# L2L (Link to Learn) - Section 8: Microservices Migration

**Version:** 1.0
**Date:** March 2026

---

## Section 8: Microservices Migration Roadmap

### Section Purpose
This section outlines the strategy for evolving from the MVP monolith to a microservices architecture, including triggers, extraction order, and migration patterns.

### 8.1 MVP Coupling Points to Instrument

**Instrument Now for Future Extraction:**

| Coupling Point | Instrumentation | Purpose |
|----------------|-----------------|---------|
| **Auth Module** | Event emission on login/logout | Future Auth Service integration |
| **AI Processing** | Separate queue, isolated context | Future AI Service extraction |
| **Analytics** | Event sourcing pattern | Future Analytics Service |
| **Database** | Schema separation by module | Easier data ownership split |

**Event Bus Pattern (prepare for microservices):**
```typescript
// src/common/events/event-bus.ts
export interface DomainEvent {
  type: string;
  payload: any;
  metadata: {
    timestamp: Date;
    correlationId: string;
    userId?: string;
  };
}

export class EventBus {
  private emitters: EventEmitter[] = [];

  emit(event: DomainEvent) {
    // In MVP: in-process event emission
    this.emitters.forEach(e => e.emit(event.type, event));

    // Future: Publish to external message broker (SNS/SQS)
    // await this.publishToBroker(event);
  }

  subscribe(type: string, handler: (event: DomainEvent) => void) {
    const emitter = new EventEmitter();
    emitter.on(type, handler);
    this.emitters.push(emitter);
  }
}

// Usage in Auth Service:
this.eventBus.emit({
  type: 'user.logged_in',
  payload: { userId: user.id, email: user.email },
  metadata: {
    timestamp: new Date(),
    correlationId: req.id,
  },
});
```

---

### 8.2 Strangler Fig Pattern Rationale

**Why Strangler Fig:**
1. **Incremental Migration:** No big-bang rewrite risk
2. **Team Scaling:** Teams can own services independently
3. **Technology Flexibility:** Each service can use optimal stack
4. **Risk Mitigation:** Failures isolated to single service

**Migration Phases:**
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Strangler Fig Migration Pattern                          │
└─────────────────────────────────────────────────────────────────────────────┘

Phase 1 (MVP Monolith):
┌─────────────────────────────────────────┐
│           MONOLITH                      │
│  Auth │ Link │ Project │ AI │ Analytics │
└─────────────────────────────────────────┘

Phase 2 (First Extraction - AI Service):
┌─────────────────────┐     ┌─────────────────────┐
│      MONOLITH       │────>│    AI SERVICE       │
│  Auth │ Link │ Proj │     │  (async workers)    │
└─────────────────────┘     └─────────────────────┘

Phase 3 (Auth Service):
┌─────────────────────┐     ┌─────────────────────┐
│      MONOLITH       │     │    AUTH SERVICE     │
│  Link │ Project     │     │  (JWT, OAuth)       │
└─────────────────────┘     └─────────────────────┘
         ▲                          │
         └──────────────────────────┘

Phase 4 (Full Microservices):
┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐
│   Auth   │ │ Content  │ │   AI     │ │Analytics │
│ Service  │ │ Service  │ │ Service  │ │ Service  │
└──────────┘ └──────────┘ └──────────┘ └──────────┘
```

---

### 8.3 Extraction Roadmap

| Phase | Trigger Criteria | Service | Infra Change | Data Ownership | Risk |
|-------|------------------|---------|--------------|----------------|------|
| **Phase 1** | AI processing > 50% of load, team > 5 devs | AI Processing Service | Separate ECS service, dedicated workers | ai_outputs, jobs | Medium |
| **Phase 2** | Auth complexity grows, OAuth needed | Auth Service | New service, JWT centralization | users (auth fields) | High |
| **Phase 3** | Analytics queries slow, custom dashboards | Analytics Service | Read replica, timeseries DB | analytics_events | Low |
| **Phase 4** | RAG/Chatbot scale requirements | RAG/Chat Service | Vector DB (Pinecone) | chat_sessions, vectors | Medium |

---

### 8.4 Dual-Write Strategy Template

**For Each Extraction:**

```typescript
// Phase: Dual-write during migration
class LinkService {
  constructor(
    private monolithDb: MongoClient,
    private newServiceClient: HttpService, // Future AI service
  ) {}

  async processLink(linkId: string) {
    // 1. Write to monolith DB (current)
    await this.monolithDb.links.updateOne(
      { _id: linkId },
      { $set: { status: 'processing' } }
    );

    // 2. Dual-write: Also send to new service
    try {
      await this.newServiceClient.post('/process', { linkId });
    } catch (error) {
      // Log but don't fail - monolith is source of truth during migration
      logger.warn('New service unavailable, using monolith', { linkId });
    }

    // 3. Process in monolith (will be removed post-migration)
    return this.processInMonolith(linkId);
  }
}

// Migration phases:
// 1. Dual-write enabled, read from monolith
// 2. Dual-write enabled, read from new service (canary)
// 3. Dual-write disabled, read from new service, monolith as fallback
// 4. Monolith code removed
```

---

### 8.5 API Contract Versioning Impact

| Extraction | API Impact | Version Strategy |
|------------|------------|------------------|
| AI Service | Internal RPC, no client change | gRPC between services |
| Auth Service | JWT validation endpoint | Maintain /auth/* routes via API Gateway |
| Analytics Service | New /analytics/* endpoints | v1 from start |
| RAG Service | New /chat/* endpoints | v1 from start |

**API Gateway Routing (post-extraction):**
```yaml
# API Gateway configuration
routes:
  - path: /api/v1/auth/*
    target: auth-service:8080

  - path: /api/v1/links/*
    target: content-service:8080

  - path: /api/v1/projects/*
    target: content-service:8080

  - path: /api/v1/jobs/*
    target: content-service:8080

  - path: /api/v1/analytics/*
    target: analytics-service:8080

  - path: /api/v1/chat/*
    target: rag-service:8080
```

> ⚠️ **ASSUMPTIONS:**
> - Monolith remains maintainable until team grows beyond 8-10 devs
> - AI Service is highest priority due to compute isolation needs
> - Auth Service extraction requires careful JWT migration planning
>
> 🚩 **RISKS & OPEN DECISIONS:**
> - **Risk:** Premature microservices adoption → **Mitigation:** Wait for trigger criteria
> - **Risk:** Data consistency during dual-write → **Mitigation:** Implement reconciliation job
> - **Decision:** API Gateway vs. service mesh → **Pending:** Evaluate based on Phase 3 complexity

---

---

*[← Deployment & CI/CD](./07_deployment_cicd.md)* | *[Back to Index](README.md)* | [Next: Security Guidelines →](./09_security_guidelines.md)*
