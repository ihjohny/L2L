import { BaseEntity } from './base.interface';

export type UserTier = 'free' | 'premium' | 'enterprise';

export interface UserProfile {
  firstName: string;
  lastName: string;
  avatar?: string;
  bio?: string;
  preferences: UserPreferences;
}

export interface UserPreferences {
  theme: 'light' | 'dark' | 'system';
  language: string;
  notifications: NotificationPreferences;
  privacy: PrivacyPreferences;
}

export interface NotificationPreferences {
  email: boolean;
  push: boolean;
  marketing: boolean;
  learningReminders: boolean;
  socialUpdates: boolean;
}

export interface PrivacyPreferences {
  profileVisibility: 'public' | 'private';
  activityVisibility: 'public' | 'private';
  showProgress: boolean;
}

export interface UserSubscription {
  tier: UserTier;
  startDate: Date;
  endDate?: Date;
  stripeCustomerId?: string;
  stripeSubscriptionId?: string;
  cancelAtPeriodEnd?: boolean;
}

export interface UserStats {
  totalBookmarks: number;
  projectsCompleted: number;
  streakDays: number;
  totalPoints: number;
  currentLevel: number;
  quizzesCompleted: number;
  flashcardsReviewed: number;
}

export interface User extends BaseEntity {
  email: string;
  username: string;
  password: string;
  profile: UserProfile;
  subscription: UserSubscription;
  stats: UserStats;
  isEmailVerified: boolean;
  lastLoginAt?: Date;
  refreshToken?: string;
}

export interface CreateUserDto {
  email: string;
  username: string;
  password: string;
  firstName: string;
  lastName: string;
}

export interface UpdateUserDto {
  firstName?: string;
  lastName?: string;
  bio?: string;
  avatar?: string;
  preferences?: Partial<UserPreferences>;
}

export interface LoginDto {
  email: string;
  password: string;
}

export interface AuthResponse {
  user: Omit<User, 'password' | 'refreshToken'>;
  token: string;
  refreshToken: string;
}

export interface JwtPayload {
  sub: string;
  email: string;
  tier: UserTier;
  permissions: string[];
  iat: number;
  exp: number;
}
