# L2L (Link to Learn) - Section 11: Observability & Operations

**Version:** 1.0
**Date:** March 2026

---

## Section 11: Observability & Operations

### Section Purpose
This section defines logging standards, metrics to instrument, tracing configuration, alerting thresholds, and operational runbooks.

### 11.1 Pino Log Entry Schema

**Required Fields:**
```typescript
interface LogEntry {
  // Automatic fields (pino)
  timestamp: string;     // ISO 8601
  level: string;         // trace, debug, info, warn, error, fatal
  msg: string;           // Log message

  // Application fields (required)
  requestId: string;     // Unique per request
  userId?: string;       // Authenticated user ID
  jobId?: string;        // For async job processing
  duration?: number;     // Request/job duration in ms

  // Optional context
  error?: {
    message: string;
    stack?: string;
    code?: string;
  };

  // Business context
  [key: string]: any;    // Additional structured data
}
```

**Example Log Entry:**
```json
{
  "timestamp": "2026-03-20T10:30:00.000Z",
  "level": "info",
  "msg": "Link processed successfully",
  "requestId": "req_abc123",
  "userId": "user_xyz789",
  "jobId": "job_456",
  "duration": 4523,
  "linkId": "link_111",
  "aiModel": "gpt-4o",
  "tokenUsage": 1250
}
```

---

### 11.2 Must-Log Events

| Event | Level | Required Fields | Example |
|-------|-------|-----------------|---------|
| **Auth: Login success** | info | userId, email, ip | `User logged in` |
| **Auth: Login failed** | warn | email, ip, reason | `Failed login attempt` |
| **Auth: Token refresh** | debug | userId, oldTokenId | `Token refreshed` |
| **AI Job: Started** | info | jobId, type, linkId/projectId | `Processing link` |
| **AI Job: Completed** | info | jobId, duration, tokenUsage | `Link processed` |
| **AI Job: Failed** | error | jobId, error, attempts | `Processing failed` |
| **5xx Error** | error | requestId, path, error, stack | `Internal server error` |
| **Stripe Webhook** | info | eventType, customerId | `Subscription updated` |
| **Rate Limit Hit** | warn | userId, tier, limit | `Rate limit exceeded` |

---

### 11.3 CloudWatch Metrics

| Metric Name | Type | Dimensions | Alert Threshold |
|-------------|------|------------|-----------------|
| `ai_job_duration` | Histogram | type | p95 > 30s |
| `ai_job_failure_count` | Count | type | > 10/hour |
| `http_latency_p95` | Histogram | endpoint | > 500ms |
| `http_5xx_count` | Count | endpoint | > 1% of requests |
| `queue_depth` | Gauge | queue_name | > 100 pending |
| `active_users` | Count | - | Track only |
| `token_usage_total` | Count | model | Cost tracking |
| `openai_error_count` | Count | error_type | > 5/hour |

**Instrumentation Code:**
```typescript
// src/utils/metrics.ts
import { CloudWatch } from '@aws-sdk/client-cloudwatch';

const cloudwatch = new CloudWatch();

export async function putMetric(
  metricName: string,
  value: number,
  unit: string,
  dimensions: Record<string, string> = {},
) {
  await cloudwatch.putMetricData({
    Namespace: 'L2L',
    MetricData: [{
      MetricName: metricName,
      Value: value,
      Unit: unit as any,
      Dimensions: Object.entries(dimensions).map(([Name, Value]) => ({ Name, Value })),
      Timestamp: new Date(),
    }],
  });
}

// Usage:
await putMetric('ai_job_duration', duration, 'Milliseconds', { type: 'process_link' });
```

---

### 11.4 OpenTelemetry Trace Structure

**Span Hierarchy for AI Pipeline:**
```
trace_id: abc123
│
├─ span: POST /api/v1/links (HTTP)
│  ├─ span: JWT authentication
│  ├─ span: Zod validation
│  ├─ span: MongoDB insert (links)
│  └─ span: BullMQ add job
│
└─ span: process_link (worker) [async, same trace_id]
   ├─ span: Playwright fetch
   ├─ span: OpenAI create completion (summary)
   ├─ span: OpenAI create completion (flashcards)
   └─ span: MongoDB update (links + ai_outputs)
```

