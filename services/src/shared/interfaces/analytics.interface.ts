import { BaseEntity } from './base.interface';

export type EventType =
  | 'bookmark_created'
  | 'bookmark_completed'
  | 'quiz_attempt'
  | 'flashcard_review'
  | 'project_shared'
  | 'group_joined'
  | 'achievement_unlocked'
  | 'streak_milestone';

export interface AnalyticsEvent extends BaseEntity {
  userId: string;
  eventType: EventType;
  eventData: Record<string, any>;
  sessionId?: string;
  metadata: EventMetadata;
}

export interface EventMetadata {
  userAgent: string;
  ip: string;
  platform: 'web' | 'mobile' | 'extension';
  screenResolution?: string;
  referrer?: string;
}

export interface UserAnalytics {
  userId: string;
  period: 'daily' | 'weekly' | 'monthly';
  startDate: Date;
  endDate: Date;
  metrics: AnalyticsMetrics;
  goals: AnalyticsGoals;
}

export interface AnalyticsMetrics {
  totalBookmarks: number;
  bookmarksCompleted: number;
  completionRate: number;
  avgQuizScore: number;
  totalQuizAttempts: number;
  flashcardsReviewed: number;
  studyTimeMinutes: number;
  activeDays: number;
  currentStreak: number;
  longestStreak: number;
  pointsEarned: number;
  achievementsUnlocked: number;
  projectsCompleted: number;
}

export interface AnalyticsGoals {
  dailyBookmarks: number;
  weeklyStudyTime: number; // minutes
  monthlyProjects: number;
  progress: Record<string, number>;
}

export interface LearningVelocity {
  userId: string;
  period: 'week' | 'month' | 'quarter';
  startDate: Date;
  endDate: Date;
  metrics: {
    bookmarksPerDay: number;
    completionRate: number;
    avgTimePerEntity: number;
    improvementRate: number;
    strongTopics: string[];
    weakTopics: string[];
  };
}

export interface ProgressReport {
  userId: string;
  projectId?: string;
  generatedAt: Date;
  summary: ReportSummary;
  breakdown: ReportBreakdown;
  recommendations: string[];
}

export interface ReportSummary {
  totalEntities: number;
  completedEntities: number;
  completionPercentage: number;
  totalTimeSpent: number;
  averageScore: number;
  streakDays: number;
}

export interface ReportBreakdown {
  byTopic: Record<string, { completed: number; total: number; percentage: number }>;
  byDifficulty: Record<string, { completed: number; total: number; percentage: number }>;
  byType: Record<string, { completed: number; total: number; percentage: number }>;
}

export interface TrackEventDto {
  eventType: EventType;
  eventData: Record<string, any>;
  sessionId?: string;
}
