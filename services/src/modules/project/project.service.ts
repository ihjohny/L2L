import ProjectModel from '../../database/models/Project.model';
import LinkModel from '../../database/models/Link.model';
import AiOutputModel from '../../database/models/AiOutput.model';
import JobModel from '../../database/models/Job.model';
import { logger } from '../../utils/logger';
import { AppError } from '../../utils/errors';
import { getQueue, QUEUE_NAMES } from '../jobs/jobs.queue';
import { config } from '../../config';

interface CreateProjectDto {
  name: string;
  description?: string | null;
}

interface UpdateProjectDto {
  name?: string;
  description?: string | null;
}

class ProjectService {
  async createProject(userId: string, dto: CreateProjectDto) {
    try {
      const project = await ProjectModel.create({
        userId,
        name: dto.name,
        description: dto.description || null
      });

      logger.info(`Project created: ${project._id} by user ${userId}`);
      return project;
    } catch (error: any) {
      logger.error('Error in createProject:', error);
      throw error;
    }
  }

  async getProjects(userId: string) {
    try {
      return ProjectModel.findByUser(userId);
    } catch (error: any) {
      logger.error('Error in getProjects:', error);
      throw error;
    }
  }

  async getProject(projectId: string, userId: string) {
    try {
      const project = await ProjectModel.findByIdAndUser(projectId, userId);
      if (!project) {
        throw new AppError('Project not found or unauthorized', 'NOT_FOUND', 404);
      }

      return project;
    } catch (error: any) {
      logger.error('Error in getProject:', error);
      throw error;
    }
  }

  async updateProject(projectId: string, userId: string, dto: UpdateProjectDto) {
    try {
      const project = await ProjectModel.findByIdAndUser(projectId, userId);
      if (!project) {
        throw new AppError('Project not found or unauthorized', 'NOT_FOUND', 404);
      }

      if (dto.name !== undefined) project.name = dto.name;
      if (dto.description !== undefined) project.description = dto.description;

      await project.save();
      logger.info(`Project updated: ${projectId}`);
      return project;
    } catch (error: any) {
      logger.error('Error in updateProject:', error);
      throw error;
    }
  }

  async deleteProject(projectId: string, userId: string) {
    try {
      const project = await ProjectModel.findByIdAndUser(projectId, userId);
      if (!project) {
        throw new AppError('Project not found or unauthorized', 'NOT_FOUND', 404);
      }

      // Soft delete
      project.deletedAt = new Date();
      await project.save();

      logger.info(`Project deleted: ${projectId}`);
    } catch (error: any) {
      logger.error('Error in deleteProject:', error);
      throw error;
    }
  }

  async deleteOldCourseAndQuiz(projectId: string) {
    try {
      const project = await ProjectModel.findById(projectId);
      if (!project) {
        throw new AppError('Project not found', 'NOT_FOUND', 404);
      }

      const deletePromises: Promise<any>[] = [];

      // Delete old course if exists
      if (project.aiOutput?.courseId) {
        deletePromises.push(AiOutputModel.findByIdAndDelete(project.aiOutput.courseId));
        logger.info(`Deleting old course: ${project.aiOutput.courseId}`);
      }

      // Delete old quiz if exists
      if (project.aiOutput?.quizId) {
        deletePromises.push(AiOutputModel.findByIdAndDelete(project.aiOutput.quizId));
        logger.info(`Deleting old quiz: ${project.aiOutput.quizId}`);
      }

      await Promise.all(deletePromises);

      // Clear the references
      await ProjectModel.clearAiOutput(projectId);

      logger.info(`Old course and quiz deleted for project: ${projectId}`);
    } catch (error: any) {
      logger.error('Error in deleteOldCourseAndQuiz:', error);
      throw error;
    }
  }

