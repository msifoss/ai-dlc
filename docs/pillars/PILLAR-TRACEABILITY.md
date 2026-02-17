# Pillar: Traceability

**Cross-cutting concern active in ALL phases of the AI Development Life Cycle.**

Traceability is the ability to follow any artifact — requirement, story, line of code, test, deployment — forward or backward through the entire development chain. Without traceability, you cannot answer: *Why does this code exist? What requirement does this test validate? What changed in this release?*

This pillar defines the artifacts, practices, and workflows that maintain an unbroken chain from intent to production.

---

## Table of Contents

1. [Traceability Matrix](#traceability-matrix)
2. [Git as Audit Trail](#git-as-audit-trail)
3. [Captain's Logs as Decision Records](#captains-logs-as-decision-records)
4. [PM Artifacts](#pm-artifacts)
5. [Traceability in Practice](#traceability-in-practice)
6. [Phase-by-Phase Traceability Activities](#phase-by-phase-traceability-activities)
7. [Anti-Patterns](#anti-patterns)
8. [Templates and Cross-References](#templates-and-cross-references)

---

## Traceability Matrix

The traceability matrix is the core artifact mapping the full chain from requirement to deployment.

### The Chain

```
REQ-001 → US-001 → SPEC-001 → module/file.py → TEST-001 → DEPLOY-v1.0
   │         │          │            │               │            │
Requirement  User     Technical    Source          Test        Release
             Story    Spec Section  Code           Case        Tag
```

### Matrix Template

| Req ID | User Story | Spec Section | Module / File | Test ID(s) | Deploy Version | Status |
|--------|-----------|--------------|---------------|------------|----------------|--------|
| REQ-001 | US-001 | SPEC-001 Sec 3.1 | `src/auth/login.py` | TEST-001, TEST-002 | v1.0.0 | Deployed |
| REQ-002 | US-003 | SPEC-002 Sec 4.2 | `src/api/billing.py` | TEST-010, TEST-011 | v1.1.0 | In Test |
| REQ-003 | US-005, US-006 | SPEC-003 Sec 5.1 | `src/notify/email.py` | TEST-020 | — | In Dev |
| REQ-004 | US-008 | SPEC-004 Sec 6.3 | — | — | — | Specified |
| REQ-005 | — | — | — | — | — | Backlog |

**Column Definitions:**
- **Req ID**: Unique identifier assigned during [Phase 1: Inception](../framework/PHASE-1-INCEPTION.md). One requirement may map to multiple stories.
- **Spec Section**: Reference in the technical spec from [Phase 2: Elaboration](../framework/PHASE-2-ELABORATION.md).
- **Module / File**: Source file(s) implementing this requirement. Use relative paths from project root.
- **Test ID(s)**: Unit, integration, and e2e test case identifiers.
- **Deploy Version**: Semantic version tag of the release containing this requirement.
- **Status**: One of `Backlog`, `Specified`, `In Dev`, `In Test`, `Deployed`, `Deprecated`.

### Maintaining the Matrix

Update at every phase transition and during significant development milestones:

- [ ] **Phase 1 exit**: All requirements have IDs. Req ID column populated.
- [ ] **Phase 2 exit**: User stories and spec sections linked.
- [ ] **Phase 3 (per bolt)**: Code files and test IDs linked as each bolt completes.
- [ ] **Phase 4 exit**: All rows have test IDs. No gaps in the chain.
- [ ] **Phase 5 (per release)**: Deploy version column updated for each release.
- [ ] **Phase 6**: Deprecated requirements marked. New requirements added from evolution insights.

### Coverage Metrics

| Metric | Formula | Target |
|--------|---------|--------|
| Requirement coverage | Rows with tests / Total rows | 100% |
| Implementation coverage | Rows with code / Specified rows | 100% at Phase 3 exit |
| Deployment coverage | Deployed rows / Tested rows | 100% at Phase 5 exit |
| Orphan tests | Tests not linked to any requirement | 0 |
| Orphan code | Code files not linked to any requirement | 0 |

---

## Git as Audit Trail

Git is not just version control — it is your legal audit trail. Every commit, tag, and branch tells the story of what changed, when, why, and by whom.

### Atomic Commits

Write one commit per logical change. If you need the word "and" in your message, split the commit.

```bash
# Good — one logical change per commit
git commit -m "feat(auth): add JWT token refresh endpoint"
git commit -m "test(auth): add token refresh integration tests"

# Bad — multiple unrelated changes in one commit
git commit -m "add token refresh, fix billing bug, update README"
```

### Semantic Commit Messages

Use conventional commit format to make the audit trail machine-readable:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

| Type | When to Use | Example |
|------|------------|---------|
| `feat` | New feature or capability | `feat(api): add user search endpoint` |
| `fix` | Bug fix | `fix(auth): resolve token expiration race condition` |
| `docs` | Documentation changes | `docs(readme): update deployment instructions` |
| `test` | Adding or updating tests | `test(billing): add edge case for zero-amount invoice` |
| `refactor` | Code change that neither fixes nor adds | `refactor(db): extract query builder utility` |
| `chore` | Build, tooling, dependency updates | `chore(deps): upgrade fastapi to 0.104.0` |
| `security` | Security-related change | `security(auth): rotate compromised API keys` |
| `perf` | Performance improvement | `perf(query): add index on user_email column` |
| `ci` | CI/CD pipeline changes | `ci: add staging deployment workflow` |

**Footer conventions** — link commits to requirements and bolts:

```bash
feat(auth): add JWT token refresh endpoint

Implements REQ-001, US-001.
Bolt: bolt-012
```

### Tags for Releases

Use semantic versioning for all release tags. Annotated tags preserve the tagger and message:

```bash
git tag -a v1.0.0 -m "Release v1.0.0: initial production deployment

Includes: REQ-001 through REQ-012
Bolt range: bolt-001 through bolt-025
Security review: PASSED (0 critical, 0 high)
Cost controls: kill switch tested"
```

### Branch Naming Conventions

```
main                    # Production-ready code
develop                 # Integration branch (if using gitflow)
feature/US-001-login    # Feature branches tied to user stories
bugfix/BUG-042-timeout  # Bug fix branches tied to bug IDs
hotfix/SEC-003-xss      # Emergency fixes tied to security findings
release/v1.2.0          # Release preparation branches
```

Include the artifact ID (US-xxx, BUG-xxx, SEC-xxx) in the branch name. Delete branches after merge. Protect `main` with required reviews and passing CI.

---

## Captain's Logs as Decision Records

Captain's logs capture the decisions, context, and rationale that exist only in the developer's head (or the AI conversation). Without them, future developers must reverse-engineer intent from code.

### Format

```markdown
# Captain's Log — YYYY-MM-DD

## Bolt: bolt-NNN

**Context:** What situation prompted this decision?
**Decision:** What was decided?
**Rationale:** Why this approach over alternatives?
**Alternatives Considered:**
1. Alternative A — rejected because...
2. Alternative B — rejected because...
**Traceability:** REQ-xxx, US-xxx
**Outcome:** What happened after implementation? (filled in retrospectively)
```

### Example Entry

```markdown
# Captain's Log — 2026-02-15

## Bolt: bolt-014

**Context:** The billing module needs currency conversion for international
customers. The API currently assumes USD only.

**Decision:** Use Open Exchange Rates API with a 1-hour cache, falling back
to last-known rates if the API is unavailable.

**Rationale:** Building our own rate service adds complexity without value.
The 1-hour cache balances accuracy with cost (free tier: 1,000 req/month).
Fallback ensures billing never blocks on an external dependency.

**Alternatives Considered:**
1. Real-time rates per transaction — rejected: too expensive, too fragile.
2. Daily batch rate update — rejected: stale rates cause billing disputes.
3. Fixed rates updated manually — rejected: operational burden, error-prone.

**Traceability:** REQ-007, US-012
**Outcome:** Cache hit rate ~98%. Zero billing disputes in first 30 days.
```

### When to Write Captain's Logs

- [ ] Every bolt (planning decisions, implementation choices)
- [ ] Every significant architectural decision
- [ ] Every time you choose between two or more valid approaches
- [ ] Every time you deviate from the spec or plan
- [ ] Every time you discover something unexpected
- [ ] Every security-related decision

### Storage and Organization

Store in the `captain-logs/` directory at project root, named `YYYY-MM-DD-<bolt-id-or-topic>.md`:

```
captain-logs/
├── 2026-01-15-bolt-001.md
├── 2026-01-16-bolt-003.md
├── 2026-02-01-architecture-decision.md
└── 2026-02-15-bolt-014.md
```

### Captain's Logs vs ADRs

| Dimension | Captain's Log | Architecture Decision Record (ADR) |
|-----------|--------------|-------------------------------------|
| Frequency | Every bolt, every significant decision | Major architectural decisions only |
| Formality | Informal, narrative | Structured, formal |
| Author | Individual developer or AI pair | Team consensus |
| Scope | Single bolt or decision | System-wide impact |
| Audience | Future self, future team | Current and future architects |

Use captain's logs as the default. Promote to a formal ADR when the decision has system-wide architectural impact.

---

## PM Artifacts

Three project management artifacts maintain sprint-level traceability.

### BACKLOG.md — All Work Items Not Yet Scheduled

```markdown
| ID | Type | Summary | Priority | Size | Req Link | Added |
|----|------|---------|----------|------|----------|-------|
| WI-015 | Feature | Email notification preferences | Medium | M | REQ-009 | 2026-02-01 |
| WI-016 | Bug | Timeout on large file upload | High | S | REQ-003 | 2026-02-05 |
| WI-017 | Tech Debt | Refactor database connection pool | Low | L | — | 2026-02-10 |
| WI-018 | Security | Rate limiting on auth endpoints | Critical | M | SEC-005 | 2026-02-12 |
```

Every item links to a requirement (REQ-xxx), bug (BUG-xxx), or security finding (SEC-xxx). Size using T-shirt sizes: S (< 1 bolt), M (1-2 bolts), L (3-5 bolts), XL (> 5 bolts).

### CURRENT-SPRINT.md — Active Bolt/Sprint Items

```markdown
# Current Sprint: Sprint 4 (2026-02-10 to 2026-02-21)
## Sprint Goal: Complete billing module and deploy to staging.

| Bolt | Work Item | Assignee | Status | Started | Completed |
|------|-----------|----------|--------|---------|-----------|
| bolt-014 | WI-010 | dev-1 + AI | Done | 02-10 | 02-10 |
| bolt-015 | WI-011 | dev-1 + AI | In Progress | 02-11 | — |
| bolt-016 | WI-012 | dev-2 + AI | Not Started | — | — |
```

### SPRINT-LOG.md — Completed Sprint Records with Metrics

```markdown
## Sprint 3 (2026-01-27 to 2026-02-07)
**Goal:** Complete authentication module.
**Result:** Goal met. All auth requirements deployed to staging.

| Metric | Value |
|--------|-------|
| Bolts planned / completed | 6 / 5 |
| Bolts carried over | 1 (WI-009, re-estimated as L) |
| Tests added | 34 |
| Security findings | 2 (0 critical, 1 high, 1 medium) |
| Captain's logs written | 5 |

**Retrospective:** Bolt estimation accurate for S/M, underestimated for L.
Five Questions pattern caught 3 assumption errors before implementation.
```

---

## Traceability in Practice

### Tracing a Bug Fix Backward (Root Cause)

When a bug is reported, trace backward through the chain:

```
1. Bug reported → "Users receive duplicate billing emails"
2. Find related test → TEST-011 exists but misses concurrent case → GAP
3. Find spec section → SPEC-002 Sec 4.2 covers it, but concurrency omitted
4. Find user story → US-003: "single clear invoice email"
5. Find requirement → REQ-002: "deduplicate billing notifications"
   Root cause: requirement and spec exist, but test coverage gap
```

### Flowing a Fix Forward (Resolution)

Once root cause is identified, flow the fix forward:

```
1. Requirement → REQ-002 still valid, no change needed
2. User story → US-003 still valid, no change needed
3. Spec → SPEC-002 Sec 4.2: add concurrency handling subsection
4. Code → src/billing/email.py: add idempotency key
5. Tests → TEST-011a (concurrent generation), TEST-011b (idempotency)
6. Deploy → v1.1.1 bug fix release; update traceability matrix
```

### Tracing a New Feature Forward (Greenfield)

```
1. Requirement → REQ-010: "Support multi-currency billing"
2. User stories → US-020 (customer sees local currency), US-021 (admin configures)
3. Spec → SPEC-005 Sec 8.1: Currency conversion service design
4. Code → bolt-018: src/billing/currency.py, bolt-019: src/api/currency_endpoints.py
5. Tests → TEST-050 through TEST-058
6. Deploy → v1.2.0; traceability matrix row complete
```

---

## Phase-by-Phase Traceability Activities

### Phase 0: Foundation
- [ ] Initialize `captain-logs/` directory
- [ ] Create BACKLOG.md, CURRENT-SPRINT.md, SPRINT-LOG.md from templates
- [ ] Create traceability matrix file (empty template)
- [ ] Establish commit message conventions in CLAUDE.md
- [ ] Configure branch protection rules

### Phase 1: Inception
- [ ] Assign unique IDs to all requirements (REQ-001, REQ-002, ...)
- [ ] Populate the Req ID column in the traceability matrix
- [ ] Write captain's logs for architecture decisions
- [ ] Log initial backlog items in BACKLOG.md

### Phase 2: Elaboration
- [ ] Link user stories to requirements in the matrix
- [ ] Link spec sections to user stories in the matrix
- [ ] Verify every requirement has at least one user story
- [ ] Write captain's logs for specification decisions

### Phase 3: Construction
- [ ] Update the matrix per bolt: add code file and test ID columns
- [ ] Write a captain's log for every bolt
- [ ] Include requirement IDs in commit message footers
- [ ] Update CURRENT-SPRINT.md as bolts progress
- [ ] Move completed items to SPRINT-LOG.md at sprint boundaries

### Phase 4: Hardening
- [ ] Verify 100% requirement coverage (all matrix rows have tests)
- [ ] Verify all security findings (SEC-xxx) are linked to fixes
- [ ] Run a full matrix audit: identify and close gaps
- [ ] Confirm all code paths trace back to a requirement

### Phase 5: Operations
- [ ] Update Deploy Version column for each release
- [ ] Tag releases with annotated git tags listing included requirements
- [ ] Write captain's logs for deployment decisions and incidents
- [ ] Link runbook entries to the modules and requirements they support

### Phase 6: Evolution
- [ ] Mark deprecated requirements in the matrix
- [ ] Add new requirements discovered through operations
- [ ] Extract patterns from captain's logs into reusable guidance
- [ ] Conduct traceability audit: verify all links still resolve

---

## Anti-Patterns

| Anti-Pattern | Symptom | Fix |
|-------------|---------|-----|
| **Phantom requirements** | Code exists with no requirement link | Assign a requirement ID or delete the code |
| **Orphan tests** | Tests pass but validate nothing traceable | Link to a requirement or mark as exploratory |
| **Commit soup** | Multi-concern commits with vague messages | Enforce atomic commits via pre-commit hooks |
| **Log-free bolts** | Bolts complete with no captain's log | Make log writing part of the bolt definition of done |
| **Stale matrix** | Matrix not updated since Phase 2 | Assign matrix update as a per-bolt checklist item |
| **Branch graveyard** | Dozens of unmerged, unnamed branches | Enforce naming conventions; delete after merge |
| **Decision amnesia** | Nobody remembers why a choice was made | Write captain's logs; promote to ADRs when needed |

---

## Templates and Cross-References

### Templates

- [Traceability Matrix Template](../../templates/TRACEABILITY-MATRIX.md) — Copy and populate for your project.
- [PM Framework Template](../../templates/PM-FRAMEWORK.md) — Backlog, sprint, and log templates.

### Cross-References

This pillar applies to every phase:

- [Phase 0: Foundation](../framework/PHASE-0-FOUNDATION.md) — Initialize traceability artifacts
- [Phase 1: Inception](../framework/PHASE-1-INCEPTION.md) — Assign requirement IDs
- [Phase 2: Elaboration](../framework/PHASE-2-ELABORATION.md) — Link stories and specs
- [Phase 3: Construction](../framework/PHASE-3-CONSTRUCTION.md) — Link code and tests per bolt
- [Phase 4: Hardening](../framework/PHASE-4-HARDENING.md) — Audit and close matrix gaps
- [Phase 5: Operations](../framework/PHASE-5-OPERATIONS.md) — Link deployments and incidents
- [Phase 6: Evolution](../framework/PHASE-6-EVOLUTION.md) — Deprecate, add, and audit

### Related Pillars

- [Security Pillar](PILLAR-SECURITY.md) — Security findings (SEC-xxx) flow through the traceability matrix.
- [Quality Pillar](PILLAR-QUALITY.md) — Test coverage metrics derive from the matrix.
- [Cost Awareness Pillar](PILLAR-COST.md) — Cost decisions are recorded in captain's logs.
