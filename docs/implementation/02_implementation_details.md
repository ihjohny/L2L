# L2L (Link to Learn) - Section 2: Implementation Details

**Version:** 1.0
**Date:** March 2026

---

## Section 2: Implementation Details

### Section Purpose
This section provides detailed implementation specifications for the backend monolith, Flutter application, and Chrome extension, including file structures, configuration, and code patterns.

---

### 2a. Backend (Node.js Monolith)

#### Module Boundaries

| Module | Responsibility | Key Files | Phase |
|--------|----------------|-----------|-------|
| **Auth** | User registration, login, JWT, password reset | `auth.controller.ts`, `auth.service.ts`, `jwt.strategy.ts` | MVP |
| **Link** | Link CRUD, URL validation, metadata | `link.controller.ts`, `link.service.ts`, `link.schema.ts` | MVP |
| **Project** | Project CRUD, link aggregation | `project.controller.ts`, `project.service.ts` | MVP |
| **AI** | Content extraction, OpenAI integration | `ai.service.ts`, `scraper.service.ts`, `prompts/` | MVP |
| **Job** | BullMQ queues, workers, DLQ | `job.service.ts`, `workers/`, `queues/` | MVP |
| **Analytics** | Events, dashboards, heatmaps | `analytics.service.ts`, `analytics.controller.ts` | P2 |
| **Subscription** | Stripe integration, plans | `subscription.service.ts`, `stripe.webhook.ts` | P2 |
| **RAG** | Vector search, chatbot | `rag.service.ts`, `vector.store.ts` | P3 |

#### File Tree

```
backend/
├── src/
│   ├── main.ts                          # Application entry point
│   ├── app.module.ts                    # Root module
│   ├── app.middleware.ts                # Global middleware (logging, CORS)
│   │
│   ├── common/
│   │   ├── decorators/
│   │   │   ├── auth.decorator.ts
│   │   │   └── roles.decorator.ts
│   │   ├── guards/
│   │   │   ├── jwt-auth.guard.ts
│   │   │   └── roles.guard.ts
│   │   ├── interceptors/
│   │   │   ├── response.interceptor.ts
│   │   │   └── error.interceptor.ts
│   │   └── filters/
│   │       └── http-error.filter.ts
│   │
│   ├── config/
│   │   ├── database.config.ts
│   │   ├── redis.config.ts
│   │   ├── jwt.config.ts
│   │   └── openai.config.ts
│   │
│   ├── modules/
│   │   ├── auth/
│   │   │   ├── auth.controller.ts
│   │   │   ├── auth.service.ts
│   │   │   ├── auth.module.ts
│   │   │   ├── dto/
│   │   │   │   ├── register.dto.ts
│   │   │   │   ├── login.dto.ts
│   │   │   │   └── refresh-token.dto.ts
│   │   │   └── strategies/
│   │   │       └── jwt.strategy.ts
│   │   │
│   │   ├── link/
│   │   │   ├── link.controller.ts
│   │   │   ├── link.service.ts
│   │   │   ├── link.module.ts
│   │   │   ├── link.schema.ts
│   │   │   └── dto/
│   │   │       ├── create-link.dto.ts
│   │   │       └── update-link.dto.ts
│   │   │
│   │   ├── project/
│   │   │   ├── project.controller.ts
│   │   │   ├── project.service.ts
│   │   │   ├── project.module.ts
│   │   │   ├── project.schema.ts
│   │   │   └── dto/
│   │   │       ├── create-project.dto.ts
│   │   │       └── update-project.dto.ts
│   │   │
│   │   ├── ai/
│   │   │   ├── ai.service.ts
│   │   │   ├── ai.module.ts
│   │   │   ├── scraper.service.ts
│   │   │   ├── prompts/
│   │   │   │   ├── summary.prompt.ts
│   │   │   │   ├── flashcard.prompt.ts
│   │   │   │   ├── course.prompt.ts
│   │   │   │   └── quiz.prompt.ts
│   │   │   └── validators/
│   │   │       ├── summary.validator.ts
│   │   │       └── flashcard.validator.ts
│   │   │
│   │   ├── job/
│   │   │   ├── job.controller.ts
│   │   │   ├── job.service.ts
│   │   │   ├── job.module.ts
│   │   │   ├── job.schema.ts
│   │   │   ├── queues/
│   │   │   │   ├── process-link.queue.ts
│   │   │   │   └── generate-course.queue.ts
│   │   │   └── workers/
│   │   │       ├── process-link.worker.ts
│   │   │       └── generate-course.worker.ts
│   │   │
│   │   ├── analytics/                     [P2]
│   │   │   ├── analytics.controller.ts
│   │   │   ├── analytics.service.ts
│   │   │   ├── analytics.module.ts
│   │   │   └── analytics.schema.ts
│   │   │
│   │   ├── subscription/                  [P2]
│   │   │   ├── subscription.controller.ts
│   │   │   ├── subscription.service.ts
│   │   │   ├── subscription.module.ts
│   │   │   ├── subscription.schema.ts
│   │   │   └── stripe.webhook.ts
│   │   │
│   │   └── chat/                          [P3]
│   │       ├── chat.controller.ts
│   │       ├── chat.service.ts
│   │       ├── chat.module.ts
│   │       └── rag.service.ts
│   │
│   └── utils/
│       ├── logger.ts                      # Pino logger
│       ├── error.ts                       # Error class hierarchy
│       └── validation.ts                  # Zod schemas
│
├── tests/
│   ├── unit/
│   ├── integration/
│   └── e2e/
│
├── migrations/
│   ├── 001_initial_schema.ts
│   └── ...
│
├── .eslintrc.js
├── .prettierrc
├── jest.config.js
├── tsconfig.json
├── package.json
└── Dockerfile
```

