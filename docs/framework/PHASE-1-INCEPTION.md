# Phase 1: Inception — From Intent to Architecture

## Purpose

Phase 1 transforms a bootstrapped project into one with clear requirements, architecture decisions, and an initial security posture. It bridges the gap between "I have an idea" and "I have a plan the AI can execute." The deliverables from this phase — numbered requirements, architecture decision records, and a security baseline — become the guardrails that keep [Phase 3: Construction](PHASE-3-CONSTRUCTION.md) on track.

This phase embraces the **build-then-harden philosophy**: working code is a better artifact for review than abstract specifications. Inception produces just enough documentation to guide construction — not exhaustive specs that become stale before the first line of code is written.

---

## Entry Criteria

| Criterion | Description |
|-----------|-------------|
| Phase 0 complete | All [Phase 0: Foundation](PHASE-0-FOUNDATION.md) exit criteria are met |
| Context file exists | CLAUDE.md is filled in with project identity, structure, and conventions |
| Governance model selected | Documented in CLAUDE.md with rationale |
| Tooling operational | Linter, pre-commit hooks, and CI pipeline are passing |
| Intent is articulable | You can describe what the project should do in 2-3 sentences |

---

## Activities

### 1. The IDEA Stage Workflow

Inception follows the IDEA workflow — a structured sequence for moving from intent to actionable plan. Each step produces a concrete artifact.

```
┌───────────┐     ┌───────────┐     ┌───────────┐     ┌───────────┐
│  IDENTIFY │────>│  DEFINE   │────>│  EVALUATE │────>│  APPROVE  │
│           │     │           │     │           │     │           │
│ What are  │     │ Write     │     │ Challenge │     │ Human     │
│ we        │     │ require-  │     │ with      │     │ decides   │
│ building? │     │ ments &   │     │ security  │     │ go/no-go  │
│           │     │ ADRs      │     │ review    │     │           │
└───────────┘     └───────────┘     └───────────┘     └───────────┘
```

#### IDENTIFY: Articulate the Intent

Start by answering these questions. Write the answers in a project brief document or directly in CLAUDE.md.

1. **What problem does this project solve?** Describe the pain point in concrete terms. "Users cannot track expenses across multiple accounts" — not "improve financial management."
2. **Who are the users?** Name specific personas. "Small business owners managing 1-5 bank accounts" — not "financial users."
3. **What does success look like?** Define measurable outcomes. "Users can import transactions from 3 bank formats and categorize them in under 2 minutes" — not "easy to use."
4. **What is out of scope?** Explicitly list what this project will NOT do. This prevents scope creep during construction.
5. **What are the constraints?** Budget, timeline, regulatory, technology, and team limitations.

**Capture these answers in your context file.** They orient the AI for every subsequent session.

#### DEFINE: Write Requirements and ADRs

Transform the intent into numbered requirements (Activity 2) and architecture decisions (Activity 3). These are the core deliverables of Phase 1.

#### EVALUATE: Challenge with Security Review

Run the initial five-persona security review (Activity 5) against the requirements and proposed architecture. This surfaces risks before code exists — when changes are cheapest.

#### APPROVE: Human Decision Gates

Present the requirements, architecture, and security findings for human approval (see Human Decision Gates below). This is the last checkpoint before construction begins.

---

### 2. Requirements Documentation

Write requirements using numbered IDs. Every requirement gets a unique identifier that follows it through the entire lifecycle — from inception through construction, testing, deployment, and operations. This is the foundation of the [Traceability Pillar](../pillars/PILLAR-TRACEABILITY.md).

#### Requirements Format

Use the [templates/REQUIREMENTS.md](../../templates/REQUIREMENTS.md) template. Each requirement follows this structure:

```markdown
### REQ-001: [Short descriptive title]

- **Category:** Functional | Non-Functional | Constraint
- **Priority:** Must Have | Should Have | Nice to Have
- **Source:** [Who requested this — user research, stakeholder, regulatory, etc.]
- **Description:** [1-3 sentences describing what the system must do]
- **Acceptance Criteria:**
  - [ ] [Measurable criterion 1]
  - [ ] [Measurable criterion 2]
- **Dependencies:** [REQ-XXX, or "None"]
- **Notes:** [Additional context, edge cases, or constraints]
```

#### Requirements Numbering Convention

