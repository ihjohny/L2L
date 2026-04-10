import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/project_repository.dart';
import '../../../../data/repositories/link_repository.dart';
import '../../../../core/utils/navigation_triggers.dart';
import 'project_details_state.dart';

/// ViewModel for managing project details.
///
/// Handles viewing, updating, and deleting individual projects,
/// as well as managing project links and course generation.
class ProjectDetailsViewModel extends StateNotifier<ProjectDetailsState> {
  final ProjectRepository _projectRepository;
  final Ref _ref;

  ProjectDetailsViewModel(this._projectRepository, this._ref)
      : super(const ProjectDetailsState());

  /// Select a project and load its details and links.
  Future<void> selectProject(String projectId) async {
    state = state.copyWith(isLoading: true, isLoadingLinks: true, error: ProjectDetailsState.nullValue);

    // Get project details
    final projectResult = await _projectRepository.getProjectById(projectId);
    if (!mounted) return;

    projectResult.fold(
      (project) {
        state = state.copyWith(selectedProject: project, isLoading: false);
      },
      (error) {
        state = state.copyWith(
          isLoading: false,
          isLoadingLinks: false,
          error: error,
        );
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
  }

  /// Clear selected project.
  void clearSelectedProject() {
    state = state.copyWith(
      selectedProject: ProjectDetailsState.nullValue,
      selectedProjectLinks: [],
      editingProjectId: ProjectDetailsState.nullValue,
      formName: '',
      formDescription: '',
    );
  }

  /// Set form fields for editing project name.
  void setFormName(String name) {
    state = state.copyWith(formName: name, error: ProjectDetailsState.nullValue);
  }

  /// Set form fields for project description.
  void setFormDescription(String description) {
    state = state.copyWith(formDescription: description, error: ProjectDetailsState.nullValue);
  }

  /// Prepare form for editing the currently selected project.
  void prepareEditProject() {
    final project = state.selectedProject;
    if (project != null) {
      state = state.copyWith(
        editingProjectId: project.id,
        formName: project.name,
        formDescription: project.description ?? '',
      );
    }
  }

  /// Update an existing project.
  Future<void> updateProject() async {
    if (!state.canSaveProject || !state.isEditing || state.editingProjectId == null) {
      return;
    }

    state = state.copyWith(isLoading: true, error: ProjectDetailsState.nullValue);

    final result = await _projectRepository.updateProject(
      projectId: state.editingProjectId!,
      name: state.formName,
      description: state.formDescription.isEmpty ? null : state.formDescription,
    );

    if (!mounted) return;

    result.fold(
      (updatedProject) {
        state = state.copyWith(
          selectedProject: updatedProject,
          isLoading: false,
          editingProjectId: ProjectDetailsState.nullValue,
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

  /// Delete the currently selected project.
  Future<void> deleteProject() async {
    final projectId = state.selectedProject?.id;
    if (projectId == null) return;

    state = state.copyWith(isLoading: true, error: ProjectDetailsState.nullValue);

    final result = await _projectRepository.deleteProject(projectId);

    if (!mounted) return;

    result.fold(
      (_) {
        state = const ProjectDetailsState(
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
        // Course and quiz generation started - could update state with job info
      },
      (error) {
        state = state.copyWith(error: error);
      },
    );
  }

  /// Clear error message.
  void clearError() {
    state = state.copyWith(error: ProjectDetailsState.nullValue);
  }

  /// Reset navigation trigger.
  void resetNavigationTrigger() {
    state = state.copyWith(navigationTrigger: ProjectNavigationTrigger.none);
  }

  /// Clear form state.
  void clearForm() {
    state = state.copyWith(
      editingProjectId: ProjectDetailsState.nullValue,
      formName: '',
      formDescription: '',
    );
  }
}

/// Provider for ProjectDetailsViewModel.
final projectDetailsViewModelProvider =
    StateNotifierProvider<ProjectDetailsViewModel, ProjectDetailsState>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return ProjectDetailsViewModel(repository, ref);
});
