# Solo Developer + AI Governance Model

## Overview

The Solo + AI model is the most common and battle-tested AI-DLC governance pattern. One developer owns the entire project. One AI assistant accelerates every phase. No approval queues, no merge conflicts, no coordination overhead — just disciplined execution with persistent context.

This model has been proven in real production deliveries: **25 bolts, 216 tests, 9 days to production.** It works because the feedback loop between human judgment and AI capability is tight, fast, and uninterrupted.

**Choose this model when:**

- One person owns the entire project end-to-end
- You need the fastest possible iteration speed
- The project is a prototype, personal tool, or small production service
- Regulatory requirements do not mandate multi-person review

**Upgrade to [Small Team](SMALL-TEAM.md) when:**

- A second developer starts contributing regularly
- The codebase exceeds what one person can hold in working memory
- You need vacation coverage or bus-factor mitigation

---

## Human-AI Responsibility Split

Every responsibility in the project belongs to either the human or the AI — or both in clearly defined roles. Ambiguity here causes the "nobody checked it" class of defects.

| Responsibility | Human | AI |
|---|---|---|
| Requirements and priorities | **Owner** — decides what to build and in what order | Advisor — suggests gaps, raises edge cases |
| Architecture decisions | **Approver** — makes the final call | Proposer — presents options with trade-offs |
| Implementation | Reviewer — reads, tests, and approves code | **Author** — writes the code |
| Testing | Verifier — confirms tests match intent | **Author** — writes unit, integration, and e2e tests |
| Security review | **Approver** — accepts or rejects findings | Reviewer — conducts 5-persona security review |
| Deployment | **Executor** — runs the deploy command | Guide — generates runbooks and checklists |
| Cost management | **Owner** — sets budgets and approves spend | Monitor — tracks costs and raises alerts |

### Key Principles

1. **The human never delegates judgment.** AI proposes, human disposes. Every architecture decision, every security approval, every deployment trigger requires a conscious human choice.
2. **The AI never waits in silence.** If the AI encounters ambiguity, it asks. If it hits a blocker, it flags immediately. Silence from AI is a bug in the workflow.
3. **Both roles are accountable.** The human is accountable for decisions. The AI is accountable for thoroughness. When a defect reaches production, trace it back: did the human skip a review, or did the AI miss a case?

---

## The Five Questions Pattern

The Five Questions Pattern is the cornerstone of solo+AI elaboration. It prevents the "canary-bug" class of errors — where the AI assumes something wrong in the first bolt and builds on that wrong assumption for the next five bolts until the human notices.

### How It Works

Before ANY implementation, the AI asks 5 clarifying questions about its assumptions. The human's answers build the context file incrementally.

### Rules

1. The AI must ask exactly 5 questions — no more, no fewer
2. Questions must be specific, not generic ("What error format do you want?" not "Any preferences?")
3. Questions must target assumptions the AI is about to act on
4. The human answers concisely — one or two sentences per question
5. The AI incorporates answers into the current bolt AND updates CLAUDE.md if any answer reveals a new convention or decision

### Example Interaction

    Human: Build the authentication module using JWT tokens.

    AI: Before I implement, I have 5 questions:

    1. Should tokens be stored in httpOnly cookies or localStorage?
       (I am assuming httpOnly cookies for security, but localStorage
       simplifies the client code.)

    2. What should the token expiry be? I am planning 15 minutes for
       access tokens and 7 days for refresh tokens.

    3. Should I implement token rotation on refresh, or is a simple
       refresh-and-reissue pattern acceptable?

    4. Where does the user data come from — a database table we need
       to create, or an existing user store?

    5. Should failed login attempts be rate-limited at the application
       layer, or do you handle that at the infrastructure level
       (WAF, API gateway)?

    Human:
    1. httpOnly cookies, yes.
    2. 15 min access, 7 day refresh — good.
    3. Rotate on refresh.
    4. New Postgres table. Use the existing db connection pool.
    5. Application layer. We do not have a WAF yet.

    AI: Got it. I will update CLAUDE.md with these decisions before
    implementing. Starting Bolt B-007: Authentication Module.

### Why It Works

