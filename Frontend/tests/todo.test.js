const axios = require('axios');

const API = process.env.API_BASE_URL || 'http://localhost:5001/api';

describe('Todo API (requires auth)', () => {
  let token;
  let todoId;
  const email = `todo_${Date.now()}@example.com`;
  const password = 'password123';

  beforeAll(async () => {
    const reg = await axios.post(`${API}/auth/register`, { email, password });
    token = reg.data.token;
  });

  it('rejects unauthenticated access', async () => {
    await expect(axios.get(`${API}/todos`)).rejects.toBeTruthy();
  });

  it('creates, lists, updates, and deletes a todo', async () => {
    const created = await axios.post(`${API}/todos`, { title: 'CI Todo' }, { headers: { Authorization: `Bearer ${token}` } });
    todoId = created.data.todo.id;
    expect(todoId).toBeTruthy();

    const list = await axios.get(`${API}/todos`, { headers: { Authorization: `Bearer ${token}` } });
    expect(list.data.todos.some(t => t.id === todoId)).toBe(true);

    const updated = await axios.put(`${API}/todos/${todoId}`, { is_completed: true }, { headers: { Authorization: `Bearer ${token}` } });
    expect(updated.data.todo).toBeTruthy();

    const del = await axios.delete(`${API}/todos/${todoId}`, { headers: { Authorization: `Bearer ${token}` } });
    expect(del.status).toBeLessThan(300);
  });
});