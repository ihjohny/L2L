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
│   │   │   │   └── generate-course-quiz.queue.ts
│   │   │   └── workers/
│   │   │       ├── process-link.worker.ts
│   │   │       └── generate-course-quiz.worker.ts
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

**Instruction:** Configure ESLint with TypeScript parser and Prettier integration.

**Key rules:**
- `@typescript-eslint/no-unused-vars`: allow args starting with `_`
- `@typescript-eslint/no-explicit-any`: warn only
- Prettier: semicolons, single quotes, 100 char width, 2-space tabs

#### BullMQ Queue Config

**Instruction:** Configure Redis connection and BullMQ queue/worker options.

**Pattern:**
```typescript
// src/config/redis.config.ts
// redisConfig: host, port, password, maxRetriesPerRequest: null
// queueOptions: attempts: 3, exponential backoff (2s delay), removeOnComplete: 100
// workerOptions: concurrency: 5
// Queue names: l2l:process_link, l2l:generate_course_quiz, l2l:notify_user, l2l:failed_jobs
```

#### Error Class Hierarchy → HTTP Status Mapping

**Instruction:** Create custom error class hierarchy extending from `AppError` base class. Each error type maps to specific HTTP status code.

**Pattern:**
```typescript
// src/utils/error.ts
// AppError base class: statusCode, code, message, isOperational
// Concrete errors: ValidationError (400), AuthenticationError (401),
// AuthorizationError (403), NotFoundError (404), ConflictError (409),
// AIProcessingError (500), RateLimitError (429)
// ERROR_STATUS_MAP for filter mapping
```

#### Logging Conventions (pino)

**Instruction:** Configure Pino logger with request tracing via UUID, ISO timestamps, and structured context.

