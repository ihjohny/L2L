import mongoose, { Schema, Document, Model } from 'mongoose';
import { BaseEntity } from '../../shared/interfaces/base.interface';

export type LinkStatus = 'pending' | 'processing' | 'completed' | 'failed';

export interface Link extends BaseEntity {
  userId: string;
  projectId?: string | null;
  url: string;
  title: string | null;
  userTitle: boolean;
  aiOutputId?: string | null;
  tags: string[];
  status: LinkStatus;
  statusMessage?: string | null;
  deletedAt?: Date | null;
}

export interface CreateLinkDto {
  url: string;
  title?: string;
  projectId?: string;
  tags?: string[];
}

export interface UpdateLinkDto {
  title?: string;
  userTitle?: boolean;
  tags?: string[];
  status?: LinkStatus;
  statusMessage?: string;
}

interface LinkDocument extends Omit<Link, '_id'>, Document {}

const linkSchema = new Schema(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true
    },
    projectId: {
      type: Schema.Types.ObjectId,
      ref: 'Project',
      default: null,
      index: true
    },
    url: {
      type: String,
      required: true,
      trim: true
    },
    title: {
      type: String,
      default: null,
      trim: true
    },
    userTitle: {
      type: Boolean,
      default: false
    },
    aiOutputId: {
      type: Schema.Types.ObjectId,
      ref: 'AiOutput',
      default: null
    },
    tags: {
      type: [String],
      default: [],
      index: true
    },
    status: {
      type: String,
      enum: ['pending', 'processing', 'completed', 'failed'],
      required: true,
      default: 'pending',
      index: true
    },
    statusMessage: {
      type: String,
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
linkSchema.index({ userId: 1, createdAt: -1 });
linkSchema.index({ userId: 1, projectId: 1, createdAt: -1 });
linkSchema.index({ deletedAt: 1 });

// Static methods
linkSchema.statics.findByUser = function (userId: string) {
  return this.find({ userId, deletedAt: null }).sort({ createdAt: -1 });
};

linkSchema.statics.findByProject = function (userId: string, projectId: string) {
  return this.find({ userId, projectId, deletedAt: null }).sort({ createdAt: -1 });
};

linkSchema.statics.findPendingProcessing = function () {
  return this.find({ status: 'pending', deletedAt: null }).limit(10);
};

interface LinkModel extends Model<LinkDocument> {
  findByUser(userId: string): Promise<LinkDocument[]>;
  findByProject(userId: string, projectId: string): Promise<LinkDocument[]>;
  findPendingProcessing(): Promise<LinkDocument[]>;
}

const LinkModel = mongoose.model<LinkDocument, LinkModel>('Link', linkSchema);

export default LinkModel;
