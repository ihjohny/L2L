import { Request, Response, NextFunction } from 'express';
import { validationResult } from 'express-validator';
import { contentService } from './content.service';
import { logger } from '../../utils/logger';
import { successResponse, errorResponse, createdResponse, paginatedResponse } from '../../utils/response';
import { CreateProjectDto, UpdateProjectDto, CreateEntityDto, UpdateEntityDto } from '../../shared/interfaces/content.interface';

class ContentController {
  // Project Controllers
  async createProject(req: Request, res: Response, next: NextFunction) {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return errorResponse(res, 'VALIDATION_ERROR', 'Validation failed', 400, errors.array());
      }

      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const dto: CreateProjectDto = req.body;
      const project = await contentService.createProject(userId, dto);

      return createdResponse(res, project, 'Project created successfully');
    } catch (error: any) {
      logger.error('Error in createProject controller:', error);
      next(error);
    }
  }

  async getProjects(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 20;

      const result = await contentService.getProjectsByUser(userId, page, limit);
      return paginatedResponse(res, result.data, result.meta, 'Projects retrieved successfully');
    } catch (error: any) {
      logger.error('Error in getProjects controller:', error);
      next(error);
    }
  }

  async getProjectById(req: Request, res: Response, next: NextFunction) {
    try {
      const { projectId } = req.params;
      const project = await contentService.getProjectById(projectId);

      return successResponse(res, project, 'Project retrieved successfully');
    } catch (error: any) {
      logger.error('Error in getProjectById controller:', error);
      next(error);
    }
  }

  async updateProject(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const { projectId } = req.params;
      const dto: UpdateProjectDto = req.body;

      const project = await contentService.updateProject(projectId, userId, dto);
      return successResponse(res, project, 'Project updated successfully');
    } catch (error: any) {
      logger.error('Error in updateProject controller:', error);
      next(error);
    }
  }

  async deleteProject(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const { projectId } = req.params;
      await contentService.deleteProject(projectId, userId);

      return successResponse(res, null, 'Project deleted successfully');
    } catch (error: any) {
      logger.error('Error in deleteProject controller:', error);
      next(error);
    }
  }

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
      const { projectId } = req.params;
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 20;

      const result = await contentService.getEntitiesByProject(projectId, page, limit);
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
}

const contentController = new ContentController();
export default contentController;
export { contentController as Content };
