# Phase 3: Construction — Bolt-Driven Development

> **Phase Summary:** Build the system through disciplined, time-boxed units of work called bolts. Every code change ships with tests. Every decision is logged. Metrics track velocity and quality in real time. The human drives requirements and approvals; the AI drives implementation and testing.

---

## Purpose

Phase 2 (Elaboration) produced validated specifications, user stories, and a traceability matrix. Phase 3 converts those specifications into working, tested code through a repeatable cadence of bolt cycles. This is where the system takes shape — but under discipline, not chaos.

Construction in AI-DLC is not "tell the AI to build it and hope for the best." It is a structured process where every unit of work is planned, sized, executed, reviewed, and retrospected. The bolt cadence ensures that progress is measurable, decisions are documented, and quality never takes a back seat to speed.

---

## Entry Criteria

Complete all of the following before starting Phase 3:

- [ ] Phase 2 (Elaboration) exit criteria satisfied
- [ ] User stories exist with acceptance criteria in Given-When-Then format
- [ ] Technical specification approved for all components
- [ ] Traceability matrix initialized (REQ -> Story -> Spec columns populated)
- [ ] Test strategy defined (unit, integration, e2e coverage targets)
- [ ] Development environment provisioned and validated
- [ ] Context file (CLAUDE.md) updated with Phase 2 decisions
- [ ] Human sign-off on Phase 2 deliverables recorded
- [ ] CI/CD pipeline skeleton operational (at minimum: lint + test on commit)

---

## Activities

### 1. What Is a Bolt?

A **bolt** is the fundamental unit of work in AI-DLC Construction. It is a focused, time-boxed chunk of development work — typically 1 to 4 hours — with a defined scope, measurable output, and built-in reflection.

The term "bolt" comes from the idea of fastening: each bolt attaches one piece of the system to the structure, secure and tested before moving to the next.

#### Bolt Properties

| Property | Description |
|----------|-------------|
| **Scope** | One user story or a clearly bounded subset of a story |
| **Duration** | 1-4 hours (T-shirt sized) |
| **Output** | Working code + passing tests + captain's log entry |
| **Cadence** | Plan -> Build -> Review -> Retro |
| **Traceability** | Updates the traceability matrix with Code Path and Test ID |

#### What a Bolt Is NOT

- A bolt is not an open-ended exploration session. If the scope is unclear, return to [Phase 2](PHASE-2-ELABORATION.md) for a Five Questions cycle.
- A bolt is not a sprint. Sprints are team-level containers. A bolt is a single-developer, single-session unit.
- A bolt is not measured in story points. Bolts use T-shirt sizes.
- A bolt does not end without tests. Untested code is unfinished code.

### 2. Bolt Cadence: Plan, Build, Review, Retro

Every bolt follows the same four-step cadence. No exceptions.

```
┌────────────────────────────────────────────────────────┐
│                    BOLT CADENCE                         │
│                                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌────────┐ │
│  │  PLAN    │─>│  BUILD   │─>│  REVIEW  │─>│ RETRO  │ │
│  │ 10-15min │  │ 1-3 hrs  │  │ 15-20min │  │ 5-10min│ │
│  └──────────┘  └──────────┘  └──────────┘  └────────┘ │
│                                                         │
│  Scope &       Code &        Verify &      Log &       │
│  acceptance    tests         quality       learn        │
└────────────────────────────────────────────────────────┘
```

#### Plan (10-15 minutes)

1. Select the next user story from the prioritized backlog
2. Confirm the acceptance criteria are still accurate (requirements may have evolved)
3. Identify the technical spec section that covers this story
4. Declare the bolt scope: "This bolt will implement US-XXX, specifically [bounded description]"
5. Assign a T-shirt size (see sizing section below)
6. If size is XL, split before proceeding — do not start an XL bolt

**Plan output checklist:**
- [ ] User story ID identified
- [ ] Acceptance criteria reviewed and confirmed
- [ ] Spec section referenced
- [ ] Scope statement written (1-2 sentences)
- [ ] T-shirt size assigned
- [ ] No blockers identified (or blockers flagged — see Blocker Management)

#### Build (1-3 hours)

1. Implement the code changes according to the specification
2. Write tests alongside the code (test-paired development — see below)
3. Run the full test suite before declaring build complete
4. Commit code with a descriptive message referencing the story ID

**Build discipline rules:**
- Write the test first or alongside the implementation, never after
- Commit frequently (at least once per hour of build time)
- If you discover a spec gap during build, stop and flag it — do not improvise
- If the bolt exceeds its time box by more than 50%, stop and split

