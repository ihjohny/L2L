import { body, ValidationChain } from 'express-validator';

export const validationRules = {
  auth: {
    register: [
      body('name')
        .trim()
        .isLength({ min: 2, max: 50 })
        .withMessage('Name must be between 2 and 50 characters'),
      body('email')
        .isEmail()
        .normalizeEmail()
        .withMessage('Please provide a valid email address'),
      body('password')
        .isLength({ min: 6 })
        .withMessage('Password must be at least 6 characters')
    ],
    login: [
      body('email')
        .isEmail()
        .normalizeEmail()
        .withMessage('Please provide a valid email address'),
      body('password')
        .notEmpty()
        .withMessage('Password is required')
    ]
  },

  content: {
    createProject: [
      body('name')
        .trim()
        .isLength({ min: 1, max: 100 })
        .withMessage('Project name must be between 1 and 100 characters'),
      body('description')
        .trim()
        .isLength({ min: 1, max: 500 })
        .withMessage('Description must be between 1 and 500 characters'),
      body('difficulty')
        .optional()
        .isIn(['beginner', 'intermediate', 'advanced', 'expert'])
        .withMessage('Invalid difficulty level')
    ],

    createEntity: [
      body('url')
        .isURL()
        .withMessage('Please provide a valid URL'),
      body('projectId')
        .isMongoId()
        .withMessage('Invalid project ID')
    ],

    updateEntity: [
      body('rating')
        .optional()
        .isInt({ min: 1, max: 5 })
        .withMessage('Rating must be between 1 and 5')
    ]
  }
};
