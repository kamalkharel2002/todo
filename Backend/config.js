module.exports = {
  PORT: process.env.PORT || 5001,
  JWT_SECRET: process.env.JWT_SECRET || 'your_jwt_secret_key_here_make_it_strong',
  DB_HOST: process.env.DB_HOST || 'mysql',
  DB_USER: process.env.DB_USER || 'root',
  DB_PASSWORD: process.env.DB_PASSWORD || 'kamal2002',
  DB_NAME: process.env.DB_NAME || 'todo_app',
  REDIS_HOST: process.env.REDIS_HOST || 'redis',
  REDIS_PORT: process.env.REDIS_PORT || 6379
};
