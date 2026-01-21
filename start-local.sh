#!/bin/bash

# L2L Local Development Startup Script (Without Docker)
# This script starts MongoDB, Redis, and the L2L API using local installations

set -e

echo "🚀 L2L Local Development Environment"
echo "===================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if a service is running
is_service_running() {
    brew services list | grep "$1" | grep -q "started"
}

# Check prerequisites
echo "📋 Checking prerequisites..."

if ! command_exists node; then
    echo -e "${RED}❌ Node.js is not installed!${NC}"
    echo "Please install Node.js: brew install node@18"
    exit 1
fi
echo -e "${GREEN}✅ Node.js installed${NC}"

if ! command_exists mongosh; then
    echo -e "${YELLOW}⚠️  MongoDB is not installed!${NC}"
    echo "Please install MongoDB: brew install mongodb-community"
    echo "Or follow the guide: RUN_WITHOUT_DOCKER.md"
    exit 1
fi
echo -e "${GREEN}✅ MongoDB installed${NC}"

if ! command_exists redis-cli; then
    echo -e "${YELLOW}⚠️  Redis is not installed!${NC}"
    echo "Please install Redis: brew install redis"
    echo "Or follow the guide: RUN_WITHOUT_DOCKER.md"
    exit 1
fi
echo -e "${GREEN}✅ Redis installed${NC}"
echo ""

# Navigate to project directory
cd "$(dirname "$0")"

# Check if .env file exists
if [ ! -f "services/.env" ]; then
    echo "📝 Creating environment file..."
    cp services/.env.example services/.env
    echo -e "${GREEN}✅ Environment file created${NC}"
    echo ""
fi

# Start MongoDB
echo "🍃 Starting MongoDB..."
if is_service_running "mongodb-community"; then
    echo -e "${GREEN}✅ MongoDB is already running${NC}"
else
    brew services start mongodb-community
    sleep 2
    echo -e "${GREEN}✅ MongoDB started${NC}"
fi

# Test MongoDB connection
if mongosh --quiet --eval "db.adminCommand('ping')" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ MongoDB is responding${NC}"
else
    echo -e "${RED}❌ MongoDB is not responding${NC}"
    echo "Please check MongoDB logs: tail -f /opt/homebrew/var/log/mongodb/mongo.log"
    exit 1
fi
echo ""

# Start Redis
echo "🔴 Starting Redis..."
if is_service_running "redis"; then
    echo -e "${GREEN}✅ Redis is already running${NC}"
else
    brew services start redis
    sleep 2
    echo -e "${GREEN}✅ Redis started${NC}"
fi

# Test Redis connection
if redis-cli ping > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Redis is responding${NC}"
else
    echo -e "${RED}❌ Redis is not responding${NC}"
    echo "Please check Redis logs: tail -f /opt/homebrew/var/log/redis.log"
    exit 1
fi
echo ""

# Check if node_modules exists
if [ ! -d "services/node_modules" ]; then
    echo "📦 Installing Node.js dependencies..."
    cd services
    npm install
    cd ..
    echo -e "${GREEN}✅ Dependencies installed${NC}"
    echo ""
fi

# Start the API
echo "🚀 Starting L2L API..."
echo "Opening in new terminal..."
cd services

# Check if we're on macOS and use open to spawn new terminal window
if [[ "$OSTYPE" == "darwin"* ]]; then
    osascript -e "tell app \"Terminal\" to do script \"cd $(pwd) && npm run dev\"" > /dev/null 2>&1 || \
    osascript -e "tell app \"iTerm\" to create window with default profile command \"cd $(pwd) && npm run dev\"" > /dev/null 2>&1 || \
    {
        echo "Could not open new terminal window. Starting in foreground..."
        echo "Press Ctrl+C to stop the API server."
        npm run dev
    }
else
    echo "Starting API in foreground..."
    echo "Press Ctrl+C to stop the API server."
    npm run dev
fi

cd ..

echo ""
echo "⏳ Waiting for API to start..."
sleep 5

# Check if API is running
if curl -s http://localhost:3000/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ API is running${NC}"
else
    echo -e "${YELLOW}⚠️  API might still be starting...${NC}"
    echo "Check the terminal window for API logs"
fi

echo ""
echo "🎉 Local development environment is ready!"
echo ""
echo "📍 Services available at:"
echo "   - API:        http://localhost:3000"
echo "   - Health:     http://localhost:3000/health"
echo "   - MongoDB:    mongodb://localhost:27017"
echo "   - Redis:      redis://localhost:6379"
echo ""
echo "📚 Useful commands:"
echo "   - Stop services:   brew services stop mongodb-community redis"
echo "   - API logs:        Check the terminal window running npm run dev"
echo "   - Test API:        curl http://localhost:3000/health"
echo "   - MongoDB shell:   mongosh"
echo "   - Redis CLI:       redis-cli"
echo ""
echo "📱 Next steps:"
echo "   1. Test the API: curl http://localhost:3000/health"
echo "   2. Run Flutter app: cd app && flutter run"
echo "   3. Load browser extension: Open chrome://extensions/ and load unpacked"
echo ""
