# L2L (Link to Learn)

> The Intelligent Learning Bookmark Platform

![L2L Logo](assets/logo.png)

**L2L** is an AI-powered knowledge management platform that transforms passive bookmarking into an active, structured, and social learning experience. By utilizing AI agents, L2L converts scattered web resources into measurable knowledge paths.

## 🚀 Core Philosophy

- **From Storage to Action:** Traditional bookmarks are static. L2L treats every saved link as a raw material for a learning module.
- **Structure over Chaos:** Users don't just "save" links; they build **Projects** and **Topics**, creating a personal curriculum.
- **Community & Competition:** Learning is amplified when shared. L2L integrates gamification to drive consistency and collaboration.

## ✨ Key Features

### 🤖 AI Knowledge Engine
- **Instant Synthesis:** Automatically generates highlighted summaries and key takeaways for every project
- **Active Learning Tools:** Converts static content into flashcards, quizzes, and guided learning paths
- **Smart Processing:** Extracts key concepts and terminology from articles, videos, and podcasts

### 🎮 Gamification & Social Learning
- **Personal Achievement:** Earn points, maintain streaks, and unlock badges
- **Collaborative Learning:** Share projects with individuals or user groups
- **Healthy Competition:** Leaderboards based on quiz scores and progress completion

### 📊 Progress & Analytics
- **Visual Dashboards:** Detailed reports on learning velocity
- **Completion Tracking:** Track exactly how much of a Project has been consumed and understood

## 🏗️ System Architecture

### High-Level Architecture
```
┌─────────────────────────────────────────────────────────────────┐
│                         Presentation Layer                      │
├─────────────────────────────────────────────────────────────────┤
│  Web App (Flutter) │  Mobile Apps (Flutter) │ Browser Extension │
└─────────────────────────────────────────────────────────────────┘
                                  │
┌─────────────────────────────────────────────────────────────────┐
│                        API Gateway Layer                        │
├─────────────────────────────────────────────────────────────────┤
│           Load Balancer │ Rate Limiting │ Authentication       │
└─────────────────────────────────────────────────────────────────┘
                                  │
┌─────────────────────────────────────────────────────────────────┐
│                         Microservices Layer                     │
├─────────────────────────────────────────────────────────────────┤
│ User Service │ Content Service │ AI Engine │ Social Service     │
│ Analytics    │ Notification    │ Payment   │ Search             │
└─────────────────────────────────────────────────────────────────┘
                                  │
┌─────────────────────────────────────────────────────────────────┐
│                         Data Layer                             │
├─────────────────────────────────────────────────────────────────┤
│  MongoDB (Primary) │ Redis (Cache) │ S3 (Assets) │ Vector DB   │
└─────────────────────────────────────────────────────────────────┘
```

### Information Hierarchy
```
Topics (High-Level Categories)
├── Projects (Goal-Oriented Learning)
│   ├── Entities (Individual Resources/Links)
│   └── Tags (Metadata for filtering)
└── User Groups (Collaborative Spaces)
```

## 🛠️ Technology Stack

### Frontend
- **Framework:** Flutter (cross-platform)
- **State Management:** Provider + Riverpod
- **Architecture:** Clean Architecture (Domain-Data-Presentation layers)

### Backend
- **Runtime:** Node.js + Express
- **Language:** TypeScript
- **Architecture:** Microservices
- **Authentication:** JWT + OAuth 2.0

### Database
- **Primary:** MongoDB (DocumentDB on AWS)
- **Cache:** Redis (ElastiCache)
- **Vector DB:** Pinecone/Weaviate for semantic search
- **File Storage:** AWS S3

### AI/ML
- **Primary Model:** OpenAI GPT-4
- **Embeddings:** OpenAI text-embedding-ada-002
- **Custom Models:** Specialized NLP for educational content

### Infrastructure
- **Cloud:** AWS
- **Containerization:** Docker + Kubernetes (EKS)
- **CI/CD:** GitHub Actions
- **Monitoring:** Prometheus + Grafana + ELK Stack

## 📋 Project Status

**Current Version:** 1.0 (Development Phase)

### Development Phases
- [x] **Phase 1: Foundation** (Q1 2025) - Backend architecture and user authentication
- [ ] **Phase 2: Core Features** (Q2 2025) - AI processing and learning materials
- [ ] **Phase 3: Social Features** (Q3 2025) - Project sharing and collaboration
- [ ] **Phase 4: Advanced Features** (Q4 2025) - Analytics and enterprise features

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
#   "environment": "development"
# }
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

Create a `.env` file in the root directory:

```env
# Database
MONGODB_URI=mongodb://localhost:27017/l2l_dev
REDIS_URL=redis://localhost:6379

# AI Services
OPENAI_API_KEY=your_openai_api_key
OPENAI_MODEL=gpt-4

# Authentication
JWT_SECRET=your_jwt_secret
REFRESH_TOKEN_SECRET=your_refresh_token_secret

# AWS Services
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_REGION=us-east-1
S3_BUCKET=l2l-assets

# External Services
STRIPE_SECRET_KEY=your_stripe_secret
EMAIL_SERVICE_API_KEY=your_email_api_key
```

## 📁 Project Structure

