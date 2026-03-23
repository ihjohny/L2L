# L2L (Link to Learn) - AI Agent Implementation Guide

**Version:** 2.0 (Concise)
**Date:** March 2026
**Status:** Authoritative Guide for AI-Assisted Development

---

## Document Purpose

This document provides step-by-step implementation instructions for AI agents to generate the L2L platform MVP codebase using **pseudocode patterns** and **minimal code examples**.

### How to Use This Guide

1. **Sequential Execution:** Follow phases in order (Phase 1 → Phase 2 → Phase 3)
2. **Pattern-Based:** Each task specifies file structure and code patterns to follow
3. **Verification Steps:** Each phase includes validation commands

---

## Project Overview

### MVP Scope

| Component | Technology | Purpose |
|-----------|------------|---------|
| Backend | Node.js 20 + TypeScript + Express | REST API, AI orchestration |
| Frontend | Flutter (Dart) | iOS, Android, Web |
| Extension | TypeScript + Manifest V3 | One-click save |
| Database | MongoDB 7.0 | Primary data store |
| Cache/Queue | Redis 7 + BullMQ | Job queues |
| AI | OpenAI API (GPT-4o) | Content processing |

### Two-Tier AI Processing

```
Per-Link (Automatic):  URL → Extract → Summary + Flashcards → MongoDB
Per-Project (Manual):  Summaries → Synthesize → Course + Quiz → MongoDB
```

---

## Code Generation Phases

| Phase | Description |
|-------|-------------|
| **Phase 1** | Project Foundation (structures, configs, Docker) |
| **Phase 2** | MVP Implementation (Auth, Link, Project, AI, Job modules) |
| **Phase 3** | Enhancement (Testing, CI/CD, Deployment) |

---

# PHASE 1: Project Foundation Setup

## Phase 1.1: Root Project Structure

**Files to Generate:**

### 1. Root `.gitignore`
- `node_modules/`, `**/node_modules/`
- Flutter/Dart build artifacts
- `.env`, `.env.*` (except templates)
- IDE folders (`.vscode/`, `.idea/`)
- Build outputs (`dist/`, `build/`, `coverage/`)

### 2. Root `README.md`
- Project title and description
- Quick start commands (docker-compose, backend, flutter, extension)
- Technology stack table
- Links to documentation

### 3. `docker-compose.yml`
**Services:**
- `mongodb`: MongoDB 7.0 on port 27017
- `redis`: Redis 7 on port 6379

**Verification:**
```bash
docker-compose up -d
docker-compose ps  # Both should be "healthy"
```

---

## Phase 1.2: Backend Foundation

**Directory Structure:**
```
backend/
├── src/
│   ├── main.ts
│   ├── app.ts
│   ├── config/
│   ├── modules/
│   ├── middleware/
│   └── utils/
├── tests/
├── .eslintrc.js
├── .prettierrc
├── jest.config.js
├── tsconfig.json
└── package.json
```

