import LinkModel from '../../database/models/Link.model';
import AiOutputModel from '../../database/models/AiOutput.model';
import JobModel from '../../database/models/Job.model';
import { logger } from '../../utils/logger';
import { AppError } from '../../utils/errors';
import { getQueue, QUEUE_NAMES } from '../jobs/jobs.queue';

interface CreateLinkDto {
  url: string;
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
      // Extract title from URL
      const title = this.extractTitleFromUrl(dto.url);

      // Create link with initial data
      const link = await LinkModel.create({
        userId,
        projectId: dto.projectId || null,
        url: dto.url,
        title,
        tags: dto.tags || [],
        status: 'pending'
      });

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

      if (dto.title !== undefined) link.title = dto.title;
      if (dto.projectId !== undefined) link.projectId = dto.projectId;
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
}

const linkService = new LinkService();
export default linkService;
export { linkService };
