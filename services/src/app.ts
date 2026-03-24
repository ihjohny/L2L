import express, { Application } from 'express';
import helmet from 'helmet';
import compression from 'compression';
import morgan from 'morgan';
import { config } from './config';
import { logger } from './utils/logger';
import { corsMiddleware } from './middleware/cors.middleware';
import { defaultRateLimit } from './middleware/rateLimit.middleware';
import { errorHandler, notFoundHandler } from './middleware/error.middleware';
import { Database } from './database';
import { initializeQueues, closeQueues } from './modules/jobs';

// Import routes
import userRoutes from './modules/user/user.routes';
import linkRoutes from './modules/links/link.routes';
import projectRoutes from './modules/project/project.routes';

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

    // Rate limiting
    this.app.use(defaultRateLimit);

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
        endpoints: {
          auth: `/api/${config.apiVersion}/auth`,
          links: `/api/${config.apiVersion}/links`,
          projects: `/api/${config.apiVersion}/projects`
        }
      });
    });
  }

  private initializeRoutes(): void {
    const apiPrefix = `/api/${config.apiVersion}`;

    // Mount MVP routes
    this.app.use(`${apiPrefix}/auth`, userRoutes);
    this.app.use(`${apiPrefix}/links`, linkRoutes);
    this.app.use(`${apiPrefix}/projects`, projectRoutes);

    // API v1 prefix for backward compatibility
    this.app.use('/api/v1', (req, res, next) => {
      req.url = req.url.replace('/api/v1', apiPrefix);
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

  public async initializeQueues(): Promise<void> {
    try {
      await initializeQueues();
      logger.info('Job queues initialized successfully');
    } catch (error) {
      logger.error('Failed to initialize job queues:', error);
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

  public async closeQueues(): Promise<void> {
    await closeQueues();
  }

  public getApp(): Application {
    return this.app;
  }
}

export default App;
