import OpenAI from 'openai';
import { logger } from '../../utils/logger';
import { config } from '../../config';
import {
  SummaryContent,
  FlashcardsContent,
  CourseContent,
  QuizContent
} from '../../database/models/AiOutput.model';
import * as cheerio from 'cheerio';
import axios from 'axios';
import mongoose from 'mongoose';

class AiService {
  private openai: OpenAI | null = null;

  constructor() {
    if (config.openai.apiKey) {
      this.openai = new OpenAI({
        apiKey: config.openai.apiKey
      });
    } else {
      logger.warn('OpenAI API key not configured. AI features will use mock data.');
    }
  }

  /**
   * Fetch and extract content from URL
   */
  async fetchContent(url: string): Promise<string> {
    try {
      logger.info(`Fetching content from URL: ${url}`);

      const response = await axios.get(url, {
        timeout: 10000,
        headers: {
          'User-Agent': 'Mozilla/5.0 (compatible; L2L/1.0)'
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
      const mainSelectors = ['article', 'main', '.content', '.post', '.article', '#content'];

      for (const selector of mainSelectors) {
        const element = $(selector).first();
        if (element.length > 0) {
          content = element.text();
          break;
        }
      }

      // Fallback to body
      if (!content) {
        content = $('body').text();
      }

      // Clean up whitespace
      content = content.replace(/\s+/g, ' ').trim();

      // Limit content length for AI processing (token limit)
      const maxContentLength = 8000;
      return content.substring(0, maxContentLength);
    } catch (error: any) {
      logger.error(`Error fetching content from ${url}:`, error.message);
      throw new Error(`Failed to fetch content: ${error.message}`);
    }
  }

  /**
   * Process a link: Generate summary and flashcards
   */
  async processLink(url: string): Promise<{ summary: SummaryContent; flashcards: FlashcardsContent }> {
    try {
      logger.info(`Processing link with AI: ${url}`);

      // Fetch content
      const content = await this.fetchContent(url);

      if (!content || content.length < 50) {
        throw new Error('Content too short or empty');
      }

      // Generate summary and flashcards in parallel
      const [summary, flashcards] = await Promise.all([
        this.generateSummary(content),
        this.generateFlashcards(content)
      ]);

      return { summary, flashcards };
    } catch (error: any) {
      logger.error('Error in processLink:', error);
      throw error;
    }
  }

  /**
   * Generate summary from content
   */
  async generateSummary(content: string): Promise<SummaryContent> {
    try {
      if (!this.openai) {
        return this.mockSummary(content);
      }

      const response = await this.openai.chat.completions.create({
        model: 'gpt-4o',
        messages: [
          {
            role: 'system',
            content: 'You are an expert at summarizing educational content. Output JSON only.'
          },
          {
            role: 'user',
            content: `Summarize the following content in JSON format:
{
  "keyPoints": string[],  // 3-5 main points
  "mainArgument": string,  // Central thesis in 1-2 sentences
  "takeaways": string[]  // 3-5 practical takeaways
}

Content: ${content.substring(0, 4000)}`
          }
        ],
        temperature: 0.7,
        max_tokens: 500
      });

      const contentText = response.choices[0].message.content;
      if (!contentText) {
        throw new Error('Empty response from OpenAI');
      }

      const parsed = JSON.parse(contentText) as SummaryContent;

      // Validate structure
      if (!parsed.keyPoints || !parsed.mainArgument || !parsed.takeaways) {
        throw new Error('Invalid summary structure');
      }

      return parsed;
    } catch (error: any) {
      logger.error('Error generating summary:', error);
      throw error;
    }
  }

  /**
   * Generate flashcards from content
   */
  async generateFlashcards(content: string): Promise<FlashcardsContent> {
    try {
      if (!this.openai) {
        return this.mockFlashcards(content);
      }

      const response = await this.openai.chat.completions.create({
        model: 'gpt-4o',
        messages: [
          {
            role: 'system',
            content: 'You are an expert at creating educational flashcards. Output JSON only.'
          },
          {
            role: 'user',
            content: `Generate 5-10 flashcards in JSON format:
{
  "flashcards": [
    {
      "question": string,
      "answer": string,
      "difficulty": "easy" | "medium" | "hard"
    }
  ]
}

Content: ${content.substring(0, 4000)}`
          }
        ],
        temperature: 0.7,
        max_tokens: 800
      });

      const contentText = response.choices[0].message.content;
      if (!contentText) {
        throw new Error('Empty response from OpenAI');
      }

      const parsed = JSON.parse(contentText) as FlashcardsContent;

      // Validate structure
      if (!parsed.flashcards || parsed.flashcards.length < 3) {
        throw new Error('Not enough flashcards generated');
      }

      return parsed;
    } catch (error: any) {
      logger.error('Error generating flashcards:', error);
      throw error;
    }
  }

  /**
   * Generate course from multiple summaries
   */
  async generateCourse(summaries: SummaryContent[]): Promise<CourseContent> {
    try {
      if (!this.openai) {
        return this.mockCourse(summaries);
      }

      const summariesText = summaries
        .map(s => `- Main: ${s.mainArgument}\n  Points: ${s.keyPoints.join(', ')}`)
        .join('\n');

      const response = await this.openai.chat.completions.create({
        model: 'gpt-4o',
        messages: [
          {
            role: 'system',
            content: 'You are an expert curriculum designer. Create structured courses from multiple summaries. Output JSON only.'
          },
          {
            role: 'user',
            content: `Synthesize a course from these summaries in JSON format:
{
  "title": string,
  "description": string,
  "lessons": [
    {
      "title": string,
      "content": string,
      "order": number
    }
  ]
}

Summaries:
${summariesText}`
          }
        ],
        temperature: 0.7,
        max_tokens: 1500
      });

      const contentText = response.choices[0].message.content;
      if (!contentText) {
        throw new Error('Empty response from OpenAI');
      }

      const parsed = JSON.parse(contentText) as CourseContent;

      // Validate structure
      if (!parsed.title || !parsed.lessons || parsed.lessons.length < 2) {
        throw new Error('Invalid course structure');
      }

      return parsed;
    } catch (error: any) {
      logger.error('Error generating course:', error);
      throw error;
    }
  }

  /**
   * Generate quiz from course content
   */
  async generateQuiz(courseContent: CourseContent, courseId?: mongoose.Types.ObjectId): Promise<QuizContent> {
    try {
      if (!this.openai) {
        return this.mockQuiz(courseContent, courseId);
      }

      const lessonsText = courseContent.lessons
        .map(l => `${l.title}: ${l.content.substring(0, 200)}`)
        .join('\n');

      const response = await this.openai.chat.completions.create({
        model: 'gpt-4o',
        messages: [
          {
            role: 'system',
            content: 'You are an expert at creating educational quizzes. Output JSON only.'
          },
          {
            role: 'user',
            content: `Generate a quiz (5-15 questions) in JSON format:
{
  "questions": [
    {
      "question": string,
      "options": string[],
      "correct": number,
      "explanation": string
    }
  ]
}

Course content:
${lessonsText.substring(0, 3000)}`
          }
        ],
        temperature: 0.7,
        max_tokens: 1000
      });

      const contentText = response.choices[0].message.content;
      if (!contentText) {
        throw new Error('Empty response from OpenAI');
      }

      const parsed = JSON.parse(contentText) as QuizContent;

      // Validate structure
      if (!parsed.questions || parsed.questions.length < 3) {
        throw new Error('Not enough quiz questions generated');
      }

      // Add courseId to the content
      if (courseId) {
        parsed.courseId = courseId;
      }

      return parsed;
    } catch (error: any) {
      logger.error('Error generating quiz:', error);
      throw error;
    }
  }

  // Mock implementations for when OpenAI is not configured
  private mockSummary(content: string): SummaryContent {
    const words = content.split(' ').slice(0, 100);
    return {
      keyPoints: [
        words.slice(0, 20).join(' ') + '...',
        words.slice(20, 40).join(' ') + '...',
        words.slice(40, 60).join(' ') + '...'
      ],
      mainArgument: 'This content provides educational information on the topic.',
      takeaways: [
        'Key takeaway from the content',
        'Important concept to remember',
        'Practical application of the knowledge'
      ]
    };
  }

  private mockFlashcards(content: string): FlashcardsContent {
    return {
      flashcards: Array.from({ length: 5 }).map((_, i) => ({
        question: `Question ${i + 1} about the content?`,
        answer: `Answer ${i + 1} explaining the concept from the content.`,
        difficulty: i < 2 ? 'easy' : i < 4 ? 'medium' : 'hard' as const
      }))
    };
  }

  private mockCourse(summaries: SummaryContent[]): CourseContent {
    return {
      title: 'Course Generated from Your Links',
      description: 'A comprehensive course synthesized from your saved resources.',
      lessons: summaries.map((summary, index) => ({
        title: `Lesson ${index + 1}: ${summary.mainArgument.substring(0, 50)}...`,
        content: `${summary.mainArgument}\n\n${summary.keyPoints.join('\n')}`,
        order: index + 1
      }))
    };
  }

  private mockQuiz(courseContent: CourseContent, courseId?: mongoose.Types.ObjectId): QuizContent {
    return {
      courseId,
      questions: Array.from({ length: 5 }).map((_, i) => ({
        question: `Question ${i + 1} about the course content?`,
        options: [
          'Correct answer with explanation',
          'Plausible but incorrect option',
          'Another incorrect option',
          'Final incorrect option'
        ],
        correct: 0,
        explanation: `Explanation for why option 0 is correct.`
      }))
    };
  }
}

const aiService = new AiService();
export default aiService;
export { aiService };
