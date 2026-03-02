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

## Jira

- **Projeto:** GES
- **Cloud ID:** `0630ea51-98b0-4a07-ab84-b3227ade0fd2`
- **Assignee:** `712020:890e5895-e21a-4b73-9bfa-68ffa48609f0`
- **Tipos:** Task, Bug, Story, Refactor, Discovery

## Fluxo Completo: Ticket → Release

### 1. Criar Ticket

Jira: Criar issue no projeto GES
- Tipo: Task, Bug, Story, Refactor, Discovery
- Prioridade: Highest → Lowest
- Status inicial: Itens Pendentes

### 2. Iniciar Tarefa

Jira:
- Atribuir ao responsável
- Definir Start Date (data atual)
- Definir Prioridade (default: High)
- Transicionar: Pendentes → Active (ID: 3)

Git:
```
git pull origin main
git checkout -b <tipo>/GES-XXX-descricao
```

Tipos de branch:
- `feature/` — funcionalidades
- `fix/` — correções
- `refactor/` — refatorações

### 3. Desenvolvimento

Commits:
```
prefixo: descrição em português
```

Prefixos:
- `feat:` — nova funcionalidade
- `fix:` — correção de bug
- `refactor:` — refatoração
- `test:` — testes
- `chore:` — manutenção
- `docs:` — documentação

Regras:
- **Sem Co-Authored-By**
- Mensagens em português
- Não usar `--no-verify` ou `--amend` sem autorização

### 4. Entregar

Qualidade (obrigatório antes do push):
```
bin/rubocop                  → 0 offenses
bin/brakeman --no-pager      → 0 warnings
bin/rails test               → 100% passing
```

Git:
```
git add <arquivos>
git commit -m "prefixo: descrição"
git push origin <branch>
```

PR:
```
gh pr create --base main
Título: [Tipo][GES-XXX] Descrição
Tipos: Bug, Feature, Refactor, Discovery
```

Jira:
- Comentário com detalhes da entrega
- Transicionar: Active → Resolvido (ID: 21)

### 5. Aprovar e Mergear

Git:
```
gh pr merge <numero> --merge --delete-branch
```

Jira:
- Comentário com link da PR
- Transicionar: Resolvido → Concluído (ID: 31)

### 6. Fechar História/Epic

Pré-condição: Todas as subtarefas concluídas

Jira:
- Atribuir ao responsável
- Definir Sprint
- Definir Start Date (data da primeira subtarefa)
- Comentário com resumo dos entregáveis e PRs
- Transicionar: → Concluído (ID: 31)

### 7. Criar Versão

Git:
```
git tag --sort=-v:refname | head -1   → versão atual
```

Incrementar:
- `patch` (X.Y.Z) → bug fixes
- `minor` (X.Y.0) → features

```
git tag -a vX.Y.Z origin/main -m "vX.Y.Z — descrição"
git push origin vX.Y.Z
gh release create vX.Y.Z --title "vX.Y.Z — título" --notes "changelog"
```

### Resumo Visual

```
JIRA:    PENDENTES ──→ ACTIVE ──→ RESOLVIDO ──→ CONCLUÍDO
              │           │            │             │
GIT:        pull       commits      push+PR    merge + tag
              │           │            │             │
QUALITY:     ---         ---     rubocop→brakeman  review
                                 →tests→push
```

### Transições Jira (referência rápida)

| Coluna            | Transition ID | Ação                          |
|-------------------|---------------|-------------------------------|
| Itens Pendentes   | 11            | mover GES-XXX para pendente   |
| Planejado         | 2             | planejar GES-XXX              |
| Active            | 3             | iniciar GES-XXX               |
| Resolvido         | 21            | entregar GES-XXX              |
| Concluído (CLOSE) | 31            | fechar GES-XXX                |