**Commit message format:**
```
[US-XXX] Brief description of change

- Detail 1
- Detail 2

Bolt: B-NNN | Size: M | Tests: +3
```

#### Review (15-20 minutes)

1. Run the complete test suite — all tests must pass
2. Run the linter — no new warnings
3. Review the diff: does the code match the specification?
4. Check acceptance criteria: does every criterion have a corresponding test?
5. Update the traceability matrix with Code Path and Test ID
6. If the bolt touches security-sensitive code, flag it for Phase 4 hardening review

**Review checklist:**
- [ ] All tests pass
- [ ] No new linter warnings
- [ ] Code matches specification (no drift)
- [ ] Every acceptance criterion has a test
- [ ] Traceability matrix updated
- [ ] Security-sensitive changes flagged

#### Retro (5-10 minutes)

1. Write a captain's log entry (see Captain's Log section below)
2. Record what went well, what was surprising, and what to change
3. Update the context file (CLAUDE.md) if the bolt revealed new patterns, constraints, or decisions
4. Update the bolt metrics dashboard

**Retro output:**
- [ ] Captain's log entry written
- [ ] Context file updated (if needed)
- [ ] Metrics dashboard updated

### 3. T-Shirt Sizing

AI-DLC uses T-shirt sizes instead of story points. Story points introduce false precision and invite gaming. T-shirt sizes are honest about uncertainty.

#### Size Definitions

| Size | Duration | Scope | Examples |
|------|----------|-------|---------|
| **S** | 1-2 hours | Single function, single test file, config change | Add input validation to one endpoint, write unit tests for a utility module |
| **M** | 2-4 hours | One component, multiple test files | Implement an API endpoint with request/response handling and tests |
| **L** | 4-8 hours | Multiple components, integration tests | Build a service with database access, API layer, and integration tests |
| **XL** | 8+ hours | **Must be split before starting** | Full feature spanning multiple services — break into S/M/L bolts |

#### Sizing Rules

1. **If it is XL, split it.** No bolt should exceed 8 hours. Break XL items into multiple bolts of size S, M, or L.
2. **When in doubt, size up.** A bolt estimated as S that turns into M is normal. A bolt estimated as S that turns into L indicates a spec gap — return to Phase 2.
3. **Track accuracy.** Record estimated vs. actual size. If estimates are consistently wrong in one direction, recalibrate.
4. **Size includes tests.** A "2-hour implementation" that needs 2 hours of tests is a size M (4 hours total), not a size S.

#### Sizing Decision Tree

```
Is the scope clear and bounded?
├── No  → Return to Phase 2 for Five Questions
└── Yes
    ├── Touches one function/file? → S (1-2h)
    ├── Touches one component? → M (2-4h)
    ├── Touches multiple components? → L (4-8h)
    └── Touches multiple services/systems? → XL → SPLIT IT
```

### 4. The Bolt Metrics Dashboard

Track these four metrics for every bolt. Review the dashboard at the end of each day and at each phase checkpoint.

#### Core Metrics

| Metric | What It Measures | Target | Warning Signal |
|--------|-----------------|--------|---------------|
| **Commits** | Development velocity and granularity | 3+ per bolt | < 1 per bolt (monolithic commits) |
| **Test Delta** | Test coverage growth per bolt | Positive every bolt | Zero or negative (tests removed without justification) |
| **Deploys** | Integration and delivery frequency | 1+ per day (to staging/dev) | 0 deploys for 3+ days |
| **Blocked %** | Percentage of bolt time spent blocked | < 10% | > 25% (systemic blockers) |

#### Dashboard Format

```markdown
# Bolt Metrics — [Project Name]

## Current Phase: Construction (Phase 3)
## Date Range: [Start] — [Current]

| Bolt ID | Story | Size Est | Size Actual | Commits | Test Delta | Deploy? | Blocked Min | Notes |
|---------|-------|----------|-------------|---------|------------|---------|-------------|-------|
| B-001   | US-001 | M       | M           | 4       | +5         | Yes     | 0           | Clean bolt |
| B-002   | US-002 | S       | M           | 3       | +3         | Yes     | 15          | Spec gap on error handling |
| B-003   | US-003 | L       | L           | 6       | +8         | Yes     | 0           | Split from XL |
| B-004   | US-003 | M       | M           | 4       | +4         | Yes     | 0           | Second half of split |

## Cumulative
- **Total Bolts:** 4
- **Total Commits:** 17
- **Total Test Delta:** +20
- **Total Deploys:** 4
- **Average Blocked %:** 2.3%
- **Size Accuracy:** 75% (3/4 matched estimate)
```

