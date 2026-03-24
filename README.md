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

**Current Version:** 1.0.0 (MVP Complete ✅)

All MVP features are implemented and ready for use. See the [Roadmap](#-roadmap) for upcoming phases.

---

## 🚀 Quick Start

### 🎯 Choose Your Setup Method

**Option A: Docker** (Recommended - Easiest)
- Single command startup
- Isolated environment
- Consistent across machines

**Option B: Local Setup** (No Docker)
- Full control over services
- No Docker overhead
- Direct access to databases

### 📋 Prerequisites

**Option A: Docker**
- Docker Desktop (see installation below)

**Option B: Local**
- Node.js 18+
- MongoDB 6.0+
- Redis 7.0+
- Flutter 3.0+ (for mobile/web app)

### Install Docker

**Direct Download:**
1. Download [Docker Desktop](https://www.docker.com/products/docker-desktop/)
2. Choose **Apple Silicon** (M1/M2/M3) or **Intel Chip**
3. Drag to Applications folder and launch

**Or via Homebrew:**
```bash
brew install --cask docker
open -a Docker
```

**Verify Installation:**
```bash
docker --version
docker run hello-world
```

### Start Services

**Automated (Recommended):**
```bash
cd /Users/bs0650/R&D/AI/L2L
./start-dev.sh
```

**Manual:**
```bash
docker-compose -f docker-compose.dev.yml up -d
```

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

---

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

---

## 🔧 Configuration

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

---

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

---

## 🧪 Testing

### Backend Tests
```bash
cd services
npm test              # Jest unit tests
npm run test:integration  # Integration tests
npm run test:watch    # Watch mode
```

### Frontend Tests
```bash
cd app
flutter test          # Unit and widget tests
flutter test integration_test/  # Integration tests
```

---

## 🚀 Running the App

### Flutter App
```bash
cd app
flutter pub get
flutter run

# Or run on Chrome
flutter run -d chrome
```

### Browser Extension
1. Open Chrome/Edge: `chrome://extensions/`
2. Enable "Developer mode"
3. Click "Load unpacked"
4. Select `extension/` directory

---

## 🔧 Common Commands

### Docker Commands

```bash
# View logs
docker-compose -f docker-compose.dev.yml logs -f

# Stop services
docker-compose -f docker-compose.dev.yml down

# Restart services
docker-compose -f docker-compose.dev.yml restart

# Rebuild after changes
docker-compose -f docker-compose.dev.yml up -d --build

# Check container status
docker-compose -f docker-compose.dev.yml ps
```

### Database Access

```bash
# MongoDB shell
docker-compose -f docker-compose.dev.yml exec mongodb mongosh

# Redis CLI
docker-compose -f docker-compose.dev.yml exec redis redis-cli

# Clear Redis cache
docker-compose -f docker-compose.dev.yml exec redis redis-cli FLUSHALL
```

---

## 🆘 Troubleshooting

### Port Already in Use
```bash
# Check what's using the port
lsof -i :3000    # API
lsof -i :27017   # MongoDB
lsof -i :6379    # Redis

# Kill the process
kill -9 <PID>
```

### Docker Won't Start
```bash
# Restart Docker Desktop
killall Docker
sleep 5
open -a Docker
```

### Database Connection Issues
```bash
# Check container logs
docker-compose -f docker-compose.dev.yml logs mongodb

# Restart MongoDB
docker-compose -f docker-compose.dev.yml restart mongodb
```

### Reset Everything
```bash
# Stop and remove everything (WARNING: deletes data)
docker-compose -f docker-compose.dev.yml down -v
docker-compose -f docker-compose.dev.yml up -d
```

---

## 📚 Documentation

### Getting Started
- **[GETTING_STARTED.md](GETTING_STARTED.md)** - Detailed setup guide with Docker installation

### Implementation Guidelines
- **[docs/implementation/README.md](docs/implementation/README.md)** - Implementation guidelines index
- **[docs/implementation/01_architecture_overview.md](docs/implementation/01_architecture_overview.md)** - System architecture
- **[docs/implementation/06_dev_environment_setup.md](docs/implementation/06_dev_environment_setup.md)** - Development environment setup
- **[docs/implementation/mvp/AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md](docs/implementation/mvp/AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md)** - MVP implementation guide

### Product & Technical Docs
- **[docs/product_concept.md](docs/product_concept.md)** - Product vision and philosophy
- **[docs/product_specification.md](docs/product_specification.md)** - Detailed product requirements
- **[docs/technical_specification.md](docs/technical_specification.md)** - Technical architecture
- **[DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md)** - Complete documentation index

---

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

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

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

---

## 📈 What's Included

- ✅ **Backend API** - Node.js/TypeScript with RESTful endpoints (Auth, Projects, Links, AI processing)
- ✅ **Flutter App** - Cross-platform mobile/web application
- ✅ **Browser Extension** - Chrome/Edge extension for saving content
- ✅ **Database** - MongoDB for data persistence
- ✅ **Cache/Queue** - Redis + BullMQ for async job processing
- ✅ **Authentication** - JWT-based auth with refresh tokens
- ✅ **Two-Tier AI Processing** - Per-link (summary+flashcards) and Per-project (course+quiz)
- ✅ **Testing** - Jest testing infrastructure

---

**Built with ❤️ for lifelong learners everywhere**

*Turning passive bookmarks into active knowledge since 2025*

**Last Updated**: March 2026
**Version**: 1.0.0 (MVP)
