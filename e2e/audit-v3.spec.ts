import { test, expect } from '@playwright/test';

test.describe('Visual Audit v3', () => {
  test.use({ baseURL: 'http://127.0.0.1:3099' });

  test('screenshot new features', async ({ page }) => {
    const dir = '/tmp/crm-screenshots';

    // Dashboard with quick-add buttons
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.screenshot({ path: `${dir}/v3-01-dashboard-buttons.png`, fullPage: true });

    // Open quick-add contact modal
    await page.click('button:has-text("+ Contact")');
    await page.waitForTimeout(500);
    await page.screenshot({ path: `${dir}/v3-02-quick-add-contact.png`, fullPage: true });

    // Fill and submit the quick-add form
    await page.fill('input[name="contact[first_name]"]', 'Quick');
    await page.fill('input[name="contact[last_name]"]', 'Added');
    await page.fill('input[name="contact[email]"]', 'quick@test.com');
    await page.click('input[type="submit"]');
    await page.waitForTimeout(1000);
    await page.screenshot({ path: `${dir}/v3-03-after-quick-add.png`, fullPage: true });

    // Companies search
    await page.goto('/companies');
    await page.waitForLoadState('networkidle');
    await page.screenshot({ path: `${dir}/v3-04-companies-with-search.png`, fullPage: true });

    await page.fill('input[name="q"]', 'hett');
    await page.waitForTimeout(500);
    await page.screenshot({ path: `${dir}/v3-05-companies-search-result.png`, fullPage: true });

    // Pipeline with drop indicators
    await page.goto('/deals');
    await page.waitForLoadState('networkidle');
    await page.screenshot({ path: `${dir}/v3-06-pipeline-improved.png`, fullPage: true });
  });
});
