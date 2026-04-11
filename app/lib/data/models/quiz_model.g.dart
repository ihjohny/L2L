// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizQuestionImpl _$$QuizQuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuizQuestionImpl(
      question: json['question'] as String,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      correct: (json['correct'] as num).toInt(),
      explanation: json['explanation'] as String?,
    );

Map<String, dynamic> _$$QuizQuestionImplToJson(_$QuizQuestionImpl instance) =>
    <String, dynamic>{
      'question': instance.question,
      'options': instance.options,
      'correct': instance.correct,
      'explanation': instance.explanation,
    };

_$QuizModelImpl _$$QuizModelImplFromJson(Map<String, dynamic> json) =>
    _$QuizModelImpl(
      id: json['_id'] as String,
      content: QuizContent.fromJson(json['content'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$QuizModelImplToJson(_$QuizModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$QuizContentImpl _$$QuizContentImplFromJson(Map<String, dynamic> json) =>
    _$QuizContentImpl(
      courseId: json['courseId'] as String?,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$QuizContentImplToJson(_$QuizContentImpl instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'questions': instance.questions,
    };
