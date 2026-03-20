# L2L (Link to Learn) - Section 9: Security Guidelines

**Version:** 1.0
**Date:** March 2026

---

## Section 9: Security Guidelines

### Section Purpose
This section defines security best practices, input validation patterns, secrets hygiene, compliance requirements, and security checklists for each phase.

### 9.1 Input Validation: Zod Schema Pattern

**Zod Schema for API Inputs:**
```typescript
// src/utils/validation.ts
import { z } from 'zod';

// User registration
export const RegisterSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string()
    .min(8, 'Password must be at least 8 characters')
    .regex(/[A-Z]/, 'Password must contain uppercase letter')
    .regex(/[0-9]/, 'Password must contain a number'),
  name: z.string().min(1).max(100),
});

// Link creation
export const CreateLinkSchema = z.object({
  url: z.string().url('Invalid URL format'),
  title: z.string().max(500).optional(),
  projectId: z.string().regex(/^[0-9a-f]{24}$/).optional(),
  tags: z.array(z.string().max(50)).max(10).optional(),
});

// Project creation
export const CreateProjectSchema = z.object({
  name: z.string().min(1).max(100),
  description: z.string().max(500).optional(),
  tags: z.array(z.string().max(50)).max(20).optional(),
});

// Course generation
export const GenerateCourseSchema = z.object({
  forceRegenerate: z.boolean().optional(),
});

// Middleware integration
export function validateRequest(schema: z.ZodSchema) {
  return (req: Request, res: Response, next: NextFunction) => {
    try {
      req.body = schema.parse(req.body);
      next();
    } catch (error) {
      if (error instanceof z.ZodError) {
        next(new ValidationError('Invalid input', error.errors));
      } else {
        next(error);
      }
    }
  };
}

// Usage in controller:
// router.post('/links', validateRequest(CreateLinkSchema), linkController.create);
```

---

### 9.2 Playwright Sandbox Config

**Secure Content Extraction:**
```typescript
// src/ai/scraper.service.ts
import { chromium } from 'playwright';

export class ScraperService {
  private browser: Browser;

  async initialize() {
    this.browser = await chromium.launch({
      headless: true,
      args: [
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-dev-shm-usage',
        '--disable-accelerated-2d-canvas',
        '--disable-gpu',
        '--deterministic-fetch',
      ],
    });
  }

  async fetchUrl(url: string): Promise<string> {
    // Validate URL before fetching
    const parsed = new URL(url);

    // Block non-HTTP protocols
    if (!['http:', 'https:'].includes(parsed.protocol)) {
      throw new ValidationError('Only HTTP/HTTPS URLs allowed');
    }

    // Block internal/private IPs
    if (this.isPrivateIP(parsed.hostname)) {
      throw new ValidationError('Cannot access internal resources');
    }

    const context = await this.browser.newContext({
      viewport: { width: 1280, height: 800 },
      userAgent: 'L2L-Scraper/1.0 (+https://l2l.app/bot)',
      bypassCSP: false,
      javaScriptEnabled: true, // Required for dynamic content
      resourceTimeout: 15000,
    });

    const page = await context.newPage();

    try {
      await page.goto(url, {
        waitUntil: 'networkidle',
        timeout: 30000,
      });

      // Extract content
      const content = await page.evaluate(() => {
        // Remove scripts, styles, nav, footer
        document.querySelectorAll('script, style, nav, footer').forEach(el => el.remove());
        return document.body.innerText;
      });

      return content;
    } finally {
      await context.close();
    }
  }

  private isPrivateIP(hostname: string): boolean {
    // Check for localhost, private IP ranges
    const privatePatterns = [
      /^localhost$/,
      /^127\./,
      /^10\./,
      /^172\.(1[6-9]|2[0-9]|3[0-1])\./,
      /^192\.168\./,
    ];
    return privatePatterns.some(pattern => pattern.test(hostname));
  }
}
```

---

### 9.3 Secrets Hygiene: Pre-commit Gitleaks Hook

**.gitleaks.toml:**
```toml
title = "L2L Secrets Detection"

[extend]
useDefault = true

[[rules]]
id = "aws-access-key-id"
description = "AWS Access Key ID"
regex = '''(A3T[A-Z0-9]|AKIA|AGPA|AIDA|AROA|AIPA|ANPA|ANVA|ASIA)[A-Z0-9]{16}'''
tags = ["aws"]

[[rules]]
id = "aws-secret-access-key"
description = "AWS Secret Access Key"
regex = '''(?i)aws(.{0,20})?(?-i)['\"][0-9a-zA-Z\/+]{40}['\"]'''
tags = ["aws"]

[[rules]]
id = "openai-api-key"
description = "OpenAI API Key"
regex = '''sk-[a-zA-Z0-9]{48}'''
tags = ["openai"]

[[rules]]
id = "jwt-secret"
description = "JWT Secret"
regex = '''(?i)(jwt|json(web)?[_-]?token)[^a-zA-Z0-9]{0,50}['\"][a-zA-Z0-9+\/\-=_]{20,}['\"]'''
tags = ["jwt"]

[[rules]]
id = "generic-api-key"
description = "Generic API Key"
regex = '''(?i)(api[_-]?key|apikey|api_secret)[^a-zA-Z0-9]{0,50}['\"][a-zA-Z0-9]{20,}['\"]'''

[allowlist]
description = "Allowlisted files"
paths = [
  '''^\.env\.example$''',
  '''^docs/''',
  '''^tests/.*\.test\.(ts|js)$''',
]
```

