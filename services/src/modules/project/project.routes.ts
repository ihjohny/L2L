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
 * @route   POST /api/projects/:projectId/generate-course-quiz
 * @desc    Generate AI course and quiz from project links
 * @access  Private
 */
router.post('/:projectId/generate-course-quiz', authenticate, Project.generateCourseQuiz);

/**
 * @route   GET /api/projects/:projectId/course
 * @desc    Get latest created course for a project
 * @access  Private
 */
router.get('/:projectId/course', authenticate, Project.getLatestCourse);

/**
 * @route   GET /api/projects/:projectId/quiz
 * @desc    Get latest created quiz for a project
 * @access  Private
 */
router.get('/:projectId/quiz', authenticate, Project.getLatestQuiz);

/**
 * @route   GET /api/projects/:projectId/stats
 * @desc    Get project statistics including link count and course status
 * @access  Private
 */
router.get('/:projectId/stats', authenticate, Project.getProjectStats);

/**
 * @route   POST /api/projects/:projectId/sync-course
 * @desc    Sync/regenerate course when new links are added
 * @access  Private
 */
router.post('/:projectId/sync-course', authenticate, Project.syncCourse);

export default router;
