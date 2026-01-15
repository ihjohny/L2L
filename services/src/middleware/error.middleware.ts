import { Request, Response, NextFunction } from 'express';
import { logger } from '../utils/logger';
import { AppError } from '../utils/errors';
import { errorResponse } from '../utils/response';

export function errorHandler(err: Error, req: Request, res: Response, next: NextFunction) {
  logger.error('Error occurred:', {
    message: err.message,
    stack: err.stack,
    url: req.url,
    method: req.method,
    ip: req.ip
  });

  // Handle operational errors
  if (err instanceof AppError) {
    return errorResponse(
      res,
      err.type,
      err.message,
      err.statusCode,
      err.isOperational ? undefined : { stack: err.stack }
    );
  }

  // Handle Mongoose validation errors
  if (err.name === 'ValidationError') {
    return errorResponse(
      res,
      'VALIDATION_ERROR',
      'Database validation failed',
      400,
      err.message
    );
  }

  // Handle Mongoose duplicate key errors
  if (err.name === 'MongoServerError' && (err as any).code === 11000) {
    return errorResponse(
      res,
      'CONFLICT',
      'Resource already exists',
      409
    );
  }

  // Handle Mongoose cast errors (invalid ObjectId)
  if (err.name === 'CastError') {
    return errorResponse(
      res,
      'VALIDATION_ERROR',
      'Invalid ID format',
      400
    );
  }

  // Handle JWT errors
  if (err.name === 'JsonWebTokenError') {
    return errorResponse(
      res,
      'UNAUTHORIZED',
      'Invalid token',
      401
    );
  }

  if (err.name === 'TokenExpiredError') {
    return errorResponse(
      res,
      'UNAUTHORIZED',
      'Token expired',
      401
    );
  }

  // Default error response
  return errorResponse(
    res,
    'INTERNAL_SERVER_ERROR',
    process.env.NODE_ENV === 'production' ? 'An unexpected error occurred' : err.message,
    500,
    process.env.NODE_ENV === 'development' ? { stack: err.stack } : undefined
  );
}

export function notFoundHandler(req: Request, res: Response) {
  errorResponse(
    res,
    'NOT_FOUND',
    `Route ${req.method} ${req.url} not found`,
    404
  );
}