| Prefix | Category | Example |
|--------|----------|---------|
| REQ-0XX | Core functional requirements | REQ-001: User authentication |
| REQ-1XX | Data and storage requirements | REQ-101: Transaction persistence |
| REQ-2XX | Integration requirements | REQ-201: Bank API connectivity |
| REQ-3XX | Non-functional requirements | REQ-301: Response time under 200ms |
| REQ-4XX | Security requirements | REQ-401: Encryption at rest |
| REQ-5XX | Operational requirements | REQ-501: 99.9% uptime SLA |
| REQ-9XX | Constraints | REQ-901: Must run on ARM64 |

This numbering scheme is a recommendation — adapt it to your domain. The critical principle is that every requirement has a stable, unique ID that never changes once assigned.

#### Requirements Writing Guidelines

**Write requirements that are testable.** Every acceptance criterion must be verifiable — either by an automated test, a manual test procedure, or an observable metric.

| Testable | Not Testable |
|----------|-------------|
| "System returns HTTP 200 with JSON body within 200ms for 95th percentile of requests" | "System is fast" |
| "Passwords are hashed with bcrypt using a cost factor of 12 or higher" | "Passwords are stored securely" |
| "User can export data as CSV with UTF-8 encoding" | "User can export data" |
| "System handles 1,000 concurrent connections without error" | "System is scalable" |

**Write requirements at the right altitude.** Phase 1 requirements describe what the system must do, not how it does it. Implementation details belong in [Phase 2: Elaboration](PHASE-2-ELABORATION.md) user stories and technical specs.

| Right Altitude (Phase 1) | Too Low (save for Phase 2) |
|--------------------------|---------------------------|
| "System authenticates users with email and password" | "System uses JWT tokens with RS256 signing stored in httpOnly cookies" |
| "System persists transaction data durably" | "System writes to PostgreSQL 16 with WAL archiving to S3" |
| "System sends notifications for overdue items" | "System uses SQS to queue emails sent via SES with exponential backoff" |

#### Example Requirements Block

```markdown
### REQ-001: User Authentication

- **Category:** Functional
- **Priority:** Must Have
- **Source:** Core product requirement
- **Description:** The system authenticates users with email and password
  before granting access to protected resources.
- **Acceptance Criteria:**
  - [ ] Users can register with email and password
  - [ ] Users can log in with valid credentials
  - [ ] Invalid credentials return a clear error without leaking
        whether the email or password was wrong
  - [ ] Sessions expire after 24 hours of inactivity
- **Dependencies:** None
- **Notes:** OAuth/SSO integration is out of scope for v1 (see constraints).

### REQ-002: Transaction Import

- **Category:** Functional
- **Priority:** Must Have
- **Source:** User research (interviews with 12 small business owners)
- **Description:** Users can import bank transactions from CSV files in
  at least three major bank export formats.
- **Acceptance Criteria:**
  - [ ] System accepts CSV uploads up to 10MB
  - [ ] System parses Chase, Bank of America, and Wells Fargo CSV formats
  - [ ] Import errors identify the failing row and column
  - [ ] Duplicate transactions are detected and flagged (not silently dropped)
- **Dependencies:** REQ-001 (user must be authenticated)
- **Notes:** Additional bank formats added based on user demand post-launch.

### REQ-301: Response Time

- **Category:** Non-Functional
- **Priority:** Must Have
- **Source:** UX benchmark (users abandon tasks after 3 seconds)
- **Description:** API endpoints return responses within acceptable latency
  thresholds under normal load.
- **Acceptance Criteria:**
  - [ ] 95th percentile response time is under 200ms for read operations
  - [ ] 95th percentile response time is under 500ms for write operations
  - [ ] System maintains these thresholds at 100 concurrent users
- **Dependencies:** None
- **Notes:** Load testing protocol defined in Phase 4 hardening.
```

---

### 3. Architecture Decision Records (ADRs)

An ADR documents a significant technical decision, the alternatives considered, and the rationale for the choice. Write an ADR when:

- The decision is difficult to reverse (database choice, authentication strategy, cloud provider)
- The decision affects multiple components or teams
- Future developers (or future AI sessions) will ask "why did we do it this way?"
- You chose against the "obvious" default and need to explain why

**Do not write ADRs for trivial decisions.** "We use Prettier for formatting" does not need an ADR — it goes in CLAUDE.md as a convention. "We use a graph database instead of a relational database" does need an ADR.

