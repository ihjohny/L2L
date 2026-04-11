import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l2l_app/data/models/project_model.dart';
import '../../../../data/repositories/project_repository.dart';
import '../../../../data/repositories/link_repository.dart';
import '../../../../core/utils/navigation_triggers.dart';
import '../../../../core/constants/app_constants.dart';
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

  /// Select a project and load its details, links, course and quiz.
  Future<void> selectProject(String projectId) async {
    state = state.copyWith(
      isLoading: true,
      isLoadingLinks: true,
      isLoadingCourse: true,
      isLoadingQuiz: true,
      error: ProjectDetailsState.nullValue,
    );

    // Get project details
    final projectResult = await _projectRepository.getProjectById(projectId);
    if (!mounted) return;

    ProjectModel? project;
    projectResult.fold(
      (p) {
        project = p;
        state = state.copyWith(project: project, isLoading: false);
      },
      (error) {
        state = state.copyWith(
          isLoading: false,
          isLoadingLinks: false,
          isLoadingCourse: false,
          isLoadingQuiz: false,
          error: error,
        );
      },
    );

    if (project == null) return;

    // Load project links
    final linkRepo = _ref.read(linkRepositoryProvider);
    final linksResult = await linkRepo.getLinks(projectId: projectId);
    if (!mounted) return;

    linksResult.fold(
      (links) {
        state = state.copyWith(
          projectLinks: links,
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

    // Load course if available
    if (project!.hasCourse) {
      final courseResult = await _projectRepository.getCourse(projectId);
      if (!mounted) return;

      courseResult.fold(
        (course) {
          state = state.copyWith(course: course, isLoadingCourse: false);
        },
        (error) {
          state = state.copyWith(isLoadingCourse: false);
        },
      );
    } else {
      state = state.copyWith(isLoadingCourse: false);
    }

    // Load quiz if available
    if (project!.hasQuiz) {
      final quizResult = await _projectRepository.getQuiz(projectId);
      if (!mounted) return;

      quizResult.fold(
        (quiz) {
          state = state.copyWith(quiz: quiz, isLoadingQuiz: false);
        },
        (error) {
          state = state.copyWith(isLoadingQuiz: false);
        },
      );
    } else {
      state = state.copyWith(isLoadingQuiz: false);
    }
  }

  /// Clear selected project.
  void clearSelectedProject() {
    state = const ProjectDetailsState(
      project: null,
      projectLinks: [],
      course: null,
      quiz: null,
      isLoading: false,
      isLoadingLinks: false,
      isLoadingCourse: false,
      isLoadingQuiz: false,
      error: null,
      navigationTrigger: ProjectNavigationTrigger.none,
    );
  }

  /// Delete the currently selected project.
  Future<void> deleteProject() async {
    final projectId = state.project?.id;
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
      (data) async {
        await Future.delayed(const Duration(seconds: AppConstants.reloadDelaySeconds));
        // Course and quiz generation started - reload project to get updated IDs
        await _reloadProjectData(projectId);
      },
      (error) {
        state = state.copyWith(error: error);
      },
    );
  }

  /// Reload project data including course and quiz after generation
  Future<void> _reloadProjectData(String projectId) async {
    final projectResult = await _projectRepository.getProjectById(projectId);
    if (!mounted) return;

    projectResult.fold(
      (project) async {
        state = state.copyWith(project: project);

        // Load course if available
        if (project.hasCourse) {
          final courseResult = await _projectRepository.getCourse(projectId);
          if (!mounted) return;

          courseResult.fold(
            (course) {
              state = state.copyWith(course: course);
            },
            (error) {
              // Ignore error
            },
          );
        }

        // Load quiz if available
        if (project.hasQuiz) {
          final quizResult = await _projectRepository.getQuiz(projectId);
          if (!mounted) return;

          quizResult.fold(
            (quiz) {
              state = state.copyWith(quiz: quiz);
            },
            (error) {
              // Ignore error
            },
          );
        }
      },
      (error) {
        // Ignore error
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
}

/// Provider for ProjectDetailsViewModel.
final projectDetailsViewModelProvider = StateNotifierProvider.autoDispose<
    ProjectDetailsViewModel, ProjectDetailsState>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return ProjectDetailsViewModel(repository, ref);
});
