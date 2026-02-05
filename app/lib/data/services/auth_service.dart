import '../../core/network/dio_client.dart';
import '../models/user_model.dart';
import '../models/auth_request.dart';
import '../models/auth_response.dart';

class ApiService {
  final DioClient _dioClient = DioClient.instance;

  void setAuthToken(String token) {
    _dioClient.setAuthToken(token);
  }

  void clearAuthToken() {
    _dioClient.clearAuthToken();
  }

  Future<AuthResponse> login(LoginRequest request) async {
    try {
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

  Future<AuthResponse> register(RegisterRequest request) async {
    try {
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

  Future<UserModel> getProfile() async {
    try {
      final response = await _dioClient.dio.get('/auth/profile');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to fetch profile');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.dio.put('/auth/profile', data: data);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to update profile');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  Future<void> deleteAccount() async {
    try {
      final response = await _dioClient.dio.delete('/auth/account');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete account');
      }
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await _dioClient.dio.post('/auth/refresh', data: {
        'refreshToken': refreshToken,
      });

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data['data']);
      }
      throw Exception('Failed to refresh token');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }
}