### package.json
**Scripts:** `dev`, `build`, `start`, `test`, `lint`, `format`
**Dependencies:** express, mongoose, bullmq, openai, bcrypt, jsonwebtoken, zod, pino, cors, helmet, dotenv
**Dev Dependencies:** typescript, ts-node, nodemon, jest, ts-jest, @types/*, eslint, prettier

### tsconfig.json
**Settings:** strict mode, ES2022 target, Node16 module, outDir: `dist`, rootDir: `src`

### ESLint + Prettier
**Rules:** TypeScript parser, semicolons required, single quotes, 100 char width

---

## Phase 1.3: Flutter Mobile App Foundation

**Directory Structure:**
```
mobile_app/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── constants/
│   │   ├── network/
│   │   ├── storage/
│   │   └── utils/
│   ├── features/
│   │   ├── auth/
│   │   ├── projects/
│   │   └── links/
│   ├── providers/
│   └── routing/
├── test/
├── pubspec.yaml
└── analysis_options.yaml
```

### pubspec.yaml
**Dependencies:** flutter, riverpod, go_router, dio, hive_flutter, flutter_secure_storage, shared_preferences
**Dev Dependencies:** flutter_test, mocktail, build_runner

---

## Phase 1.4: Chrome Extension Foundation

**Directory Structure:**
```
extension/
├── src/
│   ├── background/
│   ├── popup/
│   ├── content/
│   └── shared/
├── public/
│   └── icons/
├── manifest.json
├── webpack.config.js
├── package.json
└── tsconfig.json
```

### manifest.json (MV3)
**Permissions:** storage, tabs, contextMenus, alarms, notifications
**Host Permissions:** backend API URL
**Background:** service worker (ES module)
**Action:** popup HTML

---

## Phase 1.5: Backend Core Utilities

### Error Class Hierarchy (`src/utils/error.ts`)
**Pattern:**
```typescript
class AppError extends Error {
  statusCode: number;
  code: string;
  isOperational: boolean;
}

// Concrete errors: ValidationError (400), AuthenticationError (401),
// NotFoundError (404), AIProcessingError (500), etc.
```

### Logger (`src/utils/logger.ts`)
**Pattern:** Pino with request tracing (UUID), structured logging
**Auto-fields:** timestamp, requestId, userId, duration

### Validation Middleware (`src/middleware/validation.ts`)
**Pattern:** Zod schema validator for Express request bodies

---

# PHASE 2: Detailed MVP Implementation

## Database Schema

All collections use MongoDB with Mongoose ODM. Common patterns:
- Soft deletes via `deletedAt: Date | null` (indexed)
- Timestamps via `createdAt`, `updatedAt` (auto-managed by Mongoose)
- UUIDs for `_id` (generated via `bson.ObjectId`)

### users

```typescript
{
  _id: ObjectId;
  email: string;        // unique, lowercase, indexed
  passwordHash: string; // bcrypt hash
  name: string;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date | null;
}
```

**Indexes:** `{ email: 1 }` (unique), `{ deletedAt: 1 }`

### projects

```typescript
{
  _id: ObjectId;
  userId: ObjectId;
  name: string;
  description: string | null;
  aiOutputId: ObjectId | null;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date | null;
}
```

**Indexes:** `{ userId: 1, createdAt: -1 }`, `{ deletedAt: 1 }`

### links

```typescript
{
  _id: ObjectId;
  userId: ObjectId;
  projectId: ObjectId | null;
  url: string;
  title: string | null;
  aiOutputId: ObjectId | null;
  tags: string[];
  status: 'pending' | 'processing' | 'completed' | 'failed';
  statusMessage: string | null;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date | null;
}
```

**Indexes:** `{ userId: 1, createdAt: -1 }`, `{ userId: 1, projectId: 1, createdAt: -1 }`, `{ deletedAt: 1 }`

### ai_outputs

```typescript
{
  _id: ObjectId;
  sourceType: 'link' | 'project';
  sourceId: ObjectId;
  type: 'summary' | 'flashcards' | 'course' | 'quiz';
  content: object;  // See schema details below
  tokenUsage: { inputTokens: number, outputTokens: number, totalTokens: number };
  createdAt: Date;
  updatedAt: Date;
}
```

**content field by type:**
- `summary`: `{ keyPoints: string[], mainArgument: string, takeaways: string[] }`
- `flashcards`: `{ flashcards: [{ question, answer, difficulty }] }`
- `course`: `{ title, description, lessons: [{ title, content, order }] }`
- `quiz`: `{ questions: [{ question, options, correct, explanation }] }`

**Indexes:** `{ sourceType: 1, sourceId: 1, type: 1 }`, `{ createdAt: -1 }`

### jobs

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
  progress: number;
  data: Record<string, any>;
  failedReason: string | null;
  processedAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
}
```

**Indexes:** `{ userId: 1, status: 1, createdAt: -1 }`, `{ status: 1, createdAt: 1 }`, `{ createdAt: 1 }` (TTL: 7 days)

---

## Phase 2.1: Backend Modules

### Module Structure (All Modules)
```
modules/<name>/
├── <name>.controller.ts    # HTTP handlers
├── <name>.service.ts       # Business logic
├── <name>.module.ts        # DI module (if using NestJS)
├── <name>.schema.ts        # MongoDB schema
└── dto/
    ├── create-<name>.dto.ts
    └── update-<name>.dto.ts
```

### Auth Module
**Endpoints:**
- `POST /auth/register` - Create user, hash password
- `POST /auth/login` - Validate credentials, return JWT pair
- `POST /auth/refresh` - Exchange refresh token for access token
- `GET /auth/me` - Get current user from JWT

**Service Pattern:**
```typescript
register(email, password, name) {
  // Check if user exists
  // Hash password with bcrypt
  // Create user document
  // Return user without passwordHash
}

login(email, password) {
  // Find user by email
  // Compare password with bcrypt
  // Generate JWT pair (access + refresh)
  // Return user + tokens
}

generateTokens(userId) {
  // Sign access token (15min TTL)
  // Sign refresh token (7day TTL)
  // Return { accessToken, refreshToken }
}
```

### Link Module
**Endpoints:**
- `GET /links` - List user's links (paginated, by project optional)
- `POST /links` - Create link, queue AI processing
- `GET /links/:id` - Get link with AI output
- `PUT /links/:id` - Update link
- `DELETE /links/:id` - Soft delete link

**Service Pattern:**
```typescript
createLink(userId, { url, projectId, tags }) {
  // Validate URL format
  // Fetch page title/metadata
  // Create link document with status: "pending"
  // Queue job: process_link
  // Return link + jobId
}

getLink(linkId) {
  // Find link, populate aiOutput
  // Return link with summary, flashcards
}
```

### Project Module
**Endpoints:**
- `GET /projects` - List user's projects
- `POST /projects` - Create project
- `GET /projects/:id` - Get project with links
- `PUT /projects/:id` - Update project
- `DELETE /projects/:id` - Soft delete project
- `POST /projects/:id/generate-course` - Trigger course generation

**Service Pattern:**
```typescript
createProject(userId, { name, description }) {
  // Create project document
  // Return project
}

getProjectWithLinks(projectId, userId) {
  // Find project, verify ownership
  // Populate links with aiOutput
  // Return project with links array
}

generateCourse(projectId) {
  // Find project with completed links
  // Validate has summaries
  // Queue job: generate_course
  // Return jobId
}
```

### AI Module
**Service Pattern:**
```typescript
processLink(url) {
  // Extract content via Playwright/Cheerio
  // Call generateSummary(content)
  // Call generateFlashcards(content)
  // Return { summary, flashcards }
}

generateSummary(content) {
  // Call OpenAI with summary prompt
  // Parse JSON response
  // Validate structure
  // Return { keyPoints, mainArgument, takeaways }
}

generateFlashcards(content) {
  // Call OpenAI with flashcard prompt
  // Parse JSON response
  // Validate 5-10 Q&A pairs
  // Return [{ question, answer, difficulty }]
}

generateCourse(summaries[]) {
  // Combine all summaries
  // Call OpenAI with course prompt
  // Parse { title, description, lessons }
  // Return course structure
}

generateQuiz(courseContent) {
  // Call OpenAI with quiz prompt
  // Parse { questions[] }
  // Validate 5-15 questions
  // Return [{ question, options, correct, explanation }]
}
```

**Prompt Patterns:**
```typescript
// Summary prompt
`Summarize the following content in JSON format:
{ keyPoints: string[], mainArgument: string, takeaways: string[] }
Content: ${content}`

// Flashcard prompt
`Generate 5-10 flashcards in JSON format:
{ flashcards: [{ question: string, answer: string, difficulty: 'easy'|'medium'|'hard' }] }
Content: ${content}`

// Course prompt
`Synthesize a course from these summaries in JSON format:
{ title, description, lessons: [{ title, content, order }] }
Summaries: ${summaries}`

// Quiz prompt
`Generate a quiz in JSON format:
{ questions: [{ question, options: string[], correct: number, explanation }] }
Course: ${courseContent}`
```

### Job Module
**Queue Names:** `l2l:process_link`, `l2l:generate_course`, `l2l:failed_jobs`

**Queue Configuration:**
- Attempts: 3, Exponential backoff (2s base), Remove on complete: 100
- Worker concurrency: 5

**Worker Pattern:**
```typescript
// process-link.worker.ts
processJob(job) {
  // Update job status: "processing"
  // Call aiService.processLink(job.data.url)
  // Store ai_output document
  // Update link status: "completed"
  // Update job status: "completed"
  // Emit notification event
}

// generate-course.worker.ts
processJob(job) {
  // Update job status: "processing", progress: 0
  // Fetch all link summaries for project
  // Call aiService.generateCourse(summaries)
  // Call aiService.generateQuiz(course)
  // Store ai_output for project
  // Update project.aiOutputId
  // Update job status: "completed", progress: 100
  // Emit notification event
}
```

**Retry Logic:**
```typescript
onJobFailed(job, error) {
  // If attempts < maxAttempts: retry with backoff
  // If max attempts reached: move to DLQ
  // Update job status: "failed"
  // Emit notification event
}
```

---

## Phase 2.2: Flutter App Implementation

### Core Setup

**API Constants (`lib/core/constants/api_constants.dart`):**
- baseUrl, connectTimeout, receiveTimeout

**Dio Client (`lib/core/network/dio_client.dart`):**
- Base HTTP client with interceptors
- Auth interceptor: adds Bearer token, handles 401 refresh
- Log interceptor: request/response logging

**Secure Storage (`lib/core/storage/secure_storage.dart`):**
- Store JWT tokens securely

### Auth Feature

**Provider Pattern:**
```dart
// AuthState
enum AuthStatus { initial, loading, authenticated, unauthenticated }
class AuthState { status, user, error }

// AuthNotifier
class AuthNotifier extends StateNotifier<AuthState> {
  login(email, password) { /* call API, update state */ }
  register(name, email, password) { /* call API, update state */ }
  logout() { /* clear tokens, update state */ }
}
```

**Login Screen Pattern:**
```dart
LoginScreen {
  // Form with email, password fields
  // Validate on submit
  // Call authNotifier.login()
  // Navigate to projects on success
  // Show error on failure
}
```

### Project Feature

**Provider Pattern:**
```dart
// ProjectState
class ProjectState { projects[], selectedProject, isLoading, error }

