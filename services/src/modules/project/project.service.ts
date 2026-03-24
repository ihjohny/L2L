import ProjectModel from '../../database/models/Project.model';
import LinkModel from '../../database/models/Link.model';
import AiOutputModel from '../../database/models/AiOutput.model';
import JobModel from '../../database/models/Job.model';
import { logger } from '../../utils/logger';
import { AppError } from '../../utils/errors';
import { getQueue, QUEUE_NAMES } from '../jobs/jobs.queue';

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

  async getProject(projectId: string, userId: string, includeLinks = false) {
    try {
      const project = await ProjectModel.findByIdAndUser(projectId, userId);
      if (!project) {
        throw new AppError('Project not found or unauthorized', 'NOT_FOUND', 404);
      }

      if (includeLinks) {
        const links = await LinkModel.findByProject(userId, projectId);
        return {
          ...project.toObject(),
          links
        };
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

  async generateCourse(projectId: string, userId: string) {
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
      logger.error('Error in generateCourse:', error);
      throw error;
    }
  }

  async markCourseCompleted(projectId: string, aiOutputId: string) {
    try {
      const project = await ProjectModel.findById(projectId);
      if (!project) {
        throw new AppError('Project not found', 'NOT_FOUND', 404);
      }

      project.aiOutputId = aiOutputId;
      await project.save();

      logger.info(`Project course completed: ${projectId}`);
    } catch (error: any) {
      logger.error('Error in markCourseCompleted:', error);
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
        attempts: 3,
        backoff: {
          type: 'exponential',
          delay: 2000
        },
        removeOnComplete: 100
      });

      return job;
    } catch (error: any) {
      logger.error('Error queueing course generation job:', error);
      throw error;
    }
  }
}

const projectService = new ProjectService();
export default projectService;
export { projectService };
