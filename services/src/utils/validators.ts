import { body, ValidationChain } from 'express-validator';

export const validationRules = {
  auth: {
    register: [
      body('email')
        .isEmail()
        .normalizeEmail()
        .withMessage('Please provide a valid email address'),
      body('username')
        .isLength({ min: 3, max: 30 })
        .withMessage('Username must be 3-30 characters')
        .matches(/^[a-zA-Z0-9_]+$/)
        .withMessage('Username must contain only letters, numbers, and underscores'),
      body('password')
        .isLength({ min: 8 })
        .withMessage('Password must be at least 8 characters')
        .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
        .withMessage('Password must contain uppercase, lowercase, and number'),
      body('firstName')
        .trim()
        .notEmpty()
        .withMessage('First name is required'),
      body('lastName')
        .trim()
        .notEmpty()
        .withMessage('Last name is required')
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
    createTopic: [
      body('name')
        .trim()
        .isLength({ min: 1, max: 100 })
        .withMessage('Topic name must be between 1 and 100 characters'),
      body('description')
        .trim()
        .isLength({ min: 1, max: 500 })
        .withMessage('Description must be between 1 and 500 characters'),
      body('color')
        .matches(/^#[0-9A-F]{6}$/i)
        .withMessage('Color must be a valid hex color code')
    ],

    createProject: [
      body('name')
        .trim()
        .isLength({ min: 1, max: 100 })
        .withMessage('Project name must be between 1 and 100 characters'),
      body('description')
        .trim()
        .isLength({ min: 1, max: 500 })
        .withMessage('Description must be between 1 and 500 characters'),
      body('topicId')
        .isMongoId()
        .withMessage('Invalid topic ID'),
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
