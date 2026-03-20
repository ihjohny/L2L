# L2L (Link to Learn) - Section 7: Deployment & CI/CD

**Version:** 1.0
**Date:** March 2026

---

## Section 7: Deployment & CI/CD

### Section Purpose
This section defines the complete deployment pipeline, Docker configurations, CI/CD workflows, and rollback procedures for production releases.

### 7.1 GitHub Actions Pipeline

**Main Workflow (.github/workflows/ci-cd.yml):**
```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
    tags: ['v*.*.*']
  pull_request:
    branches: [main, develop]

env:
  NODE_VERSION: '20'
  FLUTTER_VERSION: '3.19.0'

jobs:
  # Backend Lint & Test
  backend-test:
    runs-on: ubuntu-latest
    services:
      mongodb:
        image: mongo:7.0
        ports: [27017:27017]
      redis:
        image: redis:7-alpine
        ports: [6379:6379]

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: backend/package-lock.json

      - name: Install dependencies
        working-directory: ./backend
        run: npm ci

      - name: Run linter
        working-directory: ./backend
        run: npm run lint

      - name: Run type check
        working-directory: ./backend
        run: npm run type-check

      - name: Run tests
        working-directory: ./backend
        run: npm run test:coverage
        env:
          MONGODB_URI: mongodb://localhost:27017/l2l-test
          REDIS_HOST: localhost
          JWT_SECRET: test-secret

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          directory: ./backend/coverage

  # Flutter Test
  flutter-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          cache: true

      - name: Install dependencies
        working-directory: ./mobile_app
        run: flutter pub get

      - name: Analyze
        working-directory: ./mobile_app
        run: flutter analyze

      - name: Run tests
        working-directory: ./mobile_app
        run: flutter test --coverage

  # Build & Deploy Backend
  deploy-backend:
    needs: [backend-test, flutter-test]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main' || startsWith(github.ref, 'refs/tags/v')

    steps:
      - uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Login to ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v2

      - name: Build and push Docker image
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          ECR_REPOSITORY: l2l-backend
          IMAGE_TAG: ${{ github.sha }}
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG -t $ECR_REGISTRY/$ECR_REPOSITORY:latest ./backend
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:latest

      - name: Deploy to ECS
        run: |
          aws ecs update-service --cluster l2l --service l2l-backend --force-new-deployment

  # Build Flutter Web
  deploy-web:
    needs: [backend-test, flutter-test]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main' || startsWith(github.ref, 'refs/tags/v')

    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}

      - name: Build web
        working-directory: ./mobile_app
        run: |
          flutter build web --release --web-renderer canvaskit
          echo "app.l2l.app" > build/web/CNAME

      - name: Deploy to S3
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Sync to S3
        run: |
          aws s3 sync ./mobile_app/build/web s3://l2l-web-app --delete

      - name: Invalidate CloudFront
        run: |
          aws cloudfront create-invalidation --distribution-id XXXXXXXXXX --paths "/*"

  # Security Scan
  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run npm audit
        working-directory: ./backend
        continue-on-error: true
        run: npm audit --audit-level=high

      - name: Run Snyk
        uses: snyk/actions/node@master
        continue-on-error: true
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
```

---

### 7.2 Backend Dockerfile (Multi-Stage)

```dockerfile
# backend/Dockerfile
# Stage 1: Build
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci --only=production

# Copy source and build
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:20-alpine AS production

# Install Playwright dependencies
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

WORKDIR /app

# Copy built artifacts from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

# Set Playwright to use system Chromium
ENV PLAYWRIGHT_BROWSERS_PATH=/usr/bin/chromium-browser

# Switch to non-root user
USER nodejs

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD node -e "require('http').get('http://localhost:8080/health', (r) => process.exit(r.statusCode === 200 ? 0 : 1))"

EXPOSE 8080

CMD ["node", "dist/main.js"]
```

---

### 7.3 Flutter Web Dockerfile

