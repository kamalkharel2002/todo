# === Stage 1: Build Frontend ===
FROM node:18-alpine AS frontend-build
WORKDIR /frontend
COPY Frontend/package*.json ./
RUN npm install --legacy-peer-deps
COPY Frontend/ .
RUN npm run build

# === Stage 2: Build Backend ===
FROM node:18-alpine AS backend
WORKDIR /app

# Copy backend files
COPY Backend/package*.json ./
RUN npm install --legacy-peer-deps

# Copy backend source
COPY Backend/ .

# Copy built frontend into backend's public directory
COPY --from=frontend-build /frontend/build ./public

# Environment variables for runtime
ENV NODE_ENV=production \
    PORT=5001

# Expose backend port
EXPOSE 5001

# Start backend
CMD ["npm", "start"]
