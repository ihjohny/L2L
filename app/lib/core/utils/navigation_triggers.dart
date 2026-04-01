/// Navigation triggers for ViewModel state-based navigation.
///
/// ViewModels set these triggers in their state, and the UI observes
/// them to perform actual navigation. This keeps ViewModels pure and testable.
enum AuthNavigationTrigger {
  /// No navigation required
  none,

  /// Navigate to home screen (after successful login/register)
  toHome,

  /// Navigate to login screen (after logout)
  toLogin,

  /// Navigate to register screen
  toRegister,
}

/// Navigation triggers for project-related ViewModels.
enum ProjectNavigationTrigger {
  /// No navigation required
  none,

  /// Navigate to project list
  toProjectsList,

  /// Navigate to project detail
  toProjectDetail,

  /// Navigate to edit project
  toEditProject,

  /// Navigate back (pop)
  back,

  /// Navigate to home
  toHome,
}

/// Navigation triggers for link-related ViewModels.
enum LinkNavigationTrigger {
  /// No navigation required
  none,

  /// Navigate to links list
  toLinksList,

  /// Navigate to link detail
  toLinkDetail,

  /// Navigate to add link
  toAddLink,

  /// Navigate back (pop)
  back,

  /// Navigate to home
  toHome,
}
