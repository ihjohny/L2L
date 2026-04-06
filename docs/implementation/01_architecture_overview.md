# L2L (Link to Learn) - Section 1: Architecture Overview

**Version:** 1.0
**Date:** March 2026

---

## Section 1: Architecture Overview

### Section Purpose
This section provides a complete architectural blueprint of the L2L platform, including system diagrams, component responsibilities, data flows, and key architectural decisions with rationale.

### 1.1 System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              CLIENT LAYER                                   │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────────┐  │
│  │   iOS App       │  │  Android App    │  │      Web App                │  │
│  │   (Flutter)     │  │  (Flutter)      │  │      (Flutter Web)          │  │
│  │                 │  │                 │  │                             │  │
│  │  • Share Sheet  │  │  • Share Intent │  │  • Responsive UI            │  │
│  │  • Offline      │  │  • Offline      │  │  • PWA Support              │  │
│  └────────┬────────┘  └────────┬────────┘  └──────────────┬──────────────┘  │
│           │                    │                          │                 │
│           └────────────────────┴──────────────────────────┘                 │
│                                    │                                        │
│                    ┌───────────────┴───────────────┐                        │
│                    │   Chrome Extension (MV3)      │                        │
│                    │   • Background Worker         │                        │
│                    │   • Content Script            │                        │
│                    │   • Popup UI                  │                        │
│                    └───────────────┬───────────────┘                        │
└────────────────────────────────────┼────────────────────────────────────────┘
                                     │ HTTPS/REST
                                     ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              API LAYER                                      │
│  ┌─────────────────────────────────────────────────────────────────────────┐│
│  │              API Gateway / Load Balancer (ALB)                          ││
│  └────────────────────────────────┬────────────────────────────────────────┤│
│                                   │                                         ││
│  ┌────────────────────────────────▼────────────────────────────────────────┐│
│  │           Node.js/Express.js Monolith (ECS Fargate)                     ││
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────┐  ││
│  │  │   Auth   │ │   Link   │ │ Project  │ │    AI    │ │     Job      │  ││
│  │  │  Module  │ │  Module  │ │  Module  │ │  Module  │ │    Module    │  ││
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────────┘  ││
│  │                                                                         ││
│  │  • JWT Authentication  • Rate Limiting  • Input Validation (Zod)        ││
│  │  • Error Handling      • Logging (pino) • OpenTelemetry Tracing         ││
│  └────────────────────────────────┬────────────────────────────────────────┘│
└────────────────────────────────────┼────────────────────────────────────────┘
                                     │
                                     ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          PROCESSING LAYER                                   │
│  ┌─────────────────────────────────┐  ┌─────────────────────────────────┐   │
│  │   Async Job Queue (BullMQ)      │  │   AI Processing Workers         │   │
│  │   • process_link queue          │  │   • Content Extractor           │   │
│  │   • generate_course queue       │  │   • OpenAI Summarizer           │   │
│  │   • notify queue                │  │   • Flashcard Generator         │   │
│  │   • Concurrency: 5              │  │   • Course Synthesizer          │   │
│  │   • Max Retries: 3              │  │   • Quiz Generator              │   │
│  │   • DLQ: failed_jobs            │  │                                 │   │
│  └───────────────┬─────────────────┘  └───────────────┬─────────────────┘   │
│                  │                                     │                     │
│                  └─────────────────┬───────────────────┘                     │
│                                    │                                         │
│                    ┌───────────────▼───────────────┐                         │
│                    │   External AI Services        │                         │
│                    │   • OpenAI API (GPT-4o)       │                         │
│                    │   • Content Scraper fallback  │                         │
│                    └───────────────────────────────┘                         │
└─────────────────────────────────────────────────────────────────────────────┘
                                     │
                                     ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                            DATA LAYER                                       │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────────┐  │
│  │   MongoDB Atlas │  │   Redis         │  │   AWS S3                    │  │
│  │   (Primary DB)  │  │   (Cache/Queue) │  │   (Assets/Thumbnails)       │  │
│  │                 │  │                 │  │                             │  │
│  │  • users        │  │  • Sessions     │  │  • Link thumbnails          │  │
│  │  • projects     │  │  • Rate limits  │  │  • Export files             │  │
│  │  • links        │  │  • Job queues   │  │  • Static assets            │  │
│  │  • ai_outputs   │  │  • Cache        │  │                             │  │
│  │  • jobs         │  │                 │  │                             │  │
│  └─────────────────┘  └─────────────────┘  └─────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1.2 Component Responsibilities

