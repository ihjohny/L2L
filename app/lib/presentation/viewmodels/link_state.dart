import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/link_model.dart';
import '../../../core/utils/navigation_triggers.dart';

part 'link_state.freezed.dart';

/// Immutable state for the LinkViewModel.
@freezed
class LinkState with _$LinkState {
  const factory LinkState({
    /// List of all links
    @Default([]) List<LinkModel> links,

    /// Selected link for detail view
    LinkModel? selectedLink,

    /// Filtered links based on search and tags
    List<LinkModel>? filteredLinks,

    /// Whether the ViewModel is currently loading
    @Default(false) bool isLoading,

    /// Error message from the last failed operation
    String? error,

    /// Navigation trigger for the UI to consume
    @Default(LinkNavigationTrigger.none) LinkNavigationTrigger navigationTrigger,

    /// Form state for add/edit link
    String? editingLinkId,
    @Default('') String formUrl,
    @Default('') String formTitle,
    @Default('') String formTags,
    String? formProjectId,

    /// Filter state
    @Default({}) Set<String> selectedTags,
    @Default('') String searchQuery,
  }) = _LinkState;

  /// Initial state
  factory LinkState.initial() => const LinkState(
        links: [],
        selectedLink: null,
        filteredLinks: null,
        isLoading: true, // Start loading to fetch links
        error: null,
        navigationTrigger: LinkNavigationTrigger.none,
      );
}

/// Extension methods for LinkState.
extension LinkStateX on LinkState {
  /// Whether links are loaded
  bool get hasLinks => links.isNotEmpty;

  /// Get links to display (filtered or all)
  List<LinkModel> get displayLinks => filteredLinks ?? links;

  /// Whether the form is valid for save
  bool get canSaveLink => !isLoading && formUrl.isNotEmpty;

  /// Whether currently editing a link
  bool get isEditing => editingLinkId != null;

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
