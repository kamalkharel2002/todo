#!/bin/bash

echo "🚀 Setting up Todo Web Application"
echo "=================================="
echo ""

# Check if MySQL is running
echo "📊 Checking MySQL connection..."
mysql -u root -p'kamal2002' -e "SELECT 1;" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ MySQL is running"
    # Create database
    mysql -u root -p'kamal2002' -e "CREATE DATABASE IF NOT EXISTS todo_app;" 2>/dev/null
    echo "✅ Database 'todo_app' created/verified"
else
    echo "❌ MySQL is not running or credentials are incorrect"
    echo "Please start MySQL and ensure credentials are correct"
    exit 1
fi

# Check if Redis is running
echo ""
echo "🔴 Checking Redis connection..."
redis-cli ping 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ Redis is running"
else
    echo "❌ Redis is not running"
    echo "Please start Redis server"
    exit 1
fi

# Install backend dependencies
echo ""
echo "📦 Installing backend dependencies..."
cd Backend
npm install
if [ $? -eq 0 ]; then
    echo "✅ Backend dependencies installed"
else
    echo "❌ Failed to install backend dependencies"
    exit 1
fi

# Install frontend dependencies
echo ""
echo "📦 Installing frontend dependencies..."
cd ../Frontend/todo-frontend
npm install
if [ $? -eq 0 ]; then
    echo "✅ Frontend dependencies installed"
else
    echo "❌ Failed to install frontend dependencies"
    exit 1
fi

cd ../..

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "To start the application:"
echo "1. Backend:  ./start-backend.sh"
echo "2. Frontend: ./start-frontend.sh"
echo ""
echo "Or run both in separate terminals:"
echo "Terminal 1: cd Backend && npm start"
echo "Terminal 2: cd Frontend/todo-frontend && npm start"
echo ""
echo "🌐 Frontend will be available at: http://localhost:3000"
echo "🔧 Backend API will be available at: http://localhost:5000"
echo "📊 Health check: http://localhost:5000/api/health"
