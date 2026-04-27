import axios from 'axios';
import * as cheerio from 'cheerio';
import { logger } from '../../utils/logger';
import { extractorDebug } from './extractor-debug';

export interface FetchContentOptions {
  timeout?: number;
  maxContentLength?: number;
  userAgent?: string;
  useAiExtractor?: boolean;
}

export interface FetchContentResult {
  content: string;
  url: string;
  fetchedAt: Date;
  metadata?: {
    title?: string;
    description?: string;
    wordCount?: number;
    contentLength?: number;
  };
}

class CheerioExtractorService {
  private readonly defaultOptions: Required<Omit<FetchContentOptions, 'useAiExtractor'>> = {
    timeout: 10000,
    maxContentLength: 8000,
    userAgent: 'Mozilla/5.0 (compatible; L2L/1.0)'
  };

  /**
   * Fetch and extract content from URL
   */
  async fetchContent(url: string, options: FetchContentOptions = {}): Promise<string> {
    const opts = { ...this.defaultOptions, ...options };

    try {
      logger.info(`Fetching content from URL via Cheerio: ${url}`);

      const response = await axios.get(url, {
        timeout: opts.timeout,
        headers: {
          'User-Agent': opts.userAgent
        }
      });

      await extractorDebug.writeRawHtml(url, response.data);

      const $ = cheerio.load(response.data);

      // Remove script, style, and nav elements
      $('script').remove();
      $('style').remove();
      $('nav').remove();
      $('header').remove();
      $('footer').remove();

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
      const processedContent = content.substring(0, opts.maxContentLength);

      await extractorDebug.writeProcessedContent(url, processedContent, {
        contentLength: processedContent.length
      });

      return processedContent;
    } catch (error: any) {
      await extractorDebug.writeError(url, error);
      logger.error(`Error fetching content from ${url} via Cheerio:`, error.message);
      throw new Error(`Failed to fetch content: ${error.message}`);
    }
  }

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
        content: truncatedContent,
        url,
        fetchedAt: new Date(),
        metadata: {
          title: title?.trim(),
          description: description?.trim(),
          wordCount: content.split(/\s+/).length,
          contentLength: truncatedContent.length
        }
      };

      await extractorDebug.writeProcessedContent(url, result.content, result.metadata);

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
