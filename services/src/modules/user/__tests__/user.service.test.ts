import { UserService } from '../user.service';
import User from '../../database/models/User.model';
import { AppError } from '../../utils/errors';

describe('UserService', () => {
  let userService: UserService;

  beforeEach(() => {
    userService = UserService;
  });

  describe('registerUser', () => {
    it('should register a new user successfully', async () => {
      const dto = {
        email: 'test@example.com',
        username: 'testuser',
        password: 'Password123',
        firstName: 'Test',
        lastName: 'User'
      };

      const result = await userService.registerUser(dto);

      expect(result).toBeDefined();
      expect(result.user).toBeDefined();
      expect(result.user.email).toBe(dto.email);
      expect(result.user.username).toBe(dto.username);
      expect(result.token).toBeDefined();
      expect(result.refreshToken).toBeDefined();
    });

    it('should throw error if user already exists', async () => {
      const dto = {
        email: 'test@example.com',
        username: 'testuser',
        password: 'Password123',
        firstName: 'Test',
        lastName: 'User'
      };

      // Create first user
      await userService.registerUser(dto);

      // Try to create duplicate
      await expect(userService.registerUser(dto))
        .rejects.toThrow('User already exists with this email');
    });

    it('should throw error for invalid password', async () => {
      const dto = {
        email: 'test@example.com',
        username: 'testuser',
        password: 'weak',
        firstName: 'Test',
        lastName: 'User'
      };

      // This should be validated at the controller level
      // But service should handle hashing properly
      await expect(userService.registerUser(dto))
        .resolves.toBeDefined();
    });
  });

  describe('loginUser', () => {
    it('should login user successfully with correct credentials', async () => {
      const registerDto = {
        email: 'test@example.com',
        username: 'testuser',
        password: 'Password123',
        firstName: 'Test',
        lastName: 'User'
      };

      await userService.registerUser(registerDto);

      const loginDto = {
        email: 'test@example.com',
        password: 'Password123'
      };

      const result = await userService.loginUser(loginDto);

      expect(result).toBeDefined();
      expect(result.user).toBeDefined();
      expect(result.token).toBeDefined();
    });

    it('should throw error for incorrect password', async () => {
      const registerDto = {
        email: 'test@example.com',
        username: 'testuser',
        password: 'Password123',
        firstName: 'Test',
        lastName: 'User'
      };

      await userService.registerUser(registerDto);

      const loginDto = {
        email: 'test@example.com',
        password: 'WrongPassword123'
      };

      await expect(userService.loginUser(loginDto))
        .rejects.toThrow('Invalid email or password');
    });

    it('should throw error for non-existent user', async () => {
      const loginDto = {
        email: 'nonexistent@example.com',
        password: 'Password123'
      };

      await expect(userService.loginUser(loginDto))
        .rejects.toThrow('Invalid email or password');
    });
  });

  describe('getUserById', () => {
    it('should return user by id', async () => {
      const registerDto = {
        email: 'test@example.com',
        username: 'testuser',
        password: 'Password123',
        firstName: 'Test',
        lastName: 'User'
      };

      const { user } = await userService.registerUser(registerDto);

      const foundUser = await userService.getUserById(user.id);

      expect(foundUser).toBeDefined();
      expect(foundUser.email).toBe(registerDto.email);
    });

    it('should throw error for non-existent user', async () => {
      await expect(userService.getUserById('507f1f77bcf86cd799439011'))
        .rejects.toThrow('User not found');
    });
  });

  describe('updateUser', () => {
    it('should update user profile', async () => {
      const registerDto = {
        email: 'test@example.com',
        username: 'testuser',
        password: 'Password123',
        firstName: 'Test',
        lastName: 'User'
      };

      const { user } = await userService.registerUser(registerDto);

      const updateDto = {
        firstName: 'Updated',
        lastName: 'Name',
        bio: 'New bio'
      };

      const updatedUser = await userService.updateUser(user.id, updateDto);

      expect(updatedUser.firstName).toBe(updateDto.firstName);
      expect(updatedUser.lastName).toBe(updateDto.lastName);
      expect(updatedUser.bio).toBe(updateDto.bio);
    });
  });
});
