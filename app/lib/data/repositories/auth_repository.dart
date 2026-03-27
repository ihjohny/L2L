import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../../core/storage/secure_storage.dart';

class AuthRepository {
  final AuthService _authService;
  final SecureStorage _secureStorage;

  AuthRepository({
    AuthService? authService,
    SecureStorage? secureStorage,
  })  : _authService = authService ?? AuthService(),
        _secureStorage = secureStorage ?? SecureStorage();

  /// Initialize auth - check for existing session
  Future<UserModel?> initializeAuth() async {
    final accessToken = await _secureStorage.getAccessToken();
    if (accessToken != null) {
      try {
        // Validate token by fetching current user
        final user = await _authService.getCurrentUser();
        return user;
      } catch (e) {
        // Token expired, try refresh
        final refreshed = await refreshAuthToken();
        if (refreshed) {
          try {
            return await _authService.getCurrentUser();
          } catch (e2) {
            // Refresh didn't help, return null
            return null;
          }
        }
      }
    }
    return null;
  }

  /// Login
  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await _authService.login(email, password);

      // Save tokens
      await _secureStorage.saveTokens(
        response.token,
        response.refreshToken,
      );

      return AuthResult(success: true, user: response.user);
    } catch (e) {
      return AuthResult(
        success: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Register
  Future<AuthResult> register({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      final response = await _authService.register(
        email: email,
        name: name,
        password: password,
      );

      // Save tokens
      await _secureStorage.saveTokens(
        response.token,
        response.refreshToken,
      );

      return AuthResult(success: true, user: response.user);
    } catch (e) {
      return AuthResult(
        success: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Logout
  Future<void> logout() async {
    await _secureStorage.clearTokens();
  }

  /// Get user profile
  Future<UserModel> getProfile() async {
    return await _authService.getCurrentUser();
  }

  /// Refresh auth token
  Future<bool> refreshAuthToken() async {
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

class AuthResult {
  final UserModel? user;
  final bool success;
  final String? error;

  AuthResult({
    this.user,
    required this.success,
    this.error,
  });
}
