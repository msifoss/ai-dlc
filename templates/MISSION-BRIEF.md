# Mission Brief

<!-- AI-DLC Phase: Produced before autonomous DLC loop execution -->

> Fill this out BEFORE running `/dlc-loop`. This document front-loads all human judgment so the AI can execute Phase 0–6 without interruption. Every decision the AI would normally ask about should be answered here.

---

## Project Identity

**Project Name:** *<!-- TODO: Your project name -->*
**Repository:** *<!-- TODO: Git URL or local path -->*
**Owner:** *<!-- TODO: Who owns the outcome -->*
**Date:** *<!-- TODO: YYYY-MM-DD -->*

---

## What to Build

<!-- TODO: Describe the end state. What does "done" look like? Be specific — the AI will use this as its north star. -->

### Goals

<!-- TODO: 3-5 bullet points. What must be true when the loop completes? -->

1. <!-- TODO -->
2. <!-- TODO -->
3. <!-- TODO -->

### Non-Goals

<!-- TODO: What is explicitly OUT of scope? This prevents scope creep during autonomous execution. -->

1. <!-- TODO -->
2. <!-- TODO -->

---

## Acceptance Criteria

<!-- TODO: Measurable criteria the AI uses to verify completion. These replace human verification gates. -->

| # | Criterion | Measurement | Threshold |
|---|-----------|-------------|-----------|
| AC-1 | <!-- TODO: e.g., All tests pass --> | <!-- TODO: e.g., pytest exit code --> | <!-- TODO: e.g., 0 --> |
| AC-2 | <!-- TODO: e.g., Code coverage --> | <!-- TODO: e.g., coverage report --> | <!-- TODO: e.g., ≥80% --> |
| AC-3 | <!-- TODO: e.g., Zero critical security findings --> | <!-- TODO: e.g., five-persona-review --> | <!-- TODO: e.g., 0 critical, 0 high --> |
| AC-4 | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |

---

## Architecture Decisions (Pre-Approved)

<!-- TODO: Decisions the AI can make without asking. These replace judgment gates. -->

| Decision | Choice | Rationale |
|----------|--------|-----------|
| <!-- TODO: e.g., Database --> | <!-- TODO: e.g., PostgreSQL --> | <!-- TODO: e.g., Team expertise --> |
| <!-- TODO: e.g., Auth pattern --> | <!-- TODO: e.g., JWT + refresh tokens --> | <!-- TODO: e.g., Existing infrastructure --> |
| <!-- TODO: e.g., Test framework --> | <!-- TODO: e.g., pytest --> | <!-- TODO: e.g., Project standard --> |

---

## Constraints

<!-- TODO: Hard limits the AI must respect during execution. -->

### Technical Constraints

- <!-- TODO: e.g., Must run on Python 3.11+ -->
- <!-- TODO: e.g., Must use existing database schema where possible -->
- <!-- TODO: e.g., No new external dependencies without documented justification -->

### Process Constraints

- <!-- TODO: e.g., Feature branches only — do not push to main -->
- <!-- TODO: e.g., All commits must pass lint + type check -->
- <!-- TODO: e.g., Do not modify CI/CD pipeline -->

### Budget Constraints

- <!-- TODO: e.g., No new infrastructure costing >$50/month -->
- <!-- TODO: e.g., Use existing AWS account and VPC -->

---

## Risk Boundaries

<!-- TODO: Define what the AI should do when it encounters risk. -->

| Risk Category | Autonomous Action | Halt Condition |
|---------------|-------------------|----------------|
| Test failure | Fix and retry (up to 3 attempts) | 3+ consecutive failures on same test |
| Security finding (Critical) | Fix immediately | Cannot fix without architecture change |
| Security finding (High) | Fix or create backlog item | More than 5 High findings accumulated |
| Dependency vulnerability | Upgrade if patch available | Major version upgrade required |
| Scope creep detected | Log and defer to backlog | Feature requirement is ambiguous |
| Build failure | Diagnose and fix | Failure in unrelated subsystem |

---

## Phase-Specific Guidance

<!-- TODO: Pre-approved decisions for each DLC phase. Remove phases you want to skip. -->

### Phase 0 — Foundation

- **Governance model:** <!-- TODO: solo-ai | small-team | enterprise -->
- **Skip if:** <!-- TODO: e.g., Project already initialized with AI-DLC -->

### Phase 1 — Inception

- **Requirements source:** <!-- TODO: e.g., This mission brief | existing PRD at docs/requirements.md -->
- **Architecture approach:** <!-- TODO: e.g., Monolith | Microservices | Serverless -->
- **Skip if:** <!-- TODO: e.g., Architecture already documented -->

### Phase 2 — Elaboration

- **Specification depth:** <!-- TODO: minimal | standard | detailed -->
- **Five Questions:** <!-- TODO: Use pre-approved decisions above — do not ask -->
- **Skip if:** <!-- TODO: e.g., User stories already exist in docs/pm/ -->

### Phase 3 — Construction

- **Bolt size:** <!-- TODO: S (1-2h) | M (2-4h) | L (4-8h) -->
- **Branch strategy:** <!-- TODO: e.g., feature branches from main -->
- **Test strategy:** <!-- TODO: e.g., Unit + integration, no e2e for MVP -->

### Phase 4 — Hardening

- **Review depth:** <!-- TODO: full (12-persona) | standard (5-persona) | quick (3-persona) -->
- **Security scan:** <!-- TODO: yes | skip for internal tools -->
- **Skip if:** <!-- TODO: e.g., Internal tool with no external exposure -->

### Phase 5 — Operations

- **Deployment target:** <!-- TODO: e.g., AWS Lambda | Docker on EC2 | Heroku -->
- **Skip if:** <!-- TODO: e.g., Library/framework project with no runtime -->

### Phase 6 — Evolution

- **Always runs** — captures learnings, updates context, extracts patterns

---

## Pre-Existing Assets

<!-- TODO: List anything the AI should find and build upon, not create from scratch. -->

| Asset | Location | Status |
|-------|----------|--------|
| <!-- TODO: e.g., Existing API --> | <!-- TODO: e.g., src/api/ --> | <!-- TODO: e.g., Working, extend it --> |
| <!-- TODO: e.g., Database schema --> | <!-- TODO: e.g., migrations/ --> | <!-- TODO: e.g., Use as-is --> |
| <!-- TODO: e.g., Design mockups --> | <!-- TODO: e.g., docs/designs/ --> | <!-- TODO: e.g., Follow exactly --> |

---

## Communication Preferences

<!-- TODO: How should the AI report progress? -->

- **Progress updates:** <!-- TODO: e.g., Write to .dlc-state/progress.log after each phase -->
- **Completion report:** <!-- TODO: e.g., Write to .dlc-state/completion-report.md -->
- **Error handling:** <!-- TODO: e.g., Halt and write to .dlc-state/error.json -->

---

## Sign-Off

<!-- TODO: This is your authorization for autonomous execution. -->

**Authorized by:** *<!-- TODO: Your name -->*
**Date:** *<!-- TODO: YYYY-MM-DD -->*
**Scope:** *<!-- TODO: e.g., Full DLC loop, Phases 0-6 | Phases 3-4 only -->*
**Trust level:** *<!-- TODO: 0 (New) | 1 (Established) | 2 (Trusted) | 3 (Autonomous) -->*

> By signing this Mission Brief, I authorize the AI to execute the specified DLC phases autonomously, halting only at the defined risk boundaries above.
