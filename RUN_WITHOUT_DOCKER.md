# 🚀 Running L2L Without Docker

This guide shows you how to run the L2L project using local installations instead of Docker.

## 📋 Prerequisites

You'll need to install the following software locally:

- **Node.js** (v18 or later) - Backend runtime
- **MongoDB** (v6.0 or later) - Database
- **Redis** (v7.0 or later) - Caching layer
- **Flutter** (v3.0 or later) - Mobile/Web app (optional)

## 🔧 Installation Guide

### 1. Install Node.js

#### Using Homebrew (Recommended)
```bash
brew install node@18

# Verify installation
node --version
npm --version
```

#### Using nvm (Node Version Manager)
```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Reload shell
source ~/.zshrc

# Install Node.js
nvm install 18
nvm use 18

# Verify
node --version
```

#### Manual Download
Visit: https://nodejs.org/ and download the LTS version for macOS.

### 2. Install MongoDB

#### Using Homebrew (Recommended)
```bash
# Install MongoDB Community Edition
brew tap mongodb/brew
brew install mongodb-community

# Start MongoDB
brew services start mongodb-community

# Verify installation
mongosh --version

# Test connection
mongosh
```

#### Manual Installation
1. Download from: https://www.mongodb.com/try/download/community
2. Install and follow the setup wizard
3. Start MongoDB:
   ```bash
   # Start MongoDB service
   sudo brew services start mongodb-community

   # Or run manually
   mongod --config /opt/homebrew/etc/mongod.conf
   ```

#### MongoDB Commands
```bash
# Start MongoDB
brew services start mongodb-community

# Stop MongoDB
brew services stop mongodb-community

# Restart MongoDB
brew services restart mongodb-community

# Check status
brew services list | grep mongodb

# Connect to MongoDB
mongosh

# Create database
use l2l_dev
```

### 3. Install Redis

#### Using Homebrew (Recommended)
```bash
# Install Redis
brew install redis

# Start Redis
brew services start redis

# Verify installation
redis-cli --version

# Test connection
redis-cli ping
# Should return: PONG
```

#### Manual Installation
1. Download from: https://redis.io/download
2. Compile and install:
   ```bash
   tar xvzf redis-*.tar.gz
   cd redis-*
   make
   make test
   make install
   ```

#### Redis Commands
```bash
# Start Redis
brew services start redis

# Stop Redis
brew services stop redis

# Restart Redis
brew services restart redis

# Check status
brew services list | grep redis

# Connect to Redis
redis-cli

# Test connection
redis-cli ping
```

### 4. Install Flutter (Optional - for mobile/web app)

```bash
# Install Flutter SDK
brew install flutter

# Setup Flutter
flutter doctor

# Accept Android licenses (if needed)
flutter doctor --android-licenses

# Verify installation
flutter --version
```

## 🚀 Starting the Project

### Step 1: Setup Environment

```bash
# Navigate to project directory
cd /Users/bs0650/R&D/AI/L2L

# Copy environment template
cp services/.env.example services/.env

# Edit .env file (optional - defaults work for local dev)
# Update these if needed:
# MONGODB_URI=mongodb://localhost:27017/l2l_dev
# REDIS_URL=redis://localhost:6379
```

### Step 2: Start Services

#### Terminal 1: Start MongoDB
```bash
# If not already running
brew services start mongodb-community

# Verify
mongosh
```

#### Terminal 2: Start Redis
```bash
# If not already running
brew services start redis

# Verify
redis-cli ping
```

#### Terminal 3: Start Backend API
```bash
# Navigate to services directory
cd /Users/bs0650/R&D/AI/L2L/services

# Install dependencies
npm install

# Start development server with hot reload
npm run dev

# Or start without hot reload
npm start
```

The API will start on **http://localhost:3000**

### Step 3: Verify Backend is Running

```bash
# In a new terminal, test the API
curl http://localhost:3000/health

# Expected response:
# {
#   "status": "ok",
#   "timestamp": "2025-01-15T...",
#   "uptime": ...,
#   "database": "connected",
#   "redis": "connected",
#   "environment": "development"
# }
```

### Step 4: Start Flutter App (Optional)

```bash
# Navigate to app directory
cd /Users/bs0650/R&D/AI/L2L/app

# Install dependencies
flutter pub get

# Run on web
flutter run -d chrome

# Or run on mobile device
flutter run

# Or run on desktop
flutter run -d macos
```

### Step 5: Load Browser Extension (Optional)

1. Open Chrome/Edge: `chrome://extensions/`
2. Enable "Developer mode"
3. Click "Load unpacked"
4. Navigate to: `/Users/bs0650/R&D/AI/L2L/extension`
5. Click "Select"

## 🛠️ Development Workflow

### Start All Services

Create a startup script or use these commands:

```bash
#!/bin/bash

# Start services
brew services start mongodb-community
brew services start redis

# Wait for services to be ready
sleep 3

# Start API
cd /Users/bs0650/R&D/AI/L2L/services
npm run dev
```

### Monitor Services

```bash
# Check MongoDB
mongosh
> db.adminCommand('ping')

# Check Redis
redis-cli ping

# Check API
curl http://localhost:3000/health

# Check logs
# API logs will be in the terminal where npm run dev is running
```

### Stop Services