- **5 questions is small enough to answer quickly.** Developers do not skip them.
- **Questions are scoped to the current bolt.** Not a requirements session — just this task.
- **Answers become permanent.** They enter CLAUDE.md and persist across sessions.
- **Wrong assumptions surface before code is written.** One minute of Q&A saves an hour of rework.

### When to Skip It

Skip the Five Questions only when the bolt is a direct continuation of the previous bolt with zero new assumptions. If in doubt, ask the questions.

---

## Blocker Management Protocol

Blockers kill momentum. In solo+AI development, there is no teammate to unblock you — only the AI assistant and your own resourcefulness. Handle blockers fast.

### The Protocol

**Step 1: Identify immediately.** The AI flags the blocker as soon as it encounters resistance. Do not spend 20 minutes trying to force through a wall.

**Step 2: Search for workarounds.** The AI proposes 2-3 alternative approaches that avoid the blocker entirely.

**Step 3: Escalate with options.** If no workaround exists, the AI presents the blocker to the human with clear options:

| Option | Trade-off |
|--------|-----------|
| Workaround A | Slightly less elegant, but ships today |
| Workaround B | Requires a new dependency |
| Defer | Move to a later bolt, mark as tech debt |
| Unblock | Invest time to solve the root cause now |

**Step 4: Human decides.** The developer picks an option. This is a judgment call, not a technical decision.

**Step 5: Log the decision.** Record the blocker, the options considered, and the chosen path in the captain's log. Future-you will want to know why this decision was made.

### Example Blocker Log Entry

    ## Blocker: Third-party OAuth provider rate-limits sandbox API

    **Encountered during:** Bolt B-012 (OAuth integration)
    **Impact:** Cannot run integration tests against the sandbox.

    **Options considered:**
    1. Mock the OAuth responses for testing (fast, but less realistic)
    2. Apply for a higher rate limit (slow, requires vendor approval)
    3. Build a local OAuth stub server (medium effort, reusable)

    **Decision:** Option 1 — mock responses for now. Filed a request for
    higher rate limits as a background task. Will revisit in Phase 4
    hardening if the mocks prove insufficient.

### Common Solo+AI Blockers

| Blocker Type | Typical Resolution |
|---|---|
| Missing API documentation | AI reverse-engineers from examples; human verifies |
| Dependency version conflict | Pin the working version, document in CLAUDE.md |
| Unclear requirement | Apply Five Questions Pattern retroactively |
| Infrastructure access | Log and defer; continue with local development |
| Performance bottleneck | Profile first, optimize second; do not guess |

---

## Captain's Logs as the Journal Layer

Captain's logs are the journal layer of solo+AI development. They capture what happened, why it happened, and what to do next. When you return to a project after a weekend, a vacation, or even a long lunch — the captain's log gets you back to speed in under two minutes.

### Format

Maintain one log per bolt. Use this structure:

    # Captain's Log — Bolt B-{NNN}

    **Date:** YYYY-MM-DD
    **Bolt ID:** B-{NNN}
    **Goal:** One-sentence description of what this bolt set out to accomplish

    ## What Happened
    - Bullet points describing the actual work done
    - Include deviations from the plan

    ## Decisions Made
    - Architecture or design decisions with brief rationale
    - Convention changes

    ## Blockers Hit
    - Blocker description and resolution (or deferral)

    ## What Changed
    - Files created or significantly modified
    - New dependencies added
    - Configuration changes

    ## Next Steps
    - What the next bolt should tackle
    - Open questions to resolve

### Storage

Store captain's logs in the project's decisions directory:

    docs/decisions/
      captain-log-B001.md
      captain-log-B002.md
      captain-log-B003.md
      ...

### Usage Patterns

- **Morning startup:** Read the most recent captain's log before starting work. It replaces the mental context you lost overnight.
- **Session handoff:** When starting a new AI session, point the assistant to the latest captain's log. It provides immediate context.
- **Weekly review:** Scan the week's logs to spot patterns — recurring blockers, scope creep, velocity changes.
- **Retrospectives:** Captain's logs are raw material for [Phase 6: Evolution](../framework/PHASE-6-EVOLUTION.md) retrospectives.