#### Metric Interpretation

| Pattern | Diagnosis | Action |
|---------|-----------|--------|
| Commits dropping per bolt | Scope creep or fatigue | Split bolts smaller, take breaks |
| Test delta flat or negative | Testing discipline eroding | Enforce test-paired rule, review in retro |
| Deploys stalling | CI/CD issues or merge conflicts | Fix pipeline, reduce branch lifetime |
| Blocked % rising | Dependency issues or unclear specs | Escalate blockers, return to Phase 2 for spec gaps |
| Size estimates consistently wrong | Sizing calibration off | Review sizing decision tree, adjust team baseline |

### 5. Captain's Log

The captain's log is a decision journal written during or after each bolt. It captures the context that the traceability matrix cannot: *why* decisions were made, *what* alternatives were considered, and *what* surprised you.

#### Captain's Log Format

```markdown
## Captain's Log — Bolt B-NNN

**Date:** YYYY-MM-DD
**Story:** US-XXX
**Bolt Size:** M (estimated) / M (actual)

### Objective
[What this bolt set out to accomplish — 1-2 sentences]

### Decisions Made
- **Decision:** [What was decided]
  **Alternatives considered:** [What else was on the table]
  **Rationale:** [Why this option won]

### Assumptions Validated
- [Assumption from Phase 2 that was confirmed or refuted during implementation]

### Surprises
- [Anything unexpected: library behavior, performance, complexity]

### Technical Debt Introduced
- [Any shortcuts taken, with justification and planned remediation]
- [If none: "No new technical debt."]

### Next Bolt Preview
- [What comes next and any setup needed]
```

#### When to Write Captain's Logs

| Situation | Log Required? | Detail Level |
|-----------|---------------|-------------|
| Every bolt (retro step) | Yes | Standard format above |
| Major decision during build | Yes — write immediately | Focus on Decisions Made section |
| Spec gap discovered | Yes — write immediately | Focus on Surprises and link to Phase 2 |
| Blocker encountered | Yes — write immediately | Document blocker, workaround, and resolution |
| End of day (multiple bolts) | Optional — summary log | Roll up key decisions and metrics |

#### Log Storage

Store captain's logs in a dedicated directory within the project:

```
project/
├── docs/
│   └── captains-log/
│       ├── 2024-01-15-B001-user-login.md
│       ├── 2024-01-15-B002-magic-link.md
│       └── 2024-01-16-B003-session-mgmt.md
```

Name format: `YYYY-MM-DD-BNNN-brief-description.md`

### 6. Human-AI Responsibility Matrix

Construction succeeds when the human and AI each focus on what they do best. This matrix defines the responsibility split.

#### Responsibility Assignment

| Activity | Human | AI | Notes |
|----------|-------|----|-------|
| **Requirements** | Owns | Advises | Human decides *what* to build |
| **Prioritization** | Owns | Suggests | Human decides *what order* |
| **Architecture decisions** | Approves | Proposes | AI proposes, human has final say |
| **Implementation** | Reviews | Owns | AI writes code, human reviews |
| **Test writing** | Reviews | Owns | AI writes tests, human validates coverage |
| **Test-to-spec alignment** | Validates | Implements | Human confirms tests match acceptance criteria |
| **Code review** | Owns | Self-reviews first | AI does first pass, human does final review |
| **Documentation** | Reviews | Owns | AI writes docs, human validates accuracy |
| **Deployment** | Owns | Assists | Human triggers deployment, AI prepares artifacts |
| **Blocker resolution** | Decides | Researches | AI finds options, human chooses |
| **Captain's log** | Reviews | Drafts | AI drafts, human adds context and approves |
| **Context file updates** | Approves | Proposes | AI suggests updates, human validates |
| **Security-sensitive changes** | Approves | Flags | AI flags security implications, human reviews |
| **Scope changes** | Decides | Flags | AI identifies scope creep, human adjudicates |

#### Escalation Protocol

When the AI encounters a situation outside its responsibility:

1. **Flag immediately** — do not silently make a human-level decision
2. **Provide options** — present 2-3 alternatives with trade-offs
3. **State a recommendation** — the AI should have an opinion, but the human decides
4. **Document the decision** — record in the captain's log once the human responds

### 7. Blocker Management Protocol

Blockers kill velocity. Manage them aggressively.

#### Blocker Classification

