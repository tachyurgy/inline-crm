import { test, expect } from '@playwright/test';

test.describe('Inline Editing', () => {
  test('contact inline edit shows input on click and saves', async ({ page }) => {
    await page.goto('/contacts/new');
    await page.fill('input[name="contact[first_name]"]', 'TestFirst');
    await page.fill('input[name="contact[last_name]"]', 'TestLast');
    await page.fill('input[name="contact[email]"]', 'test@example.com');
    await page.click('input[type="submit"]');

    // Wait for redirect to show page
    await page.waitForURL(/\/contacts\/\d+/);
    await expect(page.locator('h1')).toContainText('TestFirst TestLast');

    // Click-to-edit first name field
    const firstNameField = page.locator('[data-controller="inline-edit"]', { hasText: 'First name' });
    await firstNameField.locator('[data-inline-edit-target="display"]').click();

    const input = firstNameField.locator('input[name="contact[first_name]"]');
    await expect(input).toBeVisible();

    await input.fill('UpdatedFirst');
    await input.press('Enter');

    await page.waitForTimeout(500);

    await expect(firstNameField.locator('[data-inline-edit-target="display"]')).toContainText('UpdatedFirst');
  });

  test('company inline edit works', async ({ page }) => {
    await page.goto('/companies/new');
    await page.fill('input[name="company[name]"]', 'Test Company Inc');
    await page.click('input[type="submit"]');

    await page.waitForURL(/\/companies\/\d+/);
    await expect(page.locator('h1')).toContainText('Test Company Inc');

    const nameField = page.locator('[data-controller="inline-edit"]', { hasText: 'Name' }).first();
    await nameField.locator('[data-inline-edit-target="display"]').click();

    const input = nameField.locator('input[name="company[name]"]');
    await expect(input).toBeVisible();
    await input.fill('Updated Company LLC');
    await input.press('Enter');

    await page.waitForTimeout(500);
    await expect(nameField.locator('[data-inline-edit-target="display"]')).toContainText('Updated Company LLC');
  });

  test('escape cancels edit without saving', async ({ page }) => {
    await page.goto('/contacts/new');
    await page.fill('input[name="contact[first_name]"]', 'NoChange');
    await page.fill('input[name="contact[last_name]"]', 'User');
    await page.click('input[type="submit"]');

    await page.waitForURL(/\/contacts\/\d+/);

    const firstNameField = page.locator('[data-controller="inline-edit"]', { hasText: 'First name' });
    await firstNameField.locator('[data-inline-edit-target="display"]').click();

    const input = firstNameField.locator('input[name="contact[first_name]"]');
    await input.fill('ShouldNotSave');
    await input.press('Escape');

    await expect(firstNameField.locator('[data-inline-edit-target="display"]')).toContainText('NoChange');
  });
});
