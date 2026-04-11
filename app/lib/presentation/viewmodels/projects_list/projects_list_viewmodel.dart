import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/project_repository.dart';
import 'projects_list_state.dart';

/// ViewModel for managing the list of projects.
///
/// Handles loading and displaying all projects.
class ProjectsListViewModel extends StateNotifier<ProjectsListState> {
  final ProjectRepository _projectRepository;

  ProjectsListViewModel(this._projectRepository)
      : super(const ProjectsListState(isLoading: true)) {
    loadProjects();
  }

  /// Load all projects.
  Future<void> loadProjects() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _projectRepository.getProjects();
    if (!mounted) return;

    result.fold(
      (projects) {
        state = state.copyWith(
          projects: projects,
          isLoading: false,
        );
      },
      (error) {
        state = state.copyWith(
          isLoading: false,
          error: error,
        );
      },
    );
  }

  /// Clear error message.
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for ProjectsListViewModel.
final projectsListViewModelProvider =
    StateNotifierProvider<ProjectsListViewModel, ProjectsListState>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return ProjectsListViewModel(repository);
});
