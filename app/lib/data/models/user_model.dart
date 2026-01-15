import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String username,
    required UserProfileModel profile,
    required UserSubscriptionModel subscription,
    required UserStatsModel stats,
    @Default(false) bool isEmailVerified,
    DateTime? lastLoginAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String firstName,
    required String lastName,
    String? avatar,
    String? bio,
    required UserPreferencesModel preferences,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}

@freezed
class UserPreferencesModel with _$UserPreferencesModel {
  const factory UserPreferencesModel({
    @Default('system') String theme,
    @Default('en') String language,
    required NotificationPreferencesModel notifications,
    required PrivacyPreferencesModel privacy,
  }) = _UserPreferencesModel;

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesModelFromJson(json);
}

@freezed
class NotificationPreferencesModel with _$NotificationPreferencesModel {
  const factory NotificationPreferencesModel({
    @Default(true) bool email,
    @Default(true) bool push,
    @Default(false) bool marketing,
    @Default(true) bool learningReminders,
    @Default(true) bool socialUpdates,
  }) = _NotificationPreferencesModel;

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesModelFromJson(json);
}

@freezed
class PrivacyPreferencesModel with _$PrivacyPreferencesModel {
  const factory PrivacyPreferencesModel({
    @Default('public') String profileVisibility,
    @Default('public') String activityVisibility,
    @Default(true) bool showProgress,
  }) = _PrivacyPreferencesModel;

  factory PrivacyPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$PrivacyPreferencesModelFromJson(json);
}

@freezed
class UserSubscriptionModel with _$UserSubscriptionModel {
  const factory UserSubscriptionModel({
    @Default('free') String tier,
    required DateTime startDate,
    DateTime? endDate,
    String? stripeCustomerId,
    String? stripeSubscriptionId,
    @Default(false) bool cancelAtPeriodEnd,
  }) = _UserSubscriptionModel;

  factory UserSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$UserSubscriptionModelFromJson(json);
}

@freezed
class UserStatsModel with _$UserStatsModel {
  const factory UserStatsModel({
    @Default(0) int totalBookmarks,
    @Default(0) int projectsCompleted,
    @Default(0) int streakDays,
    @Default(0) int totalPoints,
    @Default(1) int currentLevel,
    @Default(0) int quizzesCompleted,
    @Default(0) int flashcardsReviewed,
  }) = _UserStatsModel;

  factory UserStatsModel.fromJson(Map<String, dynamic> json) =>
      _$UserStatsModelFromJson(json);
}
