import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/project_model.dart';
import '../../data/repositories/project_repository.dart';

// Project Repository Provider
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepository();
});

// Projects State
class ProjectsState {
  final List<ProjectModel> projects;
  final bool isLoading;
  final String? error;
  final String? selectedProjectId;

  ProjectsState({
    this.projects = const [],
    this.isLoading = false,
    this.error,
    this.selectedProjectId,
  });

  ProjectsState copyWith({
    List<ProjectModel>? projects,
    bool? isLoading,
    String? error,
    String? selectedProjectId,
  }) {
    return ProjectsState(
      projects: projects ?? this.projects,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedProjectId: selectedProjectId ?? this.selectedProjectId,
    );
  }
}

// Projects StateNotifier
class ProjectsNotifier extends StateNotifier<ProjectsState> {
  final ProjectRepository _projectRepository;

  ProjectsNotifier(this._projectRepository) : super(ProjectsState()) {
    loadProjects();
  }

  // Load all projects for the user
  Future<void> loadProjects() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final projects = await _projectRepository.getProjects();
      state = ProjectsState(projects: projects, isLoading: false);
    } catch (e) {
      state = ProjectsState(
        projects: state.projects,
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  // Create project
  Future<ProjectModel?> createProject({
    required String name,
    String? description,
  }) async {
    try {
      final newProject = await _projectRepository.createProject(
        name: name,
        description: description,
      );
      state = state.copyWith(
        projects: [...state.projects, newProject],
      );
      return newProject;
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceAll('Exception: ', ''));
      return null;
    }
  }

  // Update project
  Future<void> updateProject({
    required String projectId,
    String? name,
    String? description,
  }) async {
    try {
      final updatedProject = await _projectRepository.updateProject(
        projectId: projectId,
        name: name,
        description: description,
      );
      state = state.copyWith(
        projects: state.projects.map((p) {
          return p.id == updatedProject.id ? updatedProject : p;
        }).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Delete project
  Future<void> deleteProject(String projectId) async {
    try {
      await _projectRepository.deleteProject(projectId);
      state = state.copyWith(
        projects: state.projects.where((p) => p.id != projectId).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Select project
  void selectProject(String? projectId) {
    state = state.copyWith(selectedProjectId: projectId);
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Projects Provider
final projectsProvider = StateNotifierProvider<ProjectsNotifier, ProjectsState>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return ProjectsNotifier(repository);
});

// Get project by id
final projectByIdProvider = Provider.family<ProjectModel?, String>((ref, projectId) {
  final projectsState = ref.watch(projectsProvider);
  try {
    return projectsState.projects.firstWhere((p) => p.id == projectId);
  } catch (_) {
    return null;
  }
});

// Get current selected project
final selectedProjectProvider = Provider<ProjectModel?>((ref) {
  final state = ref.watch(projectsProvider);
  if (state.selectedProjectId == null) return null;
  try {
    return state.projects.firstWhere((p) => p.id == state.selectedProjectId);
  } catch (_) {
    return null;
  }
});
