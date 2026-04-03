// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_link_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AddLinkState {
  /// Form field: URL (required)
  String get formUrl => throw _privateConstructorUsedError;

  /// Form field: Title (optional)
  String get formTitle => throw _privateConstructorUsedError;

  /// Form field: Tags (optional, comma-separated)
  String get formTags => throw _privateConstructorUsedError;

  /// Form field: Selected project ID (optional)
  String? get formProjectId => throw _privateConstructorUsedError;

  /// New project name if creating a new project
  String? get newProjectName => throw _privateConstructorUsedError;

  /// List of existing projects for autocomplete
  List<ProjectModel> get projects => throw _privateConstructorUsedError;

  /// Whether the form is currently submitting
  bool get isSubmitting => throw _privateConstructorUsedError;

  /// Error message from the last failed operation
  String? get error => throw _privateConstructorUsedError;

  /// Whether form is valid for submission
  bool get isValid => throw _privateConstructorUsedError;

  /// Create a copy of AddLinkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddLinkStateCopyWith<AddLinkState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddLinkStateCopyWith<$Res> {
  factory $AddLinkStateCopyWith(
          AddLinkState value, $Res Function(AddLinkState) then) =
      _$AddLinkStateCopyWithImpl<$Res, AddLinkState>;
  @useResult
  $Res call(
      {String formUrl,
      String formTitle,
      String formTags,
      String? formProjectId,
      String? newProjectName,
      List<ProjectModel> projects,
      bool isSubmitting,
      String? error,
      bool isValid});
}

