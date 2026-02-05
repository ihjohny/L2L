// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContentMetadataImpl _$$ContentMetadataImplFromJson(
        Map<String, dynamic> json) =>
    _$ContentMetadataImpl(
      author: json['author'] as String?,
      publishDate: json['publishDate'] == null
          ? null
          : DateTime.parse(json['publishDate'] as String),
      readingTime: (json['readingTime'] as num?)?.toInt(),
      difficulty:
          $enumDecodeNullable(_$DifficultyLevelEnumMap, json['difficulty']) ??
              DifficultyLevel.intermediate,
      sourceUrl: json['sourceUrl'] as String,
      thumbnail: json['thumbnail'] as String?,
      fileSize: (json['fileSize'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      language: json['language'] as String? ?? 'en',
    );

Map<String, dynamic> _$$ContentMetadataImplToJson(
        _$ContentMetadataImpl instance) =>
    <String, dynamic>{
      'author': instance.author,
      'publishDate': instance.publishDate?.toIso8601String(),
      'readingTime': instance.readingTime,
      'difficulty': _$DifficultyLevelEnumMap[instance.difficulty]!,
      'sourceUrl': instance.sourceUrl,
      'thumbnail': instance.thumbnail,
      'fileSize': instance.fileSize,
      'duration': instance.duration,
      'language': instance.language,
    };

const _$DifficultyLevelEnumMap = {
  DifficultyLevel.beginner: 'beginner',
  DifficultyLevel.intermediate: 'intermediate',
  DifficultyLevel.advanced: 'advanced',
  DifficultyLevel.expert: 'expert',
};

_$ProcessedContentImpl _$$ProcessedContentImplFromJson(
        Map<String, dynamic> json) =>
    _$ProcessedContentImpl(
      summary: json['summary'] as String?,
      keyPoints: (json['keyPoints'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      thumbnail: json['thumbnail'] as String?,
      concepts: (json['concepts'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      difficulty:
          $enumDecodeNullable(_$DifficultyLevelEnumMap, json['difficulty']) ??
              DifficultyLevel.intermediate,
      readingTime: (json['readingTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ProcessedContentImplToJson(
        _$ProcessedContentImpl instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'keyPoints': instance.keyPoints,
      'tags': instance.tags,
      'thumbnail': instance.thumbnail,
      'concepts': instance.concepts,
      'difficulty': _$DifficultyLevelEnumMap[instance.difficulty]!,
      'readingTime': instance.readingTime,
    };

_$FlashcardImpl _$$FlashcardImplFromJson(Map<String, dynamic> json) =>
    _$FlashcardImpl(
      id: json['id'] as String,
      front: json['front'] as String,
      back: json['back'] as String,
      difficulty:
          $enumDecodeNullable(_$DifficultyLevelEnumMap, json['difficulty']),
      imageUrl: json['imageUrl'] as String?,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      lastReviewedAt: json['lastReviewedAt'] == null
          ? null
          : DateTime.parse(json['lastReviewedAt'] as String),
      nextReviewAt: json['nextReviewAt'] == null
          ? null
          : DateTime.parse(json['nextReviewAt'] as String),
      easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? 2.5,
    );

Map<String, dynamic> _$$FlashcardImplToJson(_$FlashcardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'front': instance.front,
      'back': instance.back,
      'difficulty': _$DifficultyLevelEnumMap[instance.difficulty],
      'imageUrl': instance.imageUrl,
      'reviewCount': instance.reviewCount,
      'lastReviewedAt': instance.lastReviewedAt?.toIso8601String(),
      'nextReviewAt': instance.nextReviewAt?.toIso8601String(),
      'easeFactor': instance.easeFactor,
    };

_$QuizQuestionImpl _$$QuizQuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuizQuestionImpl(
      id: json['id'] as String,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      correctAnswer: (json['correctAnswer'] as num).toInt(),
      explanation: json['explanation'] as String?,
      difficulty:
          $enumDecodeNullable(_$DifficultyLevelEnumMap, json['difficulty']) ??
              DifficultyLevel.intermediate,
      points: (json['points'] as num?)?.toInt() ?? 10,
    );

Map<String, dynamic> _$$QuizQuestionImplToJson(_$QuizQuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'options': instance.options,
      'correctAnswer': instance.correctAnswer,
      'explanation': instance.explanation,
      'difficulty': _$DifficultyLevelEnumMap[instance.difficulty]!,
      'points': instance.points,
    };

_$QuizAttemptImpl _$$QuizAttemptImplFromJson(Map<String, dynamic> json) =>
    _$QuizAttemptImpl(
      score: (json['score'] as num).toInt(),
      totalQuestions: (json['totalQuestions'] as num).toInt(),
      correctAnswers: (json['correctAnswers'] as num).toInt(),
      timeSpent: (json['timeSpent'] as num?)?.toInt(),
      completedAt: DateTime.parse(json['completedAt'] as String),
      answers: (json['answers'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$QuizAttemptImplToJson(_$QuizAttemptImpl instance) =>
    <String, dynamic>{
      'score': instance.score,
      'totalQuestions': instance.totalQuestions,
      'correctAnswers': instance.correctAnswers,
      'timeSpent': instance.timeSpent,
      'completedAt': instance.completedAt.toIso8601String(),
      'answers': instance.answers,
    };

_$LearningMaterialsImpl _$$LearningMaterialsImplFromJson(
        Map<String, dynamic> json) =>
    _$LearningMaterialsImpl(
      flashcards: (json['flashcards'] as List<dynamic>?)
              ?.map((e) => Flashcard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      quiz: json['quiz'] == null
          ? null
          : Quiz.fromJson(json['quiz'] as Map<String, dynamic>),
      learningPath: (json['learningPath'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$LearningMaterialsImplToJson(
        _$LearningMaterialsImpl instance) =>
    <String, dynamic>{
      'flashcards': instance.flashcards,
      'quiz': instance.quiz,
      'learningPath': instance.learningPath,
    };

_$QuizImpl _$$QuizImplFromJson(Map<String, dynamic> json) => _$QuizImpl(
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      attempts: (json['attempts'] as List<dynamic>?)
              ?.map((e) => QuizAttempt.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$QuizImplToJson(_$QuizImpl instance) =>
    <String, dynamic>{
      'questions': instance.questions,
      'attempts': instance.attempts,
    };

_$UserInteractionsImpl _$$UserInteractionsImplFromJson(
        Map<String, dynamic> json) =>
    _$UserInteractionsImpl(
      isRead: json['isRead'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toInt(),
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
    );

Map<String, dynamic> _$$UserInteractionsImplToJson(
        _$UserInteractionsImpl instance) =>
    <String, dynamic>{
      'isRead': instance.isRead,
      'isFavorite': instance.isFavorite,
      'rating': instance.rating,
      'readAt': instance.readAt?.toIso8601String(),
    };
