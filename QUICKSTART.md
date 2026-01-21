# 🚀 L2L Quick Start Guide

Welcome to **L2L (Link to Learn)** - An AI-powered learning bookmark platform that transforms passive bookmarking into active, structured learning experiences.

## 🎯 Choose Your Setup Method

You can run L2L in two ways:

### Option A: With Docker (Recommended - Easiest)
✅ Single command startup
✅ Isolated environment
✅ Consistent across machines

**See**: [DOCKER_GUIDE.md](DOCKER_GUIDE.md) | [READY_TO_RUN.md](READY_TO_RUN.md)

### Option B: Without Docker (Local Installation)
✅ Full control over services
✅ No Docker overhead
✅ Direct access to databases

**See**: [RUN_WITHOUT_DOCKER.md](RUN_WITHOUT_DOCKER.md)

---

## 📋 Quick Start

### With Docker (Once Docker is Installed)

```bash
cd /Users/bs0650/R&D/AI/L2L
./start-dev.sh
```

### Without Docker (Once Dependencies are Installed)

```bash
cd /Users/bs0650/R&D/AI/L2L
./start-local.sh
```

---

## 🎓 What's Included

### Complete MVP Implementation
- ✅ **Backend API** - Node.js/TypeScript with 20+ RESTful endpoints
- ✅ **Flutter App** - Cross-platform mobile/web application
- ✅ **Browser Extension** - Chrome/Edge extension for saving content
- ✅ **Database** - MongoDB for data persistence
- ✅ **Cache** - Redis for session management
- ✅ **Authentication** - JWT-based auth with refresh tokens
- ✅ **Content Management** - Topics, Projects, and Bookmarks
- ✅ **Testing** - Jest testing infrastructure

### Project Structure
```
L2L/
├── services/              # Backend API (Node.js/TypeScript)
│   ├── src/              # Source code
│   │   ├── modules/      # Feature modules (user, content)
│   │   ├── database/     # MongoDB models
│   │   ├── middleware/   # Express middleware
│   │   └── utils/        # Utilities
│   ├── .env              # Environment variables
│   └── package.json      # Dependencies
├── app/                  # Flutter app
│   └── lib/              # Flutter code
├── extension/            # Browser extension
│   ├── manifest.json     # Extension manifest
│   ├── popup/            # Popup UI
│   └── content/          # Content script
├── docs/                 # Documentation
└── *.md                  # Setup guides
```

---

## 🚦 Getting Started

### Step 1: Choose Your Setup Method

#### If you want the easiest setup (Docker):
1. Install Docker Desktop: https://www.docker.com/products/docker-desktop/
2. Run: `./start-dev.sh`

#### If you prefer local installations:
1. Install dependencies: MongoDB, Redis, Node.js
2. Run: `./start-local.sh`

**Full guides**: [DOCKER_GUIDE.md](DOCKER_GUIDE.md) | [RUN_WITHOUT_DOCKER.md](RUN_WITHOUT_DOCKER.md)

### Step 2: Verify Installation

```bash
# Test the API health endpoint
curl http://localhost:3000/health

# Expected response:
# {
#   "status": "ok",
#   "database": "connected",
#   "environment": "development"
# }
```

### Step 3: Explore the Application

#### Test the API
```bash
# Register a new user
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "username": "testuser",
    "password": "Password123",
    "firstName": "Test",
    "lastName": "User"
  }'
```

#### Run the Flutter App
```bash
cd app
flutter pub get
flutter run
```

#### Load the Browser Extension
1. Open Chrome/Edge: `chrome://extensions/`
2. Enable "Developer mode"
3. Click "Load unpacked"
4. Select `extension/` directory

---

## 📚 Documentation

### Setup & Installation
- **[QUICKSTART.md](QUICKSTART.md)** - You are here! Quick start guide
- **[DOCKER_INSTALLATION.md](DOCKER_INSTALLATION.md)** - Docker installation guide
- **[RUN_WITHOUT_DOCKER.md](RUN_WITHOUT_DOCKER.md)** - Local development setup
- **[READY_TO_RUN.md](READY_TO_RUN.md)** - Quick reference once ready

