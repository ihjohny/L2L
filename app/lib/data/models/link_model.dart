import 'package:freezed_annotation/freezed_annotation.dart';

part 'link_model.freezed.dart';
part 'link_model.g.dart';

enum LinkStatus { pending, processing, completed, failed }

@freezed
class Flashcard with _$Flashcard {
  const factory Flashcard({
    required String question,
    required String answer,
    @Default('medium') String difficulty,
  }) = _Flashcard;

  factory Flashcard.fromJson(Map<String, dynamic> json) =>
      _$FlashcardFromJson(json);
}

@freezed
class FlashcardsContent with _$FlashcardsContent {
  const factory FlashcardsContent({
    @Default([]) List<Flashcard> flashcards,
  }) = _FlashcardsContent;

  factory FlashcardsContent.fromJson(Map<String, dynamic> json) =>
      _$FlashcardsContentFromJson(json);
}

@freezed
class SummaryContent with _$SummaryContent {
  const factory SummaryContent({
    @Default([]) List<String> keyPoints,
    @Default('') String mainArgument,
    @Default([]) List<String> takeaways,
  }) = _SummaryContent;

  factory SummaryContent.fromJson(Map<String, dynamic> json) =>
      _$SummaryContentFromJson(json);
}

@freezed
class LinkModel with _$LinkModel {
  const LinkModel._();

  const factory LinkModel({
    required String id,
    required String url,
    required String userId,
    String? projectId,
    String? title,
    String? aiOutputId,
    @Default([]) List<String> tags,
    @Default(LinkStatus.pending) LinkStatus status,
    String? statusMessage,
    SummaryContent? summary,
    FlashcardsContent? flashcards,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _LinkModel;

  factory LinkModel.fromJson(Map<String, dynamic> json) {
    return LinkModel(
      id: json['_id']?.toString() ?? json['id'] ?? '',
      url: json['url'] ?? '',
      userId: json['userId'] ?? '',
      projectId: json['projectId']?.toString(),
      title: json['title'],
      aiOutputId: json['aiOutputId']?.toString(),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      status: LinkStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => LinkStatus.pending,
      ),
      statusMessage: json['statusMessage'],
      summary: json['summary'] != null
          ? SummaryContent.fromJson(json['summary'])
          : null,
      flashcards: json['flashcards'] != null
          ? FlashcardsContent.fromJson(json['flashcards'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  factory LinkModel.empty() => LinkModel(
    id: '',
    url: '',
    userId: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

// Extension methods for computed properties
extension LinkModelX on LinkModel {
  bool get isProcessed => status == LinkStatus.completed;

  bool get isProcessing => status == LinkStatus.processing;

  bool get isFailed => status == LinkStatus.failed;

  bool get isPending => status == LinkStatus.pending;

  String get displayTitle => title ?? _extractDomain();

  String _extractDomain() {
    try {
      final uri = Uri.parse(url);
      return uri.host.replaceAll('www.', '');
    } catch (_) {
      return url;
    }
  }

  String get displaySummary => summary?.mainArgument ?? 'Processing...';

  List<String> get displayTags =>
      tags.isNotEmpty ? tags : (summary?.takeaways ?? []);
}
