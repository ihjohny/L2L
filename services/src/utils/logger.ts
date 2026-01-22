import winston from 'winston';
import path from 'path';
import { config } from '../config/environment';

const logFormat = winston.format.combine(
  winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
  winston.format.errors({ stack: true }),
  winston.format.splat(),
  winston.format.json()
);

const consoleFormat = winston.format.combine(
  winston.format.colorize(),
  winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
  winston.format.printf(({ timestamp, level, message, ...metadata }) => {
    let msg = `${timestamp} [${level}]: ${message}`;
    if (Object.keys(metadata).length > 0) {
      msg += ` ${JSON.stringify(metadata)}`;
    }
    return msg;
  })
);

const transports: winston.transport[] = [
  new winston.transports.Console({
    format: consoleFormat
  })
];

// Add file transports in production
if (config.env === 'production') {
  transports.push(
    new winston.transports.File({
      filename: path.join(config.log.filePath, 'error.log'),
      level: 'error',
      format: logFormat
    }),
    new winston.transports.File({
      filename: path.join(config.log.filePath, 'combined.log'),
      format: logFormat
    })
  );
}

const logger = winston.createLogger({
  level: config.log.level,
  format: logFormat,
  transports,
  exitOnError: false
});

export default logger;
export { logger };