### Project Documentation
- **[MVP_OVERVIEW.md](docs/MVP_OVERVIEW.md)** - Project overview
- **[IMPLEMENTATION_SUMMARY.md](docs/IMPLEMENTATION_SUMMARY.md)** - Complete technical details
- **[Product Concept](docs/product_concept.md)** - Product vision
- **[Product Specification](docs/product_specification.md)** - Requirements
- **[Technical Specification](docs/technical_specification.md)** - Architecture

### Docker-Specific
- **[DOCKER_SETUP.md](DOCKER_SETUP.md)** - Docker setup guide
- **[DOCKER_STATUS.md](DOCKER_STATUS.md)** - Installation status tracker

---

## 🛠️ Development Workflow

### Start Services

#### With Docker
```bash
./start-dev.sh
```

#### Without Docker
```bash
./start-local.sh
```

### View Logs

#### With Docker
```bash
docker-compose -f docker-compose.dev.yml logs -f
```

#### Without Docker
```bash
# API logs are in the terminal where npm run dev is running
# MongoDB logs
tail -f /opt/homebrew/var/log/mongodb/mongo.log

# Redis logs
tail -f /opt/homebrew/var/log/redis.log
```

### Stop Services

#### With Docker
```bash
docker-compose -f docker-compose.dev.yml down
```

#### Without Docker
```bash
# Stop API (press Ctrl+C in terminal)
# Stop services
brew services stop mongodb-community redis
```

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

## 🔧 Troubleshooting

### Docker Issues
- **Problem**: Docker won't start
  - **Solution**: [DOCKER_INSTALLATION.md](DOCKER_INSTALLATION.md)

### Port Already in Use
```bash
# Check what's using the port
lsof -i :3000    # API
lsof -i :27017   # MongoDB
lsof -i :6379    # Redis

# Kill the process
kill -9 <PID>
```

### Database Connection Issues
```bash
# With Docker
docker-compose -f docker-compose.dev.yml ps

# Without Docker
brew services list

# Restart services
brew services restart mongodb-community
brew services restart redis
```

---

## 📖 API Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login user
- `POST /api/v1/auth/refresh` - Refresh token
- `GET /api/v1/auth/profile` - Get user profile
- `PUT /api/v1/auth/profile` - Update profile
- `DELETE /api/v1/auth/account` - Delete account

### Content Management
- `POST /api/v1/content/topics` - Create topic
- `GET /api/v1/content/topics` - List topics
- `POST /api/v1/content/projects` - Create project
- `GET /api/v1/content/projects` - List projects
- `POST /api/v1/content/entities` - Create bookmark
- `GET /api/v1/content/entities/:id` - Get bookmark

**Full API docs**: See [IMPLEMENTATION_SUMMARY.md](docs/IMPLEMENTATION_SUMMARY.md)

---

## 🎯 What's Next?

### Immediate Tasks
1. ✅ Get the development environment running
2. ✅ Test the API endpoints
3. ✅ Explore the Flutter app
4. ✅ Load the browser extension

### Development Tasks
1. 🚀 Implement AI processing service
2. 🚀 Add flashcard generation
3. 🚀 Add quiz generation
4. 🚀 Implement social features

See [Product Specification](docs/product_specification.md) for full roadmap.

---

## 🤝 Contributing

This is a complete MVP ready for development!

1. **Backend**: Add new features in `services/src/modules/`
2. **Frontend**: Add screens in `app/lib/presentation/pages/`
3. **Extension**: Extend functionality in `extension/`
4. **Tests**: Add tests in `services/src/**/__tests__/`

---

## 📊 Project Stats

- **71 files** created
- **8,940+ lines** of code
- **4 database** models
- **20+ API** endpoints
- **4 Flutter** screens
- **7 extension** files

---

## 🎉 You're Ready to Go!

Choose your setup method above, follow the guide, and start building the future of learning!

**Questions?** Check the documentation or open an issue on GitHub.

---

**Last Updated**: January 2025
**Version**: 1.0.0 (MVP)
**License**: MIT