### What Makes a Good Log

| Attribute | Good | Bad |
|---|---|---|
| Specificity | "Added retry logic to S3 upload with exponential backoff (base 2s, max 30s)" | "Fixed upload" |
| Decisions | "Chose PostgreSQL over DynamoDB because we need JOIN queries for the reporting feature" | No decisions recorded |
| Blockers | "Rate limited by Stripe sandbox. Mocked responses for now. Ticket filed." | "Had some issues" |
| Next steps | "B-008 should add error handling for the three failure modes identified in testing" | "Continue working" |

---

## Context File as Institutional Memory

CLAUDE.md is the single most important artifact in solo+AI development. It is the memory that persists across AI sessions, across days, and across context windows. Every decision, every convention, every constraint lives here.

### Structure

Organize the context file in order of importance. AI assistants read from the top — put the highest-signal information first.

    # Project Name — Context File

    ## Project Identity
    - Name, version, license, language, framework
    - One-sentence purpose

    ## What This Project Is
    - 2-3 sentences describing the system
    - What it is NOT (prevents scope creep)

    ## Architecture
    - System diagram or description
    - Key components and their relationships
    - Data flow overview

    ## Conventions
    - File naming patterns
    - Code style rules beyond the linter
    - Commit message format
    - Error handling patterns
    - Logging conventions

    ## Current State
    - What has been built (list of completed bolts)
    - What is in progress
    - What is planned next

    ## Known Issues
    - Bugs awaiting fixes
    - Tech debt items
    - Deferred blockers

    ## Key Decisions
    - Architecture Decision Records (or summaries)
    - Why we chose X over Y

### Update Cadence

| Event | Action |
|---|---|
| Bolt completed | Add any new conventions or decisions |
| Architecture decision made | Record in Key Decisions section |
| Blocker deferred | Add to Known Issues |
| New dependency added | Update Architecture section |
| Convention changed | Update Conventions section |

### Pruning

Prune CLAUDE.md quarterly. Remove:

- References to completed and obsolete work items
- Conventions that are now enforced by linting (no need to state what the linter catches)
- Decisions about components that no longer exist
- Duplicate information

Keep CLAUDE.md between 50 and 200 lines. A bloated context file wastes tokens and dilutes signal. If you need more space, move detailed records to `docs/context/` files and reference them from CLAUDE.md.

### Anti-Patterns

| Anti-Pattern | Why It Hurts | Fix |
|---|---|---|
| Never updating CLAUDE.md | AI makes decisions based on stale context | Update after every bolt |
| Putting everything in CLAUDE.md | Token waste, signal dilution | Keep it focused; use linked docs for details |
| Generic content | "Follow best practices" tells the AI nothing | Be specific: "Use snake_case for database columns" |
| Conflicting information | Old decision contradicts new decision | Prune when updating |

---

## Daily Workflow

The solo+AI daily workflow follows a consistent rhythm. Consistency reduces cognitive overhead and ensures nothing falls through the cracks.

### The Cycle

1. **Wake up and read.** Open the most recent captain's log. Read CLAUDE.md. Reestablish context from where you left off.

2. **Plan the bolt.** Decide what the next bolt will accomplish. Size it (S/M/L). If it is XL, break it down. Write a one-sentence goal.

3. **Start the AI session.** Point the AI to CLAUDE.md. Share the bolt goal. Let the AI ask its Five Questions.

4. **Execute.** The AI writes code. You review. The AI writes tests. You verify. Handle blockers per the protocol.

5. **Review and test.** Run the full test suite. Review the diff. Check for security concerns. Verify the bolt goal was met.

6. **Log.** Write the captain's log entry. Record decisions, blockers, and next steps.

7. **Update context.** Add any new conventions, decisions, or state changes to CLAUDE.md.

8. **Commit.** Make a clean commit with a descriptive message. Tag if this is a milestone.

### Bolt Sizing Guide

