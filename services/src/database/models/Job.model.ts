import mongoose, { Schema, Document, Model } from 'mongoose';
import { Job } from '../../shared/interfaces/job.interface';

interface JobDocument extends Omit<Job, '_id'>, Document {}

const jobSchema = new Schema(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true
    },
    type: {
      type: String,
      enum: ['process_link', 'generate_course'],
      required: true,
      index: true
    },
    sourceType: {
      type: String,
      enum: ['link', 'project'],
      required: true,
      index: true
    },
    sourceId: {
      type: Schema.Types.ObjectId,
      required: true,
      index: true
    },
    status: {
      type: String,
      enum: ['waiting', 'active', 'completed', 'failed', 'delayed'],
      required: true,
      default: 'waiting',
      index: true
    },
    attempts: {
      type: Number,
      default: 0
    },
    maxAttempts: {
      type: Number,
      default: 3
    },
    progress: {
      type: Number,
      default: 0,
      min: 0,
      max: 100
    },
    data: {
      type: Schema.Types.Mixed,
      default: {}
    },
    failedReason: {
      type: String,
      default: null
    },
    processedAt: {
      type: Date,
      default: null
    }
  },
  {
    timestamps: true
  }
);

// Indexes
jobSchema.index({ userId: 1, status: 1, createdAt: -1 });
jobSchema.index({ status: 1, createdAt: 1 });
jobSchema.index({ createdAt: 1 }, { expireAfterSeconds: 7 * 24 * 60 * 60 }); // TTL: 7 days

// Static methods
jobSchema.statics.findByUser = function (userId: string) {
  return this.find({ userId }).sort({ createdAt: -1 });
};

jobSchema.statics.findPendingByType = function (type: string) {
  return this.find({ type, status: 'waiting' }).limit(10);
};

jobSchema.statics.findFailed = function () {
  return this.find({ status: 'failed' }).sort({ updatedAt: 1 }).limit(10);
};

interface JobModel extends Model<JobDocument> {
  findByUser(userId: string): Promise<JobDocument[]>;
  findPendingByType(type: string): Promise<JobDocument[]>;
  findFailed(): Promise<JobDocument[]>;
}

const JobModel = mongoose.model<JobDocument, JobModel>('Job', jobSchema);

export default JobModel;
