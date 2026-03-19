# L2L (Link to Learn) - Project Plan

**Version:** 2.0 | **Date:** March 2026 | **Timeline:** 36 weeks (9 months)

---

## Executive Summary

L2L is an AI-powered knowledge management platform that transforms passive bookmarking into active, structured learning. The platform uses a two-tier AI processing pipeline: per-link (summaries + flashcards) and per-project (courses + quizzes).

**Key Objectives:**
- Launch MVP (Closed Beta) in 12 weeks with 500-1,000 users
- Public launch at Week 24 with 50,000 users
- Achieve 60% weekly retention and 4-6% premium conversion
- Reach 100K users and clear path to profitability by Week 36

**Budget:** $550K Year 1 | **Team:** 7-9 FTE | **Launch Target:** September 2026

---

## Timeline Overview

```
Q2 2026 (W1-12):  MVP - Closed Beta
Q3 2026 (W13-24): Phase 2 - Public Launch
Q4 2026 (W25-36): Phase 3 - AI Learning Coach
```

### 3 Development Phases

| Phase | Duration | Focus | Key Deliverables |
|-------|----------|-------|------------------|
| **MVP** | W1-12 (12w) | Core Platform | Auth, Link/Project CRUD, Per-link AI, Per-project AI, Flutter app, Chrome extension, Closed Beta |
| **Phase 2** | W13-24 (12w) | Growth & Engagement | Analytics, Sharing, Gamification, Payments, Mobile apps (App Store), Public Launch |
| **Phase 3** | W25-36 (12w) | AI Coaching | Adaptive learning, RAG chatbot, Spaced repetition, Collaboration |

---

## Critical Path (36 weeks to full launch)

```
Infrastructure Setup (W1-2)
       ↓
Authentication + DB Schema (W3-4)
       ↓
Link/Project APIs (W5-6)
       ↓
Per-Link AI Pipeline (W7-8)
       ↓
Flutter App Core (W9-10)
       ↓
Chrome Extension (W9-10)
       ↓
Per-Project AI (Course/Quiz) (W11-12)
       ↓
CLOSED BETA LAUNCH (W12) ⭐
       ↓
Analytics + Sharing (W13-18)
       ↓
Gamification + Payments (W19-21)
       ↓
App Store Submission (W22-23)
       ↓
PUBLIC LAUNCH (W24) ⭐
       ↓
RAG Chatbot + SRS (W25-30)
       ↓
Collaboration Features (W31-34)
       ↓
FULL RELEASE (W36) ⭐
```

---

## Key Milestones

| # | Milestone | Week | Deliverable |
|---|-----------|------|-------------|
| M1 | Infrastructure Ready | 4 | AWS, MongoDB, Redis, CI/CD operational |
| M2 | Core APIs Complete | 6 | Auth, Link, Project endpoints functional |
| M3 | Per-Link AI Working | 8 | Summaries + Flashcards auto-generated |
| M4 | Frontend MVP Ready | 10 | Flutter app + Chrome extension usable |
| M5 | **Closed Beta Launch** | **12** | **500-1,000 users, full MVP feature set** |
| M6 | Analytics + Sharing Complete | 18 | Dashboard, heatmap, share links/projects |
| M7 | Payments Integrated | 21 | Stripe subscription flow working |
| M8 | App Store Approval | 23 | iOS + Android apps approved |
| M9 | **Public Launch** | **24** | **50K users target, all Phase 2 features** |
| M10 | AI Chatbot Working | 30 | RAG-based Q&A functional |
| M11 | Collaboration Complete | 34 | Annotations, groups, public courses |
| M12 | **Full Release** | **36** | **100K users target, all Phase 3 features** |

---

## Team Structure (7-9 FTE)

### Core Team

| Role | MVP (FTE) | Phase 2 (FTE) | Phase 3 (FTE) | Responsibilities |
|------|-----------|---------------|---------------|------------------|
| **Backend Developer** | 2 | 2 | 2 | Node.js APIs, AI pipeline, database |
| **Frontend Developer (Flutter)** | 2 | 2 | 2 | Mobile + Web app |
| **Extension Developer** | 1 | 0.5 | 0.5 | Chrome extension |
| **ML/AI Engineer** | 0.5 | 1 | 2 | OpenAI integration, RAG, SRS |
| **QA Engineer** | 1 | 1 | 1 | Testing (manual + automated) |
| **DevOps** | 0.5 | 0.5 | 0.5 | Infrastructure, CI/CD, monitoring |
| **Product/Design** | 1 | 1 | 1 | UX, requirements, design |
| **Total** | **7** | **8** | **9** | |

