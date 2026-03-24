# L2L (Link to Learn)

> The Intelligent Learning Bookmark Platform

**L2L** is an AI-powered knowledge management platform that transforms passive bookmarking into an active, structured learning experience. By utilizing AI agents, L2L converts scattered web resources into measurable knowledge paths.

## 🚀 Core Philosophy

- **From Storage to Action:** Traditional bookmarks are static. L2L treats every saved link as raw material for learning.
- **Structure over Chaos:** Users don't just "save" links; they build **Projects** with **Tags**, creating a personal curriculum.
- **AI-Powered Learning:** Every link automatically generates summaries, flashcards, and quizzes.

## ✨ Key Features

### 🤖 Two-Tier AI Processing

**Per-Link (Automatic):**
- **Summaries:** Key points, main arguments, and takeaways
- **Flashcards:** 5-10 Q&A pairs generated from content
- **Status Tracking:** pending → processing → completed/failed

**Per-Project (Manual):**
- **Course Generation:** Synthesize all link summaries into structured lessons
- **Quiz Generation:** Create 5-15 questions with explanations
- **Learning Paths:** Organized curriculum from multiple resources

### 📊 Project Management

- **Organize Links:** Group related resources into projects
- **Tag System:** Flexible metadata for cross-project organization
- **Progress Tracking:** Monitor link processing status

### 🔌 Chrome Extension

- **One-Click Save:** Save any webpage with a single click
- **Project Selection:** Assign links to projects directly from browser
- **Instant Feedback:** Confirmation notifications on successful save

## 🏗️ System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Presentation Layer                           │
├─────────────────────────────────────────────────────────────────┤
│         Flutter App (iOS/Android/Web) + Chrome Extension        │
└─────────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────────┐
│                      API Layer (Express)                        │
├─────────────────────────────────────────────────────────────────┤
│              JWT Authentication + Rate Limiting                 │
└─────────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────────┐
│                   Business Logic Layer                          │
├─────────────────────────────────────────────────────────────────┤
│   Auth Module │ Links Module │ Projects Module │ AI Module     │
│                      Jobs Module (BullMQ)                       │
└─────────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────────┐
│                        Data Layer                               │
├─────────────────────────────────────────────────────────────────┤
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

## 🛠️ Technology Stack

### Frontend
- **Framework:** Flutter (cross-platform: iOS, Android, Web)
- **State Management:** Riverpod
- **Routing:** GoRouter
- **HTTP Client:** Dio with interceptors

### Backend
- **Runtime:** Node.js 20 + TypeScript
- **Framework:** Express
- **Database:** MongoDB 7.0 with Mongoose ODM
- **Queue:** BullMQ with Redis
- **AI:** OpenAI API (GPT-4o) + Cheerio for web scraping

### Infrastructure
- **Database:** MongoDB (local or Atlas)
- **Cache/Queue:** Redis 7
- **Containerization:** Docker + Docker Compose
- **CI/CD:** GitHub Actions (planned)

## 📋 Project Status

**Current Version:** 1.0.0 (MVP)

### MVP Scope ✅
- [x] User authentication (JWT-based)
- [x] Project CRUD operations
- [x] Link CRUD with AI processing
- [x] AI summary generation
- [x] AI flashcard generation
- [x] AI course generation
- [x] AI quiz generation
- [x] Job queue system (BullMQ)
- [x] Flutter mobile/web app
- [x] Chrome extension

### Post-MVP (Planned)
- [ ] Spaced repetition (SM-2 algorithm)
- [ ] Learning analytics dashboard
- [ ] Social sharing features
- [ ] Team collaboration
- [ ] Stripe payments
- [ ] RAG chatbot

## 🚀 Quick Start

### 🎯 Choose Your Setup Method

**Option A: With Docker** (Recommended - Easiest)
- Single command startup
- Isolated environment
- Consistent across machines

**Option B: Without Docker** (Local Installation)
- Full control over services
- No Docker overhead
- Direct access to databases

### 📖 Setup Guides

- **[GETTING_STARTED.md](GETTING_STARTED.md)** - Complete getting started guide (Docker + Local setup)
- **[RUN_WITHOUT_DOCKER.md](RUN_WITHOUT_DOCKER.md)** - Local development without Docker

### 🚀 One-Command Start

#### With Docker (Once Installed)
```bash
./start-dev.sh
```

#### Without Docker (Once Dependencies Installed)
```bash
./start-local.sh
```

### 📋 Prerequisites

**Option A: Docker**
- Docker Desktop (see [GETTING_STARTED.md](GETTING_STARTED.md))

**Option B: Local**
- Node.js 18+
- MongoDB 6.0+
- Redis 7.0+
- Flutter 3.0+ (for mobile/web app)

### 📍 Access Points

Once running:
- **API**: http://localhost:3000
- **Health Check**: http://localhost:3000/health
- **MongoDB**: mongodb://localhost:27017
- **Redis**: redis://localhost:6379

### 🧪 Verify Installation

