// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'link_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Flashcard _$FlashcardFromJson(Map<String, dynamic> json) {
  return _Flashcard.fromJson(json);
}

/// @nodoc
mixin _$Flashcard {
  String get question => throw _privateConstructorUsedError;
  String get answer => throw _privateConstructorUsedError;
  String get difficulty => throw _privateConstructorUsedError;

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
  $Res call({String question, String answer, String difficulty});
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
    Object? question = null,
    Object? answer = null,
    Object? difficulty = null,
  }) {
    return _then(_value.copyWith(
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String,
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
  $Res call({String question, String answer, String difficulty});
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
    Object? question = null,
    Object? answer = null,
    Object? difficulty = null,
  }) {
    return _then(_$FlashcardImpl(
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FlashcardImpl implements _Flashcard {
  const _$FlashcardImpl(
      {required this.question,
      required this.answer,
      this.difficulty = 'medium'});

  factory _$FlashcardImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlashcardImplFromJson(json);

  @override
  final String question;
  @override
  final String answer;
  @override
  @JsonKey()
  final String difficulty;

  @override
  String toString() {
    return 'Flashcard(question: $question, answer: $answer, difficulty: $difficulty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlashcardImpl &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.answer, answer) || other.answer == answer) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, question, answer, difficulty);

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
      {required final String question,
      required final String answer,
      final String difficulty}) = _$FlashcardImpl;

  factory _Flashcard.fromJson(Map<String, dynamic> json) =
      _$FlashcardImpl.fromJson;

  @override
  String get question;
  @override
  String get answer;
  @override
  String get difficulty;

  /// Create a copy of Flashcard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlashcardImplCopyWith<_$FlashcardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FlashcardsContent _$FlashcardsContentFromJson(Map<String, dynamic> json) {
  return _FlashcardsContent.fromJson(json);
}

/// @nodoc
mixin _$FlashcardsContent {
  List<Flashcard> get flashcards => throw _privateConstructorUsedError;

  /// Serializes this FlashcardsContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FlashcardsContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlashcardsContentCopyWith<FlashcardsContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlashcardsContentCopyWith<$Res> {
  factory $FlashcardsContentCopyWith(
          FlashcardsContent value, $Res Function(FlashcardsContent) then) =
      _$FlashcardsContentCopyWithImpl<$Res, FlashcardsContent>;
  @useResult
  $Res call({List<Flashcard> flashcards});
}

/// @nodoc
class _$FlashcardsContentCopyWithImpl<$Res, $Val extends FlashcardsContent>
    implements $FlashcardsContentCopyWith<$Res> {
  _$FlashcardsContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlashcardsContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flashcards = null,
  }) {
    return _then(_value.copyWith(
      flashcards: null == flashcards
          ? _value.flashcards
          : flashcards // ignore: cast_nullable_to_non_nullable
              as List<Flashcard>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FlashcardsContentImplCopyWith<$Res>
    implements $FlashcardsContentCopyWith<$Res> {
  factory _$$FlashcardsContentImplCopyWith(_$FlashcardsContentImpl value,
          $Res Function(_$FlashcardsContentImpl) then) =
      __$$FlashcardsContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Flashcard> flashcards});
}

/// @nodoc
class __$$FlashcardsContentImplCopyWithImpl<$Res>
    extends _$FlashcardsContentCopyWithImpl<$Res, _$FlashcardsContentImpl>
    implements _$$FlashcardsContentImplCopyWith<$Res> {
  __$$FlashcardsContentImplCopyWithImpl(_$FlashcardsContentImpl _value,
      $Res Function(_$FlashcardsContentImpl) _then)
      : super(_value, _then);

  /// Create a copy of FlashcardsContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flashcards = null,
  }) {
    return _then(_$FlashcardsContentImpl(
      flashcards: null == flashcards
          ? _value._flashcards
          : flashcards // ignore: cast_nullable_to_non_nullable
              as List<Flashcard>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FlashcardsContentImpl implements _FlashcardsContent {
  const _$FlashcardsContentImpl({final List<Flashcard> flashcards = const []})
      : _flashcards = flashcards;

  factory _$FlashcardsContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlashcardsContentImplFromJson(json);

  final List<Flashcard> _flashcards;
  @override
  @JsonKey()
  List<Flashcard> get flashcards {
    if (_flashcards is EqualUnmodifiableListView) return _flashcards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_flashcards);
  }

  @override
  String toString() {
    return 'FlashcardsContent(flashcards: $flashcards)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlashcardsContentImpl &&
            const DeepCollectionEquality()
                .equals(other._flashcards, _flashcards));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_flashcards));

  /// Create a copy of FlashcardsContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlashcardsContentImplCopyWith<_$FlashcardsContentImpl> get copyWith =>
      __$$FlashcardsContentImplCopyWithImpl<_$FlashcardsContentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FlashcardsContentImplToJson(
      this,
    );
  }
}

abstract class _FlashcardsContent implements FlashcardsContent {
  const factory _FlashcardsContent({final List<Flashcard> flashcards}) =
      _$FlashcardsContentImpl;

  factory _FlashcardsContent.fromJson(Map<String, dynamic> json) =
      _$FlashcardsContentImpl.fromJson;

  @override
  List<Flashcard> get flashcards;

  /// Create a copy of FlashcardsContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlashcardsContentImplCopyWith<_$FlashcardsContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SummaryContent _$SummaryContentFromJson(Map<String, dynamic> json) {
  return _SummaryContent.fromJson(json);
}

/// @nodoc
mixin _$SummaryContent {
  List<String> get keyPoints => throw _privateConstructorUsedError;
  String get mainArgument => throw _privateConstructorUsedError;
  List<String> get takeaways => throw _privateConstructorUsedError;

  /// Serializes this SummaryContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SummaryContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SummaryContentCopyWith<SummaryContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SummaryContentCopyWith<$Res> {
  factory $SummaryContentCopyWith(
          SummaryContent value, $Res Function(SummaryContent) then) =
      _$SummaryContentCopyWithImpl<$Res, SummaryContent>;
  @useResult
  $Res call(
      {List<String> keyPoints, String mainArgument, List<String> takeaways});
}

/// @nodoc
class _$SummaryContentCopyWithImpl<$Res, $Val extends SummaryContent>
    implements $SummaryContentCopyWith<$Res> {
  _$SummaryContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SummaryContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keyPoints = null,
    Object? mainArgument = null,
    Object? takeaways = null,
  }) {
    return _then(_value.copyWith(
      keyPoints: null == keyPoints
          ? _value.keyPoints
          : keyPoints // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mainArgument: null == mainArgument
          ? _value.mainArgument
          : mainArgument // ignore: cast_nullable_to_non_nullable
              as String,
      takeaways: null == takeaways
          ? _value.takeaways
          : takeaways // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SummaryContentImplCopyWith<$Res>
    implements $SummaryContentCopyWith<$Res> {
  factory _$$SummaryContentImplCopyWith(_$SummaryContentImpl value,
          $Res Function(_$SummaryContentImpl) then) =
      __$$SummaryContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> keyPoints, String mainArgument, List<String> takeaways});
}

/// @nodoc
class __$$SummaryContentImplCopyWithImpl<$Res>
    extends _$SummaryContentCopyWithImpl<$Res, _$SummaryContentImpl>
    implements _$$SummaryContentImplCopyWith<$Res> {
  __$$SummaryContentImplCopyWithImpl(
      _$SummaryContentImpl _value, $Res Function(_$SummaryContentImpl) _then)
      : super(_value, _then);

  /// Create a copy of SummaryContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keyPoints = null,
    Object? mainArgument = null,
    Object? takeaways = null,
  }) {
    return _then(_$SummaryContentImpl(
      keyPoints: null == keyPoints
          ? _value._keyPoints
          : keyPoints // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mainArgument: null == mainArgument
          ? _value.mainArgument
          : mainArgument // ignore: cast_nullable_to_non_nullable
              as String,
      takeaways: null == takeaways
          ? _value._takeaways
          : takeaways // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SummaryContentImpl implements _SummaryContent {
  const _$SummaryContentImpl(
      {final List<String> keyPoints = const [],
      this.mainArgument = '',
      final List<String> takeaways = const []})
      : _keyPoints = keyPoints,
        _takeaways = takeaways;

  factory _$SummaryContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$SummaryContentImplFromJson(json);

  final List<String> _keyPoints;
  @override
  @JsonKey()
  List<String> get keyPoints {
    if (_keyPoints is EqualUnmodifiableListView) return _keyPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keyPoints);
  }

  @override
  @JsonKey()
  final String mainArgument;
  final List<String> _takeaways;
  @override
  @JsonKey()
  List<String> get takeaways {
    if (_takeaways is EqualUnmodifiableListView) return _takeaways;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_takeaways);
  }

  @override
  String toString() {
    return 'SummaryContent(keyPoints: $keyPoints, mainArgument: $mainArgument, takeaways: $takeaways)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SummaryContentImpl &&
            const DeepCollectionEquality()
                .equals(other._keyPoints, _keyPoints) &&
            (identical(other.mainArgument, mainArgument) ||
                other.mainArgument == mainArgument) &&
            const DeepCollectionEquality()
                .equals(other._takeaways, _takeaways));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_keyPoints),
      mainArgument,
      const DeepCollectionEquality().hash(_takeaways));

  /// Create a copy of SummaryContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SummaryContentImplCopyWith<_$SummaryContentImpl> get copyWith =>
      __$$SummaryContentImplCopyWithImpl<_$SummaryContentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SummaryContentImplToJson(
      this,
    );
  }
}

