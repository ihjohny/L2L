import { Request, Response, NextFunction } from 'express';
import { projectService } from './project.service';
import { logger } from '../../utils/logger';
import { successResponse, errorResponse, createdResponse } from '../../utils/response';

interface CreateProjectBody {
  name: string;
  description?: string | null;
}

interface UpdateProjectBody {
  name?: string;
  description?: string | null;
}

class ProjectController {
  async createProject(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const dto: CreateProjectBody = req.body;
      const project = await projectService.createProject(userId, dto);

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

      const projects = await projectService.getProjects(userId);
      return successResponse(res, projects, 'Projects retrieved successfully');
    } catch (error: any) {
      logger.error('Error in getProjects controller:', error);
      next(error);
    }
  }

  async getProject(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const { projectId } = req.params;
      const { includeLinks } = req.query;
      const project = await projectService.getProject(
        projectId,
        userId,
        includeLinks === 'true'
      );

      return successResponse(res, project, 'Project retrieved successfully');
    } catch (error: any) {
      logger.error('Error in getProject controller:', error);
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
      const dto: UpdateProjectBody = req.body;

      const project = await projectService.updateProject(projectId, userId, dto);
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
      await projectService.deleteProject(projectId, userId);

      return successResponse(res, null, 'Project deleted successfully');
    } catch (error: any) {
      logger.error('Error in deleteProject controller:', error);
      next(error);
    }
  }

  async generateCourseQuiz(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const { projectId } = req.params;
      const result = await projectService.generateCourseQuiz(projectId, userId);

      return successResponse(res, result, 'Course and quiz generation started');
    } catch (error: any) {
      logger.error('Error in generateCourseQuiz controller:', error);
      next(error);
    }
  }

  async getLatestCourse(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const { projectId } = req.params;
      const course = await projectService.getLatestCourse(projectId, userId);

      return successResponse(res, course, 'Latest course retrieved successfully');
    } catch (error: any) {
      logger.error('Error in getLatestCourse controller:', error);
      next(error);
    }
  }

  async getLatestQuiz(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const { projectId } = req.params;
      const quiz = await projectService.getLatestQuiz(projectId, userId);

      return successResponse(res, quiz, 'Latest quiz retrieved successfully');
    } catch (error: any) {
      logger.error('Error in getLatestQuiz controller:', error);
      next(error);
    }
  }
}

const projectController = new ProjectController();
export default projectController;
export { projectController as Project };
