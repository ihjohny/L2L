import Project from '../../database/models/Project.model';
import Entity from '../../database/models/Entity.model';
import { logger } from '../../utils/logger';
import { AppError } from '../../utils/errors';
import { CreateProjectDto, UpdateProjectDto, CreateEntityDto, UpdateEntityDto } from '../../shared/interfaces/content.interface';
import { calculatePaginationMeta } from '../../utils/response';

class ContentService {
  // Project Methods
  async createProject(userId: string, dto: CreateProjectDto) {
    try {
      const project = await Project.create({
        ...dto,
        userId,
        entities: [],
        collaborators: [],
        tags: dto.tags || [],
        progress: {
          completionPercentage: 0,
          lastAccessed: new Date(),
          timeSpent: 0,
          entitiesCompleted: 0,
          totalEntities: 0
        },
        gamification: {
          points: 0,
          badges: [],
          achievements: []
        }
      });

      logger.info(`Project created: ${project._id} by user ${userId}`);
      return project;
    } catch (error: any) {
      logger.error('Error in createProject:', error);
      throw error;
    }
  }

  async getProjectsByUser(userId: string, page: number = 1, limit: number = 20) {
    try {
      const skip = (page - 1) * limit;
      const projects = await Project.find({ userId })
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(limit);

      const total = await Project.countDocuments({ userId });

      return {
        data: projects,
        meta: calculatePaginationMeta(total, page, limit)
      };
    } catch (error: any) {
      logger.error('Error in getProjectsByUser:', error);
      throw error;
    }
  }

  async getProjectById(projectId: string) {
    try {
      const project = await Project.findById(projectId)
        .populate('entities')
        .populate('collaborators', 'username profile.firstName profile.lastName profile.avatar');

      if (!project) {
        throw new AppError('Project not found', 'NOT_FOUND', 404);
      }
      return project;
    } catch (error: any) {
      logger.error('Error in getProjectById:', error);
      throw error;
    }
  }

  async updateProject(projectId: string, userId: string, dto: UpdateProjectDto) {
    try {
      const project = await Project.findOne({ _id: projectId, userId });
      if (!project) {
        throw new AppError('Project not found or unauthorized', 'NOT_FOUND', 404);
      }

      Object.assign(project, dto);
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
      const project = await Project.findOne({ _id: projectId, userId });
      if (!project) {
        throw new AppError('Project not found or unauthorized', 'NOT_FOUND', 404);
      }

      // Delete all entities associated with this project
      await Entity.deleteMany({ projectId });

      await Project.findByIdAndDelete(projectId);
      logger.info(`Project deleted: ${projectId}`);
    } catch (error: any) {
      logger.error('Error in deleteProject:', error);
      throw error;
    }
  }

  // Entity Methods
  async createEntity(userId: string, dto: CreateEntityDto) {
    try {
      // Verify project exists and belongs to user
      const project = await Project.findOne({ _id: dto.projectId, userId });
      if (!project) {
        throw new AppError('Project not found or unauthorized', 'NOT_FOUND', 404);
      }

      // Fetch basic metadata from URL
      const metadata = await this.fetchUrlMetadata(dto.url);

      const entity = await Entity.create({
        url: dto.url,
        title: metadata.title || 'Untitled',
        description: metadata.description || '',
        userId,
        projectId: dto.projectId,
        type: this.detectContentType(dto.url, metadata),
        status: 'pending',
        metadata: {
          ...metadata,
          difficulty: 'intermediate',
          sourceUrl: dto.url,
          language: 'en'
        },
        userInteractions: {
          isRead: false,
          isFavorite: false,
          notes: dto.notes
        }
      });

      // Add entity to project
      project.entities.push(entity._id.toString());
      project.progress.totalEntities = project.entities.length;
      await project.save();

      logger.info(`Entity created: ${entity._id} by user ${userId}`);
      return entity;
    } catch (error: any) {
      logger.error('Error in createEntity:', error);
      throw error;
    }
  }

  async getEntitiesByProject(projectId: string, page: number = 1, limit: number = 20) {
    try {
      const skip = (page - 1) * limit;
      const entities = await Entity.find({ projectId })
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(limit);

      const total = await Entity.countDocuments({ projectId });

      return {
        data: entities,
        meta: calculatePaginationMeta(total, page, limit)
      };
    } catch (error: any) {
      logger.error('Error in getEntitiesByProject:', error);
      throw error;
    }
  }

