import '../models/project_model.dart';
import '../services/project_service.dart';

class ProjectRepository {
  final ProjectService _projectService;

  ProjectRepository({ProjectService? projectService})
      : _projectService = projectService ?? ProjectService();

  /// Create a new project
  Future<ProjectModel> createProject({
    required String name,
    String? description,
  }) async {
    return await _projectService.createProject(
      name: name,
      description: description,
    );
  }

  /// Get all projects for the user
  Future<List<ProjectModel>> getProjects() async {
    return await _projectService.getProjects();
  }

  /// Get a single project by ID
  Future<ProjectModel> getProjectById(String projectId) async {
    return await _projectService.getProjectById(projectId);
  }

  /// Update project
  Future<ProjectModel> updateProject({
    required String projectId,
    String? name,
    String? description,
  }) async {
    return await _projectService.updateProject(
      projectId: projectId,
      name: name,
      description: description,
    );
  }

  /// Delete a project
  Future<void> deleteProject(String projectId) async {
    await _projectService.deleteProject(projectId);
  }

  /// Generate course from project links
  Future<Map<String, dynamic>> generateCourse(String projectId) async {
    return await _projectService.generateCourse(projectId);
  }
}
