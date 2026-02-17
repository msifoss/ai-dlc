# Phase 2: Elaboration — From Architecture to Specification

> **Phase Summary:** Transform the architectural decisions and requirements from Inception into detailed, validated specifications. Use the Five Questions Pattern to surface hidden assumptions. Produce user stories, a technical specification, and an initialized traceability matrix. Validate everything through internal gates before Construction begins.

---

## Purpose

Phase 1 (Inception) produced high-level requirements and architectural direction. Phase 2 converts those into specifications precise enough to build against. The core challenge: traditional elaboration assumes a team debating requirements in a room. Solo+AI development replaces that debate with a structured assumption-surfacing protocol — the Five Questions Pattern.

By the end of this phase, every requirement has a user story, every user story has acceptance criteria, every component has a technical specification, and a traceability matrix links them all together. This is the last phase before code is written. Get it right here, and Construction flows. Get it wrong, and you build the wrong thing fast.

### The Artifact Hierarchy: IDEA → INTENT → UNIT → BOLT

Phase 2 converts high-level IDEAs (from Phase 1) into increasingly detailed artifacts through a four-level hierarchy. Each level refines and validates against its parent, ensuring no requirement is lost or distorted.

```
IDEA (Phase 1)
  └── INTENT (what to achieve, with measurable criteria)
        └── UNIT (testable specification chunk)
              └── BOLT (executable unit of work)
```

| Level | Purpose | Validation | Example |
|-------|---------|------------|---------|
| **IDEA** | Problem statement with business context | Human approval at Phase 1 gate | "Users need to reset passwords securely" |
| **INTENT** | Measurable objective derived from the IDEA | Conformance check against IDEA | "Implement password reset with email verification, rate limiting, and token expiry" |
| **UNIT** | Testable specification chunk with acceptance criteria | Momus + Metis gates | "Token generation: cryptographic token, 15-min expiry, single-use, stored hashed" |
| **BOLT** | Executable work unit with scope, tests, and time box | The Ascent verification loop | "Implement token generation endpoint with 4 tests (happy path, expired, reused, rate-limited)" |

#### Conformance Scoring

Validate each artifact against its parent using conformance scoring:

| Score | Meaning | Action |
|-------|---------|--------|
| 90-100% | Full alignment — child fully addresses parent | Proceed |
| 70-89% | Partial alignment — minor gaps | Address gaps before proceeding |
| 50-69% | Significant gaps — child drifts from parent | Revise child artifact; re-run Five Questions |
| Below 50% | Misalignment — child does not address parent | Reject; return to parent level and re-elaborate |

#### Dual Validation

Every artifact validates in two directions:

1. **Against parent** — Does this UNIT satisfy its INTENT? Does this INTENT satisfy its IDEA?
2. **Against root** — Does this BOLT still serve the original IDEA? (Prevents drift through layers)

If dual validation reveals divergence, stop and realign before proceeding. Drift detected at the BOLT level costs hours to fix. Drift detected at the INTENT level costs days.

#### Dependency Graph Generation

When elaborating INTENTs into UNITs, generate a dependency graph that shows which UNITs must complete before others can begin. This graph drives bolt sequencing in [Phase 3: Construction](PHASE-3-CONSTRUCTION.md).

```markdown
## Dependency Graph: [Feature Name]

UNIT-001: Database schema → No dependencies (start here)
UNIT-002: Token generation → Depends on UNIT-001
UNIT-003: Email dispatch → Depends on UNIT-002
UNIT-004: Reset endpoint → Depends on UNIT-002, UNIT-003
UNIT-005: Rate limiting → Depends on UNIT-004
```

---

## Entry Criteria

Complete all of the following before starting Phase 2:

- [ ] Phase 1 (Inception) exit criteria satisfied
- [ ] Requirements document exists with numbered requirements (REQ-001, REQ-002, ...)
- [ ] At least one Architecture Decision Record (ADR) approved
- [ ] Initial security review completed (threat model draft)
- [ ] Technology stack selected and documented
- [ ] Context file (CLAUDE.md) updated with Phase 1 decisions
- [ ] Human sign-off on Phase 1 deliverables recorded

---

## Activities

### 1. The Five Questions Pattern

The Five Questions Pattern is the signature elaboration technique in AI-DLC. It replaces traditional mob elaboration, design-by-committee, and ambiguous specification documents with a structured assumption-surfacing protocol.

#### How It Works

