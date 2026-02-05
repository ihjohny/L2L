import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity_model.freezed.dart';
part 'entity_model.g.dart';

enum ContentType { article, video, podcast, document, book }

enum ContentStatus { pending, processing, completed, failed }

enum DifficultyLevel { beginner, intermediate, advanced, expert }

@freezed
class ContentMetadata with _$ContentMetadata {
  const factory ContentMetadata({
    String? author,
    DateTime? publishDate,
    int? readingTime,
    @Default(DifficultyLevel.intermediate) DifficultyLevel difficulty,
    required String sourceUrl,
    String? thumbnail,
    int? fileSize,
    int? duration,
    @Default('en') String language,
  }) = _ContentMetadata;

  factory ContentMetadata.fromJson(Map<String, dynamic> json) =>
      _$ContentMetadataFromJson(json);
}

@freezed
class ProcessedContent with _$ProcessedContent {
  const factory ProcessedContent({
    String? summary,
    @Default([]) List<String> keyPoints,
    @Default([]) List<String> tags,
    String? thumbnail,
    @Default([]) List<String> concepts,
    @Default(DifficultyLevel.intermediate) DifficultyLevel difficulty,
    int? readingTime,
  }) = _ProcessedContent;

  factory ProcessedContent.fromJson(Map<String, dynamic> json) =>
      _$ProcessedContentFromJson(json);
}

@freezed
class Flashcard with _$Flashcard {
  const factory Flashcard({
    required String id,
    required String front,
    required String back,
    DifficultyLevel? difficulty,
    String? imageUrl,
    @Default(0) int reviewCount,
    DateTime? lastReviewedAt,
    DateTime? nextReviewAt,
    @Default(2.5) double easeFactor,
  }) = _Flashcard;

  factory Flashcard.fromJson(Map<String, dynamic> json) =>
      _$FlashcardFromJson(json);
}

@freezed
class QuizQuestion with _$QuizQuestion {
  const factory QuizQuestion({
    required String id,
    required String question,
    @Default([]) List<String> options,
    required int correctAnswer,
    String? explanation,
    @Default(DifficultyLevel.intermediate) DifficultyLevel difficulty,
    @Default(10) int points,
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
}

@freezed
class QuizAttempt with _$QuizAttempt {
  const factory QuizAttempt({
    required int score,
    required int totalQuestions,
    required int correctAnswers,
    int? timeSpent,
    required DateTime completedAt,
    @Default([]) List<int> answers,
  }) = _QuizAttempt;

  factory QuizAttempt.fromJson(Map<String, dynamic> json) =>
      _$QuizAttemptFromJson(json);
}

@freezed
class LearningMaterials with _$LearningMaterials {
  const factory LearningMaterials({
    @Default([]) List<Flashcard> flashcards,
    Quiz? quiz,
    @Default([]) List<String> learningPath,
  }) = _LearningMaterials;

  factory LearningMaterials.fromJson(Map<String, dynamic> json) =>
      _$LearningMaterialsFromJson(json);
}

@freezed
class Quiz with _$Quiz {
  const factory Quiz({
    @Default([]) List<QuizQuestion> questions,
    @Default([]) List<QuizAttempt> attempts,
  }) = _Quiz;

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
}

@freezed
class UserInteractions with _$UserInteractions {
  const factory UserInteractions({
    @Default(false) bool isRead,
    @Default(false) bool isFavorite,
    int? rating,
    DateTime? readAt,
  }) = _UserInteractions;

  factory UserInteractions.fromJson(Map<String, dynamic> json) =>
      _$UserInteractionsFromJson(json);
}

@freezed
class EntityModel with _$EntityModel {
  const EntityModel._();

  const factory EntityModel({
    required String id,
    required String url,
    required String title,
    required String description,
    required String userId,
    @Default([]) List<String> tags,
    @Default(ContentType.article) ContentType type,
    @Default(ContentStatus.pending) ContentStatus status,
    required ContentMetadata metadata,
    ProcessedContent? processedContent,
    LearningMaterials? learningMaterials,
    @Default(UserInteractions()) UserInteractions userInteractions,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _EntityModel;

  factory EntityModel.fromJson(Map<String, dynamic> json) {
    return EntityModel(
      id: json['_id']?.toString() ?? json['id'] ?? '',
      url: json['url'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      userId: json['userId'] ?? '',
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      type: ContentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ContentType.article,
      ),
      status: ContentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ContentStatus.pending,
      ),
      metadata: json['metadata'] != null
          ? ContentMetadata.fromJson(json['metadata'])
          : ContentMetadata(sourceUrl: json['url'] ?? ''),
      processedContent: json['processedContent'] != null
          ? ProcessedContent.fromJson(json['processedContent'])
          : null,
      learningMaterials: json['learningMaterials'] != null
          ? LearningMaterials.fromJson(json['learningMaterials'])
          : null,
      userInteractions: json['userInteractions'] != null
          ? UserInteractions.fromJson(json['userInteractions'])
          : const UserInteractions(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  factory EntityModel.empty() => EntityModel(
    id: '',
    url: '',
    title: '',
    description: '',
    userId: '',
    metadata: const ContentMetadata(
      sourceUrl: '',
    ),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

// Extension methods for computed properties
extension EntityModelX on EntityModel {
  bool get isProcessed => status == ContentStatus.completed;

  bool get isProcessing => status == ContentStatus.processing;

  bool get isFailed => status == ContentStatus.failed;

  List<String> get displayTags => tags.isNotEmpty ? tags : (processedContent?.tags.isNotEmpty == true ? processedContent!.tags : []);

  String get displaySummary =>
      processedContent?.summary ?? description;

  String get domain {
    try {
      final uri = Uri.parse(url);
      return uri.host.replaceAll('www.', '').split('.')[0];
    } catch (_) {
      return 'Unknown';
    }
  }
}
