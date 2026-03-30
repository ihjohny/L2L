import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/project_model.dart';

/// An elegant card widget for displaying project information.
/// Used across the app for both horizontal and vertical project lists.
class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final bool isHorizontal;
  final VoidCallback? onTap;

  const ProjectCard({
    super.key,
    required this.project,
    this.isHorizontal = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      child: InkWell(
        onTap: onTap ?? () => context.push('/projects/${project.id}'),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: isHorizontal
              ? _buildHorizontalCard(context)
              : _buildVerticalCard(context),
        ),
      ),
    );
  }

  Widget _buildHorizontalCard(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Folder icon and AI indicator row
          Row(
            children: [
              // Folder icon with background
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.folder_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
              const Spacer(),
              // AI output indicator
              if (project.aiOutputId != null)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: Colors.amber[700],
                    size: 14,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Title (max 2 lines)
          Text(
            project.name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Link count (only if > 0)
          if (project.linkCount > 0) ...[
            const SizedBox(height: 4),
            Text(
              '${project.linkCount} ${project.linkCount == 1 ? 'link' : 'links'}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVerticalCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Folder icon and AI indicator row
          Row(
            children: [
              // Folder icon with background
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.folder_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 22,
                ),
              ),
              const Spacer(),
              // AI output indicator
              if (project.aiOutputId != null)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: Colors.amber[700],
                    size: 16,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          // Title
          Text(
            project.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // Description or link count
          const SizedBox(height: 2),
          project.description != null && project.description!.isNotEmpty
              ? Text(
                  project.description!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              : Text(
                  '${project.linkCount} ${project.linkCount == 1 ? 'link' : 'links'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
        ],
      ),
    );
  }
}
