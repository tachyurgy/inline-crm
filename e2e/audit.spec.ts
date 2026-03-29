import { test, expect } from '@playwright/test';

test.describe('Visual Audit v2', () => {
  test.use({ baseURL: 'http://127.0.0.1:3099' });

  test('screenshot every page and interaction', async ({ page }) => {
    const dir = '/tmp/crm-screenshots';

    // 1. Dashboard
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.screenshot({ path: `${dir}/01-dashboard.png`, fullPage: true });

    // 2. Contacts index with search bar
    await page.goto('/contacts');
    await page.waitForLoadState('networkidle');
    await page.screenshot({ path: `${dir}/02-contacts-index.png`, fullPage: true });

    // 3. Search contacts
    await page.fill('input[name="q"]', 'sarah');
    await page.waitForTimeout(500);
    await page.screenshot({ path: `${dir}/03-contacts-search.png`, fullPage: true });
    await page.fill('input[name="q"]', '');
    await page.waitForTimeout(300);

    // 4. Create a contact
    await page.goto('/contacts/new');
    await page.fill('input[name="contact[first_name]"]', 'Sarah');
    await page.fill('input[name="contact[last_name]"]', 'Chen');
    await page.fill('input[name="contact[email]"]', 'sarah.chen@example.com');
    await page.fill('input[name="contact[phone]"]', '555-0142');
    await page.fill('input[name="contact[title]"]', 'VP of Engineering');
    await page.click('input[type="submit"]');
    await page.waitForURL(/\/contacts\/\d+/);
    await page.waitForLoadState('networkidle');
    await page.screenshot({ path: `${dir}/04-contact-show.png`, fullPage: true });

    // 5. Hover over editable field to see pencil icon
    const firstNameField = page.locator('[data-controller="inline-edit"]', { hasText: 'First name' });
    await firstNameField.locator('[data-inline-edit-target="display"]').hover();
    await page.waitForTimeout(300);
    await page.screenshot({ path: `${dir}/05-contact-hover-pencil.png`, fullPage: true });

    // 6. Click to edit
    await firstNameField.locator('[data-inline-edit-target="display"]').click();
    await page.waitForTimeout(300);
    const input = firstNameField.locator('input[name="contact[first_name]"]');
    await input.fill('Sarah Jane');
    await input.press('Enter');
    await page.waitForTimeout(500);
    await page.screenshot({ path: `${dir}/06-contact-edited-h1-updated.png`, fullPage: true });

    // 7. Add a manual note
    await page.fill('input[placeholder="Add a note..."]', 'Had a great intro call, very interested in platform.');
    await page.screenshot({ path: `${dir}/07-contact-add-note.png`, fullPage: true });
    await page.click('button:has-text("Add")');
    await page.waitForTimeout(500);
    await page.screenshot({ path: `${dir}/08-contact-note-added.png`, fullPage: true });

    // 8. Companies
    await page.goto('/companies');
    await page.waitForLoadState('networkidle');
    await page.screenshot({ path: `${dir}/09-companies-index.png`, fullPage: true });

    // 9. Company show
    await page.goto('/companies/new');
    await page.fill('input[name="company[name]"]', 'Acme Technologies');
    await page.fill('input[name="company[industry]"]', 'Software');
    await page.fill('input[name="company[phone]"]', '555-0100');
    await page.click('input[type="submit"]');
    await page.waitForURL(/\/companies\/\d+/);
    await page.waitForLoadState('networkidle');
    await page.screenshot({ path: `${dir}/10-company-show.png`, fullPage: true });

    // 10. Pipeline board
    await page.goto('/deals');
    await page.waitForLoadState('networkidle');
    await page.screenshot({ path: `${dir}/11-pipeline-board.png`, fullPage: true });

    // 11. Deal show
    await page.goto('/deals/new');
    await page.fill('input[name="deal[name]"]', 'Enterprise Platform License');
    await page.selectOption('select[name="deal[stage]"]', 'proposal');
    await page.fill('input[name="deal[value]"]', '125000');
    const companySelect = page.locator('select[name="deal[company_id]"]');
    const options = await companySelect.locator('option:not([value=""])').all();
    if (options.length > 0) {
      const val = await options[0].getAttribute('value');
      if (val) await companySelect.selectOption(val);
    }
    await page.click('input[type="submit"]');
    await page.waitForURL(/\/deals/);
    await page.click('text=Enterprise Platform License');
    await page.waitForLoadState('networkidle');
    await page.screenshot({ path: `${dir}/12-deal-show.png`, fullPage: true });

    // 12. Activity feed
    await page.goto('/activities');
    await page.waitForLoadState('networkidle');
    await page.screenshot({ path: `${dir}/13-activity-feed.png`, fullPage: true });

    // 13. Dashboard with data
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.screenshot({ path: `${dir}/14-dashboard-final.png`, fullPage: true });
  });
});
