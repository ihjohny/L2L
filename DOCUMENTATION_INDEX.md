# 📚 L2L Documentation Index

Complete guide to all L2L documentation and how to use it.

## 🚀 Getting Started (Start Here!)

### New to L2L? Start with these:
1. **[README.md](README.md)** - Project overview and introduction
2. **[GETTING_STARTED.md](GETTING_STARTED.md)** - Complete getting started guide (Docker + Local setup)
3. **[RUN_WITHOUT_DOCKER.md](RUN_WITHOUT_DOCKER.md)** - Local setup without Docker (detailed)

---

## 📖 Setup & Installation Guides

### Getting Started
- **[GETTING_STARTED.md](GETTING_STARTED.md)** - Complete getting started guide
  - Docker installation and setup (recommended)
  - Local setup instructions
  - Common commands for both methods
  - Troubleshooting
  - Testing and verification

### Local Setup (Without Docker)
- **[RUN_WITHOUT_DOCKER.md](RUN_WITHOUT_DOCKER.md)** - Detailed local development guide
  - Installing MongoDB, Redis, Node.js, Flutter
  - Service management with Homebrew
  - Manual service startup
  - Troubleshooting

### Startup Scripts
- **[start-dev.sh](start-dev.sh)** - One-command Docker startup
- **[start-local.sh](start-local.sh)** - One-command local startup

---

## 📋 Product Documentation

### Product Vision & Requirements
- **[docs/product_concept.md](docs/product_concept.md)** - Product vision and philosophy
  - Core concepts
  - Target audience
  - Market analysis
  - Success metrics

- **[docs/product_specification.md](docs/product_specification.md)** - Detailed product requirements
  - Feature specifications
  - User flows
  - Requirements
  - Acceptance criteria

### MVP Implementation
- **[docs/implementation/mvp/AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md](docs/implementation/mvp/AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md)** - **Authoritative MVP implementation guide**
  - Database schema (users, projects, links, ai_outputs, jobs)
  - Module structure and code patterns
  - API endpoints reference
  - Two-tier AI processing flow
  - Verification checklist

### Technical Documentation
- **[docs/technical_specification.md](docs/technical_specification.md)** - Technical architecture
  - System architecture
  - Technology stack
  - Database design
  - API specifications
  - Security considerations

- **[docs/IMPLEMENTATION_SUMMARY.md](docs/IMPLEMENTATION_SUMMARY.md)** - Complete implementation details
  - What was built
  - Architecture patterns
  - Database schema
  - API endpoints
  - Testing infrastructure
  - Migration path to microservices

- **[docs/MVP_OVERVIEW.md](docs/MVP_OVERVIEW.md)** - Quick project overview
  - What's included
  - Key statistics
  - Design patterns
  - Next steps

---

## 🛠️ Developer Guides

### Backend Development
- **Technology**: Node.js, TypeScript, Express, MongoDB, Redis, BullMQ
- **Location**: `services/` directory
- **Key Files**:
  - `services/src/modules/` - Feature modules (auth, links, projects, ai, jobs)
  - `services/src/database/` - MongoDB models (User, Project, Link, AiOutput, Job)
  - `services/src/middleware/` - Express middleware (auth, validation, error handling)
  - `services/src/utils/` - Utilities (logger, error classes)

### Frontend Development
- **Technology**: Flutter, Dart, Riverpod, go_router
- **Location**: `app/` directory
- **Key Files**:
  - `app/lib/core/` - Core app setup
  - `app/lib/data/` - Data models and repositories
  - `app/lib/domain/` - Business logic
  - `app/lib/presentation/` - UI screens and widgets

### Browser Extension
- **Technology**: Chrome Extension Manifest V3, JavaScript
- **Location**: `extension/` directory
- **Key Files**:
  - `extension/manifest.json` - Extension manifest
  - `extension/popup/` - Popup UI
  - `extension/content/` - Content script
  - `extension/background/` - Service worker

---

## 🔧 Configuration Files

### Environment Configuration
- **`services/.env.example`** - Environment variables template
- **`services/.env`** - Your actual environment configuration (create from .env.example)

### Docker Configuration
- **`docker-compose.dev.yml`** - Development Docker Compose
- **`docker-compose.prod.yml`** - Production Docker Compose
- **`services/Dockerfile`** - API service Dockerfile

### Build Configuration
- **`services/package.json`** - Backend dependencies and scripts
- **`app/pubspec.yaml`** - Flutter dependencies
- **`services/tsconfig.json`** - TypeScript configuration
- **`services/jest.config.js`** - Testing configuration

---

## 🧪 Testing

### Backend Tests
```bash
cd services
npm test              # Unit tests
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

## 📊 API Documentation

### Key Endpoints

#### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login user
- `POST /api/v1/auth/refresh` - Refresh access token
- `GET /api/v1/auth/me` - Get current user profile

#### Projects
- `GET /api/v1/projects` - List user's projects
- `POST /api/v1/projects` - Create new project
- `GET /api/v1/projects/:id` - Get project details
- `PUT /api/v1/projects/:id` - Update project
- `DELETE /api/v1/projects/:id` - Delete project
- `POST /api/v1/projects/:id/generate-course` - Generate AI course

#### Links
- `GET /api/v1/links` - List user's links
- `POST /api/v1/links` - Create new link (triggers AI processing)
- `GET /api/v1/links/:id` - Get link with AI output
- `PUT /api/v1/links/:id` - Update link
- `DELETE /api/v1/links/:id` - Delete link

#### Jobs
- `GET /api/v1/jobs/:jobId` - Get job status

**Full API documentation**: See [IMPLEMENTATION_SUMMARY.md](docs/IMPLEMENTATION_SUMMARY.md)

---

## 🚀 Deployment

### Development
```bash
# With Docker
./start-dev.sh

