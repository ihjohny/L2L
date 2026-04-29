import axios from 'axios';
import * as cheerio from 'cheerio';
import { logger } from '../../utils/logger';
import { extractorDebug } from './extractor-debug';
import type { FetchContentOptions, FetchContentResult } from './extractor.service';

class CheerioExtractorService {
  private readonly defaultOptions: Required<Omit<FetchContentOptions, 'useAiExtractor'>> = {
    timeout: 10000,
    maxContentLength: 25000,
    userAgent: 'Mozilla/5.0 (compatible; L2L/1.0)'
  };

  /**
   * Fetch content with metadata
   */
  async fetchContentWithMetadata(url: string, options: FetchContentOptions = {}): Promise<FetchContentResult> {
    const opts = { ...this.defaultOptions, ...options };

    try {
      logger.info(`Fetching content with metadata from URL via Cheerio: ${url}`);

      const response = await axios.get(url, {
        timeout: opts.timeout,
        headers: {
          'User-Agent': opts.userAgent
        }
      });

      await extractorDebug.writeRawHtml(url, response.data);

      const $ = cheerio.load(response.data);

      // Extract metadata
      const title = $('title').first().text() ||
        $('meta[property="og:title"]').attr('content') ||
        $('h1').first().text();

      const description = $('meta[name="description"]').attr('content') ||
        $('meta[property="og:description"]').attr('content') || '';

      // Remove script, style, and nav elements
      $('script').remove();
      $('style').remove();
      $('nav').remove();
      $('header').remove();
      $('footer').remove();
      $('aside').remove();

      // Get main content (try common selectors first)
      let content = '';
      const mainSelectors = [
        'article',
        'main',
        '.content',
        '.post',
        '.article',
        '#content',
        '[role="main"]',
        '.main-content'
      ];

      for (const selector of mainSelectors) {
        const element = $(selector).first();
        if (element.length > 0 && element.text().trim().length > 100) {
          content = element.text();
          break;
        }
      }

      // Fallback to body
      if (!content || content.trim().length < 50) {
        content = $('body').text();
      }

      // Clean up whitespace
      content = content.replace(/\s+/g, ' ').trim();

      // Limit content length for AI processing (token limit)
      const truncatedContent = content.substring(0, opts.maxContentLength);

      const result: FetchContentResult = {
        url,
        fetchedAt: new Date(),
        title: title?.trim() || null,
        description: description?.trim() || null,
        mainContent: truncatedContent,
        contentLength: truncatedContent.length
      };

      await extractorDebug.writeProcessedContent(url, result.mainContent, {
        title: result.title ?? undefined,
        description: result.description ?? undefined,
        contentLength: result.contentLength
      });

      return result;
    } catch (error: any) {
      await extractorDebug.writeError(url, error);
      logger.error(`Error fetching content with metadata from ${url} via Cheerio:`, error.message);
      throw new Error(`Failed to fetch content: ${error.message}`);
    }
  }

}

const cheerioExtractorService = new CheerioExtractorService();
export default cheerioExtractorService;
export { cheerioExtractorService };
