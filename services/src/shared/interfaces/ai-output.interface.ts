import { BaseEntity } from './base.interface';

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
