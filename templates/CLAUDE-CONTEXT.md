# Claude Context File

<!-- AI-DLC Phase: Created in Phase 0: Foundation, updated every bolt -->

> This is your AI's primary context file. Place it at the root of your repository.
> Keep it current -- stale context leads to poor AI output.
> Update this file at the end of every bolt/sprint.
> Items marked with <!-- TODO: ... --> need your input.

---

## Project Identity

<!-- TODO: Fill in your project details -->

| Field | Value |
|-------|-------|
| **Project Name** | *<!-- TODO: e.g., SubscriptionHub -->* |
| **Type** | *<!-- TODO: e.g., Web application, CLI tool, API service, Library -->* |
| **Version** | *<!-- TODO: e.g., 0.1.0 -->* |
| **Repository** | *<!-- TODO: e.g., github.com/org/project -->* |
| **Primary Language** | *<!-- TODO: e.g., TypeScript -->* |
| **Framework** | *<!-- TODO: e.g., Next.js 14, FastAPI, Rails 7 -->* |
| **Runtime** | *<!-- TODO: e.g., Node.js 20, Python 3.12, Ruby 3.3 -->* |
| **Package Manager** | *<!-- TODO: e.g., pnpm, uv, bundler -->* |
| **Database** | *<!-- TODO: e.g., PostgreSQL 16, SQLite, DynamoDB -->* |

---

## Architecture Overview

<!-- TODO: Describe your system architecture at a level an AI assistant needs to be productive -->

### High-Level Diagram

<!-- TODO: Replace with an ASCII diagram, Mermaid block, or link to a diagram -->

```
<!--
Example:

  [Browser] --> [API Gateway] --> [App Server] --> [Database]
                                       |
                                       +--> [Cache]
                                       |
                                       +--> [Object Storage]
-->
```

### Key Components

<!-- TODO: List the major components of your system -->

| Component | Location | Purpose |
|-----------|----------|---------|
| *API Server* | *src/api/* | *Handles HTTP requests, routing, middleware* |
| *Database Layer* | *src/db/* | *Schema, migrations, query builders* |
| *Auth Module* | *src/auth/* | *Authentication, authorization, session management* |
| *UI* | *src/app/* | *Frontend pages and components* |
| <!-- TODO: Add your components --> | | |

### Data Flow

<!-- TODO: Describe how data moves through your system for the primary use case -->

*<!-- Example: User submits form -> API validates input -> Service layer processes business logic -> Repository persists to database -> Response returned with created resource. -->*

---

## Conventions

### Coding Style

<!-- TODO: Define the coding conventions AI should follow -->

- *<!-- TODO: e.g., Use functional components, not class components -->*
- *<!-- TODO: e.g., Prefer named exports over default exports -->*
- *<!-- TODO: e.g., Use early returns to reduce nesting -->*
- *<!-- TODO: e.g., Maximum function length: 40 lines -->*
- *<!-- TODO: e.g., All public functions must have JSDoc/docstring comments -->*

### Naming Conventions

<!-- TODO: Define naming rules -->

| Element | Convention | Example |
|---------|-----------|---------|
| *Files* | *<!-- TODO: e.g., kebab-case -->* | *user-profile.ts* |
| *Components* | *<!-- TODO: e.g., PascalCase -->* | *UserProfile.tsx* |
| *Functions* | *<!-- TODO: e.g., camelCase -->* | *getUserProfile()* |
| *Constants* | *<!-- TODO: e.g., SCREAMING_SNAKE_CASE -->* | *MAX_RETRY_COUNT* |
| *Database tables* | *<!-- TODO: e.g., snake_case, plural -->* | *user_profiles* |
| *API endpoints* | *<!-- TODO: e.g., kebab-case, plural nouns -->* | */api/user-profiles* |

### File Structure

<!-- TODO: Show your project's directory layout -->

```
<!-- TODO: Replace with your actual structure -->
<!--
project-root/
  src/
    api/          # Route handlers and middleware
    db/           # Database schema, migrations, repositories
    auth/         # Authentication and authorization
    services/     # Business logic
    utils/        # Shared utilities
    types/        # Type definitions
  tests/
    unit/         # Unit tests mirroring src/ structure
    integration/  # Integration and API tests
  docs/           # Project documentation
  scripts/        # Build, deploy, and maintenance scripts
-->
```

### Commit Messages

<!-- TODO: Define your commit message format -->

*<!-- Example: Follow Conventional Commits: type(scope): description -->*
*<!-- Types: feat, fix, docs, style, refactor, test, chore -->*
*<!-- Example: feat(auth): add email verification flow -->*

---

## Current State

<!-- TODO: Update this section at the end of every bolt/sprint -->

### What Is Built

<!-- TODO: List completed features and capabilities -->

