import { Router } from 'express';
import { Project } from './project.controller';
import { authenticate } from '../../middleware/auth.middleware';

const router = Router();

/**
 * @route   POST /api/projects
 * @desc    Create a new project
 * @access  Private
 */
router.post('/', authenticate, Project.createProject);

/**
 * @route   GET /api/projects
 * @desc    Get all projects for user
 * @access  Private
 */
router.get('/', authenticate, Project.getProjects);

/**
 * @route   GET /api/projects/:projectId
 * @desc    Get single project with optional links
 * @access  Private
 */
router.get('/:projectId', authenticate, Project.getProject);

/**
 * @route   PUT /api/projects/:projectId
 * @desc    Update project
 * @access  Private
 */
router.put('/:projectId', authenticate, Project.updateProject);

/**
 * @route   DELETE /api/projects/:projectId
 * @desc    Delete project
 * @access  Private
 */
router.delete('/:projectId', authenticate, Project.deleteProject);

/**
 * @route   POST /api/projects/:projectId/generate-course
 * @desc    Generate AI course from project links
 * @access  Private
 */
router.post('/:projectId/generate-course', authenticate, Project.generateCourse);

export default router;
