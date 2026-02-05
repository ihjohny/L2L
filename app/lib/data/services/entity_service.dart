import 'package:dio/dio.dart';
import '../../core/config/env_config.dart';
import '../models/entity_model.dart';

class EntityService {
  late final Dio _dio;

  EntityService() {
    _dio = Dio(BaseOptions(
      baseUrl: EnvConfig.apiPath,
      connectTimeout: Duration(milliseconds: EnvConfig.connectTimeout),
      receiveTimeout: Duration(milliseconds: EnvConfig.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
  }

  /// Set authentication token
  void setAuthToken(String? token) {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  /// Create a new bookmark/entity
  Future<EntityModel> createEntity({
    required String url,
    List<String>? tags,
    String? notes,
  }) async {
    try {
      final response = await _dio.post(
        '/content/entities',
        data: {
          'url': url,
          if (tags != null) 'tags': tags,
          if (notes != null) 'notes': notes,
        },
      );

      if (response.statusCode == 201) {
        return EntityModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to create entity');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all entities for the user with optional filters
  Future<List<EntityModel>> getEntities({
    int page = 1,
    int limit = 50,
    List<String>? tags,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};
      if (tags != null && tags.isNotEmpty) {
        queryParams['tags'] = tags.join(',');
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _dio.get(
        '/content/entities',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => EntityModel.fromJson(json)).toList();
      }
      throw Exception('Failed to fetch entities');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a single entity by ID
  Future<EntityModel> getEntityById(String entityId) async {
    try {
      final response = await _dio.get('/content/entities/$entityId');

      if (response.statusCode == 200) {
        return EntityModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to fetch entity');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Update entity (notes, rating)
  Future<EntityModel> updateEntity({
    required String entityId,
    String? title,
    String? description,
    List<String>? tags,
    String? notes,
    int? rating,
  }) async {
    try {
      final response = await _dio.put(
        '/content/entities/$entityId',
        data: {
          if (title != null) 'title': title,
          if (description != null) 'description': description,
          if (tags != null) 'tags': tags,
          if (notes != null) 'notes': notes,
          if (rating != null) 'rating': rating,
        },
      );

      if (response.statusCode == 200) {
        return EntityModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to update entity');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete an entity
  Future<void> deleteEntity(String entityId) async {
    try {
      final response = await _dio.delete('/content/entities/$entityId');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete entity');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Mark entity as read
  Future<EntityModel> markAsRead(String entityId) async {
    try {
      final response = await _dio.post('/content/entities/$entityId/read');

      if (response.statusCode == 200) {
        return EntityModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to mark as read');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Toggle entity favorite status
  Future<EntityModel> toggleFavorite(String entityId) async {
    try {
      final response = await _dio.post('/content/entities/$entityId/favorite');

      if (response.statusCode == 200) {
        return EntityModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to toggle favorite');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Re-process entity with AI
  Future<EntityModel> reprocessEntity(String entityId) async {
    try {
      final response = await _dio.post('/content/entities/$entityId/reprocess');

      if (response.statusCode == 200) {
        return EntityModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to reprocess entity');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Update entity tags (with AI enhancement)
  Future<EntityModel> updateTags(String entityId, List<String> tags) async {
    try {
      final response = await _dio.put(
        '/content/entities/$entityId/tags',
        data: {'tags': tags},
      );

      if (response.statusCode == 200) {
        return EntityModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to update tags');
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      final message = error.response?.data?['message'] ?? error.message;
      return Exception('Network error: $message');
    }
    if (error is Exception) {
      return error;
    }
    return Exception('Unknown error occurred');
  }
}