#### ADR Format

Store ADRs in `docs/architecture/` with the naming convention `ADR-NNN-short-title.md`.

```markdown
# ADR-001: [Decision Title]

## Status

Proposed | Accepted | Deprecated | Superseded by ADR-XXX

## Context

[Describe the situation that requires a decision. What problem are you
facing? What constraints exist? 2-5 sentences.]

## Decision

[State the decision clearly in one sentence. Then elaborate on the
specifics in 2-5 sentences.]

## Alternatives Considered

### Alternative A: [Name]
- **Pros:** [List]
- **Cons:** [List]
- **Why rejected:** [1-2 sentences]

### Alternative B: [Name]
- **Pros:** [List]
- **Cons:** [List]
- **Why rejected:** [1-2 sentences]

## Consequences

### Positive
- [What becomes easier or better]

### Negative
- [What becomes harder or worse]

### Risks
- [What could go wrong with this decision]

## Requirements Addressed

- REQ-XXX: [How this decision satisfies the requirement]
```

#### Example ADR

```markdown
# ADR-001: Use PostgreSQL for Primary Data Store

## Status

Accepted

## Context

The system must persist user accounts, transactions, and categorization
data. The data is relational (transactions belong to users, categories
have hierarchies). Query patterns include complex filtering, aggregation,
and full-text search across transaction descriptions. Expected data
volume is under 100GB for the first year.

## Decision

Use PostgreSQL 16 as the primary data store. Deploy as a managed service
(RDS, Cloud SQL, or Azure Database for PostgreSQL) to reduce operational
burden. Use the built-in full-text search rather than adding a separate
search service.

## Alternatives Considered

### Alternative A: MongoDB
- **Pros:** Flexible schema, easy to start with
- **Cons:** Poor support for relational queries, eventual consistency by
  default, complex transactions require multi-document ACID (added in 4.0
  but less mature)
- **Why rejected:** Data is inherently relational. Schemaless flexibility
  is a liability for financial data where consistency matters.

### Alternative B: SQLite
- **Pros:** Zero configuration, embedded, fast for reads
- **Cons:** Single-writer limitation, no concurrent access from multiple
  services, limited managed hosting options
- **Why rejected:** System requires concurrent access and will eventually
  need horizontal read scaling.

## Consequences

### Positive
- Mature ecosystem with excellent tooling (pg_dump, pgAdmin, extensions)
- Strong ACID guarantees for financial data
- Built-in full-text search eliminates need for Elasticsearch

### Negative
- Schema migrations require more discipline than schemaless alternatives
- Connection pooling needed at moderate concurrency (use PgBouncer)

### Risks
- If data volume exceeds 1TB, may need partitioning strategy (revisit in
  Phase 6 evolution)

## Requirements Addressed

- REQ-101: Transaction persistence — PostgreSQL provides durable storage
  with ACID guarantees
- REQ-002: Transaction import — bulk COPY command handles CSV import
  efficiently
- REQ-301: Response time — indexed queries on relational data meet
  latency requirements
```

#### When to Write ADRs During Phase 1

Write ADRs for these categories of decisions during inception:

| Decision Category | Examples | Typical Count |
|-------------------|----------|---------------|
| Primary data store | PostgreSQL vs. MongoDB vs. DynamoDB | 1 |
| Authentication strategy | Session-based vs. JWT vs. OAuth2 | 1 |
| API style | REST vs. GraphQL vs. gRPC | 1 |
| Runtime/language | Python vs. Go vs. TypeScript | 1 (if not predetermined) |
| Cloud provider | AWS vs. Azure vs. GCP vs. self-hosted | 1 (if not predetermined) |
| Architecture pattern | Monolith vs. microservices vs. modular monolith | 1 |

Expect 3-6 ADRs from Phase 1. Additional ADRs are written as decisions arise in Phase 2 and Phase 3.

---

### 4. Build-Then-Harden Philosophy

Traditional software development prescribes exhaustive upfront specification: write every requirement in detail, produce UML diagrams, get sign-off, then build. This approach fails with AI-assisted development for three reasons:

1. **AI produces working code faster than humans produce specs.** By the time you finish specifying a module, the AI could have built and tested it.
2. **Working code is a better review artifact than abstract specs.** Reviewing a running prototype reveals issues that no spec ever will — performance characteristics, API ergonomics, edge cases in real data.
3. **Specs become stale immediately.** The AI does not consult a Confluence page mid-generation. It reads the context file and the existing code.