For each requirement or feature area, the AI generates exactly five questions that expose its assumptions about the implementation. The human validates, corrects, or defers each one. This cycle repeats until no critical assumptions remain unvalidated.

#### The Protocol

```
┌─────────────────────────────────────────────────┐
│              FIVE QUESTIONS CYCLE                │
│                                                  │
│  1. AI reads requirement (REQ-NNN)               │
│  2. AI states 5 assumptions about implementation │
│  3. Human responds: Validate / Correct / Defer   │
│  4. AI updates spec with validated assumptions    │
│  5. Repeat until assumption debt = 0             │
│                                                  │
│  Typical cycles per feature: 2-4                 │
└─────────────────────────────────────────────────┘
```

#### Example: Five Questions for a User Authentication Requirement

Given REQ-003: "The system must support user authentication."

**AI surfaces five assumptions:**

| # | Assumption | Category |
|---|-----------|----------|
| 1 | Authentication uses email + password as the primary credential pair | Functional |
| 2 | Sessions expire after 30 minutes of inactivity | Security |
| 3 | The system stores password hashes using bcrypt with cost factor 12 | Security |
| 4 | OAuth 2.0 social login (Google, GitHub) is out of scope for v1 | Scope |
| 5 | Failed login attempts are rate-limited to 5 per minute per IP | Security |

**Human responds:**

| # | Response | Detail |
|---|----------|--------|
| 1 | **Correct** — Also support magic link authentication | Added to spec |
| 2 | **Validate** — 30 minutes is correct | Confirmed |
| 3 | **Correct** — Use Argon2id instead of bcrypt | Updated |
| 4 | **Correct** — Google OAuth is in scope for v1 | Scope expanded |
| 5 | **Validate** — 5 per minute is correct | Confirmed |

**Result:** Two corrections caught before a single line of code was written. Without this pattern, the AI would have built bcrypt-based, email-only authentication and called it done.

#### Why Five Questions Prevents Canary-Bug Errors

A "canary-bug" is an error that arises from an unstated assumption baked into early implementation. It often goes undetected until production because it matches what the AI "thought" was correct. The Five Questions Pattern forces these assumptions into the open where a human can evaluate them.

**Canary-bug risk indicators:**
- The AI expresses high confidence about an unspecified behavior
- A requirement uses ambiguous terms ("secure," "fast," "scalable") without metrics
- The implementation involves third-party integrations with undocumented contracts
- The feature touches user data, money, or access control

#### When to Apply Five Questions

| Situation | Apply Five Questions? |
|-----------|----------------------|
| New feature with ambiguous requirements | Yes — full cycle |
| Bug fix with clear reproduction steps | No — skip to Construction |
| Infrastructure change (CI/CD, monitoring) | Yes — one cycle minimum |
| Refactoring with no behavior change | No — but document assumptions in captain's log |
| Security-sensitive feature | Yes — require at least 2 cycles |

### 2. PRD Generation with User Stories

After the Five Questions cycles resolve critical assumptions, generate a Product Requirements Document (PRD) containing user stories with acceptance criteria.

#### PRD Structure

```markdown
# Product Requirements Document: [Feature Name]

## Overview
[1-2 paragraph summary of the feature and its business value]

## User Stories

### US-001: [Story Title]
**As a** [role],
**I want to** [action],
**So that** [benefit].

**Acceptance Criteria:**
- [ ] Given [precondition], when [action], then [result]
- [ ] Given [precondition], when [action], then [result]
- [ ] Given [edge case], when [action], then [error handling]

**Priority:** Must-have | Should-have | Nice-to-have
**Size:** S | M | L | XL
**Traces to:** REQ-NNN

### US-002: [Story Title]
...
```

#### User Story Quality Checklist

Every user story must satisfy the INVEST criteria:

| Criterion | Question | Fail Signal |
|-----------|----------|-------------|
| **I**ndependent | Can this story be built without waiting for another? | "Blocked by US-XXX" |
| **N**egotiable | Is the solution flexible, or is it over-specified? | Implementation details in the story |
| **V**aluable | Does it deliver value to a user or the business? | "Refactor internal module" with no user impact |
| **E**stimable | Can the team size it with confidence? | "Build the analytics engine" — too vague |
| **S**mall | Does it fit in one bolt (1-4 hours)? | Size XL — must be split |
| **T**estable | Are acceptance criteria concrete and verifiable? | "System should be fast" — no metric |