```bash
# Stop API
# Press Ctrl+C in the terminal running npm run dev

# Stop MongoDB
brew services stop mongodb-community

# Stop Redis
brew services stop redis
```

## 🔍 Troubleshooting

### MongoDB Issues

#### Port 27017 already in use
```bash
# Check what's using the port
lsof -i :27017

# Kill the process
kill -9 <PID>

# Or restart MongoDB
brew services restart mongodb-community
```

#### Connection refused
```bash
# Check if MongoDB is running
brew services list | grep mongodb

# Start MongoDB
brew services start mongodb-community

# Check MongoDB logs
tail -f /opt/homebrew/var/log/mongodb/mongo.log
```

### Redis Issues

#### Port 6379 already in use
```bash
# Check what's using the port
lsof -i :6379

# Kill the process
kill -9 <PID>

# Or restart Redis
brew services restart redis
```

#### Connection refused
```bash
# Check if Redis is running
brew services list | grep redis

# Start Redis
brew services start redis

# Test connection
redis-cli ping
```

### Node.js/NPM Issues

#### Port 3000 already in use
```bash
# Check what's using the port
lsof -i :3000

# Kill the process
kill -9 <PID>

# Or change port in .env
PORT=3001 npm run dev
```

#### Module not found errors
```bash
# Clear npm cache
npm cache clean --force

# Delete node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

### Environment Issues

#### .env file not found
```bash
# Copy environment template
cp services/.env.example services/.env

# Verify it exists
ls -la services/.env
```

#### Database connection errors
```bash
# Check MongoDB is running
mongosh

# Check .env MONGODB_URI
cat services/.env | grep MONGODB_URI

# Test connection
mongosh mongodb://localhost:27017/l2l_dev
```

## 📊 Service Management

### Using Homebrew Services

```bash
# List all services
brew services list

# Start a service
brew services start mongodb-community
brew services start redis

# Stop a service
brew services stop mongodb-community
brew services stop redis

# Restart a service
brew services restart mongodb-community
brew services restart redis
```

### Manual Service Management

#### MongoDB
```bash
# Start manually
mongod --config /opt/homebrew/etc/mongod.conf --fork

# Stop manually
mongosh --eval "db.adminCommand('shutdown')"

# Check logs
tail -f /opt/homebrew/var/log/mongodb/mongo.log
```

#### Redis
```bash
# Start manually
redis-server /opt/homebrew/etc/redis.conf --daemonize yes

# Stop manually
redis-cli shutdown

# Check logs
tail -f /opt/homebrew/var/log/redis.log
```

## 🧪 Testing the Setup

### Test MongoDB Connection
```bash
# Connect to MongoDB
mongosh

# In MongoDB shell
use l2l_dev
db.test.insertOne({test: "data"})
db.test.find()
exit
```

### Test Redis Connection
```bash
# Connect to Redis
redis-cli

# In Redis CLI
ping
set test "hello"
get test
exit
```

### Test API Endpoints
```bash
# Health check
curl http://localhost:3000/health

# Register user
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "username": "testuser",
    "password": "Password123",
    "firstName": "Test",
    "lastName": "User"
  }'

# Login
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Password123"
  }'
```

## 📈 Monitoring & Logs

### MongoDB Logs
```bash
# View MongoDB logs
tail -f /opt/homebrew/var/log/mongodb/mongo.log

# Or check specific entries
grep ERROR /opt/homebrew/var/log/mongodb/mongo.log
```

### Redis Logs
```bash
# View Redis logs
tail -f /opt/homebrew/var/log/redis.log

# Or check Redis info
redis-cli info
```

### API Logs
```bash
# API logs are displayed in the terminal where npm run dev is running
# For production, logs are written to:
tail -f services/logs/combined.log
tail -f services/logs/error.log
```

## 🎯 Quick Start Commands

```bash
# Terminal 1: Start MongoDB
brew services start mongodb-community

# Terminal 2: Start Redis
brew services start redis

# Terminal 3: Start API
cd /Users/bs0650/R&D/AI/L2L/services
npm install
npm run dev

# Terminal 4: Test API
curl http://localhost:3000/health

# Terminal 5: Run Flutter app (optional)
cd /Users/bs0650/R&D/AI/L2L/app
flutter run
```

## 🔐 Security Notes

When running locally without Docker:

- **MongoDB**: By default, has no authentication on localhost
- **Redis**: By default, has no authentication on localhost
- **API**: Uses JWT tokens for authentication

For production:
- Enable MongoDB authentication
- Enable Redis password authentication
- Use environment variables for secrets
- Enable HTTPS/TLS

## 📚 Additional Resources

- [Node.js Documentation](https://nodejs.org/docs/)
- [MongoDB Documentation](https://docs.mongodb.com/)
- [Redis Documentation](https://redis.io/documentation)
- [Flutter Documentation](https://flutter.dev/docs)

## 🆘 Getting Help

If you encounter issues:

1. Check service status: `brew services list`
2. Check logs for each service
3. Verify ports are not in use: `lsof -i :<port>`
4. Restart the problematic service
5. Check [DOCKER_INSTALLATION.md](DOCKER_INSTALLATION.md) for Docker alternative

## 🎉 Success!

Once all services are running:

- ✅ MongoDB on port 27017
- ✅ Redis on port 6379
- ✅ API on port 3000
- ✅ Flutter app running
- ✅ Browser extension loaded

You're ready to start building features! 🚀
