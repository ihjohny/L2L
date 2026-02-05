import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/env_config.dart';

class DioClient {
  static DioClient? _instance;
  late final Dio _dio;
  String? _accessToken;

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
      onRequest: (options, handler) {
        if (_accessToken != null) {
          options.headers['Authorization'] = 'Bearer $_accessToken';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Handle unauthorized - token expired
          // Could trigger token refresh here
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

  /// Set authentication token
  void setAuthToken(String? token) {
    _accessToken = token;
  }

  /// Clear authentication token
  void clearAuthToken() {
    _accessToken = null;
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
          } else {
            message = errorData?['message'] ?? 'An error occurred';
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
