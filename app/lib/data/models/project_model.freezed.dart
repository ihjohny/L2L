// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProjectAiOutput _$ProjectAiOutputFromJson(Map<String, dynamic> json) {
  return _ProjectAiOutput.fromJson(json);
}

/// @nodoc
mixin _$ProjectAiOutput {
  String? get courseId => throw _privateConstructorUsedError;
  String? get quizId => throw _privateConstructorUsedError;

  /// Serializes this ProjectAiOutput to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectAiOutput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectAiOutputCopyWith<ProjectAiOutput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectAiOutputCopyWith<$Res> {
  factory $ProjectAiOutputCopyWith(
          ProjectAiOutput value, $Res Function(ProjectAiOutput) then) =
      _$ProjectAiOutputCopyWithImpl<$Res, ProjectAiOutput>;
  @useResult
  $Res call({String? courseId, String? quizId});
}

/// @nodoc
class _$ProjectAiOutputCopyWithImpl<$Res, $Val extends ProjectAiOutput>
    implements $ProjectAiOutputCopyWith<$Res> {
  _$ProjectAiOutputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectAiOutput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseId = freezed,
    Object? quizId = freezed,
  }) {
    return _then(_value.copyWith(
      courseId: freezed == courseId
          ? _value.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as String?,
      quizId: freezed == quizId
          ? _value.quizId
          : quizId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectAiOutputImplCopyWith<$Res>
    implements $ProjectAiOutputCopyWith<$Res> {
  factory _$$ProjectAiOutputImplCopyWith(_$ProjectAiOutputImpl value,
          $Res Function(_$ProjectAiOutputImpl) then) =
      __$$ProjectAiOutputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? courseId, String? quizId});
}

/// @nodoc
class __$$ProjectAiOutputImplCopyWithImpl<$Res>
    extends _$ProjectAiOutputCopyWithImpl<$Res, _$ProjectAiOutputImpl>
    implements _$$ProjectAiOutputImplCopyWith<$Res> {
  __$$ProjectAiOutputImplCopyWithImpl(
      _$ProjectAiOutputImpl _value, $Res Function(_$ProjectAiOutputImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectAiOutput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseId = freezed,
    Object? quizId = freezed,
  }) {
    return _then(_$ProjectAiOutputImpl(
      courseId: freezed == courseId
          ? _value.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as String?,
      quizId: freezed == quizId
          ? _value.quizId
          : quizId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectAiOutputImpl implements _ProjectAiOutput {
  const _$ProjectAiOutputImpl({this.courseId, this.quizId});

  factory _$ProjectAiOutputImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectAiOutputImplFromJson(json);

  @override
  final String? courseId;
  @override
  final String? quizId;

  @override
  String toString() {
    return 'ProjectAiOutput(courseId: $courseId, quizId: $quizId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectAiOutputImpl &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.quizId, quizId) || other.quizId == quizId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, courseId, quizId);

  /// Create a copy of ProjectAiOutput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectAiOutputImplCopyWith<_$ProjectAiOutputImpl> get copyWith =>
      __$$ProjectAiOutputImplCopyWithImpl<_$ProjectAiOutputImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectAiOutputImplToJson(
      this,
    );
  }
}

abstract class _ProjectAiOutput implements ProjectAiOutput {
  const factory _ProjectAiOutput(
      {final String? courseId, final String? quizId}) = _$ProjectAiOutputImpl;

  factory _ProjectAiOutput.fromJson(Map<String, dynamic> json) =
      _$ProjectAiOutputImpl.fromJson;

  @override
  String? get courseId;
  @override
  String? get quizId;

  /// Create a copy of ProjectAiOutput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectAiOutputImplCopyWith<_$ProjectAiOutputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) {
  return _ProjectModel.fromJson(json);
}

/// @nodoc
mixin _$ProjectModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  ProjectAiOutput? get aiOutput => throw _privateConstructorUsedError;
  bool get shouldSyncAiOutput => throw _privateConstructorUsedError;
  int get totalLinks => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ProjectModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectModelCopyWith<ProjectModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectModelCopyWith<$Res> {
  factory $ProjectModelCopyWith(
          ProjectModel value, $Res Function(ProjectModel) then) =
      _$ProjectModelCopyWithImpl<$Res, ProjectModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      String? description,
      ProjectAiOutput? aiOutput,
      bool shouldSyncAiOutput,
      int totalLinks,
      DateTime createdAt,
      DateTime updatedAt});

  $ProjectAiOutputCopyWith<$Res>? get aiOutput;
}

/// @nodoc
class _$ProjectModelCopyWithImpl<$Res, $Val extends ProjectModel>
    implements $ProjectModelCopyWith<$Res> {
  _$ProjectModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? description = freezed,
    Object? aiOutput = freezed,
    Object? shouldSyncAiOutput = null,
    Object? totalLinks = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      aiOutput: freezed == aiOutput
          ? _value.aiOutput
          : aiOutput // ignore: cast_nullable_to_non_nullable
              as ProjectAiOutput?,
      shouldSyncAiOutput: null == shouldSyncAiOutput
          ? _value.shouldSyncAiOutput
          : shouldSyncAiOutput // ignore: cast_nullable_to_non_nullable
              as bool,
      totalLinks: null == totalLinks
          ? _value.totalLinks
          : totalLinks // ignore: cast_nullable_to_non_nullable
              as int,
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

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProjectAiOutputCopyWith<$Res>? get aiOutput {
    if (_value.aiOutput == null) {
      return null;
    }

    return $ProjectAiOutputCopyWith<$Res>(_value.aiOutput!, (value) {
      return _then(_value.copyWith(aiOutput: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProjectModelImplCopyWith<$Res>
    implements $ProjectModelCopyWith<$Res> {
  factory _$$ProjectModelImplCopyWith(
          _$ProjectModelImpl value, $Res Function(_$ProjectModelImpl) then) =
      __$$ProjectModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      String? description,
      ProjectAiOutput? aiOutput,
      bool shouldSyncAiOutput,
      int totalLinks,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $ProjectAiOutputCopyWith<$Res>? get aiOutput;
}

/// @nodoc
class __$$ProjectModelImplCopyWithImpl<$Res>
    extends _$ProjectModelCopyWithImpl<$Res, _$ProjectModelImpl>
    implements _$$ProjectModelImplCopyWith<$Res> {
  __$$ProjectModelImplCopyWithImpl(
      _$ProjectModelImpl _value, $Res Function(_$ProjectModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? description = freezed,
    Object? aiOutput = freezed,
    Object? shouldSyncAiOutput = null,
    Object? totalLinks = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ProjectModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      aiOutput: freezed == aiOutput
          ? _value.aiOutput
          : aiOutput // ignore: cast_nullable_to_non_nullable
              as ProjectAiOutput?,
      shouldSyncAiOutput: null == shouldSyncAiOutput
          ? _value.shouldSyncAiOutput
          : shouldSyncAiOutput // ignore: cast_nullable_to_non_nullable
              as bool,
      totalLinks: null == totalLinks
          ? _value.totalLinks
          : totalLinks // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$ProjectModelImpl extends _ProjectModel {
  const _$ProjectModelImpl(
      {required this.id,
      required this.userId,
      required this.name,
      this.description,
      this.aiOutput,
      this.shouldSyncAiOutput = false,
      this.totalLinks = 0,
      required this.createdAt,
      required this.updatedAt})
      : super._();

  factory _$ProjectModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final ProjectAiOutput? aiOutput;
  @override
  @JsonKey()
  final bool shouldSyncAiOutput;
  @override
  @JsonKey()
  final int totalLinks;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ProjectModel(id: $id, userId: $userId, name: $name, description: $description, aiOutput: $aiOutput, shouldSyncAiOutput: $shouldSyncAiOutput, totalLinks: $totalLinks, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.aiOutput, aiOutput) ||
                other.aiOutput == aiOutput) &&
            (identical(other.shouldSyncAiOutput, shouldSyncAiOutput) ||
                other.shouldSyncAiOutput == shouldSyncAiOutput) &&
            (identical(other.totalLinks, totalLinks) ||
                other.totalLinks == totalLinks) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, name, description,
      aiOutput, shouldSyncAiOutput, totalLinks, createdAt, updatedAt);

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectModelImplCopyWith<_$ProjectModelImpl> get copyWith =>
      __$$ProjectModelImplCopyWithImpl<_$ProjectModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectModelImplToJson(
      this,
    );
  }
}

abstract class _ProjectModel extends ProjectModel {
  const factory _ProjectModel(
      {required final String id,
      required final String userId,
      required final String name,
      final String? description,
      final ProjectAiOutput? aiOutput,
      final bool shouldSyncAiOutput,
      final int totalLinks,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ProjectModelImpl;
  const _ProjectModel._() : super._();

  factory _ProjectModel.fromJson(Map<String, dynamic> json) =
      _$ProjectModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get name;
  @override
  String? get description;
  @override
  ProjectAiOutput? get aiOutput;
  @override
  bool get shouldSyncAiOutput;
  @override
  int get totalLinks;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectModelImplCopyWith<_$ProjectModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
