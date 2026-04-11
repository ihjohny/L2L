// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'link_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LinkDetailState {
  /// The selected link with complete data (including AI output)
  LinkModel? get link => throw _privateConstructorUsedError;

  /// Whether the ViewModel is currently loading
  bool get isLoading => throw _privateConstructorUsedError;

  /// Error message from the last failed operation
  String? get error => throw _privateConstructorUsedError;

  /// Whether the content is being refreshed (pull-to-refresh)
  bool get isRefreshing => throw _privateConstructorUsedError;

  /// Whether the link processing is being retried
  bool get isRetrying => throw _privateConstructorUsedError;

  /// Create a copy of LinkDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LinkDetailStateCopyWith<LinkDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LinkDetailStateCopyWith<$Res> {
  factory $LinkDetailStateCopyWith(
          LinkDetailState value, $Res Function(LinkDetailState) then) =
      _$LinkDetailStateCopyWithImpl<$Res, LinkDetailState>;
  @useResult
  $Res call(
      {LinkModel? link,
      bool isLoading,
      String? error,
      bool isRefreshing,
      bool isRetrying});

  $LinkModelCopyWith<$Res>? get link;
}

/// @nodoc
class _$LinkDetailStateCopyWithImpl<$Res, $Val extends LinkDetailState>
    implements $LinkDetailStateCopyWith<$Res> {
  _$LinkDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LinkDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? link = freezed,
    Object? isLoading = null,
    Object? error = freezed,
    Object? isRefreshing = null,
    Object? isRetrying = null,
  }) {
    return _then(_value.copyWith(
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as LinkModel?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      isRetrying: null == isRetrying
          ? _value.isRetrying
          : isRetrying // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of LinkDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LinkModelCopyWith<$Res>? get link {
    if (_value.link == null) {
      return null;
    }

    return $LinkModelCopyWith<$Res>(_value.link!, (value) {
      return _then(_value.copyWith(link: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LinkDetailStateImplCopyWith<$Res>
    implements $LinkDetailStateCopyWith<$Res> {
  factory _$$LinkDetailStateImplCopyWith(_$LinkDetailStateImpl value,
          $Res Function(_$LinkDetailStateImpl) then) =
      __$$LinkDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {LinkModel? link,
      bool isLoading,
      String? error,
      bool isRefreshing,
      bool isRetrying});

  @override
  $LinkModelCopyWith<$Res>? get link;
}

/// @nodoc
class __$$LinkDetailStateImplCopyWithImpl<$Res>
    extends _$LinkDetailStateCopyWithImpl<$Res, _$LinkDetailStateImpl>
    implements _$$LinkDetailStateImplCopyWith<$Res> {
  __$$LinkDetailStateImplCopyWithImpl(
      _$LinkDetailStateImpl _value, $Res Function(_$LinkDetailStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of LinkDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? link = freezed,
    Object? isLoading = null,
    Object? error = freezed,
    Object? isRefreshing = null,
    Object? isRetrying = null,
  }) {
    return _then(_$LinkDetailStateImpl(
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as LinkModel?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      isRetrying: null == isRetrying
          ? _value.isRetrying
          : isRetrying // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$LinkDetailStateImpl implements _LinkDetailState {
  const _$LinkDetailStateImpl(
      {this.link,
      this.isLoading = false,
      this.error,
      this.isRefreshing = false,
      this.isRetrying = false});

  /// The selected link with complete data (including AI output)
  @override
  final LinkModel? link;

  /// Whether the ViewModel is currently loading
  @override
  @JsonKey()
  final bool isLoading;

  /// Error message from the last failed operation
  @override
  final String? error;

  /// Whether the content is being refreshed (pull-to-refresh)
  @override
  @JsonKey()
  final bool isRefreshing;

  /// Whether the link processing is being retried
  @override
  @JsonKey()
  final bool isRetrying;

  @override
  String toString() {
    return 'LinkDetailState(link: $link, isLoading: $isLoading, error: $error, isRefreshing: $isRefreshing, isRetrying: $isRetrying)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LinkDetailStateImpl &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            (identical(other.isRetrying, isRetrying) ||
                other.isRetrying == isRetrying));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, link, isLoading, error, isRefreshing, isRetrying);

  /// Create a copy of LinkDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LinkDetailStateImplCopyWith<_$LinkDetailStateImpl> get copyWith =>
      __$$LinkDetailStateImplCopyWithImpl<_$LinkDetailStateImpl>(
          this, _$identity);
}

abstract class _LinkDetailState implements LinkDetailState {
  const factory _LinkDetailState(
      {final LinkModel? link,
      final bool isLoading,
      final String? error,
      final bool isRefreshing,
      final bool isRetrying}) = _$LinkDetailStateImpl;

  /// The selected link with complete data (including AI output)
  @override
  LinkModel? get link;

  /// Whether the ViewModel is currently loading
  @override
  bool get isLoading;

  /// Error message from the last failed operation
  @override
  String? get error;

  /// Whether the content is being refreshed (pull-to-refresh)
  @override
  bool get isRefreshing;

  /// Whether the link processing is being retried
  @override
  bool get isRetrying;

  /// Create a copy of LinkDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LinkDetailStateImplCopyWith<_$LinkDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