**Build-then-harden means:**

- Write just enough requirements to guide construction (Phase 1 — you are here)
- Elaborate into user stories and technical specs only where complexity demands it ([Phase 2: Elaboration](PHASE-2-ELABORATION.md))
- Build working code in focused bolts ([Phase 3: Construction](PHASE-3-CONSTRUCTION.md))
- Harden the working code with security review, ops readiness, and production hardening ([Phase 4: Hardening](PHASE-4-HARDENING.md))

**Build-then-harden does NOT mean:**

- Skip requirements (you still need REQ-IDs for traceability)
- Skip architecture decisions (wrong database choice is expensive to reverse)
- Skip security thinking (the five-persona review in this phase catches design-level flaws)
- Ship without hardening (Phase 4 exists for a reason)

The key insight: invest in decisions that are expensive to change (architecture, data model, security model) and defer decisions that are cheap to change (UI layout, API field names, log formatting).

```
              EXPENSIVE TO CHANGE              CHEAP TO CHANGE
              ─────────────────────            ─────────────────
              Decide in Phase 1                Decide in Phase 3

              • Database technology             • API field names
              • Authentication model            • UI component library
              • Service boundaries              • Log format
              • Data ownership model            • Error message text
              • Security perimeter              • CSS framework
              • Deployment topology             • Build tool version
```

---

### 5. Initial Five-Persona Security Review

Before exiting Phase 1, run the first five-persona security review against the requirements and architecture decisions. This is a design-level review — no code exists yet. The goal is to surface structural security concerns while changes are still free.

#### The Five Personas

| Persona | Perspective | Key Questions |
|---------|-------------|---------------|
| Attacker | "How do I break this?" | What are the attack surfaces? Where is user input trusted? What happens if authentication is bypassed? |
| Auditor | "Does this meet compliance standards?" | Are data handling practices documented? Is PII identified and protected? Are access controls defined? |
| Ops Engineer | "What fails at 3 AM?" | What happens when the database is unreachable? How are secrets managed? Is there a recovery procedure? |
| Cost Analyst | "What costs spiral?" | Which resources scale with user count? Are there unbounded queries? Is there a cost ceiling? |
| End User | "Is my data safe?" | Can I delete my data? Who else can see it? What happens if my account is compromised? |

#### How to Run the Review

1. Prepare a summary document listing all requirements (REQ-IDs) and architecture decisions (ADRs)
2. For each persona, ask the AI to review the requirements and architecture from that perspective
3. Capture findings as security items with severity ratings

#### Finding Format

```markdown
### SEC-001: [Finding Title]

- **Persona:** Attacker | Auditor | Ops | Cost | User
- **Severity:** Critical | High | Medium | Low | Informational
- **Phase Found:** 1 (Inception)
- **Related Requirements:** REQ-XXX, REQ-YYY
- **Related ADRs:** ADR-NNN
- **Description:** [What the risk is, in concrete terms]
- **Recommendation:** [What to do about it]
- **Resolution Phase:** [Which phase should address this — typically Phase 3 or Phase 4]
```

#### Severity Definitions

| Severity | Definition | Action |
|----------|-----------|--------|
| Critical | Exploitable vulnerability that could lead to data breach or system compromise | Block Phase 2 entry. Redesign before proceeding. |
| High | Significant risk that requires architectural mitigation | Address in Phase 2 elaboration. Track in ADR. |
| Medium | Moderate risk addressable during construction | Capture as requirement. Address in Phase 3. |
| Low | Minor risk or defense-in-depth opportunity | Address in Phase 4 hardening. |
| Informational | Observation, not a risk | Document for awareness. No action required. |

#### Example Findings