| Size | Duration | Scope | Example |
|---|---|---|---|
| S (Small) | < 1 hour | Single function or config change | Add input validation to one endpoint |
| M (Medium) | 1-2 hours | One feature or module component | Build the password reset flow |
| L (Large) | 2-4 hours | Full feature with tests | Implement JWT authentication end-to-end |
| XL (Too Large) | 4+ hours | Break it down | "Build the entire API" — split into auth, CRUD, search, etc. |

### Session Management

- **Start fresh sessions often.** AI context windows degrade over long conversations. Start a new session for each bolt when possible.
- **Front-load context.** Point the AI to CLAUDE.md at the start of every session. Do not assume it remembers anything.
- **End sessions cleanly.** Write the captain's log before closing. Do not leave work in an uncommitted, undocumented state.

---

## Phase-Specific Guidance

The Solo+AI model applies across all AI-DLC phases, but the human-AI dynamic shifts.

### Phase 0: Foundation

- Human drives structure decisions
- AI generates boilerplate (context file, CI config, directory structure)
- Gate: Human reviews the entire foundation before proceeding
- See [Phase 0: Foundation](../framework/PHASE-0-FOUNDATION.md)

### Phase 1: Inception

- AI drafts requirements from human's verbal description
- Human prioritizes and refines
- Five Questions Pattern is critical here — requirements errors are the most expensive
- See [Phase 1: Inception](../framework/PHASE-1-INCEPTION.md)

### Phase 2: Elaboration

- AI proposes architecture options with trade-offs
- Human selects and records decisions as ADRs
- AI elaborates user stories with acceptance criteria
- Human verifies stories match intent
- See [Phase 2: Elaboration](../framework/PHASE-2-ELABORATION.md)

### Phase 3: Construction

- AI authors code and tests (highest AI leverage phase)
- Human reviews every diff and runs the test suite
- Bolt cadence is fastest here — 3-6 bolts per day is typical
- Captain's logs are most valuable during construction sprints
- See [Phase 3: Construction](../framework/PHASE-3-CONSTRUCTION.md)

### Phase 4: Hardening

- AI conducts 5-persona security review
- Human approves or rejects security findings
- AI writes performance tests; human sets acceptable thresholds
- See [Phase 4: Hardening](../framework/PHASE-4-HARDENING.md) and [Security Pillar](../pillars/PILLAR-SECURITY.md)

### Phase 5: Operations

- AI generates runbooks, monitoring dashboards, and alerting rules
- Human executes deployments and responds to incidents
- AI assists with incident diagnosis but human owns the response
- See [Phase 5: Operations](../framework/PHASE-5-OPERATIONS.md)

### Phase 6: Evolution

- AI summarizes captain's logs into retrospective reports
- Human identifies process improvements
- AI helps prune and restructure CLAUDE.md for the next cycle
- See [Phase 6: Evolution](../framework/PHASE-6-EVOLUTION.md)

---

## Security in Solo+AI

Solo developers face a unique security risk: there is no second pair of human eyes. Compensate with structured AI review.

### The 5-Persona Security Review

During [Phase 4: Hardening](../framework/PHASE-4-HARDENING.md), instruct the AI to review the codebase from five distinct security perspectives:

1. **Attacker** — How would I exploit this system?
2. **Auditor** — Does this meet compliance requirements?
3. **Architect** — Are there structural security weaknesses?
4. **User** — Can I accidentally expose my own data?
5. **Operator** — Can I detect and respond to a breach?

The human reviews all five perspectives and decides which findings to address. Record the review and its outcomes in the captain's log.

> See [Security Pillar](../pillars/PILLAR-SECURITY.md) for the complete cross-phase security checklist.

### Minimum Security Practices for Solo+AI

- [ ] Secrets never committed to version control (enforced by pre-commit hook)
- [ ] Dependencies scanned for known vulnerabilities in CI
- [ ] Authentication and authorization logic reviewed by the 5-persona method
- [ ] Input validation on every external boundary
- [ ] HTTPS enforced for all network communication
- [ ] Logging does not capture sensitive data (passwords, tokens, PII)

---

## Cost Management in Solo+AI

Solo developers often run lean. Track costs from the start to avoid surprise bills.

### What to Track

