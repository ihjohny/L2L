import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../core/utils/navigation_triggers.dart';
import 'auth_state.dart';

/// ViewModel for authentication-related operations.
///
/// Manages login, register, logout, and session state.
class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository) : super(AuthState.initial()) {
    _initializeAuth();
  }

  /// Initialize authentication - check for existing session.
  Future<void> _initializeAuth() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _authRepository.initializeAuth();
      if (!mounted) return;
      result.fold(
        (user) {
          state = AuthState.loginInitial().copyWith(
            user: user,
            isLoading: false,
          );
        },
        (_) {
          // On failure, start with clean login state
          state = AuthState.loginInitial();
        },
      );
    } catch (e) {
      state = AuthState.loginInitial();
    }
  }

  /// Update email field.
  void setEmail(String email) {
    state = state.copyWith(email: email, error: null);
  }

  /// Update password field.
  void setPassword(String password) {
    state = state.copyWith(password: password, error: null);
  }

  /// Update name field.
  void setName(String name) {
    state = state.copyWith(name: name, error: null);
  }

  /// Update confirm password field.
  void setConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword, error: null);
  }

  /// Toggle password visibility.
  void togglePasswordVisibility() {
    state = state.copyWith(
      obscurePassword: !state.obscurePassword,
    );
  }

  /// Toggle confirm password visibility.
  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      obscureConfirmPassword: !state.obscureConfirmPassword,
    );
  }

  /// Attempt to login with current credentials.
  Future<void> login() async {
    if (!state.canLogin) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authRepository.login(
        state.email,
        state.password,
      );

      if (!mounted) return;
      result.fold(
        (user) {
          state = state.copyWith(
            isLoading: false,
            user: user,
            navigationTrigger: AuthNavigationTrigger.toHome,
          );
        },
        (error) {
          state = state.copyWith(
            isLoading: false,
            error: error,
            navigationTrigger: AuthNavigationTrigger.none,
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Attempt to register with current credentials.
  Future<void> register() async {
    if (!state.canRegister) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authRepository.register(
        name: state.name,
        email: state.email,
        password: state.password,
      );

      if (!mounted) return;
      result.fold(
        (user) {
          state = state.copyWith(
            isLoading: false,
            user: user,
            navigationTrigger: AuthNavigationTrigger.toHome,
          );
        },
        (error) {
          state = state.copyWith(
            isLoading: false,
            error: error,
            navigationTrigger: AuthNavigationTrigger.none,
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Logout the current user.
  Future<void> logout() async {
    await _authRepository.logout();
    state = state.copyWith(
      user: null,
      email: '',
      password: '',
      name: '',
      confirmPassword: '',
      navigationTrigger: AuthNavigationTrigger.toLogin,
    );
  }

  /// Clear the current error.
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Reset navigation trigger after UI has consumed it.
  void resetNavigationTrigger() {
    state = state.copyWith(navigationTrigger: AuthNavigationTrigger.none);
  }

  /// Switch to login form state.
  void switchToLogin() {
    state = AuthState.loginInitial();
  }

  /// Switch to register form state.
  void switchToRegister() {
    state = AuthState.registerInitial();
  }
}

/// Provider for AuthViewModel.
final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthViewModel(repository);
});
