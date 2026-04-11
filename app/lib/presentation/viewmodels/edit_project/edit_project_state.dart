import '../../../../data/models/project_model.dart';

/// Marker object to allow setting nullable values in copyWith.
class NullValue {
  const NullValue();
}

/// Immutable state for the EditProjectViewModel.
class EditProjectState {
  final ProjectModel? project;
  final bool isLoading;
  final String? error;
  final String formName;
  final String formDescription;

  /// Marker for explicitly setting nullable values to null
  static const nullValue = NullValue();

  const EditProjectState({
    this.project,
    this.isLoading = false,
    this.error,
    this.formName = '',
    this.formDescription = '',
  });

  EditProjectState copyWith({
    Object? project = nullValue,
    bool? isLoading,
    Object? error = nullValue,
    String? formName,
    String? formDescription,
  }) {
    return EditProjectState(
      project: project is NullValue ? this.project : project as ProjectModel?,
      isLoading: isLoading ?? this.isLoading,
      error: error is NullValue ? this.error : error as String?,
      formName: formName ?? this.formName,
      formDescription: formDescription ?? this.formDescription,
    );
  }
}

/// Extension methods for EditProjectState.
extension EditProjectStateX on EditProjectState {
  /// Whether the form is valid for save
  bool get canSave => !isLoading && formName.isNotEmpty;

  /// Whether currently editing a project (not creating new)
  bool get isEditing => project?.id.isNotEmpty == true;
}
