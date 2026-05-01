import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/project_model.dart';
import '../../../../data/providers/projects_provider.dart';
import 'projects_list_state.dart';

/// ViewModel for managing the list of projects.
///
/// Handles loading and displaying all projects.
class ProjectsListViewModel extends StateNotifier<ProjectsListState> {
  final Ref _ref;

  ProjectsListViewModel(this._ref)
      : super(const ProjectsListState(isLoading: true)) {
    
    // Listen to the common data source and sync local state
    _ref.listen<AsyncValue<List<ProjectModel>>>(
      projectsProvider,
      (previous, next) {
        next.when(
          data: (projects) {
            state = state.copyWith(
              projects: projects,
              isLoading: false,
              error: null,
            );
          },
          error: (error, stackTrace) {
            state = state.copyWith(
              isLoading: false,
              error: error.toString(),
            );
          },
          loading: () {
            state = state.copyWith(isLoading: true, error: null);
          },
        );
      },
      fireImmediately: true,
    );
  }

  /// Load all projects via the common data source.
  Future<void> loadProjects() async {
    await _ref.read(projectsProvider.notifier).fetchProjects();
  }

  /// Clear error message.
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for ProjectsListViewModel.
final projectsListViewModelProvider =
    StateNotifierProvider<ProjectsListViewModel, ProjectsListState>((ref) {
  return ProjectsListViewModel(ref);
});