#### ESLint + Prettier Config

```javascript
// .eslintrc.js
module.exports = {
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: 'tsconfig.json',
    tsconfigRootDir: __dirname,
    sourceType: 'module',
  },
  plugins: ['@typescript-eslint', 'prettier'],
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:@typescript-eslint/recommended-requiring-type-checking',
    'prettier',
  ],
  root: true,
  env: {
    node: true,
    jest: true,
  },
  ignorePatterns: ['.eslintrc.js', 'dist', 'coverage'],
  rules: {
    '@typescript-eslint/interface-name-prefix': 'off',
    '@typescript-eslint/explicit-function-return-type': 'off',
    '@typescript-eslint/explicit-module-boundary-types': 'off',
    '@typescript-eslint/no-explicit-any': 'warn',
    '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
    'prettier/prettier': 'error',
  },
};
```

```javascript
// .prettierrc
module.exports = {
  semi: true,
  trailingComma: 'all',
  singleQuote: true,
  printWidth: 100,
  tabWidth: 2,
  useTabs: false,
  arrowParens: 'avoid',
};
```

#### BullMQ Queue Config

```typescript
// src/config/redis.config.ts
import { QueueOptions, WorkerOptions } from 'bullmq';

export const redisConfig = {
  host: process.env.REDIS_HOST || 'localhost',
  port: parseInt(process.env.REDIS_PORT || '6379'),
  password: process.env.REDIS_PASSWORD,
  maxRetriesPerRequest: null, // Required for BullMQ
};

export const queueOptions: QueueOptions = {
  connection: redisConfig,
  defaultJobOptions: {
    attempts: 3,
    removeOnComplete: 100,
    removeOnFail: 1000,
    backoff: {
      type: 'exponential',
      delay: 2000,
    },
  },
};

export const workerOptions: WorkerOptions = {
  connection: redisConfig,
  concurrency: 5,
};

// Queue names (use FF_ prefix for feature flags)
export const QUEUES = {
  PROCESS_LINK: 'l2l:process_link',
  GENERATE_COURSE: 'l2l:generate_course',
  NOTIFY_USER: 'l2l:notify_user',
  DLQ: 'l2l:failed_jobs',
} as const;
```

#### Error Class Hierarchy → HTTP Status Mapping

