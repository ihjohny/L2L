// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'link_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LinkListState {
  /// List of all links (without AI output - lightweight)
  List<LinkModel> get links => throw _privateConstructorUsedError;

  /// Filtered links based on search and tags
  List<LinkModel>? get filteredLinks => throw _privateConstructorUsedError;

  /// Whether the ViewModel is currently loading
  bool get isLoading => throw _privateConstructorUsedError;

  /// Error message from the last failed operation
  String? get error => throw _privateConstructorUsedError;

  /// Navigation trigger for the UI to consume
  LinkNavigationTrigger get navigationTrigger =>
      throw _privateConstructorUsedError;

  /// Filter state
  Set<String> get selectedTags => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;

  /// Link ID to delete (for confirmation dialog)
  String? get deleteLinkId => throw _privateConstructorUsedError;

  /// Create a copy of LinkListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LinkListStateCopyWith<LinkListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LinkListStateCopyWith<$Res> {
  factory $LinkListStateCopyWith(
          LinkListState value, $Res Function(LinkListState) then) =
      _$LinkListStateCopyWithImpl<$Res, LinkListState>;
  @useResult
  $Res call(
      {List<LinkModel> links,
      List<LinkModel>? filteredLinks,
      bool isLoading,
      String? error,
      LinkNavigationTrigger navigationTrigger,
      Set<String> selectedTags,
      String searchQuery,
      String? deleteLinkId});
}

/// @nodoc
class _$LinkListStateCopyWithImpl<$Res, $Val extends LinkListState>
    implements $LinkListStateCopyWith<$Res> {
  _$LinkListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LinkListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? links = null,
    Object? filteredLinks = freezed,
    Object? isLoading = null,
    Object? error = freezed,
    Object? navigationTrigger = null,
    Object? selectedTags = null,
    Object? searchQuery = null,
    Object? deleteLinkId = freezed,
  }) {
    return _then(_value.copyWith(
      links: null == links
          ? _value.links
          : links // ignore: cast_nullable_to_non_nullable
              as List<LinkModel>,
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
      selectedTags: null == selectedTags
          ? _value.selectedTags
          : selectedTags // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      deleteLinkId: freezed == deleteLinkId
          ? _value.deleteLinkId
          : deleteLinkId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LinkListStateImplCopyWith<$Res>
    implements $LinkListStateCopyWith<$Res> {
  factory _$$LinkListStateImplCopyWith(
          _$LinkListStateImpl value, $Res Function(_$LinkListStateImpl) then) =
      __$$LinkListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<LinkModel> links,
      List<LinkModel>? filteredLinks,
      bool isLoading,
      String? error,
      LinkNavigationTrigger navigationTrigger,
      Set<String> selectedTags,
      String searchQuery,
      String? deleteLinkId});
}

/// @nodoc
class __$$LinkListStateImplCopyWithImpl<$Res>
    extends _$LinkListStateCopyWithImpl<$Res, _$LinkListStateImpl>
    implements _$$LinkListStateImplCopyWith<$Res> {
  __$$LinkListStateImplCopyWithImpl(
      _$LinkListStateImpl _value, $Res Function(_$LinkListStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of LinkListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? links = null,
    Object? filteredLinks = freezed,
    Object? isLoading = null,
    Object? error = freezed,
    Object? navigationTrigger = null,
    Object? selectedTags = null,
    Object? searchQuery = null,
    Object? deleteLinkId = freezed,
  }) {
    return _then(_$LinkListStateImpl(
      links: null == links
          ? _value._links
          : links // ignore: cast_nullable_to_non_nullable
              as List<LinkModel>,
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
      selectedTags: null == selectedTags
          ? _value._selectedTags
          : selectedTags // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      deleteLinkId: freezed == deleteLinkId
          ? _value.deleteLinkId
          : deleteLinkId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LinkListStateImpl implements _LinkListState {
  const _$LinkListStateImpl(
      {final List<LinkModel> links = const [],
      final List<LinkModel>? filteredLinks,
      this.isLoading = false,
      this.error,
      this.navigationTrigger = LinkNavigationTrigger.none,
      final Set<String> selectedTags = const {},
      this.searchQuery = '',
      this.deleteLinkId})
      : _links = links,
        _filteredLinks = filteredLinks,
        _selectedTags = selectedTags;

  /// List of all links (without AI output - lightweight)
  final List<LinkModel> _links;

  /// List of all links (without AI output - lightweight)
  @override
  @JsonKey()
  List<LinkModel> get links {
    if (_links is EqualUnmodifiableListView) return _links;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_links);
  }

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

  /// Link ID to delete (for confirmation dialog)
  @override
  final String? deleteLinkId;

  @override
  String toString() {
    return 'LinkListState(links: $links, filteredLinks: $filteredLinks, isLoading: $isLoading, error: $error, navigationTrigger: $navigationTrigger, selectedTags: $selectedTags, searchQuery: $searchQuery, deleteLinkId: $deleteLinkId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LinkListStateImpl &&
            const DeepCollectionEquality().equals(other._links, _links) &&
            const DeepCollectionEquality()
                .equals(other._filteredLinks, _filteredLinks) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.navigationTrigger, navigationTrigger) ||
                other.navigationTrigger == navigationTrigger) &&
            const DeepCollectionEquality()
                .equals(other._selectedTags, _selectedTags) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.deleteLinkId, deleteLinkId) ||
                other.deleteLinkId == deleteLinkId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_links),
      const DeepCollectionEquality().hash(_filteredLinks),
      isLoading,
      error,
      navigationTrigger,
      const DeepCollectionEquality().hash(_selectedTags),
      searchQuery,
      deleteLinkId);

  /// Create a copy of LinkListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LinkListStateImplCopyWith<_$LinkListStateImpl> get copyWith =>
      __$$LinkListStateImplCopyWithImpl<_$LinkListStateImpl>(this, _$identity);
}

abstract class _LinkListState implements LinkListState {
  const factory _LinkListState(
      {final List<LinkModel> links,
      final List<LinkModel>? filteredLinks,
      final bool isLoading,
      final String? error,
      final LinkNavigationTrigger navigationTrigger,
      final Set<String> selectedTags,
      final String searchQuery,
      final String? deleteLinkId}) = _$LinkListStateImpl;

  /// List of all links (without AI output - lightweight)
  @override
  List<LinkModel> get links;

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

  /// Filter state
  @override
  Set<String> get selectedTags;
  @override
  String get searchQuery;

  /// Link ID to delete (for confirmation dialog)
  @override
  String? get deleteLinkId;

  /// Create a copy of LinkListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LinkListStateImplCopyWith<_$LinkListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
