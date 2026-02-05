import 'package:flutter/material.dart';
import '../../../data/models/entity_model.dart';

class BookmarkCard extends StatelessWidget {
  final EntityModel bookmark;
  final VoidCallback? onDelete;
  final VoidCallback? onFavorite;
  final VoidCallback? onMarkRead;
  final VoidCallback? onTap;

  const BookmarkCard({
    super.key,
    required this.bookmark,
    this.onDelete,
    this.onFavorite,
    this.onMarkRead,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProcessing = bookmark.isProcessing;
    final isProcessed = bookmark.isProcessed;
    final isFailed = bookmark.isFailed;
    final isRead = bookmark.userInteractions.isRead;
    final isFavorite = bookmark.userInteractions.isFavorite;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isRead ? 0 : 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and actions
              Row(
                children: [
                  // Type icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getTypeIcon(bookmark.type),
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookmark.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                decoration: isRead ? TextDecoration.lineThrough : null,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bookmark.domain,
                          style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                  // Status indicator
                  if (isProcessing)
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else if (isFailed)
                    const Icon(Icons.error, color: Colors.red, size: 20)
                  else if (isProcessed)
                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  // Favorite button
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: onFavorite,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // AI Summary
              if (isProcessed && bookmark.displaySummary.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'AI Summary',
                            style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        bookmark.displaySummary,
                        style: theme.textTheme.bodySmall,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),

              // Tags
              if (bookmark.displayTags.isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: bookmark.displayTags.take(5).map((tag) {
                    return Chip(
                      label: Text(
                        tag,
                        style: theme.textTheme.labelSmall,
                      ),
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],

              // Footer with actions
              Row(
                children: [
                  // Difficulty badge
                  _buildDifficultyBadge(bookmark.processedContent?.difficulty, theme),
                  const SizedBox(width: 12),
                  // Reading time
                  if (bookmark.processedContent?.readingTime != null)
                    _buildReadingTime(bookmark.processedContent!.readingTime!, theme),
                  const Spacer(),
                  // Mark as read button
                  if (!isRead)
                    TextButton.icon(
                      onPressed: onMarkRead,
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('Mark Read'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  // Delete button
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: IconButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(ContentType type) {
    switch (type) {
      case ContentType.article:
        return Icons.article;
      case ContentType.video:
        return Icons.play_circle;
      case ContentType.podcast:
        return Icons.podcasts;
      case ContentType.document:
        return Icons.description;
      case ContentType.book:
        return Icons.menu_book;
    }
  }

  Widget _buildDifficultyBadge(DifficultyLevel? difficulty, ThemeData theme) {
    if (difficulty == null) return const SizedBox.shrink();

    Color color;
    switch (difficulty) {
      case DifficultyLevel.beginner:
        color = Colors.green;
        break;
      case DifficultyLevel.intermediate:
        color = Colors.orange;
        break;
      case DifficultyLevel.advanced:
        color = Colors.red;
        break;
      case DifficultyLevel.expert:
        color = Colors.purple;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        difficulty.name.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildReadingTime(int minutes, ThemeData theme) {
    return Row(
      children: [
        const Icon(Icons.schedule, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          '$minutes min',
          style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }
}
