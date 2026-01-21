# 🐳 Docker Complete Guide - L2L Development

The comprehensive guide to installing, configuring, and using Docker for L2L development.

## 📑 Table of Contents

1. [Why Docker?](#why-docker)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Running L2L with Docker](#running-l2l-with-docker)
5. [Common Commands](#common-commands)
6. [Troubleshooting](#troubleshooting)
7. [Advanced Usage](#advanced-usage)

---

## Why Docker?

### Benefits of Using Docker
- ✅ **Single Command Startup** - Start all services at once
- ✅ **Isolated Environment** - No conflicts with local installations
- ✅ **Consistency** - Same environment across all machines
- ✅ **Easy Setup** - No need to install MongoDB, Redis, or Node.js separately
- ✅ **Clean Removal** - Easy to stop and remove everything

### What Docker Runs for L2L
- **MongoDB** - Database (port 27017)
- **Redis** - Cache layer (port 6379)
- **L2L API** - Backend server (port 3000)

---

## Installation

### Option 1: Direct Download (Recommended - Fastest)

1. **Download Docker Desktop**:
   - Visit: https://www.docker.com/products/docker-desktop/
   - Click "Download for Mac"
   - Choose **Apple Silicon** (for M1/M2/M3) or **Intel Chip** based on your Mac

2. **Install Docker Desktop**:
   ```bash
   # Open the downloaded Docker.dmg file
   # Drag Docker to Applications folder
   # Eject the DMG when complete
   ```

3. **Launch Docker Desktop**:
   - Open Applications folder
   - Double-click Docker.app
   - Complete the setup wizard
   - Wait for Docker to start (Docker icon appears in menu bar)

### Option 2: Homebrew Installation

```bash
# Update Homebrew
brew update

# Install Docker Desktop
brew install --cask docker

# Launch Docker Desktop
open -a Docker
```

### Option 3: Colima (Lightweight Alternative)

If Docker Desktop has issues, try **Colima** - a lightweight Docker alternative for Mac:

```bash
# Install Colima and Docker CLI
brew install docker colima

# Start Colima
colima start

# Verify
docker info
```

**Colima advantages:**
- ✅ Lighter weight than Docker Desktop
- ✅ Faster startup
- ✅ Better resource management
- ✅ Full Docker compatibility

### Verify Installation

After installing, verify Docker is working:

```bash
# Check Docker version
docker --version

# Check Docker is running
docker info

# Test with hello-world
docker run hello-world
```

Expected output:
```
Docker version 24.0.x or higher
Hello from Docker!
```

---

## Configuration

### Environment Setup

1. **Navigate to project directory**:
   ```bash
   cd /Users/bs0650/R&D/AI/L2L
   ```

2. **Copy environment template**:
   ```bash
   cp services/.env.example services/.env
   ```

3. **Edit environment file** (optional - defaults work for dev):
   ```bash
   # Open in your editor
   nano services/.env
   # or
   code services/.env
   ```

4. **Minimum required settings**:
   ```env
   NODE_ENV=development
   PORT=3000
   MONGODB_URI=mongodb://localhost:27017/l2l_dev
   REDIS_URL=redis://localhost:6379
   JWT_SECRET=change-this-to-a-random-secret-key
   REFRESH_TOKEN_SECRET=change-this-to-another-random-secret
   ```

### Docker Compose Files

The project includes two Docker Compose configurations:

#### Development: `docker-compose.dev.yml`
- Hot reload enabled
- Volume mounting for live code changes
- Debug logging
- Lower resource limits

#### Production: `docker-compose.prod.yml`
- Optimized builds
- No volume mounting (code baked in)
- Production logging
- Higher resource limits
- Multiple replicas

---

## Running L2L with Docker

### Quick Start (Automated)

Use the startup script for easiest setup:

```bash
cd /Users/bs0650/R&D/AI/L2L
./start-dev.sh
```

This script will:
1. Check if Docker is installed and running
2. Create environment file if needed
3. Start all services (MongoDB, Redis, API)
4. Verify services are healthy
5. Display access information

### Manual Start

#### Option 1: Start All Services
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

### Verify Services

```bash
# Check container status
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

### Access the Application

Once running:
- **API**: http://localhost:3000
- **Health Check**: http://localhost:3000/health
- **MongoDB**: mongodb://localhost:27017
- **Redis**: redis://localhost:6379

---

## Common Commands

### View Logs

```bash
# All services
docker-compose -f docker-compose.dev.yml logs -f

# Specific service
docker-compose -f docker-compose.dev.yml logs -f api
docker-compose -f docker-compose.dev.yml logs -f mongodb
docker-compose -f docker-compose.dev.yml logs -f redis

# Last 100 lines
docker-compose -f docker-compose.dev.yml logs --tail=100
```

### Stop Services

```bash
# Stop all services
docker-compose -f docker-compose.dev.yml down

# Stop and remove volumes (WARNING: clears data)
docker-compose -f docker-compose.dev.yml down -v
```

### Restart Services

```bash
# Restart all services
docker-compose -f docker-compose.dev.yml restart

# Restart specific service
docker-compose -f docker-compose.dev.yml restart api
```

### Rebuild Services

```bash
# Rebuild and restart
docker-compose -f docker-compose.dev.yml up -d --build

# Rebuild specific service
docker-compose -f docker-compose.dev.yml up -d --build api

# Rebuild without cache
docker-compose -f docker-compose.dev.yml build --no-cache
```

### Execute Commands in Containers

```bash
# Access API container
docker-compose -f docker-compose.dev.yml exec api sh

# Access MongoDB
docker-compose -f docker-compose.dev.yml exec mongodb mongosh

# Access Redis
docker-compose -f docker-compose.dev.yml exec redis redis-cli
```

### Monitor Resources

```bash
# View container resource usage
docker stats

# View specific container
docker stats l2l-api l2l-mongodb l2l-redis
```

---

## Troubleshooting

### Installation Issues

#### Docker won't start
```bash
# Check Docker Desktop is running
ps aux | grep Docker

# Restart Docker Desktop
killall Docker
sleep 5
open -a Docker

# Check Docker logs
~/Library/Containers/com.docker.docker/Data/log/host
```

#### Docker command not found
```bash
# Add Docker to PATH (add to ~/.zshrc or ~/.bash_profile)
export PATH="/opt/homebrew/bin:$PATH"

# Reload shell
source ~/.zshrc

# Verify
docker --version
```

### Port Conflicts

#### Port 3000 already in use
```bash
# Check what's using the port
lsof -i :3000

# Kill the process
kill -9 <PID>

# Or change ports in docker-compose.dev.yml
```

#### Port 27017 already in use
```bash
# Check what's using MongoDB port
lsof -i :27017

# Check if local MongoDB is running
brew services list | grep mongodb

# Stop local MongoDB if running
brew services stop mongodb-community
```

#### Port 6379 already in use
```bash
# Check what's using Redis port
lsof -i :6379

# Check if local Redis is running
brew services list | grep redis

# Stop local Redis if running
brew services stop redis
```

### Container Issues

#### Container won't start
```bash
# Check container logs
docker-compose -f docker-compose.dev.yml logs <service-name>

# Rebuild without cache
docker-compose -f docker-compose.dev.yml up -d --build --force-recreate

# Reset everything (WARNING: deletes data)
docker-compose -f docker-compose.dev.yml down -v
docker-compose -f docker-compose.dev.yml up -d
```

#### Database connection issues
```bash
# Check MongoDB is running
docker-compose -f docker-compose.dev.yml logs mongodb

# Restart MongoDB
docker-compose -f docker-compose.dev.yml restart mongodb

# Clear and restart (WARNING: deletes data)
docker-compose -f docker-compose.dev.yml down -v
docker-compose -f docker-compose.dev.yml up -d
```

#### API not responding
```bash
# Check API logs
docker-compose -f docker-compose.dev.yml logs api

# Check if API container is running
docker-compose -f docker-compose.dev.yml ps

# Restart API
docker-compose -f docker-compose.dev.yml restart api

# Access container shell for debugging
docker-compose -f docker-compose.dev.yml exec api sh
```

### Permission Issues

```bash
# Fix Docker permissions
sudo chown -R $USER /var/run/docker.sock

# Fix volume permissions
sudo chown -R $USER:$(id -gn) .
```

### Performance Issues

```bash
# Increase Docker resources
# Docker Desktop > Settings > Resources > Memory (8GB+ recommended)

# Clean up unused resources
docker system prune -a

# Remove unused images
docker image prune -a

# Remove unused containers
docker container prune

# Remove unused volumes
docker volume prune
```

### Reset Everything

If everything is broken and you want to start fresh:

```bash
# Stop and remove everything
docker-compose -f docker-compose.dev.yml down -v

# Remove all Docker images
docker rmi $(docker images -q)

# Rebuild and start
docker-compose -f docker-compose.dev.yml up -d --build
```

---

## Advanced Usage

### Development Workflow

#### 1. Start Services
```bash
docker-compose -f docker-compose.dev.yml up -d
```

#### 2. Run Backend Tests
```bash
cd services
npm test
```

#### 3. Run Flutter App
```bash
cd app
flutter run
```

#### 4. Load Browser Extension
1. Open Chrome/Edge: `chrome://extensions/`
2. Enable "Developer mode"
3. Click "Load unpacked"
4. Select `extension/` directory

#### 5. Stop Everything
```bash
docker-compose -f docker-compose.dev.yml down
```

### Production Deployment

```bash
# Build for production
docker-compose -f docker-compose.prod.yml build

# Start production services
docker-compose -f docker-compose.prod.yml up -d

# View production logs
docker-compose -f docker-compose.prod.yml logs -f
```

### Database Management

#### Backup MongoDB
```bash
# Create backup
docker-compose -f docker-compose.dev.yml exec mongodb mongodump --out /backup/

# Copy backup to host
docker cp l2l-mongodb:/backup ./backup
```

#### Restore MongoDB
```bash
# Copy backup to container
docker cp ./backup l2l-mongodb:/backup

# Restore
docker-compose -f docker-compose.dev.yml exec mongodb mongorestore /backup/
```

#### Access MongoDB Shell
```bash
# Using docker-compose
docker-compose -f docker-compose.dev.yml exec mongodb mongosh

# Using docker
docker exec -it l2l-mongodb mongosh

# Once in shell
use l2l_dev
db.users.find()
exit
```

### Redis Management

#### Access Redis CLI
```bash
# Using docker-compose
docker-compose -f docker-compose.dev.yml exec redis redis-cli

# Using docker
docker exec -it l2l-redis redis-cli

# Once in CLI
ping
keys *
exit
```

#### Clear Redis Cache
```bash
docker-compose -f docker-compose.dev.yml exec redis redis-cli FLUSHALL
```

### Custom Commands

#### Run npm commands in API container
```bash
docker-compose -f docker-compose.dev.yml exec api npm install
docker-compose -f docker-compose.dev.yml exec api npm test
docker-compose -f docker-compose.dev.yml exec api npm run build
```

#### View container stats
```bash
docker stats l2l-api l2l-mongodb l2l-redis
```

#### Inspect container
```bash
docker inspect l2l-api
docker inspect l2l-mongodb
docker inspect l2l-redis
```

---

## Docker Compose Reference

### Services

#### API Service
- **Image**: Node.js 18 Alpine
- **Ports**: 3000:3000
- **Volumes**: Mounts `services/` for hot reload
- **Dependencies**: mongodb, redis
- **Environment**: Loaded from `services/.env`

#### MongoDB Service
- **Image**: MongoDB 6.0
- **Ports**: 27017:27017
- **Volumes**: `mongodb_data` for persistence
- **Command**: WiredTiger engine with logging

#### Redis Service
- **Image**: Redis 7.0 Alpine
- **Ports**: 6379:6379
- **Volumes**: `redis_data` for persistence
- **Command**: With append-only file enabled

### Volumes

- **mongodb_data**: MongoDB data persistence
- **redis_data**: Redis data persistence

### Networks

- **l2l_network**: Bridge network for service communication

---

## Environment Variables

### Required Variables

```env
# Application
NODE_ENV=development
PORT=3000
API_VERSION=v1

# Database
MONGODB_URI=mongodb://localhost:27017/l2l_dev

# Cache
REDIS_URL=redis://localhost:6379

# Authentication
JWT_SECRET=your-secret-key-here
REFRESH_TOKEN_SECRET=your-refresh-secret-here
```

### Optional Variables

```env
# OpenAI
OPENAI_API_KEY=your-openai-key

# AWS
AWS_ACCESS_KEY_ID=your-aws-key
AWS_SECRET_ACCESS_KEY=your-aws-secret
S3_BUCKET=l2l-assets

# Email
SMTP_HOST=smtp.gmail.com
SMTP_USER=your-email
SMTP_PASSWORD=your-password

# Stripe
STRIPE_SECRET_KEY=your-stripe-key
```

---

## Tips & Best Practices

### Development Tips

1. **Use the startup script**: `./start-dev.sh`
2. **Keep Docker running** in the background
3. **Check logs** if something isn't working
4. **Use volume mounts** for hot reload in development
5. **Restart services** after config changes

### Performance Tips

1. **Allocate enough resources** to Docker (8GB+ RAM)
2. **Clean up unused resources** regularly
3. **Use .dockerignore** to exclude unnecessary files
4. **Limit log size** in production
5. **Use multi-stage builds** for smaller images

### Security Tips

1. **Never commit** `.env` files
2. **Use secrets management** in production
3. **Limit container resources** to prevent DoS
4. **Scan images** for vulnerabilities
5. **Keep Docker updated**

---

## Quick Reference

### Essential Commands

```bash
# Start everything
docker-compose -f docker-compose.dev.yml up -d

# View logs
docker-compose -f docker-compose.dev.yml logs -f

# Stop everything
docker-compose -f docker-compose.dev.yml down

# Restart services
docker-compose -f docker-compose.dev.yml restart

# Rebuild
docker-compose -f docker-compose.dev.yml up -d --build

# Check status
docker-compose -f docker-compose.dev.yml ps
```

### Access Points

- **API**: http://localhost:3000
- **Health**: http://localhost:3000/health
- **MongoDB**: mongodb://localhost:27017
- **Redis**: redis://localhost:6379

### Container Names

- **API**: l2l-api
- **MongoDB**: l2l-mongodb
- **Redis**: l2l-redis

---

## System Requirements

### macOS
- **OS**: Big Sur (11.0) or later
- **RAM**: 4GB minimum, 8GB recommended
- **Disk**: 20GB free space
- **Architecture**: Apple Silicon (M1/M2/M3) or Intel

### Docker Resources
- **Memory**: 4GB minimum, 8GB recommended
- **CPU**: 2 cores minimum, 4 cores recommended
- **Disk**: 20GB minimum

---

## Next Steps

1. ✅ Install Docker
2. ✅ Start development environment: `./start-dev.sh`
3. ✅ Test the API: `curl http://localhost:3000/health`
4. ✅ Run Flutter app: `cd app && flutter run`
5. ✅ Load browser extension
6. ✅ Start building features!

---

## Additional Resources

- [Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [L2L Documentation](./DOCUMENTATION_INDEX.md)

---

## Support

### Documentation
- [README.md](README.md) - Project overview
- [QUICKSTART.md](QUICKSTART.md) - Quick start guide
- [RUN_WITHOUT_DOCKER.md](RUN_WITHOUT_DOCKER.md) - Local development without Docker

### Troubleshooting
- Check logs: `docker-compose logs -f`
- Check container status: `docker-compose ps`
- Restart Docker Desktop
- Clear Docker cache and rebuild

---

**Last Updated**: January 2025
**Version**: 1.0.0

*This guide covers everything you need to use Docker for L2L development.*
