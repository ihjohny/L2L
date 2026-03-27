import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/link_model.dart';
import '../../data/services/link_service.dart';

// Link Service Provider
final linkServiceProvider = Provider<LinkService>((ref) {
  return LinkService();
});

// Links State
class LinksState {
  final List<LinkModel> links;
  final bool isLoading;
  final String? error;
  final Set<String> selectedTags;
  final String? selectedProjectId;
  final String searchQuery;

  LinksState({
    this.links = const [],
    this.isLoading = false,
    this.error,
    this.selectedTags = const {},
    this.selectedProjectId,
    this.searchQuery = '',
  });

  LinksState copyWith({
    List<LinkModel>? links,
    bool? isLoading,
    String? error,
    Set<String>? selectedTags,
    String? selectedProjectId,
    String? searchQuery,
  }) {
    return LinksState(
      links: links ?? this.links,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedTags: selectedTags ?? this.selectedTags,
      selectedProjectId: selectedProjectId ?? this.selectedProjectId,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  // Get filtered links based on selected tags, project, and search query
  List<LinkModel> get filteredLinks {
    var filtered = links;

    // Filter by project
    if (selectedProjectId != null) {
      filtered = filtered
          .where((l) => l.projectId == selectedProjectId)
          .toList();
    }

    // Filter by tags
    if (selectedTags.isNotEmpty) {
      filtered = filtered
          .where((l) => l.tags.any((tag) => selectedTags.contains(tag)))
          .toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered
          .where((l) =>
              l.displayTitle.toLowerCase().contains(query) ||
              l.displaySummary.toLowerCase().contains(query))
          .toList();
    }

    return filtered;
  }

  // Get all unique tags from links
  Set<String> get allTags {
    return links.expand((l) => l.tags).toSet();
  }
}

// Links StateNotifier
class LinksNotifier extends StateNotifier<LinksState> {
  final LinkService _linkService;

  LinksNotifier(this._linkService) : super(LinksState()) {
    loadLinks();
  }

  // Load all links for the user
  Future<void> loadLinks({
    String? projectId,
    List<String>? tags,
    String? search,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final links = await _linkService.getLinks(
        projectId: projectId,
        tags: tags,
        search: search,
      );
      state = LinksState(
        links: links,
        isLoading: false,
        selectedProjectId: projectId,
        selectedTags: tags?.toSet() ?? state.selectedTags,
        searchQuery: search ?? state.searchQuery,
      );
    } catch (e) {
      state = LinksState(
        links: state.links,
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
        selectedProjectId: state.selectedProjectId,
        selectedTags: state.selectedTags,
        searchQuery: state.searchQuery,
      );
    }
  }

  // Add link
  Future<LinkModel?> addLink({
    required String url,
    String? title,
    String? projectId,
    List<String>? tags,
  }) async {
    try {
      final newLink = await _linkService.createLink(
        url: url,
        title: title,
        projectId: projectId,
        tags: tags,
      );
      state = state.copyWith(
        links: [...state.links, newLink],
      );
      return newLink;
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceAll('Exception: ', ''));
      return null;
    }
  }

  // Update link
  Future<void> updateLink({
    required String linkId,
    String? title,
    List<String>? tags,
  }) async {
    try {
      final updatedLink = await _linkService.updateLink(
        linkId: linkId,
        title: title,
        tags: tags,
      );
      state = state.copyWith(
        links: state.links.map((l) {
          return l.id == updatedLink.id ? updatedLink : l;
        }).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Delete link
  Future<void> deleteLink(String linkId) async {
    try {
      await _linkService.deleteLink(linkId);
      state = state.copyWith(
        links: state.links.where((l) => l.id != linkId).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Toggle tag filter
  void toggleTagFilter(String tag) {
    final newTags = Set<String>.from(state.selectedTags);
    if (newTags.contains(tag)) {
      newTags.remove(tag);
    } else {
      newTags.add(tag);
    }
    state = state.copyWith(selectedTags: newTags);
  }

  // Set project filter
  void setProjectFilter(String? projectId) {
    state = state.copyWith(selectedProjectId: projectId);
  }

  // Clear tag filters
  void clearTagFilters() {
    state = state.copyWith(selectedTags: {});
  }

  // Set search query
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  // Clear search query
  void clearSearchQuery() {
    state = state.copyWith(searchQuery: '');
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Links Provider
final linksProvider = StateNotifierProvider<LinksNotifier, LinksState>((ref) {
  final service = ref.watch(linkServiceProvider);
  return LinksNotifier(service);
});

// Get link by id
final linkByIdProvider = Provider.family<LinkModel?, String>((ref, linkId) {
  final linksState = ref.watch(linksProvider);
  try {
    return linksState.links.firstWhere((l) => l.id == linkId);
  } catch (_) {
    return null;
  }
});
