import '../../core/network/dio_client.dart';
import '../models/user_model.dart';
import '../models/auth_request.dart';
import '../models/auth_response.dart';

class AuthService {
  final DioClient _dioClient = DioClient.instance;

  /// Login user
  Future<AuthResponse> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _dioClient.dio.post(
        '/auth/login',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(response.data['data']);
      }
      throw Exception('Login failed');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Register new user
  Future<AuthResponse> register({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      final request = RegisterRequest(
        email: email,
        name: name,
        password: password,
      );
      final response = await _dioClient.dio.post(
        '/auth/register',
        data: request.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return AuthResponse.fromJson(response.data['data']);
      }
      throw Exception('Registration failed');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Get current user profile
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dioClient.dio.get('/auth/me');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to fetch profile');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Refresh access token
  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data['data']);
      }
      throw Exception('Failed to refresh token');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }
}
