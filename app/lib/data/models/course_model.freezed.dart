// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CourseLesson _$CourseLessonFromJson(Map<String, dynamic> json) {
  return _CourseLesson.fromJson(json);
}

/// @nodoc
mixin _$CourseLesson {
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  /// Serializes this CourseLesson to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseLesson
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseLessonCopyWith<CourseLesson> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseLessonCopyWith<$Res> {
  factory $CourseLessonCopyWith(
          CourseLesson value, $Res Function(CourseLesson) then) =
      _$CourseLessonCopyWithImpl<$Res, CourseLesson>;
  @useResult
  $Res call({String title, String content, int order});
}

/// @nodoc
class _$CourseLessonCopyWithImpl<$Res, $Val extends CourseLesson>
    implements $CourseLessonCopyWith<$Res> {
  _$CourseLessonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseLesson
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? content = null,
    Object? order = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CourseLessonImplCopyWith<$Res>
    implements $CourseLessonCopyWith<$Res> {
  factory _$$CourseLessonImplCopyWith(
          _$CourseLessonImpl value, $Res Function(_$CourseLessonImpl) then) =
      __$$CourseLessonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String content, int order});
}

/// @nodoc
class __$$CourseLessonImplCopyWithImpl<$Res>
    extends _$CourseLessonCopyWithImpl<$Res, _$CourseLessonImpl>
    implements _$$CourseLessonImplCopyWith<$Res> {
  __$$CourseLessonImplCopyWithImpl(
      _$CourseLessonImpl _value, $Res Function(_$CourseLessonImpl) _then)
      : super(_value, _then);

  /// Create a copy of CourseLesson
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? content = null,
    Object? order = null,
  }) {
    return _then(_$CourseLessonImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseLessonImpl implements _CourseLesson {
  const _$CourseLessonImpl(
      {required this.title, required this.content, required this.order});

  factory _$CourseLessonImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseLessonImplFromJson(json);

  @override
  final String title;
  @override
  final String content;
  @override
  final int order;

  @override
  String toString() {
    return 'CourseLesson(title: $title, content: $content, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseLessonImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, content, order);

  /// Create a copy of CourseLesson
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseLessonImplCopyWith<_$CourseLessonImpl> get copyWith =>
      __$$CourseLessonImplCopyWithImpl<_$CourseLessonImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseLessonImplToJson(
      this,
    );
  }
}

abstract class _CourseLesson implements CourseLesson {
  const factory _CourseLesson(
      {required final String title,
      required final String content,
      required final int order}) = _$CourseLessonImpl;

  factory _CourseLesson.fromJson(Map<String, dynamic> json) =
      _$CourseLessonImpl.fromJson;

  @override
  String get title;
  @override
  String get content;
  @override
  int get order;

  /// Create a copy of CourseLesson
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseLessonImplCopyWith<_$CourseLessonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) {
  return _CourseModel.fromJson(json);
}

/// @nodoc
mixin _$CourseModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  CourseContent get content => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CourseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseModelCopyWith<CourseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseModelCopyWith<$Res> {
  factory $CourseModelCopyWith(
          CourseModel value, $Res Function(CourseModel) then) =
      _$CourseModelCopyWithImpl<$Res, CourseModel>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      CourseContent content,
      DateTime createdAt,
      DateTime updatedAt});

  $CourseContentCopyWith<$Res> get content;
}

