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
- `POST /api/v1/auth/register` - Register new user (email, password, name)
- `POST /api/v1/auth/login` - Login user
- `POST /api/v1/auth/refresh` - Refresh access token
- `GET /api/v1/auth/me` - Get current user profile

### Projects
- `GET /api/v1/projects` - List user's projects
- `POST /api/v1/projects` - Create new project
- `GET /api/v1/projects/:id` - Get project details (with links)
- `PUT /api/v1/projects/:id` - Update project
- `DELETE /api/v1/projects/:id` - Soft delete project
- `POST /api/v1/projects/:id/generate-course` - Generate AI course from project links

### Links
- `GET /api/v1/links` - List user's links (optionally by project)
- `POST /api/v1/links` - Save new link (queues AI processing)
- `GET /api/v1/links/:id` - Get link with AI summary and flashcards
- `PUT /api/v1/links/:id` - Update link
- `DELETE /api/v1/links/:id` - Soft delete link

### Jobs
- `GET /api/v1/jobs/:jobId` - Get job status (processing, completed, failed)

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

# Or run on Chrome
flutter run -d chrome
```

### Browser Extension
1. Open Chrome/Edge: `chrome://extensions/`
2. Enable "Developer mode"
3. Click "Load unpacked"
4. Select `extension/` directory

---

## Quick Reference

### Ready to Run? Quick Start Commands

```bash
# Navigate to project
cd /Users/bs0650/R&D/AI/L2L

# Start development (once Docker is ready)
./start-dev.sh

# Run Flutter app
cd app && flutter run

# Load browser extension
# Open chrome://extensions/ and load the extension folder
```

### Test the API

```bash
# Register a new user
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Password123",
    "name": "Test User"
  }'

# Login
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Password123"
  }'

# Create a project (requires auth token)
curl -X POST http://localhost:3000/api/v1/projects \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "name": "My Learning Project",
    "description": "Learning web development"
  }'

# Save a link (requires auth token)
curl -X POST http://localhost:3000/api/v1/links \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "url": "https://example.com/article",
    "projectId": "PROJECT_ID"
  }'
```

### What You Can Do Now

1. **Explore the API** - Test endpoints with Postman or curl
2. **Run the Flutter app** - See the mobile/web interface
3. **Load the extension** - Save web pages to L2L
4. **Build features** - Start implementing AI processing!
5. **Run tests** - `cd services && npm test`

### Tips

- First-time Docker startup may take a few minutes
- Keep Docker Desktop running in the background
- Use `./start-dev.sh` for easy startup
- Check logs if something isn't working
- All data persists in Docker volumes

---

## What's Included

- ✅ **Backend API** - Node.js/TypeScript with RESTful endpoints (Auth, Projects, Links, AI processing)
- ✅ **Flutter App** - Cross-platform mobile/web application
- ✅ **Browser Extension** - Chrome/Edge extension for saving content
- ✅ **Database** - MongoDB for data persistence
- ✅ **Cache/Queue** - Redis + BullMQ for async job processing
- ✅ **Authentication** - JWT-based auth with refresh tokens
- ✅ **Two-Tier AI Processing** - Per-link (summary+flashcards) and Per-project (course+quiz)
- ✅ **Testing** - Jest testing infrastructure

---

## Documentation

- **[README.md](README.md)** - Project overview
- **[RUN_WITHOUT_DOCKER.md](RUN_WITHOUT_DOCKER.md)** - Local development without Docker
- **[docs/implementation/mvp/AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md](docs/implementation/mvp/AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md)** - MVP implementation guide
- **[docs/MVP_OVERVIEW.md](docs/MVP_OVERVIEW.md)** - Quick project overview
- **[docs/IMPLEMENTATION_SUMMARY.md](docs/IMPLEMENTATION_SUMMARY.md)** - Technical implementation details

---

**Last Updated**: March 2026
**Version**: 1.0.0 (MVP)