```typescript
// src/utils/error.ts
import { HttpStatus } from '@nestjs/common';

export abstract class AppError extends Error {
  constructor(
    public readonly statusCode: HttpStatus,
    public readonly code: string,
    message: string,
    public readonly isOperational: boolean = true,
  ) {
    super(message);
    Object.setPrototypeOf(this, new.target.prototype);
    Error.captureStackTrace(this);
  }
}

export class ValidationError extends AppError {
  constructor(message: string, public readonly details?: any) {
    super(HttpStatus.BAD_REQUEST, 'VALIDATION_ERROR', message);
  }
}

export class AuthenticationError extends AppError {
  constructor(message: string = 'Authentication required') {
    super(HttpStatus.UNAUTHORIZED, 'AUTH_ERROR', message);
  }
}

export class AuthorizationError extends AppError {
  constructor(message: string = 'Access denied') {
    super(HttpStatus.FORBIDDEN, 'FORBIDDEN', message);
  }
}

export class NotFoundError extends AppError {
  constructor(resource: string) {
    super(HttpStatus.NOT_FOUND, 'NOT_FOUND', `${resource} not found`);
  }
}

export class ConflictError extends AppError {
  constructor(message: string) {
    super(HttpStatus.CONFLICT, 'CONFLICT', message);
  }
}

export class AIProcessingError extends AppError {
  constructor(message: string) {
    super(HttpStatus.INTERNAL_SERVER_ERROR, 'AI_ERROR', message);
  }
}

export class RateLimitError extends AppError {
  constructor(message: string = 'Rate limit exceeded') {
    super(HttpStatus.TOO_MANY_REQUESTS, 'RATE_LIMIT', message);
  }
}

// HTTP Error Filter mapping
export const ERROR_STATUS_MAP: Record<string, HttpStatus> = {
  ValidationError: HttpStatus.BAD_REQUEST,
  AuthenticationError: HttpStatus.UNAUTHORIZED,
  AuthorizationError: HttpStatus.FORBIDDEN,
  NotFoundError: HttpStatus.NOT_FOUND,
  ConflictError: HttpStatus.CONFLICT,
  AIProcessingError: HttpStatus.INTERNAL_SERVER_ERROR,
  RateLimitError: HttpStatus.TOO_MANY_REQUESTS,
};
```

#### Logging Conventions (pino)

```typescript
// src/utils/logger.ts
import pino from 'pino';
import { v4 as uuidv4 } from 'uuid';

const baseLogger = pino({
  level: process.env.LOG_LEVEL || 'info',
  formatters: {
    level: (label) => ({ level: label }),
  },
  timestamp: pino.stdTimeFunctions.isoTime,
});

export interface LogContext {
  requestId: string;
  userId?: string;
  jobId?: string;
  duration?: number;
  error?: Error;
  [key: string]: any;
}

export function createLogger(context: Partial<LogContext> = {}) {
  return baseLogger.child({
    requestId: context.requestId || uuidv4(),
    userId: context.userId,
    jobId: context.jobId,
    duration: context.duration,
    ...context,
  });
}

// Usage example:
// const logger = createLogger({ requestId, userId: user.id });
// logger.info({ duration: Date.now() - start }, 'Request completed');
```

> ⚠️ **ASSUMPTIONS:**
> - Using NestJS-style module structure for better organization (can adapt to Express-only if needed)
> - TypeScript for all backend code (type safety, better DX)
> - UUID for request tracing across services
>
> 🚩 **RISKS & OPEN DECISIONS:**
> - **Risk:** Over-engineering with NestJS patterns → **Mitigation:** Keep modules focused, avoid unnecessary abstraction
> - **Decision:** Error handling pattern → **Open:** Evaluate if custom error classes add value vs. simple HTTP errors

---

### 2b. Flutter Application

#### File Tree