/// @nodoc
class _$AddLinkStateCopyWithImpl<$Res, $Val extends AddLinkState>
    implements $AddLinkStateCopyWith<$Res> {
  _$AddLinkStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddLinkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? formUrl = null,
    Object? formTitle = null,
    Object? formTags = null,
    Object? formProjectId = freezed,
    Object? newProjectName = freezed,
    Object? projects = null,
    Object? isSubmitting = null,
    Object? error = freezed,
    Object? isValid = null,
  }) {
    return _then(_value.copyWith(
      formUrl: null == formUrl
          ? _value.formUrl
          : formUrl // ignore: cast_nullable_to_non_nullable
              as String,
      formTitle: null == formTitle
          ? _value.formTitle
          : formTitle // ignore: cast_nullable_to_non_nullable
              as String,
      formTags: null == formTags
          ? _value.formTags
          : formTags // ignore: cast_nullable_to_non_nullable
              as String,
      formProjectId: freezed == formProjectId
          ? _value.formProjectId
          : formProjectId // ignore: cast_nullable_to_non_nullable
              as String?,
      newProjectName: freezed == newProjectName
          ? _value.newProjectName
          : newProjectName // ignore: cast_nullable_to_non_nullable
              as String?,
      projects: null == projects
          ? _value.projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<ProjectModel>,
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddLinkStateImplCopyWith<$Res>
    implements $AddLinkStateCopyWith<$Res> {
  factory _$$AddLinkStateImplCopyWith(
          _$AddLinkStateImpl value, $Res Function(_$AddLinkStateImpl) then) =
      __$$AddLinkStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String formUrl,
      String formTitle,
      String formTags,
      String? formProjectId,
      String? newProjectName,
      List<ProjectModel> projects,
      bool isSubmitting,
      String? error,
      bool isValid});
}

/// @nodoc
class __$$AddLinkStateImplCopyWithImpl<$Res>
    extends _$AddLinkStateCopyWithImpl<$Res, _$AddLinkStateImpl>
    implements _$$AddLinkStateImplCopyWith<$Res> {
  __$$AddLinkStateImplCopyWithImpl(
      _$AddLinkStateImpl _value, $Res Function(_$AddLinkStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddLinkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? formUrl = null,
    Object? formTitle = null,
    Object? formTags = null,
    Object? formProjectId = freezed,
    Object? newProjectName = freezed,
    Object? projects = null,
    Object? isSubmitting = null,
    Object? error = freezed,
    Object? isValid = null,
  }) {
    return _then(_$AddLinkStateImpl(
      formUrl: null == formUrl
          ? _value.formUrl
          : formUrl // ignore: cast_nullable_to_non_nullable
              as String,
      formTitle: null == formTitle
          ? _value.formTitle
          : formTitle // ignore: cast_nullable_to_non_nullable
              as String,
      formTags: null == formTags
          ? _value.formTags
          : formTags // ignore: cast_nullable_to_non_nullable
              as String,
      formProjectId: freezed == formProjectId
          ? _value.formProjectId
          : formProjectId // ignore: cast_nullable_to_non_nullable
              as String?,
      newProjectName: freezed == newProjectName
          ? _value.newProjectName
          : newProjectName // ignore: cast_nullable_to_non_nullable
              as String?,
      projects: null == projects
          ? _value._projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<ProjectModel>,
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AddLinkStateImpl implements _AddLinkState {
  const _$AddLinkStateImpl(
      {this.formUrl = '',
      this.formTitle = '',
      this.formTags = '',
      this.formProjectId,
      this.newProjectName,
      final List<ProjectModel> projects = const [],
      this.isSubmitting = false,
      this.error,
      this.isValid = false})
      : _projects = projects;

  /// Form field: URL (required)
  @override
  @JsonKey()
  final String formUrl;

  /// Form field: Title (optional)
  @override
  @JsonKey()
  final String formTitle;

  /// Form field: Tags (optional, comma-separated)
  @override
  @JsonKey()
  final String formTags;

  /// Form field: Selected project ID (optional)
  @override
  final String? formProjectId;

  /// New project name if creating a new project
  @override
  final String? newProjectName;

  /// List of existing projects for autocomplete
  final List<ProjectModel> _projects;

  /// List of existing projects for autocomplete
  @override
  @JsonKey()
  List<ProjectModel> get projects {
    if (_projects is EqualUnmodifiableListView) return _projects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projects);
  }

  /// Whether the form is currently submitting
  @override
  @JsonKey()
  final bool isSubmitting;

  /// Error message from the last failed operation
  @override
  final String? error;

  /// Whether form is valid for submission
  @override
  @JsonKey()
  final bool isValid;

  @override
  String toString() {
    return 'AddLinkState(formUrl: $formUrl, formTitle: $formTitle, formTags: $formTags, formProjectId: $formProjectId, newProjectName: $newProjectName, projects: $projects, isSubmitting: $isSubmitting, error: $error, isValid: $isValid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddLinkStateImpl &&
            (identical(other.formUrl, formUrl) || other.formUrl == formUrl) &&
            (identical(other.formTitle, formTitle) ||
                other.formTitle == formTitle) &&
            (identical(other.formTags, formTags) ||
                other.formTags == formTags) &&
            (identical(other.formProjectId, formProjectId) ||
                other.formProjectId == formProjectId) &&
            (identical(other.newProjectName, newProjectName) ||
                other.newProjectName == newProjectName) &&
            const DeepCollectionEquality().equals(other._projects, _projects) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isValid, isValid) || other.isValid == isValid));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      formUrl,
      formTitle,
      formTags,
      formProjectId,
      newProjectName,
      const DeepCollectionEquality().hash(_projects),
      isSubmitting,
      error,
      isValid);

  /// Create a copy of AddLinkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddLinkStateImplCopyWith<_$AddLinkStateImpl> get copyWith =>
      __$$AddLinkStateImplCopyWithImpl<_$AddLinkStateImpl>(this, _$identity);
}

abstract class _AddLinkState implements AddLinkState {
  const factory _AddLinkState(
      {final String formUrl,
      final String formTitle,
      final String formTags,
      final String? formProjectId,
      final String? newProjectName,
      final List<ProjectModel> projects,
      final bool isSubmitting,
      final String? error,
      final bool isValid}) = _$AddLinkStateImpl;

  /// Form field: URL (required)
  @override
  String get formUrl;

  /// Form field: Title (optional)
  @override
  String get formTitle;

  /// Form field: Tags (optional, comma-separated)
  @override
  String get formTags;

  /// Form field: Selected project ID (optional)
  @override
  String? get formProjectId;

  /// New project name if creating a new project
  @override
  String? get newProjectName;

  /// List of existing projects for autocomplete
  @override
  List<ProjectModel> get projects;

  /// Whether the form is currently submitting
  @override
  bool get isSubmitting;

  /// Error message from the last failed operation
  @override
  String? get error;

  /// Whether form is valid for submission
  @override
  bool get isValid;

  /// Create a copy of AddLinkState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddLinkStateImplCopyWith<_$AddLinkStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
