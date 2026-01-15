import { Request, Response, NextFunction } from 'express';
import { validationResult } from 'express-validator';
import { validationErrorResponse } from '../utils/response';
import { logger } from '../utils/logger';

export function validate(req: Request, res: Response, next: NextFunction) {
  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    logger.debug('Validation errors:', errors.array());

    const formattedErrors = errors.array().reduce((acc: any, error: any) => {
      if (error.path) {
        acc[error.path] = error.msg;
      }
      return acc;
    }, {});

    return validationErrorResponse(res, formattedErrors);
  }

  next();
}
