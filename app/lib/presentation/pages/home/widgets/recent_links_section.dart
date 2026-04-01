import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../presentation/viewmodels/link_viewmodel.dart';
import '../../../widgets/link_card.dart';

class RecentLinksSection extends ConsumerWidget {
  const RecentLinksSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linksState = ref.watch(linkViewModelProvider);
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
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayLinks.length,
            itemBuilder: (context, index) {
              final link = displayLinks[index];
              return LinkCard(link: link);
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
