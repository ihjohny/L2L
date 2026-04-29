import { config } from '../../config';
import cheerioExtractorService from './cheerio-extractor.service';
import aiExtractorService from './ai-extractor.service';

export interface FetchContentOptions {
  timeout?: number;
  maxContentLength?: number;
  userAgent?: string;
  useAiExtractor?: boolean;
}

export interface FetchContentResult {
  url: string;
  fetchedAt: Date;
  title: string | null;
  description: string | null;
  mainContent: string;
  contentLength: number;
}

class ExtractorFacade {

  /**
   * Fetch content with metadata (title, description, content length, etc.)
   */
  async fetchContentWithMetadata(url: string, options: FetchContentOptions = {}): Promise<FetchContentResult> {
    const useAi = options.useAiExtractor !== undefined ? options.useAiExtractor : config.extractor.useAiExtractor;

    if (useAi) {
      return await aiExtractorService.fetchContentWithMetadata(url, options);
    } else {
      return cheerioExtractorService.fetchContentWithMetadata(url, options);
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

}

const extractorService = new ExtractorFacade();
export default extractorService;
export { extractorService };
