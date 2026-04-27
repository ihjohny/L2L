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
      try {
        return await aiExtractorService.fetchContent(url, options);
      } catch (error: any) {
        logger.warn(`AI Extractor failed for ${url}, falling back to Cheerio. Error: ${error.message}`);
        return cheerioExtractorService.fetchContent(url, options);
      }
    }

    return cheerioExtractorService.fetchContent(url, options);
  }

  /**
   * Fetch content with metadata
   */
  async fetchContentWithMetadata(url: string, options: FetchContentOptions = {}): Promise<FetchContentResult> {
    const useAi = options.useAiExtractor !== undefined ? options.useAiExtractor : config.extractor.useAiExtractor;

    if (useAi) {
      try {
        return await aiExtractorService.fetchContentWithMetadata(url, options);
      } catch (error: any) {
        logger.warn(`AI Extractor failed for ${url}, falling back to Cheerio. Error: ${error.message}`);
        return cheerioExtractorService.fetchContentWithMetadata(url, options);
      }
    }

    return cheerioExtractorService.fetchContentWithMetadata(url, options);
  }

  /**
   * Validate if content is sufficient for AI processing
   * (Delegates to CheerioExtractor since the logic is identical and basic)
   */
  validateContent(content: string): { valid: boolean; reason?: string } {
    return cheerioExtractorService.validateContent(content);
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
