// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectAiOutputImpl _$$ProjectAiOutputImplFromJson(
        Map<String, dynamic> json) =>
    _$ProjectAiOutputImpl(
      courseId: json['courseId'] as String?,
      quizId: json['quizId'] as String?,
    );

Map<String, dynamic> _$$ProjectAiOutputImplToJson(
        _$ProjectAiOutputImpl instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'quizId': instance.quizId,
    };

_$ProjectModelImpl _$$ProjectModelImplFromJson(Map<String, dynamic> json) =>
    _$ProjectModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      aiOutput: json['aiOutput'] == null
          ? null
          : ProjectAiOutput.fromJson(json['aiOutput'] as Map<String, dynamic>),
      shouldSyncAiOutput: json['shouldSyncAiOutput'] as bool? ?? false,
      totalLinks: (json['totalLinks'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ProjectModelImplToJson(_$ProjectModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'description': instance.description,
      'aiOutput': instance.aiOutput,
      'shouldSyncAiOutput': instance.shouldSyncAiOutput,
      'totalLinks': instance.totalLinks,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
