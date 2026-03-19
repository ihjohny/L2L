# L2L (Link to Learn) - Work Breakdown Structure (WBS)

## Document Information
- **Version:** 2.0
- **Date:** March 2026
- **Project:** L2L Platform Development
- **Status:** Draft

---

## Overview

This WBS aligns with the MVP-first strategy: a well-structured monolith delivering core AI processing (per-link and per-project) across three platforms (mobile, web, extension). Phases 2-3 features are marked as future work.

### MVP Scope (12 Weeks)
- **Platforms:** Mobile (iOS/Android), Web, Chrome Extension
- **Core Features:** Link capture, per-link AI (summary + flashcards), per-project AI (course + quiz)
- **Authentication:** Email/password + JWT
- **Timeline:** Week 1-12 → Closed Beta

---

## 1.0 Project Management

### 1.1 Planning & Coordination
- 1.1.1 Sprint planning and daily standups
- 1.1.2 Risk tracking and mitigation
- 1.1.3 Stakeholder updates (bi-weekly)

### 1.2 Quality & Process
- 1.2.1 Code review process (PR-based)
- 1.2.2 Definition of Done per feature
- 1.2.3 Retrospectives after each sprint

---

## 2.0 Infrastructure & DevOps

### 2.1 Cloud Infrastructure (AWS)
- 2.1.1 AWS account setup
- 2.1.2 VPC and security groups
- 2.1.3 EC2 instances or ECS Fargate (MVP monolith)
- 2.1.4 MongoDB Atlas (managed) or DocumentDB
- 2.1.5 ElastiCache (Redis) for queues and caching
- 2.1.6 S3 for assets (thumbnails, exports)

### 2.2 CI/CD Pipeline
- 2.2.1 GitHub Actions workflows
  - Build and test on PR
  - Deploy to staging on merge
  - Deploy to production on tag
- 2.2.2 Environment management (dev/staging/prod)
- 2.2.3 Docker containerization

### 2.3 Monitoring & Logging
- 2.3.1 Application logging (winston/pino)
- 2.3.2 Error tracking (Sentry)
- 2.3.3 Basic metrics (CPU, memory, request latency)
- 2.3.4 Health check endpoints

### 2.4 Security
- 2.4.1 HTTPS/TLS configuration
- 2.4.2 JWT authentication setup
- 2.4.3 Rate limiting (Redis-backed)
- 2.4.4 Input validation and sanitization

---

## 3.0 Backend Development (Node.js Monolith)

### 3.1 Authentication Service
- 3.1.1 User registration (email/password)
- 3.1.2 User login and JWT token issuance
- 3.1.3 Password hashing (bcrypt)
- 3.1.4 Password reset flow
- 3.1.5 Basic user profile (name, email)

### 3.2 Link Service
- 3.2.1 Create link (URL validation, metadata extraction)
- 3.2.2 Get links (list, filter by project/tags)
- 3.2.3 Get single link with AI output
- 3.2.4 Update link (project assignment, tags)
- 3.2.5 Delete link
- 3.2.6 Status tracking (pending/processing/completed/failed)

### 3.3 Project Service
- 3.3.1 Create project
- 3.3.2 List user projects
- 3.3.3 Get project with links and AI output
- 3.3.4 Update project (name, tags)
- 3.3.5 Delete project
- 3.3.6 Generate course trigger (aggregates link summaries)

### 3.4 AI Processing Service
- 3.4.1 Content fetching
  - Web scraper (Playwright or Cheerio for static)
  - YouTube metadata extraction (if applicable)
  - Error handling for inaccessible content
- 3.4.2 Per-link processing (async job queue)
  - Summary generation (OpenAI)
  - Flashcard generation (5-10 Q&A pairs)
  - Store results in MongoDB
- 3.4.3 Per-project processing (async job queue)
  - Fetch all link summaries in project
  - Synthesize course (multi-lesson structure)
  - Generate quiz from course content
  - Store results in MongoDB
- 3.4.4 Job status API
  - Get job status by ID
  - Progress tracking (0-100%)

