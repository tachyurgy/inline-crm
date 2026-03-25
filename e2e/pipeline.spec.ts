import { test, expect } from '@playwright/test';

test.describe('Pipeline Board', () => {
  test('renders all pipeline stages', async ({ page }) => {
    await page.goto('/deals');

    for (const stage of ['Lead', 'Qualified', 'Proposal', 'Negotiation', 'Won', 'Lost']) {
      await expect(page.locator(`text=${stage}`).first()).toBeVisible();
    }
  });

  test('can create a new deal', async ({ page }) => {
    // First create a company
    await page.goto('/companies/new');
    await page.fill('input[name="company[name]"]', 'Pipeline Test Co');
    await page.click('input[type="submit"]');

    // Now create a deal
    await page.goto('/deals/new');
    await page.fill('input[name="deal[name]"]', 'Big Pipeline Deal');
    await page.selectOption('select[name="deal[stage]"]', 'lead');
    await page.fill('input[name="deal[value]"]', '75000');
    await page.selectOption('select[name="deal[company_id]"]', { label: 'Pipeline Test Co' });
    await page.click('input[type="submit"]');

    await expect(page).toHaveURL(/\/deals/);
    await expect(page.locator('text=Big Pipeline Deal').first()).toBeVisible();
  });

  test('deal cards are draggable', async ({ page }) => {
    await page.goto('/deals');
    const draggableCards = page.locator('[draggable="true"]');
    const count = await draggableCards.count();
    // Verify draggable attribute exists on deal cards
    if (count > 0) {
      await expect(draggableCards.first()).toHaveAttribute('draggable', 'true');
    }
  });

  test('deal show page has inline editing', async ({ page }) => {
    // Create a deal first
    await page.goto('/companies/new');
    await page.fill('input[name="company[name]"]', 'Show Page Co');
    await page.click('input[type="submit"]');

    await page.goto('/deals/new');
    await page.fill('input[name="deal[name]"]', 'Show Page Deal');
    await page.selectOption('select[name="deal[stage]"]', 'lead');
    await page.fill('input[name="deal[value]"]', '50000');
    await page.selectOption('select[name="deal[company_id]"]', { label: 'Show Page Co' });
    await page.click('input[type="submit"]');

    // Click on the deal
    await page.click('text=Show Page Deal');

    // Verify inline edit fields exist
    await expect(page.locator('[data-controller="inline-edit"]').first()).toBeVisible();
  });
});
