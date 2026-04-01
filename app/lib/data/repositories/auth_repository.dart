import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/utils/result.dart';

/// Provider for AuthRepository with dependency injection.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    authService: AuthService(),
    secureStorage: SecureStorage(),
  );
});

/// Repository for authentication operations.
///
/// Coordinates between AuthService and SecureStorage to manage
/// authentication state and token persistence.
class AuthRepository {
  final AuthService _authService;
  final SecureStorage _secureStorage;

  AuthRepository({
    required AuthService authService,
    required SecureStorage secureStorage,
  })  : _authService = authService,
        _secureStorage = secureStorage;

  /// Initialize auth - check for existing session.
  /// Returns [Success] with user if authenticated, [Failure] otherwise.
  Future<Result<UserModel?>> initializeAuth() async {
    try {
      final accessToken = await _secureStorage.getAccessToken();
      if (accessToken != null) {
        try {
          // Validate token by fetching current user
          final user = await _authService.getCurrentUser();
          return Success(user);
        } catch (_) {
          // Token expired, try refresh
          final refreshed = await _refreshAuthToken();
          if (refreshed) {
            try {
              final user = await _authService.getCurrentUser();
              return Success(user);
            } catch (_) {
              return const Success(null);
            }
          }
        }
      }
      return const Success(null);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Login with email and password.
  /// Returns [Success] with user on success, [Failure] with error message on failure.
  Future<Result<UserModel>> login(String email, String password) async {
    try {
      final response = await _authService.login(email, password);

      // Save tokens
      await _secureStorage.saveTokens(
        response.token,
        response.refreshToken,
      );

      return Success(response.user);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Register with name, email and password.
  /// Returns [Success] with user on success, [Failure] with error message on failure.
  Future<Result<UserModel>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.register(
        name: name,
        email: email,
        password: password,
      );

      // Save tokens
      await _secureStorage.saveTokens(
        response.token,
        response.refreshToken,
      );

      return Success(response.user);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Logout - clear stored tokens.
  Future<void> logout() async {
    await _secureStorage.clearTokens();
  }

  /// Get user profile.
  Future<Result<UserModel>> getProfile() async {
    try {
      final user = await _authService.getCurrentUser();
      return Success(user);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Refresh auth token internally.
  Future<bool> _refreshAuthToken() async {
    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _authService.refreshToken(refreshToken);

      // Save new tokens
      await _secureStorage.saveTokens(
        response.token,
        response.refreshToken,
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}