```
mobile_app/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── app.dart                           # MaterialApp configuration
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_strings.dart
│   │   │   └── api_constants.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── app_typography.dart
│   │   ├── network/
│   │   │   ├── dio_client.dart
│   │   │   ├── api_interceptor.dart
│   │   │   └── network_error.dart
│   │   ├── storage/
│   │   │   ├── secure_storage.dart
│   │   │   └── local_cache.dart
│   │   └── utils/
│   │       ├── date_formatter.dart
│   │       └── validators.dart
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── auth_repository.dart
│   │   │   │   └── auth_api_service.dart
│   │   │   ├── domain/
│   │   │   │   ├── user_model.dart
│   │   │   │   └── auth_state.dart
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   ├── login_screen.dart
│   │   │       │   ├── register_screen.dart
│   │   │       │   └── forgot_password_screen.dart
│   │   │       └── widgets/
│   │   │           ├── login_form.dart
│   │   │           └── register_form.dart
│   │   │
│   │   ├── projects/
│   │   │   ├── data/
│   │   │   │   ├── project_repository.dart
│   │   │   │   └── project_api_service.dart
│   │   │   ├── domain/
│   │   │   │   ├── project_model.dart
│   │   │   │   └── project_state.dart
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   ├── projects_list_screen.dart
│   │   │       │   ├── project_detail_screen.dart
│   │   │       │   └── create_project_screen.dart
│   │   │       └── widgets/
│   │   │           ├── project_card.dart
│   │   │           ├── generate_course_button.dart
│   │   │           └── course_viewer.dart
│   │   │
│   │   ├── links/
│   │   │   ├── data/
│   │   │   │   ├── link_repository.dart
│   │   │   │   └── link_api_service.dart
│   │   │   ├── domain/
│   │   │   │   ├── link_model.dart
│   │   │   │   └── link_state.dart
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   ├── links_list_screen.dart
│   │   │       │   ├── link_detail_screen.dart
│   │   │       │   └── manual_input_screen.dart
│   │   │       └── widgets/
│   │   │           ├── link_card.dart
│   │   │           ├── summary_view.dart
│   │   │           ├── flashcard_carousel.dart
│   │   │           └── processing_status.dart
│   │   │
│   │   ├── quiz/
│   │   │   ├── data/
│   │   │   │   └── quiz_repository.dart
│   │   │   ├── domain/
│   │   │   │   └── quiz_model.dart
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   └── quiz_screen.dart
│   │   │       └── widgets/
│   │   │           ├── question_card.dart
│   │   │           └── quiz_result.dart
│   │   │
│   │   ├── dashboard/                     [P2]
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           ├── dashboard_screen.dart
│   │   │           └── heatmap_widget.dart
│   │   │
│   │   └── profile/
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   │           └── screens/
│   │               └── profile_screen.dart
│   │
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── project_provider.dart
│   │   ├── link_provider.dart
│   │   └── job_polling_provider.dart
│   │
│   ├── routing/
│   │   ├── app_router.dart
│   │   ├── route_names.dart
│   │   └── auth_guard.dart
│   │
│   └── share_extension/
│       └── share_handler.dart
│
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
│
├── android/
│   └── app/src/main/AndroidManifest.xml   # Intent filter for share
│
├── ios/
│   ├── ShareExtension/
│   │   ├── ShareViewController.swift
│   │   └── Info.plist
│   └── Runner/
│
├── pubspec.yaml
└── analysis_options.yaml
```

#### Riverpod Provider Patterns

```dart
// lib/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  AuthState({this.status = AuthStatus.initial, this.user, this.error});

  AuthState copyWith({AuthStatus? status, User? user, String? error}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _repository.login(email, password);
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

// Usage in widget:
// final authState = ref.watch(authProvider);
// ref.read(authProvider.notifier).login(email, password);
```

```dart
// lib/providers/link_provider.dart
class LinkState {
  final List<Link> links;
  final bool isLoading;
  final String? error;
  final String? nextCursor;

  LinkState({this.links = const [], this.isLoading = false, this.error, this.nextCursor});

  LinkState copyWith({List<Link>? links, bool? isLoading, String? error, String? nextCursor}) {
    return LinkState(
      links: links ?? this.links,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      nextCursor: nextCursor ?? this.nextCursor,
    );
  }
}

class LinkNotifier extends StateNotifier<LinkState> {
  final LinkRepository _repository;

  LinkNotifier(this._repository) : super(LinkState());

  Future<void> fetchLinks({String? projectId, String? cursor}) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);
    try {
      final result = await _repository.getLinks(projectId: projectId, cursor: cursor);
      state = state.copyWith(
        links: cursor != null ? [...state.links, ...result.links] : result.links,
        nextCursor: result.nextCursor,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> saveLink({required String url, String? projectId, List<String>? tags}) async {
    await _repository.createLink(url: url, projectId: projectId, tags: tags);
    // Optimistic update
    state = state.copyWith(
      links: [
        Link.temp(url: url, status: LinkStatus.pending),
        ...state.links,
      ],
    );
  }
}
```

```dart
// lib/providers/job_polling_provider.dart
class JobPollingNotifier extends StateNotifier<JobState> {
  JobPollingNotifier() : super(JobState());

  void startPolling(String jobId) {
    // Poll every 2 seconds
    Timer.periodic(Duration(seconds: 2), (timer) async {
      final job = await _repository.getJob(jobId);

      if (job.status == JobStatus.completed || job.status == JobStatus.failed) {
        timer.cancel();
        state = state.copyWith(job: job, status: job.status);

        // Show notification
        if (job.status == JobStatus.completed) {
          _showCompletionNotification(job);
        }
      } else {
        state = state.copyWith(job: job, status: job.status);
      }
    });
  }
}
```