/// @nodoc
class _$CourseModelCopyWithImpl<$Res, $Val extends CourseModel>
    implements $CourseModelCopyWith<$Res> {
  _$CourseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as CourseContent,
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

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CourseContentCopyWith<$Res> get content {
    return $CourseContentCopyWith<$Res>(_value.content, (value) {
      return _then(_value.copyWith(content: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CourseModelImplCopyWith<$Res>
    implements $CourseModelCopyWith<$Res> {
  factory _$$CourseModelImplCopyWith(
          _$CourseModelImpl value, $Res Function(_$CourseModelImpl) then) =
      __$$CourseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      CourseContent content,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $CourseContentCopyWith<$Res> get content;
}

/// @nodoc
class __$$CourseModelImplCopyWithImpl<$Res>
    extends _$CourseModelCopyWithImpl<$Res, _$CourseModelImpl>
    implements _$$CourseModelImplCopyWith<$Res> {
  __$$CourseModelImplCopyWithImpl(
      _$CourseModelImpl _value, $Res Function(_$CourseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$CourseModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as CourseContent,
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
@JsonSerializable()
class _$CourseModelImpl extends _CourseModel {
  const _$CourseModelImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.content,
      required this.createdAt,
      required this.updatedAt})
      : super._();

  factory _$CourseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final CourseContent content;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'CourseModel(id: $id, content: $content, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, content, createdAt, updatedAt);

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseModelImplCopyWith<_$CourseModelImpl> get copyWith =>
      __$$CourseModelImplCopyWithImpl<_$CourseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseModelImplToJson(
      this,
    );
  }
}

abstract class _CourseModel extends CourseModel {
  const factory _CourseModel(
      {@JsonKey(name: '_id') required final String id,
      required final CourseContent content,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$CourseModelImpl;
  const _CourseModel._() : super._();

  factory _CourseModel.fromJson(Map<String, dynamic> json) =
      _$CourseModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  CourseContent get content;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseModelImplCopyWith<_$CourseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CourseContent _$CourseContentFromJson(Map<String, dynamic> json) {
  return _CourseContent.fromJson(json);
}

/// @nodoc
mixin _$CourseContent {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<CourseLesson> get lessons => throw _privateConstructorUsedError;

  /// Serializes this CourseContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseContentCopyWith<CourseContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseContentCopyWith<$Res> {
  factory $CourseContentCopyWith(
          CourseContent value, $Res Function(CourseContent) then) =
      _$CourseContentCopyWithImpl<$Res, CourseContent>;
  @useResult
  $Res call({String title, String description, List<CourseLesson> lessons});
}

/// @nodoc
class _$CourseContentCopyWithImpl<$Res, $Val extends CourseContent>
    implements $CourseContentCopyWith<$Res> {
  _$CourseContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? lessons = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      lessons: null == lessons
          ? _value.lessons
          : lessons // ignore: cast_nullable_to_non_nullable
              as List<CourseLesson>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CourseContentImplCopyWith<$Res>
    implements $CourseContentCopyWith<$Res> {
  factory _$$CourseContentImplCopyWith(
          _$CourseContentImpl value, $Res Function(_$CourseContentImpl) then) =
      __$$CourseContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String description, List<CourseLesson> lessons});
}

/// @nodoc
class __$$CourseContentImplCopyWithImpl<$Res>
    extends _$CourseContentCopyWithImpl<$Res, _$CourseContentImpl>
    implements _$$CourseContentImplCopyWith<$Res> {
  __$$CourseContentImplCopyWithImpl(
      _$CourseContentImpl _value, $Res Function(_$CourseContentImpl) _then)
      : super(_value, _then);

  /// Create a copy of CourseContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? lessons = null,
  }) {
    return _then(_$CourseContentImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      lessons: null == lessons
          ? _value._lessons
          : lessons // ignore: cast_nullable_to_non_nullable
              as List<CourseLesson>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseContentImpl implements _CourseContent {
  const _$CourseContentImpl(
      {required this.title,
      required this.description,
      required final List<CourseLesson> lessons})
      : _lessons = lessons;

  factory _$CourseContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseContentImplFromJson(json);

  @override
  final String title;
  @override
  final String description;
  final List<CourseLesson> _lessons;
  @override
  List<CourseLesson> get lessons {
    if (_lessons is EqualUnmodifiableListView) return _lessons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lessons);
  }

  @override
  String toString() {
    return 'CourseContent(title: $title, description: $description, lessons: $lessons)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseContentImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._lessons, _lessons));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, description,
      const DeepCollectionEquality().hash(_lessons));

  /// Create a copy of CourseContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseContentImplCopyWith<_$CourseContentImpl> get copyWith =>
      __$$CourseContentImplCopyWithImpl<_$CourseContentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseContentImplToJson(
      this,
    );
  }
}

abstract class _CourseContent implements CourseContent {
  const factory _CourseContent(
      {required final String title,
      required final String description,
      required final List<CourseLesson> lessons}) = _$CourseContentImpl;

  factory _CourseContent.fromJson(Map<String, dynamic> json) =
      _$CourseContentImpl.fromJson;

  @override
  String get title;
  @override
  String get description;
  @override
  List<CourseLesson> get lessons;

  /// Create a copy of CourseContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseContentImplCopyWith<_$CourseContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