- *<!-- TODO: e.g., User registration and login (REQ-001) -->*
- *<!-- TODO: e.g., Basic dashboard layout (REQ-002, partial) -->*

### What Is In Progress

<!-- TODO: List features currently being worked on -->

- *<!-- TODO: e.g., Subscription display on dashboard (US-201) -->*
- *<!-- TODO: e.g., CSV export backend (US-301) -->*

### Known Issues

<!-- TODO: List bugs, tech debt, or incomplete work the AI should be aware of -->

- *<!-- TODO: e.g., Session timeout not implemented yet -- sessions persist indefinitely -->*
- *<!-- TODO: e.g., Error handling in API returns generic 500 for all failures -->*
- *<!-- TODO: e.g., Test coverage is below 60% for the auth module -->*

---

## Key Decisions

<!-- TODO: Document important architectural or design choices and why they were made -->

| Decision | Rationale | Date | Alternatives Considered |
|----------|-----------|------|------------------------|
| *<!-- TODO: e.g., Use server-side rendering -->* | *<!-- TODO: e.g., SEO requirements and faster initial load -->* | *<!-- TODO: Date -->* | *Client-side SPA, static generation* |
| *<!-- TODO: e.g., PostgreSQL over MongoDB -->* | *<!-- TODO: e.g., Relational data model, ACID transactions needed -->* | *<!-- TODO: Date -->* | *MongoDB, DynamoDB* |
| *<!-- TODO: e.g., Monorepo structure -->* | *<!-- TODO: e.g., Shared types between frontend and backend -->* | *<!-- TODO: Date -->* | *Separate repos, git submodules* |

---

## Environment Setup

<!-- TODO: Provide the exact steps to get a working local development environment -->

### Prerequisites

<!-- TODO: List required tools and versions -->

- *<!-- TODO: e.g., Node.js >= 20.0 -->*
- *<!-- TODO: e.g., Docker and Docker Compose -->*
- *<!-- TODO: e.g., pnpm >= 9.0 -->*

### Quick Start

```bash
# <!-- TODO: Replace with your actual setup commands -->
# git clone <repo-url>
# cd <project-name>
# cp .env.example .env
# pnpm install
# pnpm db:migrate
# pnpm dev
```

### Environment Variables

<!-- TODO: List required environment variables (without actual secrets) -->

| Variable | Purpose | Example Value |
|----------|---------|---------------|
| *DATABASE_URL* | *Database connection string* | *postgresql://localhost:5432/myapp_dev* |
| *SESSION_SECRET* | *Session encryption key* | *any-random-string-for-dev* |
| *API_BASE_URL* | *Backend API URL* | *http://localhost:3001* |
| <!-- TODO: Add your env vars --> | | |

---

## Testing

### Running Tests

```bash
# <!-- TODO: Replace with your actual test commands -->
# pnpm test              # Run all tests
# pnpm test:unit         # Run unit tests only
# pnpm test:integration  # Run integration tests only
# pnpm test:coverage     # Run tests with coverage report
```

### Test Conventions

<!-- TODO: Define how tests should be written -->

- *<!-- TODO: e.g., Test files live next to source files as *.test.ts -->*
- *<!-- TODO: e.g., Use describe/it blocks; describe matches the module name -->*
- *<!-- TODO: e.g., One assertion per test where practical -->*
- *<!-- TODO: e.g., Integration tests use a dedicated test database -->*
- *<!-- TODO: e.g., Mock external services; never call real APIs in tests -->*

---

## Deployment

<!-- TODO: Describe how the application is deployed -->

### Environments

| Environment | URL | Purpose | Deploy Method |
|-------------|-----|---------|---------------|
| *Local* | *http://localhost:3000* | *Development* | *Manual (pnpm dev)* |
| *Staging* | *<!-- TODO: URL -->* | *Pre-production testing* | *<!-- TODO: e.g., Auto-deploy on merge to main -->* |
| *Production* | *<!-- TODO: URL -->* | *Live users* | *<!-- TODO: e.g., Manual promotion from staging -->* |

### Deploy Commands

```bash
# <!-- TODO: Replace with your actual deploy commands -->
# pnpm build
# pnpm deploy:staging
# pnpm deploy:production
```

---

## AI-Specific Notes

<!-- TODO: Add any context that helps the AI assistant be more effective -->

- *<!-- TODO: e.g., Always check REQUIREMENTS.md before implementing a new feature -->*
- *<!-- TODO: e.g., Run pnpm lint before suggesting code is complete -->*
- *<!-- TODO: e.g., The auth module is security-sensitive -- flag any changes for human review -->*
- *<!-- TODO: e.g., Prefer existing utility functions in src/utils/ over creating new ones -->*

---

## Revision History

| Date | Version | Author | Changes |
|------|---------|--------|---------|
| *<!-- TODO: Date -->* | *0.1* | *<!-- TODO: Author -->* | *Initial context file created in Phase 0* |
