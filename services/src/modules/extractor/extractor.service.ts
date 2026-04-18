import axios from 'axios';
import * as cheerio from 'cheerio';
import { logger } from '../../utils/logger';
import { config } from '../../config';

export interface FetchContentOptions {
  timeout?: number;
  maxContentLength?: number;
  userAgent?: string;
}

export interface FetchContentResult {
  content: string;
  url: string;
  fetchedAt: Date;
  metadata?: {
    title?: string;
    description?: string;
    wordCount?: number;
  };
}

class ExtractorService {
  private readonly defaultOptions: Required<FetchContentOptions> = {
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
      logger.info(`Fetching content from URL: ${url}`);

      const response = await axios.get(url, {
        timeout: opts.timeout,
        headers: {
          'User-Agent': opts.userAgent
        }
      });

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

      // Limit content length for AI processing (token limit)
      return content.substring(0, opts.maxContentLength);
    } catch (error: any) {
      logger.error(`Error fetching content from ${url}:`, error.message);
      throw new Error(`Failed to fetch content: ${error.message}`);
    }
  }

  /**
   * Fetch content with metadata
   */
  async fetchContentWithMetadata(url: string, options: FetchContentOptions = {}): Promise<FetchContentResult> {
    const opts = { ...this.defaultOptions, ...options };

    try {
      logger.info(`Fetching content with metadata from URL: ${url}`);

      const response = await axios.get(url, {
        timeout: opts.timeout,
        headers: {
          'User-Agent': opts.userAgent
        }
      });

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

      return {
        content: truncatedContent,
        url,
        fetchedAt: new Date(),
        metadata: {
          title: title?.trim(),
          description: description?.trim(),
          wordCount: content.split(/\s+/).length
        }
      };
    } catch (error: any) {
      logger.error(`Error fetching content with metadata from ${url}:`, error.message);
      throw new Error(`Failed to fetch content: ${error.message}`);
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
    const opts = { ...this.defaultOptions, ...options };

    // Process in batches to avoid overwhelming servers
    const batchSize = 5;
    for (let i = 0; i < urls.length; i += batchSize) {
      const batch = urls.slice(i, i + batchSize);
      const promises = batch.map(async (url) => {
        try {
          const content = await this.fetchContent(url, opts);
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

const extractorService = new ExtractorService();
export default extractorService;
export { extractorService };
