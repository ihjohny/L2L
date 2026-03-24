# L2L (Link to Learn)

> The Intelligent Learning Bookmark Platform

**L2L** is an AI-powered knowledge management platform that transforms passive bookmarking into an active, structured learning experience. By utilizing AI agents, L2L converts scattered web resources into measurable knowledge paths.

---

## Table of Contents

1. [Core Philosophy](#-core-philosophy)
2. [Key Features](#-key-features)
3. [Architecture](#-system-architecture)
4. [Technology Stack](#-technology-stack)
5. [Quick Start](#-quick-start)
6. [Configuration](#-configuration)
7. [API Reference](#-api-reference)
8. [Development](#-development)
9. [Documentation Index](#-documentation-index)
10. [Troubleshooting](#-troubleshooting)
11. [Contributing](#-contributing)
12. [Roadmap](#-roadmap)

---

## 🚀 Core Philosophy

- **From Storage to Action:** Traditional bookmarks are static. L2L treats every saved link as raw material for learning.
- **Structure over Chaos:** Users don't just "save" links; they build **Projects** with **Tags**, creating a personal curriculum.
- **AI-Powered Learning:** Every link automatically generates summaries, flashcards, and quizzes.

---

## ✨ Key Features

### 🤖 Two-Tier AI Processing

| Tier | Trigger | Output |
|------|---------|--------|
| **Per-Link** | Automatic on save | Summary, 5-10 flashcards, status tracking |
| **Per-Project** | Manual trigger | Structured course, 5-15 question quiz, learning path |

### 📊 Project Management

- Organize links into projects with flexible tagging
- Track processing status: `pending` → `processing` → `completed/failed`
- Cross-project organization via tags

### 🔌 Chrome Extension

- One-click save from any webpage
- Project selection directly from browser
- Instant confirmation notifications

---

## 🏗️ System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Presentation Layer                           │
│         Flutter App (iOS/Android/Web) + Chrome Extension        │
└─────────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────────┐
│                      API Layer (Express)                        │
│              JWT Authentication + Rate Limiting                 │
└─────────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────────┐
│                   Business Logic Layer                          │
│   Auth │ Links │ Projects │ AI │ Jobs (BullMQ)                 │
└─────────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────────┐
│                        Data Layer                               │
│     MongoDB (Primary) │ Redis (Cache/Queue) │ OpenAI API        │
└─────────────────────────────────────────────────────────────────┘
```

### Information Hierarchy

```
Projects (Learning Goals)
├── Links (Saved Resources)
│   ├── AI Summary
│   └── Flashcards
└── AI Course (Generated from all links)
    └── Quiz
```

---

## 🛠️ Technology Stack

| Layer | Technologies |
|-------|--------------|
| **Frontend** | Flutter, Riverpod, GoRouter, Dio |
| **Backend** | Node.js 20, TypeScript, Express |
| **Database** | MongoDB 7.0, Mongoose ODM |
| **Queue/Cache** | Redis 7, BullMQ |
| **AI** | OpenAI API (GPT-4o), Cheerio |
| **Infrastructure** | Docker, Docker Compose, GitHub Actions |

---

## 🚀 Quick Start

### Choose Your Setup Method

| Method | Pros | Cons |
|--------|------|------|
| **Docker** (Recommended) | Single command, isolated, consistent | Docker overhead |
| **Local** | Full control, no Docker | Manual setup of all services |

### Prerequisites

**Docker:**
- Docker Desktop (Apple Silicon or Intel)

**Local:**
- Node.js 18+
- MongoDB 6.0+
- Redis 7.0+
- Flutter 3.0+ (for mobile/web app)

### Install Docker

```bash
# Via Homebrew
brew install --cask docker
open -a Docker

# Or download from https://www.docker.com/products/docker-desktop/
```

### Start Services

```bash
# Automated (Recommended)
./start-dev.sh

# Manual Docker
docker-compose -f docker-compose.dev.yml up -d

# Manual Local
./start-local.sh
```

### Access Points

| Service | URL |
|---------|-----|
| API | http://localhost:3000 |
| Health Check | http://localhost:3000/health |
| MongoDB | mongodb://localhost:27017 |
| Redis | redis://localhost:6379 |

### Verify Installation

```bash
curl http://localhost:3000/health
```

Expected response:
```json
{
  "status": "ok",
  "database": "connected",
  "redis": "connected",
  "environment": "development"
}
```

---

## 🔧 Configuration

### Environment Variables

Create `services/.env`:

```env
# Node.js
NODE_ENV=development
PORT=3000

# Database
MONGODB_URI=mongodb://localhost:27017/l2l_dev

# Redis
REDIS_URL=redis://localhost:6379

# Authentication
JWT_SECRET=your_jwt_secret_min_32_chars
JWT_ACCESS_TTL=15m
JWT_REFRESH_TTL=7d

# AI Services
OPENAI_API_KEY=your_openai_api_key
OPENAI_MODEL=gpt-4o
```

### Configuration Files

| File | Purpose |
|------|---------|
| `services/.env.example` | Environment template |
| `docker-compose.dev.yml` | Development services |
| `docker-compose.prod.yml` | Production services |
| `services/Dockerfile` | API container |
| `services/package.json` | Backend dependencies |
| `app/pubspec.yaml` | Flutter dependencies |

---

## 📊 API Reference

### Authentication

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/auth/register` | Register (email, password, name) |
| POST | `/api/v1/auth/login` | Login |
| POST | `/api/v1/auth/refresh` | Refresh access token |
| GET | `/api/v1/auth/me` | Get current user |

### Projects

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/projects` | List user's projects |
| POST | `/api/v1/projects` | Create project |
| GET | `/api/v1/projects/:id` | Get project details |
| PUT | `/api/v1/projects/:id` | Update project |
| DELETE | `/api/v1/projects/:id` | Delete project |
| POST | `/api/v1/projects/:id/generate-course` | Generate AI course |

### Links

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/links` | List user's links |
| POST | `/api/v1/links` | Create link (triggers AI processing) |
| GET | `/api/v1/links/:id` | Get link with AI output |
| PUT | `/api/v1/links/:id` | Update link |
| DELETE | `/api/v1/links/:id` | Delete link |

### Jobs

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/jobs/:jobId` | Get job status |

Full API documentation: [docs/implementation/04_api_design.md](docs/implementation/04_api_design.md)

---

## 🛠️ Development

### Project Structure

```
L2L/
├── docs/                              # Documentation
│   ├── implementation/                # Implementation guides
│   │   ├── mvp/                       # MVP implementation
│   │   └── *.md                       # Architecture, database, API docs
│   ├── product_concept.md             # Product vision
│   ├── product_specification.md       # Requirements
│   └── technical_specification.md     # Technical architecture
│
├── services/                          # Backend API
│   └── src/
│       ├── modules/                   # Feature modules
│       │   ├── auth/                  # Authentication
│       │   ├── links/                 # Link CRUD + AI processing
│       │   ├── projects/              # Project CRUD + course generation
│       │   ├── ai/                    # OpenAI integration
│       │   └── jobs/                  # BullMQ job queues
│       ├── database/                  # Mongoose models
│       ├── middleware/                # Express middleware
│       └── utils/                     # Utilities
│
├── app/                               # Flutter application
│   └── lib/
│       ├── core/                      # Core setup
│       ├── data/                      # Models and services
│       ├── domain/                    # Business logic
│       └── presentation/              # UI screens and widgets
│
└── extension/                         # Chrome extension
    ├── manifest.json                  # Extension config
    ├── popup/                         # Popup UI
    ├── content/                       # Content script
    └── background/                    # Service worker
```

### Running the Application

**Flutter App:**
```bash
cd app
flutter pub get
flutter run
flutter run -d chrome  # Run on Chrome
```

**Browser Extension:**
1. Open Chrome: `chrome://extensions/`
2. Enable "Developer mode"
3. Click "Load unpacked"
4. Select `extension/` directory

### Testing

**Backend:**
```bash
cd services
npm test              # Unit tests
npm run test:integration  # Integration tests
npm run test:watch    # Watch mode
```

**Frontend:**
```bash
cd app
flutter test          # Unit and widget tests
flutter test integration_test/  # Integration tests
```

### Common Commands

**Docker:**
```bash
docker-compose -f docker-compose.dev.yml logs -f     # View logs
docker-compose -f docker-compose.dev.yml down        # Stop services
docker-compose -f docker-compose.dev.yml restart     # Restart services
docker-compose -f docker-compose.dev.yml up -d --build  # Rebuild
docker-compose -f docker-compose.dev.yml ps          # Check status
```

**Database Access:**
```bash
docker-compose -f docker-compose.dev.yml exec mongodb mongosh
docker-compose -f docker-compose.dev.yml exec redis redis-cli
docker-compose -f docker-compose.dev.yml exec redis redis-cli FLUSHALL  # Clear cache
```

---

## 📚 Documentation Index

### Product Documentation

| Document | Description |
|----------|-------------|
| [docs/product_concept.md](docs/product_concept.md) | Product vision, target audience, market analysis |
| [docs/product_specification.md](docs/product_specification.md) | Feature specs, user flows, acceptance criteria |
| [docs/technical_specification.md](docs/technical_specification.md) | System architecture, database design, security |
| [docs/project_plan.md](docs/project_plan.md) | Project planning |
| [docs/WBS.md](docs/WBS.md) | Work Breakdown Structure |
| [docs/effort_estimation.md](docs/effort_estimation.md) | Effort estimation |

### Implementation Guidelines

| # | Document | Description |
|---|----------|-------------|
| 01 | [Architecture Overview](docs/implementation/01_architecture_overview.md) | System diagrams, component responsibilities, data flows |
| 02 | [Implementation Details](docs/implementation/02_implementation_details.md) | Backend structure, Flutter patterns, extension spec |
| 03 | [Database Schema](docs/implementation/03_database_schema.md) | MongoDB collections, indexes, migrations |
| 04 | [API Design](docs/implementation/04_api_design.md) | REST endpoints, JWT flows, error handling, rate limiting |
| 05 | [Configuration](docs/implementation/05_configuration.md) | Environment variables, secrets, feature flags |
| 06 | [Dev Environment](docs/implementation/06_dev_environment.md) | Prerequisites, local setup, onboarding |
| 07 | [Deployment & CI/CD](docs/implementation/07_deployment_cicd.md) | GitHub Actions, Docker, ECS, rollback |
| 08 | [Microservices Migration](docs/implementation/08_microservices_migration.md) | Strangler Fig pattern, extraction roadmap |
| 09 | [Security Guidelines](docs/implementation/09_security_guidelines.md) | Input validation, secrets hygiene, GDPR |
| 10 | [Testing Strategy](docs/implementation/10_testing_strategy.md) | Testing pyramid, coverage, load testing |
| 11 | [Observability & Operations](docs/implementation/11_observability_operations.md) | Logging, metrics, alerting, runbooks |
| 12 | [Pre-Launch Checklist](docs/implementation/12_pre_launch_checklist.md) | Blocking/high/deferrable items by phase |

### MVP Implementation

- **[AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md](docs/implementation/mvp/AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md)** - Authoritative MVP implementation guide
  - Database schema (users, projects, links, ai_outputs, jobs)
  - Module structure and code patterns
  - API endpoints reference
  - Two-tier AI processing flow
  - Verification checklist

### Recommended Reading Order

**New Developers:**
1. This README (project overview)
2. [06_dev_environment.md](docs/implementation/06_dev_environment.md) - Setup environment
3. [product_concept.md](docs/product_concept.md) - Understand the product
4. [technical_specification.md](docs/technical_specification.md) - Architecture overview
5. [AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md](docs/implementation/mvp/AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md) - Implementation details

**DevOps & Deployment:**
1. [06_dev_environment.md](docs/implementation/06_dev_environment.md) - Local setup
2. [07_deployment_cicd.md](docs/implementation/07_deployment_cicd.md) - CI/CD pipelines
3. [11_observability_operations.md](docs/implementation/11_observability_operations.md) - Monitoring
4. [12_pre_launch_checklist.md](docs/implementation/12_pre_launch_checklist.md) - Launch prep

---

## 🆘 Troubleshooting

### Port Conflicts

```bash
lsof -i :3000    # API
lsof -i :27017   # MongoDB
lsof -i :6379    # Redis
kill -9 <PID>
```

### Docker Issues

```bash
# Restart Docker Desktop
killall Docker
sleep 5
open -a Docker

# Check container logs
docker-compose -f docker-compose.dev.yml logs mongodb

# Restart service
docker-compose -f docker-compose.dev.yml restart mongodb
```

### Database Connection Issues

```bash
# Check MongoDB (local)
brew services list | grep mongodb
mongosh

# Check Redis (local)
brew services list | grep redis
redis-cli ping

# Check container logs
docker-compose -f docker-compose.dev.yml logs mongodb
```

### Reset Everything

⚠️ **WARNING: Deletes all data**

```bash
docker-compose -f docker-compose.dev.yml down -v
docker-compose -f docker-compose.dev.yml up -d
```

For more troubleshooting, see [11_observability_operations.md](docs/implementation/11_observability_operations.md)

---

## 🤝 Contributing

### Development Workflow

1. Create a feature branch: `git checkout -b feature/amazing-feature`
2. Commit your changes: `git commit -m 'Add amazing feature'`
3. Push: `git push origin feature/amazing-feature`
4. Open a Pull Request

### Code Style

| Layer | Tools |
|-------|-------|
| Backend | ESLint + Prettier with TypeScript |
| Frontend | Dart Format + Flutter Lints |

---

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) for details.

---

## 🗺️ Roadmap

### Phase 1: MVP ✅ (Complete)

- [x] User authentication (JWT)
- [x] Project management (CRUD)
- [x] Link management with AI processing
- [x] AI summaries and flashcards per link
- [x] AI course and quiz generation per project
- [x] Job queue system (BullMQ)
- [x] Flutter mobile/web app
- [x] Chrome extension

### Phase 2: Enhancement (Planned)

- [ ] Spaced repetition (SM-2 algorithm)
- [ ] Learning analytics dashboard
- [ ] Social sharing features
- [ ] Team collaboration

### Phase 3: Advanced (Future)

- [ ] Stripe payments
- [ ] RAG chatbot
- [ ] Adaptive learning paths
- [ ] Enterprise features

---

## 📈 What's Included

- ✅ **Backend API** - Node.js/TypeScript with RESTful endpoints
- ✅ **Flutter App** - Cross-platform mobile/web application
- ✅ **Browser Extension** - Chrome/Edge extension
- ✅ **Database** - MongoDB with Mongoose
- ✅ **Cache/Queue** - Redis + BullMQ
- ✅ **Authentication** - JWT with refresh tokens
- ✅ **Two-Tier AI Processing** - Per-link and per-project
- ✅ **Testing** - Jest and Flutter test infrastructure

---

**Version**: 1.0.0 (MVP)
**Last Updated**: March 2026

**Built with ❤️ for lifelong learners everywhere**

*Turning passive bookmarks into active knowledge since 2025*