### 3.5 Job Queue System
- 3.5.1 Redis Queue (Bull or Agenda) setup
- 3.5.2 Job prioritization
- 3.5.3 Retry logic for failed jobs
- 3.5.4 Job completion notifications

### 3.6 API Layer
- 3.6.1 REST API endpoints (Express.js)
- 3.6.2 Request validation (Joi/Zod)
- 3.6.3 Error handling middleware
- 3.6.4 CORS configuration
- 3.6.5 API documentation (OpenAPI/Swagger)

---

## 4.0 Frontend Development (Flutter)

### 4.1 Core Application Setup
- 4.1.1 Flutter project structure (mobile + web)
- 4.1.2 State management (Provider/Riverpod)
- 4.1.3 Navigation and routing
- 4.1.4 Theme setup (Material Design 3)
- 4.1.5 API client configuration

### 4.2 Authentication Screens
- 4.2.1 Registration form
- 4.2.2 Login form
- 4.2.3 Password reset flow
- 4.2.4 JWT storage and refresh

### 4.3 Dashboard & Project Management
- 4.3.1 Home screen (recent projects, quick actions)
- 4.3.2 Projects list
- 4.3.3 Project creation flow
- 4.3.4 Project detail view (links list, progress)
- 4.3.5 "Generate Course" action

### 4.4 Link Management
- 4.4.1 Manual URL input
- 4.4.2 Links list (filtered by project)
- 4.4.3 Link detail view
- 4.4.4 Processing status indicator
- 4.4.5 AI summary display
- 4.4.6 Flashcards viewer

### 4.5 Learning Interface
- 4.5.1 Summary view (structured, readable)
- 4.5.2 Flashcards carousel (flip animation)
- 4.5.3 Course view (lesson-by-lesson)
- 4.5.4 Quiz interface (multiple choice)
- 4.5.5 Quiz results and feedback
- 4.5.6 Mark as complete action

### 4.6 Web-Specific Features
- 4.6.1 Responsive layout (mobile/tablet/desktop)
- 4.6.2 PWA configuration
- 4.6.3 Browser session persistence

### 4.7 Settings
- 4.7.1 User profile settings
- 4.7.2 Logout
- 4.7.3 Basic preferences (theme)

---

## 5.0 Chrome Extension

### 5.1 Extension Core
- 5.1.1 Manifest V3 configuration
- 5.1.2 Background service worker
- 5.1.3 Popup UI (HTML/CSS/JS)

### 5.2 Save Functionality
- 5.2.1 One-click save button
- 5.2.2 Page metadata extraction (title, URL, description)
- 5.2.3 Project selector
- 5.2.4 Tag input
- 5.2.5 Save confirmation

### 5.3 Authentication
- 5.3.1 Token storage
- 5.3.2 Auto-refresh on expiry

### 5.4 Chrome Web Store
- 5.4.1 Extension listing assets
- 5.4.2 Submission and review

---

## 6.0 Database

### 6.1 MongoDB Schema
- 6.1.1 Users collection
- 6.1.2 Projects collection
- 6.1.3 Links collection
- 6.1.4 AI Outputs collection (embedded or referenced)
- 6.1.5 Jobs collection

### 6.2 Indexing
- 6.2.1 User ID indexes
- 6.2.2 Project ID indexes
- 6.2.3 Text indexes for search

### 6.3 Redis
- 6.3.1 Job queue implementation
- 6.3.2 Session cache
- 6.3.3 Rate limiting counters

---

## 7.0 AI/ML Integration

### 7.1 OpenAI Integration
- 7.1.1 API client setup
- 7.1.2 Prompt engineering for summaries
- 7.1.3 Prompt engineering for flashcards
- 7.1.4 Prompt engineering for courses
- 7.1.5 Prompt engineering for quizzes
- 7.1.6 Error handling and retries

### 7.2 Content Processing
- 7.2.1 HTML to text extraction
- 7.2.2 Main content detection
- 7.2.3 Handling JavaScript-rendered content (Playwright)

### 7.3 Quality & Cost
- 7.3.1 Output validation (basic sanity checks)
- 7.3.2 Token usage tracking
- 7.3.3 Response caching (same URL = same output)