#### GoRouter Configuration

```dart
// lib/routing/app_router.dart
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final authState = context.read(authProvider);
    final isAuthRoute = state.matchedLocation.startsWith('/login') ||
                        state.matchedLocation.startsWith('/register');

    if (authState.status != AuthStatus.authenticated && !isAuthRoute) {
      return '/login';
    }

    if (authState.status == AuthStatus.authenticated && isAuthRoute) {
      return '/projects';
    }

    return null;
  },
  routes: [
    // Auth routes
    GoRoute(path: '/login', builder: (_, __) => LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => RegisterScreen()),

    // Main app routes
    ShellRoute(
      builder: (_, __, child) => MainScaffold(child: child),
      routes: [
        GoRoute(path: '/projects', builder: (_, __) => ProjectsListScreen()),
        GoRoute(
          path: '/projects/:id',
          builder: (_, state) => ProjectDetailScreen(
            projectId: state.pathParameters['id']!,
          ),
          routes: [
            GoRoute(
              path: 'links/:linkId',
              builder: (_, state) => LinkDetailScreen(
                linkId: state.pathParameters['linkId']!,
              ),
            ),
          ],
        ),
      ],
    ),

    // Deep links
    GoRoute(
      path: '/shared/project/:id',
      builder: (_, state) => SharedProjectScreen(
        projectId: state.pathParameters['id']!,
      ),
    ),
  ],
);

// Usage: context.go('/projects'), context.go('/projects/${project.id}')
```

#### Dio Client Configuration

```dart
// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';

class DioClient {
  late final Dio _dio;
  final SecureStorage _storage;

  DioClient(this._storage) {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.addAll([
      AuthInterceptor(_storage),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  Dio get client => _dio;
}

class AuthInterceptor extends Interceptor {
  final SecureStorage _storage;
  bool _isRefreshing = false;

  AuthInterceptor(this._storage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final tokens = await _storage.getTokens();
    if (tokens != null) {
      options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final newTokens = await _refreshToken();
        // Retry original request with new token
        final response = await _dio.request(
          err.requestOptions.path,
          options: Options(
            method: err.requestOptions.method,
            headers: {'Authorization': 'Bearer ${newTokens.accessToken}'},
          ),
          data: err.requestOptions.data,
        );
        _isRefreshing = false;
        handler.resolve(response);
        return;
      } catch (e) {
        // Refresh failed, redirect to login
        _isRefreshing = false;
        // Trigger logout
      }
    }
    handler.next(err);
  }

  Future<Tokens> _refreshToken() async {
    final refreshToken = await _storage.getRefreshToken();
    final response = await _dio.post('/auth/refresh', data: {'refreshToken': refreshToken});
    final tokens = Tokens.fromMap(response.data);
    await _storage.saveTokens(tokens);
    return tokens;
  }
}

// Error mapping
sealed class AppNetworkException implements Exception {
  final String message;
  AppNetworkException(this.message);
}

class UnauthorizedException extends AppNetworkException {
  UnauthorizedException() : super('Session expired');
}

class ValidationException extends AppNetworkException {
  final Map<String, dynamic>? errors;
  ValidationException(this.errors, String message) : super(message);
}

class ServerException extends AppNetworkException {
  ServerException() : super('Server error, please try again');
}
```

#### Share Intent Setup

**iOS Share Extension** (`ios/ShareExtension/ShareViewController.swift`):
```swift
class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = item.attachments,
              let attachment = attachments.first else { return }

        if attachment.hasItemConformingToTypeIdentifier("public.url") {
            attachment.loadItem(forTypeIdentifier: "public.url", options: nil) { [weak self] url, _ in
                if let shareUrl = url as? URL {
                    self?.handleShareUrl(shareUrl)
                }
                self?.extensionContext?.completeRequest(returningItems: nil)
            }
        }
    }

    func handleShareUrl(_ url: URL) {
        // Store URL in App Group container
        let defaults = UserDefaults(suiteName: "group.com.l2l.app")
        defaults?.set(url.absoluteString, forKey: "shared_url")

        // Open main app
        let selector = sel_registerName("openURL:")
        let responder = self as UIResponder
        var responderChain = responder.next
        while responderChain != nil {
            if responderChain!.responds(to: selector) {
                responderChain!.perform(selector, with: url)
                return
            }
            responderChain = responderChain!.next
        }
    }
}
```