// ProjectNotifier
class ProjectNotifier extends StateNotifier<ProjectState> {
  fetchProjects() { /* GET /projects */ }
  createProject(name, description) { /* POST /projects */ }
  getProject(id) { /* GET /projects/:id */ }
  generateCourse(id) { /* POST /projects/:id/generate-course */ }
}
```

### Link Feature

**Provider Pattern:**
```dart
// LinkState
class LinkState { links[], selectedLink, isLoading, error, nextCursor }

// LinkNotifier
class LinkNotifier extends StateNotifier<LinkState> {
  fetchLinks({projectId, cursor}) { /* GET /links */ }
  saveLink(url, projectId, tags) { /* POST /links */ }
  getLink(id) { /* GET /links/:id */ }
}
```

### App Router (`lib/routing/app_router.dart`)
**Pattern:** GoRouter with auth redirect
- Unauthenticated → redirect to `/login`
- Routes: `/login`, `/register`, `/projects`, `/projects/:id`, `/projects/:id/links/:linkId`

### Main Entry Point (`lib/main.dart`)
- Initialize Hive, secure storage
- Wrap with ProviderScope
- Set up MaterialApp with router

---

## Phase 2.3: Chrome Extension Implementation

### Background Service Worker (`src/background/index.ts`)
**Pattern:**
```typescript
// On installed: create context menu
chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({ title: 'Save to L2L', contexts: ['link', 'page'] })
})

