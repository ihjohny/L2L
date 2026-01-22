// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  UserProfileModel get profile => throw _privateConstructorUsedError;
  UserSubscriptionModel get subscription => throw _privateConstructorUsedError;
  UserStatsModel get stats => throw _privateConstructorUsedError;
  bool get isEmailVerified => throw _privateConstructorUsedError;
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String id,
      String email,
      String username,
      UserProfileModel profile,
      UserSubscriptionModel subscription,
      UserStatsModel stats,
      bool isEmailVerified,
      DateTime? lastLoginAt});

  $UserProfileModelCopyWith<$Res> get profile;
  $UserSubscriptionModelCopyWith<$Res> get subscription;
  $UserStatsModelCopyWith<$Res> get stats;
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? profile = null,
    Object? subscription = null,
    Object? stats = null,
    Object? isEmailVerified = null,
    Object? lastLoginAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as UserProfileModel,
      subscription: null == subscription
          ? _value.subscription
          : subscription // ignore: cast_nullable_to_non_nullable
              as UserSubscriptionModel,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as UserStatsModel,
      isEmailVerified: null == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileModelCopyWith<$Res> get profile {
    return $UserProfileModelCopyWith<$Res>(_value.profile, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserSubscriptionModelCopyWith<$Res> get subscription {
    return $UserSubscriptionModelCopyWith<$Res>(_value.subscription, (value) {
      return _then(_value.copyWith(subscription: value) as $Val);
    });
  }

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserStatsModelCopyWith<$Res> get stats {
    return $UserStatsModelCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String username,
      UserProfileModel profile,
      UserSubscriptionModel subscription,
      UserStatsModel stats,
      bool isEmailVerified,
      DateTime? lastLoginAt});

  @override
  $UserProfileModelCopyWith<$Res> get profile;
  @override
  $UserSubscriptionModelCopyWith<$Res> get subscription;
  @override
  $UserStatsModelCopyWith<$Res> get stats;
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? profile = null,
    Object? subscription = null,
    Object? stats = null,
    Object? isEmailVerified = null,
    Object? lastLoginAt = freezed,
  }) {
    return _then(_$UserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as UserProfileModel,
      subscription: null == subscription
          ? _value.subscription
          : subscription // ignore: cast_nullable_to_non_nullable
              as UserSubscriptionModel,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as UserStatsModel,
      isEmailVerified: null == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl(
      {required this.id,
      required this.email,
      required this.username,
      required this.profile,
      required this.subscription,
      required this.stats,
      this.isEmailVerified = false,
      this.lastLoginAt});

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String username;
  @override
  final UserProfileModel profile;
  @override
  final UserSubscriptionModel subscription;
  @override
  final UserStatsModel stats;
  @override
  @JsonKey()
  final bool isEmailVerified;
  @override
  final DateTime? lastLoginAt;

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, username: $username, profile: $profile, subscription: $subscription, stats: $stats, isEmailVerified: $isEmailVerified, lastLoginAt: $lastLoginAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.subscription, subscription) ||
                other.subscription == subscription) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, username, profile,
      subscription, stats, isEmailVerified, lastLoginAt);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
      {required final String id,
      required final String email,
      required final String username,
      required final UserProfileModel profile,
      required final UserSubscriptionModel subscription,
      required final UserStatsModel stats,
      final bool isEmailVerified,
      final DateTime? lastLoginAt}) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get username;
  @override
  UserProfileModel get profile;
  @override
  UserSubscriptionModel get subscription;
  @override
  UserStatsModel get stats;
  @override
  bool get isEmailVerified;
  @override
  DateTime? get lastLoginAt;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) {
  return _UserProfileModel.fromJson(json);
}

/// @nodoc
mixin _$UserProfileModel {
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  UserPreferencesModel get preferences => throw _privateConstructorUsedError;

  /// Serializes this UserProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileModelCopyWith<UserProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileModelCopyWith<$Res> {
  factory $UserProfileModelCopyWith(
          UserProfileModel value, $Res Function(UserProfileModel) then) =
      _$UserProfileModelCopyWithImpl<$Res, UserProfileModel>;
  @useResult
  $Res call(
      {String firstName,
      String lastName,
      String? avatar,
      String? bio,
      UserPreferencesModel preferences});

  $UserPreferencesModelCopyWith<$Res> get preferences;
}