#### Acceptance Criteria Format

Write acceptance criteria in Given-When-Then format:

```
Given the user is on the login page
  And has entered a valid email address
When the user clicks "Send Magic Link"
Then the system sends a one-time login link to that email address
  And displays a confirmation message
  And the link expires after 15 minutes
```

Every acceptance criterion must be:
- **Observable** — a human or automated test can verify it
- **Specific** — includes concrete values, not "appropriate" or "reasonable"
- **Bounded** — defines edge cases and error states, not just the happy path

### 3. Technical Specification

The technical specification translates user stories into component designs that the AI can implement during Construction.

#### Technical Specification Format

```markdown
# Technical Specification: [Feature Name]

## Component Overview
[Diagram or description of components and their interactions]

## Component Design

### Component: [Name]
- **Responsibility:** [Single sentence]
- **Interface:**
  - Input: [data type, format, constraints]
  - Output: [data type, format, constraints]
- **Dependencies:** [Other components, services, libraries]
- **Error Handling:** [Strategy: retry, circuit-break, fail-fast]
- **Data Model:** [Schema or structure]

### API Contracts (if applicable)
| Endpoint | Method | Request | Response | Auth |
|----------|--------|---------|----------|------|
| /api/auth/login | POST | { email, password } | { token, expires_at } | None |
| /api/auth/magic-link | POST | { email } | { status } | None |
| /api/auth/verify | GET | ?token=xxx | { user, session } | None |

### Data Model
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| id | UUID | PK, auto-generated | |
| email | string | unique, max 255 | Normalized to lowercase |
| password_hash | string | nullable | Null for magic-link-only users |
| created_at | timestamp | not null | UTC |

### Non-Functional Requirements
- **Latency:** Login response < 500ms at p99
- **Throughput:** Support 100 concurrent authentication requests
- **Availability:** Auth service targets 99.9% uptime
- **Storage:** Estimate 1KB per user record, plan for 100K users in year 1
```

#### Cloud-Neutral Design Guidance

Write specifications in cloud-neutral language. Add cloud-specific implementation notes in sidebars.

| Concern | Cloud-Neutral Term | AWS | Azure | GCP |
|---------|-------------------|-----|-------|-----|
| Object storage | Blob storage | S3 | Blob Storage | Cloud Storage |
| Serverless compute | Function-as-a-Service | Lambda | Functions | Cloud Functions |
| Managed database | Managed relational DB | RDS/Aurora | SQL Database | Cloud SQL |
| Secret management | Secrets store | Secrets Manager | Key Vault | Secret Manager |
| Message queue | Message broker | SQS/SNS | Service Bus | Pub/Sub |

### 4. Traceability Matrix Initialization

Initialize the traceability matrix that will track every requirement through implementation, testing, and deployment. This is a living document that grows throughout Construction and Hardening.

#### Matrix Structure

```markdown
| REQ ID | Requirement | Story ID | Spec Section | Code Path | Test ID | Status |
|--------|-------------|----------|-------------|-----------|---------|--------|
| REQ-001 | User login | US-001 | auth-spec#login | — | — | Specified |
| REQ-002 | Magic link auth | US-002 | auth-spec#magic | — | — | Specified |
| REQ-003 | Session mgmt | US-003 | auth-spec#session | — | — | Specified |
| REQ-004 | Rate limiting | US-004 | auth-spec#ratelimit | — | — | Specified |
```

**Status values during Elaboration:**
- `Identified` — Requirement exists but no story yet
- `Storied` — User story written
- `Specified` — Technical specification complete
- `Deferred` — Intentionally delayed to a future phase or version

**In later phases, status evolves to:**
- `Implemented` — Code written (Phase 3)
- `Tested` — Tests passing (Phase 3)
- `Hardened` — Security and ops review complete (Phase 4)
- `Deployed` — In production (Phase 5)

#### Traceability Rules

1. **Every requirement must trace to at least one user story.** If a requirement has no story, it is either incomplete or should be removed.
2. **Every user story must trace back to a requirement.** Orphan stories indicate scope creep — flag them for human review.
3. **Every technical spec section must trace to at least one user story.** Spec sections with no story are gold-plating — remove them.
4. **Gaps in the matrix are Phase 2 exit blockers.** Do not proceed to Construction with unlinked rows.

### 5. Validation Gates (Momus and Metis Concepts)

Validation gates are internal quality checks that run before the phase exit. They are named after two concepts:

