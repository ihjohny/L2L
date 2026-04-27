import { GoogleGenAI } from '@google/genai';

import { logger } from '../../utils/logger';
import { config } from '../../config';
import { extractorDebug } from './extractor-debug';
import { FetchContentOptions, FetchContentResult } from './cheerio-extractor.service';

class AiExtractorService {
  private ai: GoogleGenAI | null = null;
  private readonly defaultOptions: Required<Omit<FetchContentOptions, 'useAiExtractor'>> = {
    timeout: 15000, // slightly higher timeout for AI
    maxContentLength: 50000, // larger token window max
    userAgent: 'Mozilla/5.0 (compatible; L2L-AI/1.0)'
  };

  constructor() {
    if (config.gemini.apiKey) {
      this.ai = new GoogleGenAI({ apiKey: config.gemini.apiKey });
    } else {
      logger.warn('Google Gemini API key not configured properly. AI extraction will use mock data.');
    }
  }

  /**
   * Fetch and extract content from URL using Gemini AI
   */
  async fetchContent(url: string, options: FetchContentOptions = {}): Promise<string> {
    const result = await this.fetchContentWithMetadata(url, options);
    return result.content;
  }

  /**
   * Fetch content with metadata using Gemini AI
   */
  async fetchContentWithMetadata(url: string, options: FetchContentOptions = {}): Promise<FetchContentResult> {
    const opts = { ...this.defaultOptions, ...options };

    if (!this.ai) {
      logger.info(`Using mock AI extraction for URL: ${url}`);
      return this.getMockExtraction(url, opts);
    }

    const prevDebugState = extractorDebug.getOptions().enabled;
    extractorDebug.setOptions({ enabled: true });

    try {
      logger.info(`Fetching and extracting content with AI (Gemini) from URL: ${url}`);

      const prompt = `You are an expert web scraper and data extraction AI.
Visit the following URL and extract the main educational, informative, or article content found on that page.
Do your best to retrieve the actual text from the webpage.
Exclude any navigation headers, footers, advertisements, sidebars, or unrelated elements.

URL: ${url}

Output strictly valid JSON with the following structure:
{
  "title": "The parsed main title of the page",
  "description": "A brief summary or the meta description of the page",
  "content": "The cleaned, completely extracted text content of the primary article or body without HTML tags"
}`;

      await extractorDebug.writeAiPrompt(url, prompt);

      const aiResponse = await this.ai.models.generateContent({
        model: config.gemini.model || 'gemini-2.5-flash',
        contents: prompt,
        config: {
          responseMimeType: 'application/json',
          temperature: 0.2
        }
      });

      const responseText = aiResponse.text;

      if (!responseText) {
        throw new Error('Gemini response body was empty or undefined.');
      }

      await extractorDebug.writeAiResponse(url, responseText);

      const extractedData = JSON.parse(responseText);

      const content = extractedData.content || '';
      const title = extractedData.title || '';
      const description = extractedData.description || '';

      const truncatedContent = content.substring(0, opts.maxContentLength);

      const result: FetchContentResult = {
        content: truncatedContent,
        url,
        fetchedAt: new Date(),
        metadata: {
          title: title.trim(),
          description: description.trim(),
          wordCount: content.split(/\s+/).length,
          contentLength: truncatedContent.length
        }
      };

      await extractorDebug.writeProcessedContent(url, result.content, result.metadata);

      return result;
    } catch (error: any) {
      await extractorDebug.writeError(url, error);
      logger.error(`Error fetching/extracting content from ${url} via AI:`, error.message);
      throw new Error(`Failed to extract content via AI: ${error.message}`);
    } finally {
      extractorDebug.setOptions({ enabled: prevDebugState });
    }
  }

  /**
   * Mock implementation for when Gemini is not configured
   */
  private getMockExtraction(url: string, opts: Required<Omit<FetchContentOptions, 'useAiExtractor'>>): FetchContentResult {
    const content = `This is a mocked extracted content block for URL: ${url}. 
Because the Gemini API key was not properly configured in the environment, the AI Service completely simulated reading the linked page.
In a production environment, this would contain the actual educational or informative body parsed from the target webpage.`;

    const truncatedContent = content.substring(0, opts.maxContentLength);

    return {
      content: truncatedContent,
      url,
      fetchedAt: new Date(),
      metadata: {
        title: 'Mocked AI Extractor Title',
        description: 'Mocked AI description for testing extraction pipelines',
        wordCount: truncatedContent.split(/\s+/).length,
        contentLength: truncatedContent.length
      }
    };
  }
}

const aiExtractorService = new AiExtractorService();
export default aiExtractorService;
export { aiExtractorService };
