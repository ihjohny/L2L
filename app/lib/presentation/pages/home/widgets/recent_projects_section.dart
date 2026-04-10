import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../presentation/viewmodels/projects_list_viewmodel.dart';
import '../../../widgets/project_card.dart';

class RecentProjectsSection extends ConsumerWidget {
  const RecentProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsState = ref.watch(projectsListViewModelProvider);
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
            height: 85,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (displayProjects.isEmpty)
          _buildEmptyState(context)
        else
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: displayProjects.length,
              separatorBuilder: (context, index) => const SizedBox(width: 2),
              itemBuilder: (context, index) {
                final project = displayProjects[index];
                return ProjectCard(project: project, isHorizontal: true);
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
