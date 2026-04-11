import '../../../../data/models/project_model.dart';
import '../../../../data/models/link_model.dart';
import '../../../../data/models/course_model.dart';
import '../../../../data/models/quiz_model.dart';
import '../../../../core/utils/navigation_triggers.dart';

/// Marker object to allow setting nullable values in copyWith.
class NullValue {
  const NullValue();
}

/// Immutable state for the ProjectDetailsViewModel.
class ProjectDetailsState {
  final ProjectModel? project;
  final List<LinkModel> projectLinks;
  final bool isLoading;
  final bool isLoadingLinks;
  final String? error;
  final ProjectNavigationTrigger navigationTrigger;

  // Course and Quiz data
  final CourseModel? course;
  final QuizModel? quiz;
  final bool isLoadingCourse;
  final bool isLoadingQuiz;

  /// Marker for explicitly setting nullable values to null
  static const nullValue = NullValue();

  const ProjectDetailsState({
    this.project,
    this.projectLinks = const [],
    this.isLoading = false,
    this.isLoadingLinks = false,
    this.error,
    this.navigationTrigger = ProjectNavigationTrigger.none,
    this.course,
    this.quiz,
    this.isLoadingCourse = false,
    this.isLoadingQuiz = false,
  });

  ProjectDetailsState copyWith({
    Object? project = nullValue,
    List<LinkModel>? projectLinks,
    bool? isLoading,
    bool? isLoadingLinks,
    Object? error = nullValue,
    ProjectNavigationTrigger? navigationTrigger,
    Object? course = nullValue,
    Object? quiz = nullValue,
    bool? isLoadingCourse,
    bool? isLoadingQuiz,
  }) {
    return ProjectDetailsState(
      project: project is NullValue ? this.project : project as ProjectModel?,
      projectLinks: projectLinks ?? this.projectLinks,
      isLoading: isLoading ?? this.isLoading,
      isLoadingLinks: isLoadingLinks ?? this.isLoadingLinks,
      error: error is NullValue ? this.error : error as String?,
      navigationTrigger: navigationTrigger ?? this.navigationTrigger,
      course: course is NullValue ? this.course : course as CourseModel?,
      quiz: quiz is NullValue ? this.quiz : quiz as QuizModel?,
      isLoadingCourse: isLoadingCourse ?? this.isLoadingCourse,
      isLoadingQuiz: isLoadingQuiz ?? this.isLoadingQuiz,
    );
  }
}

/// Extension methods for ProjectDetailsState.
extension ProjectDetailsStateX on ProjectDetailsState {

  /// Whether AI output (course/quiz) exists
  bool get hasAiOutput => course != null || quiz != null;

  /// Whether AI output needs sync (links changed since generation)
  bool get needsAiSync => project?.needsAiSync ?? false;

  /// Whether course data is available
  bool get hasCourse => course != null;

  /// Whether quiz data is available
  bool get hasQuiz => quiz != null;

  /// Get UI state based on AI output availability and sync status
  ProjectDetailsUiState get uiState {
    if (!hasAiOutput) {
      return ProjectDetailsUiState.initial;
    } else if (needsAiSync) {
      return ProjectDetailsUiState.syncRequired;
    } else {
      return ProjectDetailsUiState.syncCompleted;
    }
  }
}

/// UI states for project details page
enum ProjectDetailsUiState {
  /// Initial state - no AI output generated yet
  initial,

  /// AI output exists but needs sync (links changed)
  syncRequired,

  /// AI output exists and is up to date
  syncCompleted,
}
