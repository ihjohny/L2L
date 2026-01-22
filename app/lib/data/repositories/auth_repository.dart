import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final ApiService _apiService;
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  AuthRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // Check if user is logged in
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  // Get stored token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Get stored refresh token
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // Login
  Future<AuthResult> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _apiService.login(request);

      // Save credentials
      await _saveAuthData(response);

      // Update API service with token
      _apiService.setAuthToken(response.token);

      return AuthResult(user: response.user, success: true);
    } catch (e) {
      return AuthResult(
        success: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  // Register
  Future<AuthResult> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final request = RegisterRequest(
        email: email,
        username: username,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      final response = await _apiService.register(request);

      // Save credentials
      await _saveAuthData(response);

      // Update API service with token
      _apiService.setAuthToken(response.token);

      return AuthResult(user: response.user, success: true);
    } catch (e) {
      return AuthResult(
        success: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    _apiService.clearAuthToken();
  }

  // Get profile from API
  Future<UserModel> getProfile() async {
    return await _apiService.getProfile();
  }

  // Update profile
  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    return await _apiService.updateProfile(data);
  }

  // Delete account
  Future<void> deleteAccount() async {
    await _apiService.deleteAccount();
    await logout();
  }

  // Refresh token
  Future<bool> refreshAuthToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _apiService.refreshToken(refreshToken);

      // Save new credentials
      await _saveAuthData(response);

      // Update API service with new token
      _apiService.setAuthToken(response.token);

      return true;
    } catch (e) {
      return false;
    }
  }

  // Save auth data locally - simplified to only store tokens
  Future<void> _saveAuthData(AuthResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, response.token);
    await prefs.setString(_refreshTokenKey, response.refreshToken);
    // Note: User data will be fetched from API when needed
  }

  // Initialize - restore session if exists
  Future<UserModel?> initializeAuth() async {
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      _apiService.setAuthToken(token);
      // Fetch fresh user data from API
      try {
        return await getProfile();
      } catch (e) {
        // Token might be expired, clear auth
        await logout();
        return null;
      }
    }
    return null;
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
