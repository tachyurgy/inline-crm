import { test, expect } from '@playwright/test';

test.describe('Turbo and Stimulus Integration', () => {
  test('JavaScript assets load correctly', async ({ page }) => {
    await page.goto('/');

    // Verify Turbo is loaded
    const turboLoaded = await page.evaluate(() => {
      return typeof window.Turbo !== 'undefined';
    });
    expect(turboLoaded).toBe(true);

    // Verify Stimulus is loaded
    const stimulusLoaded = await page.evaluate(() => {
      return typeof window.Stimulus !== 'undefined';
    });
    expect(stimulusLoaded).toBe(true);
  });

  test('Stimulus controllers are registered', async ({ page }) => {
    await page.goto('/');

    const controllers = await page.evaluate(() => {
      const app = window.Stimulus;
      if (!app) return [];
      // @ts-ignore
      return app.router.modules.map(m => m.definition.identifier);
    });

    expect(controllers).toContain('inline-edit');
    expect(controllers).toContain('pipeline');
    expect(controllers).toContain('activity-feed');
  });

  test('Turbo navigation works between pages', async ({ page }) => {
    await page.goto('/');

    await page.click('nav >> text=Contacts');
    await expect(page).toHaveURL(/\/contacts/);

    await page.click('nav >> text=Companies');
    await expect(page).toHaveURL(/\/companies/);

    const stimulusConnected = await page.evaluate(() => {
      return typeof window.Stimulus !== 'undefined';
    });
    expect(stimulusConnected).toBe(true);
  });

  test('CSS is loaded and styled', async ({ page }) => {
    await page.goto('/');

    const navBg = await page.locator('nav').evaluate((el) => {
      return window.getComputedStyle(el).borderBottomWidth;
    });
    expect(navBg).toBe('1px');
  });

  test('inline edit creates activity entry', async ({ page }) => {
    // Create a contact
    await page.goto('/contacts/new');
    await page.fill('input[name="contact[first_name]"]', 'ActivityTest');
    await page.fill('input[name="contact[last_name]"]', 'User');
    await page.click('input[type="submit"]');

    // Wait for redirect to show page
    await page.waitForURL(/\/contacts\/\d+/);
    await expect(page.locator('h1')).toContainText('ActivityTest User');

    // Edit a field to generate activity
    const firstNameField = page.locator('[data-controller="inline-edit"]', { hasText: 'First name' });
    await firstNameField.locator('[data-inline-edit-target="display"]').click();
    const input = firstNameField.locator('input[name="contact[first_name]"]');
    await input.fill('ActivityUpdated');
    await input.press('Enter');

    await page.waitForTimeout(1000);
    await page.reload();

    await expect(page.locator('text=Changed first name')).toBeVisible();
  });
});