**Android Intent Filter** (`android/app/src/main/AndroidManifest.xml`):
```xml
<activity android:name=".MainActivity">
    <intent-filter>
        <action android:name="android.intent.action.SEND" />
        <category android:name="android.intent.category.DEFAULT" />
        <data android:mimeType="text/plain" />
    </intent-filter>
</activity>
```

```dart
// lib/share_extension/share_handler.dart
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ShareHandler {
  final LinkNotifier _linkNotifier;

  void init() {
    // Handle when app is running
    ReceiveSharingIntent.getInitialMedia().then(_handleSharedMedia);

    // Handle when app is terminated
    ReceiveSharingIntent.getMediaStream().listen(_handleSharedMedia);
  }

  void _handleSharedMedia(List<SharedMediaFile> media) {
    if (media.isNotEmpty && media.first.type == SharedMediaType.TEXT) {
      final url = media.first.path;
      if (Uri.tryParse(url) != null) {
        _linkNotifier.saveLink(url: url);
        // Navigate to links list
      }
    }
  }
}
```

#### Offline Strategy (Hive)

```dart
// lib/core/storage/local_cache.dart
import 'package:hive/hive.dart';

class LocalCache {
  static const String linksBox = 'links';
  static const String projectsBox = 'projects';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(LinkAdapter());
    Hive.registerAdapter(ProjectAdapter());

    await Hive.openBox(linksBox);
    await Hive.openBox(projectsBox);
  }

  // Cache link with AI output
  Future<void> cacheLink(Link link) async {
    final box = Hive.box(linksBox);
    await box.put(link.id, link);
  }

  // Get cached link
  Link? getCachedLink(String id) {
    final box = Hive.box(linksBox);
    return box.get(id) as Link?;
  }

  // Get all cached links for project
  List<Link> getCachedLinks(String? projectId) {
    final box = Hive.box(linksBox);
    return box.values
        .whereType<Link>()
        .where((l) => projectId == null || l.projectId == projectId)
        .toList();
  }

  // Check if content is stale (older than 1 hour)
  bool isStale(String key) {
    final box = Hive.box(linksBox);
    final lastUpdated = box.get('${key}_timestamp') as DateTime?;
    if (lastUpdated == null) return true;
    return DateTime.now().difference(lastUpdated).inHours > 1;
  }
}
```

> ⚠️ **ASSUMPTIONS:**
> - Riverpod for state management (preferred over Provider/Bloc for this use case)
> - go_router for navigation (modern, declarative routing)
> - Hive for offline caching (lightweight, Flutter-native)
> - iOS share extension requires App Group configuration
>
> 🚩 **RISKS & OPEN DECISIONS:**
> - **Risk:** Share extension complexity on iOS → **Mitigation:** Test early, use receive_sharing_intent plugin
> - **Risk:** Offline sync conflicts → **Open:** Decide on conflict resolution strategy (last-write-wins vs. manual)
> - **Decision:** Folder structure by feature → **Confirmed:** Enables team scaling, clear ownership

---

### 2c. Chrome Extension (Manifest V3)

#### manifest.json Template

```json
{
  "manifest_version": 3,
  "name": "L2L - Save to Link to Learn",
  "version": "1.0.0",
  "description": "One-click save links to your L2L learning projects",
  "icons": {
    "16": "icons/icon16.png",
    "48": "icons/icon48.png",
    "128": "icons/icon128.png"
  },
  "action": {
    "default_popup": "popup/index.html",
    "default_icon": {
      "16": "icons/icon16.png",
      "48": "icons/icon48.png",
      "128": "icons/icon128.png"
    },
    "default_title": "Save to L2L"
  },
  "background": {
    "service_worker": "background/index.js",
    "type": "module"
  },
  "content_scripts": [
    {
      "matches": ["<all_urls>"],
      "js": ["content/index.js"],
      "run_at": "document_idle"
    }
  ],
  "permissions": [
    "storage",
    "tabs",
    "contextMenus",
    "alarms"
  ],
  "host_permissions": [
    "https://api.l2l.app/*"
  ],
  "web_accessible_resources": [
    {
      "resources": ["icons/*"],
      "matches": ["<all_urls>"]
    }
  ],
  "content_security_policy": {
    "extension_pages": "script-src 'self'; object-src 'self'"
  }
}
```