  async generateCourseQuiz(projectId: string, userId: string) {
    try {
      // Verify project ownership
      const project = await ProjectModel.findByIdAndUser(projectId, userId);
      if (!project) {
        throw new AppError('Project not found or unauthorized', 'NOT_FOUND', 404);
      }

      // Get all links for this project
      const links = await LinkModel.findByProject(userId, projectId);

      // Check if there are completed links with summaries
      const completedLinks = links.filter(link => link.status === 'completed');
      if (completedLinks.length === 0) {
        throw new AppError('No completed links found in this project', 'BAD_REQUEST', 400);
      }

      // Queue course generation job
      const job = await this.queueCourseGenerationJob(userId, projectId);

      logger.info(`Course generation queued for project: ${projectId}, job: ${job._id}`);

      return {
        projectId,
        jobId: job._id,
        status: 'queued'
      };
    } catch (error: any) {
      logger.error('Error in generateCourseQuiz:', error);
      throw error;
    }
  }

  async getCourse(projectId: string, userId: string) {
    try {
      // Verify project ownership
      const project = await ProjectModel.findByIdAndUser(projectId, userId);
      if (!project) {
        throw new AppError('Project not found or unauthorized', 'NOT_FOUND', 404);
      }

      if (!project.aiOutput?.courseId) {
        throw new AppError('No course found for this project', 'NOT_FOUND', 404);
      }

      // Get course by ID
      const course = await AiOutputModel.findById(project.aiOutput.courseId);

      if (!course) {
        throw new AppError('Course not found', 'NOT_FOUND', 404);
      }

      return course;
    } catch (error: any) {
      logger.error('Error in getCourse:', error);
      throw error;
    }
  }

  async getQuiz(projectId: string, userId: string) {
    try {
      // Verify project ownership
      const project = await ProjectModel.findByIdAndUser(projectId, userId);
      if (!project) {
        throw new AppError('Project not found or unauthorized', 'NOT_FOUND', 404);
      }

      if (!project.aiOutput?.quizId) {
        throw new AppError('No quiz found for this project', 'NOT_FOUND', 404);
      }

      // Get quiz by ID
      const quiz = await AiOutputModel.findById(project.aiOutput.quizId);

      if (!quiz) {
        throw new AppError('Quiz not found', 'NOT_FOUND', 404);
      }

      return quiz;
    } catch (error: any) {
      logger.error('Error in getQuiz:', error);
      throw error;
    }
  }

  async getGenerationStatus(projectId: string, userId: string) {
    try {
      // Verify project ownership
      const project = await ProjectModel.findByIdAndUser(projectId, userId);
      if (!project) {
        throw new AppError('Project not found or unauthorized', 'NOT_FOUND', 404);
      }

      // Find the most recent generate_course job for this project
      const job = await JobModel.findOne({
        type: 'generate_course',
        sourceType: 'project',
        sourceId: projectId
      }).sort({ createdAt: -1 });

      if (!job) {
        return null;
      }

      return {
        jobId: job._id,
        status: job.status,
        progress: job.progress,
        failedReason: job.failedReason,
        createdAt: job.createdAt,
        updatedAt: job.updatedAt
      };
    } catch (error: any) {
      logger.error('Error in getGenerationStatus:', error);
      throw error;
    }
  }

  private async queueCourseGenerationJob(userId: string, projectId: string) {
    try {
      const queue = await getQueue(QUEUE_NAMES.GENERATE_COURSE);

      const job = await JobModel.create({
        userId,
        type: 'generate_course',
        sourceType: 'project',
        sourceId: projectId,
        status: 'waiting',
        data: { projectId }
      });

      // Add to BullMQ queue
      await queue.add('generate_course', {
        userId,
        projectId
      }, {
        jobId: job._id.toString(),
        attempts: config.jobs.attempts,
        backoff: {
          type: config.jobs.backoff.type,
          delay: config.jobs.backoff.delay
        },
        removeOnComplete: 100
      });

      return job;
    } catch (error: any) {
      logger.error('Error queueing course generation job:', error);
      throw error;
    }
  }

  async updateAiOutput(projectId: string, courseId: string, quizId: string) {
    try {
      const project = await ProjectModel.findById(projectId);
      if (!project) {
        throw new AppError('Project not found', 'NOT_FOUND', 404);
      }

      // Use the static method to update both IDs
      await ProjectModel.updateAiOutput(projectId, courseId, quizId);

      logger.info(`Project AI output updated: ${projectId}`);
      return await ProjectModel.findById(projectId);
    } catch (error: any) {
      logger.error('Error in updateAiOutput:', error);
      throw error;
    }
  }
}

const projectService = new ProjectService();
export default projectService;
export { projectService };
