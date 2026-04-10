import mongoose from 'mongoose';
import ProjectModel from '../models/Project.model';
import LinkModel from '../models/Link.model';
import { logger } from '../../utils/logger';

/**
 * Migration: Backfill totalLinks field for existing projects
 *
 * This script calculates the actual link count for each project
 * and updates the totalLinks field accordingly.
 */

export async function backfillProjectLinkCount(): Promise<void> {
  try {
    logger.info('Starting backfill of project link counts...');

    // Get all projects
    const projects = await ProjectModel.find({ deletedAt: null });
    logger.info(`Found ${projects.length} projects to process`);

    let updatedCount = 0;
    let skippedCount = 0;

    for (const project of projects) {
      // Count actual links for this project
      const linkCount = await LinkModel.countDocuments({
        projectId: project._id,
        deletedAt: null
      });

      // Update project if count differs
      if (project.totalLinks !== linkCount) {
        project.totalLinks = linkCount;
        await project.save();
        updatedCount++;
        logger.info(`Updated project ${project._id}: ${linkCount} links`);
      } else {
        skippedCount++;
      }
    }

    logger.info(`Backfill complete: ${updatedCount} projects updated, ${skippedCount} projects skipped`);
  } catch (error) {
    logger.error('Error during backfill:', error);
    throw error;
  }
}

// Run if executed directly
if (require.main === module) {
  const runMigration = async () => {
    try {
      // Import and connect to database
      const Database = require('../../database/connection').default;
      const db = Database.getInstance();
      await db.connect();

      // Wait a moment for connection to stabilize
      await new Promise((resolve) => setTimeout(resolve, 500));

      await backfillProjectLinkCount();

      logger.info('Migration completed successfully');

      // Disconnect from database
      await db.disconnect();
      process.exit(0);
    } catch (error) {
      logger.error('Migration failed:', error);
      process.exit(1);
    }
  };

  runMigration();
}
