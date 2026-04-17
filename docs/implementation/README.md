# L2L Implementation Guidelines

**Version:** 1.0
**Date:** March 2026
**Status:** Authoritative Implementation Reference

This directory contains the complete development implementation guidelines for the L2L (Link to Learn) platform. Each section is a self-contained, actionable document for the development team.

---

## Document Structure

| # | Section | Description |
|---|---------|-------------|
| [01](./01_architecture_overview.md) | [Architecture Overview](./01_architecture_overview.md) | System diagrams, component responsibilities, data flows, architectural decisions |
| [02](./02_implementation_details.md) | [Implementation Details](./02_implementation_details.md) | Backend structure, Flutter app patterns, Chrome extension specification |
| [03](./03_database_schema.md) | [Database Schema](./03_database_schema.md) | MongoDB collections, indexes, embedding strategies, migrations |
| [04](./04_api_design.md) | [API Design & Contracts](./04_api_design.md) | REST endpoints, JWT flows, error handling, pagination, rate limiting |
| [05](./05_configuration.md) | [Configuration & Secrets](./05_configuration.md) | Environment variables, secrets management, feature flags |
| [06](./06_dev_environment.md) | [Dev Environment Setup](./06_dev_environment_setup.md) | Prerequisites, local infrastructure, onboarding checklist |
| [07](./07_deployment_cicd.md) | [Deployment & CI/CD](./07_deployment_cicd.md) | GitHub Actions, Dockerfiles, ECS config, rollback procedures |
| [08](./08_microservices_migration.md) | [Microservices Migration](./08_microservices_migration.md) | Strangler Fig pattern, extraction roadmap, dual-write strategy |
| [09](./09_security_guidelines.md) | [Security Guidelines](./09_security_guidelines.md) | Input validation, secrets hygiene, GDPR, security checklists |
| [10](./10_testing_strategy.md) | [Testing Strategy](./10_testing_strategy.md) | Testing pyramid, coverage gates, mock strategies, load testing |
| [11](./11_observability_operations.md) | [Observability & Operations](./11_observability_operations.md) | Logging, metrics, tracing, alerting, runbooks |
| [12](./12_pre_launch_checklist.md) | [Pre-Launch Checklist](./12_pre_launch_checklist.md) | Prioritized blocking/high/deferrable items for each phase |

---

## Quick Reference

### Technology Stack
| Layer | Technology |
|-------|------------|
| Backend | Node.js + Express.js |
| Frontend | Flutter/Dart (iOS, Android, Web) |
| Extension | TypeScript, Chrome Manifest V3 |
| Database | MongoDB Atlas |
| Cache/Queue | Redis + BullMQ |
| AI | OpenAI API (GPT-4o) |
| Infrastructure | AWS ECS Fargate, S3, CloudFront |

### Key NFRs
| Metric | Target |
|--------|--------|
| API Latency (p95) | < 500ms |
| AI Processing | < 30s per link |
| Crash-free Sessions | > 99% |
| Test Coverage | > 70% |

### Phase Timeline
| Phase | Weeks | Scope |
|-------|-------|-------|
| MVP | 1-8 | Auth, CRUD, AI pipelines, Flutter app, Extension |
| Phase 2 | 9-16 | Analytics, sharing, gamification, Stripe |
| Phase 3 | 17-24 | RAG chatbot, SM-2 spaced repetition, collaboration |

---

## Related Documents

- [Product Concept](../product_concept.md) - Product vision and philosophy
- [Product Specification](../product_specification.md) - Detailed product requirements
- [Technical Specification](../technical_specification.md) - High-level architecture
- [WBS](../WBS.md) - Work Breakdown Structure

---

## Usage Guidelines

1. **For New Team Members:** Start with [Section 6: Dev Environment Setup](./06_dev_environment_setup.md) to get your environment configured.

2. **For Backend Development:** Reference [Section 2a](./02_implementation_details.md#2a-backend-nodejs-monolith), [Section 3](./03_database_schema.md), and [Section 4](./04_api_design.md).

3. **For Frontend Development:** Reference [Section 2b](./02_implementation_details.md#2b-flutter-application) and [Section 4](./04_api_design.md). Course and quiz screen implementations are detailed in the Flutter Application section.

4. **For Extension Development:** Reference [Section 2c](./02_implementation_details.md#2c-chrome-extension-manifest-v3).

5. **For DevOps/Deployment:** Reference [Section 7](./07_deployment_cicd.md) and [Section 11](./11_observability_operations.md).

---

*This is a living document. Update it as architectural decisions evolve during development.*