| Type | Description | Examples | Resolution Target |
|------|-------------|----------|-------------------|
| **Technical** | Implementation obstacle | Library bug, API incompatibility, environment issue | Same bolt |
| **Specification** | Unclear or missing requirements | Ambiguous acceptance criteria, missing edge case | Return to Phase 2 |
| **Dependency** | Waiting on external input or system | Third-party API access, credential provisioning | Flag and switch bolts |
| **Decision** | Requires human judgment | Architecture trade-off, scope question | Escalate immediately |

#### Blocker Resolution Protocol

```
┌─────────────────────────────────────────────┐
│           BLOCKER ENCOUNTERED                │
│                                              │
│  1. IDENTIFY — What type of blocker?         │
│     ├── Technical → attempt workaround       │
│     ├── Specification → Five Questions cycle  │
│     ├── Dependency → switch to another bolt   │
│     └── Decision → escalate to human          │
│                                              │
│  2. TIME-BOX — Spend max 30 min on           │
│     workaround before escalating              │
│                                              │
│  3. DOCUMENT — Log in captain's log with:     │
│     - Blocker description                     │
│     - Workaround attempted                    │
│     - Resolution or escalation path           │
│     - Time lost                               │
│                                              │
│  4. CONTINUE — Switch to unblocked bolt       │
│     if resolution is pending                  │
└─────────────────────────────────────────────┘
```

#### Blocker Tracking Table

Maintain this table in the project documentation:

```markdown
| Blocker ID | Bolt | Type | Description | Status | Time Lost | Resolution |
|------------|------|------|-------------|--------|-----------|------------|
| BLK-001 | B-002 | Specification | Error handling for invalid tokens unspecified | Resolved | 15 min | Five Questions cycle added to spec |
| BLK-002 | B-005 | Dependency | Waiting for staging database credentials | Open | 45 min | Switched to B-006, escalated to ops |
```

### 8. Context File Maintenance Strategy

The context file (CLAUDE.md) is a living document. During Construction, it grows with every bolt as new patterns, constraints, and decisions are discovered.

#### Growth Pattern

```
Phase 0-1: Foundation
├── Project identity
├── Repository structure
└── Conventions

Phase 2: Elaboration
├── Architecture decisions
├── Validated assumptions (from Five Questions)
└── Key design patterns

Phase 3: Construction (grows most here)
├── Implementation patterns discovered
├── Library-specific gotchas
├── Testing patterns
├── Environment-specific notes
├── Performance baselines
└── Known limitations
```

#### When to Update the Context File

| Trigger | What to Add | Example |
|---------|-------------|---------|
| New library adopted | Usage pattern, version, known issues | "Using Zod 3.22 for validation. Must call `.parse()` not `.validate()`" |
| Surprising behavior discovered | Documentation of the behavior and workaround | "PostgreSQL JSONB queries require explicit cast for array containment" |
| Pattern established | Reusable pattern description | "All API handlers follow: validate -> authorize -> execute -> respond" |
| Decision with future impact | The decision and its rationale | "Chose eventual consistency for notification delivery — see ADR-005" |
| Environment-specific constraint | The constraint and how to work with it | "CI runner has 2GB RAM limit — mock heavy dependencies in tests" |

#### Context File Hygiene Rules

1. **Keep it current.** Outdated context is worse than no context — the AI will follow stale instructions.
2. **Keep it concise.** The context file is not a wiki. If a section exceeds 20 lines, link to a separate document.
3. **Organize by section.** Use consistent headers so the AI can find relevant context quickly.
4. **Review weekly.** At the end of each week during Construction, review the context file for accuracy.
5. **Remove resolved items.** Temporary workarounds that are fixed should be removed, not left to confuse future sessions.

### 9. Test-Paired Development

Test-paired development is not optional. It is a mandate: **every code change must have corresponding tests.**

#### The Rule

```
No code change ships without a test that:
1. Did not exist before this bolt
2. Would fail without the code change
3. Validates at least one acceptance criterion
```

#### Test-Paired Workflow

```
┌───────────────────────────────────────────────────┐
│         TEST-PAIRED DEVELOPMENT FLOW               │
│                                                     │
│  1. Read acceptance criterion                       │
│  2. Write test that validates the criterion          │
│  3. Run test → confirm it FAILS (red)               │
│  4. Write implementation                             │
│  5. Run test → confirm it PASSES (green)             │
│  6. Refactor if needed                               │
│  7. Run full suite → confirm no regressions          │
│  8. Repeat for next criterion                        │
└───────────────────────────────────────────────────┘
```

#### Test Coverage Targets

