import { Queue, Worker, Job } from 'bullmq';
import { logger } from '../../utils/logger';
import { config } from '../../config';
import { aiService } from '../ai/ai.service';
import { projectService } from '../project/project.service';
import LinkModel from '../../database/models/Link.model';
import ProjectModel from '../../database/models/Project.model';
import AiOutputModel from '../../database/models/AiOutput.model';
import ExtractedContentModel from '../../database/models/ExtractedContent.model';
import JobModel from '../../database/models/Job.model';
import { extractorService } from '../extractor';

// Queue name constants
export const QUEUE_NAMES = {
  PROCESS_LINK: 'l2l_process_link',
  GENERATE_COURSE: 'l2l_generate_course'
} as const;

// Connection options
const connectionOptions = {
  host: config.redis.url.replace('redis://', '').split(':')[0],
  port: parseInt(config.redis.url.replace('redis://', '').split(':')[1] || '6379')
};

// Cache for queues
const queues: Map<string, Queue> = new Map();

/**
 * Get or create a queue by name
 */
export async function getQueue(name: string): Promise<Queue> {
  if (!queues.has(name)) {
    const queue = new Queue(name, { connection: connectionOptions });
    queues.set(name, queue);
    logger.info(`Queue created: ${name}`);
  }
  return queues.get(name)!;
}

/**
 * Initialize all queues and workers
 */
export async function initializeQueues(): Promise<void> {
  try {
    // Create queues
    const processLinkQueue = await getQueue(QUEUE_NAMES.PROCESS_LINK);
    const generateCourseQueue = await getQueue(QUEUE_NAMES.GENERATE_COURSE);

    // Create workers
    createProcessLinkWorker();
    createGenerateCourseWorker();

    logger.info('Queues and workers initialized');
  } catch (error: any) {
    logger.error('Error initializing queues:', error);
    throw error;
  }
}

/**
 * Process Link Worker
 */
function createProcessLinkWorker(): void {
  const worker = new Worker(
    QUEUE_NAMES.PROCESS_LINK,
    async (job: Job) => {
      const { userId, linkId, url } = job.data;

      logger.info(`Processing link: ${linkId} (job: ${job.id})`);

      try {
        // Update job status
        await JobModel.findByIdAndUpdate(job.id, {
          status: 'active',
          attempts: job.attemptsMade
        });

        // Update link status
        await LinkModel.findByIdAndUpdate(linkId, { status: 'processing' });
        await JobModel.findByIdAndUpdate(job.id, { progress: 10 });

        // Step 1: Check/Fetch Extracted Content
        let extractedContent = await ExtractedContentModel.findByLink(linkId);
        if (!extractedContent) {
          logger.info(`Extracting content for link: ${linkId} (${url})`);
          const fetchResult = await extractorService.fetchContentWithMetadata(url);
          
          const validation = extractorService.validateContent(fetchResult.mainContent);
          if (!validation.valid) {
            throw new Error(validation.reason);
          }

          extractedContent = await ExtractedContentModel.create({
            linkId,
            url,
            fetchedAt: fetchResult.fetchedAt,
            title: fetchResult.title,
            description: fetchResult.description,
            mainContent: fetchResult.mainContent,
            contentLength: fetchResult.contentLength
          });

          // Auto-fill link title from extracted content if user hasn't set one
          const link = await LinkModel.findById(linkId);
          if (link && !link.userTitle && extractedContent.title) {
            link.title = extractedContent.title;
            await link.save();
            logger.info(`Auto-filled link title from extracted content: "${extractedContent.title}"`);
          }
        }

        await JobModel.findByIdAndUpdate(job.id, { progress: 33 });

        // Step 2: Check/Generate Summary
        let summaryOutput = await AiOutputModel.findSummaryByLink(linkId);
        if (!summaryOutput) {
          logger.info(`Generating summary for link: ${linkId}`);
          const summary = await aiService.generateSummary(extractedContent.mainContent);
          summaryOutput = await AiOutputModel.create({
            sourceType: 'link',
            sourceId: linkId,
            type: 'summary',
            content: summary,
            tokenUsage: { inputTokens: 0, outputTokens: 0, totalTokens: 0 }
          });
        }

        await JobModel.findByIdAndUpdate(job.id, { progress: 66 });

        // Step 3: Check/Generate Flashcards
        let flashcardsOutput = await AiOutputModel.findFlashcardsByLink(linkId);
        if (!flashcardsOutput) {
          logger.info(`Generating flashcards for link: ${linkId}`);
          const flashcards = await aiService.generateFlashcards(extractedContent.mainContent);
          flashcardsOutput = await AiOutputModel.create({
            sourceType: 'link',
            sourceId: linkId,
            type: 'flashcards',
            content: flashcards,
            tokenUsage: { inputTokens: 0, outputTokens: 0, totalTokens: 0 }
          });
        }

        // Update link with AI output ID (use summary as main output)
        await LinkModel.findByIdAndUpdate(linkId, {
          status: 'completed',
          statusMessage: null,
          aiOutputId: summaryOutput._id
        });

        // Update job status
        await JobModel.findByIdAndUpdate(job.id, {
          status: 'completed',
          progress: 100,
          processedAt: new Date()
        });

        logger.info(`Link processed successfully: ${linkId}`);
      } catch (error: any) {
        logger.error(`Error processing link ${linkId}:`, error);

        // Update link status
        await LinkModel.findByIdAndUpdate(linkId, {
          status: 'failed',
          statusMessage: error.message
        });

        throw error;
      }
    },
    {
      connection: connectionOptions,
      concurrency: 5
    }
  );

  worker.on('completed', (job: Job) => {
    logger.info(`Job ${job.id} completed`);
  });

  worker.on('failed', async (job: Job | undefined, error: Error) => {
    const jobId = job?.id || 'unknown';
    logger.error(`Job ${jobId} failed:`, error);

    if (job) {
      await JobModel.findByIdAndUpdate(job.id, {
        status: 'failed',
        failedReason: error.message,
        attempts: job.attemptsMade
      });
    }
  });

  logger.info(`Process Link Worker started (concurrency: 5)`);
}

