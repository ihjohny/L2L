// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'link_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LinkState {
  /// List of all links
  List<LinkModel> get links => throw _privateConstructorUsedError;

  /// Selected link for detail view
  LinkModel? get selectedLink => throw _privateConstructorUsedError;

  /// Filtered links based on search and tags
  List<LinkModel>? get filteredLinks => throw _privateConstructorUsedError;

  /// Whether the ViewModel is currently loading
  bool get isLoading => throw _privateConstructorUsedError;

  /// Error message from the last failed operation
  String? get error => throw _privateConstructorUsedError;

  /// Navigation trigger for the UI to consume
  LinkNavigationTrigger get navigationTrigger =>
      throw _privateConstructorUsedError;

  /// Form state for add/edit link
  String? get editingLinkId => throw _privateConstructorUsedError;
  String get formUrl => throw _privateConstructorUsedError;
  String get formTitle => throw _privateConstructorUsedError;
  String get formTags => throw _privateConstructorUsedError;
  String? get formProjectId => throw _privateConstructorUsedError;

  /// Filter state
  Set<String> get selectedTags => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;

  /// Create a copy of LinkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LinkStateCopyWith<LinkState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LinkStateCopyWith<$Res> {
  factory $LinkStateCopyWith(LinkState value, $Res Function(LinkState) then) =
      _$LinkStateCopyWithImpl<$Res, LinkState>;
  @useResult
  $Res call(
      {List<LinkModel> links,
      LinkModel? selectedLink,
      List<LinkModel>? filteredLinks,
      bool isLoading,
      String? error,
      LinkNavigationTrigger navigationTrigger,
      String? editingLinkId,
      String formUrl,
      String formTitle,
      String formTags,
      String? formProjectId,
      Set<String> selectedTags,
      String searchQuery});

  $LinkModelCopyWith<$Res>? get selectedLink;
}

