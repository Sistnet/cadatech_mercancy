# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Mercancy Admin is a Rails 8.1 admin application built with Ruby 4.0. It uses PostgreSQL, Tailwind CSS, Hotwire (Turbo + Stimulus), and import maps (no Node.js required). The project is in early stage with minimal routes and models.

## Common Commands

### Development
- `bin/setup` — initial project setup (bundle, db:prepare, etc.)
- `bin/dev` — start dev server (Rails + Tailwind CSS watcher via Foreman)
- `bin/rails server` — start Rails server only

### Testing
- `bin/rails test` — run unit/integration tests (Minitest, parallel)
- `bin/rails test test/models/user_test.rb` — run a single test file
- `bin/rails test test/models/user_test.rb:42` — run a specific test by line number
- `bin/rails test:system` — run system tests (Capybara + Selenium)
- `bin/rails db:test:prepare` — prepare test database

### Code Quality (all run in CI)
- `bin/rubocop` — lint Ruby (Omakase Rails style)
- `bin/brakeman --no-pager` — security static analysis
- `bin/bundler-audit` — gem vulnerability scan
- `bin/importmap audit` — JS dependency scan

### Database
- `bin/rails db:prepare` — create and migrate
- `bin/rails db:migrate` — run pending migrations
- `bin/rails db:seed` — seed data

### Deployment
- `bin/kamal deploy` — deploy via Kamal (Docker-based)

## Architecture

### Stack
- **Backend:** Rails 8.1, Ruby 4.0, PostgreSQL
- **Frontend:** Tailwind CSS, Turbo, Stimulus via import maps
- **Asset Pipeline:** Propshaft
- **Background Jobs:** Solid Queue (database-backed)
- **Caching:** Solid Cache (database-backed)
- **WebSockets:** Solid Cable (database-backed)
- **Deployment:** Kamal + Docker, Thruster as HTTP accelerator

### Database Configuration
- Development uses a single database (`mercado_dev`)
- Production uses multiple PostgreSQL databases: primary, cache, queue, cable
- Each has its own `migrations_paths` (`db/cache_migrate`, `db/queue_migrate`, `db/cable_migrate`)

### CI Pipeline (GitHub Actions)
Runs on PRs and pushes to `main`:
1. **scan_ruby** — Brakeman + Bundler Audit
2. **scan_js** — ImportMap audit
3. **lint** — RuboCop
4. **test** — unit tests with PostgreSQL service
5. **system-test** — browser tests with PostgreSQL service

## Conventions

- RuboCop uses `rubocop-rails-omakase` (Rails standard style). Run `bin/rubocop` before committing.
- Tests use Minitest with fixtures (not RSpec).
- JavaScript uses Stimulus controllers in `app/javascript/controllers/` — no npm/yarn.
- Health check endpoint: `GET /up`.
