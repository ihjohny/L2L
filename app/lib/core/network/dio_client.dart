import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/env_config.dart';
import '../storage/secure_storage.dart';

class DioClient {
  static DioClient? _instance;
  late final Dio _dio;
  final SecureStorage _secureStorage = SecureStorage();

  DioClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: EnvConfig.apiPath,
      connectTimeout: Duration(milliseconds: EnvConfig.connectTimeout),
      receiveTimeout: Duration(milliseconds: EnvConfig.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Add logging interceptor if enabled
    if (EnvConfig.enableLogging) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ));
    }

    // Add auth interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Try to get token from secure storage
        final token = await _secureStorage.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired or invalid - will be handled by repository
          _onTokenExpired();
        }
        return handler.next(error);
      },
    ));
  }

  static DioClient get instance {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  /// Set authentication token (for in-memory caching)
  /// Note: Tokens should be persisted via SecureStorage directly
  void setAuthToken(String? token) {
    // Token is now managed directly by SecureStorage
    // This method is kept for backward compatibility
  }

  /// Clear authentication token
  void clearAuthToken() {
    // Tokens are now cleared via SecureStorage directly
    // This method is kept for backward compatibility
  }

  /// Called when token expires - triggers cleanup
  void _onTokenExpired() {
    // Clear stored tokens - auth repository will handle logout
    _secureStorage.clearTokens();
  }

  /// Handle Dio errors and convert to Exception
  Exception handleError(dynamic error) {
    if (error is DioException) {
      String message;

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          message = 'Connection timeout. Please check your internet connection.';
          break;
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final errorData = error.response?.data;

          if (statusCode == 401) {
            message = errorData?['message'] ?? 'Invalid credentials';
          } else if (statusCode == 409) {
            message = errorData?['message'] ?? 'User already exists';
          } else if (statusCode == 400) {
            final errors = errorData?['errors'];
            if (errors != null && errors is List && errors.isNotEmpty) {
              message = errors[0]['msg'] ?? 'Validation error';
            } else {
              message = errorData?['message'] ?? 'Invalid request';
            }
          } else if (statusCode == 404) {
            message = errorData?['message'] ?? 'Resource not found';
          } else if (statusCode == 500) {
            message = errorData?['message'] ?? 'Server error. Please try again later.';
          } else {
            message = errorData?['message'] ?? 'An error occurred (Status: $statusCode)';
          }
          break;
        case DioExceptionType.cancel:
          message = 'Request was cancelled';
          break;
        case DioExceptionType.connectionError:
          message = 'No internet connection';
          break;
        default:
          message = 'An unexpected error occurred';
      }

      return Exception(message);
    }

    if (error is Exception) {
      return error;
    }

    return Exception('Unknown error occurred');
  }
}
