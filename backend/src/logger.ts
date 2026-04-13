import winston from 'winston';
const { ElasticsearchTransport } = require('winston-elasticsearch');

const esTransport = new ElasticsearchTransport({
  level: 'info',
  clientOpts: {
    node: 'http://elasticsearch:9200',
    requestTimeout: 10000,
  },
  index: 'logs-backend',
  transformer: (logData: any) => ({
    '@timestamp': new Date().toISOString(),
    message: logData.message,
    severity: logData.level,
    fields: logData.meta || {},
  }),
});

esTransport.on('error', (err: any) => {
  console.error('Elasticsearch transport error:', err);
});

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  defaultMeta: { service: 'notes-backend' },
  transports: [
    new winston.transports.Console(),
    esTransport,
  ],
});

export default logger;
