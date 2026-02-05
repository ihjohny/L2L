import mongoose, { Schema, Document, Model } from 'mongoose';
import { Entity, ContentType, ContentStatus, DifficultyLevel } from '../../shared/interfaces/content.interface';

interface EntityDocument extends Omit<Entity, '_id'>, Document {}

const contentMetadataSchema = new Schema({
  author: { type: String },
  publishDate: { type: Date },
  readingTime: { type: Number }, // in minutes
  difficulty: {
    type: String,
    enum: ['beginner', 'intermediate', 'advanced', 'expert'],
    default: 'intermediate'
  },
  sourceUrl: { type: String, required: true },
  thumbnail: { type: String },
  fileSize: { type: Number },
  duration: { type: Number }, // for video/podcast in seconds
  language: { type: String, default: 'en' }
});

const processedContentSchema = new Schema({
  summary: { type: String },
  keyPoints: [{ type: String }],
  tags: [{ type: String }],
  thumbnail: { type: String },
  concepts: [{ type: String }],
  difficulty: {
    type: String,
    enum: ['beginner', 'intermediate', 'advanced', 'expert']
  },
  readingTime: { type: Number }
});

const flashcardSchema = new Schema({
  id: { type: String, required: true },
  front: { type: String, required: true },
  back: { type: String, required: true },
  difficulty: {
    type: String,
    enum: ['beginner', 'intermediate', 'advanced', 'expert']
  },
  imageUrl: { type: String },
  reviewCount: { type: Number, default: 0 },
  lastReviewedAt: { type: Date },
  nextReviewAt: { type: Date },
  easeFactor: { type: Number, default: 2.5 }
});

const quizQuestionSchema = new Schema({
  id: { type: String, required: true },
  question: { type: String, required: true },
  options: [{ type: String, required: true }],
  correctAnswer: { type: Number, required: true },
  explanation: { type: String },
  difficulty: {
    type: String,
    enum: ['beginner', 'intermediate', 'advanced', 'expert']
  },
  points: { type: Number, default: 10 }
});

const quizAttemptSchema = new Schema({
  score: { type: Number, required: true },
  totalQuestions: { type: Number, required: true },
  correctAnswers: { type: Number, required: true },
  timeSpent: { type: Number }, // in seconds
  completedAt: { type: Date, default: Date.now },
  answers: [{ type: Number }]
});

const learningMaterialsSchema = new Schema({
  flashcards: [flashcardSchema],
  quiz: {
    questions: [quizQuestionSchema],
    attempts: [quizAttemptSchema]
  },
  learningPath: [{ type: String }]
});

const userInteractionsSchema = new Schema({
  isRead: { type: Boolean, default: false },
  isFavorite: { type: Boolean, default: false },
  rating: { type: Number, min: 1, max: 5 },
  readAt: { type: Date }
});

const entitySchema = new Schema(
  {
    url: {
      type: String,
      required: true,
      index: true
    },
    title: {
      type: String,
      required: true,
      trim: true
    },
    description: {
      type: String,
      trim: true
    },
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true
    },
    tags: {
      type: [String],
      default: [],
      index: true
    },
    type: {
      type: String,
      enum: ['article', 'video', 'podcast', 'document', 'book'],
      required: true,
      default: 'article'
    },
    status: {
      type: String,
      enum: ['pending', 'processing', 'completed', 'failed'],
      required: true,
      default: 'pending',
      index: true
    },
    metadata: {
      type: contentMetadataSchema,
      required: true
    },
    processedContent: {
      type: processedContentSchema
    },
    learningMaterials: {
      type: learningMaterialsSchema
    },
    userInteractions: {
      type: userInteractionsSchema,
      default: {}
    }
  },
  {
    timestamps: true,
    toJSON: {
      virtuals: true
    },
    toObject: {
      virtuals: true
    }
  }
);

// Indexes
entitySchema.index({ userId: 1, createdAt: -1 });
entitySchema.index({ tags: 1, createdAt: -1 });
entitySchema.index({ status: 1 });
entitySchema.index({ type: 1 });
entitySchema.index({ 'userInteractions.isRead': 1 });
entitySchema.index({ 'userInteractions.isFavorite': 1 });
entitySchema.index({ title: 'text', description: 'text', 'processedContent.summary': 'text' });

// Method to mark as read
entitySchema.methods.markAsRead = function () {
  this.userInteractions.isRead = true;
  this.userInteractions.readAt = new Date();
  return this.save();
};

// Method to toggle favorite
entitySchema.methods.toggleFavorite = function () {
  this.userInteractions.isFavorite = !this.userInteractions.isFavorite;
  return this.save();
};

// Method to add quiz attempt
entitySchema.methods.addQuizAttempt = function (attempt: any) {
  if (!this.learningMaterials) {
    this.learningMaterials = { flashcards: [], quiz: { questions: [], attempts: [] } };
  }
  if (!this.learningMaterials.quiz.attempts) {
    this.learningMaterials.quiz.attempts = [];
  }
  this.learningMaterials.quiz.attempts.push(attempt);
  return this.save();
};

// Static method to find by user
entitySchema.statics.findByUser = function (userId: string) {
  return this.find({ userId }).sort({ createdAt: -1 });
};

// Static method to find pending processing
entitySchema.statics.findPendingProcessing = function () {
  return this.find({ status: 'pending' }).limit(10);
};

// Static method to find by tags
entitySchema.statics.findByTags = function (userId: string, tags: string[]) {
  return this.find({ userId, tags: { $in: tags } }).sort({ createdAt: -1 });
};

interface EntityModel extends Model<EntityDocument> {
  findByUser(userId: string): Promise<EntityDocument[]>;
  findByTags(userId: string, tags: string[]): Promise<EntityDocument[]>;
  findPendingProcessing(): Promise<EntityDocument[]>;
}

const EntityModel = mongoose.model<EntityDocument, EntityModel>('Entity', entitySchema);

export default EntityModel;