---

## 8.0 Testing

### 8.1 Backend Tests
- 8.1.1 Unit tests (services, utilities)
- 8.1.2 Integration tests (API endpoints)
- 8.1.3 Target: 70% coverage

### 8.2 Frontend Tests
- 8.2.1 Widget tests (Flutter)
- 8.2.2 Integration tests (critical flows)

### 8.3 E2E Tests
- 8.3.1 Mobile critical flows (Detox or manual)
- 8.3.2 Web critical flows (Playwright)
- 8.3.3 Extension (manual testing)

---

## 9.0 Documentation

### 9.1 Technical
- 9.1.1 API documentation (OpenAPI)
- 9.1.2 Architecture overview
- 9.1.3 Local development setup guide

### 9.2 User-Facing
- 9.2.1 Getting started guide
- 9.2.2 Feature tutorials (save link, generate course)
- 9.2.3 FAQ

---

## 10.0 Launch Preparation

### 10.1 Beta Testing
- 10.1.1 Internal testing
- 10.1.2 Closed beta (500-1000 users)
- 10.1.3 Feedback collection mechanism

### 10.2 App/Store Submission
- 10.2.1 Chrome Web Store submission
- 10.2.2 Web app deployment
- 10.2.3 Mobile apps (TestFlight / Play Beta for beta)

### 10.3 Technical Readiness
- 10.3.1 Performance benchmarks (API < 500ms, AI < 30s)
- 10.3.2 Security review
- 10.3.3 Backup/restore test

---

## 11.0 Post-Launch Support

### 11.1 Monitoring
- 11.1.1 Error tracking (Sentry)
- 11.1.2 Performance dashboards
- 11.1.3 User feedback triage

### 11.2 Iteration
- 11.2.1 Bug fixes (priority)
- 11.2.2 Feature improvements based on feedback
- 11.2.3 Sprint planning for Phase 2

---

## Phase 2+ Features (Future Work)

*Not included in MVP (Weeks 1-12)*

### Phase 2 (Weeks 13-24)
- **Organization:** AI-inferred categorization, bulk operations, import/export
- **Analytics:** Personal dashboard, consistency heatmap, quiz history
- **Sharing:** Share links/projects, public view-only pages
- **Enhanced Gamification:** Points, achievements, streaks

### Phase 3 (Weeks 25-36)
- **AI Learning Coach:** Adaptive learning paths, study schedules, SRS for flashcards
- **Source Chatbot:** RAG-based Q&A against saved content
- **Collaboration:** Collaborative annotation, group learning

---

## Timeline Summary

| Phase | Weeks | Focus | Deliverables |
|-------|-------|-------|--------------|
| **MVP Foundation** | 1-4 | Backend core, Auth, Link/Project CRUD | API ready, DB schema, Auth flow |
| **AI Pipeline** | 5-8 | Per-link AI, Job queue, Content fetching | Summaries + Flashcards auto-generated |
| **Frontend + Extension** | 9-12 | Flutter app, Chrome extension, Per-project AI | Closed beta ready |
| **Phase 2** | 13-24 | Analytics, Sharing, Gamification | Public launch |
| **Phase 3** | 25-36 | AI Coach, Chatbot, Collaboration | Advanced features |

---

## Resource Requirements (MVP)

| Role | FTE | Responsibilities |
|------|-----|------------------|
| Backend Developer | 2 | API, AI pipeline, DB |
| Frontend Developer (Flutter) | 2 | Mobile + Web app |
| Extension Developer | 1 | Chrome extension |
| QA Engineer | 1 | Testing (manual + automated) |
| DevOps | 0.5 | Infrastructure, CI/CD |
| Product/Design | 1 | UX, requirements |

**Total:** ~6.5 FTE for 12 weeks

---

## Success Criteria (MVP Launch)

| Metric | Target |
|--------|--------|
| Registered users (closed beta) | 500-1,000 |
| Link processing success rate | > 90% |
| AI processing time (per link) | < 30 seconds |
| API response time | < 500ms |
| User retention (weekly) | > 60% |
| Course generation usage | > 30% of projects |

---

**End of WBS Document**