| Test Type | Target | Rationale |
|-----------|--------|-----------|
| **Unit tests** | 80%+ line coverage | Catch logic errors in individual functions |
| **Integration tests** | Critical paths covered | Validate component interactions |
| **End-to-end tests** | Happy path + top 3 error paths | Validate user-facing behavior |

#### What "Test Delta" Means in Metrics

Test delta is the net change in test count per bolt:

- **Positive delta:** New tests added (expected for every bolt)
- **Zero delta:** No tests added — this bolt failed the test-paired mandate
- **Negative delta:** Tests removed — acceptable only if the corresponding feature was removed; otherwise flag for review

#### Test Quality Standards

Tests must be:
- **Deterministic** — Same input, same result, every time. No flaky tests.
- **Independent** — Each test runs in isolation. No test depends on another test's side effects.
- **Fast** — Unit tests complete in milliseconds. Integration tests complete in seconds. E2E tests under 2 minutes for the full suite.
- **Descriptive** — Test names describe the behavior being validated, not the implementation.

Good test names:
```
test_login_with_valid_credentials_returns_session_token
test_login_with_expired_magic_link_returns_401
test_rate_limiter_blocks_after_five_failed_attempts
```

Bad test names:
```
test_login
test_error
test_function_works
```

### 10. Multi-Agent Execution Model

Complex construction work benefits from specialized AI agents. Match the agent's specialization to the task for higher quality and efficiency.

#### Agent Taxonomy for Construction

| Agent Type | Specialization | When to Use |
|------------|---------------|-------------|
| **Builder** | Code implementation and test writing | Default for most bolt work |
| **Reviewer** | Five-persona review, code analysis | Post-bolt review, security-sensitive changes |
| **Scout** | Research, debugging, dependency analysis | Blocker investigation, library evaluation |
| **Scribe** | Documentation, captain's logs | Retro step, runbook generation |

#### Smart Model Routing

Not every construction task requires the same model capability. Route tasks to the appropriate tier:

| Tier | Task Examples | Routing Guidance |
|------|---------------|-----------------|
| **Lightweight** | Boilerplate, formatting, simple refactoring, log writing | Fastest model; minimize cost and latency |
| **Standard** | Feature implementation, test writing, standard code review | Default for most construction work |
| **Complex** | Security-sensitive code, complex debugging, architecture-impacting changes | Most capable model; correctness over speed |

#### Mandatory Delegation Rules

Delegate to a specialist agent when:

- The task requires a **different skill profile** (e.g., security review during construction)
- The task would benefit from a **fresh context window** (long sessions degrade quality)
- The task is **independent** and can run in parallel with current work
- A **dedicated review** is needed (reviewer agent for security-sensitive changes)

Handle directly when the task is within the current agent's specialization and requires loaded context.

See the [Autonomous Execution Guide](../reference/AUTONOMOUS-EXECUTION-GUIDE.md) for the complete agent taxonomy and delegation framework.

### 11. The Ascent as Construction Discipline

The Ascent is the persistence loop that ensures every bolt is verified complete before proceeding. It replaces the common "generate and declare done" pattern with a verification cycle.

```
IMPLEMENT → VERIFY → CHECK CRITERIA → All met? → YES → COMPLETE
                                         │
                                         NO → Fix and return to IMPLEMENT
```

#### Ascent Rules During Construction

1. **Never declare a bolt complete without running the full test suite.** Not just the new tests — all tests.
2. **Check every acceptance criterion explicitly.** Do not assume passing tests imply all criteria are met.
3. **Verify no regressions.** Adjacent components may break when new code is added.
4. **Exit only on verified completion, blocker escalation, or time-box split.** "Mostly works" is not an exit condition.

See the [Autonomous Execution Guide](../reference/AUTONOMOUS-EXECUTION-GUIDE.md) for the complete Ascent pattern.

### 12. Trust-Adaptive Review

Review ceremony scales with earned trust and risk tier. New projects start with full ceremony; mature projects with strong track records earn reduced ceremony for normal-risk work.

| Trust Level | Review Ceremony | Applies When |
|-------------|----------------|-------------|
| Level 0 (New) | Every diff reviewed in detail | First 5 bolts of a new project or team |
| Level 1 (Established) | Review at phase transitions + major decisions | 5+ bolts with consistent quality |
| Level 2 (Trusted) | Review at phase transitions, spot-check construction | 20+ bolts with minimal rework |
| Level 3 (Autonomous) | Review at human decision gates only | Extended track record, mature context |

