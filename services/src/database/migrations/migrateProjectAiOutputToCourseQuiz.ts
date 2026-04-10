import ProjectModel from '../models/Project.model';
import AiOutputModel from '../models/AiOutput.model';
import { logger } from '../../utils/logger';

/**
 * Migration: Migrate projects from aiOutputId to aiOutput object with courseId and quizId
 *
 * This script updates projects that have an aiOutputId to use a new aiOutput object
 * containing separate courseId and quizId fields.
 * It finds the latest course and quiz for each project and updates the project accordingly.
 */

export async function migrateProjectAiOutputToCourseQuiz(): Promise<void> {
  try {
    logger.info('Starting migration of project AI output to aiOutput object...');

    // Get all projects that have aiOutputId
    const projects = await ProjectModel.find({
      aiOutputId: { $exists: true, $ne: null },
      deletedAt: null
    });
    logger.info(`Found ${projects.length} projects to migrate`);

    let updatedCount = 0;
    let skippedCount = 0;
    let errorCount = 0;

    for (const project of projects) {
      try {
        // Get the latest course for this project
        const course = await AiOutputModel.findLatestCourseByProject(project._id.toString());
        // Get the latest quiz for this project
        const quiz = await AiOutputModel.findLatestQuizByProject(project._id.toString());

        if (!course && !quiz) {
          logger.info(`No course or quiz found for project ${project._id}, skipping`);
          skippedCount++;
          continue;
        }

        // Build aiOutput object
        const aiOutputData: any = {};
        if (course) {
          aiOutputData.courseId = course._id;
        }
        if (quiz) {
          aiOutputData.quizId = quiz._id;
        }

        // Update project with aiOutput object and remove old field
        await ProjectModel.findByIdAndUpdate(project._id, {
          aiOutput: aiOutputData,
          $unset: { aiOutputId: '' }
        });
        updatedCount++;
        logger.info(`Migrated project ${project._id}: courseId=${course?._id}, quizId=${quiz?._id}`);
      } catch (error: any) {
        logger.error(`Error migrating project ${project._id}:`, error);
        errorCount++;
      }
    }

    logger.info(`Migration complete: ${updatedCount} projects updated, ${skippedCount} skipped, ${errorCount} errors`);
  } catch (error) {
    logger.error('Error during migration:', error);
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

      await migrateProjectAiOutputToCourseQuiz();

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
