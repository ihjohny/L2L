// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entity_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContentMetadata _$ContentMetadataFromJson(Map<String, dynamic> json) {
  return _ContentMetadata.fromJson(json);
}

/// @nodoc
mixin _$ContentMetadata {
  String? get author => throw _privateConstructorUsedError;
  DateTime? get publishDate => throw _privateConstructorUsedError;
  int? get readingTime => throw _privateConstructorUsedError;
  DifficultyLevel get difficulty => throw _privateConstructorUsedError;
  String get sourceUrl => throw _privateConstructorUsedError;
  String? get thumbnail => throw _privateConstructorUsedError;
  int? get fileSize => throw _privateConstructorUsedError;
  int? get duration => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;

  /// Serializes this ContentMetadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContentMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContentMetadataCopyWith<ContentMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentMetadataCopyWith<$Res> {
  factory $ContentMetadataCopyWith(
          ContentMetadata value, $Res Function(ContentMetadata) then) =
      _$ContentMetadataCopyWithImpl<$Res, ContentMetadata>;
  @useResult
  $Res call(
      {String? author,
      DateTime? publishDate,
      int? readingTime,
      DifficultyLevel difficulty,
      String sourceUrl,
      String? thumbnail,
      int? fileSize,
      int? duration,
      String language});
}

/// @nodoc
class _$ContentMetadataCopyWithImpl<$Res, $Val extends ContentMetadata>
    implements $ContentMetadataCopyWith<$Res> {
  _$ContentMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContentMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? author = freezed,
    Object? publishDate = freezed,
    Object? readingTime = freezed,
    Object? difficulty = null,
    Object? sourceUrl = null,
    Object? thumbnail = freezed,
    Object? fileSize = freezed,
    Object? duration = freezed,
    Object? language = null,
  }) {
    return _then(_value.copyWith(
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      publishDate: freezed == publishDate
          ? _value.publishDate
          : publishDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readingTime: freezed == readingTime
          ? _value.readingTime
          : readingTime // ignore: cast_nullable_to_non_nullable
              as int?,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as DifficultyLevel,
      sourceUrl: null == sourceUrl
          ? _value.sourceUrl
          : sourceUrl // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContentMetadataImplCopyWith<$Res>
    implements $ContentMetadataCopyWith<$Res> {
  factory _$$ContentMetadataImplCopyWith(_$ContentMetadataImpl value,
          $Res Function(_$ContentMetadataImpl) then) =
      __$$ContentMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? author,
      DateTime? publishDate,
      int? readingTime,
      DifficultyLevel difficulty,
      String sourceUrl,
      String? thumbnail,
      int? fileSize,
      int? duration,
      String language});
}

/// @nodoc
class __$$ContentMetadataImplCopyWithImpl<$Res>
    extends _$ContentMetadataCopyWithImpl<$Res, _$ContentMetadataImpl>
    implements _$$ContentMetadataImplCopyWith<$Res> {
  __$$ContentMetadataImplCopyWithImpl(
      _$ContentMetadataImpl _value, $Res Function(_$ContentMetadataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContentMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? author = freezed,
    Object? publishDate = freezed,
    Object? readingTime = freezed,
    Object? difficulty = null,
    Object? sourceUrl = null,
    Object? thumbnail = freezed,
    Object? fileSize = freezed,
    Object? duration = freezed,
    Object? language = null,
  }) {
    return _then(_$ContentMetadataImpl(
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      publishDate: freezed == publishDate
          ? _value.publishDate
          : publishDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readingTime: freezed == readingTime
          ? _value.readingTime
          : readingTime // ignore: cast_nullable_to_non_nullable
              as int?,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as DifficultyLevel,
      sourceUrl: null == sourceUrl
          ? _value.sourceUrl
          : sourceUrl // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContentMetadataImpl implements _ContentMetadata {
  const _$ContentMetadataImpl(
      {this.author,
      this.publishDate,
      this.readingTime,
      this.difficulty = DifficultyLevel.intermediate,
      required this.sourceUrl,
      this.thumbnail,
      this.fileSize,
      this.duration,
      this.language = 'en'});

  factory _$ContentMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContentMetadataImplFromJson(json);

  @override
  final String? author;
  @override
  final DateTime? publishDate;
  @override
  final int? readingTime;
  @override
  @JsonKey()
  final DifficultyLevel difficulty;
  @override
  final String sourceUrl;
  @override
  final String? thumbnail;
  @override
  final int? fileSize;
  @override
  final int? duration;
  @override
  @JsonKey()
  final String language;

  @override
  String toString() {
    return 'ContentMetadata(author: $author, publishDate: $publishDate, readingTime: $readingTime, difficulty: $difficulty, sourceUrl: $sourceUrl, thumbnail: $thumbnail, fileSize: $fileSize, duration: $duration, language: $language)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentMetadataImpl &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.publishDate, publishDate) ||
                other.publishDate == publishDate) &&
            (identical(other.readingTime, readingTime) ||
                other.readingTime == readingTime) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.sourceUrl, sourceUrl) ||
                other.sourceUrl == sourceUrl) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.language, language) ||
                other.language == language));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, author, publishDate, readingTime,
      difficulty, sourceUrl, thumbnail, fileSize, duration, language);

  /// Create a copy of ContentMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContentMetadataImplCopyWith<_$ContentMetadataImpl> get copyWith =>
      __$$ContentMetadataImplCopyWithImpl<_$ContentMetadataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentMetadataImplToJson(
      this,
    );
  }
}

abstract class _ContentMetadata implements ContentMetadata {
  const factory _ContentMetadata(
      {final String? author,
      final DateTime? publishDate,
      final int? readingTime,
      final DifficultyLevel difficulty,
      required final String sourceUrl,
      final String? thumbnail,
      final int? fileSize,
      final int? duration,
      final String language}) = _$ContentMetadataImpl;

  factory _ContentMetadata.fromJson(Map<String, dynamic> json) =
      _$ContentMetadataImpl.fromJson;

  @override
  String? get author;
  @override
  DateTime? get publishDate;
  @override
  int? get readingTime;
  @override
  DifficultyLevel get difficulty;
  @override
  String get sourceUrl;
  @override
  String? get thumbnail;
  @override
  int? get fileSize;
  @override
  int? get duration;
  @override
  String get language;

