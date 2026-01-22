import User from '../../database/models/User.model';
import { User as UserType, CreateUserDto, UpdateUserDto, LoginDto, AuthResponse } from '../../shared/interfaces/user.interface';
import { generateAccessToken, generateRefreshToken, verifyAccessToken } from '../../utils/jwt';
import { logger } from '../../utils/logger';
import { AppError } from '../../utils/errors';

class UserService {
  async registerUser(dto: CreateUserDto): Promise<AuthResponse> {
    try {
      // Check if user already exists
      const existingUser = await User.findByEmail(dto.email);
      if (existingUser) {
        throw new AppError('User already exists with this email', 'CONFLICT', 409);
      }

      const existingUsername = await User.findByUsername(dto.username);
      if (existingUsername) {
        throw new AppError('Username already taken', 'CONFLICT', 409);
      }

      // Create new user
      const user = await User.create({
        email: dto.email.toLowerCase(),
        username: dto.username.toLowerCase(),
        password: dto.password, // Will be hashed by pre-save hook
        profile: {
          firstName: dto.firstName,
          lastName: dto.lastName,
          preferences: {
            theme: 'system',
            language: 'en',
            notifications: {
              email: true,
              push: true,
              marketing: false,
              learningReminders: true,
              socialUpdates: true
            },
            privacy: {
              profileVisibility: 'public',
              activityVisibility: 'public',
              showProgress: true
            }
          }
        },
        subscription: {
          tier: 'free',
          startDate: new Date()
        },
        stats: {
          totalBookmarks: 0,
          projectsCompleted: 0,
          streakDays: 0,
          totalPoints: 0,
          currentLevel: 1,
          quizzesCompleted: 0,
          flashcardsReviewed: 0
        },
        isEmailVerified: false
      });

      logger.info(`New user registered: ${user.email}`);

      // Generate tokens
      const token = generateAccessToken(user._id.toString(), user.email, user.subscription.tier);
      const refreshToken = generateRefreshToken(user._id.toString());

      // Save refresh token to user
      user.refreshToken = refreshToken;
      await user.save();

      return {
        user: (user as any).toPublicJSON(),
        token,
        refreshToken
      };
    } catch (error: any) {
      logger.error('Error in registerUser:', error);
      throw error;
    }
  }

  async loginUser(dto: LoginDto): Promise<AuthResponse> {
    try {
      // Find user by email
      const user = await User.findByEmail(dto.email);
      if (!user) {
        throw new AppError('Invalid email or password', 'UNAUTHORIZED', 401);
      }

      // Check password
      const isPasswordValid = await (user as any).comparePassword(dto.password);
      if (!isPasswordValid) {
        throw new AppError('Invalid email or password', 'UNAUTHORIZED', 401);
      }

      // Update last login
      user.lastLoginAt = new Date();
      await user.save();

      logger.info(`User logged in: ${user.email}`);

      // Generate tokens
      const token = generateAccessToken(user._id.toString(), user.email, user.subscription.tier);
      const refreshToken = generateRefreshToken(user._id.toString());

      // Save refresh token to user
      user.refreshToken = refreshToken;
      await user.save();

      return {
        user: (user as any).toPublicJSON(),
        token,
        refreshToken
      };
    } catch (error: any) {
      logger.error('Error in loginUser:', error);
      throw error;
    }
  }

  async getUserById(userId: string): Promise<UserType> {
    try {
      const user = await User.findById(userId);
      if (!user) {
        throw new AppError('User not found', 'NOT_FOUND', 404);
      }
      return (user as any).toPublicJSON();
    } catch (error: any) {
      logger.error('Error in getUserById:', error);
      throw error;
    }
  }

  async updateUser(userId: string, dto: UpdateUserDto): Promise<UserType> {
    try {
      const user = await User.findById(userId);
      if (!user) {
        throw new AppError('User not found', 'NOT_FOUND', 404);
      }

      // Update profile fields
      if (dto.firstName) {
        user.profile.firstName = dto.firstName;
      }
      if (dto.lastName) {
        user.profile.lastName = dto.lastName;
      }
      if (dto.bio !== undefined) {
        user.profile.bio = dto.bio;
      }
      if (dto.avatar !== undefined) {
        user.profile.avatar = dto.avatar;
      }
      if (dto.preferences) {
        user.profile.preferences = {
          ...user.profile.preferences,
          ...dto.preferences
        };
      }

      await user.save();
      logger.info(`User updated: ${user.email}`);

      return (user as any).toPublicJSON();
    } catch (error: any) {
      logger.error('Error in updateUser:', error);
      throw error;
    }
  }

  async updateLastLogin(userId: string): Promise<void> {
    try {
      const user = await User.findById(userId);
      if (user) {
        user.lastLoginAt = new Date();
        await user.save();
      }
    } catch (error: any) {
      logger.error('Error in updateLastLogin:', error);
    }
  }

  async deleteUser(userId: string): Promise<void> {
    try {
      const user = await User.findById(userId);
      if (!user) {
        throw new AppError('User not found', 'NOT_FOUND', 404);
      }

      await User.findByIdAndDelete(userId);
      logger.info(`User deleted: ${user.email}`);
    } catch (error: any) {
      logger.error('Error in deleteUser:', error);
      throw error;
    }
  }

  async refreshAccessToken(refreshToken: string): Promise<{ token: string; refreshToken: string }> {
    try {
      // Verify refresh token
      const payload = verifyAccessToken(refreshToken); // This should use refresh token verification

      const user = await User.findById(payload.sub);
      if (!user || user.refreshToken !== refreshToken) {
        throw new AppError('Invalid refresh token', 'UNAUTHORIZED', 401);
      }

      // Generate new tokens
      const newToken = generateAccessToken(user._id.toString(), user.email, user.subscription.tier);
      const newRefreshToken = generateRefreshToken(user._id.toString());

      // Update refresh token
      user.refreshToken = newRefreshToken;
      await user.save();

      return {
        token: newToken,
        refreshToken: newRefreshToken
      };
    } catch (error: any) {
      logger.error('Error in refreshAccessToken:', error);
      throw new AppError('Invalid refresh token', 'UNAUTHORIZED', 401);
    }
  }

  async updateSubscriptionTier(userId: string, tier: 'free' | 'premium' | 'enterprise'): Promise<UserType> {
    try {
      const user = await User.findById(userId);
      if (!user) {
        throw new AppError('User not found', 'NOT_FOUND', 404);
      }

      user.subscription.tier = tier;
      if (tier !== 'free') {
        user.subscription.startDate = new Date();
        user.subscription.endDate = undefined;
      }

      await user.save();
      logger.info(`User subscription updated: ${user.email} -> ${tier}`);

      return (user as any).toPublicJSON();
    } catch (error: any) {
      logger.error('Error in updateSubscriptionTier:', error);
      throw error;
    }
  }

  async updateUserStats(userId: string, statsUpdate: Partial<UserType['stats']>): Promise<void> {
    try {
      const user = await User.findById(userId);
      if (!user) {
        throw new AppError('User not found', 'NOT_FOUND', 404);
      }

      Object.assign(user.stats, statsUpdate);
      await user.save();
    } catch (error: any) {
      logger.error('Error in updateUserStats:', error);
      throw error;
    }
  }
}

const userService = new UserService();
export default userService;
export { userService };