**Instrumentation Setup:**
```typescript
// src/utils/tracing.ts
import { NodeTracerProvider } from '@opentelemetry/node';
import { AWSInstrumentation } from '@opentelemetry/instrumentation-aws-sdk';
import { HttpInstrumentation } from '@opentelemetry/instrumentation-http';
import { registerInstrumentations } from '@opentelemetry/instrumentation';

const provider = new NodeTracerProvider();
provider.register();

registerInstrumentations({
  instrumentations: [
    new HttpInstrumentation({
      ignoreIncomingRequestHook: (req) => req.url === '/health',
    }),
    new AWSInstrumentation(),
  ],
});

// Manual instrumentation for AI processing
const tracer = trace.getTracer('l2l-ai');

async function processLinkWithTracing(linkId: string) {
  return tracer.startActiveSpan('process_link', async (span) => {
    span.setAttribute('link.id', linkId);

    try {
      // ... processing
      span.setStatus({ code: SpanStatusCode.OK });
    } catch (error) {
      span.setStatus({ code: SpanStatusCode.ERROR, message: error.message });
      throw error;
    } finally {
      span.end();
    }
  });
}
```

---

### 11.5 Sentry Configuration

**Sentry Setup:**
```typescript
// src/utils/sentry.ts
import * as Sentry from '@sentry/node';

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  tracesSampleRate: process.env.NODE_ENV === 'production' ? 0.1 : 1.0,
  profilesSampleRate: 0.1,

  // Ignore these error classes
  integrations: [
    new Sentry.Integrations.Http({ tracing: true }),
  ],

  beforeSend(event, hint) {
    // Filter out known non-actionable errors
    const error = hint.originalException as Error;

    if (error?.name === 'ValidationError') return null;
    if (error?.message?.includes('ECONNREFUSED')) return null;

    return event;
  },
});
```

**Alert Thresholds:**
| Alert | Condition | Severity | Action |
|-------|-----------|----------|--------|
| Error spike | > 50 errors/hour | Critical | Page on-call |
| AI failure rate | > 10% of jobs | High | Investigate OpenAI |
| Latency p95 | > 1000ms for 5min | High | Scale up |
| Queue depth | > 500 pending | Medium | Add workers |

---

### 11.6 Runbook Template

**Runbook: AI Processing Failures**

| Field | Value |
|-------|-------|
| **Trigger** | `ai_job_failure_count` > 10/hour |
| **Severity** | High |
| **On-call** | Backend engineer |

**Diagnosis Steps:**
1. Check Sentry dashboard for error patterns
2. Review CloudWatch logs for `ai_job_failed` events
3. Check OpenAI status page (status.openai.com)
4. Review BullMQ dead-letter queue

**Resolution Steps:**
1. If OpenAI outage: Enable fallback mode, notify users
2. If rate limiting: Reduce queue concurrency, implement backoff
3. If content extraction failure: Check target site accessibility
4. If persistent: Escalate to AI service team

**Escalation:**
- L1: On-call engineer
- L2: Backend team lead
- L3: CTO (if affecting all users > 30 min)

---

### 11.7 Launch Readiness Dashboard

**Pre-Launch Checklist:**

| Category | Check | Status |
|----------|-------|--------|
| **Infrastructure** | All health checks passing | ☐ |
| **Infrastructure** | Auto-scaling configured | ☐ |
| **Infrastructure** | Backup/restore tested | ☐ |
| **Observability** | All metrics instrumented | ☐ |
| **Observability** | Alerts configured and tested | ☐ |
| **Observability** | Runbooks documented | ☐ |
| **Security** | Penetration test complete | ☐ |
| **Security** | All dependencies audited | ☐ |
| **Performance** | Load test passed (10K concurrent) | ☐ |
| **Performance** | p95 latency < 500ms | ☐ |
| **Data** | Migration scripts tested | ☐ |
| **Data** | Rollback procedure documented | ☐ |
| **Support** | Customer support trained | ☐ |
| **Support** | Help center articles ready | ☐ |

> ⚠️ **ASSUMPTIONS:**
> - CloudWatch sufficient for MVP monitoring (no Datadog needed)
> - Sentry free tier adequate for closed beta
> - Single-region deployment acceptable for MVP
>
> 🚩 **RISKS & OPEN DECISIONS:**
> - **Risk:** Alert fatigue from false positives → **Mitigation:** Start with high thresholds, tune based on baseline
> - **Risk:** Distributed tracing complexity → **Mitigation:** Start with basic spans, expand post-MVP
> - **Decision:** Self-hosted vs. managed observability → **Confirmed:** Managed (Sentry, CloudWatch) for speed

---

---

*[← Testing Strategy](./10_testing_strategy.md)* | *[Back to Index](README.md)* | [Next: Pre-Launch Checklist →](./12_pre_launch_checklist.md)*
