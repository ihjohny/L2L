import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_model.freezed.dart';
part 'project_model.g.dart';

@freezed
class ProjectAiOutput with _$ProjectAiOutput {
  const factory ProjectAiOutput({
    String? courseId,
    String? quizId,
  }) = _ProjectAiOutput;

  factory ProjectAiOutput.fromJson(Map<String, dynamic> json) => ProjectAiOutput(
    courseId: json['courseId']?.toString(),
    quizId: json['quizId']?.toString(),
  );
}

@freezed
class SyncAiOutput with _$SyncAiOutput {
  const factory SyncAiOutput({
    @Default(false) bool course,
    @Default(false) bool quiz,
  }) = _SyncAiOutput;

  factory SyncAiOutput.fromJson(Map<String, dynamic> json) => SyncAiOutput(
    course: json['course'] ?? false,
    quiz: json['quiz'] ?? false,
  );
}

@freezed
class ProjectModel with _$ProjectModel {
  const ProjectModel._();

  const factory ProjectModel({
    required String id,
    required String userId,
    required String name,
    String? description,
    ProjectAiOutput? aiOutput,
    SyncAiOutput? syncAiOutput,
    @Default(0) int totalLinks,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
    id: json['_id']?.toString() ?? json['id'] ?? '',
    userId: json['userId']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    description: json['description']?.toString(),
    aiOutput: json['aiOutput'] != null
        ? ProjectAiOutput.fromJson(json['aiOutput'])
        : null,
    syncAiOutput: json['syncAiOutput'] != null
        ? SyncAiOutput.fromJson(json['syncAiOutput'])
        : null,
    totalLinks: json['totalLinks'] ?? 0,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'].toString())
        : DateTime.now(),
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'].toString())
        : DateTime.now(),
  );

  factory ProjectModel.empty() => ProjectModel(
    id: '',
    userId: '',
    name: '',
    totalLinks: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

// Extension methods for computed properties
extension ProjectModelX on ProjectModel {
  bool get hasLinks => totalLinks > 0;

  int get linkCount => totalLinks;

  bool get hasCourse => aiOutput?.courseId != null && aiOutput!.courseId!.isNotEmpty;

  bool get hasQuiz => aiOutput?.quizId != null && aiOutput!.quizId!.isNotEmpty;

  bool get needsAiSync => syncAiOutput?.course == true || syncAiOutput?.quiz == true;

  bool get needsCourseSync => syncAiOutput?.course == true;

  bool get needsQuizSync => syncAiOutput?.quiz == true;
}
