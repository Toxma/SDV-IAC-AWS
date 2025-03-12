// config.js
// Load environment variables from .env file for local development
require('dotenv').config();

// Define configuration with environment variables and fallbacks
const config = {
  APP_DB_HOST: process.env.APP_DB_HOST || "",
  APP_DB_USER: process.env.APP_DB_USER || "",
  APP_DB_PASSWORD: process.env.APP_DB_PASSWORD || "",
  APP_DB_NAME: process.env.APP_DB_NAME || "",
  APP_PORT: process.env.APP_PORT || 80,
};

// Log notice for any config using default values
Object.keys(config).forEach(key => {
  if (!process.env[key]) {
    console.log(`[NOTICE] Value for key '${key}' not found in ENV, using default value. See app/config/config.js`);
  }
});

module.exports = config;
