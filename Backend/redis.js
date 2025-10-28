const redis = require('redis');
const config = require('./config');

// Create Redis client with proper configuration for Docker
const client = redis.createClient({
  url: `redis://${config.REDIS_HOST}:${config.REDIS_PORT}`
});

// Handle Redis connection
client.on('connect', () => {
  console.log('Connected to Redis');
});

client.on('error', (err) => {
  console.error('Redis connection error:', err);
});

// Connect to Redis
client.connect();

// Cache utility functions
const cache = {
  // Get data from cache
  get: async (key) => {
    try {
      const data = await client.get(key);
      return data ? JSON.parse(data) : null;
    } catch (error) {
      console.error('Redis get error:', error);
      return null;
    }
  },

  // Set data in cache with expiration
  set: async (key, data, expirationSeconds = 3600) => {
    try {
      await client.setEx(key, expirationSeconds, JSON.stringify(data));
    } catch (error) {
      console.error('Redis set error:', error);
    }
  },

  // Delete data from cache
  del: async (key) => {
    try {
      await client.del(key);
    } catch (error) {
      console.error('Redis delete error:', error);
    }
  },

  // Delete all cache keys for a user
  deleteUserCache: async (userId) => {
    try {
      const pattern = `todos:${userId}:*`;
      const keys = await client.keys(pattern);
      if (keys.length > 0) {
        await client.del(keys);
      }
    } catch (error) {
      console.error('Redis delete user cache error:', error);
    }
  }
};

module.exports = { client, cache };
