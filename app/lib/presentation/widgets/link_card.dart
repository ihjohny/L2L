import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/link_model.dart';

/// An elegant card widget for displaying link information.
/// Used across the app to show link previews with consistent styling.
class LinkCard extends StatelessWidget {
  final LinkModel link;
  final VoidCallback? onTap;
  final bool showTags;

  const LinkCard({
    super.key,
    required this.link,
    this.onTap,
    this.showTags = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[50],
      child: InkWell(
        onTap: onTap ?? () => context.push('/links/${link.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status icon and title row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status icon with subtle background
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _getStatusColor(link.status).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getStatusIcon(link.status),
                      color: _getStatusColor(link.status),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title and host
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          link.displayTitle,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Host/URL
                        Text(
                          _extractHost(link.url),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w500,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Tags and timestamp row
              if (showTags && link.displayTags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Tags on the left
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: link.displayTags.take(5).map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    // Timestamp on the right
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatRelativeTime(link.createdAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[500],
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ] else ...[
                // Just timestamp if no tags
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatRelativeTime(link.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon(LinkStatus status) {
    switch (status) {
      case LinkStatus.pending:
        return Icons.schedule;
      case LinkStatus.processing:
        return Icons.autorenew;
      case LinkStatus.completed:
        return Icons.check_circle;
      case LinkStatus.failed:
        return Icons.error_outline;
    }
  }

  Color _getStatusColor(LinkStatus status) {
    switch (status) {
      case LinkStatus.pending:
        return Colors.orange;
      case LinkStatus.processing:
        return Colors.blue;
      case LinkStatus.completed:
        return Colors.green;
      case LinkStatus.failed:
        return Colors.red;
    }
  }

  String _extractHost(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.replaceAll('www.', '');
    } catch (_) {
      return url;
    }
  }

  String _formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      final mins = difference.inMinutes;
      return '$mins ${mins == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inDays < 1) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