abstract class _SummaryContent implements SummaryContent {
  const factory _SummaryContent(
      {final List<String> keyPoints,
      final String mainArgument,
      final List<String> takeaways}) = _$SummaryContentImpl;

  factory _SummaryContent.fromJson(Map<String, dynamic> json) =
      _$SummaryContentImpl.fromJson;

  @override
  List<String> get keyPoints;
  @override
  String get mainArgument;
  @override
  List<String> get takeaways;

  /// Create a copy of SummaryContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SummaryContentImplCopyWith<_$SummaryContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LinkModel {
  String get id => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get projectId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get aiOutputId => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  LinkStatus get status => throw _privateConstructorUsedError;
  String? get statusMessage => throw _privateConstructorUsedError;
  SummaryContent? get summary => throw _privateConstructorUsedError;
  FlashcardsContent? get flashcards => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of LinkModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LinkModelCopyWith<LinkModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LinkModelCopyWith<$Res> {
  factory $LinkModelCopyWith(LinkModel value, $Res Function(LinkModel) then) =
      _$LinkModelCopyWithImpl<$Res, LinkModel>;
  @useResult
  $Res call(
      {String id,
      String url,
      String userId,
      String? projectId,
      String? title,
      String? aiOutputId,
      List<String> tags,
      LinkStatus status,
      String? statusMessage,
      SummaryContent? summary,
      FlashcardsContent? flashcards,
      DateTime createdAt,
      DateTime updatedAt});

  $SummaryContentCopyWith<$Res>? get summary;
  $FlashcardsContentCopyWith<$Res>? get flashcards;
}

/// @nodoc
class _$LinkModelCopyWithImpl<$Res, $Val extends LinkModel>
    implements $LinkModelCopyWith<$Res> {
  _$LinkModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LinkModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? userId = null,
    Object? projectId = freezed,
    Object? title = freezed,
    Object? aiOutputId = freezed,
    Object? tags = null,
    Object? status = null,
    Object? statusMessage = freezed,
    Object? summary = freezed,
    Object? flashcards = freezed,
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
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      aiOutputId: freezed == aiOutputId
          ? _value.aiOutputId
          : aiOutputId // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LinkStatus,
      statusMessage: freezed == statusMessage
          ? _value.statusMessage
          : statusMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as SummaryContent?,
      flashcards: freezed == flashcards
          ? _value.flashcards
          : flashcards // ignore: cast_nullable_to_non_nullable
              as FlashcardsContent?,
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

  /// Create a copy of LinkModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SummaryContentCopyWith<$Res>? get summary {
    if (_value.summary == null) {
      return null;
    }

    return $SummaryContentCopyWith<$Res>(_value.summary!, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }

  /// Create a copy of LinkModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FlashcardsContentCopyWith<$Res>? get flashcards {
    if (_value.flashcards == null) {
      return null;
    }

    return $FlashcardsContentCopyWith<$Res>(_value.flashcards!, (value) {
      return _then(_value.copyWith(flashcards: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LinkModelImplCopyWith<$Res>
    implements $LinkModelCopyWith<$Res> {
  factory _$$LinkModelImplCopyWith(
          _$LinkModelImpl value, $Res Function(_$LinkModelImpl) then) =
      __$$LinkModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String url,
      String userId,
      String? projectId,
      String? title,
      String? aiOutputId,
      List<String> tags,
      LinkStatus status,
      String? statusMessage,
      SummaryContent? summary,
      FlashcardsContent? flashcards,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $SummaryContentCopyWith<$Res>? get summary;
  @override
  $FlashcardsContentCopyWith<$Res>? get flashcards;
}

/// @nodoc
class __$$LinkModelImplCopyWithImpl<$Res>
    extends _$LinkModelCopyWithImpl<$Res, _$LinkModelImpl>
    implements _$$LinkModelImplCopyWith<$Res> {
  __$$LinkModelImplCopyWithImpl(
      _$LinkModelImpl _value, $Res Function(_$LinkModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LinkModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? userId = null,
    Object? projectId = freezed,
    Object? title = freezed,
    Object? aiOutputId = freezed,
    Object? tags = null,
    Object? status = null,
    Object? statusMessage = freezed,
    Object? summary = freezed,
    Object? flashcards = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$LinkModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      aiOutputId: freezed == aiOutputId
          ? _value.aiOutputId
          : aiOutputId // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LinkStatus,
      statusMessage: freezed == statusMessage
          ? _value.statusMessage
          : statusMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as SummaryContent?,
      flashcards: freezed == flashcards
          ? _value.flashcards
          : flashcards // ignore: cast_nullable_to_non_nullable
              as FlashcardsContent?,
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

class _$LinkModelImpl extends _LinkModel {
  const _$LinkModelImpl(
      {required this.id,
      required this.url,
      required this.userId,
      this.projectId,
      this.title,
      this.aiOutputId,
      final List<String> tags = const [],
      this.status = LinkStatus.pending,
      this.statusMessage,
      this.summary,
      this.flashcards,
      required this.createdAt,
      required this.updatedAt})
      : _tags = tags,
        super._();

  @override
  final String id;
  @override
  final String url;
  @override
  final String userId;
  @override
  final String? projectId;
  @override
  final String? title;
  @override
  final String? aiOutputId;
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
  final LinkStatus status;
  @override
  final String? statusMessage;
  @override
  final SummaryContent? summary;
  @override
  final FlashcardsContent? flashcards;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'LinkModel(id: $id, url: $url, userId: $userId, projectId: $projectId, title: $title, aiOutputId: $aiOutputId, tags: $tags, status: $status, statusMessage: $statusMessage, summary: $summary, flashcards: $flashcards, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LinkModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.aiOutputId, aiOutputId) ||
                other.aiOutputId == aiOutputId) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusMessage, statusMessage) ||
                other.statusMessage == statusMessage) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.flashcards, flashcards) ||
                other.flashcards == flashcards) &&
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
      userId,
      projectId,
      title,
      aiOutputId,
      const DeepCollectionEquality().hash(_tags),
      status,
      statusMessage,
      summary,
      flashcards,
      createdAt,
      updatedAt);

  /// Create a copy of LinkModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LinkModelImplCopyWith<_$LinkModelImpl> get copyWith =>
      __$$LinkModelImplCopyWithImpl<_$LinkModelImpl>(this, _$identity);
}

abstract class _LinkModel extends LinkModel {
  const factory _LinkModel(
      {required final String id,
      required final String url,
      required final String userId,
      final String? projectId,
      final String? title,
      final String? aiOutputId,
      final List<String> tags,
      final LinkStatus status,
      final String? statusMessage,
      final SummaryContent? summary,
      final FlashcardsContent? flashcards,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$LinkModelImpl;
  const _LinkModel._() : super._();

  @override
  String get id;
  @override
  String get url;
  @override
  String get userId;
  @override
  String? get projectId;
  @override
  String? get title;
  @override
  String? get aiOutputId;
  @override
  List<String> get tags;
  @override
  LinkStatus get status;
  @override
  String? get statusMessage;
  @override
  SummaryContent? get summary;
  @override
  FlashcardsContent? get flashcards;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of LinkModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LinkModelImplCopyWith<_$LinkModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
