# L2L (Link to Learn) - Section 3: Database Schema

**Version:** 1.0
**Date:** March 2026

---

## Section 3: Database Schema

### Section Purpose
This section defines all MongoDB collections with complete field specifications, index strategies, embedding vs. referencing decisions, soft delete patterns, and migration conventions.

### 3.1 Collections Overview

| Collection | Description | Phase | Avg Document Size |
|------------|-------------|-------|-------------------|
| `users` | User accounts, auth credentials, subscription status | MVP | ~500 bytes |
| `projects` | User-created learning collections | MVP | ~1 KB |
| `links` | Saved URLs with processing status | MVP | ~2 KB |
| `ai_outputs` | AI-generated content (summaries, flashcards, courses, quizzes) | MVP | ~10 KB |
| `jobs` | Async job tracking | MVP | ~500 bytes |
| `analytics_events` | User activity tracking | P2 | ~200 bytes |
| `subscriptions` | Stripe subscription data | P2 | ~1 KB |
| `chat_sessions` | RAG chatbot conversations | P3 | ~5 KB |

---

### 3.2 Collection Specifications

#### users

| Field | Type | Required | Default | Index | Description |
|-------|------|----------|---------|-------|-------------|
| `_id` | ObjectId | Yes | auto | PK | Primary key |
| `email` | String | Yes | - | Unique, sparse | User email (login identifier) |
| `passwordHash` | String | Yes* | - | - | bcrypt hash (null for OAuth users) |
| `name` | String | Yes | - | - | Display name |
| `avatarUrl` | String | No | null | - | Profile picture URL |
| `subscriptionTier` | String | Yes | `free` | Indexed | `free`, `premium`, `team` |
| `stripeCustomerId` | String | No | null | Unique | Stripe customer ID [P2] |
| `subscriptionId` | ObjectId | No | null | FK → subscriptions | Current subscription [P2] |
| `stats` | Object | Yes | `{}` | - | Aggregated user statistics |
| `stats.linksSaved` | Number | Yes | `0` | - | Total links saved |
| `stats.coursesCompleted` | Number | Yes | `0` | - | Courses finished |
| `stats.quizzesTaken` | Number | Yes | `0` | - | Quizzes attempted |
| `stats.averageQuizScore` | Number | Yes | `0` | - | Average quiz score (%) |
| `stats.currentStreak` | Number | Yes | `0` | - | Daily streak count [P2] |
| `stats.longestStreak` | Number | Yes | `0` | - | Best streak [P2] |
| `stats.totalPoints` | Number | Yes | `0` | - | Gamification points [P2] |
| `lastActivityAt` | Date | No | null | Indexed | For engagement tracking |
| `createdAt` | Date | Yes | `Date.now` | Indexed | Account creation date |
| `updatedAt` | Date | Yes | `Date.now` | - | Last update timestamp |
| `deletedAt` | Date | No | null | Sparse | Soft delete timestamp |

**Indexes:**
```javascript
// Primary indexes
db.users.createIndex({ email: 1 }, { unique: true, sparse: true });
db.users.createIndex({ stripeCustomerId: 1 }, { unique: true, sparse: true });

// Query optimization
db.users.createIndex({ subscriptionTier: 1, createdAt: -1 }); // Admin queries
db.users.createIndex({ lastActivityAt: -1 }); // Active users

// Soft delete filter
db.users.createIndex({ deletedAt: 1 }, { sparse: true });
```

---

#### projects

| Field | Type | Required | Default | Index | Description |
|-------|------|----------|---------|-------|-------------|
| `_id` | ObjectId | Yes | auto | PK | Primary key |
| `userId` | ObjectId | Yes | - | FK → users | Owner reference |
| `name` | String | Yes | - | Text | Project name |
| `description` | String | No | null | Text | Project description |
| `tags` | String[] | Yes | `[]` | Multi-key | Tag labels |
| `aiOutputId` | ObjectId | No | null | FK → ai_outputs | Course/quiz reference |
| `linkCount` | Number | Yes | `0` | - | Denormalized count |
| `isPublic` | Boolean | Yes | `false` | Indexed | Shareable project [P2] |
| `shareSlug` | String | No | null | Unique | Public URL slug [P2] |
| `collaborators` | Object[] | Yes | `[]` | - | Shared access [P2] |
| `collaborators[].userId` | ObjectId | Yes | - | - | Collaborator reference |
| `collaborators[].role` | String | Yes | `viewer` | - | `viewer`, `editor` |
| `metadata` | Object | No | `{}` | - | Additional data |
| `metadata.thumbnailUrl` | String | No | null | - | Preview image |
| `metadata.category` | String | No | null | - | AI-inferred category [P2] |
| `createdAt` | Date | Yes | `Date.now` | Indexed | Creation timestamp |
| `updatedAt` | Date | Yes | `Date.now` | - | Last update |
| `deletedAt` | Date | No | null | Sparse | Soft delete |