```dockerfile
# mobile_app/Dockerfile.web
FROM debian:bookworm AS builder

# Install Flutter dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter precache --web

WORKDIR /app

COPY . .

# Get dependencies
RUN flutter pub get

# Build web
RUN flutter build web --release --web-renderer canvaskit

# Stage 2: Nginx
FROM nginx:alpine

# Copy built files
COPY --from=builder /app/build/web /usr/share/nginx/html

# Custom nginx config for SPA
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

**nginx.conf:**
```nginx
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    # Gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    # SPA routing - all routes serve index.html
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
}
```

---

### 7.4 Local docker-compose.yml

(Already provided in Section 6.2 - same file used for local dev)

---

### 7.5 ECS Fargate Task Definition

**Key Parameters:**
```json
{
  "family": "l2l-backend",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "1024",
  "memory": "2048",
  "executionRoleArn": "arn:aws:iam::ACCOUNT:role/l2l-ecs-execution",
  "taskRoleArn": "arn:aws:iam::ACCOUNT:role/l2l-ecs-task",
  "containerDefinitions": [
    {
      "name": "l2l-backend",
      "image": "ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/l2l-backend:latest",
      "portMappings": [
        {
          "containerPort": 8080,
          "protocol": "tcp"
        }
      ],
      "environment": [
        { "name": "NODE_ENV", "value": "production" },
        { "name": "PORT", "value": "8080" }
      ],
      "secrets": [
        {
          "name": "MONGODB_URI",
          "valueFrom": "arn:aws:secretsmanager:us-east-1:ACCOUNT:secret:l2l/prod/mongodb-uri"
        },
        {
          "name": "OPENAI_API_KEY",
          "valueFrom": "arn:aws:secretsmanager:us-east-1:ACCOUNT:secret:l2l/prod/openai-api-key"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/l2l-backend",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "healthCheck": {
        "command": ["CMD-SHELL", "curl -f http://localhost:8080/health || exit 1"],
        "interval": 30,
        "timeout": 5,
        "retries": 3,
        "startPeriod": 60
      }
    }
  ]
}
```

---

### 7.6 Promotion Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         Git/Branch Promotion Flow                           │
└─────────────────────────────────────────────────────────────────────────────┘

Feature Development:
  feature/my-feature ──PR──> main (auto-deploy to staging)

Staging:
  main branch → Auto-deploy to staging.l2l.app
  Tag: v1.2.3-rc1 → Release candidate testing

Production:
  git tag v1.2.3 → Auto-deploy to production.l2l.app
  CHANGELOG.md updated

Hotfix:
  hotfix/critical-fix ──PR──> main ( expedited review )
  git tag v1.2.4 → Deploy to production
```

**Semver + CHANGELOG Convention:**
```markdown
# Changelog

## [1.2.3] - 2026-03-20

### Added
- New feature: Project sharing [P2]
- Analytics dashboard with heatmap

### Changed
- Improved AI processing latency by 30%

### Fixed
- Bug: Flashcard carousel infinite loop
- Bug: Extension token refresh race condition

### Deprecated
- API v1/links endpoint (use v2/links)

### Security
- Updated dependencies with CVE fixes
```

---

### 7.7 Rollback Procedure

**Backend Rollback:**
```bash
# 1. Identify previous stable version
aws ecs list-task-definitions --family-prefix l2l-backend --sort DESC

# 2. Update service to previous task definition
aws ecs update-service \
  --cluster l2l \
  --service l2l-backend \
  --task-definition l2l-backend:PREVIOUS_REVISION

# 3. Monitor deployment
aws ecs describe-services --cluster l2l --services l2l-backend

# 4. Verify health
curl https://api.l2l.app/health
```

**Web Rollback:**
```bash
# 1. Find previous deployment ID
aws s3api list-object-versions --bucket l2l-web-app --prefix index.html

# 2. Restore previous version
aws s3api put-object --bucket l2l-web-app --key index.html --version-id PREVIOUS_VERSION_ID

# 3. Invalidate CloudFront
aws cloudfront create-invalidation --distribution-id XXXXXXXXXX --paths "/*"
```

---

### 7.8 Health Check Endpoint

**Implementation:**
```typescript
// src/modules/health/health.controller.ts
@Controller('health')
export class HealthController {
  constructor(
    private mongo: MongoService,
    private redis: RedisService,
  ) {}

  @Get()
  async health() {
    const checks = await Promise.allSettled([
      this.checkMongo(),
      this.checkRedis(),
      this.checkOpenAI(),
    ]);

    const mongoOk = checks[0].status === 'fulfilled';
    const redisOk = checks[1].status === 'fulfilled';
    const openAiOk = checks[2].status === 'fulfilled';

    const status = mongoOk && redisOk ? 'ok' : 'degraded';
    const httpStatus = status === 'ok' ? 200 : 503;

    return {
      status,
      timestamp: new Date().toISOString(),
      checks: {
        mongodb: mongoOk ? 'ok' : 'error',
        redis: redisOk ? 'ok' : 'error',
        openai: openAiOk ? 'ok' : 'degraded',
      },
    };
  }
}
```

**ALB Health Check Configuration:**
```yaml
# Terraform/CloudFormation
HealthCheck:
  Protocol: HTTP
  Path: /health
  Port: 8080
  Interval: 30
  Timeout: 5
  HealthyThreshold: 2
  UnhealthyThreshold: 3
```

> ⚠️ **ASSUMPTIONS:**
> - GitHub Actions sufficient for CI/CD (no Jenkins/GitLab CI needed)
> - ECS Fargate provides adequate scalability for MVP/P2
> - S3 + CloudFront sufficient for web hosting
>
> 🚩 **RISKS & OPEN DECISIONS:**
> - **Risk:** Single-region deployment → **Mitigation:** Plan multi-region for P3
> - **Risk:** Long Docker build times → **Mitigation:** Implement layer caching, multi-stage builds
> - **Decision:** Blue/green vs. rolling deployment → **Confirmed:** Rolling for simplicity, blue/green for P3

---

---

*[← Dev Environment](./06_dev_environment.md)* | *[Back to Index](README.md)* | [Next: Microservices Migration →](./08_microservices_migration.md)*
