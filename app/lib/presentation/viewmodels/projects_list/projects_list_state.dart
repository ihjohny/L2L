import '../../../../data/models/project_model.dart';

/// Immutable state for the ProjectsListViewModel.
class ProjectsListState {
  final List<ProjectModel> projects;
  final bool isLoading;
  final String? error;

  const ProjectsListState({
    this.projects = const [],
    this.isLoading = true,
    this.error,
  });

  ProjectsListState copyWith({
    List<ProjectModel>? projects,
    bool? isLoading,
    String? error,
  }) {
    return ProjectsListState(
      projects: projects ?? this.projects,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get hasProjects => projects.isNotEmpty;
}
