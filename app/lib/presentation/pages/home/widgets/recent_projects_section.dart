import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../providers/project_providers.dart';
import '../../../../../data/models/project_model.dart';

class RecentProjectsSection extends ConsumerWidget {
  const RecentProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsState = ref.watch(projectsProvider);
    final projects = projectsState.projects;

    // Sort projects by activity (most recently updated first)
    final recentProjects = projects
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    // Take only the most recent 10 projects for the horizontal list
    final displayProjects = recentProjects.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Projects',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () => context.push('/projects'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Horizontal Scrollable List
        if (projectsState.isLoading && displayProjects.isEmpty)
          const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (displayProjects.isEmpty)
          _buildEmptyState(context)
        else
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: displayProjects.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final project = displayProjects[index];
                return _ProjectCard(project: project);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.folder_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'No projects yet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a project to get started',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => context.push('/projects/${project.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.folder,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      project.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (project.description != null && project.description!.isNotEmpty)
                Text(
                  project.description!,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              else
                Text(
                  '${project.linkIds.length} links',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 12,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _formatLastActivity(project),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                      overflow: TextOverflow.ellipsis,
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

  String _formatLastActivity(ProjectModel project) {
    final lastActivity = project.updatedAt;
    final now = DateTime.now();
    final difference = now.difference(lastActivity);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${lastActivity.day}/${lastActivity.month}/${lastActivity.year}';
    }
  }
}