  /// Create a copy of ContentMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContentMetadataImplCopyWith<_$ContentMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProcessedContent _$ProcessedContentFromJson(Map<String, dynamic> json) {
  return _ProcessedContent.fromJson(json);
}

/// @nodoc
mixin _$ProcessedContent {
  String? get summary => throw _privateConstructorUsedError;
  List<String> get keyPoints => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String? get thumbnail => throw _privateConstructorUsedError;
  List<String> get concepts => throw _privateConstructorUsedError;
  DifficultyLevel get difficulty => throw _privateConstructorUsedError;
  int? get readingTime => throw _privateConstructorUsedError;

  /// Serializes this ProcessedContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProcessedContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProcessedContentCopyWith<ProcessedContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProcessedContentCopyWith<$Res> {
  factory $ProcessedContentCopyWith(
          ProcessedContent value, $Res Function(ProcessedContent) then) =
      _$ProcessedContentCopyWithImpl<$Res, ProcessedContent>;
  @useResult
  $Res call(
      {String? summary,
      List<String> keyPoints,
      List<String> tags,
      String? thumbnail,
      List<String> concepts,
      DifficultyLevel difficulty,
      int? readingTime});
}

/// @nodoc
class _$ProcessedContentCopyWithImpl<$Res, $Val extends ProcessedContent>
    implements $ProcessedContentCopyWith<$Res> {
  _$ProcessedContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProcessedContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = freezed,
    Object? keyPoints = null,
    Object? tags = null,
    Object? thumbnail = freezed,
    Object? concepts = null,
    Object? difficulty = null,
    Object? readingTime = freezed,
  }) {
    return _then(_value.copyWith(
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      keyPoints: null == keyPoints
          ? _value.keyPoints
          : keyPoints // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      concepts: null == concepts
          ? _value.concepts
          : concepts // ignore: cast_nullable_to_non_nullable
              as List<String>,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as DifficultyLevel,
      readingTime: freezed == readingTime
          ? _value.readingTime
          : readingTime // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProcessedContentImplCopyWith<$Res>
    implements $ProcessedContentCopyWith<$Res> {
  factory _$$ProcessedContentImplCopyWith(_$ProcessedContentImpl value,
          $Res Function(_$ProcessedContentImpl) then) =
      __$$ProcessedContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? summary,
      List<String> keyPoints,
      List<String> tags,
      String? thumbnail,
      List<String> concepts,
      DifficultyLevel difficulty,
      int? readingTime});
}

/// @nodoc
class __$$ProcessedContentImplCopyWithImpl<$Res>
    extends _$ProcessedContentCopyWithImpl<$Res, _$ProcessedContentImpl>
    implements _$$ProcessedContentImplCopyWith<$Res> {
  __$$ProcessedContentImplCopyWithImpl(_$ProcessedContentImpl _value,
      $Res Function(_$ProcessedContentImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProcessedContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = freezed,
    Object? keyPoints = null,
    Object? tags = null,
    Object? thumbnail = freezed,
    Object? concepts = null,
    Object? difficulty = null,
    Object? readingTime = freezed,
  }) {
    return _then(_$ProcessedContentImpl(
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      keyPoints: null == keyPoints
          ? _value._keyPoints
          : keyPoints // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      concepts: null == concepts
          ? _value._concepts
          : concepts // ignore: cast_nullable_to_non_nullable
              as List<String>,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as DifficultyLevel,
      readingTime: freezed == readingTime
          ? _value.readingTime
          : readingTime // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProcessedContentImpl implements _ProcessedContent {
  const _$ProcessedContentImpl(
      {this.summary,
      final List<String> keyPoints = const [],
      final List<String> tags = const [],
      this.thumbnail,
      final List<String> concepts = const [],
      this.difficulty = DifficultyLevel.intermediate,
      this.readingTime})
      : _keyPoints = keyPoints,
        _tags = tags,
        _concepts = concepts;

  factory _$ProcessedContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProcessedContentImplFromJson(json);

  @override
  final String? summary;
  final List<String> _keyPoints;
  @override
  @JsonKey()
  List<String> get keyPoints {
    if (_keyPoints is EqualUnmodifiableListView) return _keyPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keyPoints);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String? thumbnail;
  final List<String> _concepts;
  @override
  @JsonKey()
  List<String> get concepts {
    if (_concepts is EqualUnmodifiableListView) return _concepts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_concepts);
  }

  @override
  @JsonKey()
  final DifficultyLevel difficulty;
  @override
  final int? readingTime;

  @override
  String toString() {
    return 'ProcessedContent(summary: $summary, keyPoints: $keyPoints, tags: $tags, thumbnail: $thumbnail, concepts: $concepts, difficulty: $difficulty, readingTime: $readingTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProcessedContentImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality()
                .equals(other._keyPoints, _keyPoints) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            const DeepCollectionEquality().equals(other._concepts, _concepts) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.readingTime, readingTime) ||
                other.readingTime == readingTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      summary,
      const DeepCollectionEquality().hash(_keyPoints),
      const DeepCollectionEquality().hash(_tags),
      thumbnail,
      const DeepCollectionEquality().hash(_concepts),
      difficulty,
      readingTime);

  /// Create a copy of ProcessedContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProcessedContentImplCopyWith<_$ProcessedContentImpl> get copyWith =>
      __$$ProcessedContentImplCopyWithImpl<_$ProcessedContentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProcessedContentImplToJson(
      this,
    );
  }
}

abstract class _ProcessedContent implements ProcessedContent {
  const factory _ProcessedContent(
      {final String? summary,
      final List<String> keyPoints,
      final List<String> tags,
      final String? thumbnail,
      final List<String> concepts,
      final DifficultyLevel difficulty,
      final int? readingTime}) = _$ProcessedContentImpl;

  factory _ProcessedContent.fromJson(Map<String, dynamic> json) =
      _$ProcessedContentImpl.fromJson;

  @override
  String? get summary;
  @override
  List<String> get keyPoints;
  @override
  List<String> get tags;
  @override
  String? get thumbnail;
  @override
  List<String> get concepts;
  @override
  DifficultyLevel get difficulty;
  @override
  int? get readingTime;

  /// Create a copy of ProcessedContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProcessedContentImplCopyWith<_$ProcessedContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Flashcard _$FlashcardFromJson(Map<String, dynamic> json) {
  return _Flashcard.fromJson(json);
}

/// @nodoc
mixin _$Flashcard {
  String get id => throw _privateConstructorUsedError;
  String get front => throw _privateConstructorUsedError;
  String get back => throw _privateConstructorUsedError;
  DifficultyLevel? get difficulty => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  DateTime? get lastReviewedAt => throw _privateConstructorUsedError;
  DateTime? get nextReviewAt => throw _privateConstructorUsedError;
  double get easeFactor => throw _privateConstructorUsedError;

  /// Serializes this Flashcard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Flashcard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlashcardCopyWith<Flashcard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlashcardCopyWith<$Res> {
  factory $FlashcardCopyWith(Flashcard value, $Res Function(Flashcard) then) =
      _$FlashcardCopyWithImpl<$Res, Flashcard>;
  @useResult
  $Res call(
      {String id,
      String front,
      String back,
      DifficultyLevel? difficulty,
      String? imageUrl,
      int reviewCount,
      DateTime? lastReviewedAt,
      DateTime? nextReviewAt,
      double easeFactor});
}

/// @nodoc
class _$FlashcardCopyWithImpl<$Res, $Val extends Flashcard>
    implements $FlashcardCopyWith<$Res> {
  _$FlashcardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Flashcard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? front = null,
    Object? back = null,
    Object? difficulty = freezed,
    Object? imageUrl = freezed,
    Object? reviewCount = null,
    Object? lastReviewedAt = freezed,
    Object? nextReviewAt = freezed,
    Object? easeFactor = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      front: null == front
          ? _value.front
          : front // ignore: cast_nullable_to_non_nullable
              as String,
      back: null == back
          ? _value.back
          : back // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: freezed == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as DifficultyLevel?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastReviewedAt: freezed == lastReviewedAt
          ? _value.lastReviewedAt
          : lastReviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextReviewAt: freezed == nextReviewAt
          ? _value.nextReviewAt
          : nextReviewAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      easeFactor: null == easeFactor
          ? _value.easeFactor
          : easeFactor // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FlashcardImplCopyWith<$Res>
    implements $FlashcardCopyWith<$Res> {
  factory _$$FlashcardImplCopyWith(
          _$FlashcardImpl value, $Res Function(_$FlashcardImpl) then) =
      __$$FlashcardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String front,
      String back,
      DifficultyLevel? difficulty,
      String? imageUrl,
      int reviewCount,
      DateTime? lastReviewedAt,
      DateTime? nextReviewAt,
      double easeFactor});
}

