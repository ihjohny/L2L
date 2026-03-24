import { BaseEntity } from './base.interface';

export interface Project extends BaseEntity {
  userId: string;
  name: string;
  description?: string | null;
  aiOutputId?: string | null;
  deletedAt?: Date | null;
}

export interface CreateProjectDto {
  name: string;
  description?: string;
}

export interface UpdateProjectDto {
  name?: string;
  description?: string;
}