**Pattern:**
```typescript
// src/utils/logger.ts
// createLogger(context): adds requestId, userId, jobId, duration to logs
// Auto-generates UUID if requestId not provided
// Usage: logger.info({ duration }, 'message')
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
│   │   │       │   ├── create_project_screen.dart
│   │   │       │   └── course_detail_screen.dart
│   │   │       └── widgets/
│   │   │           ├── project_card.dart
│   │   │           ├── generate_course_button.dart
│   │   │           ├── course_section.dart
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

**Instruction:** Use Riverpod StateNotifier pattern for state management. Each feature gets a provider with state class, notifier, and provider declaration.

**Auth Provider Pattern:**
```dart
// lib/providers/auth_provider.dart
// AuthState: status (enum), user?, error?
// AuthNotifier: login(), logout()
// State transitions: initial → loading → authenticated/unauthenticated
```

**Link Provider Pattern:**
```dart
// lib/providers/link_provider.dart
// LinkState: links[], isLoading, error?, nextCursor?
// LinkNotifier: fetchLinks({projectId, cursor}), saveLink()
// Supports pagination and optimistic updates
```

**Job Polling Pattern:**
```dart
// lib/providers/job_polling_provider.dart
// Poll every 2 seconds, cancel on completed/failed
// Show notification on job completion
```

#### GoRouter Configuration

**Instruction:** Configure GoRouter with auth redirect logic, ShellRoute for main scaffold, and nested routes for projects/links.

**Pattern:**
```dart
// lib/routing/app_router.dart
// redirect: check auth status, redirect unauthenticated to /login
// Routes: /login, /register, /projects, /projects/:id, /projects/:id/links/:linkId
// Deep links: /shared/project/:id
// Usage: context.go('/projects')
```

#### Dio Client Configuration

**Instruction:** Create Dio HTTP client with auth interceptor, token refresh logic, and error mapping.

**Pattern:**
```dart
// lib/core/network/dio_client.dart
// DioClient: baseUrl, 30s timeout, auth + log interceptors
// AuthInterceptor: adds Bearer token, handles 401 with refresh
// Token refresh: grabs refresh token, calls /auth/refresh, retries original request
// Error classes: UnauthorizedException, ValidationException, ServerException
```

#### Share Intent Setup

**iOS Share Extension** (`ios/ShareExtension/ShareViewController.swift`):
```swift
// Load shared URL from extension context
// Store URL in App Group container (group.com.l2l.app)
// Open main app using openURL selector
```

**Android Intent Filter** (`android/app/src/main/AndroidManifest.xml`):
```xml
<!-- Add intent-filter for SEND action with text/plain mimeType -->
```

**Flutter Share Handler**:
```dart
// lib/share_extension/share_handler.dart
// Use receive_sharing_intent plugin
// Handle initial media (app running) and media stream (app terminated)
// Extract URL from SharedMediaFile, call linkNotifier.saveLink()
```

#### Course Detail Screen Implementation

**Instruction:** Interactive course viewer with lesson navigation, progress tracking, and reading time estimation.

**State Management:**
```dart
// lib/features/course/detail/data/course_detail_state.dart
// CourseDetailState: course, currentLessonIndex, estimatedReadingMinutes
// Computed: currentLesson, hasPreviousLesson, hasNextLesson, progress (0.0-1.0)
// formattedReadingTime: "X min read"
```

**UI Components:**
- **Progress Stepper**: Combined component with horizontal track line, progress fill, and interactive dots
  - Current lesson: Larger (32px), primary color
  - Completed lessons: Checkmark icon
  - Future lessons: Smaller (24px), neutral color
  - Tap any dot to jump directly to that lesson
- **Reading Time Badge**: Calculated from content length (~200 words/minute, clamped 1-60 min)
- **Navigation Controls**: Previous/Next buttons at bottom, disabled at boundaries
- **Direct Quiz Access**: Quiz button in AppBar for direct navigation

**Navigation Pattern:**
```dart
// Route: /projects/:projectId/course?lesson=2
// Pass projectName parameter for consistent toolbar title
// Support jump-to-lesson via query parameter and stepper taps
```

#### Quiz Screen Implementation

**Instruction:** Interactive quiz system with timer, progress tracking, and comprehensive result view.

**State Management:**
```dart
// lib/features/quiz/data/quiz_questions_state.dart
// QuizQuestionsState: quiz, currentQuestionIndex, selectedOptionIndex
// selectedAnswers[], viewState (questions/result), result?
// Timer: elapsedTime, isTimerRunning
// Computed: currentQuestion, hasPreviousQuestion, hasNextQuestion, progress
// formattedElapsedTime: "MM:SS", isCurrentQuestionAnswered, areAllQuestionsAnswered
```

**UI Components:**
- **Timer Display**: Live timer in AppBar (MM:SS format), auto-starts on load, stops on submit
- **Progress Stepper**: Matches course page design with question-specific states
  - Current question: Larger (32px), primary color
  - Answered questions: Checkmark icon
  - Unanswered questions: Question number
- **Question Cards**: Numbered label, question text, multiple choice options (A, B, C, D...)
- **Navigation Controls**: Previous/Next buttons, "Submit" on last question
- **Result View**: Trophy icon, score percentage, breakdown card (correct count, time taken)
- **Action Buttons**: Review Answers (returns to questions), Retry Quiz (resets)

**Timer Management:**
```dart
// Timer.periodic with 1-second intervals
// Lifecycle: Start on load, stop on submit, reset on retry, dispose on exit
// Stored in state, updates every second
```

**Route Pattern:**
```dart
// Route: /projects/:projectId/quiz
// Pass quiz and projectName via extra parameter to avoid redundant API call
// Integration: Both project details and course details can navigate to quiz
```

---

#### Offline Strategy (Hive)

**Instruction:** Use Hive for local caching of links and projects. Cache content with timestamp, check staleness after 1 hour.

**Pattern:**
```dart
// lib/core/storage/local_cache.dart
// LocalCache: init(), cacheLink(link), getCachedLink(id), getCachedLinks(projectId), isStale(key)
// Links box, projects box
// Staleness threshold: 1 hour
```

> ⚠️ **ASSUMPTIONS:**
> - Riverpod for state management (preferred over Provider/Bloc for this use case)
> - go_router for navigation (modern, declarative routing)
> - Hive for offline caching (lightweight, Flutter-native)
> - iOS share extension requires App Group configuration
> - Combined progress stepper design for consistency across course and quiz screens
>
> 🚩 **RISKS & OPEN DECISIONS:**
> - **Risk:** Share extension complexity on iOS → **Mitigation:** Test early, use receive_sharing_intent plugin
> - **Risk:** Offline sync conflicts → **Open:** Decide on conflict resolution strategy (last-write-wins vs. manual)
> - **Risk:** Timer management complexity → **Mitigation:** Proper cleanup in dispose, state-based timer control
> - **Decision:** Folder structure by feature → **Confirmed:** Enables team scaling, clear ownership
> - **Decision:** Combined progress component → **Confirmed:** Cleaner UI, better UX, visual consistency

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

**Instruction:** Implement service worker with context menu, message handling, and token refresh alarm.

**Pattern:**
```typescript
// background/index.ts
// OnInstalled: create context menu for link/page save
// onContextMenuClicked: save URL, show notification, handle auth errors
// onMessage: handle SAVE_LINK and GET_CURRENT_PAGE messages
// Alarms: refresh token every 10 minutes
```

#### Popup UI

**Instruction:** Create React popup with form for URL, title, project selection, and tags.

**Pattern:**
```typescript
// popup/index.tsx
// App component: url, title, projects[], selectedProject, tags state
// useEffect: load current page info via GET_CURRENT_PAGE message, fetch projects
// handleSave: send SAVE_LINK message with payload
// UI: form groups for each field, error display, loading state
```

#### Message Protocol (Type-Safe Schema)

**Instruction:** Define type-safe message protocol for extension communication.

**Pattern:**
```typescript
// shared/protocol.ts
// Message types: SAVE_LINK, GET_CURRENT_PAGE, TOKEN_UPDATE
// SaveLinkMessage: { url, title, projectId?, tags? }
// sendMessage<T, R>: type-safe wrapper for chrome.runtime.sendMessage
```

#### Auth: JWT Storage & Refresh Flow

**Instruction:** Implement token storage in chrome.storage.local and auto-refresh logic.

**Pattern:**
```typescript
// shared/storage.ts
// TokenStorage: getTokens(), saveTokens(), clearTokens(), isTokenExpired()
// Tokens interface: accessToken, refreshToken, expiresAt
```

```typescript
// shared/api.ts
// ApiClient: request() with auth header, refreshTokenIfNeeded()
// Refresh threshold: 5 minutes before expiry
// saveLink(payload): POST /links
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
