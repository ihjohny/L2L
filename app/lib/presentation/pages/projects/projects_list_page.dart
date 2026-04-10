import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/projects_list/projects_list_viewmodel.dart';
import '../../viewmodels/projects_list/projects_list_state.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/project_card.dart';

class ProjectsListPage extends ConsumerStatefulWidget {
  const ProjectsListPage({super.key});

  @override
  ConsumerState<ProjectsListPage> createState() => _ProjectsListPageState();
}

class _ProjectsListPageState extends ConsumerState<ProjectsListPage> {
  @override
  Widget build(BuildContext context) {
    final projectsState = ref.watch(projectsListViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: projectsState.isLoading && projectsState.projects.isEmpty
          ? const LoadingWidget()
          : projectsState.error != null && projectsState.projects.isEmpty
              ? CustomErrorWidget(
                  message: projectsState.error!,
                  onRetry: () => ref.read(projectsListViewModelProvider.notifier).loadProjects(),
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

  Widget _buildProjectsList(ProjectsListState projectsState) {
    return RefreshIndicator(
      onRefresh: () => ref.read(projectsListViewModelProvider.notifier).loadProjects(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: projectsState.projects.length,
        itemBuilder: (context, index) {
          final project = projectsState.projects[index];
          return ProjectCard(project: project);
        },
      ),
    );
  }
}
