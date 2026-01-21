# 🚀 L2L Getting Started Guide

Welcome to **L2L (Link to Learn)** - An AI-powered learning bookmark platform.

## Quick Start

### Choose Your Setup Method

**Option A: Docker (Recommended)**
```bash
cd /Users/bs0650/R&D/AI/L2L
./start-dev.sh
```

**Option B: Local Setup**
```bash
cd /Users/bs0650/R&D/AI/L2L
./start-local.sh
```

---

## Docker Setup (Recommended)

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
./start-dev.sh
```

**Manual:**
```bash
docker-compose -f docker-compose.dev.yml up -d
```

### Access Points
- **API**: http://localhost:3000
- **Health Check**: http://localhost:3000/health
- **MongoDB**: mongodb://localhost:27017
- **Redis**: redis://localhost:6379

---

## Common Commands

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

## Project Structure

```
L2L/
├── services/              # Backend API (Node.js/TypeScript)
│   ├── src/              # Source code
│   │   ├── modules/      # Feature modules
│   │   ├── database/     # MongoDB models
│   │   └── middleware/   # Express middleware
│   └── .env              # Environment variables
├── app/                  # Flutter app
├── extension/            # Browser extension
└── docs/                 # Documentation
```

---

## API Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login user
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

---

## Troubleshooting

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

## Testing

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
```

---

## Environment Setup

Create `.env` file in `services/` directory:

```env
NODE_ENV=development
PORT=3000
MONGODB_URI=mongodb://localhost:27017/l2l_dev
REDIS_URL=redis://localhost:6379
JWT_SECRET=change-this-to-a-random-secret-key
REFRESH_TOKEN_SECRET=change-this-to-another-random-secret
```

---

## Running the App

### Flutter App
```bash
cd app
flutter pub get
flutter run
```

### Browser Extension
1. Open Chrome/Edge: `chrome://extensions/`
2. Enable "Developer mode"
3. Click "Load unpacked"
4. Select `extension/` directory

---

## What's Included

- ✅ **Backend API** - Node.js/TypeScript with 20+ RESTful endpoints
- ✅ **Flutter App** - Cross-platform mobile/web application
- ✅ **Browser Extension** - Chrome/Edge extension for saving content
- ✅ **Database** - MongoDB for data persistence
- ✅ **Cache** - Redis for session management
- ✅ **Authentication** - JWT-based auth with refresh tokens
- ✅ **Content Management** - Topics, Projects, and Bookmarks
- ✅ **Testing** - Jest testing infrastructure

---

## Documentation

- **[README.md](README.md)** - Project overview
- **[RUN_WITHOUT_DOCKER.md](RUN_WITHOUT_DOCKER.md)** - Local development without Docker
- **[docs/MVP_OVERVIEW.md](docs/MVP_OVERVIEW.md)** - Project overview
- **[docs/IMPLEMENTATION_SUMMARY.md](docs/IMPLEMENTATION_SUMMARY.md)** - Technical details

---

**Last Updated**: January 2025
**Version**: 1.0.0 (MVP)
