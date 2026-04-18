# Extractor Debug Examples

This file shows how to use the debug functionality in the extractor module.

## Basic Usage

### Enable Debug Mode Globally

```typescript
import { extractorService, enableDebug, disableDebug } from './modules/extractor';

// Enable debug mode (optional: specify custom directory)
enableDebug('./debug-content');

try {
  // Use extractor normally - debug files will be created automatically
  const content = await extractorService.fetchContent('https://example.com');

  // Debug files created:
  // - example.com-2024-04-18T12-30-45-123Z-raw.txt (Original HTML)
  // - example.com-2024-04-18T12-30-45-123Z-processed.txt (Cleaned text)
} finally {
  // Disable debug mode when done
  disableDebug();
}
```

### Using with Metadata

```typescript
import { extractorService, enableDebug, disableDebug } from './modules/extractor';

enableDebug('./my-debug-files');

const result = await extractorService.fetchContentWithMetadata('https://example.com');

console.log('Title:', result.metadata?.title);
console.log('Description:', result.metadata?.description);
console.log('Word count:', result.metadata?.wordCount);

// Debug files include metadata information
disableDebug();
```

### Advanced Debug Control

```typescript
import { extractorDebug, extractorService } from './modules/extractor';

// Create custom debug instance with specific options
const customDebug = new ExtractorDebug({
  enabled: true,
  debugDir: './custom-debug-dir'
});

// Use with extractor service
customDebug.writeRawHtml('https://example.com', '<html>...</html>');
customDebug.writeProcessedContent('https://example.com', 'Processed content...', {
  title: 'Example',
  wordCount: 150
});
```

## Debug File Formats

### Raw HTML File (`*-raw.txt`)
Contains the complete HTML response from the server.

### Processed Content File (`*-processed.txt`)
```
URL: https://example.com
Fetched at: 2024-04-18T12:30:45.123Z
Title: Example Domain
Description: This domain is for use in illustrative examples
Word count: 150
Content length: 8000 characters

=== PROCESSED CONTENT ===
[Cleaned text content here...]
```

### Error File (`*-error.txt`)
```
URL: https://example.com
Error at: 2024-04-18T12:30:45.123Z
Error Type: Error
Error Message: Failed to fetch content: Connection timeout

Stack Trace:
Error: Failed to fetch content: Connection timeout
    at ExtractorService.fetchContent (/path/to/extractor.service.ts:123)
    ...
```

## Integration with AI Processing

```typescript
import { extractorService, enableDebug, disableDebug } from './modules/extractor';
import { aiService } from './modules/ai';

// Debug while processing links
enableDebug('./ai-debug');

const url = 'https://example.com/article';
const content = await extractorService.fetchContent(url);

// Debug files help troubleshoot AI processing issues
const { summary, flashcards } = await aiService.processLink(url);

disableDebug();
```

## Best Practices

1. **Enable debug only when needed** - Debug mode creates files on disk, so enable it only during development or troubleshooting.

2. **Use separate directories** - Use different debug directories for different tasks to avoid mixing files:
   ```typescript
   enableDebug('./debug-scraping');    // For web scraping issues
   enableDebug('./debug-ai');          // For AI processing issues
   enableDebug('./debug-testing');     // For testing
   ```

3. **Clean up debug files** - Remember to clean up debug files periodically:
   ```bash
   # Remove all debug files
   rm -rf ./debug-*

   # Or add to .gitignore (already done)
   ```

4. **Check debug files in CI/CD** - You can enable debug mode in test environments to capture issues:
   ```typescript
   if (process.env.NODE_ENV === 'test') {
     enableDebug('./test-debug');
   }
   ```

## Troubleshooting

### Debug files not being created
- Ensure `enableDebug()` is called before fetching
- Check write permissions for the debug directory
- Verify the debug directory path is valid

### Debug directory not found
- The debug directory is created automatically
- Check file system permissions
- Ensure the parent directory exists

### Too many debug files
- Debug files are timestamped and won't overwrite each other
- Clean up old debug files regularly
- Use separate debug directories for different sessions
