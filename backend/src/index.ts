import express from "express";
import cors from "cors";
import { randomUUID } from "crypto";

import noteRoutes from "./routes/noteRoutes";
import speechRoutes from "./routes/speechRoutes";
import { metricsHandler, httpRequestDuration, httpRequestTotal } from "./metrics";
import logger from "./logger";

const app = express();

app.use(express.json());
app.use(cors());

/**
 * Correlation ID middleware
 * Добавляет requestId ко всем запросам
 */
app.use((req, res, next) => {
  const requestId = randomUUID();
  (req as any).requestId = requestId;
  res.setHeader("X-Request-Id", requestId);
  next();
});

/**
 * HTTP logging middleware
 */
app.use((req, res, next) => {
  const start = Date.now();
  const requestId = (req as any).requestId;

  logger.info("HTTP request", {
    requestId,
    method: req.method,
    url: req.originalUrl,
    query: req.query,
    ip: req.ip,
  });

  res.on("finish", () => {
    const duration = Date.now() - start;

    logger.info("HTTP response", {
      requestId,
      method: req.method,
      url: req.originalUrl,
      status: res.statusCode,
      duration, // ms
    });
  });

  next();
});

/**
 * Prometheus metrics middleware
 */
app.use((req, res, next) => {
  const start = Date.now();

  res.on("finish", () => {
    const duration = (Date.now() - start) / 1000;

    const route = req.route?.path || req.path;

    httpRequestDuration
      .labels(req.method, route, String(res.statusCode))
      .observe(duration);

    httpRequestTotal
      .labels(req.method, route, String(res.statusCode))
      .inc();
  });

  next();
});

/**
 * Metrics endpoint
 */
app.get("/metrics", metricsHandler);

/**
 * Routes
 */
app.use("/api/notes", noteRoutes);
app.use("/api/speech-to-text", speechRoutes);

/**
 * 404 handler
 */
app.use((req, res) => {
  logger.warn("Route not found", {
    method: req.method,
    url: req.originalUrl,
  });

  res.status(404).json({ error: "Not Found" });
});

/**
 * Error handler (должен быть последним)
 */
app.use((err: any, req: any, res: any, next: any) => {
  logger.error("Unhandled error", {
    requestId: req.requestId,
    message: err.message,
    stack: err.stack,
    method: req.method,
    url: req.originalUrl,
  });

  res.status(500).json({ error: "Internal Server Error" });
});

/**
 * Start server
 */
const PORT = 5000;

app.listen(PORT, () => {
  logger.info(`Server running on http://localhost:${PORT}`, {
    port: PORT,
  });

  console.log(`Server running on http://localhost:${PORT}`);
});
