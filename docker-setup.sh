#!/bin/bash

echo "🐳 Docker Setup for Todo Application"
echo "===================================="
echo ""

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        echo "❌ Docker is not running. Please start Docker Desktop and try again."
        exit 1
    fi
    echo "✅ Docker is running"
}

# Function to build services
build_services() {
    echo "🔨 Building Docker services..."
    docker-compose build
    if [ $? -eq 0 ]; then
        echo "✅ Services built successfully"
    else
        echo "❌ Failed to build services"
        exit 1
    fi
}

# Function to start services
start_services() {
    echo "🚀 Starting services in detached mode..."
    docker-compose up -d
    if [ $? -eq 0 ]; then
        echo "✅ Services started successfully"
    else
        echo "❌ Failed to start services"
        exit 1
    fi
}

# Function to check container status
check_status() {
    echo "📊 Container Status:"
    docker-compose ps
}

# Function to show logs
show_logs() {
    echo "📋 Backend logs:"
    docker-compose logs backend
}

# Function to stop services
stop_services() {
    echo "🛑 Stopping services..."
    docker-compose down
    echo "✅ Services stopped"
}

# Main execution
case "$1" in
    "build")
        check_docker
        build_services
        ;;
    "start")
        check_docker
        start_services
        check_status
        ;;
    "logs")
        show_logs
        ;;
    "status")
        check_status
        ;;
    "stop")
        stop_services
        ;;
    "restart")
        stop_services
        sleep 2
        start_services
        check_status
        ;;
    *)
        echo "Usage: $0 {build|start|logs|status|stop|restart}"
        echo ""
        echo "Commands:"
        echo "  build   - Build Docker images"
        echo "  start   - Start all services"
        echo "  logs    - Show backend logs"
        echo "  status  - Check container status"
        echo "  stop    - Stop all services"
        echo "  restart - Restart all services"
        exit 1
        ;;
esac
