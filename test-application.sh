#!/bin/bash

echo "🧪 Testing Todo Web Application"
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
  -d '{"email":"newuser@example.com","password":"password123"}')

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
  -d '{"title":"Test Todo","description":"This is a test todo"}')

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

# Test todo update
echo ""
echo "5. Testing Todo Update..."
UPDATE_RESPONSE=$(curl -s -X PUT http://localhost:5001/api/todos/$TODO_ID \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"is_completed":true}')

if [[ $UPDATE_RESPONSE == *"Todo updated successfully"* ]]; then
    echo "✅ Todo update successful"
else
    echo "❌ Todo update failed: $UPDATE_RESPONSE"
    exit 1
fi

# Test todo deletion
echo ""
echo "6. Testing Todo Deletion..."
DELETE_RESPONSE=$(curl -s -X DELETE http://localhost:5001/api/todos/$TODO_ID \
  -H "Authorization: Bearer $TOKEN")

if [[ $DELETE_RESPONSE == *"Todo deleted successfully"* ]]; then
    echo "✅ Todo deletion successful"
else
    echo "❌ Todo deletion failed: $DELETE_RESPONSE"
    exit 1
fi

# Test frontend accessibility
echo ""
echo "7. Testing Frontend Accessibility..."
FRONTEND_RESPONSE=$(curl -s -I http://localhost:3000 | head -1)

if [[ $FRONTEND_RESPONSE == *"200 OK"* ]]; then
    echo "✅ Frontend is accessible on port 3000"
else
    echo "❌ Frontend accessibility test failed: $FRONTEND_RESPONSE"
    exit 1
fi

echo ""
echo "🎉 All tests passed! The Todo application is working correctly."
echo ""
echo "🌐 Frontend: http://localhost:3000"
echo "🔧 Backend API: http://localhost:5001"
echo "📊 Health Check: http://localhost:5001/api/health"
echo ""
echo "You can now:"
echo "1. Open http://localhost:3000 in your browser"
echo "2. Register a new account or login"
echo "3. Create, edit, and manage your todos!"
