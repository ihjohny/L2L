import { BaseEntity } from './base.interface';

export interface SharedProject extends BaseEntity {
  projectId: string;
  sharedBy: string;
  sharedWith: string[]; // user IDs or 'public'
  accessLevel: 'view' | 'edit' | 'admin';
  expiresAt?: Date;
  shareCode: string;
  isActive: boolean;
}

export interface UserGroup extends BaseEntity {
  name: string;
  description: string;
  ownerId: string;
  members: string[];
  admins: string[];
  isPublic: boolean;
  inviteCode: string;
  maxMembers?: number;
  settings: GroupSettings;
}

export interface GroupSettings {
  allowMemberInvites: boolean;
  requireApproval: boolean;
  sharedProjects: string[];
  leaderboardsEnabled: boolean;
  challengesEnabled: boolean;
}

export interface Comment extends BaseEntity {
  projectId: string;
  entityId?: string;
  userId: string;
  content: string;
  parentId?: string;
  replies: string[];
  isEdited: boolean;
  editedAt?: Date;
}

export interface LeaderboardEntry {
  userId: string;
  username: string;
  avatar?: string;
  points: number;
  level: number;
  rank: number;
  change?: number; // rank change from previous period
}

export interface Leaderboard {
  id: string;
  type: 'global' | 'topic' | 'project' | 'group';
  resourceId?: string;
  period: 'daily' | 'weekly' | 'monthly' | 'allTime';
  entries: LeaderboardEntry[];
  lastUpdated: Date;
}

export interface ShareProjectDto {
  projectId: string;
  accessLevel: 'view' | 'edit' | 'admin';
  shareWith?: string[];
  expiresIn?: number; // days
}

export interface CreateGroupDto {
  name: string;
  description: string;
  isPublic?: boolean;
  maxMembers?: number;
}

export interface AddCommentDto {
  projectId: string;
  entityId?: string;
  content: string;
  parentId?: string;
}
