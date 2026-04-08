// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProjectState {
  /// List of all projects
  List<ProjectModel> get projects => throw _privateConstructorUsedError;

  /// Currently selected project (for detail view)
  ProjectModel? get selectedProject => throw _privateConstructorUsedError;

  /// Links for the selected project
  List<LinkModel> get selectedProjectLinks =>
      throw _privateConstructorUsedError;

  /// Course for the selected project
  CourseModel? get selectedProjectCourse => throw _privateConstructorUsedError;

  /// Quiz for the selected project
  QuizModel? get selectedProjectQuiz => throw _privateConstructorUsedError;

  /// Project statistics
  Map<String, dynamic>? get selectedProjectStats =>
      throw _privateConstructorUsedError;

  /// Whether the ViewModel is currently loading
  bool get isLoading => throw _privateConstructorUsedError;

  /// Whether links are loading for the selected project
  dynamic get isLoadingLinks => throw _privateConstructorUsedError;

  /// Whether course/quiz data is loading
  dynamic get isLoadingCourse => throw _privateConstructorUsedError;

  /// Error message from the last failed operation
  String? get error => throw _privateConstructorUsedError;

  /// Navigation trigger for the UI to consume
  ProjectNavigationTrigger get navigationTrigger =>
      throw _privateConstructorUsedError;

  /// Form state for create/edit
  String? get editingProjectId => throw _privateConstructorUsedError;
  String get formName => throw _privateConstructorUsedError;
  String get formDescription => throw _privateConstructorUsedError;

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectStateCopyWith<ProjectState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectStateCopyWith<$Res> {
  factory $ProjectStateCopyWith(
          ProjectState value, $Res Function(ProjectState) then) =
      _$ProjectStateCopyWithImpl<$Res, ProjectState>;
  @useResult
  $Res call(
      {List<ProjectModel> projects,
      ProjectModel? selectedProject,
      List<LinkModel> selectedProjectLinks,
      CourseModel? selectedProjectCourse,
      QuizModel? selectedProjectQuiz,
      Map<String, dynamic>? selectedProjectStats,
      bool isLoading,
      dynamic isLoadingLinks,
      dynamic isLoadingCourse,
      String? error,
      ProjectNavigationTrigger navigationTrigger,
      String? editingProjectId,
      String formName,
      String formDescription});

  $ProjectModelCopyWith<$Res>? get selectedProject;
  $CourseModelCopyWith<$Res>? get selectedProjectCourse;
  $QuizModelCopyWith<$Res>? get selectedProjectQuiz;
}

