import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  timeout: 30000,
  retries: 1,
  use: {
    baseURL: 'http://127.0.0.1:3099',
    headless: true,
    screenshot: 'only-on-failure',
  },
  webServer: {
    command: 'bin/rails server -p 3099 -e test',
    url: 'http://127.0.0.1:3099/up',
    timeout: 30000,
    reuseExistingServer: true,
  },
  projects: [
    {
      name: 'chromium',
      use: { browserName: 'chromium' },
    },
  ],
});
