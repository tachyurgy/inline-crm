# InlineCRM

**Deployment status (Render, 2026-04-10):** Not currently deployed to Render free tier. This app uses Rails 8.1 with `solid_queue`, `solid_cache`, and `solid_cable`, which require a PostgreSQL database. Render's free tier limits the workspace to a single active free Postgres instance, which is already in use by the Pulse deploy. To deploy InlineCRM, either upgrade Render Postgres to a paid plan ($7/mo) or supply an external free Postgres (e.g. Neon, Supabase) as `DATABASE_URL`.

A lightweight CRM built with Rails 8.1, Hotwire (Turbo + Stimulus), and ViewComponent. Everything is editable inline -- no separate edit pages. Drag deals across pipeline stages. Activity feeds update automatically.

## Stack

- Ruby 3.3 / Rails 8.1
- PostgreSQL
- Hotwire (Turbo Drive, Turbo Streams, Stimulus)
- ViewComponent
- Tailwind CSS 4 (via cssbundling-rails)
- esbuild (via jsbundling-rails)
- Playwright (E2E tests)
- Minitest (unit + integration tests)

## Features

- Click-to-edit fields on every detail page (contacts, companies, deals)
- Turbo Stream partial replacement on inline save
- Drag-and-drop pipeline board for deals
- Polymorphic activity feed with auto-refresh polling
- Component-driven UI with ViewComponent
- Full test coverage: 56 unit/integration tests + 17 Playwright E2E tests

## Setup

```
bin/setup
bin/rails db:seed
```

## Running

```
bin/dev
```

## Tests

```
bin/rails test                    # unit + integration
npx playwright test               # E2E (starts server automatically)
```

## Architecture

The app demonstrates modern Rails patterns without a frontend framework:

- **Stimulus controllers** handle click-to-edit, drag-and-drop, and activity feed polling
- **Turbo Streams** replace individual fields after inline saves (no full-page reloads)
- **ViewComponent** encapsulates reusable UI: `EditableFieldComponent`, `DealCardComponent`, `StageColumnComponent`, `ActivityEntryComponent`
- **Polymorphic activities** track all changes automatically via model callbacks
