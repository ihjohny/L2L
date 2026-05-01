import '../../core/network/dio_client.dart';
import '../models/project_model.dart';
import '../models/course_model.dart';
import '../models/quiz_model.dart';

class ProjectService {
  final DioClient _dioClient = DioClient.instance;

  /// Create a new project
  Future<ProjectModel> createProject({
    required String name,
    String? description,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        '/projects',
        data: {
          'name': name,
          if (description != null) 'description': description,
        },
      );

      if (response.statusCode == 201) {
        return ProjectModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to create project');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Get all projects for the user
  Future<List<ProjectModel>> getProjects() async {
    try {
      final response = await _dioClient.dio.get('/projects');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ProjectModel.fromJson(json)).toList();
      }
      throw Exception('Failed to fetch projects');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Get a single project by ID
  Future<ProjectModel> getProjectById(String projectId) async {
    try {
      final response = await _dioClient.dio.get('/projects/$projectId');

      if (response.statusCode == 200) {
        return ProjectModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to fetch project');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Update project
  Future<ProjectModel> updateProject({
    required String projectId,
    String? name,
    String? description,
  }) async {
    try {
      final response = await _dioClient.dio.put(
        '/projects/$projectId',
        data: {
          if (name != null) 'name': name,
          if (description != null) 'description': description,
        },
      );

      if (response.statusCode == 200) {
        return ProjectModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to update project');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Delete a project
  Future<void> deleteProject(String projectId) async {
    try {
      final response = await _dioClient.dio.delete('/projects/$projectId');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete project');
      }
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Generate course and quiz from project links
  Future<Map<String, dynamic>> generateCourseQuiz(String projectId) async {
    try {
      final response = await _dioClient.dio.post(
        '/projects/$projectId/generate-course-quiz',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['data'] as Map<String, dynamic>;
      }
      throw Exception('Failed to generate course and quiz');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Get the current status of course and quiz generation
  Future<Map<String, dynamic>?> getGenerationStatus(String projectId) async {
    try {
      final response = await _dioClient.dio.get(
        '/projects/$projectId/generation-status',
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return response.data['data'] as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Get course for a project
  Future<CourseModel> getCourse(String projectId) async {
    try {
      final response = await _dioClient.dio.get('/projects/$projectId/course');

      if (response.statusCode == 200) {
        return CourseModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to fetch course');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Get quiz for a project
  Future<QuizModel> getQuiz(String projectId) async {
    try {
      final response = await _dioClient.dio.get('/projects/$projectId/quiz');

      if (response.statusCode == 200) {
        return QuizModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to fetch quiz');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }
}
