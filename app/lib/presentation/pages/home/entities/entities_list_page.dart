import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/entity_providers.dart';
import '../../../../data/models/entity_model.dart';

class EntitiesListPage extends ConsumerStatefulWidget {
  const EntitiesListPage({super.key});

  @override
  ConsumerState<EntitiesListPage> createState() => _EntitiesListPageState();
}

class _EntitiesListPageState extends ConsumerState<EntitiesListPage> {
  @override
  void initState() {
    super.initState();
    // Load entities when page initializes
    Future.microtask(() {
      ref.read(entitiesProvider.notifier).loadEntities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final entitiesState = ref.watch(entitiesProvider);
    final filteredEntities = entitiesState.filteredEntities;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Links'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: EntitySearchDelegate(ref),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tags filter chips
          if (entitiesState.allTags.isNotEmpty)
            _buildTagsFilter(entitiesState),

          // Entities list
          Expanded(
            child: _buildEntitiesList(entitiesState, filteredEntities),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/add-entity');
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Link'),
      ),
    );
  }

  Widget _buildTagsFilter(EntitiesState state) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Clear filters button
          if (state.selectedTags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: const Text('Clear'),
                selected: false,
                onSelected: (_) {
                  ref.read(entitiesProvider.notifier).clearTagFilters();
                },
                avatar: const Icon(Icons.clear, size: 18),
              ),
            ),
          // Tag chips
          ...state.allTags.map((tag) {
            final isSelected = state.selectedTags.contains(tag);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (_) {
                  ref.read(entitiesProvider.notifier).toggleTagFilter(tag);
                },
                selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                checkmarkColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEntitiesList(EntitiesState state, List<EntityModel> entities) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              state.error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(entitiesProvider.notifier).loadEntities();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (entities.isEmpty) {
      final hasFilters = state.selectedTags.isNotEmpty || state.searchQuery.isNotEmpty;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasFilters ? Icons.search_off : Icons.bookmark_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              hasFilters ? 'No matching links' : 'No links yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 8),
            if (!hasFilters)
              Text(
                'Tap + to add your first link',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(entitiesProvider.notifier).loadEntities();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: entities.length,
        itemBuilder: (context, index) {
          final entity = entities[index];
          return _EntityCard(entity: entity);
        },
      ),
    );
  }
}

class _EntityCard extends ConsumerWidget {
  final EntityModel entity;

  const _EntityCard({required this.entity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          context.push('/entities/${entity.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status icon and title
              Row(
                children: [
                  Icon(
                    entity.isProcessed
                        ? Icons.check_circle
                        : entity.isProcessing
                            ? Icons.pending
                            : Icons.error_outline,
                    size: 20,
                    color: entity.isProcessed
                        ? Colors.green
                        : entity.isProcessing
                            ? Colors.orange
                            : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entity.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // URL
              Text(
                entity.url,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.blue,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Description or summary
              Text(
                entity.displaySummary,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Tags
              if (entity.displayTags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: entity.displayTags.take(3).map((tag) {
                    return Chip(
                      label: Text(
                        tag,
                        style: const TextStyle(fontSize: 12),
                      ),
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class EntitySearchDelegate extends SearchDelegate<String> {
  final WidgetRef ref;

  EntitySearchDelegate(this.ref);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          ref.read(entitiesProvider.notifier).clearSearchQuery();
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Delay state update to avoid modifying provider during build
    Future.microtask(() {
      ref.read(entitiesProvider.notifier).setSearchQuery(query);
    });
    final entitiesState = ref.watch(entitiesProvider);
    final results = entitiesState.filteredEntities;

    if (results.isEmpty) {
      return const Center(
        child: Text('No results found'),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final entity = results[index];
        return _EntityCard(entity: entity);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Delay state update to avoid modifying provider during build
    Future.microtask(() {
      ref.read(entitiesProvider.notifier).setSearchQuery(query);
    });
    final entitiesState = ref.watch(entitiesProvider);
    final suggestions = entitiesState.filteredEntities;

    if (suggestions.isEmpty) {
      return const Center(
        child: Text('No suggestions'),
      );
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final entity = suggestions[index];
        return _EntityCard(entity: entity);
      },
    );
  }
}
