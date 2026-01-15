#!/bin/bash

# L2L Development Environment Startup Script
# This script checks for Docker and starts the development environment

set -e

echo "🚀 L2L Development Environment Startup"
echo "======================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed!"
    echo ""
    echo "Please install Docker Desktop first:"
    echo "1. Download from: https://www.docker.com/products/docker-desktop/"
    echo "2. Or run: brew install --cask docker"
    echo ""
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo "⚠️  Docker is installed but not running!"
    echo ""
    echo "Please start Docker Desktop:"
    echo "1. Open Applications folder"
    echo "2. Double-click Docker.app"
    echo "3. Wait for Docker to start (Docker icon in menu bar)"
    echo ""
    read -p "Press Enter once Docker Desktop is running..."
fi

echo "✅ Docker is running!"
echo ""

# Navigate to project directory
cd "$(dirname "$0")"

# Check if .env file exists
if [ ! -f "services/.env" ]; then
    echo "📝 Creating environment file..."
    cp services/.env.example services/.env
    echo "✅ Environment file created at services/.env"
    echo "   You may want to edit this file to add your API keys"
    echo ""
fi

# Start services
echo "🐳 Starting Docker containers..."
docker-compose -f docker-compose.dev.yml up -d

echo ""
echo "⏳ Waiting for services to be healthy..."
sleep 10

# Check service status
echo ""
echo "📊 Service Status:"
echo "=================="
docker-compose -f docker-compose.dev.yml ps

echo ""
echo "✅ Development environment is ready!"
echo ""
echo "📍 Services available at:"
echo "   - API:        http://localhost:3000"
echo "   - Health:     http://localhost:3000/health"
echo "   - MongoDB:    localhost:27017"
echo "   - Redis:      localhost:6379"
echo ""
echo "📚 Next steps:"
echo "   1. Test the API: curl http://localhost:3000/health"
echo "   2. View logs: docker-compose -f docker-compose.dev.yml logs -f"
echo "   3. Stop services: docker-compose -f docker-compose.dev.yml down"
echo ""
echo "💡 Useful commands:"
echo "   - View logs:          docker-compose -f docker-compose.dev.yml logs -f"
echo "   - Restart services:   docker-compose -f docker-compose.dev.yml restart"
echo "   - Stop services:      docker-compose -f docker-compose.dev.yml down"
echo "   - Shell in API:       docker-compose -f docker-compose.dev.yml exec api sh"
echo ""
