import { BaseEntity } from './base.interface';

export type JobType = 'process_link' | 'generate_course';
export type JobStatus = 'waiting' | 'active' | 'completed' | 'failed' | 'delayed';

export interface Job extends BaseEntity {
  userId: string;
  type: JobType;
  sourceType: 'link' | 'project';
  sourceId: string;
  status: JobStatus;
  attempts: number;
  maxAttempts: number;
  progress: number;
  data: Record<string, any>;
  failedReason?: string | null;
  processedAt?: Date | null;
}

export interface CreateJobDto {
  type: JobType;
  sourceType: 'link' | 'project';
  sourceId: string;
  data?: Record<string, any>;
}

export interface UpdateJobDto {
  status?: JobStatus;
  attempts?: number;
  progress?: number;
  failedReason?: string;
  processedAt?: Date;
  data?: Record<string, any>;
}
