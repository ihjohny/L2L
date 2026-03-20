# L2L (Link to Learn) - Section 10: Testing Strategy

**Version:** 1.0
**Date:** March 2026

---

## Section 10: Testing Strategy

### Section Purpose
This section defines the testing pyramid, tooling, coverage requirements, mock strategies, and load testing approach.

### 10.1 Testing Pyramid

```
                    ┌─────────────┐
                   │   E2E 10%   │
                  │  (Critical   │
                 │    Flows)     │
                └───────────────┘
               ┌─────────────────┐
              │  Integration 30%  │
             │   (API, Database)  │
            └───────────────────┘
           ┌─────────────────────┐
          │    Unit Tests 60%     │
         │  (Services, Utilities) │
        └─────────────────────────┘
```

| Level | Tooling | Target | Execution Time |
|-------|---------|--------|----------------|
| **Unit** | Jest (backend), flutter_test | Services, utilities, pure functions | < 5 min |
| **Integration** | Supertest + Jest | API endpoints, database operations | < 15 min |
| **E2E** | Playwright (web), Detox (mobile) | Critical user flows | < 30 min |

---

### 10.2 Coverage Gate Configuration

**Jest Config:**
```javascript
// jest.config.js
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src'],
  testMatch: ['**/*.test.ts'],
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/main.ts',
    '!src/**/*.module.ts',
    '!src/**/*.dto.ts',
    '!src/**/index.ts',
  ],
  coverageThreshold: {
    global: {
      branches: 70,
      functions: 70,
      lines: 70,
      statements: 70,
    },
  },
  coverageReporters: ['text', 'lcov', 'clover'],
  coverageDirectory: 'coverage',
};
```

**Package.json Scripts:**
```json
{
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "test:ci": "jest --coverage --ci --maxWorkers=2",
    "test:integration": "jest --config jest.integration.config.js",
    "test:e2e": "playwright test"
  }
}
```

---

### 10.3 OpenAI Mock Strategy

**MSW Handlers for Unit Tests:**
```typescript
// tests/mocks/openai-handlers.ts
import { http, HttpResponse } from 'msw';

export const openAIHandlers = [
  // Summary generation mock
  http.post('https://api.openai.com/v1/chat/completions', async ({ request }) => {
    const body = await request.json();
    const content = body.messages?.[0]?.content || '';

    if (content.includes('summarize')) {
      return HttpResponse.json({
        id: 'chatcmpl-mock',
        choices: [{
          message: {
            content: JSON.stringify({
              summary: 'This is a mock summary for testing.',
              keyPoints: ['Point 1', 'Point 2'],
              mainArgument: 'Main argument',
              takeaways: ['Takeaway 1'],
            }),
          },
        }],
        usage: { prompt_tokens: 100, completion_tokens: 50, total_tokens: 150 },
      });
    }

    if (content.includes('flashcard')) {
      return HttpResponse.json({
        id: 'chatcmpl-mock',
        choices: [{
          message: {
            content: JSON.stringify({
              flashcards: [
                { question: 'Q1?', answer: 'A1', difficulty: 'easy' },
                { question: 'Q2?', answer: 'A2', difficulty: 'medium' },
              ],
            }),
          },
        }],
        usage: { prompt_tokens: 100, completion_tokens: 80, total_tokens: 180 },
      });
    }
  }),
];
```

**Test Setup:**
```typescript
// tests/setup.ts
import { setupServer } from 'msw/node';
import { openAIHandlers } from './mocks/openai-handlers';

export const server = setupServer(...openAIHandlers);

beforeAll(() => server.listen({ onUnhandledRequest: 'error' }));
afterEach(() => server.resetHandlers());
afterAll(() => server.close());
```

**Record/Replay for Integration:**
```typescript
// Using nock for recording real API responses
import nock from 'nock';

// Record once
nock.recorder.rec({
  dont_print: true,
  output_objects: true,
});

const fixtures = nock.recorder.play();
fs.writeFileSync('tests/fixtures/openai-responses.json', JSON.stringify(fixtures));

// Replay in tests
export function mockOpenAIResponses() {
  const fixtures = JSON.parse(fs.readFileSync('tests/fixtures/openai-responses.json'));
  fixtures.forEach(fixture => {
    nock(fixture.scope).get(fixture.path).reply(fixture.response);
  });
}
```

---

### 10.4 Factory Pattern for Test Data

