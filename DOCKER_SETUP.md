# Docker Setup Guide for L2L Project

## Prerequisites

- macOS 11 or later (Big Sur or newer recommended)
- At least 4GB RAM available for Docker
- 20GB free disk space

## Installation Steps

### Method 1: Homebrew (Recommended)

1. **Install Homebrew** (if not already installed):
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. **Install Docker Desktop**:
```bash
brew install --cask docker
```

3. **Start Docker Desktop**:
   - Open Applications folder
   - Double-click Docker.app
   - Wait for Docker to start (Docker icon in menu bar)

### Method 2: Manual Download

1. **Download Docker Desktop**:
   - Visit: https://www.docker.com/products/docker-desktop/
   - Click "Download for Mac"
   - Choose **Apple Silicon** or **Intel Chip** based on your Mac

2. **Install**:
   - Open the downloaded .dmg file
   - Drag Docker to Applications folder
   - Launch Docker from Applications

3. **Complete Setup**:
   - Follow the setup wizard
   - Enter your password when prompted
   - Wait for Docker Engine to start

## Verify Installation

Open a new terminal and run:

```bash
# Check Docker version
docker --version

# Check Docker is running
docker info

# Test Docker with hello-world
docker run hello-world
```

Expected output:
```
Docker version 24.0.x or higher
Hello from Docker!
```

## Project Setup

Once Docker is installed and running, navigate to the project:

```bash
cd /Users/bs0650/R&D/AI/L2L
```

### Environment Configuration

1. **Copy environment template**:
```bash
cp services/.env.example services/.env
```

2. **Edit environment file** (optional - defaults work for dev):
```bash
# Open in your editor
nano services/.env
# or
code services/.env
```

3. **Minimum required settings**:
```env
NODE_ENV=development
PORT=3000
MONGODB_URI=mongodb://localhost:27017/l2l_dev
REDIS_URL=redis://localhost:6379
JWT_SECRET=change-this-to-a-random-secret-key
REFRESH_TOKEN_SECRET=change-this-to-another-random-secret
```

### Start Development Environment

#### Option 1: Start All Services (Recommended)

```bash
docker-compose -f docker-compose.dev.yml up -d
```

This starts:
- MongoDB (port 27017)
- Redis (port 6379)
- L2L API (port 3000)

#### Option 2: Start Services Individually

```bash
# Start only databases
docker-compose -f docker-compose.dev.yml up mongodb redis -d

# Start API with hot reload (requires Node.js locally)
cd services
npm install
npm run dev
```

### Verify Services are Running

```bash
# Check containers
docker-compose -f docker-compose.dev.yml ps

# View logs
docker-compose -f docker-compose.dev.yml logs -f

# Check API health
curl http://localhost:3000/health
```

Expected response:
```json
{
  "status": "ok",
  "timestamp": "2025-01-15T...",
  "uptime": ...,
  "database": "connected",
  "environment": "development"
}
```

## Access the Application

- **API**: http://localhost:3000
- **API Docs**: http://localhost:3000/api/v1/docs (when implemented)
- **Health Check**: http://localhost:3000/health

## Common Commands

### View Logs
```bash
# All services
docker-compose -f docker-compose.dev.yml logs -f

# Specific service
docker-compose -f docker-compose.dev.yml logs -f api
docker-compose -f docker-compose.dev.yml logs -f mongodb
```

### Stop Services
```bash
# Stop all services
docker-compose -f docker-compose.dev.yml down

# Stop and remove volumes (clears data)
docker-compose -f docker-compose.dev.yml down -v
```

### Restart Services
```bash
docker-compose -f docker-compose.dev.yml restart
```

### Rebuild Services
```bash
# Rebuild and restart
docker-compose -f docker-compose.dev.yml up -d --build

# Rebuild specific service
docker-compose -f docker-compose.dev.yml up -d --build api
```

## Troubleshooting

### Port Already in Use

If you get "port is already allocated" error:

```bash
# Check what's using the port
lsof -i :3000  # API
lsof -i :27017 # MongoDB
lsof -i :6379  # Redis

# Kill the process
kill -9 <PID>
```

### Permission Issues

```bash
# Fix Docker permissions
sudo chown -R $USER /var/run/docker.sock
```

### Container Won't Start

```bash
# Check container logs
docker-compose -f docker-compose.dev.yml logs <service-name>

# Rebuild without cache
docker-compose -f docker-compose.dev.yml build --no-cache
```

### Database Connection Issues

```bash
# Check MongoDB is running
docker-compose -f docker-compose.dev.yml logs mongodb

# Restart MongoDB
docker-compose -f docker-compose.dev.yml restart mongodb

# Clear and restart (WARNING: deletes data)
docker-compose -f docker-compose.dev.yml down -v
docker-compose -f docker-compose.dev.yml up -d
```

## Development Workflow

### 1. Start Services
```bash
docker-compose -f docker-compose.dev.yml up -d
```

### 2. Run Backend Tests
```bash
cd services
npm test
```

### 3. Run Flutter App
```bash
cd app
flutter pub get
flutter run
```

### 4. Load Browser Extension
1. Open Chrome/Edge: `chrome://extensions/`
2. Enable "Developer mode"
3. Click "Load unpacked"
4. Select `extension/` directory

### 5. Stop Everything
```bash
docker-compose -f docker-compose.dev.yml down
```

## Project Structure

```
L2L/
├── docker-compose.dev.yml      # Development Docker Compose
├── docker-compose.prod.yml     # Production Docker Compose
├── services/                   # Backend API
│   ├── src/                   # Source code
│   ├── .env                   # Environment variables
│   └── package.json           # Dependencies
├── app/                       # Flutter frontend
│   └── lib/                   # Flutter code
└── extension/                 # Browser extension
    └── manifest.json          # Extension manifest
```

## Useful Tips

### View Real-time Logs
```bash
docker-compose -f docker-compose.dev.yml logs -f --tail=100
```

### Execute Commands in Container
```bash
# Access API container
docker-compose -f docker-compose.dev.yml exec api sh

# Access MongoDB
docker-compose -f docker-compose.dev.yml exec mongodb mongosh

# Access Redis
docker-compose -f docker-compose.dev.yml exec redis redis-cli
```

### Monitor Resource Usage
```bash
docker stats
```

### Clean Up Unused Resources
```bash
# Remove unused images
docker image prune -a

# Remove unused containers
docker container prune

# Remove unused volumes
docker volume prune
```

## Next Steps

After Docker is running:

1. ✅ Test API endpoints with Postman or curl
2. ✅ Start Flutter app: `cd app && flutter run`
3. ✅ Load browser extension
4. ✅ Start building features!

## Support

If you encounter issues:

1. Check Docker Desktop is running
2. Check ports are not in use
3. Check logs: `docker-compose logs -f`
4. Restart Docker Desktop
5. Clear Docker cache and rebuild

## Resources

- Docker Desktop for Mac: https://docs.docker.com/desktop/install/mac-install/
- Docker Compose Docs: https://docs.docker.com/compose/
- L2L Documentation: ./docs/
