// /backend/database/db.js
require('dotenv').config();
const mongoose = require('mongoose');

const mongoURI = process.env.MONGODB_URI || process.env.MONGO_URI;
if (!mongoURI) {
  console.error('❌ ERROR: Please set the MONGODB_URI (or MONGO_URI) environment variable.');
  process.exit(1);
}

mongoose
  .connect(mongoURI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log('✅ Connected to MongoDB'))
  .catch(err => {
    console.error('❌ MongoDB connection error:', err);
    process.exit(1);
  });

module.exports = mongoose;
