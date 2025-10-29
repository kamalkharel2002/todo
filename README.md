# Todo Web Application

A complete full-stack Todo web application built with React frontend and Node.js/Express backend, featuring MySQL database, Redis caching, and JWT authentication.

## Features

- **User Authentication**: Register and login with JWT tokens
- **Todo Management**: Create, read, update, and delete todos
- **Database**: MySQL for persistent storage
- **Caching**: Redis for performance optimization
- **Security**: Password hashing with bcrypt, JWT authentication
- **Modern UI**: Responsive design with Tailwind CSS

## Tech Stack

### Backend
- Node.js with Express.js
- MySQL database
- Redis for caching
- JWT for authentication
- bcrypt for password hashing

### Frontend
- React with JSX
- React Router for navigation
- Axios for API calls
- Tailwind CSS for styling

## Prerequisites

- Node.js (v14 or higher)
- MySQL server
- Redis server
- npm or yarn

## Installation & Setup

### 1. Database Setup

Make sure MySQL is running and create the database:

```sql
CREATE DATABASE todo_app;
```

### 2. Backend Setup

```bash
cd Backend
npm install
npm start
```

The backend will start on `http://localhost:5001`

### 3. Frontend Setup

```bash
cd Frontend/todo-frontend
npm install
npm start
```

The frontend will start on `http://localhost:3000`

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/me` - Get current user info

### Todos
- `GET /api/todos` - Get all todos for authenticated user
- `GET /api/todos/:id` - Get specific todo
- `POST /api/todos` - Create new todo
- `PUT /api/todos/:id` - Update todo
- `DELETE /api/todos/:id` - Delete todo

## Database Schema

### Users Table
```sql
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Todos Table
```sql
CREATE TABLE todos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  is_completed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```
## Features Explained

### Authentication Flow
1. User registers with email and password
2. Password is hashed using bcrypt
3. JWT token is generated and returned
4. Token is stored in localStorage
5. All subsequent requests include the token in Authorization header

### Caching Strategy
- Todo lists are cached in Redis for 1 hour
- Cache is invalidated when todos are created, updated, or deleted
- Cache keys follow pattern: `todos:{userId}:all`

### Security Features
- Password hashing with bcrypt (12 salt rounds)
- JWT tokens with 24-hour expiration
- Protected routes with authentication middleware
- Input validation and sanitization

## Usage

1. Start MySQL and Redis servers
2. Start the backend server (`npm start` in Backend folder)
3. Start the frontend development server (`npm start` in Frontend/todo-frontend folder)
4. Open `http://localhost:3000` in your browser
5. Register a new account or login
6. Start managing your todos!

## Project Structure

```
todo-app/
├── Backend/
│   ├── config.js
│   ├── database.js
│   ├── redis.js
│   ├── server.js
│   ├── middleware/
│   │   └── auth.js
│   └── routes/
│       ├── auth.js
│       └── todos.js
└── Frontend/
    └── todo-frontend/
        ├── src/
        │   ├── components/
        │   ├── context/
        │   ├── services/
        │   └── App.js
        └── package.json
```

## Troubleshooting

### Common Issues

1. **Database Connection Error**: Ensure MySQL is running and credentials are correct
2. **Redis Connection Error**: Ensure Redis server is running
3. **CORS Issues**: Backend includes CORS middleware for cross-origin requests
4. **Authentication Issues**: Check JWT secret and token expiration

### Development Tips

- Use `npm run dev` in Backend for development with nodemon
- Frontend auto-reloads on changes
- Check browser console for API errors
- Use browser dev tools to inspect network requests

## License

MIT License
