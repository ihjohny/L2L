import LinkModel from '../../database/models/Link.model';
import ProjectModel from '../../database/models/Project.model';
import AiOutputModel from '../../database/models/AiOutput.model';
import JobModel from '../../database/models/Job.model';
import { logger } from '../../utils/logger';
import { AppError } from '../../utils/errors';
import { getQueue, QUEUE_NAMES } from '../jobs/jobs.queue';

interface CreateLinkDto {
  url: string;
  title?: string;
  projectId?: string | null;
  tags?: string[];
}

interface UpdateLinkDto {
  title?: string;
  projectId?: string | null;
  tags?: string[];
}

class LinkService {
  async createLink(userId: string, dto: CreateLinkDto) {
    try {
      // Verify project ownership if projectId is provided
      if (dto.projectId) {
        const project = await ProjectModel.findByIdAndUser(dto.projectId, userId);
        if (!project) {
          throw new AppError('Project not found or unauthorized', 'NOT_FOUND', 404);
        }
      }

      // Use provided title or extract from URL as placeholder
      const hasUserTitle = !!dto.title;
      const title = dto.title || this.extractTitleFromUrl(dto.url);

      // Create link with initial data
      const link = await LinkModel.create({
        userId,
        projectId: dto.projectId || null,
        url: dto.url,
        title,
        userTitle: hasUserTitle,
        tags: dto.tags || [],
        status: 'pending'
      });

      if (dto.projectId) {
        // Increment project link count if link is added to a project
        await ProjectModel.incrementLinkCount(dto.projectId);
        // Mark project for AI sync
        await ProjectModel.markAiSyncRequired(dto.projectId);
      }

      // Queue AI processing job
      const job = await this.queueAiProcessingJob(userId, link._id.toString(), dto.url);

      logger.info(`Link created: ${link._id} by user ${userId}, job queued: ${job._id}`);

      return {
        ...link.toObject(),
        jobId: job._id
      };
    } catch (error: any) {
      logger.error('Error in createLink:', error);
      throw error;
    }
  }

  async getLinks(userId: string, projectId?: string | null) {
    try {
      if (projectId) {
        return LinkModel.findByProject(userId, projectId);
      }
      return LinkModel.findByUser(userId);
    } catch (error: any) {
      logger.error('Error in getLinks:', error);
      throw error;
    }
  }

  async getLink(linkId: string, includeAiOutput = true) {
    try {
      const link = await LinkModel.findById(linkId);
      if (!link) {
        throw new AppError('Link not found', 'NOT_FOUND', 404);
      }

      if (includeAiOutput && link.aiOutputId) {
        const aiOutput = await AiOutputModel.findBySource('link', linkId);
        return {
          ...link.toObject(),
          aiOutput
        };
      }

      return link;
    } catch (error: any) {
      logger.error('Error in getLink:', error);
      throw error;
    }
  }

  async updateLink(linkId: string, userId: string, dto: UpdateLinkDto) {
    try {
      const link = await LinkModel.findOne({ _id: linkId, userId, deletedAt: null });
      if (!link) {
        throw new AppError('Link not found or unauthorized', 'NOT_FOUND', 404);
      }

      // Handle project changes - update link counts for old and new projects
      if (dto.projectId !== undefined && dto.projectId !== link.projectId) {
        const oldProjectId = link.projectId;
        const newProjectId = dto.projectId;

        // Verify ownership of the new project
        if (newProjectId) {
          const project = await ProjectModel.findByIdAndUser(newProjectId, userId);
          if (!project) {
            throw new AppError('Project not found or unauthorized', 'NOT_FOUND', 404);
          }
        }

        // Update link's project
        link.projectId = newProjectId;

        // Decrement old project's link count and mark for ai sync
        if (oldProjectId) {
          await ProjectModel.decrementLinkCount(oldProjectId);
          await ProjectModel.markAiSyncRequired(oldProjectId);
        }

        // Increment new project's link count and mark for ai sync
        if (newProjectId) {
          await ProjectModel.incrementLinkCount(newProjectId);
          await ProjectModel.markAiSyncRequired(newProjectId);
        }
      }

      if (dto.title !== undefined) {
        link.title = dto.title;
        link.userTitle = true; // User explicitly set the title
      }
      if (dto.tags !== undefined) link.tags = dto.tags;

      await link.save();
      logger.info(`Link updated: ${linkId}`);
      return link;
    } catch (error: any) {
      logger.error('Error in updateLink:', error);
      throw error;
    }
  }

