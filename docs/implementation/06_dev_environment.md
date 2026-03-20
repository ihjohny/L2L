# L2L (Link to Learn) - Section 6: Dev Environment Setup

**Version:** 1.0
**Date:** March 2026

---

## Section 6: Dev Environment Setup

### Section Purpose
This section provides complete step-by-step setup instructions for developers joining the project, including prerequisites, local infrastructure, and verification steps.

### 6.1 Prerequisites (macOS/Linux)

**Required Software:**

| Tool | Version | Purpose | Install Command |
|------|---------|---------|-----------------|
| Node.js | 20.x LTS | Backend runtime | `nvm install 20 && nvm use 20` |
| npm | 10.x | Package manager | Included with Node |
| Flutter | 3.19.x | Mobile/Web framework | `flutter upgrade` |
| Dart | 3.3.x | Flutter language | Included with Flutter |
| Docker | 24.x | Containerization | `brew install --cask docker` |
| Git | 2.40+ | Version control | `brew install git` |
| MongoDB Compass | Latest | Database GUI | `brew install --cask mongodb-compass` |

**Verification Commands:**
```bash
node --version    # v20.x.x
npm --version     # 10.x.x
flutter --version # Flutter 3.19.x
dart --version    # Dart 3.3.x
docker --version  # Docker 24.x.x
git --version     # 2.4x.x
```

---

### 6.2 Local Infrastructure (Docker Compose)

**docker-compose.yml:**
```yaml
version: '3.8'

services:
  mongodb:
    image: mongo:7.0
    container_name: l2l-mongodb
    restart: unless-stopped
    ports:
      - "27017:27017"
    volumes:
      - mongodb_data:/data/db
    environment:
      MONGO_INITDB_ROOT_USERNAME: l2l
      MONGO_INITDB_ROOT_PASSWORD: l2lpassword
    healthcheck:
      test: echo 'db.runCommand("ping").ok' | mongosh localhost:27017/test --quiet
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: l2l-redis
    restart: unless-stopped
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    command: redis-server --appendonly yes
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Optional: MongoDB Express for web-based DB admin
  mongo-express:
    image: mongo-express:latest
    container_name: l2l-mongo-express
    restart: unless-stopped
    ports:
      - "8081:8081"
    environment:
      ME_CONFIG_MONGODB_ADMINUSERNAME: l2l
      ME_CONFIG_MONGODB_ADMINPASSWORD: l2lpassword
      ME_CONFIG_MONGODB_URL: mongodb://l2l:l2lpassword@mongodb:27017/
    depends_on:
      - mongodb

volumes:
  mongodb_data:
  redis_data:
```

**Start Infrastructure:**
```bash
cd backend
docker-compose up -d

# Verify containers
docker-compose ps

# View logs
docker-compose logs -f mongodb
docker-compose logs -f redis

# Stop infrastructure
docker-compose down
```

---

### 6.3 Backend Setup

**Clone and Install:**
```bash
# Clone repository
git clone https://github.com/your-org/l2l.git
cd l2l/backend

# Install dependencies
npm ci

# Copy environment template
cp .env.example .env

# Edit .env with your local values
# (use defaults from Section 5)
```

**Run Migrations:**
```bash
npm run migrate:up
```

**Start Development Server:**
```bash
# With auto-reload
npm run dev

# Server starts at http://localhost:3000
# Health check: http://localhost:3000/health
```

**Verify Backend:**
```bash
# Health check
curl http://localhost:3000/health

# Expected: {"status":"ok","timestamp":"..."}
```

---

### 6.4 Flutter App Setup

**Install Dependencies:**
```bash
cd mobile_app

# Get Flutter packages
flutter pub get

# Run build runner (if using code generation)
flutter pub run build_runner build --delete-conflicting-outputs
```

**Configure Environment:**
```bash
# Create config file
cat > lib/core/config/api_config.dart << 'EOF'
class ApiConfig {
  static const String baseUrl = 'http://localhost:3000/api/v1';
  static const bool useMockData = false;
}
EOF
```

**Run Flutter App:**
```bash
# List available devices
flutter devices

# Run on web
flutter run -d chrome

# Run on iOS simulator
flutter run -d ios

# Run on Android emulator
flutter run -d android
```

---

### 6.5 Chrome Extension Setup

**Install Dependencies:**
```bash
cd extension

# Install packages
npm ci

# Build extension
npm run build

# Or watch mode for development
npm run watch
```

