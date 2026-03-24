import mongoose, { Schema, Document, Model } from 'mongoose';
import { BaseEntity } from '../../shared/interfaces/base.interface';

export interface Project extends BaseEntity {
  userId: string;
  name: string;
  description?: string | null;
  aiOutputId?: string | null;
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
    aiOutputId: {
      type: Schema.Types.ObjectId,
      ref: 'AiOutput',
      default: null
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

interface ProjectModel extends Model<ProjectDocument> {
  findByUser(userId: string): Promise<ProjectDocument[]>;
  findByIdAndUser(id: string, userId: string): Promise<ProjectDocument | null>;
}

const ProjectModel = mongoose.model<ProjectDocument, ProjectModel>('Project', projectSchema);

export default ProjectModel;
