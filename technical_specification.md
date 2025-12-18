# L2L (Link to Learn) - Technical Specification

## Document Information
- **Version:** 1.0
- **Date:** December 2025
- **Status:** Draft
- **Product:** L2L (Link to Learn)
- **Author:** Technical Architecture Team

---

## 1. System Architecture Overview

### 1.1 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Presentation Layer                      │
├─────────────────────────────────────────────────────────────────┤
│  Web App (Flutter) │  Mobile Apps (Flutter) │ Browser Extension │
└─────────────────────────────────────────────────────────────────┘
                                  │
┌─────────────────────────────────────────────────────────────────┐
│                        API Gateway Layer                        │
├─────────────────────────────────────────────────────────────────┤
│           Load Balancer │ Rate Limiting │ Authentication       │
└─────────────────────────────────────────────────────────────────┘
                                  │
┌─────────────────────────────────────────────────────────────────┐
│                         Microservices Layer                     │
├─────────────────────────────────────────────────────────────────┤
│ User Service │ Content Service │ AI Engine │ Social Service     │
│ Analytics    │ Notification    │ Payment   │ Search             │
└─────────────────────────────────────────────────────────────────┘
                                  │
┌─────────────────────────────────────────────────────────────────┐
│                         Data Layer                             │
├─────────────────────────────────────────────────────────────────┤
│  MongoDB (Primary) │ Redis (Cache) │ S3 (Assets) │ Vector DB   │
└─────────────────────────────────────────────────────────────────┘
                                  │