#### Background Service Worker

```typescript
// background/index.ts
import { ApiClient } from '../shared/api';
import { TokenStorage } from '../shared/storage';

const api = new ApiClient();
const storage = new TokenStorage();

// Context menu for right-click save
chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({
    id: 'saveToL2L',
    title: 'Save to L2L',
    contexts: ['link', 'page'],
  });
});

chrome.contextMenus.onClicked.addListener(async (info, tab) => {
  if (info.menuItemId === 'saveToL2L') {
    const url = info.linkUrl || info.pageUrl;
    const title = tab?.title || 'Saved Page';

    try {
      await api.saveLink({ url, title, source: 'extension_context' });
      showNotification('Link saved to L2L!');
    } catch (error) {
      if (isAuthError(error)) {
        await handleAuthError();
      }
    }
  }
});

// Message handler from popup
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.type === 'SAVE_LINK') {
    api.saveLink(message.payload)
      .then(sendResponse)
      .catch(sendResponse);
    return true; // Keep channel open for async response
  }

  if (message.type === 'GET_CURRENT_PAGE') {
    chrome.tabs.query({ active: true, currentWindow: true }, ([tab]) => {
      sendResponse({ url: tab.url, title: tab.title });
    });
    return true;
  }
});

// Token refresh alarm
chrome.alarms.create('refreshToken', { periodInMinutes: 10 });
chrome.alarms.onAlarm.addListener(async (alarm) => {
  if (alarm.name === 'refreshToken') {
    await api.refreshTokenIfNeeded();
  }
});

function showNotification(message: string) {
  chrome.notifications.create({
    type: 'basic',
    iconUrl: 'icons/icon48.png',
    title: 'L2L',
    message,
  });
}
```

#### Popup UI

```typescript
// popup/index.tsx
import React, { useState, useEffect } from 'react';
import ReactDOM from 'react-dom/client';

function App() {
  const [url, setUrl] = useState('');
  const [title, setTitle] = useState('');
  const [projects, setProjects] = useState([]);
  const [selectedProject, setSelectedProject] = useState('');
  const [tags, setTags] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    // Get current page info
    chrome.runtime.sendMessage({ type: 'GET_CURRENT_PAGE' }, (response) => {
      setUrl(response.url);
      setTitle(response.title);
    });

    // Fetch user projects
    loadProjects();
  }, []);

  const handleSave = async () => {
    setIsLoading(true);
    setError('');

    try {
      const result = await chrome.runtime.sendMessage({
        type: 'SAVE_LINK',
        payload: {
          url,
          title,
          projectId: selectedProject || undefined,
          tags: tags.split(',').map(t => t.trim()).filter(Boolean),
        },
      });

      if (result.success) {
        window.close(); // Close popup
      }
    } catch (err) {
      setError(err.message || 'Failed to save link');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="popup-container">
      <header>
        <img src="/icons/icon48.png" alt="L2L" />
        <h1>Save to L2L</h1>
      </header>

      <form onSubmit={handleSave}>
        <div className="form-group">
          <label>URL</label>
          <input
            type="url"
            value={url}
            onChange={(e) => setUrl(e.target.value)}
            required
          />
        </div>

        <div className="form-group">
          <label>Title</label>
          <input
            type="text"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
          />
        </div>

        <div className="form-group">
          <label>Project (optional)</label>
          <select
            value={selectedProject}
            onChange={(e) => setSelectedProject(e.target.value)}
          >
            <option value="">No project</option>
            {projects.map(p => (
              <option key={p.id} value={p.id}>{p.name}</option>
            ))}
          </select>
        </div>

        <div className="form-group">
          <label>Tags (comma-separated)</label>
          <input
            type="text"
            value={tags}
            onChange={(e) => setTags(e.target.value)}
            placeholder="react, tutorial, frontend"
          />
        </div>

        {error && <div className="error">{error}</div>}

        <button type="submit" disabled={isLoading}>
          {isLoading ? 'Saving...' : 'Save Link'}
        </button>
      </form>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
```

#### Message Protocol (Type-Safe Schema)

