class AppConstants {
  static const String appName = 'L2L';
  static const String appVersion = '1.0.0';

  // API Endpoints
  static const String authPath = '/auth';
  static const String contentPath = '/content';

  // Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserProfile = 'user_profile';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Duration
  static const int snackBarDuration = 3;
  static const int animationDuration = 300;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;

  // UI
  static const double borderRadius = 12.0;
  static const double cardElevation = 0.0;
}