/// @nodoc
class _$UserProfileModelCopyWithImpl<$Res, $Val extends UserProfileModel>
    implements $UserProfileModelCopyWith<$Res> {
  _$UserProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? avatar = freezed,
    Object? bio = freezed,
    Object? preferences = null,
  }) {
    return _then(_value.copyWith(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      preferences: null == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as UserPreferencesModel,
    ) as $Val);
  }

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserPreferencesModelCopyWith<$Res> get preferences {
    return $UserPreferencesModelCopyWith<$Res>(_value.preferences, (value) {
      return _then(_value.copyWith(preferences: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserProfileModelImplCopyWith<$Res>
    implements $UserProfileModelCopyWith<$Res> {
  factory _$$UserProfileModelImplCopyWith(_$UserProfileModelImpl value,
          $Res Function(_$UserProfileModelImpl) then) =
      __$$UserProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String firstName,
      String lastName,
      String? avatar,
      String? bio,
      UserPreferencesModel preferences});

  @override
  $UserPreferencesModelCopyWith<$Res> get preferences;
}

/// @nodoc
class __$$UserProfileModelImplCopyWithImpl<$Res>
    extends _$UserProfileModelCopyWithImpl<$Res, _$UserProfileModelImpl>
    implements _$$UserProfileModelImplCopyWith<$Res> {
  __$$UserProfileModelImplCopyWithImpl(_$UserProfileModelImpl _value,
      $Res Function(_$UserProfileModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? avatar = freezed,
    Object? bio = freezed,
    Object? preferences = null,
  }) {
    return _then(_$UserProfileModelImpl(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      preferences: null == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as UserPreferencesModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileModelImpl implements _UserProfileModel {
  const _$UserProfileModelImpl(
      {required this.firstName,
      required this.lastName,
      this.avatar,
      this.bio,
      required this.preferences});

  factory _$UserProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileModelImplFromJson(json);

  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? avatar;
  @override
  final String? bio;
  @override
  final UserPreferencesModel preferences;

  @override
  String toString() {
    return 'UserProfileModel(firstName: $firstName, lastName: $lastName, avatar: $avatar, bio: $bio, preferences: $preferences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileModelImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.preferences, preferences) ||
                other.preferences == preferences));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, firstName, lastName, avatar, bio, preferences);

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      __$$UserProfileModelImplCopyWithImpl<_$UserProfileModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileModelImplToJson(
      this,
    );
  }
}

abstract class _UserProfileModel implements UserProfileModel {
  const factory _UserProfileModel(
          {required final String firstName,
          required final String lastName,
          final String? avatar,
          final String? bio,
          required final UserPreferencesModel preferences}) =
      _$UserProfileModelImpl;

  factory _UserProfileModel.fromJson(Map<String, dynamic> json) =
      _$UserProfileModelImpl.fromJson;

  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get avatar;
  @override
  String? get bio;
  @override
  UserPreferencesModel get preferences;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserPreferencesModel _$UserPreferencesModelFromJson(Map<String, dynamic> json) {
  return _UserPreferencesModel.fromJson(json);
}

/// @nodoc
mixin _$UserPreferencesModel {
  String get theme => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  NotificationPreferencesModel get notifications =>
      throw _privateConstructorUsedError;
  PrivacyPreferencesModel get privacy => throw _privateConstructorUsedError;

  /// Serializes this UserPreferencesModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPreferencesModelCopyWith<UserPreferencesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPreferencesModelCopyWith<$Res> {
  factory $UserPreferencesModelCopyWith(UserPreferencesModel value,
          $Res Function(UserPreferencesModel) then) =
      _$UserPreferencesModelCopyWithImpl<$Res, UserPreferencesModel>;
  @useResult
  $Res call(
      {String theme,
      String language,
      NotificationPreferencesModel notifications,
      PrivacyPreferencesModel privacy});

  $NotificationPreferencesModelCopyWith<$Res> get notifications;
  $PrivacyPreferencesModelCopyWith<$Res> get privacy;
}

/// @nodoc
class _$UserPreferencesModelCopyWithImpl<$Res,
        $Val extends UserPreferencesModel>
    implements $UserPreferencesModelCopyWith<$Res> {
  _$UserPreferencesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? theme = null,
    Object? language = null,
    Object? notifications = null,
    Object? privacy = null,
  }) {
    return _then(_value.copyWith(
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      notifications: null == notifications
          ? _value.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as NotificationPreferencesModel,
      privacy: null == privacy
          ? _value.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as PrivacyPreferencesModel,
    ) as $Val);
  }

  /// Create a copy of UserPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NotificationPreferencesModelCopyWith<$Res> get notifications {
    return $NotificationPreferencesModelCopyWith<$Res>(_value.notifications,
        (value) {
      return _then(_value.copyWith(notifications: value) as $Val);
    });
  }

  /// Create a copy of UserPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PrivacyPreferencesModelCopyWith<$Res> get privacy {
    return $PrivacyPreferencesModelCopyWith<$Res>(_value.privacy, (value) {
      return _then(_value.copyWith(privacy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserPreferencesModelImplCopyWith<$Res>
    implements $UserPreferencesModelCopyWith<$Res> {
  factory _$$UserPreferencesModelImplCopyWith(_$UserPreferencesModelImpl value,
          $Res Function(_$UserPreferencesModelImpl) then) =
      __$$UserPreferencesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String theme,
      String language,
      NotificationPreferencesModel notifications,
      PrivacyPreferencesModel privacy});

  @override
  $NotificationPreferencesModelCopyWith<$Res> get notifications;
  @override
  $PrivacyPreferencesModelCopyWith<$Res> get privacy;
}

/// @nodoc
class __$$UserPreferencesModelImplCopyWithImpl<$Res>
    extends _$UserPreferencesModelCopyWithImpl<$Res, _$UserPreferencesModelImpl>
    implements _$$UserPreferencesModelImplCopyWith<$Res> {
  __$$UserPreferencesModelImplCopyWithImpl(_$UserPreferencesModelImpl _value,
      $Res Function(_$UserPreferencesModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? theme = null,
    Object? language = null,
    Object? notifications = null,
    Object? privacy = null,
  }) {
    return _then(_$UserPreferencesModelImpl(
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      notifications: null == notifications
          ? _value.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as NotificationPreferencesModel,
      privacy: null == privacy
          ? _value.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as PrivacyPreferencesModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPreferencesModelImpl implements _UserPreferencesModel {
  const _$UserPreferencesModelImpl(
      {this.theme = 'system',
      this.language = 'en',
      required this.notifications,
      required this.privacy});

  factory _$UserPreferencesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPreferencesModelImplFromJson(json);

  @override
  @JsonKey()
  final String theme;
  @override
  @JsonKey()
  final String language;
  @override
  final NotificationPreferencesModel notifications;
  @override
  final PrivacyPreferencesModel privacy;

  @override
  String toString() {
    return 'UserPreferencesModel(theme: $theme, language: $language, notifications: $notifications, privacy: $privacy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPreferencesModelImpl &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.notifications, notifications) ||
                other.notifications == notifications) &&
            (identical(other.privacy, privacy) || other.privacy == privacy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, theme, language, notifications, privacy);

  /// Create a copy of UserPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPreferencesModelImplCopyWith<_$UserPreferencesModelImpl>
      get copyWith =>
          __$$UserPreferencesModelImplCopyWithImpl<_$UserPreferencesModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPreferencesModelImplToJson(
      this,
    );
  }
}

abstract class _UserPreferencesModel implements UserPreferencesModel {
  const factory _UserPreferencesModel(
          {final String theme,
          final String language,
          required final NotificationPreferencesModel notifications,
          required final PrivacyPreferencesModel privacy}) =
      _$UserPreferencesModelImpl;

  factory _UserPreferencesModel.fromJson(Map<String, dynamic> json) =
      _$UserPreferencesModelImpl.fromJson;

  @override
  String get theme;
  @override
  String get language;
  @override
  NotificationPreferencesModel get notifications;
  @override
  PrivacyPreferencesModel get privacy;

  /// Create a copy of UserPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPreferencesModelImplCopyWith<_$UserPreferencesModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NotificationPreferencesModel _$NotificationPreferencesModelFromJson(
    Map<String, dynamic> json) {
  return _NotificationPreferencesModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationPreferencesModel {
  bool get email => throw _privateConstructorUsedError;
  bool get push => throw _privateConstructorUsedError;
  bool get marketing => throw _privateConstructorUsedError;
  bool get learningReminders => throw _privateConstructorUsedError;
  bool get socialUpdates => throw _privateConstructorUsedError;

  /// Serializes this NotificationPreferencesModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationPreferencesModelCopyWith<NotificationPreferencesModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationPreferencesModelCopyWith<$Res> {
  factory $NotificationPreferencesModelCopyWith(
          NotificationPreferencesModel value,
          $Res Function(NotificationPreferencesModel) then) =
      _$NotificationPreferencesModelCopyWithImpl<$Res,
          NotificationPreferencesModel>;
  @useResult
  $Res call(
      {bool email,
      bool push,
      bool marketing,
      bool learningReminders,
      bool socialUpdates});
}

/// @nodoc
class _$NotificationPreferencesModelCopyWithImpl<$Res,
        $Val extends NotificationPreferencesModel>
    implements $NotificationPreferencesModelCopyWith<$Res> {
  _$NotificationPreferencesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? push = null,
    Object? marketing = null,
    Object? learningReminders = null,
    Object? socialUpdates = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as bool,
      push: null == push
          ? _value.push
          : push // ignore: cast_nullable_to_non_nullable
              as bool,
      marketing: null == marketing
          ? _value.marketing
          : marketing // ignore: cast_nullable_to_non_nullable
              as bool,
      learningReminders: null == learningReminders
          ? _value.learningReminders
          : learningReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      socialUpdates: null == socialUpdates
          ? _value.socialUpdates
          : socialUpdates // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationPreferencesModelImplCopyWith<$Res>
    implements $NotificationPreferencesModelCopyWith<$Res> {
  factory _$$NotificationPreferencesModelImplCopyWith(
          _$NotificationPreferencesModelImpl value,
          $Res Function(_$NotificationPreferencesModelImpl) then) =
      __$$NotificationPreferencesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool email,
      bool push,
      bool marketing,
      bool learningReminders,
      bool socialUpdates});
}

/// @nodoc
class __$$NotificationPreferencesModelImplCopyWithImpl<$Res>
    extends _$NotificationPreferencesModelCopyWithImpl<$Res,
        _$NotificationPreferencesModelImpl>
    implements _$$NotificationPreferencesModelImplCopyWith<$Res> {
  __$$NotificationPreferencesModelImplCopyWithImpl(
      _$NotificationPreferencesModelImpl _value,
      $Res Function(_$NotificationPreferencesModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? push = null,
    Object? marketing = null,
    Object? learningReminders = null,
    Object? socialUpdates = null,
  }) {
    return _then(_$NotificationPreferencesModelImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as bool,
      push: null == push
          ? _value.push
          : push // ignore: cast_nullable_to_non_nullable
              as bool,
      marketing: null == marketing
          ? _value.marketing
          : marketing // ignore: cast_nullable_to_non_nullable
              as bool,
      learningReminders: null == learningReminders
          ? _value.learningReminders
          : learningReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      socialUpdates: null == socialUpdates
          ? _value.socialUpdates
          : socialUpdates // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationPreferencesModelImpl
    implements _NotificationPreferencesModel {
  const _$NotificationPreferencesModelImpl(
      {this.email = true,
      this.push = true,
      this.marketing = false,
      this.learningReminders = true,
      this.socialUpdates = true});

  factory _$NotificationPreferencesModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NotificationPreferencesModelImplFromJson(json);

  @override
  @JsonKey()
  final bool email;
  @override
  @JsonKey()
  final bool push;
  @override
  @JsonKey()
  final bool marketing;
  @override
  @JsonKey()
  final bool learningReminders;
  @override
  @JsonKey()
  final bool socialUpdates;

  @override
  String toString() {
    return 'NotificationPreferencesModel(email: $email, push: $push, marketing: $marketing, learningReminders: $learningReminders, socialUpdates: $socialUpdates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationPreferencesModelImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.push, push) || other.push == push) &&
            (identical(other.marketing, marketing) ||
                other.marketing == marketing) &&
            (identical(other.learningReminders, learningReminders) ||
                other.learningReminders == learningReminders) &&
            (identical(other.socialUpdates, socialUpdates) ||
                other.socialUpdates == socialUpdates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, email, push, marketing, learningReminders, socialUpdates);

  /// Create a copy of NotificationPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationPreferencesModelImplCopyWith<
          _$NotificationPreferencesModelImpl>
      get copyWith => __$$NotificationPreferencesModelImplCopyWithImpl<
          _$NotificationPreferencesModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationPreferencesModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationPreferencesModel
    implements NotificationPreferencesModel {
  const factory _NotificationPreferencesModel(
      {final bool email,
      final bool push,
      final bool marketing,
      final bool learningReminders,
      final bool socialUpdates}) = _$NotificationPreferencesModelImpl;

  factory _NotificationPreferencesModel.fromJson(Map<String, dynamic> json) =
      _$NotificationPreferencesModelImpl.fromJson;

  @override
  bool get email;
  @override
  bool get push;
  @override
  bool get marketing;
  @override
  bool get learningReminders;
  @override
  bool get socialUpdates;

  /// Create a copy of NotificationPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationPreferencesModelImplCopyWith<
          _$NotificationPreferencesModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PrivacyPreferencesModel _$PrivacyPreferencesModelFromJson(
    Map<String, dynamic> json) {
  return _PrivacyPreferencesModel.fromJson(json);
}

/// @nodoc
mixin _$PrivacyPreferencesModel {
  String get profileVisibility => throw _privateConstructorUsedError;
  String get activityVisibility => throw _privateConstructorUsedError;
  bool get showProgress => throw _privateConstructorUsedError;

  /// Serializes this PrivacyPreferencesModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrivacyPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrivacyPreferencesModelCopyWith<PrivacyPreferencesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrivacyPreferencesModelCopyWith<$Res> {
  factory $PrivacyPreferencesModelCopyWith(PrivacyPreferencesModel value,
          $Res Function(PrivacyPreferencesModel) then) =
      _$PrivacyPreferencesModelCopyWithImpl<$Res, PrivacyPreferencesModel>;
  @useResult
  $Res call(
      {String profileVisibility, String activityVisibility, bool showProgress});
}

/// @nodoc
class _$PrivacyPreferencesModelCopyWithImpl<$Res,
        $Val extends PrivacyPreferencesModel>
    implements $PrivacyPreferencesModelCopyWith<$Res> {
  _$PrivacyPreferencesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrivacyPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileVisibility = null,
    Object? activityVisibility = null,
    Object? showProgress = null,
  }) {
    return _then(_value.copyWith(
      profileVisibility: null == profileVisibility
          ? _value.profileVisibility
          : profileVisibility // ignore: cast_nullable_to_non_nullable
              as String,
      activityVisibility: null == activityVisibility
          ? _value.activityVisibility
          : activityVisibility // ignore: cast_nullable_to_non_nullable
              as String,
      showProgress: null == showProgress
          ? _value.showProgress
          : showProgress // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrivacyPreferencesModelImplCopyWith<$Res>
    implements $PrivacyPreferencesModelCopyWith<$Res> {
  factory _$$PrivacyPreferencesModelImplCopyWith(
          _$PrivacyPreferencesModelImpl value,
          $Res Function(_$PrivacyPreferencesModelImpl) then) =
      __$$PrivacyPreferencesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String profileVisibility, String activityVisibility, bool showProgress});
}

/// @nodoc
class __$$PrivacyPreferencesModelImplCopyWithImpl<$Res>
    extends _$PrivacyPreferencesModelCopyWithImpl<$Res,
        _$PrivacyPreferencesModelImpl>
    implements _$$PrivacyPreferencesModelImplCopyWith<$Res> {
  __$$PrivacyPreferencesModelImplCopyWithImpl(
      _$PrivacyPreferencesModelImpl _value,
      $Res Function(_$PrivacyPreferencesModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrivacyPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileVisibility = null,
    Object? activityVisibility = null,
    Object? showProgress = null,
  }) {
    return _then(_$PrivacyPreferencesModelImpl(
      profileVisibility: null == profileVisibility
          ? _value.profileVisibility
          : profileVisibility // ignore: cast_nullable_to_non_nullable
              as String,
      activityVisibility: null == activityVisibility
          ? _value.activityVisibility
          : activityVisibility // ignore: cast_nullable_to_non_nullable
              as String,
      showProgress: null == showProgress
          ? _value.showProgress
          : showProgress // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrivacyPreferencesModelImpl implements _PrivacyPreferencesModel {
  const _$PrivacyPreferencesModelImpl(
      {this.profileVisibility = 'public',
      this.activityVisibility = 'public',
      this.showProgress = true});

  factory _$PrivacyPreferencesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrivacyPreferencesModelImplFromJson(json);

  @override
  @JsonKey()
  final String profileVisibility;
  @override
  @JsonKey()
  final String activityVisibility;
  @override
  @JsonKey()
  final bool showProgress;

  @override
  String toString() {
    return 'PrivacyPreferencesModel(profileVisibility: $profileVisibility, activityVisibility: $activityVisibility, showProgress: $showProgress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrivacyPreferencesModelImpl &&
            (identical(other.profileVisibility, profileVisibility) ||
                other.profileVisibility == profileVisibility) &&
            (identical(other.activityVisibility, activityVisibility) ||
                other.activityVisibility == activityVisibility) &&
            (identical(other.showProgress, showProgress) ||
                other.showProgress == showProgress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, profileVisibility, activityVisibility, showProgress);

  /// Create a copy of PrivacyPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrivacyPreferencesModelImplCopyWith<_$PrivacyPreferencesModelImpl>
      get copyWith => __$$PrivacyPreferencesModelImplCopyWithImpl<
          _$PrivacyPreferencesModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrivacyPreferencesModelImplToJson(
      this,
    );
  }
}

abstract class _PrivacyPreferencesModel implements PrivacyPreferencesModel {
  const factory _PrivacyPreferencesModel(
      {final String profileVisibility,
      final String activityVisibility,
      final bool showProgress}) = _$PrivacyPreferencesModelImpl;

  factory _PrivacyPreferencesModel.fromJson(Map<String, dynamic> json) =
      _$PrivacyPreferencesModelImpl.fromJson;

  @override
  String get profileVisibility;
  @override
  String get activityVisibility;
  @override
  bool get showProgress;

  /// Create a copy of PrivacyPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrivacyPreferencesModelImplCopyWith<_$PrivacyPreferencesModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UserSubscriptionModel _$UserSubscriptionModelFromJson(
    Map<String, dynamic> json) {
  return _UserSubscriptionModel.fromJson(json);
}

/// @nodoc
mixin _$UserSubscriptionModel {
  String get tier => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  String? get stripeCustomerId => throw _privateConstructorUsedError;
  String? get stripeSubscriptionId => throw _privateConstructorUsedError;
  bool get cancelAtPeriodEnd => throw _privateConstructorUsedError;

  /// Serializes this UserSubscriptionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSubscriptionModelCopyWith<UserSubscriptionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSubscriptionModelCopyWith<$Res> {
  factory $UserSubscriptionModelCopyWith(UserSubscriptionModel value,
          $Res Function(UserSubscriptionModel) then) =
      _$UserSubscriptionModelCopyWithImpl<$Res, UserSubscriptionModel>;
  @useResult
  $Res call(
      {String tier,
      DateTime startDate,
      DateTime? endDate,
      String? stripeCustomerId,
      String? stripeSubscriptionId,
      bool cancelAtPeriodEnd});
}

/// @nodoc
class _$UserSubscriptionModelCopyWithImpl<$Res,
        $Val extends UserSubscriptionModel>
    implements $UserSubscriptionModelCopyWith<$Res> {
  _$UserSubscriptionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tier = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? stripeCustomerId = freezed,
    Object? stripeSubscriptionId = freezed,
    Object? cancelAtPeriodEnd = null,
  }) {
    return _then(_value.copyWith(
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      stripeCustomerId: freezed == stripeCustomerId
          ? _value.stripeCustomerId
          : stripeCustomerId // ignore: cast_nullable_to_non_nullable
              as String?,
      stripeSubscriptionId: freezed == stripeSubscriptionId
          ? _value.stripeSubscriptionId
          : stripeSubscriptionId // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelAtPeriodEnd: null == cancelAtPeriodEnd
          ? _value.cancelAtPeriodEnd
          : cancelAtPeriodEnd // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSubscriptionModelImplCopyWith<$Res>
    implements $UserSubscriptionModelCopyWith<$Res> {
  factory _$$UserSubscriptionModelImplCopyWith(
          _$UserSubscriptionModelImpl value,
          $Res Function(_$UserSubscriptionModelImpl) then) =
      __$$UserSubscriptionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String tier,
      DateTime startDate,
      DateTime? endDate,
      String? stripeCustomerId,
      String? stripeSubscriptionId,
      bool cancelAtPeriodEnd});
}

/// @nodoc
class __$$UserSubscriptionModelImplCopyWithImpl<$Res>
    extends _$UserSubscriptionModelCopyWithImpl<$Res,
        _$UserSubscriptionModelImpl>
    implements _$$UserSubscriptionModelImplCopyWith<$Res> {
  __$$UserSubscriptionModelImplCopyWithImpl(_$UserSubscriptionModelImpl _value,
      $Res Function(_$UserSubscriptionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tier = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? stripeCustomerId = freezed,
    Object? stripeSubscriptionId = freezed,
    Object? cancelAtPeriodEnd = null,
  }) {
    return _then(_$UserSubscriptionModelImpl(
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      stripeCustomerId: freezed == stripeCustomerId
          ? _value.stripeCustomerId
          : stripeCustomerId // ignore: cast_nullable_to_non_nullable
              as String?,
      stripeSubscriptionId: freezed == stripeSubscriptionId
          ? _value.stripeSubscriptionId
          : stripeSubscriptionId // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelAtPeriodEnd: null == cancelAtPeriodEnd
          ? _value.cancelAtPeriodEnd
          : cancelAtPeriodEnd // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSubscriptionModelImpl implements _UserSubscriptionModel {
  const _$UserSubscriptionModelImpl(
      {this.tier = 'free',
      required this.startDate,
      this.endDate,
      this.stripeCustomerId,
      this.stripeSubscriptionId,
      this.cancelAtPeriodEnd = false});

  factory _$UserSubscriptionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSubscriptionModelImplFromJson(json);

  @override
  @JsonKey()
  final String tier;
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;
  @override
  final String? stripeCustomerId;
  @override
  final String? stripeSubscriptionId;
  @override
  @JsonKey()
  final bool cancelAtPeriodEnd;

  @override
  String toString() {
    return 'UserSubscriptionModel(tier: $tier, startDate: $startDate, endDate: $endDate, stripeCustomerId: $stripeCustomerId, stripeSubscriptionId: $stripeSubscriptionId, cancelAtPeriodEnd: $cancelAtPeriodEnd)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSubscriptionModelImpl &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.stripeCustomerId, stripeCustomerId) ||
                other.stripeCustomerId == stripeCustomerId) &&
            (identical(other.stripeSubscriptionId, stripeSubscriptionId) ||
                other.stripeSubscriptionId == stripeSubscriptionId) &&
            (identical(other.cancelAtPeriodEnd, cancelAtPeriodEnd) ||
                other.cancelAtPeriodEnd == cancelAtPeriodEnd));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, tier, startDate, endDate,
      stripeCustomerId, stripeSubscriptionId, cancelAtPeriodEnd);

  /// Create a copy of UserSubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSubscriptionModelImplCopyWith<_$UserSubscriptionModelImpl>
      get copyWith => __$$UserSubscriptionModelImplCopyWithImpl<
          _$UserSubscriptionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSubscriptionModelImplToJson(
      this,
    );
  }
}

abstract class _UserSubscriptionModel implements UserSubscriptionModel {
  const factory _UserSubscriptionModel(
      {final String tier,
      required final DateTime startDate,
      final DateTime? endDate,
      final String? stripeCustomerId,
      final String? stripeSubscriptionId,
      final bool cancelAtPeriodEnd}) = _$UserSubscriptionModelImpl;

  factory _UserSubscriptionModel.fromJson(Map<String, dynamic> json) =
      _$UserSubscriptionModelImpl.fromJson;

  @override
  String get tier;
  @override
  DateTime get startDate;
  @override
  DateTime? get endDate;
  @override
  String? get stripeCustomerId;
  @override
  String? get stripeSubscriptionId;
  @override
  bool get cancelAtPeriodEnd;

  /// Create a copy of UserSubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSubscriptionModelImplCopyWith<_$UserSubscriptionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UserStatsModel _$UserStatsModelFromJson(Map<String, dynamic> json) {
  return _UserStatsModel.fromJson(json);
}

/// @nodoc
mixin _$UserStatsModel {
  int get totalBookmarks => throw _privateConstructorUsedError;
  int get projectsCompleted => throw _privateConstructorUsedError;
  int get streakDays => throw _privateConstructorUsedError;
  int get totalPoints => throw _privateConstructorUsedError;
  int get currentLevel => throw _privateConstructorUsedError;
  int get quizzesCompleted => throw _privateConstructorUsedError;
  int get flashcardsReviewed => throw _privateConstructorUsedError;

  /// Serializes this UserStatsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStatsModelCopyWith<UserStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatsModelCopyWith<$Res> {
  factory $UserStatsModelCopyWith(
          UserStatsModel value, $Res Function(UserStatsModel) then) =
      _$UserStatsModelCopyWithImpl<$Res, UserStatsModel>;
  @useResult
  $Res call(
      {int totalBookmarks,
      int projectsCompleted,
      int streakDays,
      int totalPoints,
      int currentLevel,
      int quizzesCompleted,
      int flashcardsReviewed});
}

/// @nodoc
class _$UserStatsModelCopyWithImpl<$Res, $Val extends UserStatsModel>
    implements $UserStatsModelCopyWith<$Res> {
  _$UserStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalBookmarks = null,
    Object? projectsCompleted = null,
    Object? streakDays = null,
    Object? totalPoints = null,
    Object? currentLevel = null,
    Object? quizzesCompleted = null,
    Object? flashcardsReviewed = null,
  }) {
    return _then(_value.copyWith(
      totalBookmarks: null == totalBookmarks
          ? _value.totalBookmarks
          : totalBookmarks // ignore: cast_nullable_to_non_nullable
              as int,
      projectsCompleted: null == projectsCompleted
          ? _value.projectsCompleted
          : projectsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      totalPoints: null == totalPoints
          ? _value.totalPoints
          : totalPoints // ignore: cast_nullable_to_non_nullable
              as int,
      currentLevel: null == currentLevel
          ? _value.currentLevel
          : currentLevel // ignore: cast_nullable_to_non_nullable
              as int,
      quizzesCompleted: null == quizzesCompleted
          ? _value.quizzesCompleted
          : quizzesCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      flashcardsReviewed: null == flashcardsReviewed
          ? _value.flashcardsReviewed
          : flashcardsReviewed // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserStatsModelImplCopyWith<$Res>
    implements $UserStatsModelCopyWith<$Res> {
  factory _$$UserStatsModelImplCopyWith(_$UserStatsModelImpl value,
          $Res Function(_$UserStatsModelImpl) then) =
      __$$UserStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalBookmarks,
      int projectsCompleted,
      int streakDays,
      int totalPoints,
      int currentLevel,
      int quizzesCompleted,
      int flashcardsReviewed});
}

/// @nodoc
class __$$UserStatsModelImplCopyWithImpl<$Res>
    extends _$UserStatsModelCopyWithImpl<$Res, _$UserStatsModelImpl>
    implements _$$UserStatsModelImplCopyWith<$Res> {
  __$$UserStatsModelImplCopyWithImpl(
      _$UserStatsModelImpl _value, $Res Function(_$UserStatsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalBookmarks = null,
    Object? projectsCompleted = null,
    Object? streakDays = null,
    Object? totalPoints = null,
    Object? currentLevel = null,
    Object? quizzesCompleted = null,
    Object? flashcardsReviewed = null,
  }) {
    return _then(_$UserStatsModelImpl(
      totalBookmarks: null == totalBookmarks
          ? _value.totalBookmarks
          : totalBookmarks // ignore: cast_nullable_to_non_nullable
              as int,
      projectsCompleted: null == projectsCompleted
          ? _value.projectsCompleted
          : projectsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      totalPoints: null == totalPoints
          ? _value.totalPoints
          : totalPoints // ignore: cast_nullable_to_non_nullable
              as int,
      currentLevel: null == currentLevel
          ? _value.currentLevel
          : currentLevel // ignore: cast_nullable_to_non_nullable
              as int,
      quizzesCompleted: null == quizzesCompleted
          ? _value.quizzesCompleted
          : quizzesCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      flashcardsReviewed: null == flashcardsReviewed
          ? _value.flashcardsReviewed
          : flashcardsReviewed // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStatsModelImpl implements _UserStatsModel {
  const _$UserStatsModelImpl(
      {this.totalBookmarks = 0,
      this.projectsCompleted = 0,
      this.streakDays = 0,
      this.totalPoints = 0,
      this.currentLevel = 1,
      this.quizzesCompleted = 0,
      this.flashcardsReviewed = 0});

  factory _$UserStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStatsModelImplFromJson(json);

  @override
  @JsonKey()
  final int totalBookmarks;
  @override
  @JsonKey()
  final int projectsCompleted;
  @override
  @JsonKey()
  final int streakDays;
  @override
  @JsonKey()
  final int totalPoints;
  @override
  @JsonKey()
  final int currentLevel;
  @override
  @JsonKey()
  final int quizzesCompleted;
  @override
  @JsonKey()
  final int flashcardsReviewed;

  @override
  String toString() {
    return 'UserStatsModel(totalBookmarks: $totalBookmarks, projectsCompleted: $projectsCompleted, streakDays: $streakDays, totalPoints: $totalPoints, currentLevel: $currentLevel, quizzesCompleted: $quizzesCompleted, flashcardsReviewed: $flashcardsReviewed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatsModelImpl &&
            (identical(other.totalBookmarks, totalBookmarks) ||
                other.totalBookmarks == totalBookmarks) &&
            (identical(other.projectsCompleted, projectsCompleted) ||
                other.projectsCompleted == projectsCompleted) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays) &&
            (identical(other.totalPoints, totalPoints) ||
                other.totalPoints == totalPoints) &&
            (identical(other.currentLevel, currentLevel) ||
                other.currentLevel == currentLevel) &&
            (identical(other.quizzesCompleted, quizzesCompleted) ||
                other.quizzesCompleted == quizzesCompleted) &&
            (identical(other.flashcardsReviewed, flashcardsReviewed) ||
                other.flashcardsReviewed == flashcardsReviewed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalBookmarks,
      projectsCompleted,
      streakDays,
      totalPoints,
      currentLevel,
      quizzesCompleted,
      flashcardsReviewed);

  /// Create a copy of UserStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatsModelImplCopyWith<_$UserStatsModelImpl> get copyWith =>
      __$$UserStatsModelImplCopyWithImpl<_$UserStatsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStatsModelImplToJson(
      this,
    );
  }
}

abstract class _UserStatsModel implements UserStatsModel {
  const factory _UserStatsModel(
      {final int totalBookmarks,
      final int projectsCompleted,
      final int streakDays,
      final int totalPoints,
      final int currentLevel,
      final int quizzesCompleted,
      final int flashcardsReviewed}) = _$UserStatsModelImpl;

  factory _UserStatsModel.fromJson(Map<String, dynamic> json) =
      _$UserStatsModelImpl.fromJson;

  @override
  int get totalBookmarks;
  @override
  int get projectsCompleted;
  @override
  int get streakDays;
  @override
  int get totalPoints;
  @override
  int get currentLevel;
  @override
  int get quizzesCompleted;
  @override
  int get flashcardsReviewed;

  /// Create a copy of UserStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStatsModelImplCopyWith<_$UserStatsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