/// @nodoc
class _$ProjectStateCopyWithImpl<$Res, $Val extends ProjectState>
    implements $ProjectStateCopyWith<$Res> {
  _$ProjectStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projects = null,
    Object? selectedProject = freezed,
    Object? selectedProjectLinks = null,
    Object? selectedProjectCourse = freezed,
    Object? selectedProjectQuiz = freezed,
    Object? selectedProjectStats = freezed,
    Object? isLoading = null,
    Object? isLoadingLinks = freezed,
    Object? isLoadingCourse = freezed,
    Object? error = freezed,
    Object? navigationTrigger = null,
    Object? editingProjectId = freezed,
    Object? formName = null,
    Object? formDescription = null,
  }) {
    return _then(_value.copyWith(
      projects: null == projects
          ? _value.projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<ProjectModel>,
      selectedProject: freezed == selectedProject
          ? _value.selectedProject
          : selectedProject // ignore: cast_nullable_to_non_nullable
              as ProjectModel?,
      selectedProjectLinks: null == selectedProjectLinks
          ? _value.selectedProjectLinks
          : selectedProjectLinks // ignore: cast_nullable_to_non_nullable
              as List<LinkModel>,
      selectedProjectCourse: freezed == selectedProjectCourse
          ? _value.selectedProjectCourse
          : selectedProjectCourse // ignore: cast_nullable_to_non_nullable
              as CourseModel?,
      selectedProjectQuiz: freezed == selectedProjectQuiz
          ? _value.selectedProjectQuiz
          : selectedProjectQuiz // ignore: cast_nullable_to_non_nullable
              as QuizModel?,
      selectedProjectStats: freezed == selectedProjectStats
          ? _value.selectedProjectStats
          : selectedProjectStats // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingLinks: freezed == isLoadingLinks
          ? _value.isLoadingLinks
          : isLoadingLinks // ignore: cast_nullable_to_non_nullable
              as dynamic,
      isLoadingCourse: freezed == isLoadingCourse
          ? _value.isLoadingCourse
          : isLoadingCourse // ignore: cast_nullable_to_non_nullable
              as dynamic,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      navigationTrigger: null == navigationTrigger
          ? _value.navigationTrigger
          : navigationTrigger // ignore: cast_nullable_to_non_nullable
              as ProjectNavigationTrigger,
      editingProjectId: freezed == editingProjectId
          ? _value.editingProjectId
          : editingProjectId // ignore: cast_nullable_to_non_nullable
              as String?,
      formName: null == formName
          ? _value.formName
          : formName // ignore: cast_nullable_to_non_nullable
              as String,
      formDescription: null == formDescription
          ? _value.formDescription
          : formDescription // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProjectModelCopyWith<$Res>? get selectedProject {
    if (_value.selectedProject == null) {
      return null;
    }

    return $ProjectModelCopyWith<$Res>(_value.selectedProject!, (value) {
      return _then(_value.copyWith(selectedProject: value) as $Val);
    });
  }

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CourseModelCopyWith<$Res>? get selectedProjectCourse {
    if (_value.selectedProjectCourse == null) {
      return null;
    }

    return $CourseModelCopyWith<$Res>(_value.selectedProjectCourse!, (value) {
      return _then(_value.copyWith(selectedProjectCourse: value) as $Val);
    });
  }

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuizModelCopyWith<$Res>? get selectedProjectQuiz {
    if (_value.selectedProjectQuiz == null) {
      return null;
    }

    return $QuizModelCopyWith<$Res>(_value.selectedProjectQuiz!, (value) {
      return _then(_value.copyWith(selectedProjectQuiz: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProjectStateImplCopyWith<$Res>
    implements $ProjectStateCopyWith<$Res> {
  factory _$$ProjectStateImplCopyWith(
          _$ProjectStateImpl value, $Res Function(_$ProjectStateImpl) then) =
      __$$ProjectStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ProjectModel> projects,
      ProjectModel? selectedProject,
      List<LinkModel> selectedProjectLinks,
      CourseModel? selectedProjectCourse,
      QuizModel? selectedProjectQuiz,
      Map<String, dynamic>? selectedProjectStats,
      bool isLoading,
      dynamic isLoadingLinks,
      dynamic isLoadingCourse,
      String? error,
      ProjectNavigationTrigger navigationTrigger,
      String? editingProjectId,
      String formName,
      String formDescription});

  @override
  $ProjectModelCopyWith<$Res>? get selectedProject;
  @override
  $CourseModelCopyWith<$Res>? get selectedProjectCourse;
  @override
  $QuizModelCopyWith<$Res>? get selectedProjectQuiz;
}

/// @nodoc
class __$$ProjectStateImplCopyWithImpl<$Res>
    extends _$ProjectStateCopyWithImpl<$Res, _$ProjectStateImpl>
    implements _$$ProjectStateImplCopyWith<$Res> {
  __$$ProjectStateImplCopyWithImpl(
      _$ProjectStateImpl _value, $Res Function(_$ProjectStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projects = null,
    Object? selectedProject = freezed,
    Object? selectedProjectLinks = null,
    Object? selectedProjectCourse = freezed,
    Object? selectedProjectQuiz = freezed,
    Object? selectedProjectStats = freezed,
    Object? isLoading = null,
    Object? isLoadingLinks = freezed,
    Object? isLoadingCourse = freezed,
    Object? error = freezed,
    Object? navigationTrigger = null,
    Object? editingProjectId = freezed,
    Object? formName = null,
    Object? formDescription = null,
  }) {
    return _then(_$ProjectStateImpl(
      projects: null == projects
          ? _value._projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<ProjectModel>,
      selectedProject: freezed == selectedProject
          ? _value.selectedProject
          : selectedProject // ignore: cast_nullable_to_non_nullable
              as ProjectModel?,
      selectedProjectLinks: null == selectedProjectLinks
          ? _value._selectedProjectLinks
          : selectedProjectLinks // ignore: cast_nullable_to_non_nullable
              as List<LinkModel>,
      selectedProjectCourse: freezed == selectedProjectCourse
          ? _value.selectedProjectCourse
          : selectedProjectCourse // ignore: cast_nullable_to_non_nullable
              as CourseModel?,
      selectedProjectQuiz: freezed == selectedProjectQuiz
          ? _value.selectedProjectQuiz
          : selectedProjectQuiz // ignore: cast_nullable_to_non_nullable
              as QuizModel?,
      selectedProjectStats: freezed == selectedProjectStats
          ? _value._selectedProjectStats
          : selectedProjectStats // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingLinks:
          freezed == isLoadingLinks ? _value.isLoadingLinks! : isLoadingLinks,
      isLoadingCourse: freezed == isLoadingCourse
          ? _value.isLoadingCourse!
          : isLoadingCourse,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      navigationTrigger: null == navigationTrigger
          ? _value.navigationTrigger
          : navigationTrigger // ignore: cast_nullable_to_non_nullable
              as ProjectNavigationTrigger,
      editingProjectId: freezed == editingProjectId
          ? _value.editingProjectId
          : editingProjectId // ignore: cast_nullable_to_non_nullable
              as String?,
      formName: null == formName
          ? _value.formName
          : formName // ignore: cast_nullable_to_non_nullable
              as String,
      formDescription: null == formDescription
          ? _value.formDescription
          : formDescription // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ProjectStateImpl implements _ProjectState {
  const _$ProjectStateImpl(
      {final List<ProjectModel> projects = const [],
      this.selectedProject,
      final List<LinkModel> selectedProjectLinks = const [],
      this.selectedProjectCourse,
      this.selectedProjectQuiz,
      final Map<String, dynamic>? selectedProjectStats,
      this.isLoading = false,
      this.isLoadingLinks = false,
      this.isLoadingCourse = false,
      this.error,
      this.navigationTrigger = ProjectNavigationTrigger.none,
      this.editingProjectId,
      this.formName = '',
      this.formDescription = ''})
      : _projects = projects,
        _selectedProjectLinks = selectedProjectLinks,
        _selectedProjectStats = selectedProjectStats;

  /// List of all projects
  final List<ProjectModel> _projects;

  /// List of all projects
  @override
  @JsonKey()
  List<ProjectModel> get projects {
    if (_projects is EqualUnmodifiableListView) return _projects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projects);
  }

  /// Currently selected project (for detail view)
  @override
  final ProjectModel? selectedProject;

  /// Links for the selected project
  final List<LinkModel> _selectedProjectLinks;

  /// Links for the selected project
  @override
  @JsonKey()
  List<LinkModel> get selectedProjectLinks {
    if (_selectedProjectLinks is EqualUnmodifiableListView)
      return _selectedProjectLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedProjectLinks);
  }

  /// Course for the selected project
  @override
  final CourseModel? selectedProjectCourse;

  /// Quiz for the selected project
  @override
  final QuizModel? selectedProjectQuiz;

  /// Project statistics
  final Map<String, dynamic>? _selectedProjectStats;

  /// Project statistics
  @override
  Map<String, dynamic>? get selectedProjectStats {
    final value = _selectedProjectStats;
    if (value == null) return null;
    if (_selectedProjectStats is EqualUnmodifiableMapView)
      return _selectedProjectStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Whether the ViewModel is currently loading
  @override
  @JsonKey()
  final bool isLoading;

  /// Whether links are loading for the selected project
  @override
  @JsonKey()
  final dynamic isLoadingLinks;

  /// Whether course/quiz data is loading
  @override
  @JsonKey()
  final dynamic isLoadingCourse;

  /// Error message from the last failed operation
  @override
  final String? error;

  /// Navigation trigger for the UI to consume
  @override
  @JsonKey()
  final ProjectNavigationTrigger navigationTrigger;

  /// Form state for create/edit
  @override
  final String? editingProjectId;
  @override
  @JsonKey()
  final String formName;
  @override
  @JsonKey()
  final String formDescription;

  @override
  String toString() {
    return 'ProjectState(projects: $projects, selectedProject: $selectedProject, selectedProjectLinks: $selectedProjectLinks, selectedProjectCourse: $selectedProjectCourse, selectedProjectQuiz: $selectedProjectQuiz, selectedProjectStats: $selectedProjectStats, isLoading: $isLoading, isLoadingLinks: $isLoadingLinks, isLoadingCourse: $isLoadingCourse, error: $error, navigationTrigger: $navigationTrigger, editingProjectId: $editingProjectId, formName: $formName, formDescription: $formDescription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectStateImpl &&
            const DeepCollectionEquality().equals(other._projects, _projects) &&
            (identical(other.selectedProject, selectedProject) ||
                other.selectedProject == selectedProject) &&
            const DeepCollectionEquality()
                .equals(other._selectedProjectLinks, _selectedProjectLinks) &&
            (identical(other.selectedProjectCourse, selectedProjectCourse) ||
                other.selectedProjectCourse == selectedProjectCourse) &&
            (identical(other.selectedProjectQuiz, selectedProjectQuiz) ||
                other.selectedProjectQuiz == selectedProjectQuiz) &&
            const DeepCollectionEquality()
                .equals(other._selectedProjectStats, _selectedProjectStats) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other.isLoadingLinks, isLoadingLinks) &&
            const DeepCollectionEquality()
                .equals(other.isLoadingCourse, isLoadingCourse) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.navigationTrigger, navigationTrigger) ||
                other.navigationTrigger == navigationTrigger) &&
            (identical(other.editingProjectId, editingProjectId) ||
                other.editingProjectId == editingProjectId) &&
            (identical(other.formName, formName) ||
                other.formName == formName) &&
            (identical(other.formDescription, formDescription) ||
                other.formDescription == formDescription));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_projects),
      selectedProject,
      const DeepCollectionEquality().hash(_selectedProjectLinks),
      selectedProjectCourse,
      selectedProjectQuiz,
      const DeepCollectionEquality().hash(_selectedProjectStats),
      isLoading,
      const DeepCollectionEquality().hash(isLoadingLinks),
      const DeepCollectionEquality().hash(isLoadingCourse),
      error,
      navigationTrigger,
      editingProjectId,
      formName,
      formDescription);

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectStateImplCopyWith<_$ProjectStateImpl> get copyWith =>
      __$$ProjectStateImplCopyWithImpl<_$ProjectStateImpl>(this, _$identity);
}

abstract class _ProjectState implements ProjectState {
  const factory _ProjectState(
      {final List<ProjectModel> projects,
      final ProjectModel? selectedProject,
      final List<LinkModel> selectedProjectLinks,
      final CourseModel? selectedProjectCourse,
      final QuizModel? selectedProjectQuiz,
      final Map<String, dynamic>? selectedProjectStats,
      final bool isLoading,
      final dynamic isLoadingLinks,
      final dynamic isLoadingCourse,
      final String? error,
      final ProjectNavigationTrigger navigationTrigger,
      final String? editingProjectId,
      final String formName,
      final String formDescription}) = _$ProjectStateImpl;

  /// List of all projects
  @override
  List<ProjectModel> get projects;

  /// Currently selected project (for detail view)
  @override
  ProjectModel? get selectedProject;

  /// Links for the selected project
  @override
  List<LinkModel> get selectedProjectLinks;

  /// Course for the selected project
  @override
  CourseModel? get selectedProjectCourse;

  /// Quiz for the selected project
  @override
  QuizModel? get selectedProjectQuiz;

  /// Project statistics
  @override
  Map<String, dynamic>? get selectedProjectStats;

  /// Whether the ViewModel is currently loading
  @override
  bool get isLoading;

  /// Whether links are loading for the selected project
  @override
  dynamic get isLoadingLinks;

  /// Whether course/quiz data is loading
  @override
  dynamic get isLoadingCourse;

  /// Error message from the last failed operation
  @override
  String? get error;

  /// Navigation trigger for the UI to consume
  @override
  ProjectNavigationTrigger get navigationTrigger;

  /// Form state for create/edit
  @override
  String? get editingProjectId;
  @override
  String get formName;
  @override
  String get formDescription;

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectStateImplCopyWith<_$ProjectStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
