import User from '../../database/models/User.model';
import { User as UserType, CreateUserDto, LoginDto, AuthResponse } from '../../shared/interfaces/user.interface';
import { generateAccessToken, generateRefreshToken } from '../../utils/jwt';
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

      // Create new user
      const user = await User.create({
        email: dto.email.toLowerCase(),
        passwordHash: dto.password, // Will be hashed by pre-save hook
        name: dto.name
      });

      logger.info(`New user registered: ${user.email}`);

      // Generate tokens
      const accessToken = generateAccessToken(user._id.toString(), user.email);
      const refreshToken = generateRefreshToken(user._id.toString());

      // Save refresh token to user
      user.refreshToken = refreshToken;
      await user.save();

      return {
        user: (user as any).toPublicJSON(),
        accessToken,
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

      logger.info(`User logged in: ${user.email}`);

      // Generate tokens
      const accessToken = generateAccessToken(user._id.toString(), user.email);
      const refreshToken = generateRefreshToken(user._id.toString());

      // Save refresh token to user
      user.refreshToken = refreshToken;
      await user.save();

      return {
        user: (user as any).toPublicJSON(),
        accessToken,
        refreshToken
      };
    } catch (error: any) {
      logger.error('Error in loginUser:', error);
      throw error;
    }
  }

  async getUserById(userId: string): Promise<UserType> {
    try {
      const user = await User.findByIdActive(userId);
      if (!user) {
        throw new AppError('User not found', 'NOT_FOUND', 404);
      }
      return (user as any).toPublicJSON();
    } catch (error: any) {
      logger.error('Error in getUserById:', error);
      throw error;
    }
  }

  async deleteUser(userId: string): Promise<void> {
    try {
      const user = await User.findByIdActive(userId);
      if (!user) {
        throw new AppError('User not found', 'NOT_FOUND', 404);
      }

      // Soft delete
      user.deletedAt = new Date();
      await user.save();
      logger.info(`User deleted: ${user.email}`);
    } catch (error: any) {
      logger.error('Error in deleteUser:', error);
      throw error;
    }
  }

  async refreshAccessToken(refreshToken: string): Promise<{ accessToken: string; refreshToken: string }> {
    try {
      // Verify refresh token and get user ID
      const { sub: userId } = await import('../../utils/jwt').then(m => m.verifyRefreshToken(refreshToken));

      const user = await User.findByIdActive(userId);
      if (!user || user.refreshToken !== refreshToken) {
        throw new AppError('Invalid refresh token', 'UNAUTHORIZED', 401);
      }

      // Generate new tokens
      const newAccessToken = generateAccessToken(user._id.toString(), user.email);
      const newRefreshToken = generateRefreshToken(user._id.toString());

      // Update refresh token
      user.refreshToken = newRefreshToken;
      await user.save();

      return {
        accessToken: newAccessToken,
        refreshToken: newRefreshToken
      };
    } catch (error: any) {
      logger.error('Error in refreshAccessToken:', error);
      throw new AppError('Invalid refresh token', 'UNAUTHORIZED', 401);
    }
  }
}

const userService = new UserService();
export default userService;
export { userService };
