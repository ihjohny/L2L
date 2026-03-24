import mongoose, { Schema, Document, Model } from 'mongoose';
import { AiOutput } from '../../shared/interfaces/ai-output.interface';

interface AiOutputDocument extends Omit<AiOutput, '_id'>, Document {}

const aiOutputSchema = new Schema(
  {
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
    type: {
      type: String,
      enum: ['summary', 'flashcards', 'course', 'quiz'],
      required: true,
      index: true
    },
    content: {
      type: Schema.Types.Mixed,
      required: true
    },
    tokenUsage: {
      inputTokens: { type: Number, default: 0 },
      outputTokens: { type: Number, default: 0 },
      totalTokens: { type: Number, default: 0 }
    }
  },
  {
    timestamps: true
  }
);

// Indexes
aiOutputSchema.index({ sourceType: 1, sourceId: 1, type: 1 });
aiOutputSchema.index({ createdAt: -1 });

// Static methods
aiOutputSchema.statics.findBySource = function (sourceType: string, sourceId: string) {
  return this.find({ sourceType, sourceId });
};

aiOutputSchema.statics.findSummaryByLink = function (linkId: string) {
  return this.findOne({ sourceType: 'link', sourceId: linkId, type: 'summary' });
};

aiOutputSchema.statics.findFlashcardsByLink = function (linkId: string) {
  return this.findOne({ sourceType: 'link', sourceId: linkId, type: 'flashcards' });
};

aiOutputSchema.statics.findCourseByProject = function (projectId: string) {
  return this.findOne({ sourceType: 'project', sourceId: projectId, type: 'course' });
};

aiOutputSchema.statics.findQuizByProject = function (projectId: string) {
  return this.findOne({ sourceType: 'project', sourceId: projectId, type: 'quiz' });
};

interface AiOutputModel extends Model<AiOutputDocument> {
  findBySource(sourceType: string, sourceId: string): Promise<AiOutputDocument[]>;
  findSummaryByLink(linkId: string): Promise<AiOutputDocument | null>;
  findFlashcardsByLink(linkId: string): Promise<AiOutputDocument | null>;
  findCourseByProject(projectId: string): Promise<AiOutputDocument | null>;
  findQuizByProject(projectId: string): Promise<AiOutputDocument | null>;
}

const AiOutputModel = mongoose.model<AiOutputDocument, AiOutputModel>('AiOutput', aiOutputSchema);

export default AiOutputModel;
