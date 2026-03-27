import '../../core/network/dio_client.dart';
import '../models/link_model.dart';

class LinkService {
  final DioClient _dioClient = DioClient.instance;

  /// Create a new link
  Future<LinkModel> createLink({
    required String url,
    String? projectId,
    List<String>? tags,
    String? title,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        '/links',
        data: {
          'url': url,
          if (projectId != null) 'projectId': projectId,
          if (tags != null) 'tags': tags,
          if (title != null) 'title': title,
        },
      );

      if (response.statusCode == 201) {
        return LinkModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to create link');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Get all links for the user
  Future<List<LinkModel>> getLinks({
    int page = 1,
    int limit = 50,
    String? projectId,
    List<String>? tags,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};
      if (projectId != null) {
        queryParams['projectId'] = projectId;
      }
      if (tags != null && tags.isNotEmpty) {
        queryParams['tags'] = tags.join(',');
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _dioClient.dio.get(
        '/links',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => LinkModel.fromJson(json)).toList();
      }
      throw Exception('Failed to fetch links');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Get a single link by ID
  Future<LinkModel> getLinkById(String linkId) async {
    try {
      final response = await _dioClient.dio.get('/links/$linkId');

      if (response.statusCode == 200) {
        return LinkModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to fetch link');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Update link
  Future<LinkModel> updateLink({
    required String linkId,
    String? title,
    List<String>? tags,
  }) async {
    try {
      final response = await _dioClient.dio.put(
        '/links/$linkId',
        data: {
          if (title != null) 'title': title,
          if (tags != null) 'tags': tags,
        },
      );

      if (response.statusCode == 200) {
        return LinkModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to update link');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Delete a link
  Future<void> deleteLink(String linkId) async {
    try {
      final response = await _dioClient.dio.delete('/links/$linkId');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete link');
      }
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }
}
