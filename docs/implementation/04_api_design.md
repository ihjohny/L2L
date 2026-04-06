# L2L (Link to Learn) - Section 4: API Design & Contracts

**Version:** 1.0
**Date:** March 2026

---

## Section 4: API Design & Contracts

### Section Purpose
This section defines the complete REST API specification including versioning, endpoint catalog, authentication flows, error handling, pagination, and rate limiting.

### 4.1 Versioning Strategy

| Aspect | Convention |
|--------|------------|
| **URL Prefix** | `/api/v1/` for all endpoints |
| **Deprecation Policy** | 6-month notice before sunset |
| **Version Sunset** | Old versions return `410 Gone` with migration guide |
| **Breaking Changes** | New major version required |
| **Non-Breaking** | Additive changes allowed in current version |

**Deprecation Response Header:**
```
Deprecation: true
Sunset: Sat, 01 Sep 2026 00:00:00 GMT
Link: </api/v2/links>; rel="successor-version"
```

---

### 4.2 Endpoint Catalog

#### Authentication Endpoints

| Method | Path | Auth | Tier | Request Body | Response | Status Codes | Phase |
|--------|------|------|------|--------------|----------|--------------|-------|
| POST | `/auth/register` | No | Public | `{ email, password, name }` | `{ user, tokens }` | 201, 400, 409 | MVP |
| POST | `/auth/login` | No | Public | `{ email, password }` | `{ user, tokens }` | 200, 401 | MVP |
| POST | `/auth/logout` | Yes | Public | `{ refreshToken }` | `{ success }` | 200, 401 | MVP |
| POST | `/auth/refresh` | No | Public | `{ refreshToken }` | `{ tokens }` | 200, 401 | MVP |
| POST | `/auth/forgot-password` | No | Public | `{ email }` | `{ success }` | 200, 404 | MVP |
| POST | `/auth/reset-password` | No | Public | `{ token, newPassword }` | `{ success }` | 200, 400, 410 | MVP |
| GET | `/auth/me` | Yes | Public | - | `{ user }` | 200, 401 | MVP |

---

#### Projects Endpoints

| Method | Path | Auth | Tier | Request Body | Response | Status Codes | Phase |
|--------|------|------|------|--------------|----------|--------------|-------|
| GET | `/projects` | Yes | User | - | `{ projects, nextCursor }` | 200, 401 | MVP |
| POST | `/projects` | Yes | User | `{ name, description?, tags? }` | `{ project }` | 201, 400, 401 | MVP |
| GET | `/projects/:id` | Yes | User | - | `{ project, links }` | 200, 401, 403, 404 | MVP |
| PUT | `/projects/:id` | Yes | User | `{ name?, description?, tags? }` | `{ project }` | 200, 400, 401, 403, 404 | MVP |
| DELETE | `/projects/:id` | Yes | User | - | `{ success }` | 200, 401, 403, 404 | MVP |
| POST | `/projects/:id/generate-course-quiz` | Yes | User | `{ forceRegenerate? }` | `{ jobId }` | 202, 400, 401, 403, 404 | MVP |
| GET | `/projects/:id/course` | Yes | User | - | `{ course, quiz }` | 200, 404 | MVP |
| GET | `/shared/projects/:slug` | No | Public | - | `{ project, links }` | 200, 404 | P2 |

---

#### Links Endpoints

| Method | Path | Auth | Tier | Request Body | Response | Status Codes | Phase |
|--------|------|------|------|--------------|----------|--------------|-------|
| GET | `/links` | Yes | User | `?projectId&cursor&limit&status` | `{ links, nextCursor }` | 200, 400, 401 | MVP |
| POST | `/links` | Yes | User | `{ url, projectId?, tags?, title? }` | `{ link, jobId }` | 201, 400, 401 | MVP |
| GET | `/links/:id` | Yes | User | - | `{ link, aiOutput }` | 200, 401, 403, 404 | MVP |
| PUT | `/links/:id` | Yes | User | `{ projectId?, tags?, title? }` | `{ link }` | 200, 400, 401, 403, 404 | MVP |
| DELETE | `/links/:id` | Yes | User | - | `{ success }` | 200, 401, 403, 404 | MVP |
| GET | `/links/:id/summary` | Yes | User | - | `{ summary }` | 200, 404 | MVP |
| GET | `/links/:id/flashcards` | Yes | User | - | `{ flashcards }` | 200, 404 | MVP |
| POST | `/links/bulk` | Yes | User | `{ urls, projectId?, tags? }` | `{ jobId }` | 202, 400, 401 | P2 |

---

#### Jobs Endpoints

| Method | Path | Auth | Tier | Request Body | Response | Status Codes | Phase |
|--------|------|------|------|--------------|----------|--------------|-------|
| GET | `/jobs/:jobId` | Yes | User | - | `{ job }` | 200, 401, 404 | MVP |
| GET | `/jobs` | Yes | User | `?status&type` | `{ jobs }` | 200, 400, 401 | MVP |

---

#### Analytics Endpoints [P2]

