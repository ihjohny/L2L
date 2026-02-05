import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../providers/auth_providers.dart';

// Router key for navigation
final _rootNavigatorKey = GlobalKey<NavigatorState>();

// Router provider with auth state integration
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Check if currently initializing (on splash screen)
      final isInitializing = authState.isLoading && authState.user == null;
      final isAuthenticated = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      final isSplash = state.matchedLocation == '/splash';

      // If still initializing, stay on splash
      if (isSplash) {
        if (!isInitializing) {
          // Initialization complete, redirect appropriately
          return isAuthenticated ? '/' : '/login';
        }
        return null;
      }

      // If not authenticated and trying to access protected route, redirect to login
      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      // If authenticated and trying to access login/register, redirect to home
      if (isAuthenticated && isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SplashPage(),
        ),
      ),

      // Authentication Routes
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const RegisterPage(),
        ),
      ),

      // Home & Main App Routes (Protected)
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const HomePage(initialIndex: 0),
        ),
      ),

      // Projects Routes (Protected)
      GoRoute(
        path: '/projects',
        name: 'projects',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const HomePage(initialIndex: 0),
        ),
      ),

      // Bookmarks Routes (Protected)
      GoRoute(
        path: '/bookmarks',
        name: 'bookmarks',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const HomePage(initialIndex: 1),
        ),
      ),

      // Profile Routes (Protected)
      GoRoute(
        path: '/profile',
        name: 'profile',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const HomePage(initialIndex: 2),
        ),
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.error.toString()),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