// On context menu click: save link
chrome.contextMenus.onClicked.addListener(async (info) => {
  // Get tokens from storage
  // Call API /links with URL
  // Show notification on success
})

// Handle messages from popup
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  // SAVE_LINK, GET_CURRENT_PAGE handlers
})
```

### Popup UI (`src/popup/index.tsx`)
**Pattern:**
```typescript
Popup {
  // State: url, title, projects[], selectedProject, tags
  // useEffect: load current tab info, fetch projects
  // handleSave: send SAVE_LINK message to background
  // Render: form with inputs for URL, title, project dropdown, tags
}
```

### Message Protocol (`src/shared/protocol.ts`)
**Pattern:**
```typescript
// Message types: SAVE_LINK, GET_CURRENT_PAGE, TOKEN_UPDATE
// Type-safe wrapper: sendMessage<T, R>(type, payload)
```

---

# PHASE 3: Enhancement & Complete MVP

## Phase 3.1: Backend Testing

**Jest Configuration:**
- Coverage threshold: 70% (branches, functions, lines, statements)
- Test environment: node
- Collect coverage from: `src/**/*.ts`

**Mock Strategy:**
- MSW for OpenAI API mocks
- mongodb-memory-server for integration tests
- Fishery factories for test data generation

**Test Structure:**
```
tests/
├── unit/           # Service tests with mocks
├── integration/    # API endpoint tests
└── e2e/           # Critical flow tests
```

---

## Phase 3.2: CI/CD Configuration

**GitHub Actions Workflow:**
```yaml
name: Backend CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    services: mongodb, redis
    steps: checkout, setup node, npm ci, npm test, upload coverage

  build:
    runs-on: ubuntu-latest
    steps: checkout, setup node, npm run build, build docker, push to registry

  deploy:
    needs: [test, build]
    runs-on: ubuntu-latest
    if: branch == main
    steps: deploy to ECS Fargate
