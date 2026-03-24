// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FlashcardImpl _$$FlashcardImplFromJson(Map<String, dynamic> json) =>
    _$FlashcardImpl(
      question: json['question'] as String,
      answer: json['answer'] as String,
      difficulty: json['difficulty'] as String? ?? 'medium',
    );

Map<String, dynamic> _$$FlashcardImplToJson(_$FlashcardImpl instance) =>
    <String, dynamic>{
      'question': instance.question,
      'answer': instance.answer,
      'difficulty': instance.difficulty,
    };

_$FlashcardsContentImpl _$$FlashcardsContentImplFromJson(
        Map<String, dynamic> json) =>
    _$FlashcardsContentImpl(
      flashcards: (json['flashcards'] as List<dynamic>?)
              ?.map((e) => Flashcard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$FlashcardsContentImplToJson(
        _$FlashcardsContentImpl instance) =>
    <String, dynamic>{
      'flashcards': instance.flashcards,
    };

_$SummaryContentImpl _$$SummaryContentImplFromJson(Map<String, dynamic> json) =>
    _$SummaryContentImpl(
      keyPoints: (json['keyPoints'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      mainArgument: json['mainArgument'] as String? ?? '',
      takeaways: (json['takeaways'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SummaryContentImplToJson(
        _$SummaryContentImpl instance) =>
    <String, dynamic>{
      'keyPoints': instance.keyPoints,
      'mainArgument': instance.mainArgument,
      'takeaways': instance.takeaways,
    };
