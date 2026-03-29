import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../providers/link_providers.dart';
import '../../../../data/models/link_model.dart';

class RecentLinksSection extends ConsumerWidget {
  const RecentLinksSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linksState = ref.watch(linksProvider);
    final links = linksState.links;

    // Sort links by most recently added first
    final recentLinks = links
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Take only the most recent 10 links
    final displayLinks = recentLinks.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Saved Links',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () => context.push('/links'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Vertical List
        if (linksState.isLoading && displayLinks.isEmpty)
          const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (displayLinks.isEmpty)
          _buildEmptyState(context)
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayLinks.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final link = displayLinks[index];
              return _LinkCard(link: link);
            },
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.bookmark_outline, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'No links yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to save your first link',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  final LinkModel link;

  const _LinkCard({required this.link});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => context.push('/links/${link.id}'),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Status Row
              Row(
                children: [
                  Icon(
                    _getStatusIcon(link),
                    size: 20,
                    color: _getStatusColor(link),
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
              // Summary/Description
              Text(
                link.displaySummary,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700],
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // Tags (if any)
              if (link.displayTags.isNotEmpty) ...[
                const SizedBox(height: 8),
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
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon(LinkModel link) {
    if (link.isProcessed) {
      return Icons.check_circle;
    } else if (link.isProcessing) {
      return Icons.pending;
    } else {
      return Icons.error_outline;
    }
  }

  Color _getStatusColor(LinkModel link) {
    if (link.isProcessed) {
      return Colors.green;
    } else if (link.isProcessing) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