- **Momus Gate (Critic):** Review all specifications for gaps, contradictions, and ambiguities. Attempt to break the spec by asking adversarial questions. "What happens if the user does X while Y is in state Z?"
- **Metis Gate (Wisdom):** Review all specifications for strategic alignment. "Does this specification actually solve the user's problem? Is there a simpler approach we missed?"

#### Momus Gate Checklist

Run this checklist against every technical specification:

- [ ] Every API endpoint has defined error responses, not just success responses
- [ ] Every data model field has constraints (nullable, max length, valid range)
- [ ] Every external dependency has a fallback or degradation strategy
- [ ] Race conditions are addressed for any concurrent operations
- [ ] Edge cases are documented (empty inputs, max limits, Unicode, timezone boundaries)
- [ ] Security assumptions from Five Questions are reflected in the spec
- [ ] Performance targets are stated with specific metrics (p50, p95, p99)
- [ ] Coverage of parent INTENT is >= 90% (conformance score)
- [ ] All user stories have measurable acceptance criteria (no subjective terms)
- [ ] Story count per INTENT is sufficient to cover all specified behaviors

#### Metis Gate Checklist

Run this checklist at the feature level:

- [ ] The specified solution addresses the original requirement, not a mutated version
- [ ] No unnecessary complexity has been introduced ("gold-plating")
- [ ] The component count is justified — could two components be merged?
- [ ] The data model supports likely future requirements without over-engineering
- [ ] The user experience flow is coherent end-to-end, not just per-story
- [ ] Cost implications of the design are understood (see [Cost Awareness Pillar](../pillars/PILLAR-COST.md))
- [ ] Architecture soundness verified — components have clear boundaries and single responsibilities
- [ ] API contracts are explicit with request/response schemas, error codes, and versioning
- [ ] Component separation supports independent testing and deployment

#### Validation Gate Protocol

```
For each specification document:

1. Run Momus Gate checklist → record findings
2. Fix critical findings (severity: high/critical)
3. Document accepted findings (severity: low/medium) with rationale
4. Run Metis Gate checklist → record findings
5. Fix strategic misalignments
6. Human reviews all gate findings and approves or requests changes
```

---

## Deliverables

| Deliverable | Format | Template |
|-------------|--------|----------|
| Five Questions log | Markdown table per feature | (Inline in PRD) |
| Product Requirements Document (PRD) | Markdown | [USER-STORIES.md](../../templates/USER-STORIES.md) |
| Technical Specification | Markdown | (Per-project — use format above) |
| Traceability Matrix (initialized) | Markdown table | [TRACEABILITY-MATRIX.md](../../templates/TRACEABILITY-MATRIX.md) |
| Validation gate findings | Markdown checklist | (Inline in spec) |
| Updated context file | CLAUDE.md | [CLAUDE-CONTEXT.md](../../templates/CLAUDE-CONTEXT.md) |

---

## Exit Criteria

Complete all of the following before advancing to [Phase 3: Construction](PHASE-3-CONSTRUCTION.md):

- [ ] All requirements from Phase 1 have corresponding user stories
- [ ] Every user story has acceptance criteria in Given-When-Then format
- [ ] Technical specification covers all components identified in architecture (Phase 1)
- [ ] Traceability matrix links every REQ to at least one Story and Spec section
- [ ] No gaps in traceability matrix (every row has REQ, Story, and Spec populated)
- [ ] Momus Gate checklist passed for all specifications
- [ ] Metis Gate checklist passed for all features
- [ ] Five Questions cycles completed for every feature area (minimum 1 cycle each)
- [ ] All "Correct" responses from Five Questions are reflected in specifications
- [ ] Context file updated with Phase 2 decisions and validated assumptions
- [ ] Human has reviewed and approved all deliverables

---

## Human Decision Gates

Phase 2 requires explicit human approval at three points:

### Gate 2A: Five Questions Responses
- **When:** During each Five Questions cycle
- **What:** Human validates, corrects, or defers each assumption
- **Why:** The AI cannot validate its own assumptions — this is the human's irreplaceable contribution
- **Fail action:** Do not proceed with the assumption; iterate or escalate

### Gate 2B: PRD Approval
- **When:** After all user stories and acceptance criteria are written
- **What:** Human reviews the PRD for completeness, correctness, and priority
- **Why:** User stories define what gets built — errors here multiply through Construction
- **Fail action:** Revise stories, re-run Five Questions for problem areas

