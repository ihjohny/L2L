import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/project_providers.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';

class ProjectsListPage extends ConsumerStatefulWidget {
  const ProjectsListPage({super.key});

  @override
  ConsumerState<ProjectsListPage> createState() => _ProjectsListPageState();
}

class _ProjectsListPageState extends ConsumerState<ProjectsListPage> {
  @override
  Widget build(BuildContext context) {
    final projectsState = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: projectsState.isLoading && projectsState.projects.isEmpty
          ? const LoadingWidget()
          : projectsState.error != null && projectsState.projects.isEmpty
              ? CustomErrorWidget(
                  message: projectsState.error!,
                  onRetry: () => ref.read(projectsProvider.notifier).loadProjects(),
                )
              : projectsState.projects.isEmpty
                  ? _buildEmptyState(context)
                  : _buildProjectsList(projectsState),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.folder_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 24),
          Text(
            'No Projects Yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Create a project while adding a new link',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsList(dynamic projectsState) {
    return RefreshIndicator(
      onRefresh: () => ref.read(projectsProvider.notifier).loadProjects(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: projectsState.projects.length,
        itemBuilder: (context, index) {
          final project = projectsState.projects[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Icon(
                  Icons.folder,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: Text(
                project.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: project.description != null && project.description!.isNotEmpty
                  ? Text(
                      project.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  : null,
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
              onTap: () => context.push('/projects/${project.id}'),
            ),
          );
        },
      ),
    );
  }
}
