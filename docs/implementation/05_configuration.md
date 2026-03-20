# L2L (Link to Learn) - Section 5: Configuration & Secrets

**Version:** 1.0
**Date:** March 2026

---

## Section 5: Configuration & Secrets

### Section Purpose
This section defines all environment variables, secrets management strategy, feature flags, and environment differences (DEV, STAGING, PROD).

### 5.1 Environment Variables Table

| Variable | Description | Type | Required | Dev Value | Prod Value | Phase |
|----------|-------------|------|----------|-----------|------------|-------|
| **Server Configuration** |
| `NODE_ENV` | Runtime environment | String | Yes | `development` | `production` | MVP |
| `PORT` | API server port | Number | Yes | `3000` | `8080` | MVP |
| `API_URL` | Public API base URL | String | Yes | `http://localhost:3000` | `https://api.l2l.app` | MVP |
| `FRONTEND_URL` | Web app URL | String | Yes | `http://localhost:3001` | `https://app.l2l.app` | MVP |
| **MongoDB** |
| `MONGODB_URI` | MongoDB connection string | String | Yes | `mongodb://localhost:27017/l2l` | `mongodb+srv://...` | MVP |
| `MONGODB_POOL_SIZE` | Connection pool size | Number | No | `10` | `50` | MVP |
| `MONGODB_MAX_IDLE_TIME` | Max idle time (ms) | Number | No | `30000` | `60000` | MVP |
| **Redis** |
| `REDIS_HOST` | Redis host | String | Yes | `localhost` | `elasticache-cluster.xxx.amazonaws.com` | MVP |
| `REDIS_PORT` | Redis port | Number | Yes | `6379` | `6379` | MVP |
| `REDIS_PASSWORD` | Redis password | String | No | - | `<secrets-manager>` | MVP |
| `REDIS_TLS_ENABLED` | Enable TLS | Boolean | No | `false` | `true` | MVP |
| **OpenAI** |
| `OPENAI_API_KEY` | OpenAI API key | String | Yes | `sk-test-...` | `<secrets-manager>` | MVP |
| `OPENAI_ORG_ID` | Organization ID | String | No | - | `org-xxx` | MVP |
| `OPENAI_MAX_TOKENS` | Max tokens per request | Number | No | `2000` | `4000` | MVP |
| `OPENAI_TIMEOUT` | Request timeout (ms) | Number | No | `30000` | `60000` | MVP |
| **JWT/Auth** |
| `JWT_SECRET` | JWT signing secret | String | Yes | `dev-secret-change-in-prod` | `<secrets-manager>` | MVP |
| `JWT_ACCESS_TTL` | Access token TTL | String | No | `15m` | `15m` | MVP |
| `JWT_REFRESH_TTL` | Refresh token TTL | String | No | `7d` | `30d` | MVP |
| **AWS/S3** |
| `AWS_REGION` | AWS region | String | Yes | `us-east-1` | `us-east-1` | MVP |
| `AWS_ACCESS_KEY_ID` | AWS access key | String | Yes | `AKIA...` | `<secrets-manager>` | MVP |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key | String | Yes | `xxx` | `<secrets-manager>` | MVP |
| `S3_BUCKET` | S3 bucket name | String | Yes | `l2l-dev-assets` | `l2l-prod-assets` | MVP |
| `S3_CLOUDFRONT_URL` | CloudFront distribution | String | No | - | `https://cdn.l2l.app` | P2 |
| **Playwright** |
| `PLAYWRIGHT_BROWSERS_PATH` | Browser install path | String | No | `./browsers` | `/opt/browsers` | MVP |
| `PLAYWRIGHT_MAX_WORKERS` | Max concurrent scrapers | Number | No | `3` | `10` | MVP |
| **Sentry** |
| `SENTRY_DSN` | Sentry DSN | String | No | - | `https://xxx@oxxx.sentry.io/xxx` | MVP |
| `SENTRY_ENVIRONMENT` | Sentry environment | String | No | `development` | `production` | MVP |
| `SENTRY_TRACES_SAMPLE_RATE` | Tracing sample rate | Number | No | `1.0` | `0.1` | MVP |
| **Stripe** [P2] |
| `STRIPE_SECRET_KEY` | Stripe secret key | String | No | `sk_test_xxx` | `<secrets-manager>` | P2 |
| `STRIPE_WEBHOOK_SECRET` | Webhook signing secret | String | No | `whsec_xxx` | `<secrets-manager>` | P2 |
| `STRIPE_PREMIUM_PRICE_ID` | Premium price ID | String | No | `price_xxx` | `price_xxx` | P2 |
| **Feature Flags** |
| `FF_AI_AUTO_CATEGORIZE` | AI auto-categorization | Boolean | No | `true` | `false` | P2 |
| `FF_GAMIFICATION` | Gamification features | Boolean | No | `true` | `false` | P2 |
| `FF_RAG_CHATBOT` | RAG chatbot feature | Boolean | No | `false` | `false` | P3 |
| **Logging** |
| `LOG_LEVEL` | Minimum log level | String | No | `debug` | `info` | MVP |
| `LOG_FORMAT` | Log format | String | No | `pretty` | `json` | MVP |

