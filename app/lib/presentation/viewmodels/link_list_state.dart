import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/link_model.dart';
import '../../../core/utils/navigation_triggers.dart';

part 'link_list_state.freezed.dart';

/// Immutable state for the LinkListViewModel.
@freezed
class LinkListState with _$LinkListState {
  const factory LinkListState({
    /// List of all links (without AI output - lightweight)
    @Default([]) List<LinkModel> links,

    /// Filtered links based on search and tags
    List<LinkModel>? filteredLinks,

    /// Whether the ViewModel is currently loading
    @Default(false) bool isLoading,

    /// Error message from the last failed operation
    String? error,

    /// Navigation trigger for the UI to consume
    @Default(LinkNavigationTrigger.none) LinkNavigationTrigger navigationTrigger,

    /// Filter state
    @Default({}) Set<String> selectedTags,
    @Default('') String searchQuery,

    /// Link ID to delete (for confirmation dialog)
    String? deleteLinkId,
  }) = _LinkListState;

  /// Initial state
  factory LinkListState.initial() => const LinkListState(
        links: [],
        filteredLinks: null,
        isLoading: true,
        error: null,
        navigationTrigger: LinkNavigationTrigger.none,
      );
}

/// Extension methods for LinkListState.
extension LinkListStateX on LinkListState {
  /// Whether links are loaded
  bool get hasLinks => links.isNotEmpty;

  /// Get links to display (filtered or all)
  List<LinkModel> get displayLinks => filteredLinks ?? links;

  /// Get all unique tags from links
  Set<String> get allTags {
    return links.expand((l) => l.tags).toSet();
  }

  /// Get link by ID from the list
  LinkModel? getLinkById(String id) {
    try {
      return links.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Whether search or filters are active
  bool get hasActiveFilters => selectedTags.isNotEmpty || searchQuery.isNotEmpty;
}
