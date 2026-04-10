import '../../../data/models/project_model.dart';
import '../../../data/models/link_model.dart';
import '../../../core/utils/navigation_triggers.dart';

/// Marker object to allow setting nullable values in copyWith.
class NullValue {
  const NullValue();
}

/// Immutable state for the ProjectDetailsViewModel.
class ProjectDetailsState {
  final ProjectModel? selectedProject;
  final List<LinkModel> selectedProjectLinks;
  final bool isLoading;
  final bool isLoadingLinks;
  final String? error;
  final ProjectNavigationTrigger navigationTrigger;

  // Form state for editing
  final String? editingProjectId;
  final String formName;
  final String formDescription;

  /// Marker for explicitly setting nullable values to null
  static const nullValue = NullValue();

  const ProjectDetailsState({
    this.selectedProject,
    this.selectedProjectLinks = const [],
    this.isLoading = false,
    this.isLoadingLinks = false,
    this.error,
    this.navigationTrigger = ProjectNavigationTrigger.none,
    this.editingProjectId,
    this.formName = '',
    this.formDescription = '',
  });

  ProjectDetailsState copyWith({
    Object? selectedProject = nullValue,
    List<LinkModel>? selectedProjectLinks,
    bool? isLoading,
    bool? isLoadingLinks,
    Object? error = nullValue,
    ProjectNavigationTrigger? navigationTrigger,
    Object? editingProjectId = nullValue,
    String? formName,
    String? formDescription,
  }) {
    return ProjectDetailsState(
      selectedProject: selectedProject is NullValue ? this.selectedProject : selectedProject as ProjectModel?,
      selectedProjectLinks: selectedProjectLinks ?? this.selectedProjectLinks,
      isLoading: isLoading ?? this.isLoading,
      isLoadingLinks: isLoadingLinks ?? this.isLoadingLinks,
      error: error is NullValue ? this.error : error as String?,
      navigationTrigger: navigationTrigger ?? this.navigationTrigger,
      editingProjectId: editingProjectId is NullValue ? this.editingProjectId : editingProjectId as String?,
      formName: formName ?? this.formName,
      formDescription: formDescription ?? this.formDescription,
    );
  }
}

/// Extension methods for ProjectDetailsState.
extension ProjectDetailsStateX on ProjectDetailsState {
  /// Whether the form is valid for save
  bool get canSaveProject => !isLoading && formName.isNotEmpty;

  /// Whether currently editing a project
  bool get isEditing => editingProjectId != null;

  /// Whether the selected project has links
  bool get selectedProjectHasLinks => selectedProjectLinks.isNotEmpty;
}
