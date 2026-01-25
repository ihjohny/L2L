// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['_id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      profile:
          UserProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
      subscription: UserSubscriptionModel.fromJson(
          json['subscription'] as Map<String, dynamic>),
      stats: UserStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'profile': instance.profile,
      'subscription': instance.subscription,
      'stats': instance.stats,
      'isEmailVerified': instance.isEmailVerified,
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
    };

_$UserProfileModelImpl _$$UserProfileModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserProfileModelImpl(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      avatar: json['avatar'] as String?,
      bio: json['bio'] as String?,
      preferences: UserPreferencesModel.fromJson(
          json['preferences'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserProfileModelImplToJson(
        _$UserProfileModelImpl instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'avatar': instance.avatar,
      'bio': instance.bio,
      'preferences': instance.preferences,
    };

_$UserPreferencesModelImpl _$$UserPreferencesModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserPreferencesModelImpl(
      theme: json['theme'] as String? ?? 'system',
      language: json['language'] as String? ?? 'en',
      notifications: NotificationPreferencesModel.fromJson(
          json['notifications'] as Map<String, dynamic>),
      privacy: PrivacyPreferencesModel.fromJson(
          json['privacy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserPreferencesModelImplToJson(
        _$UserPreferencesModelImpl instance) =>
    <String, dynamic>{
      'theme': instance.theme,
      'language': instance.language,
      'notifications': instance.notifications,
      'privacy': instance.privacy,
    };

_$NotificationPreferencesModelImpl _$$NotificationPreferencesModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationPreferencesModelImpl(
      email: json['email'] as bool? ?? true,
      push: json['push'] as bool? ?? true,
      marketing: json['marketing'] as bool? ?? false,
      learningReminders: json['learningReminders'] as bool? ?? true,
      socialUpdates: json['socialUpdates'] as bool? ?? true,
    );

Map<String, dynamic> _$$NotificationPreferencesModelImplToJson(
        _$NotificationPreferencesModelImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'push': instance.push,
      'marketing': instance.marketing,
      'learningReminders': instance.learningReminders,
      'socialUpdates': instance.socialUpdates,
    };

_$PrivacyPreferencesModelImpl _$$PrivacyPreferencesModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PrivacyPreferencesModelImpl(
      profileVisibility: json['profileVisibility'] as String? ?? 'public',
      activityVisibility: json['activityVisibility'] as String? ?? 'public',
      showProgress: json['showProgress'] as bool? ?? true,
    );

Map<String, dynamic> _$$PrivacyPreferencesModelImplToJson(
        _$PrivacyPreferencesModelImpl instance) =>
    <String, dynamic>{
      'profileVisibility': instance.profileVisibility,
      'activityVisibility': instance.activityVisibility,
      'showProgress': instance.showProgress,
    };

_$UserSubscriptionModelImpl _$$UserSubscriptionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserSubscriptionModelImpl(
      tier: json['tier'] as String? ?? 'free',
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      stripeCustomerId: json['stripeCustomerId'] as String?,
      stripeSubscriptionId: json['stripeSubscriptionId'] as String?,
      cancelAtPeriodEnd: json['cancelAtPeriodEnd'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserSubscriptionModelImplToJson(
        _$UserSubscriptionModelImpl instance) =>
    <String, dynamic>{
      'tier': instance.tier,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'stripeCustomerId': instance.stripeCustomerId,
      'stripeSubscriptionId': instance.stripeSubscriptionId,
      'cancelAtPeriodEnd': instance.cancelAtPeriodEnd,
    };

_$UserStatsModelImpl _$$UserStatsModelImplFromJson(Map<String, dynamic> json) =>
    _$UserStatsModelImpl(
      totalBookmarks: (json['totalBookmarks'] as num?)?.toInt() ?? 0,
      projectsCompleted: (json['projectsCompleted'] as num?)?.toInt() ?? 0,
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      currentLevel: (json['currentLevel'] as num?)?.toInt() ?? 1,
      quizzesCompleted: (json['quizzesCompleted'] as num?)?.toInt() ?? 0,
      flashcardsReviewed: (json['flashcardsReviewed'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserStatsModelImplToJson(
        _$UserStatsModelImpl instance) =>
    <String, dynamic>{
      'totalBookmarks': instance.totalBookmarks,
      'projectsCompleted': instance.projectsCompleted,
      'streakDays': instance.streakDays,
      'totalPoints': instance.totalPoints,
      'currentLevel': instance.currentLevel,
      'quizzesCompleted': instance.quizzesCompleted,
      'flashcardsReviewed': instance.flashcardsReviewed,
    };