/// @nodoc
class __$$FlashcardImplCopyWithImpl<$Res>
    extends _$FlashcardCopyWithImpl<$Res, _$FlashcardImpl>
    implements _$$FlashcardImplCopyWith<$Res> {
  __$$FlashcardImplCopyWithImpl(
      _$FlashcardImpl _value, $Res Function(_$FlashcardImpl) _then)
      : super(_value, _then);

  /// Create a copy of Flashcard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? front = null,
    Object? back = null,
    Object? difficulty = freezed,
    Object? imageUrl = freezed,
    Object? reviewCount = null,
    Object? lastReviewedAt = freezed,
    Object? nextReviewAt = freezed,
    Object? easeFactor = null,
  }) {
    return _then(_$FlashcardImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      front: null == front
          ? _value.front
          : front // ignore: cast_nullable_to_non_nullable
              as String,
      back: null == back
          ? _value.back
          : back // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: freezed == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as DifficultyLevel?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastReviewedAt: freezed == lastReviewedAt
          ? _value.lastReviewedAt
          : lastReviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextReviewAt: freezed == nextReviewAt
          ? _value.nextReviewAt
          : nextReviewAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      easeFactor: null == easeFactor
          ? _value.easeFactor
          : easeFactor // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FlashcardImpl implements _Flashcard {
  const _$FlashcardImpl(
      {required this.id,
      required this.front,
      required this.back,
      this.difficulty,
      this.imageUrl,
      this.reviewCount = 0,
      this.lastReviewedAt,
      this.nextReviewAt,
      this.easeFactor = 2.5});

  factory _$FlashcardImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlashcardImplFromJson(json);

  @override
  final String id;
  @override
  final String front;
  @override
  final String back;
  @override
  final DifficultyLevel? difficulty;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final int reviewCount;
  @override
  final DateTime? lastReviewedAt;
  @override
  final DateTime? nextReviewAt;
  @override
  @JsonKey()
  final double easeFactor;

  @override
  String toString() {
    return 'Flashcard(id: $id, front: $front, back: $back, difficulty: $difficulty, imageUrl: $imageUrl, reviewCount: $reviewCount, lastReviewedAt: $lastReviewedAt, nextReviewAt: $nextReviewAt, easeFactor: $easeFactor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlashcardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.front, front) || other.front == front) &&
            (identical(other.back, back) || other.back == back) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.lastReviewedAt, lastReviewedAt) ||
                other.lastReviewedAt == lastReviewedAt) &&
            (identical(other.nextReviewAt, nextReviewAt) ||
                other.nextReviewAt == nextReviewAt) &&
            (identical(other.easeFactor, easeFactor) ||
                other.easeFactor == easeFactor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, front, back, difficulty,
      imageUrl, reviewCount, lastReviewedAt, nextReviewAt, easeFactor);

  /// Create a copy of Flashcard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlashcardImplCopyWith<_$FlashcardImpl> get copyWith =>
      __$$FlashcardImplCopyWithImpl<_$FlashcardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FlashcardImplToJson(
      this,
    );
  }
}

abstract class _Flashcard implements Flashcard {
  const factory _Flashcard(
      {required final String id,
      required final String front,
      required final String back,
      final DifficultyLevel? difficulty,
      final String? imageUrl,
      final int reviewCount,
      final DateTime? lastReviewedAt,
      final DateTime? nextReviewAt,
      final double easeFactor}) = _$FlashcardImpl;

  factory _Flashcard.fromJson(Map<String, dynamic> json) =
      _$FlashcardImpl.fromJson;

