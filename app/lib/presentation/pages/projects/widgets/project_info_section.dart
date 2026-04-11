import 'package:flutter/material.dart';
import '../../../../data/models/project_model.dart';

/// Widget displaying project information with sync status indicator
class ProjectInfoSection extends StatelessWidget {
  final ProjectModel project;

  const ProjectInfoSection({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project name and sync status
            Row(
              children: [
                Expanded(
                  child: Text(
                    project.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // Description
            if (project.description != null &&
                project.description!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                project.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Last updated info
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 8),
                Text(
                  'Updated ${_formatDate(project.updatedAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const Spacer(),
                _buildSyncStatusIndicator(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncStatusIndicator(BuildContext context) {
    if (!project.hasCourse && !project.hasQuiz) {
      // Initial state - no AI output yet
      return _buildStatusChip(
        context,
        label: 'Not Generated',
        icon: Icons.help_outline,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        iconColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      );
    } else if (project.needsAiSync) {
      // Needs sync
      return _buildStatusChip(
        context,
        label: 'Needs Sync',
        icon: Icons.sync,
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        iconColor: Theme.of(context).colorScheme.error,
      );
    } else {
      // Sync completed
      return _buildStatusChip(
        context,
        label: 'Generated',
        icon: Icons.check_circle,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        iconColor: Theme.of(context).colorScheme.primary,
      );
    }
  }

  Widget _buildStatusChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: iconColor,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        final minutes = difference.inMinutes;
        return minutes <= 1 ? 'just now' : '$minutes minutes ago';
      }
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