  async getEntityById(entityId: string) {
    try {
      const entity = await Entity.findById(entityId)
        .populate('projectId', 'name description')
        .populate('userId', 'username profile.firstName profile.lastName');

      if (!entity) {
        throw new AppError('Entity not found', 'NOT_FOUND', 404);
      }
      return entity;
    } catch (error: any) {
      logger.error('Error in getEntityById:', error);
      throw error;
    }
  }

  async updateEntity(entityId: string, userId: string, dto: UpdateEntityDto): Promise<any> {
    try {
      const entity = await Entity.findOne({ _id: entityId, userId });
      if (!entity) {
        throw new AppError('Entity not found or unauthorized', 'NOT_FOUND', 404);
      }

      // Update user interactions
      if (dto.notes !== undefined) {
        entity.userInteractions.notes = dto.notes;
      }
      if (dto.rating !== undefined) {
        entity.userInteractions.rating = dto.rating;
      }

      await entity.save();
      logger.info(`Entity updated: ${entityId}`);
      return entity;
    } catch (error: any) {
      logger.error('Error in updateEntity:', error);
      throw error;
    }
  }

  async deleteEntity(entityId: string, userId: string) {
    try {
      const entity = await Entity.findOne({ _id: entityId, userId });
      if (!entity) {
        throw new AppError('Entity not found or unauthorized', 'NOT_FOUND', 404);
      }

      const projectId = entity.projectId;

      // Remove entity from project
      await Project.updateOne(
        { _id: projectId },
        { $pull: { entities: entityId } }
      );

      await Entity.findByIdAndDelete(entityId);
      logger.info(`Entity deleted: ${entityId}`);
    } catch (error: any) {
      logger.error('Error in deleteEntity:', error);
      throw error;
    }
  }

  async markEntityAsRead(entityId: string, userId: string): Promise<any> {
    try {
      const entity = await Entity.findOne({ _id: entityId, userId });
      if (!entity) {
        throw new AppError('Entity not found or unauthorized', 'NOT_FOUND', 404);
      }

      await (entity as any).markAsRead();

      // Update project progress
      const project = await Project.findById(entity.projectId);
      if (project) {
        project.progress.entitiesCompleted += 1;
        await (project as any).updateProgress();
        await (project as any).addPoints(10); // Add 10 points for completing an entity
      }

      logger.info(`Entity marked as read: ${entityId}`);
      return entity;
    } catch (error: any) {
      logger.error('Error in markEntityAsRead:', error);
      throw error;
    }
  }

  async toggleEntityFavorite(entityId: string, userId: string): Promise<any> {
    try {
      const entity = await Entity.findOne({ _id: entityId, userId });
      if (!entity) {
        throw new AppError('Entity not found or unauthorized', 'NOT_FOUND', 404);
      }

      await (entity as any).toggleFavorite();
      logger.info(`Entity favorite toggled: ${entityId}`);
      return entity;
    } catch (error: any) {
      logger.error('Error in toggleEntityFavorite:', error);
      throw error;
    }
  }

  // Helper methods
  private async fetchUrlMetadata(url: string) {
    try {
      // Basic implementation - in production, use a proper scraper
      const response = await fetch(url, { method: 'HEAD' });
      const contentType = response.headers.get('content-type') || '';

      return {
        title: this.extractDomainFromUrl(url),
        description: `Content from ${this.extractDomainFromUrl(url)}`,
        type: contentType
      };
    } catch (error) {
      logger.error('Error fetching URL metadata:', error);
      return {
        title: this.extractDomainFromUrl(url),
        description: 'No description available'
      };
    }
  }

  private detectContentType(url: string, metadata: any): 'article' | 'video' | 'podcast' | 'document' | 'book' {
    if (url.includes('youtube.com') || url.includes('vimeo.com')) {
      return 'video';
    }
    if (url.includes('.pdf')) {
      return 'document';
    }
    if (url.includes('soundcloud.com') || url.includes('spotify.com')) {
      return 'podcast';
    }
    return 'article';
  }

  private extractDomainFromUrl(url: string): string {
    try {
      const urlObj = new URL(url);
      return urlObj.hostname;
    } catch {
      return 'Unknown Source';
    }
  }
}

const contentService = new ContentService();
export default contentService;
export { contentService };
