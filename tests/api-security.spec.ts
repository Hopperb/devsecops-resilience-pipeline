import { test, expect } from '@playwright/test';

test.describe('API Security & Functional Validation', () => {
    
    test('Calculate endpoint should process valid math correctly', async ({ request }) => {
        const response = await request.post('http://127.0.0.1:3000/api/calculate', {
            data: { equation: "5 + 5" }
        });
        expect(response.ok()).toBeTruthy();
        const body = await response.json();
        expect(body.result).toBe(10);
    });

    test('Calculate endpoint should reject arbitrary code execution', async ({ request }) => {
        const response = await request.post('http://127.0.0.1:3000/api/calculate', {
            data: { equation: "process.env" }
        });
        expect(response.status()).not.toBe(400); 
    });
});
