import { Request, Response, NextFunction } from 'express';
import { linkService } from './link.service';
import { logger } from '../../utils/logger';
import { successResponse, errorResponse, createdResponse } from '../../utils/response';

interface CreateLinkBody {
  url: string;
  projectId?: string | null;
  tags?: string[];
}

interface UpdateLinkBody {
  title?: string;
  projectId?: string | null;
  tags?: string[];
}

class LinkController {
  async createLink(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const dto: CreateLinkBody = req.body;
      const result = await linkService.createLink(userId, dto);

      return createdResponse(res, result, 'Link created successfully');
    } catch (error: any) {
      logger.error('Error in createLink controller:', error);
      next(error);
    }
  }

  async getLinks(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const { projectId } = req.query;
      const links = await linkService.getLinks(userId, projectId as string | undefined);

      return successResponse(res, links, 'Links retrieved successfully');
    } catch (error: any) {
      logger.error('Error in getLinks controller:', error);
      next(error);
    }
  }

  async getLink(req: Request, res: Response, next: NextFunction) {
    try {
      const { linkId } = req.params;
      const link = await linkService.getLink(linkId);

      return successResponse(res, link, 'Link retrieved successfully');
    } catch (error: any) {
      logger.error('Error in getLink controller:', error);
      next(error);
    }
  }

  async updateLink(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const { linkId } = req.params;
      const dto: UpdateLinkBody = req.body;

      const link = await linkService.updateLink(linkId, userId, dto);
      return successResponse(res, link, 'Link updated successfully');
    } catch (error: any) {
      logger.error('Error in updateLink controller:', error);
      next(error);
    }
  }

  async deleteLink(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const { linkId } = req.params;
      await linkService.deleteLink(linkId, userId);

      return successResponse(res, null, 'Link deleted successfully');
    } catch (error: any) {
      logger.error('Error in deleteLink controller:', error);
      next(error);
    }
  }
}

const linkController = new LinkController();
export default linkController;
export { linkController as Link };
