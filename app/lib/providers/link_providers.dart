import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/link_model.dart';
import '../../data/repositories/link_repository.dart';

// Link Repository Provider
final linkRepositoryProvider = Provider<LinkRepository>((ref) {
  return LinkRepository();
});

// Links State
class LinksState {
  final List<LinkModel> links;
  final bool isLoading;
  final String? error;
  final Set<String> selectedTags;
  final String searchQuery;

  LinksState({
    this.links = const [],
    this.isLoading = false,
    this.error,
    this.selectedTags = const {},
    this.searchQuery = '',
  });

  LinksState copyWith({
    List<LinkModel>? links,
    bool? isLoading,
    String? error,
    Set<String>? selectedTags,
    String? searchQuery,
  }) {
    return LinksState(
      links: links ?? this.links,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedTags: selectedTags ?? this.selectedTags,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  // Get filtered links based on selected tags and search query
  List<LinkModel> get filteredLinks {
    var filtered = links;

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
  final LinkRepository _linkRepository;

  LinksNotifier(this._linkRepository) : super(LinksState()) {
    loadLinks();
  }

  // Load all links for the user (always fetches all links, no filtering)
  Future<void> loadLinks() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final links = await _linkRepository.getLinks();
      state = LinksState(
        links: links,
        isLoading: false,
      );
    } catch (e) {
      state = LinksState(
        links: state.links,
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
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
      final newLink = await _linkRepository.createLink(
        url: url,
        projectId: projectId,
        tags: tags,
        title: title,
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
      final updatedLink = await _linkRepository.updateLink(
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
      await _linkRepository.deleteLink(linkId);
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
  final repository = ref.watch(linkRepositoryProvider);
  return LinksNotifier(repository);
});

// Project Links Provider - Family provider for project-specific links
// This keeps project links separate from the global links state
final projectLinksProvider = FutureProvider.family<List<LinkModel>, String>((ref, projectId) async {
  final repository = ref.watch(linkRepositoryProvider);
  return await repository.getLinks(projectId: projectId);
});

// Provider to fetch a single link by ID
final singleLinkProvider = FutureProvider.family<LinkModel, String>((ref, linkId) async {
  final repository = ref.watch(linkRepositoryProvider);
  return await repository.getLinkById(linkId);
});