| Component | Technology | Responsibility | Phase |
|-----------|------------|----------------|-------|
| **Mobile App (iOS/Android)** | Flutter | User interface, offline caching, share sheet integration, biometric auth | MVP |
| **Web App** | Flutter Web | Responsive browser interface, PWA capabilities, desktop experience | MVP |
| **Chrome Extension** | TypeScript, MV3 | One-click link saving, background sync, popup UI | MVP |
| **API Gateway (ALB)** | AWS ALB | Load balancing, SSL termination, health checks | MVP |
| **Backend Monolith** | Node.js + Express | Business logic, API endpoints, authentication, AI orchestration | MVP |
| **Auth Module** | JWT + bcrypt | User registration, login, token refresh, password reset | MVP |
| **Link Module** | Express + MongoDB | CRUD operations, URL validation, metadata extraction | MVP |
| **Project Module** | Express + MongoDB | Project CRUD, link aggregation, course generation trigger | MVP |
| **AI Module** | OpenAI API + Playwright | Content extraction, summarization, flashcard/course/quiz generation | MVP |
| **Job Module** | BullMQ + Redis | Async job queue, retry logic, dead-letter handling | MVP |
| **MongoDB** | MongoDB Atlas | Primary data store for all entities | MVP |
| **Redis** | ElastiCache | Session cache, rate limiting, BullMQ queue backend | MVP |
| **S3** | AWS S3 | Link thumbnails, exported content, static assets | MVP |
| **CloudFront** | AWS CDN | Global content delivery for static assets | P2 |
| **Sentry** | Sentry SDK | Error tracking, performance monitoring | MVP |
| **Stripe** | Stripe API | Subscription management, payment processing | P2 |

### 1.3 Sync vs. Async Interaction Map

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         SYNCHRONOUS REQUESTS                                │
│                         (Response < 500ms p95)                              │
└─────────────────────────────────────────────────────────────────────────────┘