```bash
# Test the API
curl http://localhost:3000/health

# Expected response:
# {
#   "status": "ok",
#   "database": "connected",
#   "redis": "connected",
#   "environment": "development"
# }
```

### Test API Endpoints

```bash
# Register a user
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "Password123", "name": "Test User"}'

# Login
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "Password123"}'
```

### 📱 Additional Components

#### Flutter App
```bash
cd app
flutter pub get
flutter run
```

#### Browser Extension
1. Open Chrome/Edge: `chrome://extensions/`
2. Enable "Developer mode"
3. Click "Load unpacked"
4. Select `extension/` directory

### Environment Variables

Create a `.env` file in `services/` directory:

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

# AI Services (required for AI features)
OPENAI_API_KEY=your_openai_api_key
OPENAI_MODEL=gpt-4o
```

## 📁 Project Structure

```
L2L/
├── docs/                          # Documentation
│   ├── implementation/            # Implementation guides
│   │   ├── mvp/                   # MVP implementation guide
│   │   └── *.md                   # Architecture, database, API docs
│   ├── product_concept.md         # Product vision
│   ├── product_specification.md   # Requirements
│   └── technical_specification.md # Architecture
├── services/                      # Backend API
│   ├── src/
│   │   ├── modules/               # Feature modules
│   │   │   ├── auth/              # Authentication
│   │   │   ├── links/             # Link CRUD + AI processing
│   │   │   ├── projects/          # Project CRUD + course generation
│   │   │   ├── ai/                # OpenAI integration
│   │   │   └── jobs/              # BullMQ job queues
│   │   ├── database/              # Mongoose models
│   │   ├── middleware/            # Express middleware
│   │   └── utils/                 # Utilities (logger, errors)
│   └── .env                       # Environment variables
├── app/                           # Flutter application
│   └── lib/
│       ├── core/                  # Core setup (providers, router)
│       ├── data/                  # Models and services
│       └── presentation/          # UI screens
├── extension/                     # Chrome extension
│   ├── manifest.json              # Extension config
│   ├── popup/                     # Popup UI
│   └── background/                # Service worker
├── docker-compose.dev.yml         # Development Docker
├── start-dev.sh                   # Docker startup script
└── start-local.sh                 # Local startup script
```

## 🧪 Testing

```bash
# Backend unit tests
cd services
npm test              # Jest unit tests
npm run test:integration  # Integration tests

# Flutter widget tests
cd app
flutter test
```

## 📊 API Endpoints

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/auth/register` | Register (email, password, name) |
| POST | `/api/v1/auth/login` | Login |
| POST | `/api/v1/auth/refresh` | Refresh token |
| GET | `/api/v1/auth/me` | Current user |

### Projects
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/projects` | List projects |
| POST | `/api/v1/projects` | Create project |
| GET | `/api/v1/projects/:id` | Get project |
| PUT | `/api/v1/projects/:id` | Update project |
| DELETE | `/api/v1/projects/:id` | Delete project |
| POST | `/api/v1/projects/:id/generate-course` | Generate AI course |

### Links
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/links` | List links |
| POST | `/api/v1/links` | Create link (queues AI job) |
| GET | `/api/v1/links/:id` | Get link with AI output |
| PUT | `/api/v1/links/:id` | Update link |
| DELETE | `/api/v1/links/:id` | Delete link |

### Jobs
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/jobs/:jobId` | Get job status |

## 🚀 Deployment

### Development Environment
```bash
# With Docker
./start-dev.sh

# Or manually
docker-compose -f docker-compose.dev.yml up -d
```

### Local Environment (No Docker)
```bash
./start-local.sh
```

See [GETTING_STARTED.md](GETTING_STARTED.md) for detailed setup instructions.

## 🔧 Configuration

### User Tiers (Planned)
- **Free:** 50 saved links/month, basic AI features
- **Premium ($9.99/month):** Unlimited links, advanced AI, team features

### Rate Limiting (Planned)
- **Free Tier:** 100 requests per 15 minutes
- **Premium Tier:** 1,000 requests per 15 minutes

## 🤝 Contributing

We welcome contributions!

### Development Workflow
1. Create a feature branch (`git checkout -b feature/amazing-feature`)
2. Commit your changes (`git commit -m 'Add amazing feature'`)
3. Push to the branch (`git push origin feature/amazing-feature`)
4. Open a Pull Request

### Code Style
- **Backend:** ESLint + Prettier with TypeScript
- **Frontend:** Dart Format + Flutter Lints

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation:** See [docs/](docs/) directory
- **Getting Started:** [GETTING_STARTED.md](GETTING_STARTED.md)
- **Issues:** [GitHub Issues](https://github.com/your-org/L2L/issues)

## 🗺️ Roadmap

### Phase 1: MVP ✅
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

## 📈 Success Metrics

- **AI Processing:** Summaries and flashcards generated for each saved link
- **Course Generation:** Synthesized lessons from multiple project links
- **User Experience:** Streamlined MVP with focused feature set

---

**Built with ❤️ for lifelong learners everywhere**

*Turning passive bookmarks into active knowledge since 2025*