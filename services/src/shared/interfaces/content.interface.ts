import { BaseEntity } from './base.interface';

export type ContentType = 'article' | 'video' | 'podcast' | 'document' | 'book';
export type ContentStatus = 'pending' | 'processing' | 'completed' | 'failed';
export type DifficultyLevel = 'beginner' | 'intermediate' | 'advanced' | 'expert';


export interface ContentMetadata {
  author?: string;
  publishDate?: Date;
  readingTime?: number; // in minutes
  difficulty: DifficultyLevel;
  sourceUrl: string;
  thumbnail?: string;
  fileSize?: number;
  duration?: number; // for video/podcast in seconds
  language?: string;
}

export interface ProcessedContent {
  summary: string;
  keyPoints: string[];
  tags: string[];
  thumbnail?: string;
  concepts: string[];
  difficulty: DifficultyLevel;
  readingTime: number;
}

export interface Flashcard {
  id: string;
  front: string;
  back: string;
  difficulty?: DifficultyLevel;
  imageUrl?: string;
  reviewCount: number;
  lastReviewedAt?: Date;
  nextReviewAt?: Date;
  easeFactor?: number;
}

export interface QuizQuestion {
  id: string;
  question: string;
  options: string[];
  correctAnswer: number;
  explanation?: string;
  difficulty: DifficultyLevel;
  points: number;
}

export interface QuizAttempt {
  score: number;
  totalQuestions: number;
  correctAnswers: number;
  timeSpent: number; // in seconds
  completedAt: Date;
  answers: number[];
}

export interface LearningMaterials {
  flashcards: Flashcard[];
  quiz: {
    questions: QuizQuestion[];
    attempts: QuizAttempt[];
  };
  learningPath?: string[];
}

export interface UserInteractions {
  isRead: boolean;
  isFavorite: boolean;
  notes?: string;
  rating?: number; // 1-5
  readAt?: Date;
}

export interface Entity extends BaseEntity {
  url: string;
  title: string;
  description: string;
  userId: string;
  tags: string[];
  type: ContentType;
  status: ContentStatus;
  metadata: ContentMetadata;
  processedContent?: ProcessedContent;
  learningMaterials?: LearningMaterials;
  userInteractions: UserInteractions;
}

export interface CreateEntityDto {
  url: string;
  tags?: string[];
  notes?: string;
}

export interface UpdateEntityDto {
  title?: string;
  description?: string;
  tags?: string[];
  notes?: string;
  rating?: number;
}

export interface ProcessContentDto {
  bookmarkId: string;
  options: ProcessingOptions;
}

export interface ProcessingOptions {
  generateSummary: boolean;
  generateFlashcards: boolean;
  generateQuiz: boolean;
  difficulty?: DifficultyLevel;
  flashcardCount?: number;
  quizQuestionCount?: number;
}
