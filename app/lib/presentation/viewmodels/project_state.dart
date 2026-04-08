import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/link_model.dart';
import '../../../data/models/course_model.dart';
import '../../../data/models/quiz_model.dart';
import '../../../core/utils/navigation_triggers.dart';

part 'project_state.freezed.dart';

/// Immutable state for the ProjectViewModel.
@freezed
class ProjectState with _$ProjectState {
  const factory ProjectState({
    /// List of all projects
    @Default([]) List<ProjectModel> projects,

    /// Currently selected project (for detail view)
    ProjectModel? selectedProject,

    /// Links for the selected project
    @Default([]) List<LinkModel> selectedProjectLinks,

    /// Course for the selected project
    CourseModel? selectedProjectCourse,

    /// Quiz for the selected project
    QuizModel? selectedProjectQuiz,

    /// Project statistics
    Map<String, dynamic>? selectedProjectStats,

    /// Whether the ViewModel is currently loading
    @Default(false) bool isLoading,

    /// Whether links are loading for the selected project
    @Default(false) isLoadingLinks,

    /// Whether course/quiz data is loading
    @Default(false) isLoadingCourse,

    /// Error message from the last failed operation
    String? error,

    /// Navigation trigger for the UI to consume
    @Default(ProjectNavigationTrigger.none) ProjectNavigationTrigger navigationTrigger,

    /// Form state for create/edit
    String? editingProjectId,
    @Default('') String formName,
    @Default('') String formDescription,
  }) = _ProjectState;

  /// Initial state
  factory ProjectState.initial() => const ProjectState(
        projects: [],
        selectedProject: null,
        selectedProjectLinks: [],
        selectedProjectCourse: null,
        selectedProjectQuiz: null,
        selectedProjectStats: null,
        isLoading: true, // Start loading to fetch projects
        isLoadingLinks: false,
        isLoadingCourse: false,
        error: null,
        navigationTrigger: ProjectNavigationTrigger.none,
      );
}

/// Extension methods for ProjectState.
extension ProjectStateX on ProjectState {
  /// Whether the project list is loaded
  bool get hasProjects => projects.isNotEmpty;

  /// Whether the form is valid for save
  bool get canSaveProject => !isLoading && formName.isNotEmpty;

  /// Whether currently editing a project
  bool get isEditing => editingProjectId != null;

  /// Get project by ID from the list
  ProjectModel? getProjectById(String id) {
    try {
      return projects.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Whether the selected project has links
  bool get selectedProjectHasLinks => selectedProjectLinks.isNotEmpty;

  /// Whether the selected project has a generated course
  bool get hasCourse => selectedProjectCourse != null;

  /// Whether the selected project has a quiz
  bool get hasQuiz => selectedProjectQuiz != null;

  /// Whether the course needs to be synced (new links added)
  bool get needsCourseSync {
    if (selectedProjectStats == null) return false;
    final courseStatus = selectedProjectStats!['courseStatus'] as String?;
    return courseStatus == 'needs_sync';
  }

  /// Whether a course can be generated
  bool get canGenerateCourse => selectedProjectHasLinks && !hasCourse && !needsCourseSync;
}
