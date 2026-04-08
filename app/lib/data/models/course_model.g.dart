// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseLessonImpl _$$CourseLessonImplFromJson(Map<String, dynamic> json) =>
    _$CourseLessonImpl(
      title: json['title'] as String,
      content: json['content'] as String,
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$$CourseLessonImplToJson(_$CourseLessonImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'order': instance.order,
    };

_$CourseContentImpl _$$CourseContentImplFromJson(Map<String, dynamic> json) =>
    _$CourseContentImpl(
      title: json['title'] as String,
      description: json['description'] as String,
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((e) => CourseLesson.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CourseContentImplToJson(_$CourseContentImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'lessons': instance.lessons,
    };