**Risk tier override:** Security-critical work (Tier 1) always receives full ceremony regardless of trust level. See the [Autonomous Execution Guide](../reference/AUTONOMOUS-EXECUTION-GUIDE.md) for trust level definitions and risk tier overrides.

---

## Deliverables

| Deliverable | Format | Template / Reference |
|-------------|--------|---------------------|
| Working, tested code | Source code + test files | Project-specific |
| Bolt metrics dashboard | Markdown table | (Format defined above) |
| Captain's logs | Markdown per bolt | (Format defined above) |
| Updated traceability matrix | Markdown table | [TRACEABILITY-MATRIX.md](../../templates/TRACEABILITY-MATRIX.md) |
| Updated context file | CLAUDE.md | [CLAUDE-CONTEXT.md](../../templates/CLAUDE-CONTEXT.md) |
| Blocker tracking log | Markdown table | (Format defined above) |

---

## Exit Criteria

Complete all of the following before advancing to [Phase 4: Hardening](PHASE-4-HARDENING.md):

- [ ] All user stories from Phase 2 are implemented
- [ ] Every user story has passing tests that validate its acceptance criteria
- [ ] Test coverage meets or exceeds targets (80%+ unit, critical paths integration, happy path + errors e2e)
- [ ] All tests pass in CI/CD pipeline (not just locally)
- [ ] Traceability matrix fully populated (REQ -> Story -> Spec -> Code -> Test)
- [ ] No open blockers of type "Specification" or "Decision"
- [ ] Captain's logs written for every bolt
- [ ] Bolt metrics dashboard is current and reviewed
- [ ] Context file reviewed and current
- [ ] No known critical bugs (all critical issues resolved or documented with mitigation)
- [ ] Human has reviewed cumulative code changes and approves

---

## Human Decision Gates

Phase 3 requires explicit human approval at these points:

### Gate 3A: Bolt Prioritization
- **When:** Start of each bolt (Plan step)
- **What:** Human confirms which story to work on next
- **Why:** Priority may have shifted due to stakeholder feedback, market changes, or dependency resolution
- **Fail action:** Reprioritize backlog before proceeding

### Gate 3B: Scope Change Approval
- **When:** AI identifies that a bolt requires work outside its declared scope
- **What:** Human approves scope expansion or decides to split into additional bolts
- **Why:** Uncontrolled scope growth turns M bolts into XL bolts and erodes predictability
- **Fail action:** Constrain scope to original declaration, log the additional work as a new story

### Gate 3C: Phase Exit Approval
- **When:** All user stories are implemented and tested
- **What:** Human reviews cumulative progress — code, tests, metrics, logs — and approves transition to Hardening
- **Why:** "All stories done" is necessary but not sufficient. Human must verify that the system is ready for hardening review.
- **Fail action:** Identify gaps, schedule additional bolts, re-evaluate

---

## Templates

Use these templates during Phase 3:

| Template | Purpose | Link |
|----------|---------|------|
| PM Framework | Project management structure for bolt tracking | [PM-FRAMEWORK.md](../../templates/PM-FRAMEWORK.md) |
| Solo AI Workflow Guide | Detailed solo+AI development workflow | [SOLO-AI-WORKFLOW-GUIDE.md](../../templates/SOLO-AI-WORKFLOW-GUIDE.md) |
| Traceability Matrix | Continue populating with Code and Test columns | [TRACEABILITY-MATRIX.md](../../templates/TRACEABILITY-MATRIX.md) |

---

## Pillar Checkpoints

Each pillar has specific Phase 3 activities. Complete these before exiting the phase.

### Security Pillar Checkpoint

| Check | Action | Evidence |
|-------|--------|----------|
| Input validation implemented | All user inputs validated against spec constraints | Tests cover invalid input cases |
| Authentication/authorization enforced | Auth checks present on every protected endpoint | Tests verify unauthorized access is denied |
| Secrets management | No secrets in code or config files; all from secrets store | Grep for API keys, passwords returns zero results |
| Dependency vulnerabilities | Run dependency vulnerability scan | Scan report with zero critical/high findings |
| Security-sensitive bolts flagged | All bolts touching auth, crypto, data access flagged for Phase 4 | Bolt log includes security flags |

See [Security Pillar](../pillars/PILLAR-SECURITY.md) for full guidance.

### Quality Pillar Checkpoint

| Check | Action | Evidence |
|-------|--------|----------|
| Test coverage targets met | Coverage report generated | 80%+ unit, critical path integration, e2e happy + error |
| No flaky tests | All tests pass 10 consecutive runs | CI/CD pass rate 100% over last 10 runs |
| Linting clean | Zero warnings from configured linter | Linter report |
| Code review complete | Human has reviewed all code changes | Review approvals recorded |
| Technical debt documented | All shortcuts logged in captain's logs with remediation plan | Captain's log entries reference debt items |

