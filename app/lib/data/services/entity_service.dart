import '../../core/network/dio_client.dart';
import '../models/entity_model.dart';

class EntityService {
  final DioClient _dioClient = DioClient.instance;

  /// Create a new bookmark/entity
  Future<EntityModel> createEntity({
    required String url,
    List<String>? tags,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        '/content/entities',
        data: {
          'url': url,
          if (tags != null) 'tags': tags,
        },
      );

      if (response.statusCode == 201) {
        return EntityModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to create entity');
    } catch (e) {
      throw _dioClient.handleError(e);
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

      final response = await _dioClient.dio.get(
        '/content/entities',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => EntityModel.fromJson(json)).toList();
      }
      throw Exception('Failed to fetch entities');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Get a single entity by ID
  Future<EntityModel> getEntityById(String entityId) async {
    try {
      final response = await _dioClient.dio.get('/content/entities/$entityId');

      if (response.statusCode == 200) {
        return EntityModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to fetch entity');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Update entity (rating)
  Future<EntityModel> updateEntity({
    required String entityId,
    String? title,
    String? description,
    List<String>? tags,
    int? rating,
  }) async {
    try {
      final response = await _dioClient.dio.put(
        '/content/entities/$entityId',
        data: {
          if (title != null) 'title': title,
          if (description != null) 'description': description,
          if (tags != null) 'tags': tags,
          if (rating != null) 'rating': rating,
        },
      );

      if (response.statusCode == 200) {
        return EntityModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to update entity');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Delete an entity
  Future<void> deleteEntity(String entityId) async {
    try {
      final response = await _dioClient.dio.delete('/content/entities/$entityId');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete entity');
      }
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Mark entity as read
  Future<EntityModel> markAsRead(String entityId) async {
    try {
      final response = await _dioClient.dio.post('/content/entities/$entityId/read');

      if (response.statusCode == 200) {
        return EntityModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to mark as read');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Toggle entity favorite status
  Future<EntityModel> toggleFavorite(String entityId) async {
    try {
      final response = await _dioClient.dio.post('/content/entities/$entityId/favorite');

      if (response.statusCode == 200) {
        return EntityModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to toggle favorite');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Re-process entity with AI
  Future<EntityModel> reprocessEntity(String entityId) async {
    try {
      final response = await _dioClient.dio.post('/content/entities/$entityId/reprocess');

      if (response.statusCode == 200) {
        return EntityModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to reprocess entity');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Update entity tags (with AI enhancement)
  Future<EntityModel> updateTags(String entityId, List<String> tags) async {
    try {
      final response = await _dioClient.dio.put(
        '/content/entities/$entityId/tags',
        data: {'tags': tags},
      );

      if (response.statusCode == 200) {
        return EntityModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to update tags');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }
}