# Without Docker
./start-local.sh
```

### Production
```bash
# Build and deploy
docker-compose -f docker-compose.prod.yml up -d

# Or deploy to Kubernetes
kubectl apply -f infrastructure/kubernetes/
```

---

## 🔍 Troubleshooting

### Common Issues

#### Docker won't start
- **Solution**: [GETTING_STARTED.md](GETTING_STARTED.md)

#### Port conflicts
```bash
# Check what's using the port
lsof -i :3000    # API
lsof -i :27017   # MongoDB
lsof -i :6379    # Redis

# Kill the process
kill -9 <PID>
```

#### Database connection issues
```bash
# Check MongoDB
brew services list | grep mongodb
mongosh

# Check Redis
brew services list | grep redis
redis-cli ping
```

---

## 📈 Project Structure

```
L2L/
├── README.md                    # Start here!
├── GETTING_STARTED.md           # Complete getting started guide
├── RUN_WITHOUT_DOCKER.md        # Local setup guide (detailed)
├── DOCUMENTATION_INDEX.md       # This file!
├── start-dev.sh                 # Docker startup script
├── start-local.sh               # Local startup script
│
├── docs/                       # Product & technical docs
│   ├── product_concept.md
│   ├── product_specification.md
│   ├── technical_specification.md
│   ├── IMPLEMENTATION_SUMMARY.md
│   └── MVP_OVERVIEW.md
│
├── services/                   # Backend API
│   ├── src/
│   │   ├── modules/           # Feature modules
│   │   ├── database/          # MongoDB models
│   │   ├── middleware/        # Express middleware
│   │   └── utils/             # Utilities
│   ├── .env.example
│   ├── package.json
│   └── Dockerfile
│
├── app/                        # Flutter app
│   └── lib/
│       ├── core/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── extension/                  # Browser extension
    ├── manifest.json
    ├── popup/
    ├── content/
    └── background/
```

---

## 🎯 Recommended Reading Order

### For New Developers
1. README.md - Project overview
2. GETTING_STARTED.md - Get it running
3. docs/product_concept.md - Understand the product
4. docs/technical_specification.md - Understand the architecture
5. docs/implementation/mvp/AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md - MVP implementation

### For Setup & Installation
1. GETTING_STARTED.md - Complete setup guide (Docker + Local)
2. RUN_WITHOUT_DOCKER.md - Detailed local setup guide

### For Understanding the System
1. docs/product_concept.md - Product vision
2. docs/product_specification.md - Requirements
3. docs/technical_specification.md - Architecture
4. docs/implementation/mvp/AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md - Implementation details

---

## 🆘 Getting Help

### Documentation
- Start with [GETTING_STARTED.md](GETTING_STARTED.md)
- Check relevant setup guide
- Review [README.md](README.md)

### Troubleshooting
- Check [GETTING_STARTED.md](GETTING_STARTED.md) for common issues
- Check [RUN_WITHOUT_DOCKER.md](RUN_WITHOUT_DOCKER.md) for local setup issues
- Review troubleshooting sections in each guide

### Community
- Open a GitHub issue
- Check existing issues
- Review documentation

---

## 📝 Documentation Maintenance

### Adding New Documentation
1. Create the markdown file
2. Add to this index (DOCUMENTATION_INDEX.md)
3. Update README.md if needed
4. Commit and push

### Updating Documentation
1. Keep all guides in sync
2. Update this index when adding new docs
3. Maintain consistent formatting
4. Test all instructions

---

## 🎓 Learning Path

### Beginner
- Read README.md
- Follow GETTING_STARTED.md
- Get the system running
- Explore the codebase

### Intermediate
- Read product_concept.md
- Read technical_specification.md
- Review docs/implementation/mvp/AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md
- Start making changes

### Advanced
- Contribute to architecture
- Add new features
- Improve documentation
- Help others

---

## 📊 File Categories

### Setup & Installation (2 files)
- GETTING_STARTED.md
- RUN_WITHOUT_DOCKER.md

### Product Documentation (3 files)
- docs/product_concept.md
- docs/product_specification.md
- docs/technical_specification.md

### Implementation Documentation
- **[docs/implementation/README.md](docs/implementation/README.md)** - Implementation guidelines index
- **[docs/implementation/mvp/AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md](docs/implementation/mvp/AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md)** - **MVP implementation guide (authoritative)**
- **[docs/MVP_OVERVIEW.md](docs/MVP_OVERVIEW.md)** - Quick project overview

### Scripts (2 files)
- start-dev.sh
- start-local.sh

### Configuration (5 files)
- docker-compose.dev.yml
- docker-compose.prod.yml
- services/Dockerfile
- services/.env.example
- app/pubspec.yaml

---

**Last Updated**: March 2026
**Version**: 1.0.0 (MVP)

---

*This index serves as your navigation hub for all L2L documentation. Start with GETTING_STARTED.md if you're new!*
