import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../presentation/viewmodels/link_list_viewmodel.dart';
import '../../../presentation/viewmodels/link_list_state.dart';
import '../../../data/models/link_model.dart';
import '../../widgets/link_card.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(linkListViewModelProvider.notifier).loadLinks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final linksState = ref.watch(linkListViewModelProvider);
    final filteredLinks = linksState.displayLinks;

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
    );
  }

  Widget _buildTagsFilter(LinkListState state) {
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
                  ref.read(linkListViewModelProvider.notifier).clearTagFilters();
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
                  ref.read(linkListViewModelProvider.notifier).toggleTagFilter(tag);
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

  Widget _buildLinksList(LinkListState state, List<LinkModel> links) {
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
                ref.read(linkListViewModelProvider.notifier).loadLinks();
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
        await ref.read(linkListViewModelProvider.notifier).loadLinks();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: links.length,
        itemBuilder: (context, index) {
          final link = links[index];
          return LinkCard(link: link);
        },
      ),
    );
  }
}

class LinkSearchDelegate extends SearchDelegate<String> {
  final WidgetRef ref;

  LinkSearchDelegate(this.ref);

  @override
  void close(BuildContext context, String result) {
    // Clear search query when closing search
    ref.read(linkListViewModelProvider.notifier).clearSearchQuery();
    super.close(context, result);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          ref.read(linkListViewModelProvider.notifier).clearSearchQuery();
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
      ref.read(linkListViewModelProvider.notifier).setSearchQuery(query);
    });
    final linksState = ref.watch(linkListViewModelProvider);
    final results = linksState.displayLinks;

    if (results.isEmpty) {
      return const Center(
        child: Text('No results found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final link = results[index];
        return LinkCard(link: link);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Delay state update to avoid modifying provider during build
    Future.microtask(() {
      ref.read(linkListViewModelProvider.notifier).setSearchQuery(query);
    });
    final linksState = ref.watch(linkListViewModelProvider);
    final suggestions = linksState.displayLinks;

    if (suggestions.isEmpty) {
      return const Center(
        child: Text('No suggestions'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final link = suggestions[index];
        return LinkCard(link: link);
      },
    );
  }
}
