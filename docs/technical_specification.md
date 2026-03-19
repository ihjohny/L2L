# L2L (Link to Learn) - Technical Specification

## Document Information
- **Version:** 2.0
- **Date:** March 2026
- **Status:** Draft
- **Product:** L2L (Link to Learn)

---

## 1. Executive Summary

This document provides a high-level technical overview of the L2L platform architecture. It outlines the core system components, data flows, and technology choices required to deliver the two-tier AI processing pipeline (per-link and per-project) across multiple platforms.

**Note:** This specification focuses on architectural clarity. Detailed implementation specifications will be created during development sprints.

---

## 2. System Architecture Overview

### 2.1 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Client Layer                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────────────┐  │
│  │  Mobile  │  │   Web    │  │   Chrome Extension       │  │
│  │  (Flutter)│  │(Flutter) │  │   (JavaScript)          │  │
│  └──────────┘  └──────────┘  └──────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    API Layer                                │
│  ┌─────────────────────────────────────────────────────────┐│
│  │           REST API (Node.js/Express.js)                ││
│  │        Authentication │ Rate Limiting │ Validation     ││
│  └─────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                 Processing Layer                            │
│  ┌─────────────────────┐  ┌─────────────────────────────┐  │
│  │   Link Processor    │  │   Project Processor         │  │
│  │   (Summary +        │  │   (Course + Quiz from       │  │
│  │    Flashcards)      │  │    multiple summaries)      │  │
│  └─────────────────────┘  └─────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   Data Layer                                │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────────────┐  │
│  │ MongoDB  │  │  Redis   │  │   Object Storage (S3)   │  │
│  │(Primary) │  │ (Cache)  │  │   (Thumbnails, Assets)  │  │
│  └──────────┘  └──────────┘  └──────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Architecture Principles

1. **Monolithic First (MVP):** Start with a well-structured monolith for rapid iteration
2. **Two-Tier Processing:** Separate pipelines for link-level and project-level AI processing
3. **Async-First Design:** All AI processing happens asynchronously with job queues
4. **Cross-Platform Consistency:** Flutter ensures consistent UI/UX across mobile and web

---

## 3. Core System Components

### 3.1 Client Applications

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Mobile App** | Flutter (iOS/Android) | Native apps with share sheet integration |
| **Web App** | Flutter Web | Responsive web application |
| **Chrome Extension** | JavaScript/TypeScript | One-click link saving |

### 3.2 Backend Services (MVP Monolith)

| Service | Responsibility |
|---------|----------------|
| **Auth Service** | User registration, login, JWT session management |
| **Link Service** | CRUD operations for saved links/entities |
| **Project Service** | Project management, tag assignment, entity aggregation |
| **AI Processing Service** | Two-tier AI pipeline (per-link and per-project) |
| **Content Service** | Processed content delivery (summaries, flashcards, courses, quizzes) |

### 3.3 External Integrations

| Service | Provider | Purpose |
|---------|----------|---------|
| **AI/LLM** | OpenAI API | Content summarization, flashcard generation, course/quiz synthesis |
| **Content Fetching** | Custom scraper | Extract page content from saved URLs |
| **Object Storage** | AWS S3 / Compatible | Store thumbnails and extracted assets |

---

## 4. Data Model

### 4.1 Core Entities

```
┌─────────────────────────────────────────────────────────────┐
│                         User                                │
│  id, email, passwordHash, createdAt, subscriptionTier       │
└─────────────────────────────────────────────────────────────┘
                              │
         ┌────────────────────┴────────────────────┐
         │                                         │
         ▼                                         ▼
┌─────────────────────────────────┐   ┌─────────────────────────┐
│           Project               │   │           Link          │
│  id, userId, name, tags[],      │   │  id, userId, projectId, │
│  entityIds[], aiOutputId        │   │  url, rawContent,       │
│                                 │   │  tags[], aiOutputId,    │
│  AI Output (Project):           │   │  status, metadata       │
│  - course { lessons[] }         │   │                         │
│  - quiz { questions[], score }  │   │  AI Output (Link):      │
│                                 │   │  - summary              │
│                                 │   │  - flashcards[]         │
│                                 │   │                         │
└─────────────────────────────────┘   └─────────────────────────┘
```

### 4.2 Key Data Relationships

- **User → Projects:** One-to-many (users own multiple projects)
- **User → Links:** One-to-many (users save multiple links)
- **Project → Links:** One-to-many (projects contain multiple links)
- **Link → AI Output:** One-to-one (each link has its own summary + flashcards)
- **Project → AI Output:** One-to-one (each project has course + quiz synthesized from its links)