```markdown
### SEC-001: No Rate Limiting on Authentication Endpoint

- **Persona:** Attacker
- **Severity:** High
- **Phase Found:** 1 (Inception)
- **Related Requirements:** REQ-001 (User Authentication)
- **Related ADRs:** None yet
- **Description:** The requirements specify authentication with email and
  password but do not address brute-force protection. An attacker could
  attempt thousands of passwords per second against known email addresses.
- **Recommendation:** Add a rate-limiting requirement (e.g., max 5 failed
  attempts per email per 15 minutes). Consider account lockout with
  unlock-by-email for persistent attacks.
- **Resolution Phase:** Phase 2 (add as REQ-4XX security requirement)

### SEC-002: PII Handling Not Specified

- **Persona:** Auditor
- **Severity:** Medium
- **Phase Found:** 1 (Inception)
- **Related Requirements:** REQ-001, REQ-002
- **Related ADRs:** ADR-001 (PostgreSQL)
- **Description:** The system will store email addresses and financial
  transaction data (PII and financial data under various regulations).
  No requirements specify data classification, retention policy, or
  encryption at rest.
- **Recommendation:** Add requirements for data classification (what is
  PII, what is financial data), encryption at rest, and retention policy.
  Review applicable regulations (GDPR if EU users, CCPA if CA users).
- **Resolution Phase:** Phase 2 (add as REQ-4XX requirements)
```

Store all findings in `docs/security/inception-review.md` or use the [templates/SECURITY.md](../../templates/SECURITY.md) template.

> See [Security Pillar](../pillars/PILLAR-SECURITY.md) and [Five-Persona Review](../reference/FIVE-PERSONA-REVIEW.md) for the complete review methodology.

---

## Deliverables

Phase 1 produces the following artifacts. Check each before proceeding.

- [ ] **Requirements document** — all requirements have unique IDs (REQ-NNN), categories, priorities, and testable acceptance criteria
- [ ] **Architecture Decision Records** — 3-6 ADRs covering major technical decisions (data store, auth, API style, architecture pattern)
- [ ] **Security review findings** — initial five-persona review with all findings documented as SEC-NNN items
- [ ] **Updated CLAUDE.md** — context file updated with architecture decisions, key requirements summary, and security baseline
- [ ] **Updated README.md** — project description refined based on requirements analysis

---

## Exit Criteria

| Criterion | Verification |
|-----------|-------------|
| All requirements have unique IDs | Grep for `REQ-` in requirements document — every requirement has an ID |
| Requirements are testable | Review acceptance criteria — each criterion is verifiable by test or observation |
| Core architecture decisions are documented | At least one ADR exists for data store, authentication, and architecture pattern |
| ADRs reference requirements | Each ADR links to the requirements it addresses |
| Five-persona security review is complete | Review document exists with findings from all 5 personas |
| No critical security findings are unresolved | All "Critical" severity items have a resolution plan |
| Context file reflects Phase 1 decisions | CLAUDE.md includes architecture summary and key constraints discovered |
| Human decision gates are passed | All three gates below are approved |

---

## Human Decision Gates

Phase 1 contains three human decision gates.

### Gate 1.1: Architecture Approval

**Decision:** Is the proposed architecture appropriate for the requirements?

**Review:**
- Read all ADRs. Do the decisions fit the problem?
- Check that alternatives were genuinely considered (not just "we picked the popular option")
- Verify that the architecture supports all "Must Have" requirements
- Assess whether the architecture is overengineered for the project's scale

**Questions to ask:**
- Can we build an MVP with this architecture in the planned timeline?
- What is the most expensive decision to reverse if we are wrong?
- Does this architecture handle the expected scale (not 100x the expected scale)?

**Record:** Mark ADRs as "Accepted" after approval.

### Gate 1.2: Data Flow Approval

**Decision:** Is the data flow secure and appropriate?

**Review:**
- Trace how user data enters, moves through, and exits the system
- Identify every point where data crosses a trust boundary (user to API, API to database, API to third-party service)
- Verify that sensitive data is identified and classified
- Check that data retention and deletion requirements exist

**Questions to ask:**
- Where does PII live? Is it encrypted at rest and in transit?
- Who can access the database directly? Is access audited?
- What happens to data when a user deletes their account?
- Are there data residency requirements (EU data stays in EU)?

**Record:** Document the data flow approval in the security review or as a captain's log entry.

### Gate 1.3: Security Model Approval

**Decision:** Is the security posture sufficient to proceed to construction?

**Review:**
- Read all SEC-NNN findings from the five-persona review
- Verify that Critical findings are resolved or have a concrete plan
- Verify that High findings are tracked and assigned to a resolution phase
- Assess whether the authentication and authorization model is sound

**Questions to ask:**
- What is the worst thing an attacker could do with this system?
- What regulations apply, and are we addressing them?
- Is the security approach proportional to the risk? (A personal to-do app needs less security than a financial platform.)

