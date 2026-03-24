import http from 'http';
import { config } from './config';
import { logger } from './utils/logger';
import App from './app';

class Server {
  private app: App;
  private server: http.Server;
  private port: number;

  constructor() {
    this.app = new App();
    this.port = config.port;
    this.server = http.createServer(this.app.getApp());
  }

  public async start(): Promise<void> {
    try {
      // Initialize database
      await this.app.initializeDatabase();

      // Initialize job queues
      await this.app.initializeQueues();

      // Start server
      this.server.listen(this.port, () => {
        logger.info(`
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   🚀 L2L (Link to Learn) API Server                      ║
║                                                           ║
║   ✓ Environment: ${config.env.padEnd(40)}║
║   ✓ Port: ${this.port.toString().padEnd(45)}║
║   ✓ API Version: ${config.apiVersion.padEnd(39)}║
║   ✓ Database: Connected                                  ║
║   ✓ Job Queues: Initialized                              ║
║                                                           ║
║   📍 Server running at: http://localhost:${this.port}        ║
║   📚 API Documentation: http://localhost:${this.port}/api/${config.apiVersion}/docs  ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
        `);
      });

      // Handle server errors
      this.server.on('error', (error: NodeJS.ErrnoException) => {
        if (error.syscall !== 'listen') {
          throw error;
        }

        const bind = typeof this.port === 'string'
          ? 'Pipe ' + this.port
          : 'Port ' + this.port;

        switch (error.code) {
          case 'EACCES':
            logger.error(`${bind} requires elevated privileges`);
            process.exit(1);
            break;
          case 'EADDRINUSE':
            logger.error(`${bind} is already in use`);
            process.exit(1);
            break;
          default:
            throw error;
        }
      });

      // Graceful shutdown
      this.setupGracefulShutdown();

    } catch (error) {
      logger.error('Failed to start server:', error);
      process.exit(1);
    }
  }

  public async stop(): Promise<void> {
    logger.info('Shutting down server...');

    this.server.close(async () => {
      logger.info('HTTP server closed');

      try {
        await this.app.closeQueues();
        logger.info('Job queues closed');

        await this.app.closeDatabase();
        logger.info('Database connection closed');

        process.exit(0);
      } catch (error) {
        logger.error('Error during shutdown:', error);
        process.exit(1);
      }
    });

    // Force shutdown after 10 seconds
    setTimeout(() => {
      logger.error('Forced shutdown after timeout');
      process.exit(1);
    }, 10000);
  }

  private setupGracefulShutdown(): void {
    // Handle termination signals
    process.on('SIGTERM', () => {
      logger.info('SIGTERM signal received');
      this.stop();
    });

    process.on('SIGINT', () => {
      logger.info('SIGINT signal received');
      this.stop();
    });

    // Handle uncaught exceptions
    process.on('uncaughtException', (error: Error) => {
      logger.error('Uncaught Exception:', error);
      this.stop();
    });

    // Handle unhandled promise rejections
    process.on('unhandledRejection', (reason: any) => {
      logger.error('Unhandled Rejection at:', reason);
      this.stop();
    });
  }
}

// Start server if this file is run directly
if (require.main === module) {
  const server = new Server();
  server.start();
}

export default Server;