| Method | Path | Auth | Tier | Request Body | Response | Status Codes | Phase |
|--------|------|------|------|--------------|----------|--------------|-------|
| GET | `/analytics/dashboard` | Yes | User | - | `{ stats, heatmap }` | 200, 401 | P2 |
| GET | `/analytics/progress` | Yes | User | `?startDate&endDate` | `{ progress }` | 200, 400, 401 | P2 |
| GET | `/analytics/quiz-history` | Yes | User | `?cursor&limit` | `{ attempts, nextCursor }` | 200, 401 | P2 |

---

#### Subscription Endpoints [P2]

| Method | Path | Auth | Tier | Request Body | Response | Status Codes | Phase |
|--------|------|------|------|--------------|----------|--------------|-------|
| GET | `/subscription` | Yes | User | - | `{ subscription }` | 200, 401, 404 | P2 |
| POST | `/subscription/checkout` | Yes | User | `{ plan }` | `{ checkoutUrl }` | 200, 400, 401 | P2 |
| POST | `/subscription/cancel` | Yes | User | - | `{ subscription }` | 200, 401, 404 | P2 |
| POST | `/stripe/webhook` | No | Public | Stripe event | `{ received }` | 200, 400 | P2 |

---

#### Quiz Endpoints [P2]

| Method | Path | Auth | Tier | Request Body | Response | Status Codes | Phase |
|--------|------|------|------|--------------|----------|--------------|-------|
| POST | `/quizzes/:id/attempt` | Yes | User | `{ answers }` | `{ score, results }` | 200, 400, 404 | P2 |
| GET | `/quizzes/:id/results` | Yes | User | - | `{ attempt, explanations }` | 200, 404 | P2 |

---

#### Chat Endpoints [P3]

| Method | Path | Auth | Tier | Request Body | Response | Status Codes | Phase |
|--------|------|------|------|--------------|----------|--------------|-------|
| GET | `/chat/sessions` | Yes | User | `?projectId` | `{ sessions }` | 200, 401 | P3 |
| POST | `/chat/sessions` | Yes | User | `{ projectId, title? }` | `{ session }` | 201, 401 | P3 |
| POST | `/chat/sessions/:id/messages` | Yes | User | `{ content }` | `{ message, citations }` | 201, 400, 404 | P3 |
| DELETE | `/chat/sessions/:id` | Yes | User | - | `{ success }` | 200, 404 | P3 |

---

### 4.3 JWT Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         JWT Authentication Flow                             │
└─────────────────────────────────────────────────────────────────────────────┘

1. INITIAL LOGIN
   ┌─────────┐                              ┌─────────┐
   │  Client │                              │  Server │
   └────┬────┘                              └────┬────┘
        │                                        │
        │  POST /auth/login                      │
        │  { email, password }                   │
        │───────────────────────────────────────>│
        │                                        │ Verify credentials
        │                                        │ Generate tokens
        │  { accessToken, refreshToken, user }   │
        │<───────────────────────────────────────│
        │                                        │
        │  Store:                                │
        │  - accessToken (memory/HTTP-only)     │
        │  - refreshToken (secure storage)       │
        │                                        │

2. AUTHENTICATED REQUESTS
   ┌─────────┐                              ┌─────────┐
   │  Client │                              │  Server │
   └────┬────┘                              └────┬────┘
        │                                        │
        │  GET /api/v1/projects                  │
        │  Authorization: Bearer <accessToken>   │
        │───────────────────────────────────────>│
        │                                        │ Validate JWT signature
        │                                        │ Check expiry
        │  { projects }                          │ Return data
        │<───────────────────────────────────────│
        │                                        │

3. TOKEN REFRESH (Access token expired)
   ┌─────────┐                              ┌─────────┐
   │  Client │                              │  Server │
   └────┬────┘                              └────┬────┘
        │                                        │
        │  GET /api/v1/links                     │
        │  Authorization: Bearer <expiredToken>  │
        │───────────────────────────────────────>│
        │                                        │ 401 Unauthorized
        │<───────────────────────────────────────│
        │                                        │
        │  POST /auth/refresh                    │
        │  { refreshToken }                      │
        │───────────────────────────────────────>│
        │                                        │ Validate refresh token
        │                                        │ Generate new access token
        │  { accessToken }                       │
        │<───────────────────────────────────────│
        │                                        │
        │  Retry original request                │
        │  Authorization: Bearer <newToken>      │
        │───────────────────────────────────────>│
        │  { links }                             │
        │<───────────────────────────────────────│
        │                                        │

4. LOGOUT
   ┌─────────┐                              ┌─────────┐
   │  Client │                              │  Server │
   └────┬────┘                              └────┬────┘
        │                                        │
        │  POST /auth/logout                     │
        │  { refreshToken }                      │
        │───────────────────────────────────────>│
        │                                        │ Invalidate refresh token
        │                                        │ (add to blocklist/Redis)
        │  { success }                           │
        │<───────────────────────────────────────│
        │                                        │
        │  Clear local tokens                    │
        │                                        │
