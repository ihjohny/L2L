# L2L (Link to Learn) - Project Plan

**Version:** 3.0 | **Date:** March 2026 | **Timeline:** 24 weeks (6 months)

> **AI-Powered Development:** This plan assumes AI-assisted engineering workflow (GitHub Copilot, Claude Code, etc.), providing ~40% productivity gain and compressing the timeline from 36 to 24 weeks.

---

## Executive Summary

L2L is an AI-powered knowledge management platform that transforms passive bookmarking into active, structured learning. The platform uses a two-tier AI processing pipeline: per-link (summaries + flashcards) and per-project (courses + quizzes).

**Key Objectives:**
- Launch MVP (Closed Beta) in 8 weeks with 500-1,000 users
- Public launch at Week 16 with 50,000 users
- Achieve 60% weekly retention and 4-6% premium conversion
- Reach 100K users and clear path to profitability by Week 24

**Budget:** ~$400K Year 1 (reduced from $550K with AI efficiency) | **Team:** 7-9 FTE | **Launch Target:** September 2026

---

## Timeline Overview

```
Q2 2026 (W1-8):   MVP - Closed Beta
Q3 2026 (W9-16):  Phase 2 - Public Launch
Q3 2026 (W17-24): Phase 3 - AI Learning Coach
```

### 3 Development Phases (AI-Powered: 40% Efficiency Gain)

| Phase | Duration | Focus | Key Deliverables |
|-------|----------|-------|------------------|
| **MVP** | W1-8 (8w) | Core Platform | Auth, Link/Project CRUD, Per-link AI, Per-project AI, Flutter app, Chrome extension, Closed Beta |
| **Phase 2** | W9-16 (8w) | Growth & Engagement | Analytics, Sharing, Gamification, Payments, Mobile apps (App Store), Public Launch |
| **Phase 3** | W17-24 (8w) | AI Coaching | Adaptive learning, RAG chatbot, Spaced repetition, Collaboration |

**Total:** 24 weeks (6 months) - *Compressed from 36 weeks with AI-powered development*

---

## Critical Path (24 weeks to full launch)

```
Infrastructure Setup (W1-2)
       ↓
Authentication + DB Schema (W3-4)
       ↓
Link/Project APIs (W5-6)
       ↓
Per-Link AI Pipeline (W6-7)
       ↓
Flutter App Core + Chrome Extension (W7-8)
       ↓
CLOSED BETA LAUNCH (W8) ⭐
       ↓
Analytics + Sharing (W9-12)
       ↓
Gamification + Payments (W13-15)
       ↓
App Store Submission (W15-16)
       ↓
PUBLIC LAUNCH (W16) ⭐
       ↓
RAG Chatbot + SRS (W17-20)
       ↓
Collaboration Features (W21-23)
       ↓
FULL RELEASE (W24) ⭐
```

---

## Key Milestones

| # | Milestone | Week | Deliverable |
|---|-----------|------|-------------|
| M1 | Infrastructure Ready | 4 | AWS, MongoDB, Redis, CI/CD operational |
| M2 | Core APIs Complete | 6 | Auth, Link, Project endpoints functional |
| M3 | Per-Link AI Working | 7 | Summaries + Flashcards auto-generated |
| M4 | Frontend MVP Ready | 8 | Flutter app + Chrome extension usable |
| M5 | **Closed Beta Launch** | **8** | **500-1,000 users, full MVP feature set** |
| M6 | Analytics + Sharing Complete | 12 | Dashboard, heatmap, share links/projects |
| M7 | Payments Integrated | 15 | Stripe subscription flow working |
| M8 | App Store Approval | 16 | iOS + Android apps approved |
| M9 | **Public Launch** | **16** | **50K users target, all Phase 2 features** |
| M10 | AI Chatbot Working | 20 | RAG-based Q&A functional |
| M11 | Collaboration Complete | 23 | Annotations, groups, public courses |
| M12 | **Full Release** | **24** | **100K users target, all Phase 3 features** |

---

## Team Structure (7-9 FTE, AI-Powered)

> **AI Efficiency Note:** With AI-powered development, the team can achieve 40% higher throughput. This allows either:
> - **Option A:** Same team (7-9 FTE) → Faster delivery (24 weeks vs 36 weeks)
> - **Option B:** Reduced team (5-6 FTE) → Same timeline with lower cost

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
- **Weeks 1-8 (MVP):** 7 FTE core team
- **Weeks 9-16 (Phase 2):** 8 FTE (+0.5 ML, +0.5 Extension)
- **Weeks 17-24 (Phase 3):** 9 FTE (+1 ML for chatbot/collaboration)

---

## Budget Breakdown

**Total: ~$400,000 Year 1 (~$44K/month average)** - *Reduced from $550K with AI efficiency*

### Monthly Costs by Phase

