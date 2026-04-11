import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/link_repository.dart';
import '../../../../data/models/link_model.dart';
import '../../../../core/utils/navigation_triggers.dart';
import 'link_list_state.dart';

/// ViewModel for link list operations.
///
/// Manages links list with filtering by tags and search.
/// Does NOT include AI output data (lightweight list fetching).
class LinkListViewModel extends StateNotifier<LinkListState> {
  final LinkRepository _linkRepository;

  LinkListViewModel(this._linkRepository) : super(LinkListState.initial());

  /// Load all links (lightweight - no AI output).
  Future<void> loadLinks() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _linkRepository.getLinks();
    if (!mounted) return;
    result.fold(
      (links) {
        state = state.copyWith(
          links: links,
          isLoading: false,
        );
        _applyFilters();
      },
      (error) {
        state = state.copyWith(
          isLoading: false,
          error: error,
        );
      },
    );
  }

  /// Toggle tag filter.
  void toggleTagFilter(String tag) {
    final newTags = Set<String>.from(state.selectedTags);
    if (newTags.contains(tag)) {
      newTags.remove(tag);
    } else {
      newTags.add(tag);
    }
    state = state.copyWith(selectedTags: newTags);
    _applyFilters();
  }

  /// Clear tag filters.
  void clearTagFilters() {
    state = state.copyWith(selectedTags: {});
    _applyFilters();
  }

  /// Set search query.
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  /// Clear search query.
  void clearSearchQuery() {
    state = state.copyWith(searchQuery: '');
    _applyFilters();
  }

  /// Apply filters to links.
  void _applyFilters() {
    var filtered = state.links;

    // Filter by tags
    if (state.selectedTags.isNotEmpty) {
      filtered = filtered
          .where((l) => l.tags.any((tag) => state.selectedTags.contains(tag)))
          .toList();
    }

    // Filter by search query
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered
          .where((l) =>
              _extractTitle(l).toLowerCase().contains(query) ||
              _extractSummary(l).toLowerCase().contains(query))
          .toList();
    }

    state = state.copyWith(filteredLinks: filtered);
  }

  /// Set link ID for deletion (shows confirmation dialog).
  void setDeleteLinkId(String? linkId) {
    state = state.copyWith(deleteLinkId: linkId);
  }

  /// Delete a link.
  Future<void> deleteLink(String linkId) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _linkRepository.deleteLink(linkId);

    if (!mounted) return;
    result.fold(
      (_) {
        state = state.copyWith(
          links: state.links.where((l) => l.id != linkId).toList(),
          deleteLinkId: null,
          isLoading: false,
          navigationTrigger: LinkNavigationTrigger.toLinksList,
        );
        _applyFilters();
      },
      (error) {
        state = state.copyWith(
          isLoading: false,
          error: error,
        );
      },
    );
  }

  /// Clear error.
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Reset navigation trigger.
  void resetNavigationTrigger() {
    state = state.copyWith(navigationTrigger: LinkNavigationTrigger.none);
  }

  /// Extract title from link for display.
  String _extractTitle(LinkModel link) {
    return link.title ?? _extractDomain(link.url);
  }

  /// Extract summary from link for display.
  String _extractSummary(LinkModel link) {
    return link.summary?.mainArgument ?? 'Processing...';
  }

  /// Extract domain from URL.
  String _extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.replaceAll('www.', '');
    } catch (_) {
      return url;
    }
  }
}

/// Provider for LinkListViewModel.
final linkListViewModelProvider =
    StateNotifierProvider<LinkListViewModel, LinkListState>((ref) {
  final repository = ref.watch(linkRepositoryProvider);
  return LinkListViewModel(repository);
});
