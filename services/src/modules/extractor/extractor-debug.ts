import * as fs from 'fs/promises';
import * as path from 'path';
import { logger } from '../../utils/logger';

export interface DebugOptions {
  enabled: boolean;
  debugDir: string;
}

/**
 * ExtractorDebug - Debug utilities for content extraction
 *
 * Provides file writing capabilities for debugging content extraction
 */
export class ExtractorDebug {
  private options: DebugOptions;

  constructor(options: Partial<DebugOptions> = {}) {
    this.options = {
      enabled: options.enabled ?? false,
      debugDir: options.debugDir ?? './debug-content'
    };
  }

  /**
   * Check if debug mode is enabled
   */
  isEnabled(): boolean {
    return this.options.enabled;
  }

  /**
   * Write raw HTML response to file
   */
  async writeRawHtml(url: string, htmlContent: string): Promise<void> {
    if (!this.options.enabled) return;

    try {
      const filename = this.generateFilename(url, 'raw');
      await this.writeFile(filename, htmlContent);
    } catch (error: any) {
      logger.warn(`Failed to write raw HTML for ${url}:`, error.message);
    }
  }

  /**
   * Write processed content to file
   */
  async writeProcessedContent(
    url: string,
    content: string,
    metadata?: {
      title?: string;
      description?: string;
      wordCount?: number;
      contentLength?: number;
    }
  ): Promise<void> {
    if (!this.options.enabled) return;

    try {
      const filename = this.generateFilename(url, 'processed');
      const debugInfo = this.formatDebugInfo(url, content, metadata);
      await this.writeFile(filename, debugInfo);
    } catch (error: any) {
      logger.warn(`Failed to write processed content for ${url}:`, error.message);
    }
  }

  /**
   * Write error information to file
   */
  async writeError(url: string, error: Error): Promise<void> {
    if (!this.options.enabled) return;

    try {
      const filename = this.generateFilename(url, 'error');
      const errorInfo = `
URL: ${url}
Error at: ${new Date().toISOString()}
Error Type: ${error.name}
Error Message: ${error.message}

Stack Trace:
${error.stack}
`;
      await this.writeFile(filename, errorInfo);
    } catch (err: any) {
      logger.warn(`Failed to write error for ${url}:`, err.message);
    }
  }

  /**
   * Format debug information
   */
  private formatDebugInfo(
    url: string,
    content: string,
    metadata?: {
      title?: string;
      description?: string;
      wordCount?: number;
      contentLength?: number;
    }
  ): string {
    const timestamp = new Date().toISOString();

    let debugInfo = `URL: ${url}\n`;
    debugInfo += `Fetched at: ${timestamp}\n`;

    if (metadata) {
      if (metadata.title) debugInfo += `Title: ${metadata.title}\n`;
      if (metadata.description) debugInfo += `Description: ${metadata.description}\n`;
      if (metadata.wordCount) debugInfo += `Word count: ${metadata.wordCount}\n`;
      if (metadata.contentLength) debugInfo += `Content length: ${metadata.contentLength} characters\n`;
    }

    debugInfo += `\n=== PROCESSED CONTENT ===\n`;
    debugInfo += content;

    return debugInfo;
  }

  /**
   * Generate safe filename from URL
   */
  private generateFilename(url: string, suffix: string): string {
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const urlSlug = url
      .replace(/https?:\/\//, '')
      .replace(/[^a-zA-Z0-9]/g, '-')
      .slice(0, 50);
    return `${urlSlug}-${timestamp}-${suffix}.txt`;
  }

  /**
   * Write content to debug file
   */
  private async writeFile(filename: string, content: string): Promise<void> {
    try {
      // Ensure debug directory exists
      await fs.mkdir(this.options.debugDir, { recursive: true });

      const filepath = path.join(this.options.debugDir, filename);
      await fs.writeFile(filepath, content, 'utf-8');
      logger.info(`Debug file written: ${filepath}`);
    } catch (error: any) {
      logger.warn(`Failed to write debug file ${filename}:`, error.message);
      throw error;
    }
  }

  /**
   * Update debug options
   */
  setOptions(options: Partial<DebugOptions>): void {
    this.options = {
      ...this.options,
      ...options
    };
  }

  /**
   * Get current debug options
   */
  getOptions(): DebugOptions {
    return { ...this.options };
  }
}

/**
 * Default debug instance (disabled by default)
 */
export const extractorDebug = new ExtractorDebug({ enabled: false });

/**
 * Enable debug mode
 */
export function enableDebug(debugDir: string = './debug-content'): void {
  extractorDebug.setOptions({ enabled: true, debugDir });
  logger.info(`Extractor debug mode enabled: ${debugDir}`);
}

/**
 * Disable debug mode
 */
export function disableDebug(): void {
  extractorDebug.setOptions({ enabled: false });
  logger.info('Extractor debug mode disabled');
}
