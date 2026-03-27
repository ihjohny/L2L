import '../models/link_model.dart';
import '../services/link_service.dart';

class LinkRepository {
  final LinkService _linkService;

  LinkRepository({LinkService? linkService}) : _linkService = linkService ?? LinkService();

  /// Create a new link
  Future<LinkModel> createLink({
    required String url,
    String? projectId,
    List<String>? tags,
    String? title,
  }) async {
    return await _linkService.createLink(
      url: url,
      projectId: projectId,
      tags: tags,
      title: title,
    );
  }

  /// Get all links for the user
  Future<List<LinkModel>> getLinks({
    int page = 1,
    int limit = 50,
    String? projectId,
    List<String>? tags,
    String? search,
  }) async {
    return await _linkService.getLinks(
      page: page,
      limit: limit,
      projectId: projectId,
      tags: tags,
      search: search,
    );
  }

  /// Get a single link by ID
  Future<LinkModel> getLinkById(String linkId) async {
    return await _linkService.getLinkById(linkId);
  }

  /// Update link
  Future<LinkModel> updateLink({
    required String linkId,
    String? title,
    List<String>? tags,
  }) async {
    return await _linkService.updateLink(
      linkId: linkId,
      title: title,
      tags: tags,
    );
  }

  /// Delete a link
  Future<void> deleteLink(String linkId) async {
    await _linkService.deleteLink(linkId);
  }
}
