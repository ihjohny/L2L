import jwt from 'jsonwebtoken';
import { config } from '../config/environment';
import { JwtPayload, UserTier } from '../shared/interfaces/user.interface';

export function generateAccessToken(userId: string, email: string, tier: UserTier): string {
  const payload: JwtPayload = {
    sub: userId,
    email,
    tier,
    permissions: getPermissionsForTier(tier),
    iat: Math.floor(Date.now() / 1000),
    exp: Math.floor(Date.now() / 1000) + 7 * 24 * 60 * 60 // 7 days
  };

  return jwt.sign(payload, config.jwt.secret);
}

export function generateRefreshToken(userId: string): string {
  const payload = {
    sub: userId,
    type: 'refresh',
    iat: Math.floor(Date.now() / 1000),
    exp: Math.floor(Date.now() / 1000) + 30 * 24 * 60 * 60 // 30 days
  };

  return jwt.sign(payload, config.jwt.refreshSecret);
}

export function verifyAccessToken(token: string): JwtPayload {
  try {
    return jwt.verify(token, config.jwt.secret) as JwtPayload;
  } catch (error) {
    throw new Error('Invalid or expired token');
  }
}

export function verifyRefreshToken(token: string): any {
  try {
    return jwt.verify(token, config.jwt.refreshSecret);
  } catch (error) {
    throw new Error('Invalid or expired refresh token');
  }
}

export function decodeToken(token: string): JwtPayload | null {
  try {
    return jwt.decode(token) as JwtPayload;
  } catch (error) {
    return null;
  }
}

function getPermissionsForTier(tier: UserTier): string[] {
  const basePermissions = ['read:content', 'create:bookmark', 'update:profile'];

  const tierPermissions: Record<UserTier, string[]> = {
    free: [
      ...basePermissions,
      'create:project:limited',
      'ai:process:limited'
    ],
    premium: [
      ...basePermissions,
      'create:project:unlimited',
      'ai:process:unlimited',
      'share:project',
      'create:group'
    ],
    enterprise: [
      ...basePermissions,
      'create:project:unlimited',
      'ai:process:unlimited',
      'share:project',
      'create:group',
      'manage:team',
      'access:analytics:advanced'
    ]
  };

  return tierPermissions[tier] || tierPermissions.free;
}
