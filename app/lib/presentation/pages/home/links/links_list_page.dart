import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../providers/link_providers.dart';
import '../../../../data/models/link_model.dart';

class LinksListPage extends ConsumerStatefulWidget {
  const LinksListPage({super.key});

  @override
  ConsumerState<LinksListPage> createState() => _LinksListPageState();
}

class _LinksListPageState extends ConsumerState<LinksListPage> {
  @override
  void initState() {
    super.initState();
    // Load links when page initializes
    Future.microtask(() {
      ref.read(linksProvider.notifier).loadLinks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final linksState = ref.watch(linksProvider);
    final filteredLinks = linksState.filteredLinks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Links'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: LinkSearchDelegate(ref),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tags filter chips
          if (linksState.allTags.isNotEmpty)
            _buildTagsFilter(linksState),

          // Links list
          Expanded(
            child: _buildLinksList(linksState, filteredLinks),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/add-link');
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Link'),
      ),
    );
  }

  Widget _buildTagsFilter(LinksState state) {
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
                  ref.read(linksProvider.notifier).clearTagFilters();
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
                  ref.read(linksProvider.notifier).toggleTagFilter(tag);
                },
                selectedColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.2),
                checkmarkColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLinksList(LinksState state, List<LinkModel> links) {
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
                ref.read(linksProvider.notifier).loadLinks();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (links.isEmpty) {
      final hasFilters =
          state.selectedTags.isNotEmpty || state.searchQuery.isNotEmpty;
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
                'Tap + to save your first link',
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
        await ref.read(linksProvider.notifier).loadLinks();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: links.length,
        itemBuilder: (context, index) {
          final link = links[index];
          return _LinkCard(link: link);
        },
      ),
    );
  }
}

class _LinkCard extends ConsumerWidget {
  final LinkModel link;

  const _LinkCard({required this.link});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          context.push('/links/${link.id}');
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
                    link.isProcessed
                        ? Icons.check_circle
                        : link.isProcessing
                            ? Icons.pending
                            : Icons.error_outline,
                    size: 20,
                    color: link.isProcessed
                        ? Colors.green
                        : link.isProcessing
                            ? Colors.orange
                            : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      link.displayTitle,
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
                link.url,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.blue,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Description or summary
              Text(
                link.displaySummary,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Tags
              if (link.displayTags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: link.displayTags.take(3).map((tag) {
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

class LinkSearchDelegate extends SearchDelegate<String> {
  final WidgetRef ref;

  LinkSearchDelegate(this.ref);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          ref.read(linksProvider.notifier).clearSearchQuery();
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
      ref.read(linksProvider.notifier).setSearchQuery(query);
    });
    final linksState = ref.watch(linksProvider);
    final results = linksState.filteredLinks;

    if (results.isEmpty) {
      return const Center(
        child: Text('No results found'),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final link = results[index];
        return _LinkCard(link: link);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Delay state update to avoid modifying provider during build
    Future.microtask(() {
      ref.read(linksProvider.notifier).setSearchQuery(query);
    });
    final linksState = ref.watch(linksProvider);
    final suggestions = linksState.filteredLinks;

    if (suggestions.isEmpty) {
      return const Center(
        child: Text('No suggestions'),
      );
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final link = suggestions[index];
        return _LinkCard(link: link);
      },
    );
  }
}