```

---

## Phase 3.3: Docker Configuration

**Backend Dockerfile (Multi-stage):**
```dockerfile
# Stage 1: Dependencies
FROM node:20 AS deps
COPY package*.json ./
RUN npm ci

# Stage 2: Build
FROM node:20 AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# Stage 3: Production
FROM node:20-slim AS runner
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
USER nodejs
EXPOSE 8080
CMD ["node", "dist/main.js"]
```

---

## Verification Checklist

### Phase 1 (Foundation)
- [ ] Docker Compose starts MongoDB and Redis
- [ ] Backend `npm run dev` starts without errors
- [ ] Backend `/health` returns 200
- [ ] Flutter app launches in Chrome
- [ ] Chrome extension loads in `chrome://extensions/`

### Phase 2 (MVP Features)
- [ ] User can register and login via API
- [ ] JWT tokens are issued and validated
- [ ] User can create/list/update/delete projects
- [ ] User can create/list/update/delete links
- [ ] Links trigger AI processing jobs
- [ ] AI generates summaries and flashcards
- [ ] User can trigger course generation
- [ ] Flutter app displays projects and links
- [ ] Chrome extension saves links

### Phase 3 (Complete Product)
- [ ] Backend tests pass with >70% coverage
- [ ] Flutter widget tests pass
- [ ] GitHub Actions workflow succeeds
- [ ] Docker image builds and runs
- [ ] End-to-end flow works: register → save link → view AI output → generate course

---

## Appendix A: API Endpoints

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/auth/register` | No | Register user |
| POST | `/auth/login` | No | Login user |
| POST | `/auth/refresh` | No | Refresh token |
| GET | `/auth/me` | Yes | Current user |
| GET | `/projects` | Yes | List projects |
| POST | `/projects` | Yes | Create project |
| GET | `/projects/:id` | Yes | Get project |
| PUT | `/projects/:id` | Yes | Update project |
| DELETE | `/projects/:id` | Yes | Delete project |
| POST | `/projects/:id/generate-course` | Yes | Generate course |
| GET | `/links` | Yes | List links |
| POST | `/links` | Yes | Create link |
| GET | `/links/:id` | Yes | Get link |
| PUT | `/links/:id` | Yes | Update link |
| DELETE | `/links/:id` | Yes | Delete link |
| GET | `/jobs/:jobId` | Yes | Job status |

---

## Appendix B: Database Collections

| Collection | Purpose | Key Indexes |
|------------|---------|-------------|
| `users` | User accounts | `email` (unique), `deletedAt` |
| `projects` | Learning projects | `userId + createdAt`, `deletedAt` |
| `links` | Saved URLs | `userId + projectId + createdAt`, `deletedAt` |
| `ai_outputs` | AI content | `sourceType + sourceId + type` |
| `jobs` | Async jobs | `userId + status`, `createdAt` (TTL) |

---

## Appendix C: Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `NODE_ENV` | No | `development` | Environment |
| `PORT` | No | `3000` | API port |
| `MONGODB_URI` | Yes | - | MongoDB connection |
| `REDIS_HOST` | No | `localhost` | Redis host |
| `REDIS_PORT` | No | `6379` | Redis port |
| `OPENAI_API_KEY` | Yes | - | OpenAI API key |
| `JWT_SECRET` | Yes | - | JWT secret (32+ chars) |
| `JWT_ACCESS_TTL` | No | `15m` | Access token expiry |
| `JWT_REFRESH_TTL` | No | `7d` | Refresh token expiry |

---

**Document End**
