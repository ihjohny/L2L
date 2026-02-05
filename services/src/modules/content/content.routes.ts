import { Router } from 'express';
import { Content } from './content.controller';
import { validationRules } from '../../utils/validators';
import { authenticate } from '../../middleware/auth.middleware';
import { validate } from '../../middleware/validation.middleware';

const router = Router();

// Entity Routes
router.post('/entities', authenticate, validationRules.content.createEntity, validate, Content.createEntity);
router.get('/entities', authenticate, Content.getEntities);
router.get('/entities/:entityId', Content.getEntityById);
router.put('/entities/:entityId', authenticate, validationRules.content.updateEntity, validate, Content.updateEntity);
router.delete('/entities/:entityId', authenticate, Content.deleteEntity);
router.post('/entities/:entityId/read', authenticate, Content.markAsRead);
router.post('/entities/:entityId/favorite', authenticate, Content.toggleFavorite);
router.post('/entities/:entityId/reprocess', authenticate, Content.reprocessEntity);
router.put('/entities/:entityId/tags', authenticate, Content.updateEntityTags);

export default router;