/**
 * Generate Course Worker
 */
function createGenerateCourseWorker(): void {
  const worker = new Worker(
    QUEUE_NAMES.GENERATE_COURSE,
    async (job: Job) => {
      const { userId, projectId } = job.data;

      logger.info(`Generating course for project: ${projectId} (job: ${job.id})`);

      try {
        // Update job status
        const dbJob = await JobModel.findByIdAndUpdate(job.id, {
          status: 'active',
          attempts: job.attemptsMade,
          progress: 5
        });

        const jobCreatedAt = dbJob?.createdAt || new Date(job.timestamp);

        await JobModel.findByIdAndUpdate(job.id, { progress: 10 });

        // Get all links for this project
        const links = await LinkModel.findByProject(userId, projectId);

        // Filter completed links with AI output
        const completedLinks = links.filter(link => link.status === 'completed' && link.aiOutputId);

        if (completedLinks.length === 0) {
          throw new Error('No completed links with AI output found');
        }

        // Get all summaries for these links
        const summaries = await Promise.all(
          completedLinks.map(async link => {
            const summary = await AiOutputModel.findSummaryByLink(link._id.toString());
            return summary?.content as any;
          })
        );

        const validSummaries = summaries.filter(s => s !== null && s !== undefined);

        await JobModel.findByIdAndUpdate(job.id, { progress: 30 });

        // Step 1: Check/Generate Course
        let courseOutput = await AiOutputModel.findLatestCourseByProject(projectId);
        const isCourseFresh = courseOutput && courseOutput.createdAt && courseOutput.createdAt >= jobCreatedAt;

        if (!courseOutput || !isCourseFresh) {
          logger.info(`Generating course for project: ${projectId}`);
          const courseContent = await aiService.generateCourse(validSummaries);
          courseOutput = await AiOutputModel.create({
            sourceType: 'project',
            sourceId: projectId,
            type: 'course',
            content: courseContent,
            tokenUsage: { inputTokens: 0, outputTokens: 0, totalTokens: 0 }
          });
        } else {
          logger.info(`Fresh course already exists for project: ${projectId}, skipping generation`);
        }

        await JobModel.findByIdAndUpdate(job.id, { progress: 70 });

        // Step 2: Check/Generate Quiz
        let quizOutput = await AiOutputModel.findLatestQuizByProject(projectId);
        const isQuizFresh = quizOutput && quizOutput.createdAt && quizOutput.createdAt >= jobCreatedAt;

        if (!quizOutput || !isQuizFresh) {
          logger.info(`Generating quiz for project: ${projectId}`);
          const courseContent = courseOutput.content as any;
          const quizContent = await aiService.generateQuiz(courseContent, courseOutput._id);
          quizOutput = await AiOutputModel.create({
            sourceType: 'project',
            sourceId: projectId,
            type: 'quiz',
            content: quizContent,
            tokenUsage: { inputTokens: 0, outputTokens: 0, totalTokens: 0 }
          });
        } else {
          logger.info(`Fresh quiz already exists for project: ${projectId}, skipping generation`);
        }

        await JobModel.findByIdAndUpdate(job.id, { progress: 85 });

        // Delete old course and quiz AFTER new ones are safely stored
        const project = await ProjectModel.findById(projectId);
        if (project && (project.aiOutput?.courseId || project.aiOutput?.quizId)) {
          // Only delete if the old IDs differ from the freshly generated ones
          const oldCourseId = project.aiOutput?.courseId?.toString();
          const oldQuizId = project.aiOutput?.quizId?.toString();
          const newCourseId = courseOutput._id.toString();
          const newQuizId = quizOutput._id.toString();
          if (oldCourseId !== newCourseId || oldQuizId !== newQuizId) {
            await projectService.deleteOldCourseAndQuiz(projectId);
          }
        }

        // Update project with course and quiz IDs
        await projectService.updateAiOutput(
          projectId,
          courseOutput._id.toString(),
          quizOutput._id.toString()
        );

        // Clear the AI sync flag
        await ProjectModel.clearAiSyncRequired(projectId);

        // Update job status
        await JobModel.findByIdAndUpdate(job.id, {
          status: 'completed',
          progress: 100,
          processedAt: new Date()
        });

        logger.info(`Course generated successfully for project: ${projectId}`);
      } catch (error: any) {
        logger.error(`Error generating course for ${projectId}:`, error);

        throw error;
      }
    },
    {
      connection: connectionOptions,
      concurrency: 3
    }
  );

  worker.on('completed', (job: Job) => {
    logger.info(`Job ${job.id} completed`);
  });

  worker.on('failed', async (job: Job | undefined, error: Error) => {
    const jobId = job?.id || 'unknown';
    logger.error(`Job ${jobId} failed:`, error);

    if (job) {
      await JobModel.findByIdAndUpdate(job.id, {
        status: 'failed',
        failedReason: error.message,
        attempts: job.attemptsMade
      });
    }
  });

  logger.info(`Generate Course Worker started (concurrency: 3)`);
}

/**
 * Close all queues (for graceful shutdown)
 */
export async function closeQueues(): Promise<void> {
  try {
    for (const [, queue] of queues) {
      await queue.close();
    }
    queues.clear();
    logger.info('All queues closed');
  } catch (error: any) {
    logger.error('Error closing queues:', error);
  }
}