| Cost Category | Tracking Method |
|---|---|
| AI API tokens | Monitor monthly token usage; set billing alerts |
| Cloud compute | Use free tiers where possible; tag resources with project name |
| Cloud storage | Set lifecycle policies; delete unused resources monthly |
| Third-party APIs | Track usage against free-tier limits |
| Domain and certificates | Calendar reminders for renewals |

### AI Token Budget

Set a monthly AI token budget and track against it. A typical solo+AI project consumes:

- **Phase 0-1:** Low token usage (planning, small outputs)
- **Phase 3:** Peak token usage (code generation, test writing)
- **Phase 4-5:** Moderate token usage (reviews, runbooks)

If token costs spike unexpectedly, check for these patterns:

- Overly long context windows (start fresh sessions more often)
- Regenerating the same code repeatedly (improve prompts instead)
- Sending entire files when only diffs are needed

> See [Cost Awareness Pillar](../pillars/PILLAR-COST.md) for the full cross-phase cost checklist.

---

## When Solo+AI Breaks Down

Recognize these warning signs. They indicate it is time to upgrade to the [Small Team](SMALL-TEAM.md) governance model.

### Red Flags

| Signal | What It Means |
|---|---|
| Captain's logs pile up unreviewed | You are moving too fast to reflect. A second person forces review. |
| CLAUDE.md exceeds 200 lines and keeps growing | The project has outgrown one person's mental model. |
| Security review is always "I'll do it later" | Without peer pressure, security slips. A teammate enforces it. |
| You cannot take a day off without anxiety | Bus-factor of one. Another developer provides coverage. |
| Bolt velocity drops despite consistent effort | Complexity has crossed the threshold. Parallelism requires more humans. |
| Production incidents go unnoticed for hours | Solo monitoring has gaps. Shared on-call covers them. |

### Transition Checklist

When upgrading from Solo+AI to Small Team:

- [ ] Convert CLAUDE.md into a shared context file (remove personal preferences)
- [ ] Create personal CLAUDE-{dev}.md files for each developer
- [ ] Namespace captain's logs by developer
- [ ] Set up branch protection requiring PR review
- [ ] Define deploy coordination rules
- [ ] Brief the new developer(s) using CLAUDE.md and recent captain's logs

---

## Quick Reference

### Solo+AI Decision Framework

    Is this a judgment call? -----> Human decides
    Is this a technical task? ----> AI executes, human reviews
    Is this ambiguous? -----------> Five Questions Pattern
    Is this blocked? ------------> Blocker Management Protocol
    Is this done? ---------------> Captain's log, context update, commit

### Files You Maintain

| File | Update Frequency | Owner |
|---|---|---|
| CLAUDE.md | After every bolt | Human (AI drafts updates) |
| Captain's logs | One per bolt | AI drafts, human reviews |
| CHANGELOG.md | Per release | AI drafts, human approves |
| README.md | When public interface changes | Human |

### Pillars Checklist for Solo+AI

- [ ] **Security:** 5-persona review completed per phase — see [Security Pillar](../pillars/PILLAR-SECURITY.md)
- [ ] **Quality:** Tests written for every bolt, linter passing — see [Quality Pillar](../pillars/PILLAR-QUALITY.md)
- [ ] **Traceability:** Captain's logs and context file current — see [Traceability Pillar](../pillars/PILLAR-TRACEABILITY.md)
- [ ] **Cost:** Monthly token and cloud spend reviewed — see [Cost Awareness Pillar](../pillars/PILLAR-COST.md)

---

## Related Documents

- [Phase 0: Foundation](../framework/PHASE-0-FOUNDATION.md) — Where governance model selection happens
- [Small Team Governance](SMALL-TEAM.md) — The next step when you outgrow solo
- [Enterprise Governance](ENTERPRISE.md) — For large teams with compliance requirements
- [Security Pillar](../pillars/PILLAR-SECURITY.md) — Cross-phase security checklist
- [Quality Pillar](../pillars/PILLAR-QUALITY.md) — Cross-phase quality checklist
- [Traceability Pillar](../pillars/PILLAR-TRACEABILITY.md) — Cross-phase traceability checklist
- [Cost Awareness Pillar](../pillars/PILLAR-COST.md) — Cross-phase cost checklist