**Indexes:**
```javascript
db.projects.createIndex({ userId: 1, createdAt: -1 }); // User's projects
db.projects.createIndex({ userId: 1, deletedAt: 1 }); // Soft delete filter
db.projects.createIndex({ tags: 1 }); // Tag filtering
db.projects.createIndex({ isPublic: 1, shareSlug: 1 }, { sparse: true }); // Public sharing
db.projects.createIndex({ name: 'text', description: 'text' }); // Full-text search
```

---

#### links

| Field | Type | Required | Default | Index | Description |
|-------|------|----------|---------|-------|-------------|
| `_id` | ObjectId | Yes | auto | PK | Primary key |
| `userId` | ObjectId | Yes | - | FK → users | Owner reference |
| `projectId` | ObjectId | Yes | - | FK → projects | Parent project |
| `url` | String | Yes | - | Indexed | Original URL |
| `title` | String | No | null | Text | Page title (extracted) |
| `description` | String | No | null | Text | Meta description |
| `rawContent` | String | No | null | - | Extracted page content |
| `thumbnailUrl` | String | No | null | - | Link preview image |
| `domain` | String | No | null | Indexed | Extracted domain |
| `tags` | String[] | Yes | `[]` | Multi-key | User tags |
| `aiOutputId` | ObjectId | No | null | FK → ai_outputs | Summary/flashcards |
| `status` | String | Yes | `pending` | Indexed | `pending`, `processing`, `completed`, `failed` |
| `metadata` | Object | No | `{}` | - | Scrape metadata |
| `metadata.contentType` | String | No | null | - | `article`, `video`, `documentation` |
| `metadata.author` | String | No | null | - | Content author |
| `metadata.publishedAt` | Date | No | null | - | Original publish date |
| `metadata.wordCount` | Number | No | null | - | Content length |
| `processingAttempts` | Number | Yes | `0` | - | Retry counter |
| `lastError` | String | No | null | - | Last error message |
| `readAt` | Date | No | null | Indexed | User viewed this link |
| `completedAt` | Date | No | null | - | Marked as complete |
| `createdAt` | Date | Yes | `Date.now` | Indexed | Save timestamp |
| `updatedAt` | Date | Yes | `Date.now` | - | Last update |
| `deletedAt` | Date | No | null | Sparse | Soft delete |

**Indexes:**
```javascript
db.links.createIndex({ userId: 1, projectId: 1, createdAt: -1 }); // Project links
db.links.createIndex({ userId: 1, status: 1, createdAt: -1 }); // Status filtering
db.links.createIndex({ userId: 1, deletedAt: 1 }); // Soft delete filter
db.links.createIndex({ url: 1, userId: 1 }); // Duplicate detection
db.links.createIndex({ domain: 1 }); // Domain analytics
db.links.createIndex({ tags: 1 }); // Tag filtering
db.links.createIndex({ title: 'text', description: 'text' }); // Search
db.links.createIndex({ readAt: -1 }); // Recently read
```

---

#### ai_outputs

| Field | Type | Required | Default | Index | Description |
|-------|------|----------|---------|-------|-------------|
| `_id` | ObjectId | Yes | auto | PK | Primary key |
| `sourceType` | String | Yes | - | Indexed | `link` or `project` |
| `sourceId` | ObjectId | Yes | - | FK | links._id or projects._id |
| `type` | String | Yes | - | - | `summary`, `course`, `quiz` |
| `content` | Object | Yes | - | - | AI output content (see below) |
| `tokenUsage` | Object | No | null | - | OpenAI usage stats |
| `tokenUsage.prompt` | Number | No | null | - | Input tokens |
| `tokenUsage.completion` | Number | No | null | - | Output tokens |
| `tokenUsage.total` | Number | No | null | - | Total tokens |
| `model` | String | Yes | - | - | Model used (e.g., `gpt-4o`) |
| `version` | Number | Yes | `1` | - | Output schema version |
| `createdAt` | Date | Yes | `Date.now` | - | Generation timestamp |

