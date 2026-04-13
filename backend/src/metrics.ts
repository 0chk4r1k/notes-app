import promClient from 'prom-client';

// Default metrics (CPU, memory, etc)
promClient.collectDefaultMetrics();

// Custom metrics
export const httpRequestDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code'],
  buckets: [0.1, 0.5, 1, 2, 5],
});

export const httpRequestTotal = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code'],
});

export const notesCreated = new promClient.Counter({
  name: 'notes_created_total',
  help: 'Total number of notes created',
});

export const notesDeleted = new promClient.Counter({
  name: 'notes_deleted_total',
  help: 'Total number of notes deleted',
});

export const databaseQueryDuration = new promClient.Histogram({
  name: 'database_query_duration_seconds',
  help: 'Duration of database queries',
  labelNames: ['operation', 'model'],
  buckets: [0.01, 0.05, 0.1, 0.5, 1],
});

export const metricsHandler = async (_req: any, res: any) => {
  res.set('Content-Type', promClient.register.contentType);
  const metrics = await promClient.register.metrics();
  res.end(metrics);
};
