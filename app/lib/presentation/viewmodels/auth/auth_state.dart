import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/models/user_model.dart';
import '../../../../core/utils/navigation_triggers.dart';

part 'auth_state.freezed.dart';

/// Immutable state for the AuthViewModel.
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    /// Current authenticated user (null if not authenticated)
    UserModel? user,

    /// Whether the ViewModel is currently loading
    @Default(false) bool isLoading,

    /// Error message from the last failed operation
    String? error,

    /// Navigation trigger for the UI to consume
    @Default(AuthNavigationTrigger.none) AuthNavigationTrigger navigationTrigger,

    /// Form state
    @Default('') String email,
    @Default('') String password,
    @Default('') String name,
    @Default('') String confirmPassword,

    /// Password visibility toggle
    @Default(true) bool obscurePassword,
    @Default(true) bool obscureConfirmPassword,
  }) = _AuthState;

  /// Initial state for login flow
  factory AuthState.initial() => const AuthState(
        user: null,
        isLoading: true, // Start loading to check existing session
        error: null,
        navigationTrigger: AuthNavigationTrigger.none,
      );

  /// State for login form
  factory AuthState.loginInitial() => const AuthState(
        user: null,
        isLoading: false,
        error: null,
        navigationTrigger: AuthNavigationTrigger.none,
      );

  /// State for register form
  factory AuthState.registerInitial() => const AuthState(
        user: null,
        isLoading: false,
        error: null,
        navigationTrigger: AuthNavigationTrigger.none,
      );
}

/// Extension methods for AuthState.
extension AuthStateX on AuthState {
  /// Whether the user is authenticated
  bool get isAuthenticated => user != null;

  /// Whether the login form is valid
  bool get canLogin => !isLoading && email.isNotEmpty && password.isNotEmpty;

  /// Whether the register form is valid
  bool get canRegister =>
      !isLoading &&
      name.isNotEmpty &&
      email.isNotEmpty &&
      password.isNotEmpty &&
      password == confirmPassword;

  /// Whether login button should be enabled
  bool get isLoginEnabled => canLogin;

  /// Whether register button should be enabled
  bool get isRegisterEnabled => canRegister;

  /// Whether the form is in error state
  bool get hasError => error != null;

  /// Whether the ViewModel is checking for existing session
  bool get isInitializing => isLoading && user == null;
}
