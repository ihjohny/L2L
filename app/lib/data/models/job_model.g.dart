// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobModelImpl _$$JobModelImplFromJson(Map<String, dynamic> json) =>
    _$JobModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$JobTypeEnumMap, json['type']),
      status: $enumDecode(_$JobStatusEnumMap, json['status']),
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      data: json['data'] as Map<String, dynamic>?,
      processedAt: json['processedAt'] == null
          ? null
          : DateTime.parse(json['processedAt'] as String),
      error: json['error'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$JobModelImplToJson(_$JobModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$JobTypeEnumMap[instance.type]!,
      'status': _$JobStatusEnumMap[instance.status]!,
      'progress': instance.progress,
      'data': instance.data,
      'processedAt': instance.processedAt?.toIso8601String(),
      'error': instance.error,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$JobTypeEnumMap = {
  JobType.processLink: 'processLink',
  JobType.generateCourse: 'generateCourse',
};

const _$JobStatusEnumMap = {
  JobStatus.waiting: 'waiting',
  JobStatus.active: 'active',
  JobStatus.completed: 'completed',
  JobStatus.failed: 'failed',
  JobStatus.delayed: 'delayed',
};
