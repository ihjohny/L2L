import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/link_repository.dart';
import '../../../core/utils/navigation_triggers.dart';
import 'project_state.dart';

/// ViewModel for project-related operations.
///
/// Manages projects list, project detail, create, update, delete, and course generation.
class ProjectViewModel extends StateNotifier<ProjectState> {
  final ProjectRepository _projectRepository;
  final Ref _ref;

  ProjectViewModel(this._projectRepository, this._ref) : super(ProjectState.initial()) {
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

  /// Select a project and load its links.
  Future<void> selectProject(String projectId) async {
    state = state.copyWith(isLoadingLinks: true, isLoadingCourse: true, error: null);

    // Get project details
    final projectResult = await _projectRepository.getProjectById(projectId);
    if (!mounted) return;
    projectResult.fold(
      (project) {
        state = state.copyWith(selectedProject: project);
      },
      (error) {
        state = state.copyWith(error: error);
      },
    );

    // Load project links
    final linkRepo = _ref.read(linkRepositoryProvider);
    final linksResult = await linkRepo.getLinks(projectId: projectId);
    if (!mounted) return;
    linksResult.fold(
      (links) {
        state = state.copyWith(
          selectedProjectLinks: links,
          isLoadingLinks: false,
        );
      },
      (error) {
        state = state.copyWith(
          isLoadingLinks: false,
          error: error,
        );
      },
    );

    // Load project stats (includes course status)
    _loadProjectStats(projectId);

    // Load course if exists
    _loadCourse(projectId);

    // Load quiz if exists
    _loadQuiz(projectId);
  }

  /// Load project statistics.
  Future<void> _loadProjectStats(String projectId) async {
    final result = await _projectRepository.getProjectStats(projectId);
    if (!mounted) return;
    result.fold(
      (stats) {
        state = state.copyWith(selectedProjectStats: stats);
      },
      (error) {
        // Silently fail - stats are not critical
      },
    );
  }

  /// Load course for the selected project.
  Future<void> _loadCourse(String projectId) async {
    final result = await _projectRepository.getLatestCourse(projectId);
    if (!mounted) return;
    result.fold(
      (course) {
        state = state.copyWith(
          selectedProjectCourse: course,
          isLoadingCourse: false,
        );
      },
      (error) {
        state = state.copyWith(isLoadingCourse: false);
      },
    );
  }

  /// Load quiz for the selected project.
  Future<void> _loadQuiz(String projectId) async {
    final result = await _projectRepository.getLatestQuiz(projectId);
    if (!mounted) return;
    result.fold(
      (quiz) {
        state = state.copyWith(selectedProjectQuiz: quiz);
      },
      (error) {
        // Silently fail - quiz might not exist yet
      },
    );
  }

  /// Clear selected project.
  void clearSelectedProject() {
    state = state.copyWith(
      selectedProject: null,
      selectedProjectLinks: [],
      selectedProjectCourse: null,
      selectedProjectQuiz: null,
      selectedProjectStats: null,
    );
  }

  /// Set form fields for creating a new project.
  void setFormName(String name) {
    state = state.copyWith(formName: name, error: null);
  }

  /// Set form fields for description.
  void setFormDescription(String description) {
    state = state.copyWith(formDescription: description, error: null);
  }

  /// Prepare form for editing a project.
  void prepareEditProject(String projectId) {
    final project = state.getProjectById(projectId);
    if (project != null) {
      state = state.copyWith(
        editingProjectId: projectId,
        formName: project.name,
        formDescription: project.description ?? '',
      );
    }
  }

  /// Create a new project.
  Future<void> createProject() async {
    if (!state.canSaveProject) return;

    state = state.copyWith(isLoading: true, error: null);

    final result = await _projectRepository.createProject(
      name: state.formName,
      description: state.formDescription.isEmpty ? null : state.formDescription,
    );

    if (!mounted) return;
    result.fold(
      (newProject) {
        state = state.copyWith(
          projects: [...state.projects, newProject],
          isLoading: false,
          formName: '',
          formDescription: '',
          navigationTrigger: ProjectNavigationTrigger.toProjectsList,
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

  /// Update an existing project.
  Future<void> updateProject() async {
    if (!state.canSaveProject || !state.isEditing) return;

    state = state.copyWith(isLoading: true, error: null);

    final result = await _projectRepository.updateProject(
      projectId: state.editingProjectId!,
      name: state.formName,
      description: state.formDescription.isEmpty ? null : state.formDescription,
    );

    if (!mounted) return;
    result.fold(
      (updatedProject) {
        state = state.copyWith(
          projects: state.projects.map((p) {
            return p.id == updatedProject.id ? updatedProject : p;
          }).toList(),
          selectedProject: updatedProject,
          isLoading: false,
          editingProjectId: null,
          formName: '',
          formDescription: '',
          navigationTrigger: ProjectNavigationTrigger.toProjectDetail,
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

  /// Delete a project.
  Future<void> deleteProject(String projectId) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _projectRepository.deleteProject(projectId);

    if (!mounted) return;
    result.fold(
      (_) {
        state = state.copyWith(
          projects: state.projects.where((p) => p.id != projectId).toList(),
          selectedProject: null,
          isLoading: false,
          navigationTrigger: ProjectNavigationTrigger.toProjectsList,
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

  /// Generate course and quiz from project links.
  Future<void> generateCourseQuiz(String projectId) async {
    final result = await _projectRepository.generateCourseQuiz(projectId);

    if (!mounted) return;
    result.fold(
      (data) {
        // Course and quiz generation started - refresh data after delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _loadProjectStats(projectId);
            _loadCourse(projectId);
            _loadQuiz(projectId);
          }
        });
      },
      (error) {
        state = state.copyWith(error: error);
      },
    );
  }

  /// Sync/regenerate course for project.
  Future<void> syncCourse(String projectId) async {
    final result = await _projectRepository.syncCourse(projectId);

    if (!mounted) return;
    result.fold(
      (data) {
        // Course sync started - refresh data after delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _loadProjectStats(projectId);
            _loadCourse(projectId);
            _loadQuiz(projectId);
          }
        });
      },
      (error) {
        state = state.copyWith(error: error);
      },
    );
  }

  /// Refresh project data (links, stats, course, quiz).
  Future<void> refreshProject(String projectId) async {
    // Load project links
    final linkRepo = _ref.read(linkRepositoryProvider);
    final linksResult = await linkRepo.getLinks(projectId: projectId);
    if (!mounted) return;
    linksResult.fold(
      (links) {
        state = state.copyWith(selectedProjectLinks: links);
      },
      (error) {
        state = state.copyWith(error: error);
      },
    );

    // Load stats, course, and quiz
    _loadProjectStats(projectId);
    _loadCourse(projectId);
    _loadQuiz(projectId);
  }

  /// Clear error.
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Reset navigation trigger.
  void resetNavigationTrigger() {
    state = state.copyWith(navigationTrigger: ProjectNavigationTrigger.none);
  }

  /// Clear form state.
  void clearForm() {
    state = state.copyWith(
      editingProjectId: null,
      formName: '',
      formDescription: '',
    );
  }
}

/// Provider for ProjectViewModel.
final projectViewModelProvider = StateNotifierProvider<ProjectViewModel, ProjectState>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return ProjectViewModel(repository, ref);
});