See [Quality Pillar](../pillars/PILLAR-QUALITY.md) for full guidance.

### Traceability Pillar Checkpoint

| Check | Action | Evidence |
|-------|--------|----------|
| Matrix fully populated | Every row has REQ, Story, Spec, Code Path, and Test ID | No blank cells in matrix |
| No orphan code | Every code file traces to a user story | No code changes outside the matrix |
| No orphan tests | Every test traces to an acceptance criterion | No tests without story linkage |
| Status updated | All matrix rows show "Implemented" or "Tested" | No rows stuck at "Specified" |

See [Traceability Pillar](../pillars/PILLAR-TRACEABILITY.md) for full guidance.

### Cost Awareness Pillar Checkpoint

| Check | Action | Evidence |
|-------|--------|----------|
| Cost instrumentation added | Cost-sensitive operations instrumented with tracking | Logging/metrics present in code |
| Resource limits configured | Compute, storage, and API rate limits set | Configuration files or IaC templates |
| Cost estimate updated | Actual usage compared to Phase 2 estimate | Updated cost estimate document |
| Kill switches implemented | Ability to disable expensive features without redeployment | Kill switch configuration tested |

See [Cost Awareness Pillar](../pillars/PILLAR-COST.md) for full guidance.

---

## Phase Transitions

```
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│   Phase 2:       │     │   Phase 3:       │     │   Phase 4:       │
│   ELABORATION    │────>│   CONSTRUCTION   │────>│   HARDENING      │
│                  │     │                  │     │                  │
│ User Stories     │     │ Bolt cadence     │     │ Security audit   │
│ Tech Spec        │     │ Test-paired dev  │     │ Ops readiness    │
│ Traceability     │     │ Captain's logs   │     │ Performance      │
│ Validation gates │     │ Metrics tracking │     │ Cost controls    │
└──────────────────┘     └──────────────────┘     └──────────────────┘
       ▲                        │
       │                        │
       └── Return here if       │
           spec gaps found ─────┘
```

**Returning to Phase 2 from Construction:** When a bolt reveals a specification gap, do not improvise. Stop the bolt, write a captain's log entry documenting the gap, run a targeted Five Questions cycle in Phase 2, update the specification and traceability matrix, then resume Construction with a new bolt.

**Advancing to Phase 4:** Construction completion means "all features built and tested." It does not mean "production ready." Phase 4 (Hardening) addresses security audits, operational readiness, performance tuning, and cost controls. Do not skip Hardening just because the code works.

### Execution Mode Selection

Select the execution mode that matches the current work:

| Mode | When to Use | Gate Frequency |
|------|-------------|---------------|
| **The Ascent** | Most bolt work — single focused task | Per-bolt verification |
| **Orchestrated** | Complex bolts requiring multiple specializations | Per-delegation checkpoint |
| **Parallel** | Multiple independent bolts with no shared state | Per-agent, then integration check |
| **Manual** | High-risk work or unfamiliar domain | Every step |

See the [Autonomous Execution Guide](../reference/AUTONOMOUS-EXECUTION-GUIDE.md) for detailed mode selection guidance and transition criteria.

---

## Anti-Patterns

Avoid these common mistakes during Construction:

| Anti-Pattern | Symptom | Remedy |
|-------------|---------|--------|
| Mega-bolt | A bolt runs 12+ hours with no commit | Split into S/M/L bolts. Commit hourly minimum. |
| Test-later | "I'll write tests after the feature is done" | Enforce test-paired development. No exceptions. |
| Silent improvisation | AI encounters an unclear spec and guesses | Stop, flag, run Five Questions. Never guess on requirements. |
| Captain's log skipping | "I'll remember the decisions I made" | No you will not. Write the log during the retro step. |
| Context file rot | CLAUDE.md not updated for weeks | Review weekly. Stale context causes repeated mistakes. |
| Metric theater | Metrics tracked but never reviewed | Review dashboard daily. Act on warning signals. |
| Scope creep acceptance | "While I'm here, I'll also add..." | Declare scope in Plan step. Anything outside scope is a new bolt. |
| Monolithic commits | One commit per bolt with 500 changed lines | Commit every logical unit. Minimum 3 commits per M-sized bolt. |
| Flaky test tolerance | "That test only fails sometimes" | Fix or delete flaky tests immediately. They erode trust in the suite. |

