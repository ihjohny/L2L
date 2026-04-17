# L2L MVP Implementation Guide

**Version:** 3.0 | **Date:** April 2026 | **Status:** Authoritative

---

## Purpose

Unified implementation reference for L2L platform MVP (backend + Flutter + extension). Uses pseudocode patterns, not copy-paste code.

### Usage
1. Follow: Infrastructure → Backend → Flutter → Extension
2. Pattern-based: File structures + implementation approaches
3. Cross-referenced: All paths align with current codebase
4. Pseudocode-first: Annotated examples, not production code

---

## Table of Contents

1. [Architecture](#1-architecture)
2. [Project Structure](#2-project-structure)
3. [Database Schema](#3-database-schema)
4. [Backend Services](#4-backend-services)
5. [Flutter App](#5-flutter-app)
6. [Chrome Extension](#6-chrome-extension)
7. [API Reference](#7-api-reference)
8. [Deployment](#8-deployment)
9. [Verification](#9-verification)

---

## 1. Architecture

### 1.1 System Diagram

```
Flutter App (iOS/Android/Web)
  Riverpod | GoRouter | Dio
         ↓ REST API
Backend Services (Express + TS)
  user/ | project/ | links/ | ai/ | jobs/ (BullMQ)
         ↓
MongoDB | Redis (jobs/cache) | OpenAI
```

### 1.2 Tech Stack

| Component | Tech | Purpose |
|-----------|------|---------|
| Backend | Node.js 20 + TS + Express | API, business logic |
| Mobile | Flutter (Dart) | Cross-platform client |
| Extension | TS + Manifest V3 | Browser save |
| Database | MongoDB 7.0 + Mongoose | Primary data |
| Queue | Redis 7 + BullMQ | Async tasks |
| AI | OpenAI GPT-4o | Content generation |

### 1.3 AI Flow

```
Per-Link (auto): URL → extract → summary + flashcards → MongoDB
Per-Project (manual): summaries → synthesize → course + quiz → MongoDB
```

---

## 2. Project Structure

### 2.1 Root Layout

```
l2l/
├── services/              # Backend (Express + TS)
├── app/                   # Flutter app
├── extension/             # Chrome extension
├── docs/implementation/mvp/
├── docker-compose.{dev,prod}.yml
└── CLAUDE.md
```

### 2.2 Backend (`services/`)

```
src/
├── index.ts, server.ts, app.ts
├── config/                # Env config
├── database/              # MongoDB + schemas
├── middleware/            # Auth, validation
├── modules/
│   ├── user/              # Auth + user mgmt
│   ├── project/           # Project CRUD
│   ├── links/             # Link mgmt
│   ├── ai/                # AI orchestration
│   └── jobs/              # BullMQ workers
├── utils/                 # Logger, errors
└── tests/                 # Unit, integration, e2e
```

### 2.3 Flutter (`app/lib/`)

```
├── main.dart
├── core/
│   ├── app/               # Root widget
│   ├── config/            # Env, theme
│   ├── constants/
│   ├── network/           # Dio client
│   ├── storage/           # Secure tokens
│   ├── router/            # GoRouter
│   └── utils/             # Result, nav triggers
├── data/
│   ├── models/            # Freezed data classes
│   ├── repositories/      # Business logic
│   └── services/          # API clients
├── providers/             # Riverpod
└── presentation/
    ├── pages/             # Screens
    ├── viewmodels/        # StateNotifier
    └── widgets/           # Reusable UI
```

---

## 3. Database Schema

**Patterns:** MongoDB + Mongoose | Soft deletes (`deletedAt`) | Auto timestamps | ObjectId IDs

### 3.1 Users

**File:** `services/src/database/schemas/user.schema.ts`

```typescript
{
  _id: ObjectId
  email: string (unique, indexed, lowercase)
  passwordHash: string (bcrypt)
  name: string
  createdAt, updatedAt: Date
  deletedAt: Date | null
}
```

**Indexes:** `{email: 1}` (unique), `{deletedAt: 1}`

### 3.2 Projects

**File:** `services/src/database/schemas/project.schema.ts`

```typescript
{
  _id: ObjectId
  userId: ObjectId (FK to users)
  name: string
  description: string | null
  aiOutputId: ObjectId | null
  linkIds: ObjectId[]
  createdAt, updatedAt: Date
  deletedAt: Date | null
}
```

**Indexes:** `{userId: 1, createdAt: -1}`, `{deletedAt: 1}`

### 3.3 Links

**File:** `services/src/database/schemas/link.schema.ts`

```typescript
{
  _id: ObjectId
  userId: ObjectId
  projectId: ObjectId | null
  url: string
  title: string | null
  aiOutputId: ObjectId | null
  tags: string[]
  status: 'pending' | 'processing' | 'completed' | 'failed'
  statusMessage: string | null
  createdAt, updatedAt: Date
  deletedAt: Date | null
}
```

**Indexes:** `{userId: 1, createdAt: -1}`, `{userId: 1, projectId: 1, createdAt: -1}`, `{deletedAt: 1}`

### 3.4 AI Outputs

**File:** `services/src/database/schemas/aiOutput.schema.ts`

```typescript
{
  _id: ObjectId
  sourceType: 'link' | 'project'
  sourceId: ObjectId
  type: 'summary' | 'flashcards' | 'course' | 'quiz'
  content: object
  tokenUsage: {inputTokens, outputTokens, totalTokens}
  createdAt, updatedAt: Date
}
```

**Content by type:**
- `summary`: `{keyPoints[], mainArgument, takeaways[]}`
- `flashcards`: `{flashcards[{question, answer, difficulty}]}`
- `course`: `{title, description, lessons[{title, content, order}]}`
- `quiz`: `{questions[{question, options[], correct, explanation}]}`

**Indexes:** `{sourceType: 1, sourceId: 1, type: 1}`, `{createdAt: -1}`

### 3.5 Jobs

**File:** `services/src/database/schemas/job.schema.ts`

```typescript
{
  _id: ObjectId
  userId: ObjectId
  type: 'process_link' | 'generate_course'
  sourceType: 'link' | 'project'
  sourceId: ObjectId
  status: 'waiting' | 'active' | 'completed' | 'failed' | 'delayed'
  attempts, maxAttempts: number
  progress: 0-100
  data: Record<string, any>
  failedReason: string | null
  processedAt: Date | null
  createdAt, updatedAt: Date
}
```

**Indexes:** `{userId: 1, status: 1, createdAt: -1}`, `{status: 1, createdAt: 1}`, `{createdAt: 1}` (TTL: 7d)

---

## 4. Backend Services

### 4.1 Module Pattern

```
modules/<name>/
├── <name>.controller.ts    # HTTP handlers
├── <name>.service.ts       # Business logic
├── <name>.model.ts         # Mongoose model
├── <name>.routes.ts        # Express routes
└── dto/
    ├── create-<name>.dto.ts
    └── update-<name>.dto.ts
```

### 4.2 User Module (`services/src/modules/user/`)

**Endpoints:**
- `POST /api/v1/auth/register` - Create account
- `POST /api/v1/auth/login` - Authenticate, return JWT pair
- `POST /api/v1/auth/refresh` - Refresh access token
- `GET /api/v1/auth/me` - Get current user

**Service Patterns:**
```typescript
register(email, password, name) {
  // Validate input → check exists → hash password (bcrypt)
  // Create user → generate JWT pair → return user (no hash)
}

login(email, password) {
  // Find user → compare password (bcrypt)
  // If valid: generate JWT pair → return user + tokens
}

generateTokens(userId) {
  // Access token: short-lived (env default: 15m)
  // Refresh token: long-lived (env default: 7d)
  // Sign with JWT_SECRET → return {accessToken, refreshToken}
}
```

### 4.3 Project Module (`services/src/modules/project/`)

**Endpoints:**
- `GET /api/v1/projects` - List user projects
- `POST /api/v1/projects` - Create project
- `GET /api/v1/projects/:id` - Get project with links
- `PUT /api/v1/projects/:id` - Update
- `DELETE /api/v1/projects/:id` - Soft delete
- `POST /api/v1/projects/:id/generate-course-quiz` - Trigger AI generation
- `GET /api/v1/projects/:id/course` - Get latest course
- `GET /api/v1/projects/:id/quiz` - Get latest quiz

**Service Patterns:**
```typescript
createProject(userId, {name, description}) {
  // Validate → create doc with userId → return
}

getProjectWithLinks(projectId, userId) {
  // Find project → verify ownership → populate links with AI output → return
}

generateCourseQuiz(projectId, userId) {
  // Find project → validate completed links with summaries
  // Create job: generate_course → return jobId
}
```

### 4.4 Links Module (`services/src/modules/links/`)

**Endpoints:**
- `GET /api/v1/links` - List (paginated, filterable)
- `POST /api/v1/links` - Create + queue AI processing
- `GET /api/v1/links/:id` - Get with AI output
- `PUT /api/v1/links/:id` - Update
- `DELETE /api/v1/links/:id` - Soft delete
- `POST /api/v1/links/:id/retry` - Retry failed processing

**Service Patterns:**
```typescript
createLink(userId, {url, projectId, tags}) {
  // Validate URL → fetch metadata (optional)
  // Create doc (status: pending) → queue job: process_link
  // Return link + jobId
}

getLink(linkId, userId) {
  // Find link → verify ownership → populate AI output → return
}

retryLink(linkId, userId) {
  // Verify ownership + failed status
  // Reset: status=pending, statusMessage=null
  // Create new job → return link + jobId
}
```

### 4.5 AI Module (`services/src/modules/ai/`)

**Service Patterns:**
```typescript
processLink(url) {
  // Extract content (Playwright/Cheerio) → clean text
  // generateSummary(content) → generateFlashcards(content)
  // Store AI outputs → return {summary, flashcards}
}

generateSummary(content) {
  // OpenAI call → JSON response
  // Validate → return {keyPoints[], mainArgument, takeaways[]}
}

generateFlashcards(content) {
  // OpenAI call → 5-10 Q&A pairs
  // Validate → return [{question, answer, difficulty}]
}

generateCourse(summaries[], courseId) {
  // Combine summaries → OpenAI synthesis
  // Parse {title, description, lessons[]} → store course
  // generateQuiz(course, courseId) → return
}

generateQuiz(courseContent, courseId) {
  // OpenAI call → 5-15 multiple-choice questions
  // Store quiz with courseId ref → return [{question, options[], correct, explanation}]
}
```

**Prompt Strategy:** JSON output | exact structure | length limits | quality criteria

### 4.6 Jobs Module (`services/src/modules/jobs/`)

**Queue Config:**
```typescript
const QUEUE_NAMES = {
  PROCESS_LINK: 'l2l:process_link',
  GENERATE_COURSE: 'l2l:generate_course',
  FAILED_JOBS: 'l2l:failed_jobs'
};

const WORKER_CONFIG = {
  concurrency: env.WORKER_CONCURRENCY || 5,
  maxAttempts: env.MAX_JOB_ATTEMPTS || 3,
  backoffType: 'exponential',
  backoffDelay: env.BASE_BACKOFF_MS || 2000
};
```

**Worker Patterns:**
```typescript
processLinkJob(job) {
  // Update: job=active, link=processing
  // aiService.processLink(job.data.url)
  // Store AI outputs → update: link=completed, job=completed, progress=100
  // Emit notification
}

generateCourseJob(job) {
  // Update: job=active, progress=0
  // Fetch link summaries → aiService.generateCourse()
  // Store course (get courseId) → aiService.generateQuiz()
  // Store quiz with courseId → update project.aiOutputId
  // Update: job=completed, progress=100 → emit notification
}

handleJobFailed(job, error) {
  // If attempts < max: retry with backoff
  // Else: DLQ → update: job=failed, link/project status with error
  // Emit failure notification
}
```

### 4.7 Middleware (`services/src/middleware/`)

**Key:** `auth.middleware.ts` | `error.middleware.ts` | `validation.middleware.ts` | `rateLimit.middleware.ts`

**Auth Pattern:**
```typescript
authenticate(req, res, next) {
  // Extract Bearer token → verify JWT
  // Find user by ID → attach to req → next() or 401
}
```

---

## 5. Flutter App

### 5.1 Core Infrastructure

#### Config (`app/lib/core/config/env_config.dart`)
```dart
class EnvConfig {
  static String get apiBaseUrl;
  static Duration get connectTimeout;
  static Duration get receiveTimeout;
  static String get apiPathPrefix;
  static bool get enableLogging;
}
```

#### Network Client (`app/lib/core/network/dio_client.dart`)
```dart
// Singleton Dio instance
onRequest(options, handler) {
  // Get token from storage → add Authorization header
}

onError(DioException error, handler) {
  // 401: trigger refresh → other: map to exception
}
```

#### Secure Storage (`app/lib/core/storage/secure_storage.dart`)
```dart
class SecureStorage {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<void> saveTokens(String access, String refresh);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
}
```

### 5.2 Data Layer

#### Models (`app/lib/data/models/`)
**Pattern:** Freezed immutable classes with JSON serialization

**Key Models:**
- `UserModel` - id, email, name
- `ProjectModel` - id, name, description, linkIds, aiOutputId
- `LinkModel` - id, url, title, status, tags, summary, flashcards
- `JobModel` - id, status, progress

```dart
@freezed
class LinkModel with _$LinkModel {
  const factory LinkModel({
    required String id,
    required String url,
    String? title,
    required LinkStatus status,
    List<String> tags,
    SummaryContent? summary,
    FlashcardsContent? flashcards,
    required DateTime createdAt,
  }) = _LinkModel;

  factory LinkModel.fromJson(Map<String, dynamic> json) =>
      _$LinkModelFromJson(json);
}
```

#### Repositories (`app/lib/data/repositories/`)
```dart
class LinkRepository {
  final LinkService _linkService;
  final SecureStorage _storage;

  Future<Result<List<LinkModel>>> getLinks({
    String? projectId,
    List<String>? tags,
  }) async {
    try {
      final links = await _linkService.getLinks(projectId, tags);
      return Result.success(links);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
```

### 5.3 State Management

#### ViewModels (`app/lib/presentation/viewmodels/`)
**Pattern:** StateNotifier + Freezed state

```dart
class FeatureViewModel extends StateNotifier<FeatureState> {
  final FeatureRepository _repository;

  FeatureViewModel(this._repository) : super(FeatureState.initial());

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.getData();

    result.fold(
      (data) => state = state.copyWith(data: data, isLoading: false),
      (error) => state = state.copyWith(isLoading: false, error: error),
    );
  }
}

@freezed
class FeatureState with _$FeatureState {
  const factory FeatureState.initial() = _Initial;
  const factory FeatureState.loading() = _Loading;
  const factory FeatureState.loaded(Data data) = _Loaded;
  const factory FeatureState.error(String message) = _Error;
}
```

### 5.4 Presentation

#### Screen Pattern (`app/lib/presentation/pages/`)
```dart
class FeaturePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<FeaturePage> createState() => _FeaturePageState();
}

class _FeaturePageState extends ConsumerState<FeaturePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(featureViewModelProvider.notifier).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(featureViewModelProvider);

    ref.listen<FeatureState>(featureViewModelProvider, (previous, next) {
      // Navigate based on state
    });

    return state.when(
      initial: () => LoadingWidget(),
      loading: () => LoadingWidget(),
      loaded: (data) => ContentWidget(data: data),
      error: (message) => ErrorWidget(message: message),
    );
  }
}
```

#### Key Screens
**Auth:** `LoginPage`, `RegisterPage`
**Main:** `MainContainerPage` (tabs), `HomePage`, `ProjectsListPage`, `ProjectDetailPage`, `LinksListPage`, `LinkDetailPage`, `AddLinkPage`, `ProfilePage`

### 5.5 Navigation (`app/lib/core/router/app_router.dart`)

**GoRouter with auth redirects:**
```dart
final router = GoRouter(
  routes: [
    GoRoute(path: '/splash'),
    GoRoute(path: '/login'),
    GoRoute(path: '/register'),
    GoRoute(path: '/', redirect: (state) => '/projects'),
    GoRoute(path: '/projects'),
    GoRoute(path: '/projects/:id'),
    GoRoute(path: '/links'),
    GoRoute(path: '/links/:id'),
    GoRoute(path: '/profile'),
  ],
  redirect: (context, state) {
    // Unauthenticated → /login
    // Authenticated on auth page → /
  },
);
```

### 5.6 Common Widgets (`app/lib/presentation/widgets/`)

`AppButton` | `AppTextField` | `LoadingWidget` | `ErrorWidget` | `ProjectCard` | `LinkCard`

---

## 6. Chrome Extension

### 6.1 Structure (`extension/`)

Manifest V3 | Background service worker | Popup UI

### 6.2 Background Worker (`extension/src/background/index.ts`)

```typescript
chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({
    title: 'Save to L2L',
    contexts: ['link', 'page']
  });
});

chrome.contextMenus.onClicked.addListener(async (info, tab) => {
  // Get token → extract URL/title → API call → notification
});

chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  // Handle: SAVE_LINK, GET_CURRENT_PAGE, TOKEN_UPDATE
});
```

### 6.3 Popup (`extension/src/popup/index.tsx`)

```typescript
function Popup() {
  // State: url, title, projects[], selectedProject, tags
  // Load tab info → fetch projects
  // Handle save → message to background
  // Render: form with URL, project dropdown, tags
}
```

---

## 7. API Reference

### 7.1 Auth

| Method | Endpoint | Auth | Purpose |
|--------|----------|------|---------|
| POST | `/api/v1/auth/register` | No | Create user |
| POST | `/api/v1/auth/login` | No | Authenticate |
| POST | `/api/v1/auth/refresh` | No | Refresh token |
| GET | `/api/v1/auth/me` | Yes | Current user |

### 7.2 Projects

| Method | Endpoint | Auth | Purpose |
|--------|----------|------|---------|
| GET | `/api/v1/projects` | Yes | List |
| POST | `/api/v1/projects` | Yes | Create |
| GET | `/api/v1/projects/:id` | Yes | Get details |
| PUT | `/api/v1/projects/:id` | Yes | Update |
| DELETE | `/api/v1/projects/:id` | Yes | Soft delete |
| POST | `/api/v1/projects/:id/generate-course-quiz` | Yes | Generate AI |
| GET | `/api/v1/projects/:id/course` | Yes | Get course |
| GET | `/api/v1/projects/:id/quiz` | Yes | Get quiz |

### 7.3 Links

| Method | Endpoint | Auth | Purpose |
|--------|----------|------|---------|
| GET | `/api/v1/links` | Yes | List (paginated) |
| POST | `/api/v1/links` | Yes | Create + queue |
| GET | `/api/v1/links/:id` | Yes | Get with AI |
| PUT | `/api/v1/links/:id` | Yes | Update |
| DELETE | `/api/v1/links/:id` | Yes | Soft delete |
| POST | `/api/v1/links/:id/retry` | Yes | Retry failed |

### 7.4 Jobs

| Method | Endpoint | Auth | Purpose |
|--------|----------|------|---------|
| GET | `/api/v1/jobs/:jobId` | Yes | Job status |

---

## 8. Deployment

### 8.1 Environment Variables

**Backend (.env):**
```
NODE_ENV=development|production
PORT=3000
MONGODB_URI=mongodb://localhost:27017/l2l
REDIS_HOST=localhost
REDIS_PORT=6379
OPENAI_API_KEY=sk-...
JWT_SECRET=min-32-chars
JWT_ACCESS_TTL=15m
JWT_REFRESH_TTL=7d
WORKER_CONCURRENCY=5
MAX_JOB_ATTEMPTS=3
```

**Flutter (.env):**
```
API_BASE_URL=http://localhost:3000
API_PATH_PREFIX=/api/v1
CONNECT_TIMEOUT=30000
RECEIVE_TIMEOUT=30000
ENABLE_LOGGING=true
```

### 8.2 Docker

**Dev:** `docker-compose -f docker-compose.dev.yml up -d`
**Prod:** `docker-compose -f docker-compose.prod.yml up -d --scale api=3`

### 8.3 Infrastructure

**Dev:** MongoDB single | Redis single | API single (hot-reload)
**Prod:** MongoDB replica | Redis persistence | API replicas (3x) | nginx (SSL, load balancer)

---

## 9. Verification Checklist

### Phase 1: Foundation
- [ ] Docker compose starts all services
- [ ] Backend health endpoint: 200
- [ ] Flutter runs: iOS simulator + Chrome
- [ ] Extension loads in dev mode
- [ ] Env vars load | DB connects | Redis connects | OpenAI key configured

### Phase 2: Backend
**User:** [ ] register | [ ] login | [ ] JWT issued | [ ] refresh works | [ ] protected routes require auth
**Project:** [ ] create | [ ] list | [ ] update | [ ] delete (soft) | [ ] trigger course gen
**Links:** [ ] create + queue | [ ] status updates | [ ] retry failed | [ ] filter by tags
**AI:** [ ] process links | [ ] generate summaries | [ ] generate flashcards | [ ] generate courses | [ ] generate quizzes
**Jobs:** [ ] queue correctly | [ ] workers process | [ ] retry with backoff | [ ] status updates

### Phase 3: Flutter
**Auth:** [ ] register via app | [ ] login via app | [ ] state persists | [ ] logout works | [ ] protected routes redirect
**Projects:** [ ] list | [ ] create | [ ] details | [ ] show links | [ ] course gen triggers
**Links:** [ ] list | [ ] add via URL | [ ] status updates | [ ] show summary | [ ] show flashcards | [ ] retry failed
**Nav:** [ ] bottom nav | [ ] routes accessible | [ ] back works | [ ] auth redirects

### Phase 4: Extension
- [ ] Context menu appears on install
- [ ] Click saves link
- [ ] Popup loads
- [ ] Project selection works
- [ ] Tags work
- [ ] Save button works

### Phase 5: Integration
- [ ] Register → Add Link → View Summary → Create Project → Generate Course
- [ ] Login → View Links → Filter Tag → View Details
- [ ] Create Project → Add Links → Generate Course & Quiz
- [ ] Extension Save → Link in App → Process Complete

---

## Appendix A: Error Handling

### Backend (`services/src/utils/errors.ts`)
```typescript
class AppError extends Error {
  statusCode: number;
  code: string;
  isOperational: boolean;
}

// Subtypes: ValidationError (400), AuthenticationError (401), NotFoundError (404), AIProcessingError (500)
```

### Flutter (`app/lib/core/utils/result.dart`)
```dart
abstract class Result<T> {
  bool get isSuccess;
  T? get data;
  String? get error;

  R fold<R>(
    R Function(T data) onSuccess,
    R Function(String error) onFailure,
  );
}
```

---

## Appendix B: Path Cross-Reference

| Component | Guide → Actual |
|-----------|---------------|
| Backend root | `backend/` → `services/` |
| Flutter root | `mobile_app/` → `app/` |
| Auth module | `modules/auth/` → `modules/user/` |
| Project | `modules/project/` → `modules/project/` |
| Links | `modules/link/` → `modules/links/` |

---

**End**
