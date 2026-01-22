// import { Validator } from 'express-validator';
// import { ContentType, DifficultyLevel } from '../shared/interfaces/content.interface';

export const validationRules = {
  auth: {
    register: [
      (validator: any) => {
        return validator
          .body('email')
          .isEmail()
          .normalizeEmail()
          .withMessage('Please provide a valid email address');
      },
      (validator: any) => {
        return validator
          .body('username')
          .isLength({ min: 3, max: 30 })
          .matches(/^[a-zA-Z0-9_]+$/)
          .withMessage('Username must be 3-30 characters and contain only letters, numbers, and underscores');
      },
      (validator: any) => {
        return validator
          .body('password')
          .isLength({ min: 8 })
          .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
          .withMessage('Password must be at least 8 characters and contain uppercase, lowercase, and number');
      },
      (validator: any) => {
        return validator
          .body('firstName')
          .trim()
          .notEmpty()
          .withMessage('First name is required');
      },
      (validator: any) => {
        return validator
          .body('lastName')
          .trim()
          .notEmpty()
          .withMessage('Last name is required');
      }
    ],
    login: [
      (validator: any) => {
        return validator
          .body('email')
          .isEmail()
          .normalizeEmail()
          .withMessage('Please provide a valid email address');
      },
      (validator: any) => {
        return validator
          .body('password')
          .notEmpty()
          .withMessage('Password is required');
      }
    ]
  },

  content: {
    createTopic: [
      (validator: any) => {
        return validator
          .body('name')
          .trim()
          .isLength({ min: 1, max: 100 })
          .withMessage('Topic name must be between 1 and 100 characters');
      },
      (validator: any) => {
        return validator
          .body('description')
          .trim()
          .isLength({ min: 1, max: 500 })
          .withMessage('Description must be between 1 and 500 characters');
      },
      (validator: any) => {
        return validator
          .body('color')
          .matches(/^#[0-9A-F]{6}$/i)
          .withMessage('Color must be a valid hex color code');
      }
    ],

    createProject: [
      (validator: any) => {
        return validator
          .body('name')
          .trim()
          .isLength({ min: 1, max: 100 })
          .withMessage('Project name must be between 1 and 100 characters');
      },
      (validator: any) => {
        return validator
          .body('description')
          .trim()
          .isLength({ min: 1, max: 500 })
          .withMessage('Description must be between 1 and 500 characters');
      },
      (validator: any) => {
        return validator
          .body('topicId')
          .isMongoId()
          .withMessage('Invalid topic ID');
      },
      (validator: any) => {
        return validator
          .body('difficulty')
          .optional()
          .isIn(['beginner', 'intermediate', 'advanced', 'expert'])
          .withMessage('Invalid difficulty level');
      }
    ],

    createEntity: [
      (validator: any) => {
        return validator
          .body('url')
          .isURL()
          .withMessage('Please provide a valid URL');
      },
      (validator: any) => {
        return validator
          .body('projectId')
          .isMongoId()
          .withMessage('Invalid project ID');
      }
    ],

    updateEntity: [
      (validator: any) => {
        return validator
          .body('rating')
          .optional()
          .isInt({ min: 1, max: 5 })
          .withMessage('Rating must be between 1 and 5');
      }
    ]
  }
};
