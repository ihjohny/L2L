# Extractor Debug

Debug utilities for content extraction. Disabled by default — writes timestamped files to disk when enabled.

## Usage

```typescript
import { extractorService, enableDebug, disableDebug } from './modules/extractor';

enableDebug('./debug-content'); // enable + set output dir

const result = await extractorService.fetchContentWithMetadata('https://example.com');

disableDebug(); // turn off when done
```

## API

| Method | Description |
|--------|-------------|
| `enableDebug(dir?)` | Enable debug mode. Default dir: `./debug-content` |
| `disableDebug()` | Disable debug mode |
| `extractorDebug.isEnabled()` | Check if debug is active |
| `extractorDebug.setOptions({ enabled, debugDir })` | Update options directly |

## Output Files

Files are written as `{url-slug}-{timestamp}-{suffix}.txt`:

| Suffix | Content |
|--------|---------|
| `raw` | Original HTML response |
| `processed` | Metadata header + cleaned text |
| `ai-prompt` | Gemini prompt (AI extractor only) |
| `ai-response` | Gemini JSON response (AI extractor only) |
| `error` | Error type, message, and stack trace |

### Processed file format

```
URL: https://example.com
Fetched at: 2026-04-29T12:30:45.123Z
Title: Example Domain
Description: This domain is for use in illustrative examples
Content length: 8000 characters

=== PROCESSED CONTENT ===
[Cleaned text content...]
```

## Cleanup

```bash
# Local
rm -rf ./debug-content/*

# Docker
docker exec l2l-api-dev sh -c 'rm -rf /app/debug-content/*'
```
