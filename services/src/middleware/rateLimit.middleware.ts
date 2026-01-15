import rateLimit from 'express-rate-limit';
import { config } from '../config/environment';
import { logger } from '../utils/logger';

// Create rate limiters for different tiers
const createRateLimiter = (maxRequests: number) => {
  return rateLimit({
    windowMs: config.rateLimit.windowMs,
    max: maxRequests,
    message: {
      success: false,
      error: 'RATE_LIMIT_EXCEEDED',
      message: 'Too many requests, please try again later'
    },
    standardHeaders: true,
    legacyHeaders: false,
    handler: (req, res) => {
      logger.warn(`Rate limit exceeded for IP: ${req.ip}`);
      res.status(429).json({
        success: false,
        error: 'RATE_LIMIT_EXCEEDED',
        message: 'Too many requests, please try again later'
      });
    }
  });
};

// Tier-based rate limiters
export const freeTierLimit = createRateLimiter(config.rateLimit.tier.free);
export const premiumTierLimit = createRateLimiter(config.rateLimit.tier.premium);
export const enterpriseTierLimit = createRateLimiter(config.rateLimit.tier.enterprise);

// Dynamic rate limiter based on user tier
export function tierBasedRateLimit(req: any, res: any, next: any) {
  const userTier = req.user?.tier || 'free';

  switch (userTier) {
    case 'enterprise':
      return enterpriseTierLimit(req, res, next);
    case 'premium':
      return premiumTierLimit(req, res, next);
    case 'free':
    default:
      return freeTierLimit(req, res, next);
  }
}

// Stricter rate limiter for authentication endpoints
export const authRateLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // 5 attempts per window
  message: {
    success: false,
    error: 'RATE_LIMIT_EXCEEDED',
    message: 'Too many authentication attempts, please try again later'
  },
  skipSuccessfulRequests: true
});

// Rate limiter for AI endpoints (more restrictive)
export const aiRateLimiter = rateLimit({
  windowMs: 60 * 60 * 1000, // 1 hour
  max: 50, // 50 AI requests per hour
  message: {
    success: false,
    error: 'RATE_LIMIT_EXCEEDED',
    message: 'AI processing limit reached, please upgrade your plan for more'
  }
});
