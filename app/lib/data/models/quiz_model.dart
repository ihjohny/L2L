import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_model.freezed.dart';
part 'quiz_model.g.dart';

/// Represents a single quiz question.
@freezed
class QuizQuestion with _$QuizQuestion {
  const factory QuizQuestion({
    required String question,
    required List<String> options,
    required int correct,
    String? explanation,
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
}

/// Represents a quiz generated from project links or a course.
@freezed
class QuizModel with _$QuizModel {
  const QuizModel._();

  const factory QuizModel({
    @JsonKey(name: '_id') required String id,
    required QuizContent content,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _QuizModel;

  factory QuizModel.fromJson(Map<String, dynamic> json) =>
      _$QuizModelFromJson(json);
}

/// Represents the content of a quiz.
@freezed
class QuizContent with _$QuizContent {
  const factory QuizContent({
    String? courseId,
    required List<QuizQuestion> questions,
  }) = _QuizContent;

  factory QuizContent.fromJson(Map<String, dynamic> json) =>
      _$QuizContentFromJson(json);
}

// Extension methods for computed properties
extension QuizModelX on QuizModel {
  /// Get the total number of questions in the quiz.
  int get questionCount => content.questions.length;

  /// Check if the quiz has any questions.
  bool get hasQuestions => content.questions.isNotEmpty;

  /// Check if this quiz is associated with a course.
  bool get hasCourse => content.courseId != null && content.courseId!.isNotEmpty;
}
