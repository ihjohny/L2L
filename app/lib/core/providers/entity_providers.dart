import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/entity_model.dart';
import '../../data/services/entity_service.dart';

// Entity Service Provider
final entityServiceProvider = Provider<EntityService>((ref) {
  return EntityService();
});

// Entities State
class EntitiesState {
  final List<EntityModel> entities;
  final bool isLoading;
  final String? error;
  final Set<String> selectedTags;
  final String searchQuery;

  EntitiesState({
    this.entities = const [],
    this.isLoading = false,
    this.error,
    this.selectedTags = const {},
    this.searchQuery = '',
  });

  EntitiesState copyWith({
    List<EntityModel>? entities,
    bool? isLoading,
    String? error,
    Set<String>? selectedTags,
    String? searchQuery,
  }) {
    return EntitiesState(
      entities: entities ?? this.entities,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedTags: selectedTags ?? this.selectedTags,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  // Get filtered entities based on selected tags and search query
  List<EntityModel> get filteredEntities {
    var filtered = entities;

    // Filter by tags
    if (selectedTags.isNotEmpty) {
      filtered = filtered
          .where((e) => e.tags.any((tag) => selectedTags.contains(tag)))
          .toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered
          .where((e) =>
              e.title.toLowerCase().contains(query) ||
              e.description.toLowerCase().contains(query) ||
              e.displaySummary.toLowerCase().contains(query))
          .toList();
    }

    return filtered;
  }

  // Get all unique tags from entities
  Set<String> get allTags {
    return entities.expand((e) => e.tags).toSet();
  }
}

// Entities StateNotifier for all user entities
class EntitiesNotifier extends StateNotifier<EntitiesState> {
  final EntityService _entityService;

  EntitiesNotifier(this._entityService) : super(EntitiesState()) {
    loadEntities();
  }

  // Load all entities for the user
  Future<void> loadEntities({List<String>? tags, String? search}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final entities = await _entityService.getEntities(
        tags: tags,
        search: search,
      );
      state = EntitiesState(
        entities: entities,
        isLoading: false,
        selectedTags: tags?.toSet() ?? state.selectedTags,
        searchQuery: search ?? state.searchQuery,
      );
    } catch (e) {
      state = EntitiesState(
        entities: state.entities,
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
        selectedTags: state.selectedTags,
        searchQuery: state.searchQuery,
      );
    }
  }

  // Add entity
  Future<EntityModel?> addEntity({
    required String url,
    List<String>? tags,
  }) async {
    try {
      final newEntity = await _entityService.createEntity(
        url: url,
        tags: tags,
      );
      state = state.copyWith(
        entities: [...state.entities, newEntity],
      );
      return newEntity;
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceAll('Exception: ', ''));
      return null;
    }
  }

  // Update entity
  Future<void> updateEntity({
    required String entityId,
    String? title,
    String? description,
    List<String>? tags,
    int? rating,
  }) async {
    try {
      final updatedEntity = await _entityService.updateEntity(
        entityId: entityId,
        title: title,
        description: description,
        tags: tags,
        rating: rating,
      );
      state = state.copyWith(
        entities: state.entities.map((e) {
          return e.id == updatedEntity.id ? updatedEntity : e;
        }).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Update entity tags
  Future<void> updateEntityTags(String entityId, List<String> tags) async {
    try {
      final updatedEntity = await _entityService.updateTags(entityId, tags);
      state = state.copyWith(
        entities: state.entities.map((e) {
          return e.id == updatedEntity.id ? updatedEntity : e;
        }).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Delete entity
  Future<void> deleteEntity(String entityId) async {
    try {
      await _entityService.deleteEntity(entityId);
      state = state.copyWith(
        entities: state.entities.where((e) => e.id != entityId).toList(),
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

// Entities Provider
final entitiesProvider = StateNotifierProvider<EntitiesNotifier, EntitiesState>((ref) {
  final service = ref.watch(entityServiceProvider);
  return EntitiesNotifier(service);
});

// Get entity by id
final entityByIdProvider = Provider.family<EntityModel?, String>((ref, entityId) {
  final entitiesState = ref.watch(entitiesProvider);
  try {
    return entitiesState.entities.firstWhere((e) => e.id == entityId);
  } catch (_) {
    return null;
  }
});