```

**Token Configuration:**

| Token Type | TTL | Storage | Refreshable |
|------------|-----|---------|-------------|
| Access Token | 15 min | Memory (mobile), HTTP-only cookie (web) | Yes |
| Refresh Token | 30 days | Secure Storage (mobile), HTTP-only cookie (web) | Yes |

---

### 4.4 Error Envelope Schema

**Standard Error Response:**
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format"
      }
    ],
    "requestId": "req_abc123"
  },
  "timestamp": "2026-03-20T10:30:00.000Z"
}
```

**Example 1: Validation Error**
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input",
    "details": [
      { "field": "url", "message": "Invalid URL format" },
      { "field": "projectId", "message": "Project not found" }
    ]
  },
  "requestId": "req_xyz789",
  "timestamp": "2026-03-20T10:30:00.000Z"
}
```

**Example 2: Authentication Error**
```json
{
  "success": false,
  "error": {
    "code": "AUTH_ERROR",
    "message": "Token expired",
    "details": null
  },
  "requestId": "req_auth456",
  "timestamp": "2026-03-20T10:30:00.000Z"
}
```

**Example 3: AI Processing Error**
```json
{
  "success": false,
  "error": {
    "code": "AI_ERROR",
    "message": "Failed to process link: content extraction failed",
    "details": {
      "jobId": "job_123",
      "retryable": true,
      "attemptsRemaining": 2
    }
  },
  "requestId": "req_ai789",
  "timestamp": "2026-03-20T10:30:00.000Z"
}
```

---

### 4.5 Cursor-Based Pagination

**Request Parameters:**

| Parameter | Type | Default | Max | Description |
|-----------|------|---------|-----|-------------|
| `cursor` | String | - | - | Opaque cursor from previous response |
| `limit` | Number | 20 | 100 | Items per page |

**Response Format:**
```json
{
  "data": [...],
  "pagination": {
    "nextCursor": "eyJfaWQiOiI2NjBh...",
    "hasMore": true,
    "limit": 20
  }
}
```

**Implementation Pattern:**
```typescript
// Cursor encoding (base64 of last document _id)
function encodeCursor(doc: Document): string {
  return Buffer.from(doc._id.toString()).toString('base64');
}

function decodeCursor(cursor: string): ObjectId {
  return new ObjectId(Buffer.from(cursor, 'base64').toString());
}

// Query pattern
async function getPaginatedLinks(userId: string, cursor?: string, limit = 20) {
  const query: Filter<Link> = { userId, deletedAt: null };

  if (cursor) {
    const cursorId = decodeCursor(cursor);
    query._id = { $lt: cursorId }; // For createdAt: -1 sorting
  }

  const links = await db.links
    .find(query)
    .sort({ createdAt: -1 })
    .limit(limit + 1) // Fetch one extra to detect hasMore
    .toArray();

  const hasMore = links.length > limit;
  if (hasMore) links.pop(); // Remove extra item

  return {
    data: links,
    pagination: {
      nextCursor: hasMore ? encodeCursor(links[links.length - 1]) : null,
      hasMore,
      limit,
    },
  };
}
```

---

### 4.6 Rate Limiting

**Tier-Based Limits (Redis Sliding Window):**

| Tier | Links/Month | API Requests/15min | AI Processing/Hour |
|------|-------------|-------------------|-------------------|
| Free | 20 | 100 | 10 |
| Premium | Unlimited | 1000 | 100 |
| Team | Unlimited | 5000 | 500 |

**Rate Limit Response Headers:**
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 42
X-RateLimit-Reset: 1710936600
Retry-After: 3600
```

**429 Too Many Requests Response:**
```json
{
  "success": false,
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many requests. Please try again in 1 hour.",
    "retryAfter": 3600
  }
}
```

**Redis Implementation:**
```typescript
// Rate limiter middleware
async function checkRateLimit(userId: string, tier: string, window: string) {
  const key = `ratelimit:${userId}:${window}`;
  const limit = getLimitForTier(tier, window);
  const now = Date.now();
  const windowMs = parseWindow(window);

  const client = redis.client;
  const pipeline = client.pipeline();

  // Remove old entries
  pipeline.zremrangebyscore(key, 0, now - windowMs);
  // Add current request
  pipeline.zadd(key, now, `${now}:${Math.random()}`);
  // Count requests in window
  pipeline.zcard(key);
  // Set expiry
  pipeline.expire(key, Math.ceil(windowMs / 1000));

  const [, , count] = await pipeline.exec();

  return {
    allowed: count <= limit,
    remaining: Math.max(0, limit - count),
    resetAt: now + windowMs,
  };
}
```

> ⚠️ **ASSUMPTIONS:**
> - REST API sufficient for MVP (GraphQL not required initially)
> - Cursor pagination meets all list use cases
> - Rate limit tiers align with monetization strategy
>
> 🚩 **RISKS & OPEN DECISIONS:**
> - **Risk:** AI processing abuse on free tier → **Mitigation:** Implement per-hour limits, monitor patterns
> - **Risk:** Refresh token theft → **Mitigation:** Consider refresh token rotation, fingerprinting
> - **Decision:** Cursor-based vs. offset pagination → **Confirmed:** Cursor for performance at scale

---

---

*[← Database Schema](./03_database_schema.md)* | *[Back to Index](README.md)* | [Next: Configuration →](./05_configuration.md)*