**Content Schema for `type: summary`:**
```javascript
content: {
  summary: String,           // Main summary (500-1000 words)
  keyPoints: String[],       // Bullet points (3-7)
  mainArgument: String,      // Core thesis
  takeaways: String[],       // Actionable takeaways (2-5)
  readingTime: Number        // Estimated minutes
}
```

**Content Schema for `type: flashcards`:**
```javascript
content: {
  flashcards: [{
    question: String,
    answer: String,
    difficulty: String,      // easy, medium, hard
    tags: String[]
  }]
}
```

**Content Schema for `type: course`:**
```javascript
content: {
  title: String,
  description: String,
  estimatedDuration: Number, // minutes
  lessons: [{
    order: Number,
    title: String,
    content: String,         // Markdown content
    keyPoints: String[],
    estimatedDuration: Number
  }],
  sources: [{               // Source link references
    linkId: ObjectId,
    title: String,
    relevance: String
  }]
}
```

**Content Schema for `type: quiz`:**
```javascript
content: {
  courseId: ObjectId,      // Reference to ai_outputs._id (course this quiz was generated from)
  title: String,
  description: String,
  passingScore: Number,      // Percentage (e.g., 70)
  questions: [{
    order: Number,
    question: String,
    type: String,            // multiple_choice, true_false, short_answer
    options: String[],       // For multiple choice
    correctAnswer: String,   // or Number for index
    explanation: String,
    points: Number
  }],
  totalPoints: Number
}
```

**Indexes:**
```javascript
db.ai_outputs.createIndex({ sourceType: 1, sourceId: 1, type: 1 }); // Lookup by source
db.ai_outputs.createIndex({ sourceId: 1, type: 1 }, { unique: true, partialFilterExpression: { sourceType: 'link' } });
```

---

#### jobs

| Field | Type | Required | Default | Index | Description |
|-------|------|----------|---------|-------|-------------|
| `_id` | ObjectId | Yes | auto | PK | Primary key |
| `type` | String | Yes | - | Indexed | `process_link`, `generate_course`, `export_data` |
| `status` | String | Yes | `pending` | Indexed | `pending`, `processing`, `completed`, `failed` |
| `priority` | Number | Yes | `0` | - | Higher = more urgent |
| `userId` | ObjectId | Yes | - | FK → users | Job owner |
| `resourceType` | String | Yes | - | - | `link`, `project` |
| `resourceId` | ObjectId | Yes | - | Indexed | Target resource |
| `result` | Object | No | null | - | Job result data |
| `error` | Object | No | null | - | Error details if failed |
| `error.message` | String | No | null | - | Error message |
| `error.code` | String | No | null | - | Error code |
| `progress` | Number | Yes | `0` | - | 0-100 percentage |
| `attempts` | Number | Yes | `0` | - | Retry count |
| `maxAttempts` | Number | Yes | `3` | - | Max retries |
| `nextAttemptAt` | Date | No | null | - | For backoff scheduling |
| `startedAt` | Date | No | null | - | Processing start |
| `completedAt` | Date | No | null | Indexed | Job completion |
| `expiresAt` | Date | No | null | - | TTL for cleanup |
| `createdAt` | Date | Yes | `Date.now` | - | Queue time |
| `updatedAt` | Date | Yes | `Date.now` | - | Last status update |

**Indexes:**
```javascript
db.jobs.createIndex({ userId: 1, status: 1, createdAt: -1 }); // User's jobs
db.jobs.createIndex({ status: 1, nextAttemptAt: 1 }); // Worker queries
db.jobs.createIndex({ resourceType: 1, resourceId: 1 }); // Resource jobs
db.jobs.createIndex({ createdAt: 1 }, { expireAfterSeconds: 604800 }); // 7-day TTL
```

---

#### analytics_events [P2]