User Action                          →  API Endpoint              →  Response
─────────────────────────────────────────────────────────────────────────────
Login/Register                       →  POST /api/v1/auth/*       →  JWT + User
Get Projects List                    →  GET /api/v1/projects      →  Project[]
Get Link with AI Output              →  GET /api/v1/links/:id     →  Link + AI
Create/Update Project                →  POST/PUT /api/v1/projects →  Project
Create/Delete Link                   →  POST/DELETE /api/v1/links →  Link + Job
Trigger Course Generation            →  POST /api/v1/projects/:id/generate-course-quiz → Job
Get Job Status                       →  GET /api/v1/jobs/:jobId   →  Job Status

┌─────────────────────────────────────────────────────────────────────────────┐
│                        ASYNCHRONOUS JOBS                                    │
│                        (Processing time varies)                             │
└─────────────────────────────────────────────────────────────────────────────┘

Job Type                →  Queue Name        →  Expected Duration  →  Notification
─────────────────────────────────────────────────────────────────────────────────
process_link            →  process_link      →  5-15 seconds       →  WebSocket/Push
generate_course_quiz    →  generate_course   →  15-45 seconds      →  WebSocket/Push
export_data             →  export_data       →  30-120 seconds     →  Email [P2]
```

### 1.4 Data Flow Narratives

#### Journey 1: User Saves Link → AI Processes → Result Delivered

```
1. USER ACTION (Flutter/Extension)
   │
   ├─> User shares URL via mobile share sheet OR clicks extension save button
   ├─> Optionally selects Project and adds Tags
   └─> Submits to API
   │
   ▼
2. API LAYER (POST /api/v1/links)
   │
   ├─> JWT authentication middleware validates token
   ├─> Zod schema validates URL format
   ├─> Link Service creates link document with status: "pending"
   ├─> Returns { link, job_id } immediately (200 OK)
   └─> Queues job to BullMQ
   │
   ▼
3. JOB QUEUE (process_link queue)
   │
   ├─> BullMQ worker picks up job (concurrency: 5)
   ├─> Updates job status: "processing"
   └─> Calls AI Processing Service
   │
   ▼
4. AI PROCESSING PIPELINE
   │
   ├─> Content Fetcher (Playwright) loads URL
   │   ├─> Executes JavaScript for dynamic content
   │   ├─> Extracts main content with Cheerio
   │   └─> Handles paywalls/errors gracefully
   │
   ├─> OpenAI Summarizer
   │   ├─> Sends extracted content to GPT-4o
   │   ├─> Receives structured summary (key points, main argument, takeaways)
   │   └─> Validates output format
   │
   ├─> OpenAI Flashcard Generator
   │   ├─> Sends content to GPT-4o
   │   ├─> Receives 5-10 Q&A pairs
   │   └─> Validates each flashcard for quality
   │
   └─> Stores results in MongoDB
       └─> Updates link status: "completed"
   │
   ▼
5. NOTIFICATION
   │
   ├─> Job Module emits "job_completed" event
   ├─> WebSocket server pushes to connected clients
   ├─> Mobile push notification (if enabled)
   └─> Updates job document with result
   │
   ▼
6. USER RECEIVES RESULT
   │
   ├─> Flutter app receives push notification
   ├─> Polls GET /api/v1/jobs/:jobId
   ├─> Displays "Processing Complete" with summary preview
   └─> User can now view summary and flashcards
```

**NFR Mapping:**
- API response time < 500ms: Step 2 returns immediately
- AI processing < 30s: Steps 4 completes within SLA
- Crash-free > 99%: Retry logic in Step 4, DLQ for failures

#### Journey 2: User Triggers "Generate Course" → Synthesized from Summaries

```
1. USER ACTION (Flutter App)
   │
   ├─> User navigates to Project detail view
   ├─> Sees list of processed links with summaries
   ├─> Taps "Generate Course" button
   └─> Confirms generation (shows token cost estimate)
   │
   ▼
2. API LAYER (POST /api/v1/projects/:id/generate-course-quiz)
   │
   ├─> Validates project ownership
   ├─> Checks project has ≥1 link with completed AI output
   ├─> Creates job document with type: "generate_course"
   ├─> Returns { job_id } immediately (202 Accepted)
   └─> Queues job to BullMQ
   │
   ▼
3. JOB QUEUE (generate_course queue)
   │
   ├─> Worker picks up job (lower priority than link processing)
   ├─> Updates job status: "processing", progress: 0
   └─> Calls Project AI Service
   │
   ▼
4. COURSE SYNTHESIS PIPELINE
   │
   ├─> Fetches all link summaries in project
   │   └─> Aggregates content from all ai_outputs
   │
   ├─> OpenAI Course Generator
   │   ├─> Sends aggregated summaries to GPT-4o
   │   ├─> Receives structured course:
   │   │   └─> { title, description, lessons: [{title, content, order}] }
   │   └─> Validates course structure (3-8 lessons)
   │
   ├─> OpenAI Quiz Generator
   │   ├─> Sends course content to GPT-4o
   │   ├─> Receives quiz: { questions: [{question, options, correct, explanation}] }
   │   └─> Validates 5-15 questions based on content volume
   │
   └─> Stores results in MongoDB
       └─> Updates project.ai_output_id
   │
   ▼
5. NOTIFICATION & COMPLETION
   │
   ├─> Updates job status: "completed", progress: 100
   ├─> Pushes notification to user
   └─> Course ready for consumption
```

#### Journey 3: User Completes Quiz → Score Recorded, Streak Updated [P2]

```
1. USER ACTION (Flutter App)
   │
   ├─> User navigates to Course detail view
   ├─> Completes all lessons
   ├─> Taps "Take Quiz" button
   └─> Answers questions sequentially
   │
   ▼
2. QUIZ SUBMISSION (POST /api/v1/quizzes/:id/submit)
   │
   ├─> Validates quiz answers
   ├─> Calculates score (correct / total)
   ├─> Records quiz_attempt document
   └─> Returns { score, correct_count, total, explanations }
   │
   ▼
3. ANALYTICS SERVICE [P2]
   │
   ├─> Records analytics_event: "quiz_completed"
   ├─> Updates user statistics:
   │   ├─> quizzes_taken++
   │   ├─> average_score = recalculate()
   │   └─> last_activity_date = now
   │
   └─> Gamification Engine
       ├─> Awards points: score * 10
       ├─> Checks and updates streak
       ├─> Unlocks achievements if thresholds met
       └─> Triggers notification for milestones
   │
   ▼
4. USER FEEDBACK
   │
   ├─> Displays score with celebration animation
   ├─> Shows detailed breakdown per question
   ├─> Updates dashboard with new points/streak
   └─> Suggests next learning action
```

### 1.5 Architectural Decisions & Rationale

| Decision | Choice | Rationale | Trade-offs |
|----------|--------|-----------|------------|
| **Architecture Style** | Monolith-first (MVP) → Microservices (P3) | Faster iteration, simpler deployment, lower operational overhead for MVP team | Technical debt to manage; refactoring required for P3 |
| **Database** | MongoDB Atlas | Flexible schema for AI outputs, rapid iteration, built-in scaling | No ACID transactions across collections; eventual consistency |
| **Queue System** | BullMQ + Redis | Native Node.js integration, priority queues, built-in retry/DLQ | Redis becomes single point of failure without cluster |
| **Frontend Framework** | Flutter | Single codebase for iOS/Android/Web, consistent UI, fast development | Web performance slightly below React; larger bundle size |
| **AI Provider** | OpenAI API (GPT-4o) | Best quality for summarization/course generation, reliable API | Vendor lock-in, cost variability, rate limits |
| **Authentication** | JWT (stateless) | Scales horizontally, works across mobile/web/extension | Token revocation requires blocklist or short expiry |
| **Content Extraction** | Playwright + Cheerio | Handles JS-heavy sites (Playwright) + fast static parsing (Cheerio) | Playwright resource-intensive; need pool management |
| **Hosting** | AWS ECS Fargate | Serverless containers, auto-scaling, pay-per-use | Cold starts; less control than EC2 |

### 1.6 NFRs Mapped to Architecture

| NFR | Target | Architecture Decision | Implementation Detail |
|-----|--------|----------------------|----------------------|
| **API Latency** | p95 < 500ms | Redis caching, MongoDB indexing, connection pooling | Cache frequent queries; compound indexes on userId + createdAt |
| **AI Processing** | < 30s per link | BullMQ concurrency, parallel API calls | 5 concurrent workers; batch OpenAI requests when possible |
| **Crash-free** | > 99% | Error boundaries, retry logic, graceful degradation | 3 retries with exponential backoff; fallback content extraction |
| **Coverage** | > 70% | Jest + flutter_test, CI enforcement | `--coverageThreshold '{"global":70}'` in Jest config |
| **Availability** | 99.9% | Multi-AZ deployment, health checks, auto-scaling | ECS service across 2 AZs; ALB health check every 30s |
| **Scalability** | 10K concurrent | Horizontal scaling, stateless API, read replicas | ECS auto-scaling at 70% CPU; MongoDB read replicas for analytics |

> ⚠️ **ASSUMPTIONS:**
> - Team has prior Node.js and Flutter experience
> - MongoDB Atlas free tier sufficient for MVP beta (≤1K users)
> - OpenAI API costs manageable at MVP scale (~$500/mo for 1K users)
> - AWS credits available for startup (reduces infrastructure cost)
>
> 🚩 **RISKS & OPEN DECISIONS:**
> - **Risk:** Playwright memory leaks under high load → **Mitigation:** Worker pool with restart policy, monitor RSS
> - **Risk:** OpenAI rate limits during peak → **Mitigation:** Request queuing, exponential backoff, upgrade to higher tier
> - **Risk:** Flutter Web SEO limitations → **Mitigation:** Accept for MVP; PWA focus, not SEO-driven
> - **Decision:** Vector database for P3 RAG → **Pending:** Evaluate Pinecone vs. Weaviate vs. MongoDB Atlas Search

---

---

*[← Back to Index](README.md)* | [Next: Implementation Details →](./02_implementation_details.md)*

