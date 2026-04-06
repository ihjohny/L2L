import mongoose, { Schema, Document, Model } from 'mongoose';
import { BaseEntity } from '../../shared/interfaces/base.interface';

export type AiOutputSourceType = 'link' | 'project';
export type AiOutputType = 'summary' | 'flashcards' | 'course' | 'quiz';

// Summary content structure
export interface SummaryContent {
  keyPoints: string[];
  mainArgument: string;
  takeaways: string[];
}

// Flashcard content structure
export interface Flashcard {
  question: string;
  answer: string;
  difficulty: 'easy' | 'medium' | 'hard';
}

export interface FlashcardsContent {
  flashcards: Flashcard[];
}

// Course content structure
export interface CourseLesson {
  title: string;
  content: string;
  order: number;
}

export interface CourseContent {
  title: string;
  description: string;
  lessons: CourseLesson[];
}

// Quiz content structure
export interface QuizQuestion {
  question: string;
  options: string[];
  correct: number;
  explanation?: string;
}

export interface QuizContent {
  courseId?: mongoose.Types.ObjectId;  // Reference to the course this quiz was generated from (ai_outputs._id)
  questions: QuizQuestion[];
}

// Union type for all content types
export type AiOutputContent = SummaryContent | FlashcardsContent | CourseContent | QuizContent;

export interface AiOutput extends BaseEntity {
  sourceType: AiOutputSourceType;
  sourceId: string;
  type: AiOutputType;
  content: AiOutputContent;
  tokenUsage: {
    inputTokens: number;
    outputTokens: number;
    totalTokens: number;
  };
}

export interface CreateAiOutputDto {
  sourceType: AiOutputSourceType;
  sourceId: string;
  type: AiOutputType;
  content: AiOutputContent;
  tokenUsage?: {
    inputTokens: number;
    outputTokens: number;
    totalTokens: number;
  };
}

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

aiOutputSchema.statics.findLatestCourseByProject = function (projectId: string) {
  return this.findOne({ sourceType: 'project', sourceId: projectId, type: 'course' }).sort({ createdAt: -1 });
};

aiOutputSchema.statics.findLatestQuizByProject = function (projectId: string) {
  return this.findOne({ sourceType: 'project', sourceId: projectId, type: 'quiz' }).sort({ createdAt: -1 });
};

interface AiOutputModel extends Model<AiOutputDocument> {
  findBySource(sourceType: string, sourceId: string): Promise<AiOutputDocument[]>;
  findSummaryByLink(linkId: string): Promise<AiOutputDocument | null>;
  findFlashcardsByLink(linkId: string): Promise<AiOutputDocument | null>;
  findCourseByProject(projectId: string): Promise<AiOutputDocument | null>;
  findQuizByProject(projectId: string): Promise<AiOutputDocument | null>;
  findLatestCourseByProject(projectId: string): Promise<AiOutputDocument | null>;
  findLatestQuizByProject(projectId: string): Promise<AiOutputDocument | null>;
}

const AiOutputModel = mongoose.model<AiOutputDocument, AiOutputModel>('AiOutput', aiOutputSchema);

export default AiOutputModel;