| Field | Type | Required | Default | Index | Description |
|-------|------|----------|---------|-------|-------------|
| `_id` | ObjectId | Yes | auto | PK | Primary key |
| `userId` | ObjectId | Yes | - | FK → users | Event owner |
| `eventType` | String | Yes | - | Indexed | `link_saved`, `course_completed`, etc. |
| `eventData` | Object | No | `{}` | - | Event-specific data |
| `projectId` | ObjectId | No | null | - | Related project |
| `linkId` | ObjectId | No | null | - | Related link |
| `sessionId` | String | No | null | Indexed | Session identifier |
| `platform` | String | No | null | - | `ios`, `android`, `web`, `extension` |
| `timestamp` | Date | Yes | `Date.now` | Indexed | Event time |

**Indexes:**
```javascript
db.analytics_events.createIndex({ userId: 1, eventType: 1, timestamp: -1 });
db.analytics_events.createIndex({ eventType: 1, timestamp: -1 }); // Aggregations
db.analytics_events.createIndex({ timestamp: 1 }, { expireAfterSeconds: 7776000 }); // 90-day retention
```

---

#### subscriptions [P2]

| Field | Type | Required | Default | Index | Description |
|-------|------|----------|---------|-------|-------------|
| `_id` | ObjectId | Yes | auto | PK | Primary key |
| `userId` | ObjectId | Yes | - | Unique FK → users | Subscriber |
| `stripeSubscriptionId` | String | Yes | - | Unique | Stripe subscription ID |
| `stripeCustomerId` | String | Yes | - | Indexed | Stripe customer |
| `plan` | String | Yes | - | - | `free`, `premium`, `team` |
| `status` | String | Yes | `active` | Indexed | `active`, `trialing`, `canceled`, `past_due` |
| `currentPeriodStart` | Date | Yes | - | - | Billing period start |
| `currentPeriodEnd` | Date | Yes | - | - | Billing period end |
| `cancelAtPeriodEnd` | Boolean | Yes | `false` | - | Scheduled cancellation |
| `canceledAt` | Date | No | null | - | Cancellation timestamp |
| `metadata` | Object | No | `{}` | - | Additional Stripe data |
| `createdAt` | Date | Yes | `Date.now` | - | Subscription start |
| `updatedAt` | Date | Yes | `Date.now` | - | Last update |

**Indexes:**
```javascript
db.subscriptions.createIndex({ userId: 1 }, { unique: true });
db.subscriptions.createIndex({ stripeSubscriptionId: 1 }, { unique: true });
db.subscriptions.createIndex({ status: 1, currentPeriodEnd: 1 }); // Renewal queries
```

---

#### chat_sessions [P3]

| Field | Type | Required | Default | Index | Description |
|-------|------|----------|---------|-------|-------------|
| `_id` | ObjectId | Yes | auto | PK | Primary key |
| `userId` | ObjectId | Yes | - | FK → users | Session owner |
| `projectId` | ObjectId | Yes | - | FK → projects | Context project |
| `title` | String | No | "New Chat" | - | Auto-generated title |
| `messages` | Object[] | Yes | `[]` | - | Conversation history |
| `messages[].role` | String | Yes | - | - | `user` or `assistant` |
| `messages[].content` | String | Yes | - | - | Message content |
| `messages[].timestamp` | Date | Yes | - | - | Message time |
| `messages[].citations` | Object[] | No | null | - | Source references |
| `lastMessageAt` | Date | No | null | Indexed | Last activity |
| `createdAt` | Date | Yes | `Date.now` | - | Session start |
| `deletedAt` | Date | No | null | Sparse | Soft delete |

**Indexes:**
```javascript
db.chat_sessions.createIndex({ userId: 1, lastMessageAt: -1 }); // User's chats
db.chat_sessions.createIndex({ projectId: 1 }); // Project chats
```

---

### 3.3 Embedded vs. Referenced Decisions

| Relationship | Decision | Rationale |
|--------------|----------|-----------|
| **User → Projects** | Referenced | Projects queried independently; large collections |
| **User → Links** | Referenced | Links have independent lifecycle, AI outputs |
| **Project → Links** | Referenced (with denormalized count) | Links belong to projects but queried separately |
| **Link → AI Output** | Referenced | AI outputs are large; lazy loading |
| **Project → AI Output** | Referenced | Course/quiz data is large (~10KB) |
| **User → Stats** | Embedded | Frequently accessed, small size |
| **Link → Metadata** | Embedded | Tight coupling, small size |
| **Chat Session → Messages** | Embedded | Session accessed as whole; messages not queried individually |

---

### 3.4 Soft Delete Pattern

