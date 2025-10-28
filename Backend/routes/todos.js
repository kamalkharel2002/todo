const express = require('express');
const { body, validationResult } = require('express-validator');
const { pool } = require('../database');
const { authenticateToken } = require('../middleware/auth');
const { cache } = require('../redis');

const router = express.Router();

// Get all todos for authenticated user
router.get('/', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;
    const cacheKey = `todos:${userId}:all`;

    // Try to get from cache first
    let todos = await cache.get(cacheKey);
    
    if (!todos) {
      // Cache miss - get from database
      const [rows] = await pool.execute(
        'SELECT id, title, description, is_completed, created_at, updated_at FROM todos WHERE user_id = ? ORDER BY created_at DESC',
        [userId]
      );
      
      todos = rows;
      
      // Store in cache for 1 hour
      await cache.set(cacheKey, todos, 3600);
    }

    res.json({ todos });
  } catch (error) {
    console.error('Get todos error:', error);
    res.status(500).json({ message: 'Server error while fetching todos' });
  }
});

// Get single todo by ID
router.get('/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.userId;

    const [rows] = await pool.execute(
      'SELECT id, title, description, is_completed, created_at, updated_at FROM todos WHERE id = ? AND user_id = ?',
      [id, userId]
    );

    if (rows.length === 0) {
      return res.status(404).json({ message: 'Todo not found' });
    }

    res.json({ todo: rows[0] });
  } catch (error) {
    console.error('Get todo error:', error);
    res.status(500).json({ message: 'Server error while fetching todo' });
  }
});

// Create new todo
router.post('/', authenticateToken, [
  body('title').notEmpty().trim(),
  body('description').optional().trim()
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ message: 'Validation failed', errors: errors.array() });
    }

    const { title, description } = req.body;
    const userId = req.user.userId;

    const [result] = await pool.execute(
      'INSERT INTO todos (user_id, title, description) VALUES (?, ?, ?)',
      [userId, title, description || '']
    );

    // Clear user's todo cache
    await cache.deleteUserCache(userId);

    const [newTodo] = await pool.execute(
      'SELECT id, title, description, is_completed, created_at, updated_at FROM todos WHERE id = ?',
      [result.insertId]
    );

    res.status(201).json({
      message: 'Todo created successfully',
      todo: newTodo[0]
    });
  } catch (error) {
    console.error('Create todo error:', error);
    res.status(500).json({ message: 'Server error while creating todo' });
  }
});

// Update todo
router.put('/:id', authenticateToken, [
  body('title').optional().notEmpty().trim(),
  body('description').optional().trim(),
  body('is_completed').optional().isBoolean()
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ message: 'Validation failed', errors: errors.array() });
    }

    const { id } = req.params;
    const userId = req.user.userId;
    const { title, description, is_completed } = req.body;

    // Check if todo exists and belongs to user
    const [existingTodos] = await pool.execute(
      'SELECT id FROM todos WHERE id = ? AND user_id = ?',
      [id, userId]
    );

    if (existingTodos.length === 0) {
      return res.status(404).json({ message: 'Todo not found' });
    }

    // Build update query dynamically
    const updates = [];
    const values = [];

    if (title !== undefined) {
      updates.push('title = ?');
      values.push(title);
    }
    if (description !== undefined) {
      updates.push('description = ?');
      values.push(description);
    }
    if (is_completed !== undefined) {
      updates.push('is_completed = ?');
      values.push(is_completed);
    }

    if (updates.length === 0) {
      return res.status(400).json({ message: 'No valid fields to update' });
    }

    values.push(id, userId);

    await pool.execute(
      `UPDATE todos SET ${updates.join(', ')} WHERE id = ? AND user_id = ?`,
      values
    );

    // Clear user's todo cache
    await cache.deleteUserCache(userId);

    // Get updated todo
    const [updatedTodo] = await pool.execute(
      'SELECT id, title, description, is_completed, created_at, updated_at FROM todos WHERE id = ?',
      [id]
    );

    res.json({
      message: 'Todo updated successfully',
      todo: updatedTodo[0]
    });
  } catch (error) {
    console.error('Update todo error:', error);
    res.status(500).json({ message: 'Server error while updating todo' });
  }
});

// Delete todo
router.delete('/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.userId;

    const [result] = await pool.execute(
      'DELETE FROM todos WHERE id = ? AND user_id = ?',
      [id, userId]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Todo not found' });
    }

    // Clear user's todo cache
    await cache.deleteUserCache(userId);

    res.json({ message: 'Todo deleted successfully' });
  } catch (error) {
    console.error('Delete todo error:', error);
    res.status(500).json({ message: 'Server error while deleting todo' });
  }
});

module.exports = router;
