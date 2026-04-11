/// App-wide constants
///
/// Contains constant values used throughout the application.
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  /// Delay in seconds after retrying link processing before refreshing data
  static const int retryDelaySeconds = 2;

  /// Delay in seconds after generating course/quiz before reloading project data
  static const int reloadDelaySeconds = 2;
}