```typescript
// shared/protocol.ts
export interface SaveLinkMessage {
  type: 'SAVE_LINK';
  payload: {
    url: string;
    title: string;
    projectId?: string;
    tags?: string[];
  };
}

export interface GetCurrentPageMessage {
  type: 'GET_CURRENT_PAGE';
}

export interface TokenUpdateMessage {
  type: 'TOKEN_UPDATE';
  payload: {
    accessToken: string;
    expiresAt: number;
  };
}

export type ExtensionMessage =
  | SaveLinkMessage
  | GetCurrentPageMessage
  | TokenUpdateMessage;

export interface SaveLinkResponse {
  success: boolean;
  linkId?: string;
  jobId?: string;
  error?: string;
}

// Type-safe message sender
export function sendMessage<T extends ExtensionMessage, R>(
  message: T
): Promise<R> {
  return new Promise((resolve, reject) => {
    chrome.runtime.sendMessage(message, (response) => {
      if (response.error) {
        reject(new Error(response.error));
      } else {
        resolve(response as R);
      }
    });
  });
}
```

#### Auth: JWT Storage & Refresh Flow

```typescript
// shared/storage.ts
export interface Tokens {
  accessToken: string;
  refreshToken: string;
  expiresAt: number;
}

export class TokenStorage {
  private readonly STORAGE_KEY = 'l2l_tokens';

  async getTokens(): Promise<Tokens | null> {
    const result = await chrome.storage.local.get(this.STORAGE_KEY);
    return result[this.STORAGE_KEY] || null;
  }

  async saveTokens(tokens: Tokens): Promise<void> {
    await chrome.storage.local.set({ [this.STORAGE_KEY]: tokens });
  }

  async clearTokens(): Promise<void> {
    await chrome.storage.local.remove(this.STORAGE_KEY);
  }

  async isTokenExpired(): Promise<boolean> {
    const tokens = await this.getTokens();
    if (!tokens) return true;
    return Date.now() >= tokens.expiresAt;
  }
}
```

```typescript
// shared/api.ts
export class ApiClient {
  private baseUrl = 'https://api.l2l.app/api/v1';
  private storage = new TokenStorage();

  async request<T>(endpoint: string, options: RequestInit = {}): Promise<T> {
    const tokens = await this.storage.getTokens();

    const response = await fetch(`${this.baseUrl}${endpoint}`, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        ...(tokens && { Authorization: `Bearer ${tokens.accessToken}` }),
        ...options.headers,
      },
    });

    if (response.status === 401) {
      throw new AuthError('Token expired');
    }

    if (!response.ok) {
      throw new ApiError(await response.text());
    }

    return response.json();
  }

  async saveLink(payload: { url: string; title: string; projectId?: string; tags?: string[] }) {
    return this.request<{ linkId: string; jobId: }>('/links', {
      method: 'POST',
      body: JSON.stringify(payload),
    });
  }

  async refreshTokenIfNeeded(): Promise<void> {
    const tokens = await this.storage.getTokens();
    if (!tokens) return;

    // Refresh if expires within 5 minutes
    if (Date.now() >= tokens.expiresAt - 5 * 60 * 1000) {
      const response = await this.request<{ tokens: Tokens }>('/auth/refresh', {
        method: 'POST',
        body: JSON.stringify({ refreshToken: tokens.refreshToken }),
      });
      await this.storage.saveTokens(response.tokens);
    }
  }
}
```

#### Permissions Table

| Permission | Justification | Required For |
|------------|---------------|--------------|
| `storage` | Store JWT tokens locally | Auth persistence |
| `tabs` | Get current tab URL/title | Auto-fill save form |
| `contextMenus` | Right-click "Save to L2L" option | Quick save from any page |
| `alarms` | Periodic token refresh | Session maintenance |
| `notifications` | Show save confirmation | User feedback |
| `host_permissions: api.l2l.app` | API communication | All backend calls |

> ⚠️ **ASSUMPTIONS:**
> - React for popup UI (faster development, component reusability)
> - TypeScript for type-safe message passing
> - Manifest V3 service worker (no persistent background page)
>
> 🚩 **RISKS & OPEN DECISIONS:**
> - **Risk:** MV3 service worker limitations (no persistent connections) → **Mitigation:** Use alarms for periodic tasks
> - **Risk:** Chrome Web Store review delays → **Mitigation:** Submit early, follow guidelines strictly
> - **Decision:** Context menu save in addition to popup → **Confirmed:** Power users prefer right-click

---

---

*[← Architecture Overview](./01_architecture_overview.md)* | *[Back to Index](README.md)* | [Next: Database Schema →](./03_database_schema.md)*