┌─────────────────────────────────────────────────────────────────┐
│                    Infrastructure Layer                         │
├─────────────────────────────────────────────────────────────────┤
│       AWS/Azure Cloud Services │ Kubernetes │ Monitoring        │
└─────────────────────────────────────────────────────────────────┘
```

### 1.2 Microservices Architecture

#### 1.2.1 User Management Service
- **Purpose:** Authentication, authorization, user profiles
- **Technology:** Node.js + Express + JWT
- **Database:** MongoDB (users collection)
- **Endpoints:**
  - `POST /auth/register`
  - `POST /auth/login`
  - `GET /auth/profile`
  - `PUT /auth/profile`
  - `POST /auth/reset-password`

#### 1.2.2 Content Management Service
- **Purpose:** CRUD operations for bookmarks, projects, topics
- **Technology:** Node.js + Express
- **Database:** MongoDB with GridFS for large content
- **Endpoints:**
  - `POST /content/bookmarks`
  - `GET /content/bookmarks`
  - `PUT /content/bookmarks/:id`
  - `DELETE /content/bookmarks/:id`
  - `POST /content/projects`
  - `GET /content/projects`

#### 1.2.3 AI Processing Service
- **Purpose:** Content analysis, summary generation, flashcard/quiz creation
- **Technology:** Python + FastAPI
- **Queue:** Redis (RQ) + Celery
- **Models:** OpenAI GPT-4, Custom NLP models
- **Endpoints:**
  - `POST /ai/process-content`
  - `GET /ai/status/:jobId`
  - `POST /ai/generate-flashcards`
  - `POST /ai/generate-quiz`

#### 1.2.4 Social Collaboration Service
- **Purpose:** Project sharing, groups, comments
- **Technology:** Node.js + Socket.io for real-time
- **Database:** MongoDB
- **Endpoints:**
  - `POST /social/share`
  - `GET /social/shared/:projectId`
  - `POST /social/groups`
  - `POST /social/comments`

#### 1.2.5 Analytics Service
- **Purpose:** User behavior tracking, progress analytics
- **Technology:** Node.js + Express + ClickHouse
- **Endpoints:**
  - `POST /analytics/track`
  - `GET /analytics/user/:userId`
  - `GET /analytics/progress/:projectId`

#### 1.2.6 Notification Service
- **Purpose:** Email, push notifications, in-app alerts
- **Technology:** Node.js + Bull Queue
- **Services:** AWS SES, Firebase Cloud Messaging
- **Endpoints:**
  - `POST /notifications/send`
  - `GET /notifications/user/:userId`

---

## 2. Database Schema Design

### 2.1 MongoDB Collections

#### Users Collection
```javascript
{
  _id: ObjectId,
  email: String (unique),
  username: String (unique),
  password: String (hashed),
  profile: {
    firstName: String,
    lastName: String,
    avatar: String,
    preferences: {
      theme: String,
      language: String,
      notifications: Object
    }
  },
  subscription: {
    tier: String, // 'free', 'premium', 'enterprise'
    startDate: Date,
    endDate: Date
  },
  stats: {
    totalBookmarks: Number,
    projectsCompleted: Number,
    streakDays: Number,
    totalPoints: Number
  },
  createdAt: Date,
  updatedAt: Date
}
```

#### Topics Collection
```javascript
{
  _id: ObjectId,
  name: String,
  description: String,
  userId: ObjectId,
  color: String,
  icon: String,
  isPublic: Boolean,
  projects: [ObjectId],
  createdAt: Date,
  updatedAt: Date
}
```

#### Projects Collection
```javascript
{
  _id: ObjectId,
  name: String,
  description: String,
  userId: ObjectId,
  topicId: ObjectId,
  tags: [String],
  entities: [ObjectId],
  isPublic: Boolean,
  collaborators: [ObjectId],
  progress: {
    completionPercentage: Number,
    lastAccessed: Date,
    timeSpent: Number
  },
  gamification: {
    points: Number,
    badges: [String],
    achievements: [Object]
  },
  createdAt: Date,
  updatedAt: Date
}
```

#### Entities Collection (Bookmarks)
```javascript
{
  _id: ObjectId,
  url: String,
  title: String,
  description: String,
  userId: ObjectId,
  projectId: ObjectId,
  type: String, // 'article', 'video', 'podcast', 'document'
  status: String, // 'pending', 'processing', 'completed', 'failed'
  metadata: {
    author: String,
    publishDate: Date,
    readingTime: Number,
    difficulty: String
  },
  processedContent: {
    summary: String,
    keyPoints: [String],
    tags: [String],
    thumbnail: String
  },
  learningMaterials: {
    flashcards: [Object],
    quiz: {
      questions: [Object],
      score: Number,
      attempts: Number
    }
  },
  userInteractions: {
    isRead: Boolean,
    isFavorite: Boolean,
    notes: String,
    rating: Number
  },
  createdAt: Date,
  updatedAt: Date
}
```

#### Analytics Collection
```javascript
{
  _id: ObjectId,
  userId: ObjectId,
  eventType: String, // 'bookmark', 'quiz_attempt', 'flashcard_review'
  eventData: Object,
  sessionId: String,
  timestamp: Date,
  metadata: {
    userAgent: String,
    ip: String,
    platform: String
  }
}
```

### 2.2 Redis Cache Structure

#### Cache Keys
- `user:profile:{userId}` - User profile data
- `project:entities:{projectId}` - Project entities list
- `ai:job:{jobId}` - AI processing job status
- `leaderboard:global` - Global leaderboar
- `leaderboard:topic:{topicId}` - Topic-specific leaderboard
- `rate_limit:{userId}` - API rate limiting

#### Session Storage
- User session data
- Temporary bookmark data
- AI processing queue

---

## 3. API Specification

### 3.1 REST API Endpoints

#### Authentication Endpoints
```typescript
// POST /api/v1/auth/register
interface RegisterRequest {
  email: string;
  username: string;
  password: string;
  firstName: string;
  lastName: string;
}

interface RegisterResponse {
  user: UserProfile;
  token: string;
  refreshToken: string;
}

// POST /api/v1/auth/login
interface LoginRequest {
  email: string;
  password: string;
}

interface LoginResponse {
  user: UserProfile;
  token: string;
  refreshToken: string;
}
```

#### Bookmark Endpoints
```typescript
// POST /api/v1/bookmarks
interface CreateBookmarkRequest {
  url: string;
  projectId?: string;
  tags?: string[];
  notes?: string;
}

interface CreateBookmarkResponse {
  bookmark: Bookmark;
  jobId: string; // AI processing job ID
}

// GET /api/v1/bookmarks
interface GetBookmarksQuery {
  projectId?: string;
  tags?: string[];
  type?: string;
  page?: number;
  limit?: number;
}