| Phase | Duration | Personnel | Infrastructure | Software | Marketing | **Monthly** |
|-------|----------|-----------|----------------|----------|-----------|-------------|
| **MVP** | W1-8 | $52K | $2K | $0.5K | $0.5K | **$55K** |
| **Phase 2** | W9-16 | $60K | $4K | $1K | $3K | **$68K** |
| **Phase 3** | W17-24 | $68K | $6K | $1.5K | $2K | **$77.5K** |

### Annual Summary

| Category | Annual Cost | % of Total |
|----------|-------------|------------|
| **Personnel** | $340,000 | 85% |
| **Infrastructure** (AWS, OpenAI) | $36,000 | 9% |
| **Software & Services** | $8,000 | 2% |
| **Marketing** | $16,000 | 4% |
| **Contingency (10%)** | $40,000 | 10% |

### Cost Notes
- **Infrastructure:** Scales with users ($2K MVP → $6K Phase 3)
- **AI Costs:** Major component; optimize via caching and prompt efficiency
- **Marketing:** Focused on Phase 2 public launch
- **Runway:** $1M funding = ~24 months runway (extended from 18 months)

---

## Success Metrics

### MVP Launch (Week 8)

| Metric | Target | Measurement |
|--------|--------|-------------|
| Closed beta users | 500-1,000 | Analytics |
| Link processing success rate | > 90% | AI pipeline logs |
| AI processing time (per link) | < 30 seconds | Job queue metrics |
| API response time (p95) | < 500ms | APM |
| Weekly user retention | > 60% | Cohort analysis |
| Course generation usage | > 30% of projects | Analytics |

### Phase 2 Launch (Week 16)

| Metric | Target | Measurement |
|--------|--------|-------------|
| Registered users | 50,000 | Analytics |
| Premium conversion | 4% | Stripe subscriptions |
| DAU/MAU ratio | > 40% | Active users |
| App store rating | > 4.0 | App Store / Play Store |
| Monthly recurring revenue | $20K | Stripe |

### Phase 3 Launch (Week 24)

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

### AI-Powered Development Risks
| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| **Over-reliance on AI code** | Medium | Low | Mandatory code review, test coverage requirements |
| **AI suggestion quality variance** | Low | Medium | Human review for critical paths, security-sensitive code |

---

## Scope

### MVP In Scope (Weeks 1-8)
- ✅ User authentication (email/password, JWT)
- ✅ Link capture (manual, Chrome extension)
- ✅ Project management (create, organize, tag)
- ✅ Per-link AI processing (summary + flashcards)
- ✅ Per-project AI processing (course + quiz)
- ✅ Flutter mobile app (iOS/Android)
- ✅ Flutter web app
- ✅ Chrome extension
- ✅ Basic analytics (processing status, completion tracking)

### Phase 2 In Scope (Weeks 9-16)
- ✅ AI-inferred categorization
- ✅ Advanced search and filtering
- ✅ Personal analytics dashboard
- ✅ Consistency heatmap
- ✅ Share links and projects
- ✅ Public view-only project pages
- ✅ Points, achievements, streaks
- ✅ Stripe subscription (Free/Premium)
- ✅ iOS/Android App Store launch

### Phase 3 In Scope (Weeks 17-24)
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
| **Internal Alpha** | 6 | Team (10-20 people) | Validate core flow |
| **Closed Beta** | 8 | Early adopters (500-1K) | MVP validation, feedback |
| **Public Beta** | 16 | Open registration | Public launch, 50K users |
| **Full Release** | 24 | All users | All features complete |

### Launch Checklists

#### MVP Launch (Week 8)
- [ ] Core APIs stable (99% uptime)
- [ ] AI pipeline > 90% success rate
- [ ] Flutter app crash-free (> 99%)
- [ ] Chrome extension published
- [ ] Closed beta waitlist (500+ signups)
- [ ] Feedback mechanism in place

#### Phase 2 Public Launch (Week 16)
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

### Weeks 9-16 (Phase 2)
- Deploy analytics dashboard
- Launch sharing features
- Integrate Stripe payments
- Submit to App Stores
- **Goal:** 50K users, 4% conversion

### Weeks 17-24 (Phase 3)
- Deploy AI chatbot (RAG)
- Launch spaced repetition
- Enable collaboration features
- **Goal:** 100K users, 6% conversion

### Months 7-9 (Stabilization)
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
| **Internal Alpha** | W6 | April 2026 |
| **Closed Beta (MVP)** | W8 | April 2026 |
| **Public Launch (Phase 2)** | W16 | July 2026 |
| **Full Release (Phase 3)** | W24 | August 2026 |

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
- **Total Year 1:** ~$400K (reduced from $550K with AI efficiency)
- **Monthly Burn:** $55K → $68K → $77.5K
- **Runway ($1M funding):** ~24 months (extended from 18 months)

---

**End of Project Plan**

*For detailed work packages, see the [Work Breakdown Structure](WBS.md).*