### Ramp-Up Schedule
- **Weeks 1-12 (MVP):** 7 FTE core team
- **Weeks 13-24 (Phase 2):** 8 FTE (+0.5 ML, +0.5 Extension)
- **Weeks 25-36 (Phase 3):** 9 FTE (+1 ML for chatbot/collaboration)

---

## Budget Breakdown

**Total: ~$550,000 Year 1 (~$61K/month average)**

### Monthly Costs by Phase

| Phase | Duration | Personnel | Infrastructure | Software | Marketing | **Monthly** |
|-------|----------|-----------|----------------|----------|-----------|-------------|
| **MVP** | W1-12 | $52K | $2K | $0.5K | $0.5K | **$55K** |
| **Phase 2** | W13-24 | $60K | $4K | $1K | $3K | **$68K** |
| **Phase 3** | W25-36 | $68K | $6K | $1.5K | $2K | **$77.5K** |

### Annual Summary

| Category | Annual Cost | % of Total |
|----------|-------------|------------|
| **Personnel** | $468,000 | 85% |
| **Infrastructure** (AWS, OpenAI) | $48,000 | 9% |
| **Software & Services** | $12,000 | 2% |
| **Marketing** | $30,000 | 4% |
| **Contingency (10%)** | $56,000 | 10% |

### Cost Notes
- **Infrastructure:** Scales with users ($2K MVP → $6K Phase 3)
- **AI Costs:** Major component; optimize via caching and prompt efficiency
- **Marketing:** Focused on Phase 2 public launch
- **Runway:** $1M funding = ~18 months runway

---

## Success Metrics

### MVP Launch (Week 12)

| Metric | Target | Measurement |
|--------|--------|-------------|
| Closed beta users | 500-1,000 | Analytics |
| Link processing success rate | > 90% | AI pipeline logs |
| AI processing time (per link) | < 30 seconds | Job queue metrics |
| API response time (p95) | < 500ms | APM |
| Weekly user retention | > 60% | Cohort analysis |
| Course generation usage | > 30% of projects | Analytics |

### Phase 2 Launch (Week 24)

| Metric | Target | Measurement |
|--------|--------|-------------|
| Registered users | 50,000 | Analytics |
| Premium conversion | 4% | Stripe subscriptions |
| DAU/MAU ratio | > 40% | Active users |
| App store rating | > 4.0 | App Store / Play Store |
| Monthly recurring revenue | $20K | Stripe |

### Phase 3 Launch (Week 36)

| Metric | Target | Measurement |
|--------|--------|-------------|
| Active users | 100,000 | Analytics |
| Premium conversion | 6% | Stripe subscriptions |
| Chatbot engagement | > 25% of users | Chat analytics |
| NPS score | > 50 | User surveys |
| Path to profitability | Clear | Financial projections |

---

## Top 5 Risks & Mitigation

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| **AI processing failures/delays** | High | Medium | Queue system with retries, user notifications, progressive enhancement |
| **Content extraction failures** (paywalls, JS-heavy sites) | Medium | High | Multiple extraction strategies (Playwright + fallbacks), manual input option |
| **High AI API costs** | Medium | High | Response caching, prompt optimization, tiered processing limits |
| **Low user adoption** | High | Medium | Strong GTM strategy, beta feedback loops, Product Hunt launch |
| **Low premium conversion** | High | Medium | Optimize free tier limits, demonstrate value early, A/B test pricing |

---

## Scope

### MVP In Scope (Weeks 1-12)
- ✅ User authentication (email/password, JWT)
- ✅ Link capture (manual, Chrome extension)
- ✅ Project management (create, organize, tag)
- ✅ Per-link AI processing (summary + flashcards)
- ✅ Per-project AI processing (course + quiz)
- ✅ Flutter mobile app (iOS/Android)
- ✅ Flutter web app
- ✅ Chrome extension
- ✅ Basic analytics (processing status, completion tracking)

### Phase 2 In Scope (Weeks 13-24)
- ✅ AI-inferred categorization
- ✅ Advanced search and filtering
- ✅ Personal analytics dashboard
- ✅ Consistency heatmap
- ✅ Share links and projects
- ✅ Public view-only project pages
- ✅ Points, achievements, streaks
- ✅ Stripe subscription (Free/Premium)
- ✅ iOS/Android App Store launch

### Phase 3 In Scope (Weeks 25-36)
- ✅ Adaptive learning paths
- ✅ Study schedules
- ✅ Spaced repetition (SM-2) for flashcards
- ✅ RAG-based source chatbot
- ✅ Collaborative annotation
- ✅ Group learning
- ✅ Public courses