```
L2L/
├── docs/                      # Documentation
│   ├── product_concept.md     # Product vision and philosophy
│   ├── product_specification.md # Detailed product requirements
│   └── technical_specification.md # Technical architecture
├── services/                  # Backend microservices
│   ├── user-service/          # User management & auth
│   ├── content-service/       # Content CRUD operations
│   ├── ai-service/            # AI processing pipeline
│   ├── social-service/        # Collaboration features
│   ├── analytics-service/     # User analytics
│   └── notification-service/  # Email & push notifications
├── app/                       # Flutter mobile/web app
│   ├── lib/
│   │   ├── core/              # Core utilities
│   │   ├── data/              # Data layer
│   │   ├── domain/            # Business logic
│   │   └── presentation/      # UI components
│   ├── test/                  # Tests
│   └── assets/                # Images, fonts, etc.
├── extension/                 # Browser extension
│   ├── popup/                 # Extension UI
│   ├── content-script/        # Page interaction
│   ├── background/            # Service worker
│   └── manifest.json          # Extension manifest
├── infrastructure/            # DevOps & IaC
│   ├── terraform/             # AWS infrastructure
│   ├── kubernetes/            # K8s manifests
│   └── docker/                # Docker files
├── scripts/                   # Build & deployment scripts
└── tests/                     # E2E and integration tests
```

## 🧪 Testing

### Running Tests

```bash
# Backend unit tests
cd services
npm run test

# Backend integration tests
npm run test:integration

# Flutter widget tests
cd app
flutter test

# E2E tests
npm run test:e2e
```

### Test Coverage
- **Backend:** Jest + Supertest
- **Frontend:** Flutter Test + Golden Tests
- **E2E:** Detox (mobile) + Playwright (web)

## 📊 API Documentation

The REST API documentation is available at:
- **Development:** `http://localhost:3000/api-docs`
- **Production:** `https://api.l2l.com/api-docs`

### Key Endpoints

#### Authentication
- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/refresh` - Refresh access token

#### Bookmarks
- `POST /api/v1/bookmarks` - Create new bookmark
- `GET /api/v1/bookmarks` - List user bookmarks
- `PUT /api/v1/bookmarks/:id` - Update bookmark
- `DELETE /api/v1/bookmarks/:id` - Delete bookmark

#### AI Processing
- `POST /api/v1/ai/process` - Process content with AI
- `GET /api/v1/ai/status/:jobId` - Check processing status

## 🚀 Deployment

### Development Environment
```bash
docker-compose -f docker-compose.dev.yml up -d
```

### Production Environment
```bash
# Deploy to Kubernetes
kubectl apply -f infrastructure/kubernetes/

# Monitor deployment
kubectl get pods -n l2l
```

### Environment-Specific Configurations
- **Development:** Local services with hot reload
- **Staging:** AWS staging environment with reduced resources
- **Production:** Full AWS infrastructure with auto-scaling

## 🔧 Configuration

### User Tiers
- **Free:** 50 saved links/month, basic AI features
- **Premium ($9.99/month):** Unlimited links, advanced AI, team features
- **Enterprise ($19.99/user/month):** All Premium + admin controls

### Rate Limiting
- **Free Tier:** 100 requests per 15 minutes
- **Premium Tier:** 1,000 requests per 15 minutes
- **Enterprise Tier:** 10,000 requests per 15 minutes

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Workflow
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- **Backend:** ESLint + Prettier with TypeScript
- **Frontend:** Dart Format + Flutter Lints
- **Git Hooks:** Pre-commit hooks for linting and formatting

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation:** [docs.l2l.com](https://docs.l2l.com)
- **API Reference:** [api.l2l.com/docs](https://api.l2l.com/docs)
- **Community:** [Discord Server](https://discord.gg/l2l)
- **Issues:** [GitHub Issues](https://github.com/your-org/L2L/issues)

## 🗺️ Roadmap

### Q1 2025: Foundation
- [x] User authentication system
- [x] Basic bookmark management
- [x] Browser extension MVP
- [ ] Mobile app core features

### Q2 2025: AI Integration
- [ ] AI content processing pipeline
- [ ] Flashcard and quiz generation
- [ ] Learning path recommendations
- [ ] Beta testing program

### Q3 2025: Social Features
- [ ] Project sharing functionality
- [ ] User groups and collaboration
- [ ] Leaderboards and competitions
- [ ] Public launch

### Q4 2025: Advanced Features
- [ ] Learning analytics dashboard
- [ ] AI learning coach
- [ ] Enterprise features
- [ ] API for third-party integrations

## 📈 Success Metrics

### Key Performance Indicators
- **User Engagement:** 60% monthly active user retention
- **Learning Effectiveness:** 75% of users report improved knowledge retention
- **Content Processing:** 95% accuracy in AI-generated materials
- **Social Features:** 40% of projects shared among users

### Launch Goals
- 10,000 registered users in first month
- 4.0+ app store rating
- 70% user retention after first week
- 50% bookmark-to-learning conversion rate

## 👥 Team

### Core Team
- **Product Lead:** [Name] - Product strategy and user experience
- **Tech Lead:** [Name] - Technical architecture and development
- **AI/ML Lead:** [Name] - AI/ML pipeline and models
- **Design Lead:** [Name] - UI/UX design and user research

### Contributors
This project is made possible by our amazing contributors. Thank you for your support!

---

**Built with ❤️ for lifelong learners everywhere**

*Turning passive bookmarks into active knowledge since 2025*