/// @nodoc
class _$LinkStateCopyWithImpl<$Res, $Val extends LinkState>
    implements $LinkStateCopyWith<$Res> {
  _$LinkStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LinkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? links = null,
    Object? selectedLink = freezed,
    Object? filteredLinks = freezed,
    Object? isLoading = null,
    Object? error = freezed,
    Object? navigationTrigger = null,
    Object? editingLinkId = freezed,
    Object? formUrl = null,
    Object? formTitle = null,
    Object? formTags = null,
    Object? formProjectId = freezed,
    Object? selectedTags = null,
    Object? searchQuery = null,
  }) {
    return _then(_value.copyWith(
      links: null == links
          ? _value.links
          : links // ignore: cast_nullable_to_non_nullable
              as List<LinkModel>,
      selectedLink: freezed == selectedLink
          ? _value.selectedLink
          : selectedLink // ignore: cast_nullable_to_non_nullable
              as LinkModel?,
      filteredLinks: freezed == filteredLinks
          ? _value.filteredLinks
          : filteredLinks // ignore: cast_nullable_to_non_nullable
              as List<LinkModel>?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      navigationTrigger: null == navigationTrigger
          ? _value.navigationTrigger
          : navigationTrigger // ignore: cast_nullable_to_non_nullable
              as LinkNavigationTrigger,
      editingLinkId: freezed == editingLinkId
          ? _value.editingLinkId
          : editingLinkId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      selectedTags: null == selectedTags
          ? _value.selectedTags
          : selectedTags // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of LinkState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LinkModelCopyWith<$Res>? get selectedLink {
    if (_value.selectedLink == null) {
      return null;
    }

    return $LinkModelCopyWith<$Res>(_value.selectedLink!, (value) {
      return _then(_value.copyWith(selectedLink: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LinkStateImplCopyWith<$Res>
    implements $LinkStateCopyWith<$Res> {
  factory _$$LinkStateImplCopyWith(
          _$LinkStateImpl value, $Res Function(_$LinkStateImpl) then) =
      __$$LinkStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<LinkModel> links,
      LinkModel? selectedLink,
      List<LinkModel>? filteredLinks,
      bool isLoading,
      String? error,
      LinkNavigationTrigger navigationTrigger,
      String? editingLinkId,
      String formUrl,
      String formTitle,
      String formTags,
      String? formProjectId,
      Set<String> selectedTags,
      String searchQuery});

  @override
  $LinkModelCopyWith<$Res>? get selectedLink;
}

/// @nodoc
class __$$LinkStateImplCopyWithImpl<$Res>
    extends _$LinkStateCopyWithImpl<$Res, _$LinkStateImpl>
    implements _$$LinkStateImplCopyWith<$Res> {
  __$$LinkStateImplCopyWithImpl(
      _$LinkStateImpl _value, $Res Function(_$LinkStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of LinkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? links = null,
    Object? selectedLink = freezed,
    Object? filteredLinks = freezed,
    Object? isLoading = null,
    Object? error = freezed,
    Object? navigationTrigger = null,
    Object? editingLinkId = freezed,
    Object? formUrl = null,
    Object? formTitle = null,
    Object? formTags = null,
    Object? formProjectId = freezed,
    Object? selectedTags = null,
    Object? searchQuery = null,
  }) {
    return _then(_$LinkStateImpl(
      links: null == links
          ? _value._links
          : links // ignore: cast_nullable_to_non_nullable
              as List<LinkModel>,
      selectedLink: freezed == selectedLink
          ? _value.selectedLink
          : selectedLink // ignore: cast_nullable_to_non_nullable
              as LinkModel?,
      filteredLinks: freezed == filteredLinks
          ? _value._filteredLinks
          : filteredLinks // ignore: cast_nullable_to_non_nullable
              as List<LinkModel>?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      navigationTrigger: null == navigationTrigger
          ? _value.navigationTrigger
          : navigationTrigger // ignore: cast_nullable_to_non_nullable
              as LinkNavigationTrigger,
      editingLinkId: freezed == editingLinkId
          ? _value.editingLinkId
          : editingLinkId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      selectedTags: null == selectedTags
          ? _value._selectedTags
          : selectedTags // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LinkStateImpl implements _LinkState {
  const _$LinkStateImpl(
      {final List<LinkModel> links = const [],
      this.selectedLink,
      final List<LinkModel>? filteredLinks,
      this.isLoading = false,
      this.error,
      this.navigationTrigger = LinkNavigationTrigger.none,
      this.editingLinkId,
      this.formUrl = '',
      this.formTitle = '',
      this.formTags = '',
      this.formProjectId,
      final Set<String> selectedTags = const {},
      this.searchQuery = ''})
      : _links = links,
        _filteredLinks = filteredLinks,
        _selectedTags = selectedTags;

  /// List of all links
  final List<LinkModel> _links;

  /// List of all links
  @override
  @JsonKey()
  List<LinkModel> get links {
    if (_links is EqualUnmodifiableListView) return _links;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_links);
  }

  /// Selected link for detail view
  @override
  final LinkModel? selectedLink;

  /// Filtered links based on search and tags
  final List<LinkModel>? _filteredLinks;

  /// Filtered links based on search and tags
  @override
  List<LinkModel>? get filteredLinks {
    final value = _filteredLinks;
    if (value == null) return null;
    if (_filteredLinks is EqualUnmodifiableListView) return _filteredLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Whether the ViewModel is currently loading
  @override
  @JsonKey()
  final bool isLoading;

  /// Error message from the last failed operation
  @override
  final String? error;

  /// Navigation trigger for the UI to consume
  @override
  @JsonKey()
  final LinkNavigationTrigger navigationTrigger;

  /// Form state for add/edit link
  @override
  final String? editingLinkId;
  @override
  @JsonKey()
  final String formUrl;
  @override
  @JsonKey()
  final String formTitle;
  @override
  @JsonKey()
  final String formTags;
  @override
  final String? formProjectId;

  /// Filter state
  final Set<String> _selectedTags;

  /// Filter state
  @override
  @JsonKey()
  Set<String> get selectedTags {
    if (_selectedTags is EqualUnmodifiableSetView) return _selectedTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedTags);
  }

  @override
  @JsonKey()
  final String searchQuery;

  @override
  String toString() {
    return 'LinkState(links: $links, selectedLink: $selectedLink, filteredLinks: $filteredLinks, isLoading: $isLoading, error: $error, navigationTrigger: $navigationTrigger, editingLinkId: $editingLinkId, formUrl: $formUrl, formTitle: $formTitle, formTags: $formTags, formProjectId: $formProjectId, selectedTags: $selectedTags, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LinkStateImpl &&
            const DeepCollectionEquality().equals(other._links, _links) &&
            (identical(other.selectedLink, selectedLink) ||
                other.selectedLink == selectedLink) &&
            const DeepCollectionEquality()
                .equals(other._filteredLinks, _filteredLinks) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.navigationTrigger, navigationTrigger) ||
                other.navigationTrigger == navigationTrigger) &&
            (identical(other.editingLinkId, editingLinkId) ||
                other.editingLinkId == editingLinkId) &&
            (identical(other.formUrl, formUrl) || other.formUrl == formUrl) &&
            (identical(other.formTitle, formTitle) ||
                other.formTitle == formTitle) &&
            (identical(other.formTags, formTags) ||
                other.formTags == formTags) &&
            (identical(other.formProjectId, formProjectId) ||
                other.formProjectId == formProjectId) &&
            const DeepCollectionEquality()
                .equals(other._selectedTags, _selectedTags) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_links),
      selectedLink,
      const DeepCollectionEquality().hash(_filteredLinks),
      isLoading,
      error,
      navigationTrigger,
      editingLinkId,
      formUrl,
      formTitle,
      formTags,
      formProjectId,
      const DeepCollectionEquality().hash(_selectedTags),
      searchQuery);

  /// Create a copy of LinkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LinkStateImplCopyWith<_$LinkStateImpl> get copyWith =>
      __$$LinkStateImplCopyWithImpl<_$LinkStateImpl>(this, _$identity);
}

abstract class _LinkState implements LinkState {
  const factory _LinkState(
      {final List<LinkModel> links,
      final LinkModel? selectedLink,
      final List<LinkModel>? filteredLinks,
      final bool isLoading,
      final String? error,
      final LinkNavigationTrigger navigationTrigger,
      final String? editingLinkId,
      final String formUrl,
      final String formTitle,
      final String formTags,
      final String? formProjectId,
      final Set<String> selectedTags,
      final String searchQuery}) = _$LinkStateImpl;

  /// List of all links
  @override
  List<LinkModel> get links;

  /// Selected link for detail view
  @override
  LinkModel? get selectedLink;

  /// Filtered links based on search and tags
  @override
  List<LinkModel>? get filteredLinks;

  /// Whether the ViewModel is currently loading
  @override
  bool get isLoading;

  /// Error message from the last failed operation
  @override
  String? get error;

  /// Navigation trigger for the UI to consume
  @override
  LinkNavigationTrigger get navigationTrigger;

  /// Form state for add/edit link
  @override
  String? get editingLinkId;
  @override
  String get formUrl;
  @override
  String get formTitle;
  @override
  String get formTags;
  @override
  String? get formProjectId;

  /// Filter state
  @override
  Set<String> get selectedTags;
  @override
  String get searchQuery;

  /// Create a copy of LinkState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LinkStateImplCopyWith<_$LinkStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
