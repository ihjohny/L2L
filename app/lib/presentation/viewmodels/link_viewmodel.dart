import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/link_repository.dart';
import '../../../data/models/link_model.dart';
import '../../../core/utils/navigation_triggers.dart';
import 'link_state.dart';

/// ViewModel for link-related operations.
///
/// Manages links list, link detail, create, update, delete, and filtering.
class LinkViewModel extends StateNotifier<LinkState> {
  final LinkRepository _linkRepository;

  LinkViewModel(this._linkRepository) : super(LinkState.initial()) {
    loadLinks();
  }

  /// Load all links.
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

  /// Set form URL field.
  void setFormUrl(String url) {
    state = state.copyWith(formUrl: url, error: null);
  }

  /// Set form title field.
  void setFormTitle(String title) {
    state = state.copyWith(formTitle: title, error: null);
  }

  /// Set form tags field.
  void setFormTags(String tags) {
    state = state.copyWith(formTags: tags, error: null);
  }

  /// Set form project ID.
  void setFormProjectId(String? projectId) {
    state = state.copyWith(formProjectId: projectId, error: null);
  }

  /// Prepare form for editing a link.
  void prepareEditLink(String linkId) {
    final link = state.getLinkById(linkId);
    if (link != null) {
      state = state.copyWith(
        editingLinkId: linkId,
        formUrl: link.url,
        formTitle: link.title ?? '',
        formTags: link.tags.join(', '),
        formProjectId: link.projectId,
      );
    }
  }

  /// Clear form state.
  void clearForm() {
    state = state.copyWith(
      editingLinkId: null,
      formUrl: '',
      formTitle: '',
      formTags: '',
      formProjectId: null,
    );
  }

  /// Create a new link.
  Future<void> createLink() async {
    if (!state.canSaveLink) return;

    state = state.copyWith(isLoading: true, error: null);

    // Parse tags
    final tags = state.formTags
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final result = await _linkRepository.createLink(
      url: state.formUrl,
      title: state.formTitle.isEmpty ? null : state.formTitle,
      projectId: state.formProjectId,
      tags: tags.isEmpty ? null : tags,
    );

    if (!mounted) return;
    result.fold(
      (newLink) {
        state = state.copyWith(
          links: [...state.links, newLink],
          isLoading: false,
          navigationTrigger: LinkNavigationTrigger.toLinksList,
        );
        _applyFilters();
        clearForm();
      },
      (error) {
        state = state.copyWith(
          isLoading: false,
          error: error,
        );
      },
    );
  }

  /// Update an existing link.
  Future<void> updateLink() async {
    if (!state.canSaveLink || !state.isEditing) return;

    state = state.copyWith(isLoading: true, error: null);

    // Parse tags
    final tags = state.formTags
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final result = await _linkRepository.updateLink(
      linkId: state.editingLinkId!,
      title: state.formTitle.isEmpty ? null : state.formTitle,
      tags: tags.isEmpty ? null : tags,
    );

    if (!mounted) return;
    result.fold(
      (updatedLink) {
        state = state.copyWith(
          links: state.links.map((l) {
            return l.id == updatedLink.id ? updatedLink : l;
          }).toList(),
          selectedLink: updatedLink,
          isLoading: false,
          navigationTrigger: LinkNavigationTrigger.toLinkDetail,
        );
        _applyFilters();
        clearForm();
      },
      (error) {
        state = state.copyWith(
          isLoading: false,
          error: error,
        );
      },
    );
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
          selectedLink: null,
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

  /// Select a link for detail view.
  void selectLink(String linkId) {
    final link = state.getLinkById(linkId);
    state = state.copyWith(selectedLink: link);
  }

  /// Clear selected link.
  void clearSelectedLink() {
    state = state.copyWith(selectedLink: null);
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

/// Provider for LinkViewModel.
final linkViewModelProvider = StateNotifierProvider<LinkViewModel, LinkState>((ref) {
  final repository = ref.watch(linkRepositoryProvider);
  return LinkViewModel(repository);
});