---

## 5. AI Processing Pipeline

### 5.1 Per-Link Processing (Automatic)

```
User saves link
       │
       ▼
Fetch & extract page content
       │
       ▼
OpenAI API → Generate Summary + Flashcards
       │
       ▼
Store results in MongoDB (linked to entity)
       │
       ▼
Notify user: Processing complete
```

**Trigger:** Automatic on link save
**Outputs:** Summary, Flashcards (5-10 Q&A pairs)
**Latency Expectation:** 5-15 seconds

### 5.2 Per-Project Processing (User-Triggered)

```
User clicks "Generate Course" on Project
       │
       ▼
Fetch all link summaries in project
       │
       ▼
OpenAI API → Synthesize Course + Quiz
(from combined summaries)
       │
       ▼
Store results in MongoDB (linked to project)
       │
       ▼
Notify user: Course ready
```

**Trigger:** User action ("Generate Course" button)
**Outputs:** Course (multi-lesson curriculum), Quiz (comprehension questions)
**Latency Expectation:** 15-45 seconds (depends on number of sources)

### 5.3 AI Processing Service

```python
class AIProcessingService:
    """
    Handles both per-link and per-project AI processing.
    Uses job queue for async processing.
    """

    async def process_link(self, link_id: str) -> JobResult:
        # 1. Fetch raw content
        content = await self.content_fetcher.fetch(link_id)

        # 2. Generate summary
        summary = await self.openai.generate_summary(content)

        # 3. Generate flashcards
        flashcards = await self.openai.generate_flashcards(content)

        # 4. Store results
        return await self.store_link_output(link_id, summary, flashcards)

    async def generate_course(self, project_id: str) -> JobResult:
        # 1. Fetch all link summaries in project
        summaries = await self.get_project_summaries(project_id)

        # 2. Synthesize course structure
        course = await self.openai.generate_course(summaries)

        # 3. Generate quiz from course
        quiz = await self.openai.generate_quiz(course)

        # 4. Store results
        return await self.store_project_output(project_id, course, quiz)
```

---

## 6. API Design

### 6.1 Core Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/auth/register` | User registration |
| `POST` | `/api/auth/login` | User login |
| `GET` | `/api/auth/me` | Get current user |
| `POST` | `/api/links` | Save a new link |
| `GET` | `/api/links` | List user's links (filtered by project/tags) |
| `GET` | `/api/links/:id` | Get link with AI output |
| `DELETE` | `/api/links/:id` | Delete a link |
| `POST` | `/api/projects` | Create a project |
| `GET` | `/api/projects` | List user's projects |
| `GET` | `/api/projects/:id` | Get project with links and AI output |
| `POST` | `/api/projects/:id/generate-course` | Trigger course generation |
| `PUT` | `/api/projects/:id` | Update project |
| `DELETE` | `/api/projects/:id` | Delete project |

### 6.2 Job Status Endpoint

```
GET /api/jobs/:jobId

Response:
{
  "jobId": "abc123",
  "type": "process_link" | "generate_course",
  "status": "pending" | "processing" | "completed" | "failed",
  "progress": 0-100,
  "result": { ... } | null,
  "error": "..." | null
}
```

---

## 7. Technology Stack

### 7.1 MVP Stack (Months 1-6)

| Layer | Technology | Rationale |
|-------|------------|-----------|
| **Frontend** | Flutter | Single codebase for iOS, Android, Web |
| **Backend** | Node.js + Express.js | Fast development, familiar ecosystem |
| **Database** | MongoDB | Flexible schema, good for content |
| **Cache** | Redis | Job queues, session caching |
| **AI** | OpenAI API | Best-in-class language understanding |
| **Hosting** | AWS / VPS | Scalable infrastructure |

### 7.2 Post-MVP Considerations (Months 7+)

| Component | Potential Evolution |
|-----------|---------------------|
| **Backend** | Microservices separation (AI service, content service) |
| **Database** | Vector database for semantic search (Phase 3) |
| **AI** | Fine-tuned models for cost optimization |
| **Mobile** | Native platform optimizations if Flutter limits discovered |

---

## 8. Security Architecture

### 8.1 Authentication

- **Method:** JWT-based authentication
- **Token Storage:** HTTP-only cookies (web), secure storage (mobile)
- **Session Management:** Redis-backed session invalidation

### 8.2 Data Protection

| Area | Approach |
|------|----------|
| **Passwords** | bcrypt hashing with salt |
| **API Communication** | HTTPS/TLS 1.3 |
| **Database** | Connection-level authentication, network isolation |
| **Sensitive Data** | Encryption at rest via cloud provider |

