import { Router } from 'express';
import { Link } from './link.controller';
import { authenticate } from '../../middleware/auth.middleware';

const router = Router();

/**
 * @route   POST /api/links
 * @desc    Create a new link (triggers AI processing)
 * @access  Private
 */
router.post('/', authenticate, Link.createLink);

/**
 * @route   GET /api/links
 * @desc    Get all links for user
 * @access  Private
 */
router.get('/', authenticate, Link.getLinks);

/**
 * @route   GET /api/links/:linkId
 * @desc    Get single link with AI output
 * @access  Private
 */
router.get('/:linkId', Link.getLink);

/**
 * @route   PUT /api/links/:linkId
 * @desc    Update link
 * @access  Private
 */
router.put('/:linkId', authenticate, Link.updateLink);

/**
 * @route   DELETE /api/links/:linkId
 * @desc    Delete link
 * @access  Private
 */
router.delete('/:linkId', authenticate, Link.deleteLink);

export default router;
