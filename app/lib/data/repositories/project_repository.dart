import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/project_model.dart';
import '../../data/models/course_model.dart';
import '../../data/models/quiz_model.dart';
import '../../data/services/project_service.dart';
import '../../core/utils/result.dart';

/// Provider for ProjectRepository with dependency injection.
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepository(
    projectService: ProjectService(),
  );
});

/// Repository for project operations.
///
/// Coordinates with ProjectService for API calls.
class ProjectRepository {
  final ProjectService _projectService;

  ProjectRepository({
    required ProjectService projectService,
  }) : _projectService = projectService;

  /// Get all projects for the user.
  Future<Result<List<ProjectModel>>> getProjects() async {
    try {
      final projects = await _projectService.getProjects();
      return Success(projects);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Create a new project.
  Future<Result<ProjectModel>> createProject({
    required String name,
    String? description,
  }) async {
    try {
      final project = await _projectService.createProject(
        name: name,
        description: description,
      );
      return Success(project);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Get a single project by ID.
  Future<Result<ProjectModel>> getProjectById(String projectId) async {
    try {
      final project = await _projectService.getProjectById(projectId);
      return Success(project);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Update project.
  Future<Result<ProjectModel>> updateProject({
    required String projectId,
    String? name,
    String? description,
  }) async {
    try {
      final project = await _projectService.updateProject(
        projectId: projectId,
        name: name,
        description: description,
      );
      return Success(project);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Delete a project.
  Future<Result<Unit>> deleteProject(String projectId) async {
    try {
      await _projectService.deleteProject(projectId);
      return const Success(Unit.value);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Generate course and quiz from project links.
  Future<Result<Map<String, dynamic>>> generateCourseQuiz(String projectId) async {
    try {
      final result = await _projectService.generateCourseQuiz(projectId);
      return Success(result);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Get course for a project.
  Future<Result<CourseModel>> getCourse(String projectId) async {
    try {
      final course = await _projectService.getCourse(projectId);
      return Success(course);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Get quiz for a project.
  Future<Result<QuizModel>> getQuiz(String projectId) async {
    try {
      final quiz = await _projectService.getQuiz(projectId);
      return Success(quiz);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''));
    }
  }
}

/// A unit type for operations that don't return meaningful data.
class Unit {
  static const Unit value = Unit._();
  const Unit._();
}
