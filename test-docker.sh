#!/bin/bash

echo "🐳 Docker Todo Application Test"
echo "=============================="
echo ""

# Test backend health
echo "1. Testing Backend Health..."
HEALTH_RESPONSE=$(curl -s http://localhost:5001/api/health)
if [[ $HEALTH_RESPONSE == *"Todo App Backend is running"* ]]; then
    echo "✅ Backend is running on port 5001"
else
    echo "❌ Backend health check failed"
    exit 1
fi

# Test user login (since user might already exist)
echo ""
echo "2. Testing User Authentication..."
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:5001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"dockeruser@example.com","password":"password123"}')

if [[ $LOGIN_RESPONSE == *"token"* ]]; then
    echo "✅ User login successful"
    # Extract token for further tests
    TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
    echo "   Token: ${TOKEN:0:20}..."
else
    echo "❌ User login failed: $LOGIN_RESPONSE"
    exit 1
fi

# Test todo creation
echo ""
echo "3. Testing Todo Creation..."
TODO_RESPONSE=$(curl -s -X POST http://localhost:5001/api/todos \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Docker Test Todo","description":"This is a test todo in Docker"}')

if [[ $TODO_RESPONSE == *"Todo created successfully"* ]]; then
    echo "✅ Todo creation successful"
    # Extract todo ID
    TODO_ID=$(echo $TODO_RESPONSE | grep -o '"id":[0-9]*' | cut -d':' -f2)
    echo "   Todo ID: $TODO_ID"
else
    echo "❌ Todo creation failed: $TODO_RESPONSE"
    exit 1
fi

# Test todo retrieval
echo ""
echo "4. Testing Todo Retrieval..."
TODOS_RESPONSE=$(curl -s -X GET http://localhost:5001/api/todos \
  -H "Authorization: Bearer $TOKEN")

if [[ $TODOS_RESPONSE == *"todos"* ]]; then
    echo "✅ Todo retrieval successful"
    echo "   Response: $TODOS_RESPONSE"
else
    echo "❌ Todo retrieval failed: $TODOS_RESPONSE"
    exit 1
fi

# Test Redis caching
echo ""
echo "5. Testing Redis Caching..."
REDIS_KEYS=$(docker exec todo-redis redis-cli keys "*")
if [[ $REDIS_KEYS == *"todos:"* ]]; then
    echo "✅ Redis caching is working"
    echo "   Cache keys: $REDIS_KEYS"
else
    echo "❌ Redis caching test failed"
    exit 1
fi

# Test frontend accessibility
echo ""
echo "6. Testing Frontend Accessibility..."
FRONTEND_RESPONSE=$(curl -s -I http://localhost:3000 | head -1)

if [[ $FRONTEND_RESPONSE == *"200 OK"* ]]; then
    echo "✅ Frontend is accessible on port 3000"
else
    echo "❌ Frontend accessibility test failed: $FRONTEND_RESPONSE"
    exit 1
fi

# Test container status
echo ""
echo "7. Testing Container Status..."
CONTAINER_COUNT=$(docker ps --filter "name=todo-" --format "table {{.Names}}" | wc -l)
if [ $CONTAINER_COUNT -ge 4 ]; then
    echo "✅ All containers are running ($CONTAINER_COUNT containers)"
    docker ps --filter "name=todo-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
else
    echo "❌ Not all containers are running"
    exit 1
fi

echo ""
echo "🎉 All Docker tests passed! The Todo application is working correctly."
echo ""
echo "🌐 Frontend: http://localhost:3000"
echo "🔧 Backend API: http://localhost:5001"
echo "📊 Health Check: http://localhost:5001/api/health"
echo "🗄️ MySQL: localhost:3306"
echo "🔴 Redis: localhost:6379"
echo ""
echo "You can now:"
echo "1. Open http://localhost:3000 in your browser"
echo "2. Register a new account or login"
echo "3. Create, edit, and manage your todos!"
echo ""
echo "🐳 Docker Commands:"
echo "  View logs: docker-compose logs [service]"
echo "  Stop: docker-compose down"
echo "  Restart: docker-compose restart [service]"
echo "  Status: docker-compose ps"