  @override
  String get id;
  @override
  String get front;
  @override
  String get back;
  @override
  DifficultyLevel? get difficulty;
  @override
  String? get imageUrl;
  @override
  int get reviewCount;
  @override
  DateTime? get lastReviewedAt;
  @override
  DateTime? get nextReviewAt;
  @override
  double get easeFactor;

  /// Create a copy of Flashcard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlashcardImplCopyWith<_$FlashcardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) {
  return _QuizQuestion.fromJson(json);
}

/// @nodoc
mixin _$QuizQuestion {
  String get id => throw _privateConstructorUsedError;
  String get question => throw _privateConstructorUsedError;
  List<String> get options => throw _privateConstructorUsedError;
  int get correctAnswer => throw _privateConstructorUsedError;
  String? get explanation => throw _privateConstructorUsedError;
  DifficultyLevel get difficulty => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;

  /// Serializes this QuizQuestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizQuestionCopyWith<QuizQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizQuestionCopyWith<$Res> {
  factory $QuizQuestionCopyWith(
          QuizQuestion value, $Res Function(QuizQuestion) then) =
      _$QuizQuestionCopyWithImpl<$Res, QuizQuestion>;
  @useResult
  $Res call(
      {String id,
      String question,
      List<String> options,
      int correctAnswer,
      String? explanation,
      DifficultyLevel difficulty,
      int points});
}

/// @nodoc
class _$QuizQuestionCopyWithImpl<$Res, $Val extends QuizQuestion>
    implements $QuizQuestionCopyWith<$Res> {
  _$QuizQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? question = null,
    Object? options = null,
    Object? correctAnswer = null,
    Object? explanation = freezed,
    Object? difficulty = null,
    Object? points = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
      correctAnswer: null == correctAnswer
          ? _value.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as int,
      explanation: freezed == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String?,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as DifficultyLevel,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuizQuestionImplCopyWith<$Res>
    implements $QuizQuestionCopyWith<$Res> {
  factory _$$QuizQuestionImplCopyWith(
          _$QuizQuestionImpl value, $Res Function(_$QuizQuestionImpl) then) =
      __$$QuizQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String question,
      List<String> options,
      int correctAnswer,
      String? explanation,
      DifficultyLevel difficulty,
      int points});
}

/// @nodoc
class __$$QuizQuestionImplCopyWithImpl<$Res>
    extends _$QuizQuestionCopyWithImpl<$Res, _$QuizQuestionImpl>
    implements _$$QuizQuestionImplCopyWith<$Res> {
  __$$QuizQuestionImplCopyWithImpl(
      _$QuizQuestionImpl _value, $Res Function(_$QuizQuestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? question = null,
    Object? options = null,
    Object? correctAnswer = null,
    Object? explanation = freezed,
    Object? difficulty = null,
    Object? points = null,
  }) {
    return _then(_$QuizQuestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
      correctAnswer: null == correctAnswer
          ? _value.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as int,
      explanation: freezed == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String?,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as DifficultyLevel,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizQuestionImpl implements _QuizQuestion {
  const _$QuizQuestionImpl(
      {required this.id,
      required this.question,
      final List<String> options = const [],
      required this.correctAnswer,
      this.explanation,
      this.difficulty = DifficultyLevel.intermediate,
      this.points = 10})
      : _options = options;

  factory _$QuizQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizQuestionImplFromJson(json);

  @override
  final String id;
  @override
  final String question;
  final List<String> _options;
  @override
  @JsonKey()
  List<String> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  final int correctAnswer;
  @override
  final String? explanation;
  @override
  @JsonKey()
  final DifficultyLevel difficulty;
  @override
  @JsonKey()
  final int points;

  @override
  String toString() {
    return 'QuizQuestion(id: $id, question: $question, options: $options, correctAnswer: $correctAnswer, explanation: $explanation, difficulty: $difficulty, points: $points)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizQuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.question, question) ||
                other.question == question) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.correctAnswer, correctAnswer) ||
                other.correctAnswer == correctAnswer) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.points, points) || other.points == points));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      question,
      const DeepCollectionEquality().hash(_options),
      correctAnswer,
      explanation,
      difficulty,
      points);

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizQuestionImplCopyWith<_$QuizQuestionImpl> get copyWith =>
      __$$QuizQuestionImplCopyWithImpl<_$QuizQuestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizQuestionImplToJson(
      this,
    );
  }
}

abstract class _QuizQuestion implements QuizQuestion {
  const factory _QuizQuestion(
      {required final String id,
      required final String question,
      final List<String> options,
      required final int correctAnswer,
      final String? explanation,
      final DifficultyLevel difficulty,
      final int points}) = _$QuizQuestionImpl;

  factory _QuizQuestion.fromJson(Map<String, dynamic> json) =
      _$QuizQuestionImpl.fromJson;

