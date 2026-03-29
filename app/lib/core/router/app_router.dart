import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/main_container/main_container_page.dart';
import '../../presentation/pages/links/link_details_page.dart';
import '../../presentation/pages/links/add_link_page.dart';
import '../../presentation/pages/links/links_list_page.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/pages/projects/project_detail_page.dart';
import '../../presentation/pages/projects/create_project_page.dart';
import '../../providers/auth_providers.dart';

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
          child: const MainContainerPage(initialIndex: 0),
        ),
      ),

      // Links Routes (Protected)
      GoRoute(
        path: '/links',
        name: 'links',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LinksListPage(),
        ),
      ),

      // Link Details Route (Protected)
      GoRoute(
        path: '/links/:linkId',
        name: 'link_details',
        pageBuilder: (context, state) {
          final linkId = state.pathParameters['linkId'] ?? '';
          return MaterialPage(
            key: state.pageKey,
            child: LinkDetailsPage(linkId: linkId),
          );
        },
      ),

      // Add Link Route (Protected)
      GoRoute(
        path: '/add-link',
        name: 'add_link',
        pageBuilder: (context, state) => const MaterialPage(
          key: ValueKey('add_link'),
          child: AddLinkPage(),
        ),
      ),

      // Profile Routes (Protected)
      GoRoute(
        path: '/profile',
        name: 'profile',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const MainContainerPage(initialIndex: 2),
        ),
      ),

      // Projects Routes (Protected)
      GoRoute(
        path: '/projects',
        name: 'projects',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const MainContainerPage(initialIndex: 1),
        ),
      ),
      GoRoute(
        path: '/projects/:projectId',
        name: 'project_detail',
        pageBuilder: (context, state) {
          final projectId = state.pathParameters['projectId'] ?? '';
          return MaterialPage(
            key: state.pageKey,
            child: ProjectDetailPage(projectId: projectId),
          );
        },
      ),
      GoRoute(
        path: '/create-project',
        name: 'create_project',
        pageBuilder: (context, state) => const MaterialPage(
          key: ValueKey('create_project'),
          child: CreateProjectPage(),
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
