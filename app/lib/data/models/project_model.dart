import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_model.freezed.dart';
part 'project_model.g.dart';

@freezed
class ProjectModel with _$ProjectModel {
  const ProjectModel._();

  const factory ProjectModel({
    required String id,
    required String userId,
    required String name,
    String? description,
    String? aiOutputId,
    @Default([]) List<String> linkIds,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['_id']?.toString() ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      aiOutputId: json['aiOutputId']?.toString(),
      linkIds: json['linkIds'] != null ? List<String>.from(json['linkIds']) : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  factory ProjectModel.empty() => ProjectModel(
    id: '',
    userId: '',
    name: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

// Extension methods for computed properties
extension ProjectModelX on ProjectModel {
  bool get hasLinks => linkIds.isNotEmpty;

  int get linkCount => linkIds.length;
}