**Pre-commit Hook Setup:**
```bash
# Install gitleaks
brew install gitleaks

# Add pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
echo "Running secrets scan..."
gitleaks detect --source . --pre-commit --redact
if [ $? -ne 0 ]; then
  echo "Secrets detected! Commit blocked."
  exit 1
fi
EOF

chmod +x .git/hooks/pre-commit
```

---

### 9.4 npm audit in CI Gate

**GitHub Actions Integration:**
```yaml
# .github/workflows/security.yml
security:
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4

    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '20'

    - name: Install dependencies
      working-directory: ./backend
      run: npm ci

    - name: Run npm audit
      working-directory: ./backend
      run: npm audit --audit-level=high
      continue-on-error: false  # Fail build on high severity

    - name: Run Snyk
      uses: snyk/actions/node@master
      env:
        SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
      continue-on-error: true  # Snyk findings for awareness
```

---

### 9.5 GDPR Endpoints

**Data Export:**
```typescript
// src/modules/compliance/compliance.controller.ts
@Controller('compliance')
export class ComplianceController {
  @Post('export')
  async requestDataExport(@Req() req: Request) {
    const userId = req.user.id;

    // Create export job
    const job = await this.exportService.createExportJob(userId);

    return {
      success: true,
      jobId: job.id,
      message: 'Export will be ready in 24 hours',
    };
  }

  @Get('export/:jobId')
  async getExportStatus(@Param('jobId') jobId: string) {
    const job = await this.exportService.getExportJob(jobId);

    if (job.status === 'completed') {
      return {
        success: true,
        downloadUrl: job.downloadUrl,
        expiresAt: job.expiresAt,
      };
    }

    return {
      success: true,
      status: job.status,
      estimatedCompletion: job.estimatedCompletion,
    };
  }
}
```

**Account Deletion:**
```typescript
@Controller('account')
export class AccountController {
  @Delete('me')
  async deleteAccount(@Req() req: Request, @Body() body: { confirm: boolean }) {
    if (!body.confirm) {
      throw new ValidationError('Confirmation required');
    }

    const userId = req.user.id;

    // Soft delete immediately
    await this.userService.softDelete(userId);

    // Schedule hard delete after 30 days (GDPR right to erasure)
    const hardDeleteDate = new Date();
    hardDeleteDate.setDate(hardDeleteDate.getDate() + 30);

    await this.scheduleHardDelete(userId, hardDeleteDate);

    // Invalidate all tokens
    await this.authService.invalidateAllTokens(userId);

    return {
      success: true,
      message: 'Account scheduled for deletion',
      deletionDate: hardDeleteDate,
    };
  }
}
```

---

### 9.6 Security Checklist

**MVP Launch Security Checklist:**
- [ ] HTTPS enforced on all endpoints (HSTS enabled)
- [ ] JWT secrets rotated from defaults
- [ ] Rate limiting enabled on auth endpoints
- [ ] Input validation on all API endpoints (Zod schemas)
- [ ] SQL/NoSQL injection protection (parameterized queries)
- [ ] XSS protection (Content-Security-Policy headers)
- [ ] CORS configured for allowed origins only
- [ ] Playwright sandbox configured for content extraction
- [ ] gitleaks pre-commit hook installed
- [ ] npm audit passes (no high-severity vulnerabilities)
- [ ] MongoDB authentication enabled
- [ ] Redis authentication enabled (if exposed)
- [ ] AWS security groups restrict access appropriately
- [ ] Sentry configured to redact PII
- [ ] Error messages don't leak internal details

**Phase 2 Launch Security Checklist:**
- [ ] All MVP items complete
- [ ] Stripe webhook signature verification
- [ ] Payment data never logged
- [ ] Sharing permissions validated server-side
- [ ] Public project slugs validated (no PII leakage)
- [ ] Analytics events don't contain sensitive data
- [ ] Rate limiting on all new endpoints
- [ ] Penetration test completed
- [ ] Dependency audit updated

**Phase 3 Launch Security Checklist:**
- [ ] All P2 items complete
- [ ] RAG chatbot input sanitization
- [ ] Vector database access controls
- [ ] Collaborative annotation permission checks
- [ ] Real-time sync authorization
- [ ] Public course content moderation

---

---

*[← Microservices Migration](./08_microservices_migration.md)* | *[Back to Index](README.md)* | [Next: Testing Strategy →](./10_testing_strategy.md)*