  async deleteLink(linkId: string, userId: string) {
    try {
      const link = await LinkModel.findOne({ _id: linkId, userId, deletedAt: null });
      if (!link) {
        throw new AppError('Link not found or unauthorized', 'NOT_FOUND', 404);
      }

      // Soft delete
      link.deletedAt = new Date();
      await link.save();

      // Decrement project link count if link was associated with a project
      if (link.projectId) {
        await ProjectModel.decrementLinkCount(link.projectId);
      }

      logger.info(`Link deleted: ${linkId}`);
    } catch (error: any) {
      logger.error('Error in deleteLink:', error);
      throw error;
    }
  }

  async markAsCompleted(linkId: string, aiOutputId: string) {
    try {
      const link = await LinkModel.findById(linkId);
      if (!link) {
        throw new AppError('Link not found', 'NOT_FOUND', 404);
      }

      link.status = 'completed';
      link.aiOutputId = aiOutputId;
      await link.save();

      logger.info(`Link marked as completed: ${linkId}`);
    } catch (error: any) {
      logger.error('Error in markAsCompleted:', error);
      throw error;
    }
  }

  async markAsFailed(linkId: string, errorMessage: string) {
    try {
      const link = await LinkModel.findById(linkId);
      if (!link) {
        throw new AppError('Link not found', 'NOT_FOUND', 404);
      }

      link.status = 'failed';
      link.statusMessage = errorMessage;
      await link.save();

      logger.info(`Link marked as failed: ${linkId}`);
    } catch (error: any) {
      logger.error('Error in markAsFailed:', error);
      throw error;
    }
  }

  private async queueAiProcessingJob(userId: string, linkId: string, url: string) {
    try {
      const queue = await getQueue(QUEUE_NAMES.PROCESS_LINK);

      const job = await JobModel.create({
        userId,
        type: 'process_link',
        sourceType: 'link',
        sourceId: linkId,
        status: 'waiting',
        data: { url, linkId }
      });

      // Add to BullMQ queue
      await queue.add('process_link', {
        userId,
        linkId,
        url
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
      logger.error('Error queueing AI processing job:', error);
      throw error;
    }
  }

  private extractTitleFromUrl(url: string): string {
    try {
      const urlObj = new URL(url);
      // Get hostname and clean it up
      const hostname = urlObj.hostname.replace('www.', '');
      const pathname = urlObj.pathname.split('/').filter(Boolean).pop() || '';

      if (pathname) {
        return decodeURIComponent(pathname.replace(/[-_]/g, ' '));
      }
      return hostname;
    } catch {
      return 'Untitled';
    }
  }

  async retryLinkProcessing(linkId: string, userId: string) {
    try {
      const link = await LinkModel.findOne({ _id: linkId, userId, deletedAt: null });
      if (!link) {
        throw new AppError('Link not found or unauthorized', 'NOT_FOUND', 404);
      }

      // Only allow retry for failed links
      if (link.status !== 'failed') {
        throw new AppError(
          'Only failed links can be retried',
          'BAD_REQUEST',
          400
        );
      }

      // Reset link status to pending
      link.status = 'pending';
      link.statusMessage = undefined;
      await link.save();

      // Queue AI processing job
      const job = await this.queueAiProcessingJob(userId, link._id.toString(), link.url);

      logger.info(`Link processing retry queued: ${link._id} by user ${userId}, job queued: ${job._id}`);

      return {
        ...link.toObject(),
        jobId: job._id
      };
    } catch (error: any) {
      logger.error('Error in retryLinkProcessing:', error);
      throw error;
    }
  }
}

const linkService = new LinkService();
export default linkService;
export { linkService };