### 8.3 Rate Limiting

| Tier | Limit |
|------|-------|
| **Free** | 100 requests per 15 minutes |
| **Premium** | 1000 requests per 15 minutes |
| **AI Processing** | Separate queue with fair usage limits |

---

## 9. Scalability Strategy

### 9.1 MVP Scale (Target: 10K users)

- Single well-optimized monolithic backend
- MongoDB with proper indexing
- Redis for caching frequently accessed data
- Horizontal scaling via load balancer (2-4 instances)

### 9.2 Growth Scale (Target: 100K+ users)

| Component | Scaling Approach |
|-----------|------------------|
| **API Layer** | Horizontal scaling with load balancer |
| **Database** | MongoDB read replicas, sharding by userId |
| **Cache** | Redis cluster for distributed caching |
| **AI Processing** | Separate worker pool with auto-scaling |
| **Static Assets** | CDN (CloudFront) for thumbnails and assets |

### 9.3 Microservices Migration (Phase 3+)

When to consider splitting:
- Team size exceeds 10 developers
- AI processing becomes a bottleneck
- Different scaling requirements between services

Target services:
1. **User Service** (auth, profiles)
2. **Content Service** (links, projects CRUD)
3. **AI Service** (async processing pipeline)
4. **Analytics Service** (tracking, reporting)

---

## 10. Infrastructure Overview

### 10.1 Core Components

```
┌─────────────────────────────────────────────────────────────┐
│                     Production Environment                  │
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   App       │  │   App       │  │   App               │ │
│  │   Server 1  │  │   Server 2  │  │   Server N          │ │
│  │  (Node.js)  │  │  (Node.js)  │  │  (Node.js)          │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
│           │               │                    │            │
│           └───────────────┴────────────────────┘            │
│                              │                              │
│              ┌───────────────┴───────────────┐              │
│              ▼                               ▼              │
│     ┌─────────────────┐            ┌─────────────────┐      │
│     │   MongoDB       │            │   Redis         │      │
│     │   (Primary +    │            │   (Cache +      │      │
│     │    Read Replica)│            │    Job Queue)   │      │
│     └─────────────────┘            └─────────────────┘      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 10.2 Key Monitoring Metrics

| Category | Metrics |
|----------|---------|
| **Application** | Request latency, error rate, active users |
| **Database** | Connection count, query latency, replication lag |
| **AI Processing** | Queue depth, processing time, success rate |
| **Infrastructure** | CPU, memory, disk usage per instance |

---

## 11. Development Phases

### 11.1 Phase MVP (Weeks 1-12)

| Week | Focus |
|------|-------|
| 1-4 | Backend foundation: Auth, Link CRUD, Project CRUD |
| 5-8 | AI pipeline: Per-link processing (summary, flashcards) |
| 9-12 | Frontend: Flutter app, Chrome extension, testing |

### 11.2 Phase 2 (Weeks 13-24)

| Week | Focus |
|------|-------|
| 13-16 | Per-project AI processing (course, quiz generation) |
| 17-20 | Progress analytics, consistency heatmap |
| 21-24 | Sharing features, public launch preparation |

### 11.3 Phase 3 (Weeks 25-36)

| Week | Focus |
|------|-------|
| 25-28 | Adaptive learning paths, study schedules |
| 29-32 | Source chatbot (RAG-based Q&A) |
| 33-36 | Spaced repetition, collaborative annotation |

---

## 12. Risk Mitigation

### 12.1 Technical Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| AI processing failures | High | Retry logic, graceful fallbacks, user notifications |
| Content extraction failures | Medium | Multiple extraction strategies, manual input fallback |
| Database performance degradation | High | Proper indexing, query optimization, read replicas |
| Cross-platform sync issues | Medium | Optimistic updates, conflict resolution strategy |

### 12.2 Cost Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| High AI API costs | High | Caching processed content, tiered processing limits |
| Unexpected traffic spikes | Medium | Rate limiting, auto-scaling policies |
| Data storage growth | Low | Compression, archival strategy for old data |

---

## 13. Next Steps

1. **Architecture Validation:** Review data model with development team
2. **AI Pipeline Prototyping:** Test OpenAI API for summary/flashcard/course quality
3. **Infrastructure Setup:** Provision development environment
4. **API Contract Definition:** Finalize endpoint specifications
5. **Development Sprint Planning:** Begin Week 1-4 implementation

---

*This specification will evolve as we gather technical insights during development. Major architectural changes should be documented and reviewed with the team.*
