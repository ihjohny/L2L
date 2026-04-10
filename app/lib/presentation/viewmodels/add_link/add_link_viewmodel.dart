import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/link_repository.dart';
import '../../../../data/repositories/project_repository.dart';
import 'add_link_state.dart';
import '../link_list/link_list_viewmodel.dart';
import '../projects_list/projects_list_viewmodel.dart';

/// ViewModel for add link operations.
///
/// Manages form state for creating new links with optional project creation.
class AddLinkViewModel extends StateNotifier<AddLinkState> {
  final LinkRepository _linkRepository;
  final ProjectRepository _projectRepository;
  final Ref _ref;

  AddLinkViewModel(
    this._linkRepository,
    this._projectRepository,
    this._ref,
  ) : super(AddLinkState.initial()) {
    loadProjects();
  }

  /// Load existing projects for autocomplete.
  Future<void> loadProjects() async {
    final result = await _projectRepository.getProjects();
    if (!mounted) return;
    result.fold(
      (projects) {
        state = state.copyWith(projects: projects);
      },
      (_) {
        // Silently fail - projects will be empty
      },
    );
  }

  /// Set URL field.
  void setUrl(String url) {
    state = state.copyWith(formUrl: url, error: null);
    _validateForm();
  }

  /// Set title field.
  void setTitle(String title) {
    state = state.copyWith(formTitle: title, error: null);
    _validateForm();
  }

  /// Set tags field.
  void setTags(String tags) {
    state = state.copyWith(formTags: tags, error: null);
    _validateForm();
  }

  /// Set project ID field.
  void setProjectId(String? projectId) {
    state = state.copyWith(
      formProjectId: projectId,
      newProjectName: null,
      error: null,
    );
    _validateForm();
  }

  /// Set new project name (when creating new project).
  void setNewProjectName(String? projectName) {
    state = state.copyWith(
      newProjectName: projectName,
      formProjectId: null,
      error: null,
    );
    _validateForm();
  }

  /// Validate form.
  void _validateForm() {
    state = state.copyWith(isValid: state.hasValidUrl);
  }

  /// Submit form to create link.
  Future<bool> submitLink() async {
    if (!state.canSubmit) return false;

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      // Handle project creation if needed
      String? finalProjectId = state.formProjectId;

      if (state.isCreatingNewProject) {
        // Create new project first
        final projectResult = await _projectRepository.createProject(
          name: state.newProjectName!,
        );

        if (projectResult.isFailure) {
          state = state.copyWith(
            isSubmitting: false,
            error: 'Failed to create project',
          );
          return false;
        }

        // Get the newly created project ID
        final newProject = projectResult.data;
        finalProjectId = newProject.id;
      }

      // Create the link
      final result = await _linkRepository.createLink(
        url: state.formUrl,
        title: state.formTitle.isEmpty ? null : state.formTitle,
        projectId: finalProjectId,
        tags: state.parsedTags.isEmpty ? null : state.parsedTags,
      );

      if (!mounted) return false;

      if (result.isFailure) {
        state = state.copyWith(
          isSubmitting: false,
          error: result.error,
        );
        return false;
      }

      // Success - clear form and refresh lists
      state = state.copyWith(
        isSubmitting: false,
        formUrl: '',
        formTitle: '',
        formTags: '',
        formProjectId: null,
        newProjectName: null,
      );

      // Refresh link list and project list to include the new link
      _ref.read(linkListViewModelProvider.notifier).loadLinks();
      _ref.read(projectsListViewModelProvider.notifier).loadProjects();

      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  /// Clear form state.
  void clearForm() {
    state = AddLinkState.initial();
    loadProjects();
  }

  /// Clear error.
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for AddLinkViewModel.
final addLinkViewModelProvider =
    StateNotifierProvider<AddLinkViewModel, AddLinkState>((ref) {
  final linkRepository = ref.watch(linkRepositoryProvider);
  final projectRepository = ref.watch(projectRepositoryProvider);
  return AddLinkViewModel(linkRepository, projectRepository, ref);
});
