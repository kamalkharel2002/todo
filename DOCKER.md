x
x
# 🐳 Docker Setup for Todo Application

This document provides complete Dockerization for the Todo application with development and production configurations.

## 📁 Project Structure

```
todo-app/
├── Backend/
│   ├── Dockerfile.dev          # Development Dockerfile
│   ├── Dockerfile             # Production Dockerfile
│   ├── package.prod.json      # Production dependencies only
│   └── .dockerignore          # Docker ignore file
├── Frontend/todo-frontend/
│   ├── Dockerfile.dev         # Development Dockerfile
│   └── .dockerignore          # Docker ignore file
├── docker-compose.yml         # Development compose
├── docker-compose.prod.yml    # Production compose
└── docker-setup.sh           # Setup script
```

## 🚀 Quick Start

### Development Environment

1. **Build and start all services:**
   ```bash
   ./docker-setup.sh start
   ```

2. **Check status:**
   ```bash
   ./docker-setup.sh status
   ```

3. **View logs:**
   ```bash
   ./docker-setup.sh logs
   ```

4. **Stop services:**
   ```bash
   ./docker-setup.sh stop
   ```

### Manual Docker Commands

#### Build Services
```bash
docker-compose build
```

#### Start Services (Detached Mode)
```bash
docker-compose up -d
```

#### Check Container Status
```bash
docker-compose ps
```

#### View Backend Logs
```bash
docker-compose logs backend
```

#### Stop All Services
```bash
docker-compose down
```

## 🏗️ Architecture

### Services

1. **MySQL Database** (`mysql`)
   - Image: `mysql:8.0`
   - Port: `3306`
   - Database: `todo_app`
   - Persistent volume: `mysql_data`

2. **Redis Cache** (`redis`)
   - Image: `redis:7-alpine`
   - Port: `6379`
   - Persistent volume: `redis_data`

3. **Backend Service** (`backend`)
   - Custom build from `Dockerfile.dev`
   - Port: `5001`
   - Live code reloading with bind mount
   - Depends on MySQL and Redis

4. **Frontend Service** (`frontend`)
   - Custom build from `Dockerfile.dev`
   - Port: `3000`
   - Live code reloading with bind mount
   - Depends on Backend

### Networks

- **todo-network**: Bridge network connecting all services

## 🔧 Development Features

### Live Code Reloading
- Backend: Bind mount `./Backend` → `/app`
- Frontend: Bind mount `./Frontend/todo-frontend` → `/app`
- Node modules are excluded from bind mounts for performance

### Environment Variables
- Database connection through Docker network
- Redis connection through Docker network
- JWT secret configuration
- Development/Production mode switching

## 🏭 Production Deployment

### Production Compose
```bash
docker-compose -f docker-compose.prod.yml up -d
```

### Production Features
- Optimized Dockerfile with production dependencies only
- Non-root user for security
- Production environment variables
- Persistent data volumes

## 📊 Monitoring

### Container Status
```bash
docker-compose ps
```

### Service Logs
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs backend
docker-compose logs frontend
docker-compose logs mysql
docker-compose logs redis
```

### Resource Usage
```bash
docker stats
```

## 🔧 Troubleshooting

### Common Issues

1. **Port Conflicts**
   ```bash
   # Check what's using the ports
   lsof -i :3000
   lsof -i :5001
   lsof -i :3306
   lsof -i :6379
   ```

2. **Container Won't Start**
   ```bash
   # Check logs
   docker-compose logs [service-name]
   
   # Rebuild
   docker-compose build --no-cache
   ```

3. **Database Connection Issues**
   ```bash
   # Check MySQL container
   docker-compose exec mysql mysql -u root -p
   ```

4. **Clean Restart**
   ```bash
   docker-compose down -v  # Remove volumes
   docker-compose build --no-cache
   docker-compose up -d
   ```

## 🌐 Access Points

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5001
- **Health Check**: http://localhost:5001/api/health
- **MySQL**: localhost:3306
- **Redis**: localhost:6379

### Frontend
- `REACT_APP_API_URL`: http://localhost:5001

## 🗂️ Data Persistence

### Volumes
- `mysql_data`: MySQL database files
- `redis_data`: Redis cache data

### Backup
```bash
# Backup MySQL
docker-compose exec mysql mysqldump -u root -p todo_app > backup.sql

# Restore MySQL
docker-compose exec -T mysql mysql -u root -p todo_app < backup.sql
```

## 🔒 Security Notes

- Production images use non-root users
- Environment variables for sensitive data
- Network isolation between services
- Persistent volumes for data integrity

## 📈 Performance

- Multi-stage builds for smaller images
- Layer caching optimization
- Bind mounts for development speed
- Production optimizations for runtime
