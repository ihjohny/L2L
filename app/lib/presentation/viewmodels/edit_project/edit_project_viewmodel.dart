import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/project_repository.dart';
import 'edit_project_state.dart';

/// ViewModel for managing project editing.
///
/// Handles creating and updating projects.
class EditProjectViewModel extends StateNotifier<EditProjectState> {
  final ProjectRepository _projectRepository;

  EditProjectViewModel(this._projectRepository)
      : super(const EditProjectState());

  /// Load a project for editing.
  Future<void> loadProject(String projectId) async {
    state = state.copyWith(isLoading: true, error: EditProjectState.nullValue);

    final result = await _projectRepository.getProjectById(projectId);

    if (!mounted) return;

    result.fold(
      (project) {
        state = state.copyWith(
          project: project,
          formName: project.name,
          formDescription: project.description ?? '',
          isLoading: false,
        );
      },
      (error) {
        state = state.copyWith(isLoading: false, error: error);
      },
    );
  }

  /// Set form name field.
  void setFormName(String name) {
    state = state.copyWith(formName: name, error: EditProjectState.nullValue);
  }

  /// Set form description field.
  void setFormDescription(String description) {
    state = state.copyWith(
      formDescription: description,
      error: EditProjectState.nullValue,
    );
  }

  /// Update an existing project.
  Future<bool> updateProject() async {
    if (!state.canSave || !state.isEditing) {
      return false;
    }

    state = state.copyWith(isLoading: true, error: EditProjectState.nullValue);

    final result = await _projectRepository.updateProject(
      projectId: state.project!.id,
      name: state.formName,
      description: state.formDescription.isEmpty ? null : state.formDescription,
    );

    if (!mounted) return false;

    return result.fold(
      (updatedProject) {
        state = state.copyWith(
          project: updatedProject,
          isLoading: false,
        );
        return true;
      },
      (error) {
        state = state.copyWith(isLoading: false, error: error);
        return false;
      },
    );
  }

  /// Clear error message.
  void clearError() {
    state = state.copyWith(error: EditProjectState.nullValue);
  }

  /// Reset the form to initial state.
  void resetForm() {
    state = const EditProjectState();
  }
}

/// Provider for EditProjectViewModel.
final editProjectViewModelProvider =
    StateNotifierProvider<EditProjectViewModel, EditProjectState>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return EditProjectViewModel(repository);
});