interface GetBookmarksResponse {
  bookmarks: Bookmark[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
}
```

#### AI Processing Endpoints
```typescript
// POST /api/v1/ai/process
interface ProcessContentRequest {
  bookmarkId: string;
  options: {
    generateSummary: boolean;
    generateFlashcards: boolean;
    generateQuiz: boolean;
    difficulty: 'easy' | 'medium' | 'hard';
  };
}

// GET /api/v1/ai/status/:jobId
interface JobStatusResponse {
  jobId: string;
  status: 'pending' | 'processing' | 'completed' | 'failed';
  progress: number;
  result?: any;
  error?: string;
}
```

### 3.2 WebSocket Events

#### Real-time Collaboration
```typescript
// Client -> Server
interface CollaborationEvents {
  'join-project': { projectId: string };
  'leave-project': { projectId: string };
  'update-bookmark': { bookmarkId: string; changes: any };
  'add-comment': { projectId: string; comment: string };
}

// Server -> Client
interface ServerEvents {
  'project-updated': { projectId: string; changes: any };
  'user-joined': { userId: string; projectId: string };
  'user-left': { userId: string; projectId: string };
  'new-comment': { projectId: string; comment: Comment };
}
```

---

## 4. AI/ML Pipeline Architecture

### 4.1 Content Processing Pipeline

```
Input URL → Content Fetcher → Content Cleaner → AI Processor → Storage
                                                            │
                                                            ▼
                         ┌─────────────────────────────────────┐
                         │        AI Processing Tasks          │
                         ├─────────────────────────────────────┤
                         │ • Text Extraction                  │
                         │ • Summarization (GPT-4)            │
                         │ • Key Concept Extraction           │
                         │ • Flashcard Generation             │
                         │ • Quiz Question Creation           │
                         │ • Tag Assignment                   │
                         └─────────────────────────────────────┘
```

### 4.2 AI Processing Microservice

#### Components
1. **Content Fetcher**
   - Web scraper with Selenium/Playwright
   - YouTube API integration for videos
   - Podcast transcription support

2. **Text Processor**
   - Clean HTML/Markdown
   - Extract main content
   - Language detection
   - Reading time estimation

3. **AI Engine**
   ```python
   class AIProcessor:
       def __init__(self):
           self.openai_client = OpenAI()
           self.nlp_model = load_model('en_core_web_sm')

       async def process_content(self, content: str) -> ProcessedContent:
           # Step 1: Generate summary
           summary = await self.generate_summary(content)

           # Step 2: Extract key concepts
           concepts = await self.extract_concepts(content)

           # Step 3: Generate flashcards
           flashcards = await self.generate_flashcards(content, concepts)

           # Step 4: Create quiz questions
           quiz = await self.generate_quiz(content, concepts)

           return ProcessedContent(
               summary=summary,
               concepts=concepts,
               flashcards=flashcards,
               quiz=quiz
           )
   ```

### 4.3 Vector Database Integration

#### Embedding Generation
- Use OpenAI's text-embedding-ada-002 model
- Store embeddings in Pinecone/Weaviate
- Enable semantic search capabilities

#### Search Implementation
```javascript
async function semanticSearch(query, userId, limit = 10) {
  const queryEmbedding = await generateEmbedding(query);

  const results = await vectorDatabase.query({
    vector: queryEmbedding,
    filter: { userId },
    topK: limit,
    includeMetadata: true
  });

  return results.matches.map(match => ({
    id: match.id,
    score: match.score,
    content: match.metadata
  }));
}
```

---

## 5. Frontend Architecture

### 5.1 Flutter Application Structure

```
lib/
├── core/                    # Core utilities and constants
│   ├── constants/
│   ├── themes/
│   ├── utils/
│   └── services/
├── data/                    # Data layer
│   ├── models/             # Data models
│   ├── repositories/       # Repository implementations
│   └── datasources/        # API, local storage
├── domain/                  # Domain layer
│   ├── entities/           # Business entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business logic
├── presentation/            # UI layer
│   ├── pages/              # Screens
│   ├── widgets/            # Reusable widgets
│   ├── providers/          # State management
│   └── routes/             # Navigation
└── main.dart
```

### 5.2 State Management

#### Provider + Riverpod Implementation
```dart
// Bookmark provider
final bookmarkProvider = StateNotifierProvider<BookmarkNotifier, BookmarkState>((ref) {
  return BookmarkNotifier(ref.watch(bookmarkRepositoryProvider));
});

class BookmarkNotifier extends StateNotifier<BookmarkState> {
  BookmarkNotifier(this._repository) : super(const BookmarkState.initial());

  final BookmarkRepository _repository;

