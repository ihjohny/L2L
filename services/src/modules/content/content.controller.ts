import { Request, Response, NextFunction } from 'express';
import { validationResult } from 'express-validator';
import { contentService } from './content.service';
import { logger } from '../../utils/logger';
import { successResponse, errorResponse, createdResponse, paginatedResponse } from '../../utils/response';
import { CreateEntityDto, UpdateEntityDto } from '../../shared/interfaces/content.interface';

class ContentController {
  // Entity Controllers
  async createEntity(req: Request, res: Response, next: NextFunction) {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return errorResponse(res, 'VALIDATION_ERROR', 'Validation failed', 400, errors.array());
      }

      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const dto: CreateEntityDto = req.body;
      const entity = await contentService.createEntity(userId, dto);

      return createdResponse(res, entity, 'Bookmark created successfully');
    } catch (error: any) {
      logger.error('Error in createEntity controller:', error);
      next(error);
    }
  }

  async getEntities(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 20;
      const tags = req.query.tags ? (req.query.tags as string).split(',') : undefined;
      const search = req.query.search as string | undefined;

      const result = await contentService.getEntitiesByUser(userId, page, limit, tags, search);
      return paginatedResponse(res, result.data, result.meta, 'Entities retrieved successfully');
    } catch (error: any) {
      logger.error('Error in getEntities controller:', error);
      next(error);
    }
  }

  async getEntityById(req: Request, res: Response, next: NextFunction) {
    try {
      const { entityId } = req.params;
      const entity = await contentService.getEntityById(entityId);

      return successResponse(res, entity, 'Entity retrieved successfully');
    } catch (error: any) {
      logger.error('Error in getEntityById controller:', error);
      next(error);
    }
  }

  async updateEntity(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const { entityId } = req.params;
      const dto: UpdateEntityDto = req.body;

      const entity = await contentService.updateEntity(entityId, userId, dto);
      return successResponse(res, entity, 'Entity updated successfully');
    } catch (error: any) {
      logger.error('Error in updateEntity controller:', error);
      next(error);
    }
  }

  async deleteEntity(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const { entityId } = req.params;
      await contentService.deleteEntity(entityId, userId);

      return successResponse(res, null, 'Entity deleted successfully');
    } catch (error: any) {
      logger.error('Error in deleteEntity controller:', error);
      next(error);
    }
  }

  async markAsRead(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const { entityId } = req.params;
      const entity = await contentService.markEntityAsRead(entityId, userId);

      return successResponse(res, entity, 'Entity marked as read');
    } catch (error: any) {
      logger.error('Error in markAsRead controller:', error);
      next(error);
    }
  }

  async toggleFavorite(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const { entityId } = req.params;
      const entity = await contentService.toggleEntityFavorite(entityId, userId);

      return successResponse(res, entity, 'Favorite status updated');
    } catch (error: any) {
      logger.error('Error in toggleFavorite controller:', error);
      next(error);
    }
  }

  async reprocessEntity(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const { entityId } = req.params;
      const entity = await contentService.reprocessEntity(entityId, userId);

      return successResponse(res, entity, 'Entity re-processed successfully');
    } catch (error: any) {
      logger.error('Error in reprocessEntity controller:', error);
      next(error);
    }
  }

  async updateEntityTags(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const { entityId } = req.params;
      const { tags } = req.body;

      if (!Array.isArray(tags)) {
        return errorResponse(res, 'VALIDATION_ERROR', 'Tags must be an array', 400);
      }

      const entity = await contentService.updateEntityTags(entityId, userId, tags);

      return successResponse(res, entity, 'Entity tags updated successfully');
    } catch (error: any) {
      logger.error('Error in updateEntityTags controller:', error);
      next(error);
    }
  }
}

const contentController = new ContentController();
export default contentController;
export { contentController as Content };