### Gate 2C: Specification Sign-Off
- **When:** After validation gates (Momus and Metis) pass
- **What:** Human reviews technical specification and traceability matrix
- **Why:** The specification is the contract for Construction; ambiguities here become bugs
- **Fail action:** Revise specification, re-run affected validation gates

---

## Templates

Use these templates during Phase 2:

| Template | Purpose | Link |
|----------|---------|------|
| User Stories | Structured user stories with acceptance criteria | [USER-STORIES.md](../../templates/USER-STORIES.md) |
| Traceability Matrix | REQ-to-deployment mapping | [TRACEABILITY-MATRIX.md](../../templates/TRACEABILITY-MATRIX.md) |
| Requirements | Numbered requirements (started in Phase 1, refined here) | [REQUIREMENTS.md](../../templates/REQUIREMENTS.md) |

---

## Pillar Checkpoints

Each pillar has specific Phase 2 activities. Complete these before exiting the phase.

### Security Pillar Checkpoint

| Check | Action | Evidence |
|-------|--------|----------|
| Threat model refined | Update threat model from Phase 1 with component-level threats | Threat model document updated |
| Auth/authz specified | Authentication and authorization mechanisms defined in tech spec | Spec sections reference security requirements |
| Data classification | All data fields classified (public, internal, confidential, restricted) | Data model annotations in tech spec |
| Input validation rules | Every API input has validation rules specified | Spec includes validation constraints |
| Dependency review | Third-party dependencies assessed for known vulnerabilities | Dependency list with risk notes |

See [Security Pillar](../pillars/PILLAR-SECURITY.md) for full guidance.

### Quality Pillar Checkpoint

| Check | Action | Evidence |
|-------|--------|----------|
| Test strategy defined | Types of tests per component (unit, integration, e2e) | Test strategy section in tech spec |
| Acceptance criteria testable | Every AC can be automated | No subjective criteria in stories |
| Code quality standards set | Linting rules, formatting, naming conventions documented | Updated context file or contributing guide |
| Review process defined | Who reviews what (AI self-review + human review) | Documented in PRD or project governance |

See [Quality Pillar](../pillars/PILLAR-QUALITY.md) for full guidance.

### Traceability Pillar Checkpoint

| Check | Action | Evidence |
|-------|--------|----------|
| Matrix initialized | Traceability matrix created with REQ, Story, Spec columns | Matrix document exists |
| No orphan stories | Every story traces to a requirement | Matrix has no blank REQ cells |
| No orphan specs | Every spec section traces to a story | Matrix has no blank Story cells |
| Forward references prepared | Code Path and Test ID columns exist (blank, awaiting Phase 3) | Matrix structure complete |

See [Traceability Pillar](../pillars/PILLAR-TRACEABILITY.md) for full guidance.

### Cost Awareness Pillar Checkpoint

| Check | Action | Evidence |
|-------|--------|----------|
| Cost estimates drafted | Each component has a rough cost estimate | Cost column in tech spec or separate estimate |
| Expensive operations flagged | Operations with per-invocation cost identified | Flagged in spec with cost notes |
| Budget alignment checked | Total estimated cost compared against Phase 1 budget | Comparison documented |
| Cost monitoring points identified | Where to instrument cost tracking in Construction | Listed in tech spec |

See [Cost Awareness Pillar](../pillars/PILLAR-COST.md) for full guidance.

---

## Phase Transitions

```
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│   Phase 1:       │     │   Phase 2:       │     │   Phase 3:       │
│   INCEPTION      │────>│   ELABORATION    │────>│   CONSTRUCTION   │
│                  │     │                  │     │                  │
│ Requirements     │     │ Five Questions   │     │ Bolt-driven      │
│ Architecture     │     │ User Stories     │     │ development      │
│ ADRs             │     │ Tech Spec        │     │ with tests       │
│ Security review  │     │ Traceability     │     │                  │
└──────────────────┘     └──────────────────┘     └──────────────────┘
                              ▲                        │
                              │                        │
                              └── Return here if       │
                                  Construction reveals │
                                  spec gaps ───────────┘
```

**Returning to Phase 2 from Construction:** If Construction reveals that the specification is incomplete or incorrect, return to Phase 2 for a targeted Five Questions cycle on the affected area. Do not treat specification gaps as "just figure it out" during Construction. Update the traceability matrix and re-run validation gates on the affected sections.

---

## Anti-Patterns

