import express, { Application } from 'express';
import helmet from 'helmet';
import compression from 'compression';
import morgan from 'morgan';
import { config } from './config';
import { logger } from './utils/logger';
import { corsMiddleware } from './middleware/cors.middleware';
import { tierBasedRateLimit } from './middleware/rateLimit.middleware';
import { errorHandler, notFoundHandler } from './middleware/error.middleware';
import { Database } from './database';

// Import routes
import userRoutes from './modules/user/user.routes';
import contentRoutes from './modules/content/content.routes';

class App {
  public app: Application;
  private database: Database;

  constructor() {
    this.app = express();
    this.database = Database.getInstance();

    this.initializeMiddlewares();
    this.initializeRoutes();
    this.initializeErrorHandling();
  }

  private initializeMiddlewares(): void {
    // Security headers
    this.app.use(helmet({
      contentSecurityPolicy: {
        directives: {
          defaultSrc: ["'self'"],
          styleSrc: ["'self'", "'unsafe-inline'"],
          scriptSrc: ["'self'"],
          imgSrc: ["'self'", "data:", "https:"],
        },
      },
      crossOriginEmbedderPolicy: false
    }));

    // CORS
    this.app.use(corsMiddleware);

    // Compression
    this.app.use(compression());

    // Body parsing
    this.app.use(express.json({ limit: '10mb' }));
    this.app.use(express.urlencoded({ extended: true, limit: '10mb' }));

    // Logging
    if (config.env !== 'test') {
      this.app.use(morgan('combined', {
        stream: {
          write: (message: string) => logger.info(message.trim())
        }
      }));
    }

    // Rate limiting (will be applied dynamically based on user tier)
    // Apply basic rate limiting to all routes
    this.app.use(tierBasedRateLimit);

    // Health check
    this.app.get('/health', (req, res) => {
      const health = {
        status: 'ok',
        timestamp: new Date().toISOString(),
        uptime: process.uptime(),
        database: this.database.isConnectedToDb() ? 'connected' : 'disconnected',
        environment: config.env
      };
      res.json(health);
    });

    // API info
    this.app.get('/', (req, res) => {
      res.json({
        name: config.appName,
        version: config.apiVersion,
        description: 'L2L (Link to Learn) API',
        documentation: `/api/${config.apiVersion}/docs`
      });
    });
  }

  private initializeRoutes(): void {
    const apiPrefix = `/api/${config.apiVersion}`;

    // Mount routes
    this.app.use(`${apiPrefix}/auth`, userRoutes);
    this.app.use(`${apiPrefix}/content`, contentRoutes);

    // API v1 prefix for backward compatibility
    this.app.use('/api/v1', (req, res, next) => {
      req.url = req.url.replace('/api/v1', `/api/${config.apiVersion}`);
      next();
    });
  }

  private initializeErrorHandling(): void {
    // 404 handler
    this.app.use(notFoundHandler);

    // Global error handler
    this.app.use(errorHandler);
  }

  public async initializeDatabase(): Promise<void> {
    try {
      await this.database.connect();
      logger.info('Database initialized successfully');
    } catch (error) {
      logger.error('Failed to initialize database:', error);
      throw error;
    }
  }

  public async closeDatabase(): Promise<void> {
    try {
      await this.database.disconnect();
      logger.info('Database connection closed');
    } catch (error) {
      logger.error('Error closing database connection:', error);
    }
  }

  public getApp(): Application {
    return this.app;
  }
}

export default App;
