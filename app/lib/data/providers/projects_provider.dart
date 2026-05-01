import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project_model.dart';
import '../repositories/project_repository.dart';

/// A common data source for fetching and caching the list of projects.
/// This ensures all viewmodels (like ProjectsListViewModel and AddLinkViewModel)
/// have access to the same synchronized data.
class ProjectsDataSource extends StateNotifier<AsyncValue<List<ProjectModel>>> {
  final ProjectRepository _repository;

  ProjectsDataSource(this._repository) : super(const AsyncValue.loading()) {
    fetchProjects();
  }

  /// Fetch all projects from the repository and update state.
  Future<void> fetchProjects() async {
    state = const AsyncValue.loading();
    final result = await _repository.getProjects();
    
    if (!mounted) return;
    
    result.fold(
      (projects) {
        state = AsyncValue.data(projects);
      },
      (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }
}

/// Global provider for the common projects data source.
final projectsProvider = StateNotifierProvider<ProjectsDataSource, AsyncValue<List<ProjectModel>>>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return ProjectsDataSource(repository);
});
