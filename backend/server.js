require('dotenv').config();

const path = require('path');
const express = require('express');
const cors = require('cors');

// Load the database connection (must export/connect in db.js)
require('../database/db');

const authRoutes           = require('./routes/auth');
const userRoutes           = require('./routes/user');
const sentimentRoutes      = require('./routes/sentiment');
const predictionsRoutes    = require('./routes/predictions');
const chartRoutes          = require('./routes/chart');
const recommendationsRoutes= require('./routes/recommendations');
const tickersRoutes        = require('./routes/tickers');

const app = express();
const PORT = process.env.PORT || 3000;

// --- Middleware ---
app.use(cors());
app.use(express.json());                        // built-in JSON parser
app.use(express.static(path.join(__dirname, '../frontend')));

// --- Health check ---
app.get('/health', (_req, res) => res.sendStatus(200));

// --- API routes ---
app.use('/api/auth',           authRoutes);
app.use('/api/user',           userRoutes);
app.use('/api/sentiment',      sentimentRoutes);
app.use('/api/predictions',    predictionsRoutes);
app.use('/api/chart',          chartRoutes);
app.use('/api/recommendations',recommendationsRoutes);
app.use('/api/tickers',        tickersRoutes);

// --- Frontend routes ---
app.get('/', (_req, res) => {
  res.sendFile(path.join(__dirname, '../frontend/landing-page/landingPage.html'));
});
app.get('*', (_req, res) => {
  res.sendFile(path.join(__dirname, '../frontend/landing-page/landingPage.html'));
});

// --- Global error handler ---
app.use((err, _req, res, _next) => {
  console.error(err);
  res.status(500).json({ error: 'Internal server error' });
});

// --- Start ---
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
