import { Request, Response, NextFunction } from 'express';
import { verifyAccessToken } from '../utils/jwt';
import { logger } from '../utils/logger';
import { errorResponse, unauthorizedResponse } from '../utils/response';
import User from '../database/models/User.model';

// Extend Express Request type
declare global {
  namespace Express {
    interface Request {
      user?: {
        sub: string;
        email: string;
        tier: 'free' | 'premium' | 'enterprise';
        permissions: string[];
      };
    }
  }
}

export async function authenticate(req: Request, res: Response, next: NextFunction) {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return unauthorizedResponse(res, 'No token provided');
    }

    const token = authHeader.substring(7);

    try {
      const payload = verifyAccessToken(token);

      // Verify user still exists
      const user = await User.findById(payload.sub);
      if (!user) {
        return unauthorizedResponse(res, 'User not found');
      }

      // Attach user info to request
      req.user = {
        sub: payload.sub,
        email: payload.email,
        tier: payload.tier,
        permissions: payload.permissions
      };

      next();
    } catch (error: any) {
      logger.error('Token verification failed:', error);
      return unauthorizedResponse(res, 'Invalid or expired token');
    }
  } catch (error) {
    logger.error('Authentication error:', error);
    return unauthorizedResponse(res, 'Authentication failed');
  }
}

export function authorize(...requiredPermissions: string[]) {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.user) {
      return unauthorizedResponse(res, 'User not authenticated');
    }

    const userPermissions = req.user.permissions || [];

    const hasPermission = requiredPermissions.every(permission =>
      userPermissions.includes(permission)
    );

    if (!hasPermission) {
      return errorResponse(
        res,
        'FORBIDDEN',
        'Insufficient permissions',
        403
      );
    }

    next();
  };
}

export function requireTier(...allowedTiers: ('free' | 'premium' | 'enterprise')[]) {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.user) {
      return unauthorizedResponse(res, 'User not authenticated');
    }

    if (!allowedTiers.includes(req.user.tier)) {
      return errorResponse(
        res,
        'FORBIDDEN',
        'This feature requires a higher subscription tier',
        403
      );
    }

    next();
  };
}

// Optional authentication - doesn't fail if no token
export async function optionalAuth(req: Request, res: Response, next: NextFunction) {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return next();
    }

    const token = authHeader.substring(7);

    try {
      const payload = verifyAccessToken(token);
      const user = await User.findById(payload.sub);

      if (user) {
        req.user = {
          sub: payload.sub,
          email: payload.email,
          tier: payload.tier,
          permissions: payload.permissions
        };
      }
    } catch (error) {
      // Ignore token verification errors for optional auth
      logger.debug('Optional auth token verification failed:', error);
    }

    next();
  } catch (error) {
    logger.debug('Optional authentication error:', error);
    next();
  }
}