**Fishery Factories:**
```typescript
// tests/factories/user.factory.ts
import { Factory } from 'fishery';
import { faker } from '@faker-js/faker';
import { ObjectId } from 'mongodb';

interface User {
  _id: ObjectId;
  email: string;
  passwordHash: string;
  name: string;
  subscriptionTier: 'free' | 'premium' | 'team';
  createdAt: Date;
}

export const UserFactory = Factory.define<User>(({ sequence }) => ({
  _id: new ObjectId(),
  email: faker.internet.email(),
  passwordHash: '$2b$10$mockedHash',
  name: faker.person.fullName(),
  subscriptionTier: 'free',
  createdAt: faker.date.past(),
}));

// Usage with overrides
const user = UserFactory.build({ subscriptionTier: 'premium' });
const users = UserFactory.buildList(5);

// Build with associations
const userWithProjects = UserFactory.build({
  _id: new ObjectId('507f1f77bcf86cd799439011'),
});
```

```typescript
// tests/factories/link.factory.ts
export const LinkFactory = Factory.define<Link>(({ sequence, afterBuild }) => ({
  _id: new ObjectId(),
  userId: new ObjectId(),
  projectId: new ObjectId(),
  url: faker.internet.url(),
  title: faker.lorem.sentence(),
  status: 'pending',
  tags: [],
  createdAt: new Date(),
  updatedAt: new Date(),
  deletedAt: null,
}));

// Factory for completed link with AI output
export const CompletedLinkFactory = LinkFactory.params({
  status: 'completed',
}).afterBuild(link => {
  link.aiOutputId = new ObjectId();
});
```

---

### 10.5 k6 Load Test Script [P2]

```typescript
// tests/load/k6-script.ts
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate, Trend } from 'k6/metrics';

// Custom metrics
const errorRate = new Rate('errors');
const apiLatency = new Trend('api_latency');

export const options = {
  stages: [
    { duration: '5m', target: 100 },   // Ramp to 100 users
    { duration: '10m', target: 100 },  // Stay at 100 users
    { duration: '5m', target: 500 },   // Ramp to 500 users
    { duration: '15m', target: 500 },  // Stay at 500 users
    { duration: '5m', target: 1000 },  // Ramp to 1000 users
    { duration: '10m', target: 1000 }, // Peak load test
    { duration: '5m', target: 0 },     // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],  // 95% of requests < 500ms
    errors: ['rate<0.01'],             // Error rate < 1%
  },
};

const BASE_URL = __ENV.BASE_URL || 'https://api.staging.l2l.app/api/v1';

export default function () {
  // Scenario 1: List projects
  const projectsRes = http.get(`${BASE_URL}/projects`, {
    headers: { Authorization: `Bearer ${__ENV.TEST_TOKEN}` },
  });

  check(projectsRes, {
    'GET /projects status is 200': (r) => r.status === 200,
  });

  errorRate.add(projectsRes.status !== 200);
  apiLatency.add(projectsRes.timings.duration);

  sleep(1);

  // Scenario 2: Create link
  const linkRes = http.post(
    `${BASE_URL}/links`,
    JSON.stringify({
      url: 'https://example.com/article',
      tags: ['test', 'load-test'],
    }),
    {
      headers: {
        Authorization: `Bearer ${__ENV.TEST_TOKEN}`,
        'Content-Type': 'application/json',
      },
    }
  );

  check(linkRes, {
    'POST /links status is 201': (r) => r.status === 201,
  });

  errorRate.add(linkRes.status !== 201);
  apiLatency.add(linkRes.timings.duration);

  sleep(2);

  // Scenario 3: Get job status
  const jobRes = http.get(`${BASE_URL}/jobs/${linkRes.json().jobId}`, {
    headers: { Authorization: `Bearer ${__ENV.TEST_TOKEN}` },
  });

  check(jobRes, {
    'GET /jobs/:id status is 200': (r) => r.status === 200,
  });

  sleep(1);
}
```

**Run Load Test:**
```bash
# Install k6
brew install k6

# Run test
k6 run tests/load/k6-script.ts

# Run with environment
BASE_URL=https://api.staging.l2l.app TEST_TOKEN=xxx k6 run tests/load/k6-script.ts
```

> ⚠️ **ASSUMPTIONS:**
> - 70% coverage achievable without excessive mocking
> - MSW sufficient for OpenAI mocking (no need for local LLM)
> - k6 provides adequate load testing for P2 scale
>
> 🚩 **RISKS & OPEN DECISIONS:**
> - **Risk:** E2E tests flaky due to timing → **Mitigation:** Use Playwright's auto-wait, avoid hardcoded sleeps
> - **Risk:** Test data pollution → **Mitigation:** Use transactions, cleanup after tests
> - **Decision:** Fishery factories vs. manual builders → **Confirmed:** Fishery for type safety, reusability

---

---

*[← Security Guidelines](./09_security_guidelines.md)* | *[Back to Index](README.md)* | [Next: Observability →](./11_observability_operations.md)*
