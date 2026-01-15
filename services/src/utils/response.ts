import { Response } from 'express';
import { ApiResponse, PaginatedResponse, PaginationMeta } from '../shared/interfaces/base.interface';

export function successResponse<T>(
  res: Response,
  data: T,
  message?: string,
  statusCode: number = 200
): Response {
  const response: ApiResponse<T> = {
    success: true,
    data,
    message
  };

  return res.status(statusCode).json(response);
}

export function errorResponse(
  res: Response,
  error: string,
  message?: string,
  statusCode: number = 500,
  details?: any
): Response {
  const response: ApiResponse = {
    success: false,
    error,
    message,
    details
  };

  return res.status(statusCode).json(response);
}

export function paginatedResponse<T>(
  res: Response,
  data: T[],
  meta: PaginationMeta,
  message?: string,
  statusCode: number = 200
): Response {
  const response: ApiResponse<T[]> = {
    success: true,
    data,
    message,
    meta
  };

  return res.status(statusCode).json(response);
}

export function createdResponse<T>(
  res: Response,
  data: T,
  message: string = 'Resource created successfully'
): Response {
  return successResponse(res, data, message, 201);
}

export function noContentResponse(res: Response): Response {
  return res.status(204).send();
}

export function unauthorizedResponse(
  res: Response,
  message: string = 'Unauthorized access'
): Response {
  return errorResponse(res, 'UNAUTHORIZED', message, 401);
}

export function forbiddenResponse(
  res: Response,
  message: string = 'Forbidden'
): Response {
  return errorResponse(res, 'FORBIDDEN', message, 403);
}

export function notFoundResponse(
  res: Response,
  message: string = 'Resource not found'
): Response {
  return errorResponse(res, 'NOT_FOUND', message, 404);
}

export function validationErrorResponse(
  res: Response,
  errors: any,
  message: string = 'Validation failed'
): Response {
  return errorResponse(res, 'VALIDATION_ERROR', message, 400, errors);
}

export function conflictResponse(
  res: Response,
  message: string = 'Resource conflict'
): Response {
  return errorResponse(res, 'CONFLICT', message, 409);
}

export function calculatePaginationMeta(
  total: number,
  page: number,
  limit: number
): PaginationMeta {
  const totalPages = Math.ceil(total / limit);

  return {
    page,
    limit,
    total,
    totalPages,
    hasNext: page < totalPages,
    hasPrev: page > 1
  };
}
