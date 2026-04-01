import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/link_model.dart';
import '../../data/services/link_service.dart';
import '../../core/utils/result.dart';

/// Provider for LinkRepository with dependency injection.
final linkRepositoryProvider = Provider<LinkRepository>((ref) {
  return LinkRepository(
    linkService: LinkService(),
  );
});

/// Repository for link operations.
///
/// Coordinates with LinkService for API calls.
class LinkRepository {
  final LinkService _linkService;

  LinkRepository({
    required LinkService linkService,
  }) : _linkService = linkService;

  /// Create a new link.
  Future<Result<LinkModel>> createLink({
    required String url,
    String? projectId,
    List<String>? tags,
    String? title,
  }) async {
    try {
      final link = await _linkService.createLink(
        url: url,
        projectId: projectId,
        tags: tags,
        title: title,
      );
      return Success(link);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Get all links for the user.
  Future<Result<List<LinkModel>>> getLinks({
    int page = 1,
    int limit = 50,
    String? projectId,
  }) async {
    try {
      final links = await _linkService.getLinks(
        page: page,
        limit: limit,
        projectId: projectId,
      );
      return Success(links);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Get a single link by ID.
  Future<Result<LinkModel>> getLinkById(String linkId) async {
    try {
      final link = await _linkService.getLinkById(linkId);
      return Success(link);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Update link.
  Future<Result<LinkModel>> updateLink({
    required String linkId,
    String? title,
    List<String>? tags,
  }) async {
    try {
      final link = await _linkService.updateLink(
        linkId: linkId,
        title: title,
        tags: tags,
      );
      return Success(link);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Delete a link.
  Future<Result<Unit>> deleteLink(String linkId) async {
    try {
      await _linkService.deleteLink(linkId);
      return const Success(Unit.value);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''));
    }
  }
}

/// A unit type for operations that don't return meaningful data.
class Unit {
  static const Unit value = Unit._();
  const Unit._();
}
