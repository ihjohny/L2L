import { Request, Response, NextFunction } from 'express';
import { validationResult } from 'express-validator';
import { userService } from './user.service';
import { logger } from '../../utils/logger';
import { successResponse, errorResponse, createdResponse } from '../../utils/response';
import { CreateUserDto, UpdateUserDto, LoginDto } from '../../shared/interfaces/user.interface';

class UserController {
  async register(req: Request, res: Response, next: NextFunction) {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return errorResponse(res, 'VALIDATION_ERROR', 'Validation failed', 400, errors.array());
      }

      const dto: CreateUserDto = req.body;
      const result = await userService.registerUser(dto);

      return createdResponse(res, result, 'User registered successfully');
    } catch (error: any) {
      logger.error('Error in register controller:', error);
      next(error);
    }
  }

  async login(req: Request, res: Response, next: NextFunction) {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return errorResponse(res, 'VALIDATION_ERROR', 'Validation failed', 400, errors.array());
      }

      const dto: LoginDto = req.body;
      const result = await userService.loginUser(dto);

      return successResponse(res, result, 'Login successful');
    } catch (error: any) {
      logger.error('Error in login controller:', error);
      next(error);
    }
  }

  async getProfile(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const user = await userService.getUserById(userId);
      return successResponse(res, user, 'Profile retrieved successfully');
    } catch (error: any) {
      logger.error('Error in getProfile controller:', error);
      next(error);
    }
  }

  async updateProfile(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      const dto: UpdateUserDto = req.body;
      const user = await userService.updateUser(userId, dto);

      return successResponse(res, user, 'Profile updated successfully');
    } catch (error: any) {
      logger.error('Error in updateProfile controller:', error);
      next(error);
    }
  }

  async refreshToken(req: Request, res: Response, next: NextFunction) {
    try {
      const { refreshToken } = req.body;
      if (!refreshToken) {
        return errorResponse(res, 'VALIDATION_ERROR', 'Refresh token is required', 400);
      }

      const tokens = await userService.refreshAccessToken(refreshToken);
      return successResponse(res, tokens, 'Token refreshed successfully');
    } catch (error: any) {
      logger.error('Error in refreshToken controller:', error);
      next(error);
    }
  }

  async deleteAccount(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.user?.sub;
      if (!userId) {
        return errorResponse(res, 'UNAUTHORIZED', 'User not authenticated', 401);
      }

      await userService.deleteUser(userId);
      return successResponse(res, null, 'Account deleted successfully');
    } catch (error: any) {
      logger.error('Error in deleteAccount controller:', error);
      next(error);
    }
  }
}

export default new UserController();
