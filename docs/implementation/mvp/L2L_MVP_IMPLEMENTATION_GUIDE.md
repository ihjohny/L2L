# L2L (Link to Learn) - Unified MVP Implementation Guide

**Version:** 3.0 (Unified)
**Date:** April 2026
**Status:** Authoritative Guide for L2L MVP Development

---

## Document Purpose

This guide provides a comprehensive, unified implementation reference for the L2L platform MVP, covering both backend services and the Flutter mobile application. It uses pseudocode patterns and architectural guidance rather than complete implementations, focusing on the current codebase structure and best practices.

### How to Use This Guide

1. **Sequential Foundation:** Start with infrastructure setup, then implement backend services, followed by the Flutter app
2. **Pattern-Based:** Each section describes architectural patterns, file structures, and implementation approaches
3. **Cross-Referenced:** All file paths, module names, and references align with the current codebase structure
4. **Pseudocode-First:** Code examples use annotated pseudocode to convey intent without copy-paste implementation

---

## Table of Contents

1. [Architecture Overview](#1-architecture-overview)
2. [Project Structure](#2-project-structure)
3. [Database Schema](#3-database-schema)
4. [Backend Services Implementation](#4-backend-services-implementation)
5. [Flutter Application Implementation](#5-flutter-application-implementation)
6. [Chrome Extension Implementation](#6-chrome-extension-implementation)
7. [API Reference](#7-api-reference)
8. [Deployment & Operations](#8-deployment--operations)
9. [Verification Checklist](#9-verification-checklist)

---

## 1. Architecture Overview

### 1.1 System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Flutter Mobile App                       │
│                  (iOS, Android, Web)                         │
│  State: Riverpod | Routing: GoRouter | Network: Dio         │
└───────────────────────────┬─────────────────────────────────┘
                            │ REST API
┌───────────────────────────┴─────────────────────────────────┐
│              Backend Services (Express + TypeScript)         │
│  ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐│
│  │   User    │  │  Project  │  │   Link    │  │    AI     ││
│  │  Module   │  │  Module   │  │  Module   │  │  Module   ││
│  └───────────┘  └───────────┘  └───────────┘  └───────────┘│
│  ┌───────────┐                                              │
│  │   Jobs    │  ← BullMQ Workers                           │
│  │  Module   │                                              │
│  └───────────┘                                              │
└───────────────────────────┬─────────────────────────────────┘
                            │
┌───────────────────────────┴─────────────────────────────────┐
│              Data Layer                                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   MongoDB    │  │    Redis     │  │   OpenAI     │     │
│  │   (Primary)  │  │  (Jobs+Cache)│  │   (Content)  │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 Technology Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Backend Services** | Node.js 20 + TypeScript + Express | REST API, business logic |
| **Mobile App** | Flutter (Dart) | Cross-platform client |
| **Browser Extension** | TypeScript + Manifest V3 | One-click link saving |
| **Database** | MongoDB 7.0 + Mongoose | Primary data persistence |
| **Job Queue** | Redis 7 + BullMQ | Async task processing |
| **AI Service** | OpenAI API (GPT-4o) | Content generation |

### 1.3 AI Processing Flow

```
Per-Link (Automatic):  URL → Extract → Summary + Flashcards → MongoDB
Per-Project (Manual):  Summaries → Synthesize → Course + Quiz → MongoDB
```

---

## 2. Project Structure

### 2.1 Root Directory Layout

```
l2l/
├── services/              # Backend services (Express + TypeScript)
├── app/                   # Flutter mobile application
├── extension/             # Chrome extension (TypeScript + MV3)
├── docs/                  # Documentation
│   └── implementation/mvp/
├── docker-compose.dev.yml # Development environment
├── docker-compose.prod.yml # Production environment
└── CLAUDE.md             # Project-specific AI instructions
```

### 2.2 Backend Services Structure

```
services/
├── src/
│   ├── index.ts          # Entry point
│   ├── server.ts         # Express server setup
│   ├── app.ts            # Express app configuration
│   ├── config/           # Environment configuration
│   ├── database/         # MongoDB connection and schemas
│   ├── middleware/       # Express middleware (auth, validation, etc.)
│   ├── modules/          # Feature modules
│   │   ├── user/         # Authentication and user management
│   │   ├── project/      # Project CRUD operations
│   │   ├── links/        # Link management
│   │   ├── ai/           # AI service orchestration
│   │   └── jobs/         # Job queue management
│   ├── utils/            # Shared utilities (logger, errors, etc.)
│   └── tests/            # Tests (unit, integration, e2e)
├── dist/                 # Compiled JavaScript output
├── package.json
└── tsconfig.json
```

### 2.3 Flutter Application Structure

```
app/
├── lib/
│   ├── main.dart         # Application entry point
│   ├── core/             # Core infrastructure
│   │   ├── app/          # Root app widget
│   │   ├── config/       # Environment and theme configuration
│   │   ├── constants/    # App constants
│   │   ├── network/      # Dio HTTP client
│   │   ├── storage/      # Secure token storage
│   │   ├── router/       # GoRouter navigation
│   │   └── utils/        # Utilities (Result, navigation triggers)
│   ├── data/             # Data layer
│   │   ├── models/       # Data classes (Freezed)
│   │   ├── repositories/ # Business logic
│   │   └── services/     # API clients
│   ├── providers/        # Riverpod providers
│   └── presentation/     # UI layer
│       ├── pages/        # Screen widgets
│       ├── viewmodels/   # State management (StateNotifier)
│       └── widgets/      # Reusable UI components
├── pubspec.yaml
└── analysis_options.yaml
```

---

## 3. Database Schema

All collections use MongoDB with Mongoose ODM following these patterns:
- Soft deletes via `deletedAt: Date | null` (indexed)
- Timestamps via `createdAt`, `updatedAt` (auto-managed)
- ObjectId for `_id` fields

### 3.1 Users Collection

**File:** `services/src/database/schemas/user.schema.ts`

**Schema Structure:**
```typescript
{
  _id: ObjectId;
  email: string;              // unique, lowercase, indexed
  passwordHash: string;       // bcrypt hash
  name: string;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date | null;
}
```

**Indexes:**
- `{ email: 1 }` (unique)
- `{ deletedAt: 1 }`

### 3.2 Projects Collection

**File:** `services/src/database/schemas/project.schema.ts`

**Schema Structure:**
```typescript
{
  _id: ObjectId;
  userId: ObjectId;           // Foreign key to users
  name: string;
  description: string | null;
  aiOutputId: ObjectId | null; // Generated course reference
  linkIds: ObjectId[];        // Associated links
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date | null;
}
```

**Indexes:**
- `{ userId: 1, createdAt: -1 }`
- `{ deletedAt: 1 }`

### 3.3 Links Collection

**File:** `services/src/database/schemas/link.schema.ts`

**Schema Structure:**
```typescript
{
  _id: ObjectId;
  userId: ObjectId;           // Owner user
  projectId: ObjectId | null; // Associated project
  url: string;
  title: string | null;
  aiOutputId: ObjectId | null; // AI content reference
  tags: string[];
  status: 'pending' | 'processing' | 'completed' | 'failed';
  statusMessage: string | null;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date | null;
}
```

**Indexes:**
- `{ userId: 1, createdAt: -1 }`
- `{ userId: 1, projectId: 1, createdAt: -1 }`
- `{ deletedAt: 1 }`

### 3.4 AI Outputs Collection

**File:** `services/src/database/schemas/aiOutput.schema.ts`

**Schema Structure:**
```typescript
{
  _id: ObjectId;
  sourceType: 'link' | 'project';
  sourceId: ObjectId;
  type: 'summary' | 'flashcards' | 'course' | 'quiz';
  content: object;           // Type-specific structure
  tokenUsage: {
    inputTokens: number;
    outputTokens: number;
    totalTokens: number;
  };
  createdAt: Date;
  updatedAt: Date;
}
```

**Content Structure by Type:**
- **summary:** `{ keyPoints: string[], mainArgument: string, takeaways: string[] }`
- **flashcards:** `{ flashcards: [{ question, answer, difficulty }] }`
- **course:** `{ title, description, lessons: [{ title, content, order }] }`
- **quiz:** `{ questions: [{ question, options, correct, explanation }] }`

**Indexes:**
- `{ sourceType: 1, sourceId: 1, type: 1 }`
- `{ createdAt: -1 }`

### 3.5 Jobs Collection

**File:** `services/src/database/schemas/job.schema.ts`

**Schema Structure:**
```typescript
{
  _id: ObjectId;
  userId: ObjectId;
  type: 'process_link' | 'generate_course';
  sourceType: 'link' | 'project';
  sourceId: ObjectId;
  status: 'waiting' | 'active' | 'completed' | 'failed' | 'delayed';
  attempts: number;
  maxAttempts: number;
  progress: number;          // 0-100
  data: Record<string, any>;
  failedReason: string | null;
  processedAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
}
```

**Indexes:**
- `{ userId: 1, status: 1, createdAt: -1 }`
- `{ status: 1, createdAt: 1 }`
- `{ createdAt: 1 }` (TTL: 7 days)

---

## 4. Backend Services Implementation

### 4.1 Module Structure Pattern

All backend modules follow this structure:

```
modules/<name>/
├── <name>.controller.ts    # HTTP request handlers
├── <name>.service.ts       # Business logic
├── <name>.model.ts         # Mongoose model
├── <name>.routes.ts        # Express route definitions
└── dto/
    ├── create-<name>.dto.ts
    └── update-<name>.dto.ts
```

### 4.2 User Module

**Location:** `services/src/modules/user/`

**Responsibilities:**
- User registration and authentication
- JWT token generation and validation
- Password hashing with bcrypt
- Token refresh mechanism

**Key Endpoints:**
- `POST /api/v1/auth/register` - Create user account
- `POST /api/v1/auth/login` - Authenticate and issue tokens
- `POST /api/v1/auth/refresh` - Exchange refresh token for access token
- `GET /api/v1/auth/me` - Get current authenticated user

**Service Pattern:**
```typescript
// Pseudocode for user registration
async register(email, password, name) {
  // Validate input
  // Check if user exists by email
  // Hash password with bcrypt (cost factor: from env)
  // Create user document
  // Generate JWT pair (access + refresh)
  // Return user data without passwordHash
}

// Pseudocode for user login
async login(email, password) {
  // Find user by email
  // Compare password with bcrypt hash
  // If valid: generate JWT pair
  // Return user + tokens
}

// Pseudocode for token generation
generateTokens(userId) {
  // Access token: short-lived (from env, default 15min)
  // Refresh token: long-lived (from env, default 7 days)
  // Sign with secret from environment
  // Return { accessToken, refreshToken }
}
```

### 4.3 Project Module

**Location:** `services/src/modules/project/`

**Responsibilities:**
- Project CRUD operations
- Link association management
- Course and quiz generation orchestration

**Key Endpoints:**
- `GET /api/v1/projects` - List user's projects
- `POST /api/v1/projects` - Create new project
- `GET /api/v1/projects/:id` - Get project with links
- `PUT /api/v1/projects/:id` - Update project
- `DELETE /api/v1/projects/:id` - Soft delete project
- `POST /api/v1/projects/:id/generate-course-quiz` - Trigger AI course generation
- `GET /api/v1/projects/:id/course` - Get latest course
- `GET /api/v1/projects/:id/quiz` - Get latest quiz

**Service Pattern:**
```typescript
// Pseudocode for project creation
async createProject(userId, { name, description }) {
  // Validate input
  // Create project document with userId
  // Return project
}

// Pseudocode for getting project with links
async getProjectWithLinks(projectId, userId) {
  // Find project by ID
  // Verify ownership (userId matches)
  // Populate associated links with AI output
  // Return project with links array
}

// Pseudocode for course generation
async generateCourseQuiz(projectId, userId) {
  // Find project with completed links
  // Validate that links have summaries
  // Create job in queue: generate_course
  // Return jobId for tracking
}
```

### 4.4 Links Module

**Location:** `services/src/modules/links/`

**Responsibilities:**
- Link CRUD operations
- URL validation and metadata extraction
- Project association
- AI processing job triggering

**Key Endpoints:**
- `GET /api/v1/links` - List user's links (paginated, filterable)
- `POST /api/v1/links` - Create link and queue AI processing
- `GET /api/v1/links/:id` - Get link with AI output
- `PUT /api/v1/links/:id` - Update link
- `DELETE /api/v1/links/:id` - Soft delete link
- `POST /api/v1/links/:id/retry` - Retry failed link processing

**Service Pattern:**
```typescript
// Pseudocode for link creation
async createLink(userId, { url, projectId, tags }) {
  // Validate URL format
  // Fetch page title/metadata (optional)
  // Create link document with status: "pending"
  // Queue job: process_link
  // Return link + jobId
}

// Pseudocode for getting link details
async getLink(linkId, userId) {
  // Find link by ID
  // Verify ownership
  // Populate AI output (summary, flashcards)
  // Return complete link data
}

// Pseudocode for retrying failed links
async retryLink(linkId, userId) {
  // Verify link ownership
  // Verify status is "failed"
  // Reset status to "pending"
  // Clear statusMessage
  // Create new job in queue
  // Return link with new jobId
}
```

### 4.5 AI Module

**Location:** `services/src/modules/ai/`

**Responsibilities:**
- Content extraction from URLs
- OpenAI API integration
- Prompt engineering and response parsing
- AI output storage

**Service Pattern:**
```typescript
// Pseudocode for processing a link
async processLink(url) {
  // Extract content via Playwright/Cheerio
  // Clean and normalize text content
  // Generate summary (OpenAI call)
  // Generate flashcards (OpenAI call)
  // Store AI outputs in ai_outputs collection
  // Return { summary, flashcards }
}

// Pseudocode for generating a summary
async generateSummary(content) {
  // Call OpenAI with structured prompt
  // Request JSON response format
  // Parse and validate response structure
  // Return { keyPoints, mainArgument, takeaways }
}

// Pseudocode for generating flashcards
async generateFlashcards(content) {
  // Call OpenAI with flashcard prompt
  // Request 5-10 Q&A pairs
  // Validate response structure
  // Return [{ question, answer, difficulty }]
}

// Pseudocode for course generation
async generateCourse(summaries[], courseId) {
  // Combine all summaries
  // Call OpenAI with course synthesis prompt
  // Parse { title, description, lessons }
  // Store course AI output
  // Generate quiz based on course content
  // Return course structure
}

// Pseudocode for quiz generation
async generateQuiz(courseContent, courseId) {
  // Call OpenAI with quiz prompt
  // Request 5-15 multiple-choice questions
  // Include explanations for answers
  // Store quiz AI output with courseId reference
  // Return [{ question, options, correct, explanation }]
}
```

**Prompt Strategy:**
All prompts should:
- Request JSON output format
- Specify exact structure requirements
- Include content length limits
- Define quality criteria (e.g., difficulty distribution)

### 4.6 Jobs Module

**Location:** `services/src/modules/jobs/`

**Responsibilities:**
- Job queue management with BullMQ
- Worker configuration and execution
- Retry logic with exponential backoff
- Job status tracking

**Queue Configuration:**
```typescript
// Queue names (use constants from config)
const QUEUE_NAMES = {
  PROCESS_LINK: 'l2l:process_link',
  GENERATE_COURSE: 'l2l:generate_course',
  FAILED_JOBS: 'l2l:failed_jobs'
};

// Worker settings (from environment or constants)
const WORKER_CONFIG = {
  concurrency: env.WORKER_CONCURRENCY || 5,
  maxAttempts: env.MAX_JOB_ATTEMPTS || 3,
  backoffType: 'exponential',
  backoffDelay: env.BASE_BACKOFF_MS || 2000
};
```

**Worker Pattern:**
```typescript
// Pseudocode for process-link worker
async processLinkJob(job) {
  // Update job status: "active"
  // Update link status: "processing"
  try {
    // Call aiService.processLink(job.data.url)
    // Store AI output documents
    // Update link status: "completed"
    // Update job status: "completed", progress: 100
    // Emit notification event
  } catch (error) {
    // Handle error, mark for retry or fail
  }
}

// Pseudocode for generate-course worker
async generateCourseJob(job) {
  // Update job status: "active", progress: 0
  // Fetch all link summaries for project
  try {
    // Call aiService.generateCourse(summaries)
    // Store course AI output (get courseId)
    // Call aiService.generateQuiz(course, courseId)
    // Store quiz AI output with courseId reference
    // Update project.aiOutputId
    // Update job status: "completed", progress: 100
    // Emit notification event
  } catch (error) {
    // Handle error, mark for retry or fail
  }
}

// Pseudocode for job failure handling
async handleJobFailed(job, error) {
  // If attempts < maxAttempts: retry with backoff
  // If max attempts reached: move to dead-letter queue
  // Update job status: "failed"
  // Update link/project status with error message
  // Emit failure notification
}
```

### 4.7 Middleware

**Location:** `services/src/middleware/`

**Key Middleware:**
- `auth.middleware.ts` - JWT validation and user attachment
- `error.middleware.ts` - Global error handling
- `validation.middleware.ts` - Request validation using express-validator
- `rateLimit.middleware.ts` - API rate limiting

**Auth Middleware Pattern:**
```typescript
// Pseudocode for authentication middleware
async authenticate(req, res, next) {
  // Extract Bearer token from Authorization header
  // Verify JWT signature and expiration
  // Find user by ID from token
  // Attach user to request object
  // Call next() or return 401
}
```

---

## 5. Flutter Application Implementation

### 5.1 Core Infrastructure

#### Configuration

**File:** `app/lib/core/config/env_config.dart`

**Responsibilities:**
- Load environment-specific configuration
- Define API endpoints and timeouts
- Control feature flags and logging

**Pattern:**
```dart
// Pseudocode for environment configuration
class EnvConfig {
  // Load from .env file or platform-specific config
  static String get apiBaseUrl;
  static Duration get connectTimeout;
  static Duration get receiveTimeout;
  static String get apiPathPrefix;
  static bool get enableLogging;
}
```

#### Network Client

**File:** `app/lib/core/network/dio_client.dart`

**Responsibilities:**
- Singleton HTTP client using Dio
- Request/response interceptors
- Auth token injection
- Token refresh on 401
- Error mapping to custom exceptions

**Interceptor Flow:**
```dart
// Pseudocode for request interceptor
onRequest(options, handler) {
  // Retrieve access token from secure storage
  // If token exists: add Authorization header
  // Continue request
}

// Pseudocode for response interceptor
onResponse(response, handler) {
  // Return response
}

onError(DioException error, handler) {
  // On 401: trigger token refresh
  // On other errors: map to appropriate exception
  // Return error response
}
```

#### Secure Storage

**File:** `app/lib/core/storage/secure_storage.dart`

**Responsibilities:**
- Store access and refresh tokens
- Retrieve tokens for API requests
- Clear tokens on logout

**Pattern:**
```dart
// Pseudocode for secure storage
class SecureStorage {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<void> saveTokens(String accessToken, String refreshToken);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
}
```

### 5.2 Data Layer

#### Models

**Location:** `app/lib/data/models/`

**Pattern:** Use Freezed for immutable data classes with JSON serialization

**Key Models:**
- `UserModel` - User data (id, email, name)
- `ProjectModel` - Project data (id, name, description, linkIds, aiOutputId)
- `LinkModel` - Link data (id, url, title, status, tags, summary, flashcards)
- `JobModel` - Job tracking (id, status, progress)

**Model Pattern:**
```dart
// Pseudocode for Freezed model
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

#### Repositories

**Location:** `app/lib/data/repositories/`

**Responsibilities:**
- Business logic layer
- Coordinate multiple service calls
- Token management for auth
- Return `Result<T>` types for explicit error handling

**Repository Pattern:**
```dart
// Pseudocode for repository pattern
class LinkRepository {
  final LinkService _linkService;
  final SecureStorage _storage;

  Future<Result<List<LinkModel>>> getLinks({
    String? projectId,
    List<String>? tags,
  }) async {
    try {
      final links = await _linkService.getLinks(
        projectId: projectId,
        tags: tags,
      );
      return Result.success(links);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
```

### 5.3 State Management

#### ViewModels

**Location:** `app/lib/presentation/viewmodels/`

**Pattern:** StateNotifier with Freezed state classes

**ViewModel Structure:**
```dart
// Pseudocode for ViewModel
class FeatureViewModel extends StateNotifier<FeatureState> {
  final FeatureRepository _repository;

  FeatureViewModel(this._repository) : super(FeatureState.initial());

  Future<void> loadData() async {
    // Set loading state
    state = state.copyWith(isLoading: true, error: null);

    // Call repository
    final result = await _repository.getData();

    // Handle result
    result.fold(
      (data) => state = state.copyWith(data: data, isLoading: false),
      (error) => state = state.copyWith(isLoading: false, error: error),
    );
  }
}
```

**State Pattern:**
```dart
// Pseudocode for state class
@freezed
class FeatureState with _$FeatureState {
  const factory FeatureState.initial() = _Initial;
  const factory FeatureState.loading() = _Loading;
  const factory FeatureState.loaded(Data data) = _Loaded;
  const factory FeatureState.error(String message) = _Error;
}
```

### 5.4 Presentation Layer

#### Screen Pattern

**Location:** `app/lib/presentation/pages/`

**Responsibilities:**
- Render UI based on state
- Handle user interactions
- Trigger ViewModel actions
- Navigate based on state changes

**Screen Pattern:**
```dart
// Pseudocode for consumer widget
class FeaturePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<FeaturePage> createState() => _FeaturePageState();
}

class _FeaturePageState extends ConsumerState<FeaturePage> {
  @override
  void initState() {
    super.initState();
    // Trigger data load
    Future.microtask(() {
      ref.read(featureViewModelProvider.notifier).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(featureViewModelProvider);

    // Handle navigation triggers
    ref.listen<FeatureState>(featureViewModelProvider, (previous, next) {
      // Navigate based on state changes
    });

    // Render UI based on state
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

**Authentication Screens:**
- `LoginPage` - Email/password login
- `RegisterPage` - New user registration

**Main Screens:**
- `MainContainerPage` - Bottom tab navigation (Home, Projects, Profile)
- `HomePage` - Dashboard with recent projects and links
- `ProjectsListPage` - Browse all projects
- `ProjectDetailPage` - View project, links, generate course
- `LinksListPage` - Browse all links with filtering
- `LinkDetailPage` - View link, summary, flashcards
- `AddLinkPage` - Save new link with project assignment
- `ProfilePage` - User info and logout

### 5.5 Navigation

**File:** `app/lib/core/router/app_router.dart`

**Router:** GoRouter with auth redirects

**Route Structure:**
```dart
// Pseudocode for route configuration
final router = GoRouter(
  routes: [
    GoRoute(path: '/splash', name: 'splash'),
    GoRoute(path: '/login', name: 'login'),
    GoRoute(path: '/register', name: 'register'),
    GoRoute(
      path: '/',
      name: 'home',
      redirect: (state) => '/projects'
    ),
    GoRoute(path: '/projects', name: 'projects'),
    GoRoute(path: '/projects/:id', name: 'project_detail'),
    GoRoute(path: '/links', name: 'links'),
    GoRoute(path: '/links/:id', name: 'link_detail'),
    GoRoute(path: '/profile', name: 'profile'),
  ],
  redirect: (context, state) {
    // Auth redirect logic
    // Unauthenticated → /login
    // Authenticated on auth page → /
  },
);
```

### 5.6 Common Widgets

**Location:** `app/lib/presentation/widgets/`

**Reusable Components:**
- `AppButton` - Primary button with loading state
- `AppTextField` - Input field with validation
- `LoadingWidget` - Full-screen loading indicator
- `ErrorWidget` - Error display with retry option
- `ProjectCard` - Project display card
- `LinkCard` - Link display card with status indicator

---

## 6. Chrome Extension Implementation

### 6.1 Structure

**Location:** `extension/`

**Manifest:** Manifest V3 format

**Key Components:**
- Background service worker
- Popup UI for saving links
- Content scripts (if needed)
- Shared utilities

### 6.2 Background Service Worker

**File:** `extension/src/background/index.ts`

**Responsibilities:**
- Create context menu on install
- Handle context menu clicks
- Process save link requests
- Manage authentication state

**Pattern:**
```typescript
// Pseudocode for background worker
// On install: create context menu
chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({
    title: 'Save to L2L',
    contexts: ['link', 'page']
  });
});

// On context menu click: save current page
chrome.contextMenus.onClicked.addListener(async (info, tab) => {
  // Get auth token from storage
  // Extract URL and title from tab
  // Call backend API to create link
  // Show notification on success
});

// Handle messages from popup
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  // Handle SAVE_LINK, GET_CURRENT_PAGE, TOKEN_UPDATE
});
```

### 6.3 Popup UI

**File:** `extension/src/popup/index.tsx`

**Responsibilities:**
- Display current page URL and title
- Allow project selection
- Add tags
- Save link

**Pattern:**
```typescript
// Pseudocode for popup component
function Popup() {
  // State: url, title, projects[], selectedProject, tags
  // Load current tab info on mount
  // Fetch projects from API
  // Handle save: send message to background
  // Render: form with URL, project dropdown, tags input
}
```

---

## 7. API Reference

### 7.1 Authentication Endpoints

| Method | Endpoint | Auth Required | Description |
|--------|----------|---------------|-------------|
| POST | `/api/v1/auth/register` | No | Create new user account |
| POST | `/api/v1/auth/login` | No | Authenticate user |
| POST | `/api/v1/auth/refresh` | No | Refresh access token |
| GET | `/api/v1/auth/me` | Yes | Get current user |

### 7.2 Project Endpoints

| Method | Endpoint | Auth Required | Description |
|--------|----------|---------------|-------------|
| GET | `/api/v1/projects` | Yes | List user projects |
| POST | `/api/v1/projects` | Yes | Create project |
| GET | `/api/v1/projects/:id` | Yes | Get project details |
| PUT | `/api/v1/projects/:id` | Yes | Update project |
| DELETE | `/api/v1/projects/:id` | Yes | Delete project (soft) |
| POST | `/api/v1/projects/:id/generate-course-quiz` | Yes | Generate course & quiz |
| GET | `/api/v1/projects/:id/course` | Yes | Get latest course |
| GET | `/api/v1/projects/:id/quiz` | Yes | Get latest quiz |

### 7.3 Link Endpoints

| Method | Endpoint | Auth Required | Description |
|--------|----------|---------------|-------------|
| GET | `/api/v1/links` | Yes | List links (paginated) |
| POST | `/api/v1/links` | Yes | Create link |
| GET | `/api/v1/links/:id` | Yes | Get link with AI output |
| PUT | `/api/v1/links/:id` | Yes | Update link |
| DELETE | `/api/v1/links/:id` | Yes | Delete link (soft) |
| POST | `/api/v1/links/:id/retry` | Yes | Retry failed processing |

### 7.4 Job Endpoints

| Method | Endpoint | Auth Required | Description |
|--------|----------|---------------|-------------|
| GET | `/api/v1/jobs/:jobId` | Yes | Get job status |

---

## 8. Deployment & Operations

### 8.1 Environment Variables

**Backend Services (.env):**
```
NODE_ENV=development|production
PORT=3000
MONGODB_URI=mongodb://localhost:27017/l2l
REDIS_HOST=localhost
REDIS_PORT=6379
OPENAI_API_KEY=sk-...
JWT_SECRET=your-secret-key-min-32-chars
JWT_ACCESS_TTL=15m
JWT_REFRESH_TTL=7d
WORKER_CONCURRENCY=5
MAX_JOB_ATTEMPTS=3
```

**Flutter App (.env or config):**
```
API_BASE_URL=http://localhost:3000
API_PATH_PREFIX=/api/v1
CONNECT_TIMEOUT=30000
RECEIVE_TIMEOUT=30000
ENABLE_LOGGING=true
```

### 8.2 Docker Configuration

**Development:**
```bash
docker-compose -f docker-compose.dev.yml up -d
```

**Production:**
```bash
docker-compose -f docker-compose.prod.yml up -d --scale api=3
```

### 8.3 Infrastructure Services

**Development:**
- MongoDB: Single instance, exposed ports
- Redis: Single instance, no persistence
- API: Single instance with hot-reload

**Production:**
- MongoDB: Replica set recommended
- Redis: Persistence enabled
- API: Multiple replicas behind nginx
- Nginx: SSL termination, load balancing

---

## 9. Verification Checklist

### Phase 1: Foundation

**Infrastructure:**
- [ ] Docker compose starts all services successfully
- [ ] Backend health endpoint returns 200
- [ ] Flutter app runs on iOS simulator and Chrome
- [ ] Chrome extension loads in developer mode

**Configuration:**
- [ ] Environment variables load correctly
- [ ] Database connections established
- [ ] Redis connection established
- [ ] OpenAI API key configured

### Phase 2: Backend Services

**User Module:**
- [ ] User can register
- [ ] User can login
- [ ] JWT tokens are issued
- [ ] Token refresh works
- [ ] Protected routes require auth

**Project Module:**
- [ ] User can create project
- [ ] User can list projects
- [ ] User can update project
- [ ] User can delete project (soft)
- [ ] User can trigger course generation

**Links Module:**
- [ ] User can create link
- [ ] Link is queued for processing
- [ ] Link status updates correctly
- [ ] Failed links can be retried
- [ ] User can filter links by tags

**AI Module:**
- [ ] Links are processed successfully
- [ ] Summaries are generated
- [ ] Flashcards are generated
- [ ] Courses are generated from summaries
- [ ] Quizzes are generated from courses

**Jobs Module:**
- [ ] Jobs are queued correctly
- [ ] Workers process jobs
- [ ] Failed jobs retry with backoff
- [ ] Job status updates correctly

### Phase 3: Flutter Application

**Authentication:**
- [ ] User can register via app
- [ ] User can login via app
- [ ] Auth state persists across restarts
- [ ] Logout works correctly
- [ ] Protected routes redirect to login

**Projects:**
- [ ] User can view projects list
- [ ] User can create project
- [ ] User can view project details
- [ ] Project shows associated links
- [ ] Course generation triggers correctly

**Links:**
- [ ] User can view links list
- [ ] User can add link via URL
- [ ] Link status updates in UI
- [ ] Completed links show summary
- [ ] Completed links show flashcards
- [ ] Failed links show retry option

**Navigation:**
- [ ] Bottom navigation works
- [ ] All routes are accessible
- [ ] Back navigation works
- [ ] Auth redirects work

### Phase 4: Chrome Extension

**Core Features:**
- [ ] Context menu appears on install
- [ ] Clicking context menu saves link
- [ ] Popup UI loads correctly
- [ ] User can select project
- [ ] User can add tags
- [ ] Save button works

### Phase 5: Integration

**End-to-End Flows:**
- [ ] Register → Add Link → View Summary → Create Project → Generate Course
- [ ] Login → View Links → Filter by Tag → View Details
- [ ] Create Project → Add Links → Generate Course & Quiz
- [ ] Extension Save → Link Appears in App → Process Complete

---

## Appendix A: Error Handling Patterns

### Backend Error Classes

**File:** `services/src/utils/errors.ts`

**Pattern:**
```typescript
// Base error class
class AppError extends Error {
  statusCode: number;
  code: string;
  isOperational: boolean;
}

// Specific error types
class ValidationError extends AppError // 400
class AuthenticationError extends AppError // 401
class NotFoundError extends AppError // 404
class AIProcessingError extends AppError // 500
```

### Flutter Result Type

**File:** `app/lib/core/utils/result.dart`

**Pattern:**
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

## Appendix B: File Path Cross-Reference

| Component | Guide Reference | Actual Path |
|-----------|----------------|-------------|
| Backend root | `backend/` | `services/` |
| Flutter root | `mobile_app/` | `app/` |
| Auth module | `modules/auth/` | `modules/user/` |
| Project module | `modules/project/` | `modules/project/` |
| Links module | `modules/link/` | `modules/links/` |

---

**Document End**

For questions or clarifications, refer to the actual implementation in the codebase or consult the project README.md.