  Future<void> createBookmark(CreateBookmarkParams params) async {
    state = const BookmarkState.loading();
    final result = await _repository.createBookmark(params);
    state = result.fold(
      (failure) => BookmarkState.error(failure.message),
      (bookmark) => BookmarkState.loaded([bookmark]),
    );
  }
}
```

### 5.3 Key UI Components

#### Bookmark Card Widget
```dart
class BookmarkCard extends StatelessWidget {
  final Bookmark bookmark;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const BookmarkCard({
    Key? key,
    required this.bookmark,
    required this.onTap,
    required this.onFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: BookmarkThumbnail(url: bookmark.url),
        title: Text(bookmark.title),
        subtitle: Text(bookmark.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (bookmark.processedContent?.summary != null)
              IconButton(
                icon: const Icon(Icons.psychology),
                onPressed: () => _showSummary(context),
              ),
            IconButton(
              icon: Icon(
                bookmark.userInteractions.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              ),
              onPressed: onFavorite,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
```

---

## 6. Browser Extension Architecture

### 6.1 Extension Structure

```
extension/
├── manifest.json           # Extension manifest
├── popup/                  # Popup UI
│   ├── popup.html
│   ├── popup.js
│   └── popup.css
├── content-script/         # Content script for page interaction
│   └── content.js
├── background/             # Background service worker
│   └── background.js
└── assets/                 # Icons and images
```

### 6.2 Content Script Implementation

```javascript
// content.js
class L2LContentScript {
  constructor() {
    this.init();
  }

  init() {
    this.injectSaveButton();
    this.setupMessageListeners();
  }

  injectSaveButton() {
    const saveButton = document.createElement('div');
    saveButton.id = 'l2l-save-button';
    saveButton.innerHTML = `
      <div class="l2l-icon">L2L</div>
    `;
    saveButton.addEventListener('click', () => this.savePage());
    document.body.appendChild(saveButton);
  }

  async savePage() {
    const pageData = {
      url: window.location.href,
      title: document.title,
      description: this.getMetaDescription(),
      selectedText: window.getSelection().toString(),
      timestamp: Date.now()
    };

    chrome.runtime.sendMessage({
      type: 'SAVE_PAGE',
      data: pageData
    });
  }

  getMetaDescription() {
    const meta = document.querySelector('meta[name="description"]');
    return meta ? meta.content : '';
  }
}

new L2LContentScript();
```

### 6.3 Background Service Worker

```javascript
// background.js
class L2LBackground {
  constructor() {
    this.setupMessageHandlers();
  }

  setupMessageHandlers() {
    chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
      switch (request.type) {
        case 'SAVE_PAGE':
          this.handleSavePage(request.data, sendResponse);
          break;
        case 'GET_USER_INFO':
          this.getUserInfo(sendResponse);
          break;
      }
    });
  }

  async handleSavePage(pageData, sendResponse) {
    try {
      const response = await fetch('https://api.l2l.com/bookmarks', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${await this.getAuthToken()}`
        },
        body: JSON.stringify(pageData)
      });

      const result = await response.json();
      sendResponse({ success: true, data: result });

      // Show notification
      chrome.notifications.create({
        type: 'basic',
        iconUrl: 'assets/icon128.png',
        title: 'L2L - Saved!',
        message: 'Content saved to your library'
      });
    } catch (error) {
      sendResponse({ success: false, error: error.message });
    }
  }
}

new L2LBackground();
```

---

## 7. Infrastructure & DevOps

### 7.1 Cloud Infrastructure (AWS)

#### Core Services
- **EKS:** Container orchestration
- **ECR:** Container registry
- **RDS:** Managed MongoDB (DocumentDB)
- **ElastiCache:** Redis cluster
- **S3:** Object storage
- **CloudFront:** CDN
- **API Gateway:** API management
- **Lambda:** Serverless functions

#### Infrastructure as Code (Terraform)
```hcl
# EKS Cluster
resource "aws_eks_cluster" "l2l_cluster" {
  name     = "l2l-prod"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.28"

  vpc_config {
    subnet_ids = [
      aws_subnet.private_1.id,
      aws_subnet.private_2.id,
      aws_subnet.private_3.id,
    ]
  }
}

# DocumentDB Cluster
resource "aws_docdb_cluster" "l2l_db" {
  cluster_identifier = "l2l-docdb"
  engine             = "docdb"
  master_username    = "l2ladmin"
  master_password    = var.db_password

  skip_final_snapshot = false

  db_subnet_group_name = aws_docdb_subnet_group.l2l.name
  vpc_security_group_ids = [aws_security_group.docdb.id]
}
```

### 7.2 CI/CD Pipeline

#### GitHub Actions Workflow
```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npm run test
      - run: npm run lint

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build Docker images
        run: |
          docker build -t l2l/api:${{ github.sha }} ./services/api
          docker build -t l2l/ai:${{ github.sha }} ./services/ai

      - name: Push to ECR
        if: github.ref == 'refs/heads/main'
        run: |
          aws ecr get-login-password | docker login --username AWS --password-stdin $ECR_REGISTRY
          docker push l2l/api:${{ github.sha }}
          docker push l2l/ai:${{ github.sha }}

  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to EKS
        run: |
          kubectl set image deployment/api api=$ECR_REGISTRY/l2l/api:${{ github.sha }}
          kubectl set image deployment/ai ai=$ECR_REGISTRY/l2l/ai:${{ github.sha }}
```

### 7.3 Monitoring & Observability

#### Stack
- **Prometheus:** Metrics collection
- **Grafana:** Visualization
- **Jaeger:** Distributed tracing
- **ELK Stack:** Logging
- **AWS CloudWatch:** Infrastructure monitoring

#### Key Metrics
```javascript
// Custom metrics for application monitoring
const promClient = require('prom-client');

const httpRequestDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code']
});

const activeUsersGauge = new promClient.Gauge({
  name: 'l2l_active_users',
  help: 'Number of currently active users'
});

const aiProcessingDuration = new promClient.Histogram({
  name: 'ai_processing_duration_seconds',
  help: 'Time spent processing content with AI',
  labelNames: ['content_type']
});
```

---

## 8. Security Architecture

### 8.1 Authentication & Authorization

#### JWT Token Structure
```typescript
interface JWTPayload {
  sub: string;        // User ID
  email: string;
  tier: 'free' | 'premium' | 'enterprise';
  permissions: string[];
  iat: number;        // Issued at
  exp: number;        // Expiration
  jti: string;        // JWT ID for revocation
}
```

#### API Gateway Security
```javascript
// Rate limiting middleware
const rateLimit = require('express-rate-limit');

const createRateLimiter = (tier) => {
  const limits = {
    free: { windowMs: 15 * 60 * 1000, max: 100 },
    premium: { windowMs: 15 * 60 * 1000, max: 1000 },
    enterprise: { windowMs: 15 * 60 * 1000, max: 10000 }
  };

  return rateLimit(limits[tier]);
};

// Apply rate limiting based on user tier
app.use('/api/v1', async (req, res, next) => {
  const user = await getUserFromToken(req.headers.authorization);
  const limiter = createRateLimiter(user.tier);
  return limiter(req, res, next);
});
```

### 8.2 Data Encryption

#### Encryption at Rest
- Database encryption using AWS KMS
- S3 bucket encryption with SSE-KMS
- Application-level encryption for sensitive fields

#### Encryption in Transit
- TLS 1.3 for all API communications
- Certificate pinning for mobile apps
- mTLS for service-to-service communication

### 8.3 Content Security Policy

#### CSP Header Implementation
```javascript
app.use(helmet.contentSecurityPolicy({
  directives: {
    defaultSrc: ["'self'"],
    scriptSrc: ["'self'", "'unsafe-inline'", "https://apis.google.com"],
    styleSrc: ["'self'", "'unsafe-inline'"],
    imgSrc: ["'self'", "data:", "https://*.amazonaws.com"],
    connectSrc: ["'self'", "https://api.l2l.com"],
    frameSrc: ["'none'"],
    objectSrc: ["'none'"],
    mediaSrc: ["'self'"],
    fontSrc: ["'self'", "https://fonts.gstatic.com"]
  }
}));
```

---

## 9. Performance Optimization

### 9.1 Caching Strategy

#### Multi-Level Caching
1. **CDN Cache** - Static assets (CloudFront)
2. **Application Cache** - API responses (Redis)
3. **Database Cache** - Query results (MongoDB indexes)

#### Cache Implementation
```javascript
class CacheManager {
  constructor(redisClient) {
    this.redis = redisClient;
    this.defaultTTL = 300; // 5 minutes
  }

  async get(key) {
    const cached = await this.redis.get(key);
    return cached ? JSON.parse(cached) : null;
  }

  async set(key, value, ttl = this.defaultTTL) {
    await this.redis.setex(key, ttl, JSON.stringify(value));
  }

  async invalidate(pattern) {
    const keys = await this.redis.keys(pattern);
    if (keys.length > 0) {
      await this.redis.del(...keys);
    }
  }
}
```

### 9.2 Database Optimization

#### MongoDB Indexes
```javascript
// Collection indexes
db.bookmarks.createIndex({ "userId": 1, "createdAt": -1 });
db.bookmarks.createIndex({ "projectId": 1, "status": 1 });
db.bookmarks.createIndex({ "tags": 1 });
db.bookmarks.createIndex({
  "title": "text",
  "description": "text",
  "processedContent.summary": "text"
});

// Compound indexes
db.users.createIndex({ "email": 1 }, { unique: true });
db.projects.createIndex({ "userId": 1, "isPublic": 1 });
```

#### Database Connection Pool
```javascript
const mongoose = require('mongoose');

mongoose.connect(process.env.MONGODB_URI, {
  maxPoolSize: 50,
  serverSelectionTimeoutMS: 5000,
  socketTimeoutMS: 45000,
  bufferMaxEntries: 0,
  useNewUrlParser: true,
  useUnifiedTopology: true
});
```

### 9.3 API Performance

#### Response Optimization
```javascript
// Pagination implementation
const paginatedResults = (model) => {
  return async (req, res, next) => {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;
    const startIndex = (page - 1) * limit;

    const results = {
      data: [],
      pagination: {
        current: page,
        limit: limit,
        total: 0,
        pages: 0
      }
    };

    try {
      results.total = await model.countDocuments();
      results.pagination.pages = Math.ceil(results.total / limit);

      results.data = await model
        .find()
        .limit(limit)
        .skip(startIndex)
        .sort({ createdAt: -1 });

      res.paginatedResults = results;
      next();
    } catch (error) {
      next(error);
    }
  };
};
```

---

## 10. Scalability & High Availability

### 10.1 Auto-scaling Configuration

#### Kubernetes HPA
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: l2l-api-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: l2l-api
  minReplicas: 3
  maxReplicas: 50
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

### 10.2 Database Scaling

#### MongoDB Sharding
```javascript
// Shard key strategy
sh.shardCollection("l2l.bookmarks", { "userId": 1, "createdAt": -1 });
sh.shardCollection("l2l.analytics", { "userId": 1, "timestamp": -1 });

// Read preferences
mongoose.connect(uri, {
  readPreference: 'secondaryPreferred',
  readConcern: { level: 'majority' }
});
```

### 10.3 Disaster Recovery

#### Backup Strategy
```yaml
# Automated backup using AWS Lambda
Resources:
  BackupFunction:
    Type: AWS::Lambda::Function
    Properties:
      Handler: index.handler
      Runtime: nodejs18.x
      Timeout: 300
      Environment:
        Variables:
          DOCDB_CLUSTER: l2l-docdb
          S3_BUCKET: l2l-backups

  BackupSchedule:
    Type: AWS::Events::Rule
    Properties:
      ScheduleExpression: cron(0 2 * * ? *) # Daily at 2 AM
      Targets:
        - Id: BackupFunctionTarget
          Arn: !GetAtt BackupFunction.Arn
```

---

## 11. Testing Strategy

### 11.1 Testing Pyramid

#### Unit Tests (70%)
- Business logic validation
- Utility functions
- Service methods

#### Integration Tests (20%)
- API endpoints
- Database operations
- Third-party integrations

#### E2E Tests (10%)
- User flows
- Cross-platform functionality

### 11.2 Test Implementation Examples

#### Unit Test (Jest)
```javascript
// services/__tests__/bookmarkService.test.js
describe('BookmarkService', () => {
  let service;
  let mockRepository;

  beforeEach(() => {
    mockRepository = {
      create: jest.fn(),
      findById: jest.fn(),
      update: jest.fn(),
      delete: jest.fn()
    };
    service = new BookmarkService(mockRepository);
  });

  describe('createBookmark', () => {
    it('should create a new bookmark successfully', async () => {
      const bookmarkData = {
        url: 'https://example.com',
        title: 'Example',
        userId: 'user123'
      };

      mockRepository.create.mockResolvedValue({ _id: '123', ...bookmarkData });

      const result = await service.createBookmark(bookmarkData);

      expect(result).toHaveProperty('_id', '123');
      expect(mockRepository.create).toHaveBeenCalledWith(bookmarkData);
    });

    it('should throw error for invalid URL', async () => {
      const bookmarkData = {
        url: 'invalid-url',
        title: 'Example',
        userId: 'user123'
      };

      await expect(service.createBookmark(bookmarkData))
        .rejects
        .toThrow('Invalid URL format');
    });
  });
});
```

#### Integration Test (Supertest)
```javascript
// tests/integration/bookmarks.test.js
describe('Bookmarks API', () => {
  let app;
  let token;

  beforeAll(async () => {
    app = require('../app');
    const loginResponse = await request(app)
      .post('/api/v1/auth/login')
      .send({
        email: 'test@example.com',
        password: 'password123'
      });
    token = loginResponse.body.token;
  });

  describe('POST /api/v1/bookmarks', () => {
    it('should create a bookmark', async () => {
      const response = await request(app)
        .post('/api/v1/bookmarks')
        .set('Authorization', `Bearer ${token}`)
        .send({
          url: 'https://example.com/article',
          title: 'Test Article'
        });

      expect(response.status).toBe(201);
      expect(response.body).toHaveProperty('bookmark');
      expect(response.body.bookmark.url).toBe('https://example.com/article');
    });
  });
});
```

---

## 12. Deployment Strategy

### 12.1 Environment Configuration

#### Development
```yaml
# docker-compose.dev.yml
version: '3.8'
services:
  api:
    build: ./services/api
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
      - MONGODB_URI=mongodb://localhost:27017/l2l_dev
      - REDIS_URL=redis://localhost:6379
    volumes:
      - ./services/api:/app
      - /app/node_modules

  mongodb:
    image: mongo:6
    ports:
      - "27017:27017"
    volumes:
      - mongo_data:/data/db

  redis:
    image: redis:7
    ports:
      - "6379:6379"
```

#### Production
```yaml
# k8s/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: l2l-api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: l2l-api
  template:
    metadata:
      labels:
        app: l2l-api
    spec:
      containers:
      - name: api
        image: l2l/api:latest
        ports:
        - containerPort: 3000
        env:
        - name: NODE_ENV
          value: "production"
        - name: MONGODB_URI
          valueFrom:
            secretKeyRef:
              name: l2l-secrets
              key: mongodb-uri
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
```

### 12.2 Blue-Green Deployment

```javascript
// deployment-script.js
const AWS = require('aws-sdk');
const eks = new AWS.EKS();

async function deployBlueGreen(imageTag) {
  const currentDeployment = await getCurrentDeployment();
  const newColor = currentDeployment.color === 'blue' ? 'green' : 'blue';

  // Deploy to inactive color
  await deployToEnvironment(newColor, imageTag);

  // Health check
  const isHealthy = await healthCheck(newColor);

  if (isHealthy) {
    // Switch traffic
    await switchTraffic(newColor);
    await cleanupOldDeployment(currentDeployment.color);
  } else {
    // Rollback
    await rollbackDeployment(newColor);
    throw new Error('Deployment failed - rolled back');
  }
}
```

---

## 13. Maintenance & Operations

### 13.1 Monitoring Alerts

#### Prometheus Alert Rules
```yaml
# alerts.yml
groups:
- name: l2l_alerts
  rules:
  - alert: HighErrorRate
    expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.1
    for: 5m
    labels:
      severity: critical
    annotations:
      summary: "High error rate detected"

  - alert: HighResponseTime
    expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 1
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "95th percentile response time is high"

  - alert: DatabaseConnections
    expr: mongodb_connections{state="current"} > 80
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "Database connection count is high"
```

### 13.2 Log Aggregation

#### ELK Stack Configuration
```yaml
# logstash.conf
input {
  beats {
    port => 5044
  }
}

filter {
  if [fields][service] == "l2l-api" {
    json {
      source => "message"
    }

    date {
      match => [ "timestamp", "ISO8601" ]
    }

    if [level] == "error" {
      mutate {
        add_tag => [ "error" ]
      }
    }
  }
}

output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
    index => "l2l-logs-%{+YYYY.MM.dd}"
  }
}
```

---

## 14. Migration Plan

### 14.1 Data Migration Strategy

#### Phase 1: Schema Migration
```javascript
// migration-001.js
module.exports = {
  async up(db) {
    // Add new fields to existing collections
    await db.collection('users').updateMany(
      {},
      {
        $set: {
          'subscription.tier': 'free',
          'stats.totalBookmarks': 0,
          'stats.streakDays': 0
        }
      }
    );

    // Create indexes for new queries
    await db.collection('bookmarks').createIndex({
      'userId': 1,
      'processedContent.summary': 'text'
    });
  },

  async down(db) {
    // Rollback changes
    await db.collection('users').updateMany(
      {},
      {
        $unset: {
          'subscription.tier': '',
          'stats.totalBookmarks': '',
          'stats.streakDays': ''
        }
      }
    );
  }
};
```

### 14.2 Zero-Downtime Migration

```javascript
// migration-service.js
class MigrationService {
  async migrateUsers() {
    const batchSize = 100;
    let hasMore = true;
    let skip = 0;

    while (hasMore) {
      const users = await User.find()
        .skip(skip)
        .limit(batchSize)
        .lean();

      if (users.length === 0) {
        hasMore = false;
        break;
      }

      await Promise.all(
        users.map(user => this.migrateUser(user))
      );

      skip += batchSize;
      console.log(`Migrated ${skip} users`);
    }
  }

  async migrateUser(user) {
    // Migrate user data with validation
    try {
      const migrated = await this.transformUser(user);
      await User.updateOne(
        { _id: user._id },
        { $set: migrated }
      );
    } catch (error) {
      console.error(`Failed to migrate user ${user._id}:`, error);
      // Log for manual review
    }
  }
}
```

---

## 15. Technology Rationale

### 15.1 Technology Stack Decisions

#### Flutter for Cross-Platform
- Single codebase for iOS, Android, and Web
- Native performance
- Rich UI components
- Growing ecosystem

#### Node.js Backend
- JavaScript/TypeScript across stack
- Large npm ecosystem
- Excellent for I/O heavy applications
- Good for microservices architecture

#### MongoDB for Data Storage
- Flexible schema for evolving data
- Good performance for read-heavy workloads
- Built-in scaling features
- Rich query capabilities

#### Redis for Caching
- In-memory performance
- Multiple data structures
- Pub/Sub capabilities
- Persistence options

### 15.2 AI/ML Technology Choices

#### OpenAI GPT-4
- State-of-the-art language understanding
- Excellent at summarization
- Strong reasoning capabilities
- API-first approach

#### Custom NLP Models
- Specialized for educational content
- Fine-tuned for flashcard generation
- Cost-effective for high volume
- Customizable for specific needs

---

## 16. Budget Estimation

### 16.1 Infrastructure Costs (Monthly)

#### AWS Services
- EKS Cluster: $300/month
- DocumentDB: $500/month
- ElastiCache (Redis): $200/month
- S3 Storage: $100/month
- CloudFront: $50/month
- Lambda: $30/month
- Data Transfer: $150/month

#### AI/ML Services
- OpenAI API: $2,000/month (estimated)
- Custom model hosting: $500/month

**Total Monthly Infrastructure: ~$3,830**

### 16.2 Development Team Costs

#### Team Composition
- 2 Backend Developers: $20,000/month
- 2 Frontend Developers: $20,000/month
- 1 DevOps Engineer: $10,000/month
- 1 ML Engineer: $15,000/month
- 1 QA Engineer: $8,000/month

**Total Monthly Team: $73,000**

---

## 17. Timeline & Milestones

### 17.1 Development Phases

#### Phase 1: Foundation (8 weeks)
- Week 1-2: Setup infrastructure and CI/CD
- Week 3-4: User authentication service
- Week 5-6: Basic bookmark management
- Week 7-8: Browser extension MVP

#### Phase 2: Core Features (12 weeks)
- Week 9-12: AI processing pipeline
- Week 13-16: Learning materials generation
- Week 17-20: Mobile app development
- Week 21-24: Testing and optimization

#### Phase 3: Social Features (8 weeks)
- Week 25-28: Project sharing
- Week 29-32: User groups and collaboration

#### Phase 4: Launch Preparation (4 weeks)
- Week 33-34: Performance optimization
- Week 35-36: Security audit and launch

### 17.2 Go-Live Checklist

- [ ] All critical bugs resolved
- [ ] Load testing complete (10K concurrent users)
- [ ] Security audit passed
- [ ] Documentation complete
- [ ] Support team trained
- [ ] Marketing assets ready
- [ ] App store submissions approved
- [ ] Backup and recovery tested

---

## 18. Conclusion

This technical specification provides a comprehensive blueprint for building the L2L platform. The architecture is designed to be:

1. **Scalable:** Microservices architecture with auto-scaling capabilities
2. **Secure:** Multi-layered security with encryption and proper authentication
3. **Performant:** Caching strategies and optimized database queries
4. **Maintainable:** Clean code principles with comprehensive testing
5. **Cost-effective:** Efficient resource utilization and monitoring

The system is prepared to handle the projected user growth while maintaining high performance and reliability. Regular reviews and updates to this specification will ensure it continues to meet evolving requirements.

---

*This technical specification should be reviewed and updated regularly as the project evolves. All team members should be familiar with the architecture and coding standards outlined in this document.*