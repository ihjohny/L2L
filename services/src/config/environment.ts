import dotenv from 'dotenv';
import path from 'path';

// Load environment variables
dotenv.config();

interface Config {
  env: string;
  port: number;
  apiVersion: string;
  appName: string;
  appUrl: string;
  database: {
    uri: string;
    name: string;
  };
  redis: {
    url: string;
    password?: string;
  };
  jwt: {
    secret: string;
    expiresIn: string;
    refreshSecret: string;
    refreshTokenExpiresIn: string;
  };
  openai: {
    apiKey: string;
    model: string;
    embeddingModel: string;
  };
  aws: {
    accessKeyId: string;
    secretAccessKey: string;
    region: string;
    s3Bucket: string;
  };
  email: {
    host: string;
    port: number;
    user: string;
    password: string;
    from: string;
  };
  stripe: {
    secretKey: string;
    webhookSecret: string;
  };
  rateLimit: {
    tier: {
      free: number;
      premium: number;
      enterprise: number;
    };
    windowMs: number;
  };
  pagination: {
    defaultPageSize: number;
    maxPageSize: number;
  };
  upload: {
    maxFileSize: number;
    allowedTypes: string[];
  };
  cors: {
    origin: string[];
  };
  log: {
    level: string;
    filePath: string;
  };
}

const config: Config = {
  env: process.env.NODE_ENV || 'development',
  port: parseInt(process.env.PORT || '3000', 10),
  apiVersion: process.env.API_VERSION || 'v1',
  appName: process.env.APP_NAME || 'L2L',
  appUrl: process.env.APP_URL || 'http://localhost:3000',
  database: {
    uri: process.env.MONGODB_URI || 'mongodb://localhost:27017/l2l_dev',
    name: process.env.DATABASE_NAME || 'l2l_dev'
  },
  redis: {
    url: process.env.REDIS_URL || 'redis://localhost:6379',
    password: process.env.REDIS_PASSWORD || undefined
  },
  jwt: {
    secret: process.env.JWT_SECRET || 'your-super-secret-jwt-key',
    expiresIn: process.env.JWT_EXPIRES_IN || '7d',
    refreshSecret: process.env.REFRESH_TOKEN_SECRET || 'your-super-secret-refresh-token-key',
    refreshTokenExpiresIn: process.env.REFRESH_TOKEN_EXPIRES_IN || '30d'
  },
  openai: {
    apiKey: process.env.OPENAI_API_KEY || '',
    model: process.env.OPENAI_MODEL || 'gpt-4',
    embeddingModel: process.env.OPENAI_EMBEDDING_MODEL || 'text-embedding-ada-002'
  },
  aws: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID || '',
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY || '',
    region: process.env.AWS_REGION || 'us-east-1',
    s3Bucket: process.env.S3_BUCKET || 'l2l-assets'
  },
  email: {
    host: process.env.SMTP_HOST || 'smtp.gmail.com',
    port: parseInt(process.env.SMTP_PORT || '587', 10),
    user: process.env.SMTP_USER || '',
    password: process.env.SMTP_PASSWORD || '',
    from: process.env.EMAIL_FROM || 'noreply@l2l.com'
  },
  stripe: {
    secretKey: process.env.STRIPE_SECRET_KEY || '',
    webhookSecret: process.env.STRIPE_WEBHOOK_SECRET || ''
  },
  rateLimit: {
    tier: {
      free: parseInt(process.env.RATE_LIMIT_TIER_FREE || '100', 10),
      premium: parseInt(process.env.RATE_LIMIT_TIER_PREMIUM || '1000', 10),
      enterprise: parseInt(process.env.RATE_LIMIT_TIER_ENTERPRISE || '10000', 10)
    },
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS || '900000', 10)
  },
  pagination: {
    defaultPageSize: parseInt(process.env.DEFAULT_PAGE_SIZE || '20', 10),
    maxPageSize: parseInt(process.env.MAX_PAGE_SIZE || '100', 10)
  },
  upload: {
    maxFileSize: parseInt(process.env.MAX_FILE_SIZE || '5242880', 10),
    allowedTypes: (process.env.ALLOWED_FILE_TYPES || 'image/jpeg,image/png,image/gif,application/pdf').split(',')
  },
  cors: {
    origin: (process.env.CORS_ORIGIN || 'http://localhost:3000').split(',')
  },
  log: {
    level: process.env.LOG_LEVEL || 'debug',
    filePath: process.env.LOG_FILE_PATH || './logs'
  }
};

export { config };
