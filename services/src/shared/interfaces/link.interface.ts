import { BaseEntity } from './base.interface';

export type LinkStatus = 'pending' | 'processing' | 'completed' | 'failed';

export interface Link extends BaseEntity {
  userId: string;
  projectId?: string | null;
  url: string;
  title: string | null;
  aiOutputId?: string | null;
  tags: string[];
  status: LinkStatus;
  statusMessage?: string | null;
  deletedAt?: Date | null;
}

export interface CreateLinkDto {
  url: string;
  projectId?: string;
  tags?: string[];
}

export interface UpdateLinkDto {
  title?: string;
  tags?: string[];
  status?: LinkStatus;
  statusMessage?: string;
}