### Out of Scope (Post-Year 1)
- ❌ Desktop applications (macOS, Windows)
- ❌ Native mobile optimizations (if Flutter suffices)
- ❌ Custom AI model fine-tuning
- ❌ LMS integrations (Canvas, Blackboard)
- ❌ White-label / Enterprise customization
- ❌ Team/Enterprise tier ($19.99/user/month)

---

## Launch Strategy

### Phased Rollout

| Phase | Week | Audience | Goal |
|-------|------|----------|------|
| **Internal Alpha** | 8 | Team (10-20 people) | Validate core flow |
| **Closed Beta** | 12 | Early adopters (500-1K) | MVP validation, feedback |
| **Public Beta** | 24 | Open registration | Public launch, 50K users |
| **Full Release** | 36 | All users | All features complete |

### Launch Checklists

#### MVP Launch (Week 12)
- [ ] Core APIs stable (99% uptime)
- [ ] AI pipeline > 90% success rate
- [ ] Flutter app crash-free (> 99%)
- [ ] Chrome extension published
- [ ] Closed beta waitlist (500+ signups)
- [ ] Feedback mechanism in place

#### Phase 2 Public Launch (Week 24)
**Technical:**
- [ ] All critical bugs resolved
- [ ] Load testing complete (10K concurrent)
- [ ] Security audit passed
- [ ] Performance benchmarks met

**App Stores:**
- [ ] App Store approved
- [ ] Play Store approved
- [ ] Listings complete (screenshots, descriptions)

**Marketing:**
- [ ] Marketing website live
- [ ] Press kit ready
- [ ] Product Hunt launch scheduled
- [ ] Email campaigns prepared

**Operational:**
- [ ] Support documentation complete
- [ ] Incident response plan ready
- [ ] Monitoring dashboards configured

---

## Communication Plan

### Internal
- **Daily:** 15-min standup (Slack/Zoom)
- **Weekly:** Sprint review + retrospective (1 hour)
- **Bi-weekly:** Stakeholder update (dashboard + email)
- **Monthly:** Roadmap review and adjustment

### External
- **Bi-weekly:** Beta tester newsletter
- **Monthly:** Social media updates (Twitter, LinkedIn)
- **Quarterly:** Public blog posts (milestones, roadmap)

---

## Quality Standards

### Code Quality
- **Test Coverage:** > 70% (backend + frontend)
- **Code Reviews:** Mandatory, 1+ approval required
- **Linting:** ESLint, Prettier, Dart Formatter
- **CI/CD:** Automated tests on every PR

### Performance
- **API Response:** P95 < 500ms
- **Page Load:** < 2 seconds
- **App Launch:** < 3 seconds
- **AI Processing:** < 30 seconds per link

### Security
- **OWASP Top 10:** No critical vulnerabilities
- **Encryption:** TLS 1.3, bcrypt passwords
- **Compliance:** GDPR, CCPA ready
- **Audit:** Security review before Phase 2 launch

---

## Post-Launch Roadmap

### Weeks 13-24 (Phase 2)
- Deploy analytics dashboard
- Launch sharing features
- Integrate Stripe payments
- Submit to App Stores
- **Goal:** 50K users, 4% conversion

### Weeks 25-36 (Phase 3)
- Deploy AI chatbot (RAG)
- Launch spaced repetition
- Enable collaboration features
- **Goal:** 100K users, 6% conversion

### Months 10-12 (Stabilization)
- Performance optimization
- User feedback implementation
- Technical debt reduction
- **Goal:** Path to profitability clear

---

## Quick Reference

### Project Timeline
| Event | Week | Date |
|-------|------|------|
| **Project Start** | W1 | March 2026 |
| **Internal Alpha** | W8 | April 2026 |
| **Closed Beta (MVP)** | W12 | May 2026 |
| **Public Launch (Phase 2)** | W24 | August 2026 |
| **Full Release (Phase 3)** | W36 | November 2026 |

### Key Contacts
- **Product Manager:** [TBD]
- **Technical Lead:** [TBD]
- **Design Lead:** [TBD]

### Key Documents
- [Product Concept](product_concept.md)
- [Product Specification](product_specification.md)
- [Technical Specification](technical_specification.md)
- [Work Breakdown Structure](WBS.md)

### Budget Summary
- **Total Year 1:** ~$550K
- **Monthly Burn:** $55K → $68K → $77.5K
- **Runway ($1M funding):** ~18 months

---

**End of Project Plan**

*For detailed work packages, see the [Work Breakdown Structure](WBS.md).*