All collections use the `deletedAt` timestamp pattern for soft deletes:

```typescript
// Soft delete helper
async function softDelete(collection: Collection, id: ObjectId) {
  return collection.updateOne(
    { _id: id, deletedAt: null },
    { $set: { deletedAt: new Date() } }
  );
}

// Query helper (always filter soft-deleted)
function findWithSoftDelete(collection: Collection, filter: Filter) {
  return collection.find({ ...filter, deletedAt: null });
}

// Hard delete (cleanup old soft-deleted records)
async function hardDeleteOlderThan(collection: Collection, days: number) {
  const cutoff = new Date();
  cutoff.setDate(cutoff.getDate() - days);
  return collection.deleteMany({ deletedAt: { $lt: cutoff } });
}
```

**Query Pattern:**
```typescript
// ALWAYS include deletedAt: null in queries
const links = await db.links.find({
  userId,
  projectId,
  deletedAt: null,  // Required for soft delete filter
}).toArray();
```

---

### 3.5 Index Strategy Summary

| Collection | Index | Purpose | Cardinality |
|------------|-------|---------|-------------|
| users | email (unique) | Login lookup | High |
| users | subscriptionTier + createdAt | Admin queries | Low-Medium |
| projects | userId + createdAt | User's projects | High |
| projects | tags | Tag filtering | Medium |
| links | userId + projectId + createdAt | Project links | High |
| links | userId + status + createdAt | Status filtering | Medium |
| links | url + userId | Duplicate check | High |
| ai_outputs | sourceType + sourceId + type | AI output lookup | High |
| jobs | userId + status + createdAt | User's jobs | High |
| jobs | status + nextAttemptAt | Worker scheduling | Low |

---

### 3.6 Migration Convention (migrate-mongo)

**File Naming:**
```
migrations/
├── 20260301000000_initial_schema.js
├── 20260315000000_add_subscription_tier.js
└── YYYYMMDDHHMMSS_description.js
```

**Migration Template:**
```javascript
// migrations/20260301000000_initial_schema.js
module.exports = {
  async up(db, client) {
    // Create users collection
    await db.createCollection('users');
    await db.collection('users').createIndex({ email: 1 }, { unique: true });

    // Create projects collection
    await db.createCollection('projects');
    await db.collection('projects').createIndex({ userId: 1, createdAt: -1 });

    // Seed default data
    await db.collection('users').insertOne({
      email: 'seed@example.com',
      name: 'Seed User',
      // ...
    });
  },

  async down(db, client) {
    await db.dropCollection('users');
    await db.dropCollection('projects');
  }
};
```

**Commands:**
```bash
npm run migrate:up    # Run pending migrations
npm run migrate:down  # Rollback last migration
npm run migrate:status # Show migration status
```

---

### 3.7 Dev/Staging Seed Data

**Seed Script Specification:**
```typescript
// scripts/seed.ts
import { faker } from '@faker-js/faker';

export async function seedDatabase() {
  // Create 10 test users
  const users = await createUserSeeds(10);

  // Each user gets 3-5 projects
  for (const user of users) {
    const projects = await createProjectSeeds(user._id, random(3, 5));

    // Each project gets 5-20 links
    for (const project of projects) {
      await createLinkSeeds(user._id, project._id, random(5, 20));
    }
  }

  console.log(`Seeded ${users.length} users with projects and links`);
}
```

**Seed Data Requirements:**
- 10 users with realistic profiles
- 3-5 projects per user (varied names/topics)
- 5-20 links per project (mix of statuses)
- 50% of links with completed AI outputs
- 20% of projects with generated courses

> ⚠️ **ASSUMPTIONS:**
> - MongoDB Atlas free tier (512MB) sufficient for MVP beta
> - Average document sizes remain within expected ranges
> - 90-day analytics retention meets compliance requirements
>
> 🚩 **RISKS & OPEN DECISIONS:**
> - **Risk:** ai_outputs collection grows large → **Mitigation:** Monitor size, consider compression or separate bucket
> - **Risk:** Index bloat on links collection → **Mitigation:** Review slow query logs, drop unused indexes
> - **Decision:** Soft delete for all collections → **Open:** Evaluate if jobs/analytics need hard delete only

---

---

*[← Implementation Details](./02_implementation_details.md)* | *[Back to Index](README.md)* | [Next: API Design →](./04_api_design.md)*
