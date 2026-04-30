import mongoose, { Schema, Document, Model } from 'mongoose';
import { BaseEntity } from '../../shared/interfaces/base.interface';

export interface ProjectAiOutput {
  courseId?: string | null;
  quizId?: string | null;
}

export interface Project extends BaseEntity {
  userId: string;
  name: string;
  description?: string | null;
  aiOutput?: ProjectAiOutput | null;
  syncAiOutput?: {
    course: boolean;
    quiz: boolean;
  };
  totalLinks: number;
  deletedAt?: Date | null;
}

export interface CreateProjectDto {
  name: string;
  description?: string;
}

export interface UpdateProjectDto {
  name?: string;
  description?: string;
}

interface ProjectDocument extends Omit<Project, '_id'>, Document {}

const projectSchema = new Schema(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true
    },
    name: {
      type: String,
      required: true,
      trim: true
    },
    description: {
      type: String,
      default: null,
      trim: true
    },
    aiOutput: {
      courseId: {
        type: Schema.Types.ObjectId,
        ref: 'AiOutput',
        default: null
      },
      quizId: {
        type: Schema.Types.ObjectId,
        ref: 'AiOutput',
        default: null
      }
    },
    syncAiOutput: {
      course: {
        type: Boolean,
        default: false
      },
      quiz: {
        type: Boolean,
        default: false
      }
    },
    totalLinks: {
      type: Number,
      default: 0,
      min: 0
    },
    deletedAt: {
      type: Date,
      default: null,
      index: true
    }
  },
  {
    timestamps: true,
    toJSON: { virtuals: true },
    toObject: { virtuals: true }
  }
);

// Indexes
projectSchema.index({ userId: 1, createdAt: -1 });
projectSchema.index({ deletedAt: 1 });

// Static methods
projectSchema.statics.findByUser = function (userId: string) {
  return this.find({ userId, deletedAt: null }).sort({ createdAt: -1 });
};

projectSchema.statics.findByIdAndUser = function (id: string, userId: string) {
  return this.findOne({ _id: id, userId, deletedAt: null });
};

projectSchema.statics.incrementLinkCount = function (projectId: string) {
  return this.findByIdAndUpdate(
    projectId,
    { $inc: { totalLinks: 1 } },
    { new: true }
  );
};

projectSchema.statics.decrementLinkCount = function (projectId: string) {
  return this.findByIdAndUpdate(
    projectId,
    { $inc: { totalLinks: -1 } },
    { new: true }
  );
};

projectSchema.statics.updateAiOutput = function (projectId: string, courseId: string, quizId: string) {
  return this.findByIdAndUpdate(
    projectId,
    { aiOutput: { courseId, quizId } },
    { new: true, upsert: true }
  );
};

projectSchema.statics.clearAiOutput = function (projectId: string) {
  return this.findByIdAndUpdate(
    projectId,
    { $unset: { aiOutput: '' } },
    { new: true }
  );
};

projectSchema.statics.markAiSyncRequired = function (projectId: string) {
  return this.findByIdAndUpdate(
    projectId,
    { 'syncAiOutput.course': true, 'syncAiOutput.quiz': true },
    { new: true }
  );
};

projectSchema.statics.clearCourseSyncRequired = function (projectId: string) {
  return this.findByIdAndUpdate(
    projectId,
    { 'syncAiOutput.course': false },
    { new: true }
  );
};

projectSchema.statics.clearQuizSyncRequired = function (projectId: string) {
  return this.findByIdAndUpdate(
    projectId,
    { 'syncAiOutput.quiz': false },
    { new: true }
  );
};

interface ProjectModel extends Model<ProjectDocument> {
  findByUser(userId: string): Promise<ProjectDocument[]>;
  findByIdAndUser(id: string, userId: string): Promise<ProjectDocument | null>;
  incrementLinkCount(projectId: string): Promise<ProjectDocument | null>;
  decrementLinkCount(projectId: string): Promise<ProjectDocument | null>;
  updateAiOutput(projectId: string, courseId: string, quizId: string): Promise<ProjectDocument | null>;
  clearAiOutput(projectId: string): Promise<ProjectDocument | null>;
  markAiSyncRequired(projectId: string): Promise<ProjectDocument | null>;
  clearCourseSyncRequired(projectId: string): Promise<ProjectDocument | null>;
  clearQuizSyncRequired(projectId: string): Promise<ProjectDocument | null>;
}

const ProjectModel = mongoose.model<ProjectDocument, ProjectModel>('Project', projectSchema);

export default ProjectModel;
