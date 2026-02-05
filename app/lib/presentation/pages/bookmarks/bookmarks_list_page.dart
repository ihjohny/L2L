import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/services/entity_service.dart';
import '../../../data/models/entity_model.dart';
import 'bookmark_card.dart';
import 'add_bookmark_page.dart';

part 'bookmarks_list_page.g.dart';

@riverpod
class BookmarksListController extends _$BookmarksListController {
  final EntityService _entityService = EntityService();

  @override
  Future<List<EntityModel>> build(String projectId) async {
    return await _entityService.getEntitiesByProject(projectId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _entityService.getEntitiesByProject(projectId);
    });
  }

  Future<void> deleteBookmark(String entityId) async {
    await _entityService.deleteEntity(entityId);
    refresh();
  }

  Future<void> toggleFavorite(String entityId) async {
    await _entityService.toggleFavorite(entityId);
    refresh();
  }

  Future<void> markAsRead(String entityId) async {
    await _entityService.markAsRead(entityId);
    refresh();
  }
}

class BookmarksListPage extends ConsumerWidget {
  final String projectId;

  const BookmarksListPage({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksListControllerProvider(projectId));

    return Scaffold(
      body: bookmarksAsync.when(
        data: (bookmarks) {
          if (bookmarks.isEmpty) {
            return _buildEmptyState(context);
          }
          return RefreshIndicator(
            onRefresh: () => ref
                .read(bookmarksListControllerProvider(projectId).notifier)
                .refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                return BookmarkCard(
                  bookmark: bookmarks[index],
                  onDelete: () => _showDeleteDialog(context, ref, bookmarks[index]),
                  onFavorite: () => ref
                      .read(bookmarksListControllerProvider(projectId).notifier)
                      .toggleFavorite(bookmarks[index].id),
                  onMarkRead: () => ref
                      .read(bookmarksListControllerProvider(projectId).notifier)
                      .markAsRead(bookmarks[index].id),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading bookmarks',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(error.toString()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(bookmarksListControllerProvider(projectId).notifier)
                    .refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddBookmarkPage(projectId: projectId),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No bookmarks yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first bookmark to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddBookmarkPage(projectId: projectId),
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Bookmark'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    EntityModel bookmark,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Bookmark'),
        content: Text('Are you sure you want to delete "${bookmark.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(bookmarksListControllerProvider(projectId).notifier)
                  .deleteBookmark(bookmark.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bookmark deleted')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