---

## Worked Example: A Construction Day

### Morning — Bolt B-007 (Size M, estimated 3 hours)

**Plan (10 min):**
- Story: US-005 — "As a user, I want to reset my password via email so that I can regain access to my account."
- Acceptance criteria reviewed: 4 criteria covering happy path, expired link, invalid token, and rate limiting.
- Spec section: auth-spec#password-reset
- Scope: Implement password reset endpoint, email trigger, and token validation.
- Size: M

**Build (2.5 hours):**
- Commit 1: Add password reset request endpoint with input validation
- Commit 2: Add token generation and email dispatch (using managed email service)
- Commit 3: Add token validation and password update endpoint
- Commit 4: Add rate limiting (5 reset requests per hour per email)
- Tests written: 7 new tests (4 acceptance criteria + 3 edge cases)

**Review (15 min):**
- All 7 tests pass. Full suite: 47 tests, all pass.
- Linter: 0 new warnings.
- Diff reviewed against auth-spec#password-reset: matches.
- Traceability matrix updated: US-005 -> Code: `src/auth/password-reset.ts` -> Tests: `tests/auth/password-reset.test.ts`

**Retro (10 min):**
- Captain's log: Noted that the email service SDK has a 10-second timeout default that should be reduced to 3 seconds. Updated context file.
- Metrics: B-007 | US-005 | M est / M actual | 4 commits | +7 tests | Deploy: yes | Blocked: 0 min

### Afternoon — Bolt B-008 (Size S, estimated 1.5 hours)

**Plan (10 min):**
- Story: US-006 — "As a user, I want to see my active sessions so that I can revoke unauthorized access."
- Scope: Implement session list endpoint.
- Size: S

**Build (1 hour):**
- Commit 1: Add session list endpoint with pagination
- Commit 2: Add session revocation endpoint
- Tests written: 4 new tests

**Blocker encountered (15 min):**
- The specification does not define what "active session" means — is it sessions with activity in the last 30 minutes, or all non-expired sessions?
- Blocker type: Specification
- Action: Flagged for human decision. In the meantime, implemented both interpretations behind a configuration flag.
- Resolution: Human confirms "all non-expired sessions." Removed the configuration flag and updated the spec.

**Review (10 min):**
- All tests pass. Full suite: 51 tests.
- Traceability matrix updated.

**Retro (5 min):**
- Captain's log: Documented the "active session" ambiguity and resolution. Noted: in future, define temporal terms explicitly in Phase 2.
- Metrics: B-008 | US-006 | S est / S actual | 2 commits | +4 tests | Deploy: yes | Blocked: 15 min

### End of Day — Dashboard Update

| Bolt ID | Story | Size Est | Size Actual | Commits | Test Delta | Deploy? | Blocked Min |
|---------|-------|----------|-------------|---------|------------|---------|-------------|
| B-007   | US-005 | M       | M           | 4       | +7         | Yes     | 0           |
| B-008   | US-006 | S       | S           | 2       | +4         | Yes     | 15          |

**Daily totals:** 2 bolts, 6 commits, +11 tests, 2 deploys, 15 min blocked (3.4%)

---

## Related Documents

- **Previous Phase:** [Phase 2: Elaboration](PHASE-2-ELABORATION.md)
- **Next Phase:** [Phase 4: Hardening](PHASE-4-HARDENING.md)
- **Pillars:** [Security](../pillars/PILLAR-SECURITY.md) | [Quality](../pillars/PILLAR-QUALITY.md) | [Traceability](../pillars/PILLAR-TRACEABILITY.md) | [Cost Awareness](../pillars/PILLAR-COST.md)
- **Governance:** [Solo + AI](../governance/SOLO-AI.md) | [Small Team](../governance/SMALL-TEAM.md) | [Enterprise](../governance/ENTERPRISE.md)
- **Templates:** [PM-FRAMEWORK.md](../../templates/PM-FRAMEWORK.md) | [SOLO-AI-WORKFLOW-GUIDE.md](../../templates/SOLO-AI-WORKFLOW-GUIDE.md) | [TRACEABILITY-MATRIX.md](../../templates/TRACEABILITY-MATRIX.md)
- **Reference:** [Bolt Metrics Guide](../reference/BOLT-METRICS-GUIDE.md) | [Glossary](../reference/GLOSSARY.md) | [Audit Scoring](../reference/AUDIT-SCORING.md) | [Autonomous Execution Guide](../reference/AUTONOMOUS-EXECUTION-GUIDE.md)