---

### 5.2 Secrets Management

**Production (AWS Secrets Manager):**
```yaml
# Secrets stored in AWS Secrets Manager:
# - l2l/prod/mongodb-uri
# - l2l/prod/redis-password
# - l2l/prod/openai-api-key
# - l2l/prod/jwt-secret
# - l2l/prod/aws-credentials
# - l2l/prod/stripe-keys

# Retrieval at runtime (Node.js):
import { SecretsManagerClient } from '@aws-sdk/client-secrets-manager';

async function getSecret(secretName: string): Promise<string> {
  const client = new SecretsManagerClient({ region: 'us-east-1' });
  const response = await client.getSecretValue({ SecretId: secretName });
  return response.SecretString;
}
```

**Development (dotenv-vault):**
```bash
# Install dotenv-vault
npm install -g dotenv-vault

# Pull development environment
dotenv-vault pull development

# .env.development is populated with team-shared values
# Never commit .env files - they are in .gitignore
```

**CI/CD (GitHub Secrets):**
```yaml
# .github/workflows/deploy.yml
env:
  MONGODB_URI: ${{ secrets.MONGODB_URI }}
  OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
  AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
  AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

---

### 5.3 Feature Flags

| Flag Name | Default | Rollout Phase | Description |
|-----------|---------|---------------|-------------|
| `FF_AI_AUTO_CATEGORIZE` | `false` | P2 | AI-inferred project categorization |
| `FF_GAMIFICATION` | `false` | P2 | Points, achievements, streaks |
| `FF_ANALYTICS_DASHBOARD` | `false` | P2 | Personal analytics dashboard |
| `FF_SHARING` | `false` | P2 | Project sharing features |
| `FF_RAG_CHATBOT` | `false` | P3 | RAG-based source chatbot |
| `FF_SPACED_REPETITION` | `false` | P3 | SM-2 flashcard scheduling |
| `FF_COLLABORATION` | `false` | P3 | Collaborative annotation |

**Feature Flag Middleware:**
```typescript
// middleware/feature-flags.ts
export function requireFeature(flagName: string) {
  return (req: Request, res: Response, next: NextFunction) => {
    const enabled = process.env[flagName] === 'true';

    if (!enabled) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'FEATURE_NOT_AVAILABLE',
          message: 'This feature is not yet available',
          flag: flagName,
        },
      });
    }

    next();
  };
}

// Usage:
// router.post('/analytics', requireFeature('FF_ANALYTICS_DASHBOARD'), analyticsController);
```

---

### 5.4 Environment Diff Matrix

| Configuration | DEV | STAGING | PROD |
|---------------|-----|---------|------|
| **Domain** | localhost | api.staging.l2l.app | api.l2l.app |
| **MongoDB** | Local Docker | Atlas (shared) | Atlas (dedicated M10) |
| **Redis** | Local Docker | ElastiCache (small) | ElastiCache (cluster) |
| **Compute** | Local | ECS Fargate (0.5 vCPU) | ECS Fargate (2 vCPU, auto-scale) |
| **OpenAI** | Free tier limits | Standard | Priority (higher tier) |
| **Logging** | Debug, pretty | Info, JSON | Warn, JSON |
| **Sentry** | Disabled | Enabled (100% sample) | Enabled (10% sample) |
| **Rate Limits** | Disabled | Relaxed | Enforced |
| **CORS** | * (all) | staging.l2l.app | l2l.app |
| **HTTPS** | No | Yes | Yes (HSTS) |
| **Backup** | None | Daily | Hourly + PITR |
| **Alerts** | None | Email | PagerDuty |

---

---

*[← API Design](./04_api_design.md)* | *[Back to Index](README.md)* | [Next: Dev Environment →](./06_dev_environment.md)*