Avoid these common mistakes during Elaboration:

| Anti-Pattern | Symptom | Remedy |
|-------------|---------|--------|
| Skipping Five Questions | "The requirements are clear enough" | Requirements are never clear enough. Run at least one cycle. |
| Gold-plating specs | Spec includes implementation details (variable names, exact SQL) | Specify *what* and *why*, not *how*. Leave implementation to Construction. |
| Orphan stories | Stories exist that trace to no requirement | Delete them or add the missing requirement. No ghost features. |
| Vague acceptance criteria | "System should be responsive" | Add metrics: "Response time < 200ms at p95 under 50 concurrent users." |
| Skipping Momus Gate | "We'll catch issues during code review" | Code review catches code bugs. Spec review catches design bugs. They are different. |
| One giant PRD | Single 500-line PRD for the entire system | Split PRDs by feature area. Each should be reviewable in 15 minutes. |
| Assumption debt | Five Questions deferred items pile up without resolution | Resolve deferred items before exiting Phase 2. Defer to Phase 3 only with explicit rationale. |

---

## Worked Example: Elaboration for a Notification Service

### Context
Phase 1 produced REQ-010: "The system must notify users of important events via email and in-app notifications."

### Five Questions Cycle 1

| # | AI Assumption | Human Response |
|---|--------------|----------------|
| 1 | Notifications are fire-and-forget (no delivery guarantee) | **Correct** — Email must have delivery confirmation; in-app can be best-effort |
| 2 | Users cannot configure which notifications they receive | **Correct** — Add notification preferences (per-channel opt-in/out) |
| 3 | Email is sent via SMTP relay, not a managed service | **Correct** — Use a managed email service (e.g., SES, SendGrid, Mailgun) |
| 4 | In-app notifications are pulled on page load, not pushed via WebSocket | **Validate** — Pull on page load is correct for v1 |
| 5 | Notification templates are hardcoded in the application | **Correct** — Use template files that can be updated without redeployment |

### Resulting User Stories

**US-010a:** As a user, I want to receive email notifications for critical events so that I stay informed even when not logged in.

**Acceptance Criteria:**
- [ ] Given a critical event occurs, when the notification service processes it, then an email is sent to the user's registered address within 60 seconds
- [ ] Given the email service is unavailable, when a notification is queued, then the system retries 3 times with exponential backoff
- [ ] Given a user has opted out of email notifications for that event type, when the event occurs, then no email is sent

**US-010b:** As a user, I want to manage my notification preferences so that I only receive notifications I care about.

**Acceptance Criteria:**
- [ ] Given the user navigates to notification settings, when the page loads, then all notification types are listed with per-channel toggles
- [ ] Given the user disables email for "marketing" notifications, when a marketing event fires, then no email is sent but in-app notification still appears
- [ ] Given the user has no preferences set, when any event occurs, then all channels are enabled by default

### Traceability Matrix Entry

| REQ ID | Requirement | Story ID | Spec Section | Code Path | Test ID | Status |
|--------|-------------|----------|-------------|-----------|---------|--------|
| REQ-010 | User notifications | US-010a | notify-spec#email | — | — | Specified |
| REQ-010 | User notifications | US-010b | notify-spec#preferences | — | — | Specified |

---

## Related Documents

- **Previous Phase:** [Phase 1: Inception](PHASE-1-INCEPTION.md)
- **Next Phase:** [Phase 3: Construction](PHASE-3-CONSTRUCTION.md)
- **Pillars:** [Security](../pillars/PILLAR-SECURITY.md) | [Quality](../pillars/PILLAR-QUALITY.md) | [Traceability](../pillars/PILLAR-TRACEABILITY.md) | [Cost Awareness](../pillars/PILLAR-COST.md)
- **Governance:** [Solo + AI](../governance/SOLO-AI.md) | [Small Team](../governance/SMALL-TEAM.md) | [Enterprise](../governance/ENTERPRISE.md)
- **Templates:** [USER-STORIES.md](../../templates/USER-STORIES.md) | [TRACEABILITY-MATRIX.md](../../templates/TRACEABILITY-MATRIX.md) | [REQUIREMENTS.md](../../templates/REQUIREMENTS.md)
- **Reference:** [Glossary](../reference/GLOSSARY.md) | [Audit Scoring](../reference/AUDIT-SCORING.md) | [Autonomous Execution Guide](../reference/AUTONOMOUS-EXECUTION-GUIDE.md)
