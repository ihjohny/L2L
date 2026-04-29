import { config } from '../../config';
import { logger } from '../../utils/logger';
import cheerioExtractorService from './cheerio-extractor.service';
import aiExtractorService from './ai-extractor.service';
import { FetchContentOptions, FetchContentResult } from './cheerio-extractor.service';

export { FetchContentOptions, FetchContentResult };

class ExtractorFacade {
  /**
   * Fetch and extract content from URL
   */
  async fetchContent(url: string, options: FetchContentOptions = {}): Promise<string> {
    const useAi = options.useAiExtractor !== undefined ? options.useAiExtractor : config.extractor.useAiExtractor;

    if (useAi) {
      return await aiExtractorService.fetchContent(url, options);
    } else {
      return cheerioExtractorService.fetchContent(url, options);
    }
  }

  /**
   * Validate if content is sufficient for AI processing
   */
  validateContent(content: string): { valid: boolean; reason?: string } {
    if (!content || content.length < 50) {
      return { valid: false, reason: 'Content too short or empty' };
    }

    if (content.length < 100) {
      return { valid: false, reason: 'Content insufficient for quality processing' };
    }

    return { valid: true };
  }

  /**
   * Fetch multiple URLs in parallel with rate limiting
   */
  async fetchMultiple(urls: string[], options: FetchContentOptions = {}): Promise<Map<string, string>> {
    const results = new Map<string, string>();

    // Process in batches to avoid overwhelming servers
    const batchSize = 5;
    for (let i = 0; i < urls.length; i += batchSize) {
      const batch = urls.slice(i, i + batchSize);
      const promises = batch.map(async (url) => {
        try {
          const content = await this.fetchContent(url, options);
          results.set(url, content);
        } catch (error) {
          logger.warn(`Failed to fetch ${url}:`, error);
          results.set(url, '');
        }
      });

      await Promise.all(promises);
    }

    return results;
  }
}

const extractorService = new ExtractorFacade();
export default extractorService;
export { extractorService };
