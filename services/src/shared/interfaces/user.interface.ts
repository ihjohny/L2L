import { BaseEntity } from './base.interface';

export interface User extends BaseEntity {
  email: string;
  passwordHash: string;
  name: string;
  deletedAt?: Date | null;
  refreshToken?: string;
}

export interface CreateUserDto {
  email: string;
  password: string;
  name: string;
}

export interface LoginDto {
  email: string;
  password: string;
}

export interface AuthResponse {
  user: Omit<User, 'passwordHash'>;
  accessToken: string;
  refreshToken: string;
}

export interface JwtPayload {
  sub: string;
  email: string;
  iat: number;
  exp: number;
  permissions?: string[];
}
