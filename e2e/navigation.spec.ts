import { test, expect } from '@playwright/test';

test.describe('Navigation', () => {
  test('loads dashboard with stats', async ({ page }) => {
    await page.goto('/');
    await expect(page.locator('h1')).toContainText('Dashboard');
    await expect(page.locator('nav >> text=Contacts')).toBeVisible();
    await expect(page.locator('nav >> text=Companies')).toBeVisible();
    await expect(page.locator('text=Pipeline Value')).toBeVisible();
  });

  test('navigates to contacts page', async ({ page }) => {
    await page.goto('/');
    await page.click('nav >> text=Contacts');
    await expect(page).toHaveURL(/\/contacts/);
    await expect(page.locator('h1')).toContainText('Contacts');
  });

  test('navigates to companies page', async ({ page }) => {
    await page.goto('/');
    await page.click('nav >> text=Companies');
    await expect(page).toHaveURL(/\/companies/);
    await expect(page.locator('h1')).toContainText('Companies');
  });

  test('navigates to pipeline page', async ({ page }) => {
    await page.goto('/');
    await page.click('nav >> text=Pipeline');
    await expect(page).toHaveURL(/\/deals/);
    await expect(page.locator('h1')).toContainText('Pipeline');
  });

  test('navigates to activity page', async ({ page }) => {
    await page.goto('/');
    await page.click('nav >> text=Activity');
    await expect(page).toHaveURL(/\/activities/);
    await expect(page.locator('h1')).toContainText('Activity Feed');
  });
});