  @override
  String get id;
  @override
  String get question;
  @override
  List<String> get options;
  @override
  int get correctAnswer;
  @override
  String? get explanation;
  @override
  DifficultyLevel get difficulty;
  @override
  int get points;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizQuestionImplCopyWith<_$QuizQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizAttempt _$QuizAttemptFromJson(Map<String, dynamic> json) {
  return _QuizAttempt.fromJson(json);
}

/// @nodoc
mixin _$QuizAttempt {
  int get score => throw _privateConstructorUsedError;
  int get totalQuestions => throw _privateConstructorUsedError;
  int get correctAnswers => throw _privateConstructorUsedError;
  int? get timeSpent => throw _privateConstructorUsedError;
  DateTime get completedAt => throw _privateConstructorUsedError;
  List<int> get answers => throw _privateConstructorUsedError;

  /// Serializes this QuizAttempt to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizAttempt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizAttemptCopyWith<QuizAttempt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizAttemptCopyWith<$Res> {
  factory $QuizAttemptCopyWith(
          QuizAttempt value, $Res Function(QuizAttempt) then) =
      _$QuizAttemptCopyWithImpl<$Res, QuizAttempt>;
  @useResult
  $Res call(
      {int score,
      int totalQuestions,
      int correctAnswers,
      int? timeSpent,
      DateTime completedAt,
      List<int> answers});
}

/// @nodoc
class _$QuizAttemptCopyWithImpl<$Res, $Val extends QuizAttempt>
    implements $QuizAttemptCopyWith<$Res> {
  _$QuizAttemptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizAttempt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? totalQuestions = null,
    Object? correctAnswers = null,
    Object? timeSpent = freezed,
    Object? completedAt = null,
    Object? answers = null,
  }) {
    return _then(_value.copyWith(
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      correctAnswers: null == correctAnswers
          ? _value.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      timeSpent: freezed == timeSpent
          ? _value.timeSpent
          : timeSpent // ignore: cast_nullable_to_non_nullable
              as int?,
      completedAt: null == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      answers: null == answers
          ? _value.answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuizAttemptImplCopyWith<$Res>
    implements $QuizAttemptCopyWith<$Res> {
  factory _$$QuizAttemptImplCopyWith(
          _$QuizAttemptImpl value, $Res Function(_$QuizAttemptImpl) then) =
      __$$QuizAttemptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int score,
      int totalQuestions,
      int correctAnswers,
      int? timeSpent,
      DateTime completedAt,
      List<int> answers});
}

/// @nodoc
class __$$QuizAttemptImplCopyWithImpl<$Res>
    extends _$QuizAttemptCopyWithImpl<$Res, _$QuizAttemptImpl>
    implements _$$QuizAttemptImplCopyWith<$Res> {
  __$$QuizAttemptImplCopyWithImpl(
      _$QuizAttemptImpl _value, $Res Function(_$QuizAttemptImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuizAttempt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? totalQuestions = null,
    Object? correctAnswers = null,
    Object? timeSpent = freezed,
    Object? completedAt = null,
    Object? answers = null,
  }) {
    return _then(_$QuizAttemptImpl(
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      correctAnswers: null == correctAnswers
          ? _value.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      timeSpent: freezed == timeSpent
          ? _value.timeSpent
          : timeSpent // ignore: cast_nullable_to_non_nullable
              as int?,
      completedAt: null == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      answers: null == answers
          ? _value._answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizAttemptImpl implements _QuizAttempt {
  const _$QuizAttemptImpl(
      {required this.score,
      required this.totalQuestions,
      required this.correctAnswers,
      this.timeSpent,
      required this.completedAt,
      final List<int> answers = const []})
      : _answers = answers;

  factory _$QuizAttemptImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizAttemptImplFromJson(json);

  @override
  final int score;
  @override
  final int totalQuestions;
  @override
  final int correctAnswers;
  @override
  final int? timeSpent;
  @override
  final DateTime completedAt;
  final List<int> _answers;
  @override
  @JsonKey()
  List<int> get answers {
    if (_answers is EqualUnmodifiableListView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_answers);
  }

  @override
  String toString() {
    return 'QuizAttempt(score: $score, totalQuestions: $totalQuestions, correctAnswers: $correctAnswers, timeSpent: $timeSpent, completedAt: $completedAt, answers: $answers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizAttemptImpl &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.correctAnswers, correctAnswers) ||
                other.correctAnswers == correctAnswers) &&
            (identical(other.timeSpent, timeSpent) ||
                other.timeSpent == timeSpent) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            const DeepCollectionEquality().equals(other._answers, _answers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      score,
      totalQuestions,
      correctAnswers,
      timeSpent,
      completedAt,
      const DeepCollectionEquality().hash(_answers));

  /// Create a copy of QuizAttempt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizAttemptImplCopyWith<_$QuizAttemptImpl> get copyWith =>
      __$$QuizAttemptImplCopyWithImpl<_$QuizAttemptImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizAttemptImplToJson(
      this,
    );
  }
}

abstract class _QuizAttempt implements QuizAttempt {
  const factory _QuizAttempt(
      {required final int score,
      required final int totalQuestions,
      required final int correctAnswers,
      final int? timeSpent,
      required final DateTime completedAt,
      final List<int> answers}) = _$QuizAttemptImpl;

  factory _QuizAttempt.fromJson(Map<String, dynamic> json) =
      _$QuizAttemptImpl.fromJson;

  @override
  int get score;
  @override
  int get totalQuestions;
  @override
  int get correctAnswers;
  @override
  int? get timeSpent;
  @override
  DateTime get completedAt;
  @override
  List<int> get answers;

  /// Create a copy of QuizAttempt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizAttemptImplCopyWith<_$QuizAttemptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LearningMaterials _$LearningMaterialsFromJson(Map<String, dynamic> json) {
  return _LearningMaterials.fromJson(json);
}

/// @nodoc
mixin _$LearningMaterials {
  List<Flashcard> get flashcards => throw _privateConstructorUsedError;
  Quiz? get quiz => throw _privateConstructorUsedError;
  List<String> get learningPath => throw _privateConstructorUsedError;

  /// Serializes this LearningMaterials to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LearningMaterials
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LearningMaterialsCopyWith<LearningMaterials> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningMaterialsCopyWith<$Res> {
  factory $LearningMaterialsCopyWith(
          LearningMaterials value, $Res Function(LearningMaterials) then) =
      _$LearningMaterialsCopyWithImpl<$Res, LearningMaterials>;
  @useResult
  $Res call(
      {List<Flashcard> flashcards, Quiz? quiz, List<String> learningPath});

  $QuizCopyWith<$Res>? get quiz;
}

/// @nodoc
class _$LearningMaterialsCopyWithImpl<$Res, $Val extends LearningMaterials>
    implements $LearningMaterialsCopyWith<$Res> {
  _$LearningMaterialsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LearningMaterials
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flashcards = null,
    Object? quiz = freezed,
    Object? learningPath = null,
  }) {
    return _then(_value.copyWith(
      flashcards: null == flashcards
          ? _value.flashcards
          : flashcards // ignore: cast_nullable_to_non_nullable
              as List<Flashcard>,
      quiz: freezed == quiz
          ? _value.quiz
          : quiz // ignore: cast_nullable_to_non_nullable
              as Quiz?,
      learningPath: null == learningPath
          ? _value.learningPath
          : learningPath // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  /// Create a copy of LearningMaterials
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuizCopyWith<$Res>? get quiz {
    if (_value.quiz == null) {
      return null;
    }

    return $QuizCopyWith<$Res>(_value.quiz!, (value) {
      return _then(_value.copyWith(quiz: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LearningMaterialsImplCopyWith<$Res>
    implements $LearningMaterialsCopyWith<$Res> {
  factory _$$LearningMaterialsImplCopyWith(_$LearningMaterialsImpl value,
          $Res Function(_$LearningMaterialsImpl) then) =
      __$$LearningMaterialsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Flashcard> flashcards, Quiz? quiz, List<String> learningPath});

  @override
  $QuizCopyWith<$Res>? get quiz;
}

/// @nodoc
class __$$LearningMaterialsImplCopyWithImpl<$Res>
    extends _$LearningMaterialsCopyWithImpl<$Res, _$LearningMaterialsImpl>
    implements _$$LearningMaterialsImplCopyWith<$Res> {
  __$$LearningMaterialsImplCopyWithImpl(_$LearningMaterialsImpl _value,
      $Res Function(_$LearningMaterialsImpl) _then)
      : super(_value, _then);

  /// Create a copy of LearningMaterials
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flashcards = null,
    Object? quiz = freezed,
    Object? learningPath = null,
  }) {
    return _then(_$LearningMaterialsImpl(
      flashcards: null == flashcards
          ? _value._flashcards
          : flashcards // ignore: cast_nullable_to_non_nullable
              as List<Flashcard>,
      quiz: freezed == quiz
          ? _value.quiz
          : quiz // ignore: cast_nullable_to_non_nullable
              as Quiz?,
      learningPath: null == learningPath
          ? _value._learningPath
          : learningPath // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningMaterialsImpl implements _LearningMaterials {
  const _$LearningMaterialsImpl(
      {final List<Flashcard> flashcards = const [],
      this.quiz,
      final List<String> learningPath = const []})
      : _flashcards = flashcards,
        _learningPath = learningPath;

  factory _$LearningMaterialsImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningMaterialsImplFromJson(json);

  final List<Flashcard> _flashcards;
  @override
  @JsonKey()
  List<Flashcard> get flashcards {
    if (_flashcards is EqualUnmodifiableListView) return _flashcards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_flashcards);
  }

  @override
  final Quiz? quiz;
  final List<String> _learningPath;
  @override
  @JsonKey()
  List<String> get learningPath {
    if (_learningPath is EqualUnmodifiableListView) return _learningPath;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_learningPath);
  }

  @override
  String toString() {
    return 'LearningMaterials(flashcards: $flashcards, quiz: $quiz, learningPath: $learningPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningMaterialsImpl &&
            const DeepCollectionEquality()
                .equals(other._flashcards, _flashcards) &&
            (identical(other.quiz, quiz) || other.quiz == quiz) &&
            const DeepCollectionEquality()
                .equals(other._learningPath, _learningPath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_flashcards),
      quiz,
      const DeepCollectionEquality().hash(_learningPath));

  /// Create a copy of LearningMaterials
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningMaterialsImplCopyWith<_$LearningMaterialsImpl> get copyWith =>
      __$$LearningMaterialsImplCopyWithImpl<_$LearningMaterialsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningMaterialsImplToJson(
      this,
    );
  }
}

abstract class _LearningMaterials implements LearningMaterials {
  const factory _LearningMaterials(
      {final List<Flashcard> flashcards,
      final Quiz? quiz,
      final List<String> learningPath}) = _$LearningMaterialsImpl;

  factory _LearningMaterials.fromJson(Map<String, dynamic> json) =
      _$LearningMaterialsImpl.fromJson;

  @override
  List<Flashcard> get flashcards;
  @override
  Quiz? get quiz;
  @override
  List<String> get learningPath;

  /// Create a copy of LearningMaterials
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LearningMaterialsImplCopyWith<_$LearningMaterialsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Quiz _$QuizFromJson(Map<String, dynamic> json) {
  return _Quiz.fromJson(json);
}

/// @nodoc
mixin _$Quiz {
  List<QuizQuestion> get questions => throw _privateConstructorUsedError;
  List<QuizAttempt> get attempts => throw _privateConstructorUsedError;

  /// Serializes this Quiz to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizCopyWith<Quiz> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizCopyWith<$Res> {
  factory $QuizCopyWith(Quiz value, $Res Function(Quiz) then) =
      _$QuizCopyWithImpl<$Res, Quiz>;
  @useResult
  $Res call({List<QuizQuestion> questions, List<QuizAttempt> attempts});
}

/// @nodoc
class _$QuizCopyWithImpl<$Res, $Val extends Quiz>
    implements $QuizCopyWith<$Res> {
  _$QuizCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questions = null,
    Object? attempts = null,
  }) {
    return _then(_value.copyWith(
      questions: null == questions
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<QuizQuestion>,
      attempts: null == attempts
          ? _value.attempts
          : attempts // ignore: cast_nullable_to_non_nullable
              as List<QuizAttempt>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuizImplCopyWith<$Res> implements $QuizCopyWith<$Res> {
  factory _$$QuizImplCopyWith(
          _$QuizImpl value, $Res Function(_$QuizImpl) then) =
      __$$QuizImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<QuizQuestion> questions, List<QuizAttempt> attempts});
}

/// @nodoc
class __$$QuizImplCopyWithImpl<$Res>
    extends _$QuizCopyWithImpl<$Res, _$QuizImpl>
    implements _$$QuizImplCopyWith<$Res> {
  __$$QuizImplCopyWithImpl(_$QuizImpl _value, $Res Function(_$QuizImpl) _then)
      : super(_value, _then);

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questions = null,
    Object? attempts = null,
  }) {
    return _then(_$QuizImpl(
      questions: null == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<QuizQuestion>,
      attempts: null == attempts
          ? _value._attempts
          : attempts // ignore: cast_nullable_to_non_nullable
              as List<QuizAttempt>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizImpl implements _Quiz {
  const _$QuizImpl(
      {final List<QuizQuestion> questions = const [],
      final List<QuizAttempt> attempts = const []})
      : _questions = questions,
        _attempts = attempts;

  factory _$QuizImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizImplFromJson(json);

  final List<QuizQuestion> _questions;
  @override
  @JsonKey()
  List<QuizQuestion> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  final List<QuizAttempt> _attempts;
  @override
  @JsonKey()
  List<QuizAttempt> get attempts {
    if (_attempts is EqualUnmodifiableListView) return _attempts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attempts);
  }

  @override
  String toString() {
    return 'Quiz(questions: $questions, attempts: $attempts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizImpl &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions) &&
            const DeepCollectionEquality().equals(other._attempts, _attempts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_questions),
      const DeepCollectionEquality().hash(_attempts));

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizImplCopyWith<_$QuizImpl> get copyWith =>
      __$$QuizImplCopyWithImpl<_$QuizImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizImplToJson(
      this,
    );
  }
}

abstract class _Quiz implements Quiz {
  const factory _Quiz(
      {final List<QuizQuestion> questions,
      final List<QuizAttempt> attempts}) = _$QuizImpl;

  factory _Quiz.fromJson(Map<String, dynamic> json) = _$QuizImpl.fromJson;

  @override
  List<QuizQuestion> get questions;
  @override
  List<QuizAttempt> get attempts;

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizImplCopyWith<_$QuizImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserInteractions _$UserInteractionsFromJson(Map<String, dynamic> json) {
  return _UserInteractions.fromJson(json);
}

/// @nodoc
mixin _$UserInteractions {
  bool get isRead => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  int? get rating => throw _privateConstructorUsedError;
  DateTime? get readAt => throw _privateConstructorUsedError;

  /// Serializes this UserInteractions to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserInteractions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserInteractionsCopyWith<UserInteractions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserInteractionsCopyWith<$Res> {
  factory $UserInteractionsCopyWith(
          UserInteractions value, $Res Function(UserInteractions) then) =
      _$UserInteractionsCopyWithImpl<$Res, UserInteractions>;
  @useResult
  $Res call({bool isRead, bool isFavorite, int? rating, DateTime? readAt});
}

/// @nodoc
class _$UserInteractionsCopyWithImpl<$Res, $Val extends UserInteractions>
    implements $UserInteractionsCopyWith<$Res> {
  _$UserInteractionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserInteractions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRead = null,
    Object? isFavorite = null,
    Object? rating = freezed,
    Object? readAt = freezed,
  }) {
    return _then(_value.copyWith(
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserInteractionsImplCopyWith<$Res>
    implements $UserInteractionsCopyWith<$Res> {
  factory _$$UserInteractionsImplCopyWith(_$UserInteractionsImpl value,
          $Res Function(_$UserInteractionsImpl) then) =
      __$$UserInteractionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isRead, bool isFavorite, int? rating, DateTime? readAt});
}

/// @nodoc
class __$$UserInteractionsImplCopyWithImpl<$Res>
    extends _$UserInteractionsCopyWithImpl<$Res, _$UserInteractionsImpl>
    implements _$$UserInteractionsImplCopyWith<$Res> {
  __$$UserInteractionsImplCopyWithImpl(_$UserInteractionsImpl _value,
      $Res Function(_$UserInteractionsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserInteractions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRead = null,
    Object? isFavorite = null,
    Object? rating = freezed,
    Object? readAt = freezed,
  }) {
    return _then(_$UserInteractionsImpl(
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserInteractionsImpl implements _UserInteractions {
  const _$UserInteractionsImpl(
      {this.isRead = false, this.isFavorite = false, this.rating, this.readAt});

  factory _$UserInteractionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserInteractionsImplFromJson(json);

  @override
  @JsonKey()
  final bool isRead;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  final int? rating;
  @override
  final DateTime? readAt;

  @override
  String toString() {
    return 'UserInteractions(isRead: $isRead, isFavorite: $isFavorite, rating: $rating, readAt: $readAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserInteractionsImpl &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.readAt, readAt) || other.readAt == readAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, isRead, isFavorite, rating, readAt);

  /// Create a copy of UserInteractions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserInteractionsImplCopyWith<_$UserInteractionsImpl> get copyWith =>
      __$$UserInteractionsImplCopyWithImpl<_$UserInteractionsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserInteractionsImplToJson(
      this,
    );
  }
}

abstract class _UserInteractions implements UserInteractions {
  const factory _UserInteractions(
      {final bool isRead,
      final bool isFavorite,
      final int? rating,
      final DateTime? readAt}) = _$UserInteractionsImpl;

  factory _UserInteractions.fromJson(Map<String, dynamic> json) =
      _$UserInteractionsImpl.fromJson;

  @override
  bool get isRead;
  @override
  bool get isFavorite;
  @override
  int? get rating;
  @override
  DateTime? get readAt;

  /// Create a copy of UserInteractions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserInteractionsImplCopyWith<_$UserInteractionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$EntityModel {
  String get id => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  ContentType get type => throw _privateConstructorUsedError;
  ContentStatus get status => throw _privateConstructorUsedError;
  ContentMetadata get metadata => throw _privateConstructorUsedError;
  ProcessedContent? get processedContent => throw _privateConstructorUsedError;
  LearningMaterials? get learningMaterials =>
      throw _privateConstructorUsedError;
  UserInteractions get userInteractions => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of EntityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EntityModelCopyWith<EntityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntityModelCopyWith<$Res> {
  factory $EntityModelCopyWith(
          EntityModel value, $Res Function(EntityModel) then) =
      _$EntityModelCopyWithImpl<$Res, EntityModel>;
  @useResult
  $Res call(
      {String id,
      String url,
      String title,
      String description,
      String userId,
      List<String> tags,
      ContentType type,
      ContentStatus status,
      ContentMetadata metadata,
      ProcessedContent? processedContent,
      LearningMaterials? learningMaterials,
      UserInteractions userInteractions,
      DateTime createdAt,
      DateTime updatedAt});

  $ContentMetadataCopyWith<$Res> get metadata;
  $ProcessedContentCopyWith<$Res>? get processedContent;
  $LearningMaterialsCopyWith<$Res>? get learningMaterials;
  $UserInteractionsCopyWith<$Res> get userInteractions;
}

/// @nodoc
class _$EntityModelCopyWithImpl<$Res, $Val extends EntityModel>
    implements $EntityModelCopyWith<$Res> {
  _$EntityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EntityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? title = null,
    Object? description = null,
    Object? userId = null,
    Object? tags = null,
    Object? type = null,
    Object? status = null,
    Object? metadata = null,
    Object? processedContent = freezed,
    Object? learningMaterials = freezed,
    Object? userInteractions = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ContentType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ContentStatus,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as ContentMetadata,
      processedContent: freezed == processedContent
          ? _value.processedContent
          : processedContent // ignore: cast_nullable_to_non_nullable
              as ProcessedContent?,
      learningMaterials: freezed == learningMaterials
          ? _value.learningMaterials
          : learningMaterials // ignore: cast_nullable_to_non_nullable
              as LearningMaterials?,
      userInteractions: null == userInteractions
          ? _value.userInteractions
          : userInteractions // ignore: cast_nullable_to_non_nullable
              as UserInteractions,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of EntityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContentMetadataCopyWith<$Res> get metadata {
    return $ContentMetadataCopyWith<$Res>(_value.metadata, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }

  /// Create a copy of EntityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProcessedContentCopyWith<$Res>? get processedContent {
    if (_value.processedContent == null) {
      return null;
    }

    return $ProcessedContentCopyWith<$Res>(_value.processedContent!, (value) {
      return _then(_value.copyWith(processedContent: value) as $Val);
    });
  }

  /// Create a copy of EntityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LearningMaterialsCopyWith<$Res>? get learningMaterials {
    if (_value.learningMaterials == null) {
      return null;
    }

    return $LearningMaterialsCopyWith<$Res>(_value.learningMaterials!, (value) {
      return _then(_value.copyWith(learningMaterials: value) as $Val);
    });
  }

  /// Create a copy of EntityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserInteractionsCopyWith<$Res> get userInteractions {
    return $UserInteractionsCopyWith<$Res>(_value.userInteractions, (value) {
      return _then(_value.copyWith(userInteractions: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EntityModelImplCopyWith<$Res>
    implements $EntityModelCopyWith<$Res> {
  factory _$$EntityModelImplCopyWith(
          _$EntityModelImpl value, $Res Function(_$EntityModelImpl) then) =
      __$$EntityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String url,
      String title,
      String description,
      String userId,
      List<String> tags,
      ContentType type,
      ContentStatus status,
      ContentMetadata metadata,
      ProcessedContent? processedContent,
      LearningMaterials? learningMaterials,
      UserInteractions userInteractions,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $ContentMetadataCopyWith<$Res> get metadata;
  @override
  $ProcessedContentCopyWith<$Res>? get processedContent;
  @override
  $LearningMaterialsCopyWith<$Res>? get learningMaterials;
  @override
  $UserInteractionsCopyWith<$Res> get userInteractions;
}

/// @nodoc
class __$$EntityModelImplCopyWithImpl<$Res>
    extends _$EntityModelCopyWithImpl<$Res, _$EntityModelImpl>
    implements _$$EntityModelImplCopyWith<$Res> {
  __$$EntityModelImplCopyWithImpl(
      _$EntityModelImpl _value, $Res Function(_$EntityModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of EntityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? title = null,
    Object? description = null,
    Object? userId = null,
    Object? tags = null,
    Object? type = null,
    Object? status = null,
    Object? metadata = null,
    Object? processedContent = freezed,
    Object? learningMaterials = freezed,
    Object? userInteractions = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$EntityModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ContentType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ContentStatus,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as ContentMetadata,
      processedContent: freezed == processedContent
          ? _value.processedContent
          : processedContent // ignore: cast_nullable_to_non_nullable
              as ProcessedContent?,
      learningMaterials: freezed == learningMaterials
          ? _value.learningMaterials
          : learningMaterials // ignore: cast_nullable_to_non_nullable
              as LearningMaterials?,
      userInteractions: null == userInteractions
          ? _value.userInteractions
          : userInteractions // ignore: cast_nullable_to_non_nullable
              as UserInteractions,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$EntityModelImpl extends _EntityModel {
  const _$EntityModelImpl(
      {required this.id,
      required this.url,
      required this.title,
      required this.description,
      required this.userId,
      final List<String> tags = const [],
      this.type = ContentType.article,
      this.status = ContentStatus.pending,
      required this.metadata,
      this.processedContent,
      this.learningMaterials,
      this.userInteractions = const UserInteractions(),
      required this.createdAt,
      required this.updatedAt})
      : _tags = tags,
        super._();

  @override
  final String id;
  @override
  final String url;
  @override
  final String title;
  @override
  final String description;
  @override
  final String userId;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final ContentType type;
  @override
  @JsonKey()
  final ContentStatus status;
  @override
  final ContentMetadata metadata;
  @override
  final ProcessedContent? processedContent;
  @override
  final LearningMaterials? learningMaterials;
  @override
  @JsonKey()
  final UserInteractions userInteractions;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'EntityModel(id: $id, url: $url, title: $title, description: $description, userId: $userId, tags: $tags, type: $type, status: $status, metadata: $metadata, processedContent: $processedContent, learningMaterials: $learningMaterials, userInteractions: $userInteractions, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntityModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata) &&
            (identical(other.processedContent, processedContent) ||
                other.processedContent == processedContent) &&
            (identical(other.learningMaterials, learningMaterials) ||
                other.learningMaterials == learningMaterials) &&
            (identical(other.userInteractions, userInteractions) ||
                other.userInteractions == userInteractions) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      url,
      title,
      description,
      userId,
      const DeepCollectionEquality().hash(_tags),
      type,
      status,
      metadata,
      processedContent,
      learningMaterials,
      userInteractions,
      createdAt,
      updatedAt);

  /// Create a copy of EntityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EntityModelImplCopyWith<_$EntityModelImpl> get copyWith =>
      __$$EntityModelImplCopyWithImpl<_$EntityModelImpl>(this, _$identity);
}

abstract class _EntityModel extends EntityModel {
  const factory _EntityModel(
      {required final String id,
      required final String url,
      required final String title,
      required final String description,
      required final String userId,
      final List<String> tags,
      final ContentType type,
      final ContentStatus status,
      required final ContentMetadata metadata,
      final ProcessedContent? processedContent,
      final LearningMaterials? learningMaterials,
      final UserInteractions userInteractions,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$EntityModelImpl;
  const _EntityModel._() : super._();

  @override
  String get id;
  @override
  String get url;
  @override
  String get title;
  @override
  String get description;
  @override
  String get userId;
  @override
  List<String> get tags;
  @override
  ContentType get type;
  @override
  ContentStatus get status;
  @override
  ContentMetadata get metadata;
  @override
  ProcessedContent? get processedContent;
  @override
  LearningMaterials? get learningMaterials;
  @override
  UserInteractions get userInteractions;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of EntityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EntityModelImplCopyWith<_$EntityModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