**Record:** Sign off on the security review document. Note any findings that are accepted risks (with rationale).

---

## Templates

| Template | Usage in Phase 1 |
|----------|-------------------|
| [REQUIREMENTS.md](../../templates/REQUIREMENTS.md) | Write all project requirements with REQ-NNN IDs |
| [SECURITY.md](../../templates/SECURITY.md) | Document initial security policy and five-persona review findings |

ADRs do not have a dedicated template — use the format described in Activity 3. Store them as individual files in `docs/architecture/ADR-NNN-title.md`.

---

## Pillar Checkpoints

### Security Pillar

- [ ] Five-persona security review is complete
- [ ] All Critical findings are resolved or have resolution plans
- [ ] Authentication and authorization model is defined
- [ ] Data classification identifies PII and sensitive data
- [ ] Security requirements exist (REQ-4XX series)
- [ ] Trust boundaries are identified (where data crosses security perimeters)

> See [Security Pillar](../pillars/PILLAR-SECURITY.md) for the full cross-phase security checklist.

### Quality Pillar

- [ ] Requirements have testable acceptance criteria
- [ ] Non-functional requirements include measurable thresholds
- [ ] ADRs are reviewed for technical soundness
- [ ] No requirements conflict with each other

> See [Quality Pillar](../pillars/PILLAR-QUALITY.md) for the full cross-phase quality checklist.

### Traceability Pillar

- [ ] Every requirement has a unique, stable ID (REQ-NNN)
- [ ] ADRs reference the requirements they address
- [ ] Security findings reference related requirements and ADRs
- [ ] Requirements are categorized and prioritized
- [ ] Context file updated with Phase 1 decisions

> See [Traceability Pillar](../pillars/PILLAR-TRACEABILITY.md) for the full cross-phase traceability checklist.

### Cost Awareness Pillar

- [ ] Architecture decisions consider cost implications (noted in ADR consequences)
- [ ] Requirements with cost impact are identified (e.g., "1,000 concurrent users" has hosting cost implications)
- [ ] Cost-related security findings (Cost Analyst persona) are captured
- [ ] No open-ended resource commitments without cost ceilings

> See [Cost Awareness Pillar](../pillars/PILLAR-COST.md) for the full cross-phase cost checklist.

---

## Common Mistakes

| Mistake | Consequence | Prevention |
|---------|-------------|------------|
| Writing 50+ requirements before any ADRs | Architecture does not fit requirements; rework | Write requirements and ADRs iteratively — 5-10 requirements, then the first ADR, then more requirements |
| Over-specifying implementation details | Requirements become stale during construction | Keep requirements at "what" altitude, save "how" for Phase 2 |
| Skipping the security review | Design-level flaws discovered in Phase 4, expensive to fix | Run the five-persona review even if it feels premature — it always finds something |
| Not updating the context file | AI assistant in Phase 2+ lacks knowledge of Phase 1 decisions | Update CLAUDE.md after every major decision |
| Treating all requirements as "Must Have" | Everything is priority 1, so nothing is | Limit "Must Have" to requirements that define the MVP; be honest about "Should Have" and "Nice to Have" |
| Writing ADRs without alternatives | Decisions appear arbitrary; no basis for revisiting | Always document at least 2 alternatives with genuine pros/cons |

---

## Phase 1 in Different Governance Models

| Activity | Solo + AI | Small Team | Enterprise |
|----------|-----------|------------|------------|
| Requirements writing | Developer + AI collaborate; developer reviews | Team brainstorms; one person writes; team reviews | Product owner writes; architect reviews; team approves |
| ADR creation | Developer writes with AI assistance | Developer proposes; team reviews via PR | Architecture board reviews and approves |
| Security review | AI performs five-persona review; developer reviews findings | AI performs review; security-aware team member validates | Dedicated security team validates findings |
| Gate 1.1 (Architecture) | Developer self-review with AI challenge | Lead developer approves | Architecture board approves |
| Gate 1.2 (Data Flow) | Developer validates with AI assistance | Team review | Security team validates |
| Gate 1.3 (Security) | Developer accepts risk posture | Team accepts risk posture | CISO or security lead accepts risk posture |

---

## Next Phase

When all exit criteria are met and all three human decision gates are passed, proceed to [Phase 2: Elaboration](PHASE-2-ELABORATION.md) to transform requirements into detailed user stories, technical specifications, and a traceability matrix.