**Load in Chrome:**
1. Open Chrome and navigate to `chrome://extensions/`
2. Enable "Developer mode" (toggle in top-right)
3. Click "Load unpacked"
4. Select `extension/dist` folder
5. Extension icon appears in toolbar

**Test Extension:**
1. Navigate to any website
2. Click extension icon
3. Verify popup loads
4. Try saving a link (requires backend running)

---

### 6.6 Running Tests

**Backend Tests:**
```bash
# Unit tests
npm run test:unit

# Integration tests (requires Docker)
docker-compose up -d
npm run test:integration
docker-compose down

# E2E tests
npm run test:e2e

# All tests with coverage
npm run test:coverage

# Test watch mode
npm run test:watch
```

**Flutter Tests:**
```bash
# Unit and widget tests
flutter test

# With coverage
flutter test --coverage

# Integration test (requires running app)
flutter test integration_test/app_test.dart
```

---

### 6.7 VS Code Extensions

**Recommended Extensions:**
```json
{
  "recommendations": [
    // TypeScript/Node.js
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "ms-vscode.vscode-typescript-next",

    // Flutter/Dart
    "Dart-Code.dart-code",
    "Dart-Code.flutter",

    // Database
    "mongodb.mongodb-vscode",

    // API Testing
    "humao.rest-client",

    // Git
    "github.vscode-pull-request-github",

    // Docker
    "ms-azuretools.vscode-docker",

    // Environment
    "mikestead.dotenv",

    // Testing
    "Orta.vscode-jest",
  ]
}
```

**Workspace Settings:**
```json
// .vscode/settings.json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "[dart]": {
    "editor.formatOnSave": true,
    "editor.selectionHighlight": false,
    "editor.suggest.snippetsPreventQuickSuggestions": false,
    "editor.suggestSelection": "first",
    "editor.tabCompletion": "onlySnippets",
    "editor.wordBasedSuggestions": "off"
  },
  "files.watcherExclude": {
    "**/node_modules/**": true,
    "**/.dart_tool/**": true,
    "**/build/**": true
  }
}
```

---

### 6.8 Onboarding Checklist

**Day 1: Environment Setup**
- [ ] Clone repository and gain access to GitHub org
- [ ] Install Node.js 20.x and verify version
- [ ] Install Flutter SDK and run `flutter doctor`
- [ ] Install Docker Desktop and start daemon
- [ ] Install VS Code with recommended extensions
- [ ] Get AWS credentials for Secrets Manager (ask lead)
- [ ] Get dotenv-vault access for team environment

**Day 1: Local Infrastructure**
- [ ] Start MongoDB and Redis via Docker Compose
- [ ] Verify MongoDB connection with Compass
- [ ] Copy `.env.example` to `.env` in backend
- [ ] Run `npm ci` in backend directory
- [ ] Run database migrations
- [ ] Start backend dev server
- [ ] Verify health endpoint responds

**Day 2: Backend Familiarization**
- [ ] Run backend test suite
- [ ] Review API documentation (Swagger UI)
- [ ] Create test user via `/auth/register`
- [ ] Test link creation via Postman/curl
- [ ] Review error handling patterns
- [ ] Review logging output format

**Day 2: Flutter App**
- [ ] Run `flutter pub get` in mobile_app
- [ ] Configure API base URL for local backend
- [ ] Run Flutter app on web or simulator
- [ ] Test login flow against local backend
- [ ] Review state management (Riverpod) patterns
- [ ] Run Flutter test suite

**Day 3: Chrome Extension**
- [ ] Build extension and load in Chrome
- [ ] Test popup UI
- [ ] Test save link functionality
- [ ] Review MV3 service worker patterns

**Day 3: Full Stack**
- [ ] Complete end-to-end flow: register → save link → view AI output
- [ ] Review job queue behavior (check BullMQ board if installed)
- [ ] Review Sentry dashboard access (if available)
- [ ] Review CloudWatch logs access (if available)

**Week 1: First Contribution**
- [ ] Pick up first ticket from backlog
- [ ] Create feature branch from `main`
- [ ] Implement feature with tests
- [ ] Open PR and address review comments
- [ ] Deploy to staging for testing
- [ ] Merge to main after approval

---

---

*[← Configuration](./05_configuration.md)* | *[Back to Index](README.md)* | [Next: Deployment & CI/CD →](./07_deployment_cicd.md)*
