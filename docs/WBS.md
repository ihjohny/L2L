# L2L (Link to Learn) - Work Breakdown Structure (WBS)

## Document Information
- **Version:** 3.0
- **Date:** March 2026
- **Project:** L2L Platform Development
- **Status:** Draft

---

## Overview

This WBS is organized by development phase, aligning with the product roadmap:
- **Phase MVP (Weeks 1-12):** Core platform with two-tier AI processing
- **Phase 2 (Weeks 13-24):** Organization, analytics, and sharing
- **Phase 3 (Weeks 25-36):** AI Learning Coach and collaboration

### Architecture Summary
```
┌─────────────────────────────────────────────────────────────┐
│                    Client Layer                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────────────┐  │
│  │  Mobile  │  │   Web    │  │   Chrome Extension       │  │
│  │(Flutter) │  │(Flutter) │  │   (JavaScript)           │  │
│  └──────────┘  └──────────┘  └──────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                 Backend (Node.js Monolith)                  │
│  Auth │ Link │ Project │ AI Processing │ Job Queue         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   Data Layer                                │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────────────┐  │
│  │ MongoDB  │  │  Redis   │  │   S3 (Assets)            │  │
│  └──────────┘  └──────────┘  └──────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

# PHASE MVP (Weeks 1-12) - Closed Beta

**Goal:** Deliver core platform with link capture, per-link AI (summary + flashcards), and per-project AI (course + quiz).

---

## MVP-1.0 Project Management

### MVP-1.1 Planning & Coordination
- MVP-1.1.1 Sprint planning (2-week sprints)
- MVP-1.1.2 Daily standups
- MVP-1.1.3 Risk tracking and mitigation
- MVP-1.1.4 Bi-weekly stakeholder updates

### MVP-1.2 Quality & Process
- MVP-1.2.1 Code review process (PR-based)
- MVP-1.2.2 Definition of Done per feature
- MVP-1.2.3 Sprint retrospectives

---

## MVP-2.0 Infrastructure & DevOps

### MVP-2.1 Cloud Infrastructure (AWS)
- MVP-2.1.1 AWS account setup
- MVP-2.1.2 VPC and security groups
- MVP-2.1.3 Compute: EC2 or ECS Fargate (monolith)
- MVP-2.1.4 Database: MongoDB Atlas or DocumentDB
- MVP-2.1.5 Cache/Queue: ElastiCache (Redis)
- MVP-2.1.6 Storage: S3 for assets

### MVP-2.2 CI/CD Pipeline
- MVP-2.2.1 GitHub Actions workflows
  - Build and test on PR
  - Deploy to staging on merge to main
  - Deploy to production on tag
- MVP-2.2.2 Environment management (dev/staging/prod)
- MVP-2.2.3 Docker containerization

### MVP-2.3 Monitoring & Logging
- MVP-2.3.1 Application logging (winston/pino)
- MVP-2.3.2 Error tracking (Sentry)
- MVP-2.3.3 Basic metrics (CPU, memory, latency)
- MVP-2.3.4 Health check endpoints

### MVP-2.4 Security
- MVP-2.4.1 HTTPS/TLS configuration
- MVP-2.4.2 JWT authentication
- MVP-2.4.3 Rate limiting (Redis-backed)
- MVP-2.4.4 Input validation and sanitization

---

## MVP-3.0 Backend Development (Node.js/Express)

### MVP-3.1 Authentication Service
- MVP-3.1.1 User registration (email/password)
- MVP-3.1.2 User login and JWT issuance
- MVP-3.1.3 Password hashing (bcrypt)
- MVP-3.1.4 Password reset flow
- MVP-3.1.5 Basic user profile (name, email)

### MVP-3.2 Link Service
- MVP-3.2.1 Create link (URL validation, metadata extraction)
- MVP-3.2.2 List links (filter by project/tags)
- MVP-3.2.3 Get single link with AI output
- MVP-3.2.4 Update link (project, tags)
- MVP-3.2.5 Delete link
- MVP-3.2.6 Status tracking (pending/processing/completed/failed)

### MVP-3.3 Project Service
- MVP-3.3.1 Create project
- MVP-3.3.2 List user projects
- MVP-3.3.3 Get project with links and AI output
- MVP-3.3.4 Update project (name, tags)
- MVP-3.3.5 Delete project
- MVP-3.3.6 Generate course trigger

### MVP-3.4 AI Processing Service
- MVP-3.4.1 Content fetching
  - Web scraper (Playwright for JS-heavy, Cheerio for static)
  - YouTube metadata extraction
  - Error handling for inaccessible content
- MVP-3.4.2 Per-link processing (async queue)
  - Summary generation (OpenAI)
  - Flashcard generation (5-10 Q&A pairs)
  - Store results in MongoDB
- MVP-3.4.3 Per-project processing (async queue)
  - Fetch all link summaries in project
  - Synthesize course (multi-lesson structure)
  - Generate quiz from course content
  - Store results in MongoDB
- MVP-3.4.4 Job status endpoint

### MVP-3.5 Job Queue System
- MVP-3.5.1 Redis Queue (Bull or Agenda) setup
- MVP-3.5.2 Job prioritization
- MVP-3.5.3 Retry logic for failed jobs
- MVP-3.5.4 Job completion tracking

### MVP-3.6 API Layer
- MVP-3.6.1 REST API endpoints (Express.js)
- MVP-3.6.2 Request validation (Joi/Zod)
- MVP-3.6.3 Error handling middleware
- MVP-3.6.4 CORS configuration
- MVP-3.6.5 OpenAPI/Swagger documentation

---

## MVP-4.0 Frontend Development (Flutter)

### MVP-4.1 Core Application Setup
- MVP-4.1.1 Flutter project structure (mobile + web)
- MVP-4.1.2 State management (Provider/Riverpod)
- MVP-4.1.3 Navigation and routing
- MVP-4.1.4 Theme setup (Material Design 3)
- MVP-4.1.5 API client configuration

### MVP-4.2 Authentication Screens
- MVP-4.2.1 Registration form
- MVP-4.2.2 Login form
- MVP-4.2.3 Password reset flow
- MVP-4.2.4 JWT storage and refresh

### MVP-4.3 Dashboard & Project Management
- MVP-4.3.1 Home screen (recent projects, quick actions)
- MVP-4.3.2 Projects list
- MVP-4.3.3 Project creation flow
- MVP-4.3.4 Project detail view (links list, progress)
- MVP-4.3.5 "Generate Course" action

### MVP-4.4 Link Management
- MVP-4.4.1 Manual URL input
- MVP-4.4.2 Links list (filtered by project)
- MVP-4.4.3 Link detail view
- MVP-4.4.4 Processing status indicator
- MVP-4.4.5 AI summary display
- MVP-4.4.6 Flashcards viewer

### MVP-4.5 Learning Interface
- MVP-4.5.1 Summary view (structured, readable)
- MVP-4.5.2 Flashcards carousel (flip animation)
- MVP-4.5.3 Course view (lesson-by-lesson)
- MVP-4.5.4 Quiz interface (multiple choice)
- MVP-4.5.5 Quiz results and feedback
- MVP-4.5.6 Mark as complete action

### MVP-4.6 Web-Specific Features
- MVP-4.6.1 Responsive layout (mobile/tablet/desktop)
- MVP-4.6.2 PWA configuration
- MVP-4.6.3 Browser session persistence

### MVP-4.7 Settings
- MVP-4.7.1 User profile settings
- MVP-4.7.2 Logout
- MVP-4.7.3 Basic preferences (theme)

---

## MVP-5.0 Chrome Extension

### MVP-5.1 Extension Core
- MVP-5.1.1 Manifest V3 configuration
- MVP-5.1.2 Background service worker
- MVP-5.1.3 Popup UI (HTML/CSS/JS)

### MVP-5.2 Save Functionality
- MVP-5.2.1 One-click save button
- MVP-5.2.2 Page metadata extraction (title, URL, description)
- MVP-5.2.3 Project selector
- MVP-5.2.4 Tag input
- MVP-5.2.5 Save confirmation

### MVP-5.3 Authentication
- MVP-5.3.1 Token storage
- MVP-5.3.2 Auto-refresh on expiry

### MVP-5.4 Chrome Web Store
- MVP-5.4.1 Extension listing assets
- MVP-5.4.2 Submission and review

---

## MVP-6.0 Database

### MVP-6.1 MongoDB Schema
- MVP-6.1.1 Users collection
- MVP-6.1.2 Projects collection
- MVP-6.1.3 Links collection
- MVP-6.1.4 AI Outputs (embedded or referenced)
- MVP-6.1.5 Jobs collection

### MVP-6.2 Indexing
- MVP-6.2.1 User ID indexes
- MVP-6.2.2 Project ID indexes
- MVP-6.2.3 Text indexes for search

### MVP-6.3 Redis
- MVP-6.3.1 Job queue implementation
- MVP-6.3.2 Session cache
- MVP-6.3.3 Rate limiting counters

---

## MVP-7.0 AI/ML Integration

### MVP-7.1 OpenAI Integration
- MVP-7.1.1 API client setup
- MVP-7.1.2 Prompt engineering: summaries
- MVP-7.1.3 Prompt engineering: flashcards
- MVP-7.1.4 Prompt engineering: courses
- MVP-7.1.5 Prompt engineering: quizzes
- MVP-7.1.6 Error handling and retries

### MVP-7.2 Content Processing
- MVP-7.2.1 HTML to text extraction
- MVP-7.2.2 Main content detection
- MVP-7.2.3 JavaScript-rendered content handling (Playwright)

### MVP-7.3 Quality & Cost
- MVP-7.3.1 Output validation (sanity checks)
- MVP-7.3.2 Token usage tracking
- MVP-7.3.3 Response caching

---

## MVP-8.0 Testing

### MVP-8.1 Backend Tests
- MVP-8.1.1 Unit tests (services, utilities)
- MVP-8.1.2 Integration tests (API endpoints)
- MVP-8.1.3 Target: 70% coverage

### MVP-8.2 Frontend Tests
- MVP-8.2.1 Widget tests (Flutter)
- MVP-8.2.2 Integration tests (critical flows)

### MVP-8.3 E2E Tests
- MVP-8.3.1 Mobile critical flows (Detox or manual)
- MVP-8.3.2 Web critical flows (Playwright)
- MVP-8.3.3 Extension (manual testing)

---

## MVP-9.0 Documentation

### MVP-9.1 Technical
- MVP-9.1.1 API documentation (OpenAPI)
- MVP-9.1.2 Architecture overview
- MVP-9.1.3 Local development setup guide

### MVP-9.2 User-Facing
- MVP-9.2.1 Getting started guide
- MVP-9.2.2 Feature tutorials
- MVP-9.2.3 FAQ

---

## MVP-10.0 Launch Preparation

### MVP-10.1 Beta Testing
- MVP-10.1.1 Internal testing
- MVP-10.1.2 Closed beta (500-1,000 users)
- MVP-10.1.3 Feedback collection mechanism

### MVP-10.2 App/Store Submission
- MVP-10.2.1 Chrome Web Store submission
- MVP-10.2.2 Web app deployment
- MVP-10.2.3 Mobile apps (TestFlight / Play Beta)

### MVP-10.3 Technical Readiness
- MVP-10.3.1 Performance benchmarks (API < 500ms, AI < 30s)
- MVP-10.3.2 Security review
- MVP-10.3.3 Backup/restore test

---

## MVP-11.0 Post-Launch Support

### MVP-11.1 Monitoring
- MVP-11.1.1 Error tracking (Sentry)
- MVP-11.1.2 Performance dashboards
- MVP-11.1.3 User feedback triage

### MVP-11.2 Iteration
- MVP-11.2.1 Bug fixes (priority)
- MVP-11.2.2 Feature improvements
- MVP-11.2.3 Phase 2 sprint planning

---

# PHASE 2 (Weeks 13-24) - Public Launch

**Goal:** Enhanced organization, progress analytics, sharing, and gamification.

---

## P2-1.0 Enhanced Organization

### P2-1.1 AI-Inferred Categorization
- P2-1.1.1 Auto-suggest project on link save
- P2-1.1.2 Auto-tagging based on content
- P2-1.1.3 Manual override capability

### P2-1.2 Advanced Filtering & Search
- P2-1.2.1 Full-text search across links
- P2-1.2.2 Tag-based filtering
- P2-1.2.3 Date range filtering
- P2-1.2.4 Content type filtering

### P2-1.3 Bulk Operations
- P2-1.3.1 Multi-select links
- P2-1.3.2 Bulk project reassignment
- P2-1.3.3 Bulk tag management
- P2-1.3.4 Bulk delete

### P2-1.4 Import/Export
- P2-1.4.1 Export projects (JSON/CSV)
- P2-1.4.2 Import bookmarks (from Pocket, browser)
- P2-1.4.3 Data backup automation

---

## P2-2.0 Progress Analytics

### P2-2.1 Personal Dashboard
- P2-2.1.1 Links saved count
- P2-2.1.2 Courses completed count
- P2-2.1.3 Quizzes taken and average score
- P2-2.1.4 Project completion tracking

### P2-2.2 Consistency Heatmap
- P2-2.2.1 Daily activity visualization
- P2-2.2.2 Weekly streak indicator
- P2-2.2.3 Monthly summary

### P2-2.3 Quiz Performance History
- P2-2.3.1 Score tracking over time
- P2-2.3.2 Weak area identification
- P2-2.3.3 Improvement suggestions

### P2-2.4 Study Session Analytics
- P2-2.4.1 Time spent per link
- P2-2.4.2 Time spent per course
- P2-2.4.3 Session frequency

---

## P2-3.0 Sharing

### P2-3.1 Share Links
- P2-3.1.1 Generate shareable link URL
- P2-3.1.2 Share to other L2L users
- P2-3.1.3 Share via external (email, social)

### P2-3.2 Share Projects
- P2-3.2.1 Generate public project URL
- P2-3.2.2 View-only project page
- P2-3.2.3 Project sharing analytics (views, clicks)

### P2-3.3 Basic Collaboration
- P2-3.3.1 Invite users to project
- P2-3.3.2 View-only vs. edit permissions
- P2-3.3.3 Collaborator management

---

## P2-4.0 Gamification

### P2-4.1 Points System
- P2-4.1.1 Points for saving links
- P2-4.1.2 Points for completing courses
- P2-4.1.3 Points for quiz performance
- P2-4.1.4 Points history

### P2-4.2 Achievements
- P2-4.2.1 Achievement definitions
- P2-4.2.2 Progress tracking
- P2-4.2.3 Achievement notifications
- P2-4.2.4 Badge gallery

### P2-4.3 Streaks
- P2-4.3.1 Daily streak tracking
- P2-4.3.2 Streak milestones
- P2-4.3.3 Streak freeze option (Premium)

### P2-4.4 Leaderboards (Basic)
- P2-4.4.1 Weekly points leaderboard
- P2-4.4.2 All-time points leaderboard
- P2-4.4.3 Personal rank display

---

## P2-5.0 Subscription & Payment

### P2-5.1 Stripe Integration
- P2-5.1.1 Stripe account setup
- P2-5.1.2 Payment processing
- P2-5.1.3 Webhook handling

### P2-5.2 Plan Management
- P2-5.2.1 Free tier (20 links/month, limited AI)
- P2-5.2.2 Premium tier ($9.99/month, unlimited)
- P2-5.2.3 Upgrade/downgrade flows

### P2-5.3 Subscription Features
- P2-5.3.1 Link limit enforcement
- P2-5.3.2 AI processing limit enforcement
- P2-5.3.3 Premium badge

---

## P2-6.0 Mobile App Enhancements

### P2-6.1 iOS/Android Native Features
- P2-6.1.1 Share sheet integration
- P2-6.1.2 Push notifications
- P2-6.1.3 Offline reading (cached content)

### P2-6.2 App Store Launch
- P2-6.2.1 App Store assets (screenshots, descriptions)
- P2-6.2.2 App Store submission
- P2-6.2.3 Play Store submission

---

## P2-7.0 Testing (Phase 2)

### P2-7.1 Feature Testing
- P2-7.1.1 Analytics accuracy tests
- P2-7.1.2 Sharing permission tests
- P2-7.1.3 Gamification tests
- P2-7.1.4 Payment flow tests

### P2-7.2 Public Launch Readiness
- P2-7.2.1 Load testing (10K concurrent)
- P2-7.2.2 Security audit
- P2-7.2.3 Performance optimization

---

## P2-8.0 Phase 2 Launch

### P2-8.1 Marketing Preparation
- P2-8.1.1 Landing page
- P2-8.1.2 Pricing page
- P2-8.1.3 Demo videos

### P2-8.2 Public Launch
- P2-8.2.1 Product Hunt launch
- P2-8.2.2 Social media campaign
- P2-8.2.3 Press outreach

---

# PHASE 3 (Weeks 25-36) - AI Learning Coach

**Goal:** Advanced AI features including adaptive learning, RAG chatbot, and collaboration.

---

## P3-1.0 Adaptive Learning

### P3-1.1 Learning Path Personalization
- P3-1.1.1 Difficulty assessment per user
- P3-1.1.2 Adaptive content sequencing
- P3-1.1.3 Personalized recommendations

### P3-1.2 Study Schedules
- P3-1.2.1 Goal-based schedule generation
- P3-1.2.2 Availability input
- P3-1.2.3 Schedule reminders

### P3-1.3 Spaced Repetition (SRS)
- P3-1.3.1 SM-2 algorithm implementation
- P3-1.3.2 Flashcard review scheduling
- P3-1.3.3 Retention tracking

---

## P3-2.0 Source Chatbot (RAG)

### P3-2.1 Vector Database Setup
- P3-2.1.1 Pinecone or Weaviate configuration
- P3-2.1.2 Embedding generation (OpenAI)
- P3-2.1.3 Vector indexing per project

### P3-2.2 Chatbot Features
- P3-2.2.1 Project-scoped Q&A
- P3-2.2.2 Citation of sources
- P3-2.2.3 Conversation history
- P3-2.2.4 Follow-up questions

### P3-2.3 Chatbot UI
- P3-2.3.1 Chat interface
- P3-2.3.2 Streaming responses
- P3-2.3.3 Source preview on citation click

---

## P3-3.0 Enhanced Collaboration

### P3-3.1 Collaborative Annotation
- P3-3.1.1 Highlight text on saved pages
- P3-3.1.2 Add notes to highlights
- P3-3.1.3 Share annotations with collaborators
- P3-3.1.4 Thread discussions on annotations

### P3-3.2 Group Learning
- P3-3.2.1 Create learning groups
- P3-3.2.2 Group projects
- P3-3.2.3 Group leaderboards
- P3-3.2.4 Group challenges

### P3-3.3 Public Courses
- P3-3.3.1 Publish courses publicly
- P3-3.3.2 Course discovery/browse
- P3-3.3.3 Course ratings and reviews

---

## P3-4.0 Advanced Analytics

### P3-4.1 Learning Velocity
- P3-4.1.1 Knowledge acquisition rate
- P3-4.1.2 Comparison to similar learners
- P3-4.1.3 Personalized insights

### P3-4.2 Knowledge Retention
- P3-4.2.1 Long-term retention tracking
- P3-4.2.2 Forgetting curve visualization
- P3-4.2.3 Review recommendations

### P3-4.3 Enterprise/Team Analytics (Phase 3+)
- P3-4.3.1 Team progress dashboard
- P3-4.3.2 Admin reports
- P3-4.3.3 Learning gap analysis

---

## P3-5.0 Mobile Share Sheet (Enhanced)

### P3-5.1 Native Share Integration
- P3-5.1.1 iOS share extension
- P3-5.1.2 Android share intent
- P3-5.1.3 Quick project selection
- P3-5.1.4 Voice input for notes

---

## P3-6.0 Testing (Phase 3)

### P3-6.1 AI Feature Testing
- P3-6.1.1 RAG accuracy tests
- P3-6.1.2 SRS algorithm validation
- P3-6.1.3 Chatbot response quality

### P3-6.2 Collaboration Testing
- P3-6.2.1 Real-time sync tests
- P3-6.2.2 Permission tests
- P3-6.2.3 Performance under load

---

## P3-7.0 Enterprise Features (Optional)

### P3-7.1 Team Management
- P3-7.1.1 Team creation
- P3-7.1.2 Member invitation
- P3-7.1.3 Role assignment

### P3-7.2 Admin Dashboard
- P3-7.2.1 Team analytics
- P3-7.2.2 Usage reports
- P3-7.2.3 Billing management

---

# Cross-Phase Concerns

## Security (All Phases)
- Regular security audits
- Dependency updates
- Penetration testing (Phase 2+)
- GDPR/CCPA compliance

## Performance (All Phases)
- Query optimization
- Caching strategy
- CDN for static assets
- Database indexing

## Documentation (All Phases)
- API docs updates
- User guides
- Runbooks for operations

---

# Timeline Summary

| Phase | Duration | Focus | Key Deliverables |
|-------|----------|-------|------------------|
| **MVP** | Weeks 1-12 | Core Platform | Auth, Link/Project CRUD, Per-link AI, Per-project AI, Flutter app, Chrome extension |
| **Phase 2** | Weeks 13-24 | Growth & Engagement | Analytics, Sharing, Gamification, Payments, Mobile apps launch |
| **Phase 3** | Weeks 25-36 | AI Coaching | Adaptive learning, RAG chatbot, SRS, Collaboration |

---

# Resource Requirements

| Role | MVP (FTE) | Phase 2 (FTE) | Phase 3 (FTE) |
|------|-----------|---------------|---------------|
| Backend Developer | 2 | 2 | 2 |
| Frontend Developer (Flutter) | 2 | 2 | 2 |
| Extension Developer | 1 | 0.5 | 0.5 |
| ML/AI Engineer | 0.5 | 1 | 2 |
| QA Engineer | 1 | 1 | 1 |
| DevOps | 0.5 | 0.5 | 0.5 |
| Product/Design | 1 | 1 | 1 |
| **Total** | **7** | **8** | **9** |

---

# Success Criteria

## MVP (Week 12)
| Metric | Target |
|--------|--------|
| Closed beta users | 500-1,000 |
| Link processing success rate | > 90% |
| AI processing time (per link) | < 30 seconds |
| API response time (p95) | < 500ms |
| Weekly user retention | > 60% |
| Course generation usage | > 30% of projects |

## Phase 2 (Week 24)
| Metric | Target |
|--------|--------|
| Registered users | 50,000 |
| Premium conversion | 4% |
| DAU/MAU | > 40% |
| App store rating | > 4.0 |
| Monthly recurring revenue | $20K |

## Phase 3 (Week 36)
| Metric | Target |
|--------|--------|
| Active users | 100,000 |
| Premium conversion | 6% |
| Chatbot engagement | > 25% of users |
| NPS score | > 50 |
| Path to profitability | Clear |

---

**End of WBS Document**
