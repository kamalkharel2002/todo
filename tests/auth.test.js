const axios = require('axios');

const API = process.env.API_BASE_URL || 'http://localhost:5001/api';

describe('Auth API', () => {
  const email = `ci_${Date.now()}@example.com`;
  const password = 'password123';

  it('registers and logs in', async () => {
    const r1 = await axios.post(`${API}/auth/register`, { email, password });
    expect(r1.status).toBeLessThan(300);
    expect(r1.data.token).toBeTruthy();

    const r2 = await axios.post(`${API}/auth/login`, { email, password });
    expect(r2.status).toBeLessThan(300);
    expect(r2.data.token).toBeTruthy();
  });
});