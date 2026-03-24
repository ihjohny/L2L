# 📚 L2L Documentation Index

Complete guide to all L2L documentation and how to use it.

## 🚀 Getting Started (Start Here!)

### New to L2L? Start with these:
1. **[README.md](README.md)** - Complete project overview, setup guide, and quick start
2. **[docs/implementation/06_dev_environment.md](docs/implementation/06_dev_environment.md)** - Detailed development environment setup
3. **[docs/implementation/README.md](docs/implementation/README.md)** - Implementation guidelines index

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

### Project Planning
- **[docs/project_plan.md](docs/project_plan.md)** - Project planning documentation
- **[docs/WBS.md](docs/WBS.md)** - Work Breakdown Structure
- **[docs/effort_estimation.md](docs/effort_estimation.md)** - Effort estimation details

### Technical Documentation
- **[docs/technical_specification.md](docs/technical_specification.md)** - Technical architecture
  - System architecture
  - Technology stack
  - Database design
  - API specifications
  - Security considerations

---

## 🛠️ Implementation Guidelines

Complete implementation reference organized by topic. See **[docs/implementation/README.md](docs/implementation/README.md)** for the full index.

### Core Implementation
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
- **[docs/implementation/mvp/AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md](docs/implementation/mvp/AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md)** - **Authoritative MVP implementation guide**
  - Database schema (users, projects, links, ai_outputs, jobs)
  - Module structure and code patterns
  - API endpoints reference
  - Two-tier AI processing flow
  - Verification checklist

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

**Full API documentation**: See [docs/implementation/04_api_design.md](docs/implementation/04_api_design.md)

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

For more troubleshooting, see [docs/implementation/11_observability_operations.md](docs/implementation/11_observability_operations.md)

---

## 📈 Project Structure

```
L2L/
├── README.md                    # Start here!
├── DOCUMENTATION_INDEX.md       # This file!
├── start-dev.sh                 # Docker startup script
├── start-local.sh               # Local startup script
│
├── docs/                        # Product & technical docs
│   ├── product_concept.md
│   ├── product_specification.md
│   ├── technical_specification.md
│   ├── project_plan.md
│   ├── WBS.md
│   ├── effort_estimation.md
│   └── implementation/          # Implementation guides
│       ├── README.md            # Implementation index
│       ├── 01_architecture_overview.md
│       ├── 02_implementation_details.md
│       ├── 03_database_schema.md
│       ├── 04_api_design.md
│       ├── 05_configuration.md
│       ├── 06_dev_environment.md
│       ├── 07_deployment_cicd.md
│       ├── 08_microservices_migration.md
│       ├── 09_security_guidelines.md
│       ├── 10_testing_strategy.md
│       ├── 11_observability_operations.md
│       ├── 12_pre_launch_checklist.md
│       └── mvp/
│           └── AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md
│
├── services/                    # Backend API
│   ├── src/
│   │   ├── modules/            # Feature modules
│   │   ├── database/           # MongoDB models
│   │   ├── middleware/         # Express middleware
│   │   └── utils/              # Utilities
│   ├── .env.example
│   ├── package.json
│   └── Dockerfile
│
├── app/                         # Flutter application
│   └── lib/
│       ├── core/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── extension/                   # Browser extension
    ├── manifest.json
    ├── popup/
    ├── content/
    └── background/
```

---

## 🎯 Recommended Reading Order

### For New Developers
1. README.md - Project overview
2. docs/implementation/06_dev_environment.md - Get environment running
3. docs/product_concept.md - Understand the product
4. docs/technical_specification.md - Understand the architecture
5. docs/implementation/01_architecture_overview.md - System architecture details
6. docs/implementation/mvp/AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md - MVP implementation

### For Understanding the System
1. docs/product_concept.md - Product vision
2. docs/product_specification.md - Requirements
3. docs/technical_specification.md - High-level architecture
4. docs/implementation/01_architecture_overview.md - Detailed architecture
5. docs/implementation/ - Implementation guidelines by topic

### For DevOps & Deployment
1. docs/implementation/06_dev_environment.md - Local setup
2. docs/implementation/07_deployment_cicd.md - CI/CD pipelines
3. docs/implementation/11_observability_operations.md - Monitoring and alerting
4. docs/implementation/12_pre_launch_checklist.md - Launch preparation

---

## 🆘 Getting Help

### Documentation
- Start with [README.md](README.md)
- Check [docs/implementation/README.md](docs/implementation/README.md) for implementation guides
- Review troubleshooting sections in relevant guides

### Community
- Open a GitHub issue
- Check existing issues
- Review documentation

---

## 📝 Documentation Maintenance

### Adding New Documentation
1. Create the markdown file in appropriate directory
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
- Follow docs/implementation/06_dev_environment.md
- Get the system running
- Explore the codebase

### Intermediate
- Read docs/product_concept.md
- Read docs/technical_specification.md
- Review implementation guidelines (01-12)
- Start making changes

### Advanced
- Contribute to architecture
- Add new features
- Improve documentation
- Help others

---

## 📊 File Categories

### Product Documentation (3 files)
- docs/product_concept.md
- docs/product_specification.md
- docs/technical_specification.md

### Project Planning (3 files)
- docs/project_plan.md
- docs/WBS.md
- docs/effort_estimation.md

### Implementation Guidelines (12 files + MVP)
- docs/implementation/01_architecture_overview.md through 12_pre_launch_checklist.md
- docs/implementation/mvp/AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md

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

*This index serves as your navigation hub for all L2L documentation. Start with [README.md](README.md) if you're new!*
