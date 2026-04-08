import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_model.freezed.dart';
part 'quiz_model.g.dart';

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

@freezed
class QuizContent with _$QuizContent {
  const factory QuizContent({
    String? courseId,
    @Default([]) List<QuizQuestion> questions,
  }) = _QuizContent;

  factory QuizContent.fromJson(Map<String, dynamic> json) =>
      _$QuizContentFromJson(json);
}

@freezed
class QuizModel with _$QuizModel {
  const QuizModel._();

  const factory QuizModel({
    required String id,
    required String projectId,
    String? courseId,
    required QuizContent content,
    required DateTime createdAt,
  }) = _QuizModel;

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['_id']?.toString() ?? json['id'] ?? '',
      projectId: json['projectId'] ?? json['sourceId'] ?? '',
      courseId: json['content']?['courseId']?.toString(),
      content: QuizContent.fromJson(json['content'] ?? {}),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  factory QuizModel.empty() => QuizModel(
    id: '',
    projectId: '',
    content: QuizContent(questions: []),
    createdAt: DateTime.now(),
  );

  // Computed properties (directly on class, not extension)
  int get questionCount => content.questions.length;

  bool get hasQuestions => content.questions.isNotEmpty;
}
