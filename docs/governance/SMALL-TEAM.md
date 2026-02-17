# Small Team Governance Model (2-5 Developers + AI)

## Overview

The Small Team model scales AI-DLC from a solo operation to a collaborative effort. Two to five developers share a codebase, each working with their own AI assistant, coordinating through shared context files, namespaced logs, and lightweight branch governance.

This model adds just enough process to prevent collisions without killing the velocity that makes AI-DLC effective. The goal is coordination, not bureaucracy.

**Choose this model when:**

- 2-5 developers share a single codebase
- You need vacation coverage and bus-factor mitigation
- The project has grown beyond what one person can hold in working memory
- You want peer review without formal compliance requirements

**Downgrade to [Solo + AI](SOLO-AI.md) when:**

- The team shrinks to one developer
- Process overhead exceeds the coordination benefit

**Upgrade to [Enterprise](ENTERPRISE.md) when:**

- The team exceeds 5 developers or spans multiple teams
- Compliance, audit trails, or regulatory gates become mandatory
- Cross-team dependencies require formal coordination

---

## Context File Strategy

Context files are the shared memory of the team. In a small team, context splits into two layers: shared and personal.

### Shared Context: CLAUDE.md

`CLAUDE.md` lives at the project root. Every developer and every AI session reads it. It contains:

- Project identity and purpose
- Architecture decisions and system overview
- Coding conventions and style rules
- Repository structure
- Current project state (active work, known issues)
- Quality standards and review expectations

**Rules for CLAUDE.md:**

1. Any developer may propose changes via PR
2. Changes require one approval from another team member
3. Keep it between 50 and 200 lines — signal over volume
4. Update after architecture decisions, convention changes, or major milestones

### Personal Context: CLAUDE-{dev}.md

Each developer maintains a personal context file at the project root:

    CLAUDE.md              # Shared — everyone reads this
    CLAUDE-alice.md        # Alice's preferences and current work
    CLAUDE-bob.md          # Bob's preferences and current work
    CLAUDE-carol.md        # Carol's preferences and current work

Personal context files contain:

- Current work area and active bolts
- Individual AI session preferences (verbosity, style)
- Local environment quirks (OS-specific paths, tool versions)
- Personal notes and working memory

**Rules for personal context files:**

1. Only the owning developer edits their own file
2. Other developers may read them for situational awareness
3. Do not duplicate information from CLAUDE.md — reference it instead
4. No sensitive information (passwords, tokens, personal data)

### Merge Conflicts as a Feature

Merge conflicts in CLAUDE.md are a signal, not a nuisance. When two developers independently update CLAUDE.md, the conflict reveals divergent understanding of the project. Resolve the conflict in a brief sync conversation. The resolution often improves the context file because it forces the team to align.

**Conflict resolution process:**

1. Developer A opens a PR that modifies CLAUDE.md
2. Developer B's PR also modifies CLAUDE.md (or B reviews A's PR and disagrees)
3. Both developers discuss the conflict (async comment or quick sync call)
4. The resolution is committed with a note explaining the alignment decision
5. Both developers update their understanding

---

## Namespaced Captain's Logs

In a small team, captain's logs are namespaced by developer. This preserves the solo+AI journaling practice while enabling cross-team visibility.

### Directory Structure

    docs/decisions/
      captain-logs/
        alice/
          2026-01-15-bolt-B012.md
          2026-01-15-bolt-B013.md
          2026-01-16-bolt-B014.md
        bob/
          2026-01-15-bolt-B010.md
          2026-01-16-bolt-B011.md
        carol/
          2026-01-16-bolt-B015.md

### Log Format

Use the same format as the [Solo + AI](SOLO-AI.md) captain's log, with one addition — a **Coordination Notes** section:

    # Captain's Log — Bolt B-{NNN}

    **Date:** YYYY-MM-DD
    **Author:** {developer name}
    **Bolt ID:** B-{NNN}
    **Goal:** One-sentence description

    ## What Happened
    - Work completed during this bolt

    ## Decisions Made
    - Decisions with rationale

    ## Blockers Hit
    - Blockers and resolutions

    ## What Changed
    - Files modified, dependencies added

    ## Coordination Notes
    - Cross-references to other developers' work
    - Potential conflicts or dependencies identified
    - "Heads up" notes for teammates

    ## Next Steps
    - What comes next

### Weekly Sync: Log Review

Hold a weekly log review (15-30 minutes, async or sync). Each developer:

1. Shares a 2-3 sentence summary of the week's bolts
2. Highlights decisions that affect other team members
3. Flags upcoming work that might overlap with others
4. Reviews one other developer's logs for the week

This practice replaces lengthy status meetings with focused, written-first communication. The logs already exist — the review is just reading them together.

---

## Branch Strategy

Small teams need a branch strategy that prevents conflicts while keeping velocity high. Long-lived branches are the enemy of AI-DLC's bolt cadence.

### Rules

1. **Short-lived feature branches.** No branch lives longer than 2 days. If a feature takes longer, break it into smaller bolts that each merge independently.
2. **Main branch is always deployable.** Never merge code that breaks tests, fails linting, or lacks required reviews.
3. **Branch naming convention:** `{dev}/{bolt-id}-{description}`

| Example Branch | Developer | Bolt | Description |
|---|---|---|---|
| `alice/B12-auth-flow` | Alice | B-012 | Authentication flow implementation |
| `bob/B10-api-pagination` | Bob | B-010 | Add pagination to API endpoints |
| `carol/B15-dashboard-ui` | Carol | B-015 | Dashboard user interface |

### Pull Request Workflow

Every merge to main requires a pull request with:

- [ ] All tests passing (enforced by CI)
- [ ] Linter passing (enforced by CI)
- [ ] At least one approval from a team member
- [ ] AI-assisted review completed (the author's AI reviews the diff)
- [ ] Human review completed (a teammate reads the changes)
- [ ] Captain's log written for the bolt
- [ ] CLAUDE.md updated if conventions or architecture changed

### AI-Assisted PR Review

Before requesting human review, have the AI review the PR diff. Instruct the AI to check:

1. **Consistency** — Does the code follow CLAUDE.md conventions?
2. **Completeness** — Are all acceptance criteria met? Are tests included?
3. **Security** — Any obvious vulnerabilities (hardcoded secrets, SQL injection, XSS)?
4. **Performance** — Any O(n^2) loops, missing indexes, or unbounded queries?
5. **Clarity** — Would another developer understand this code in 6 months?

The AI review does not replace human review. It catches mechanical issues so the human reviewer can focus on design, intent, and correctness.

### Handling Stale Branches

| Branch Age | Action |
|---|---|
| < 1 day | Normal — keep working |
| 1-2 days | Rebase on main, push to finish |
| 2-3 days | Break the remaining work into a smaller bolt, merge what is done |
| 3+ days | Abandon the branch. Start fresh with a smaller scope. |

---

## Deploy Coordination

When multiple developers share a codebase, deployments require coordination. Simultaneous deploys cause confusion about which change caused which behavior in production.

### Release Tagging

Use semantic versioning with git tags:

    v1.0.0    # Initial production release
    v1.1.0    # New feature added
    v1.1.1    # Bug fix
    v1.2.0    # Next feature release

Tag releases on the main branch after all tests pass and the team agrees the code is ready.

### Deploy Queue

Maintain a simple deploy queue — one deploy at a time.

**Process:**

1. Developer announces intent to deploy in the team channel (or updates a shared deploy queue file)
2. No other developer begins a deploy until the current one completes
3. The deploying developer monitors production for 15 minutes post-deploy
4. If issues arise, the deploying developer initiates rollback
5. Once stable, the next developer in the queue may proceed

### Rollback Responsibility

The developer who deployed owns the rollback. This principle is simple and unambiguous:

- **You deployed it, you roll it back** if something goes wrong
- Rollback procedure must be documented in the project's operations runbook
- Practice the rollback procedure in staging before deploying to production
- Log every rollback in the captain's log with root cause and resolution

### Deploy Checklist

Before every deploy:

- [ ] All tests passing on the tagged commit
- [ ] No other deploy in progress
- [ ] Rollback procedure reviewed
- [ ] Team notified of the deploy window
- [ ] Monitoring dashboards open during deploy
- [ ] Captain's log entry prepared (fill in results after deploy)

> See [Phase 5: Operations](../framework/PHASE-5-OPERATIONS.md) for complete deployment pipeline design.

---

## Structured Workflow Pipeline

Small teams benefit from the structured workflow pipeline drawn from the Olympus philosophy. This pipeline converts ideas into shipped software through a series of refinement stages, with team review gates at key points.

### The Pipeline

    IDEA --> PRD --> SPEC --> INTENTS --> Implementation --> Review --> Deploy

| Stage | Description | Who Creates | Who Reviews |
|---|---|---|---|
| IDEA | One-paragraph description of the feature or change | Any developer | Team (async) |
| PRD | Product Requirements Document — what and why | Proposing developer + AI | Full team |
| SPEC | Technical specification — how | Assigned developer + AI | Full team |
| INTENTS | Ordered list of bolts with goals and acceptance criteria | Assigned developer + AI | One reviewer |
| Implementation | Code, tests, and documentation per bolt | Assigned developer + AI | PR reviewer |
| Review | Human + AI review of the complete feature | PR reviewer + AI | Assigned developer |
| Deploy | Ship to production | Deploying developer | Team (notification) |

### Team Review Gates

**Gate 1: PRD Review** — The team reviews the PRD before technical work begins. Catch scope issues, missing requirements, and conflicting priorities here. This is the cheapest place to change direction.

**Gate 2: SPEC Review** — The team reviews the technical specification. Catch architecture mistakes, missed edge cases, and integration risks here. Once the SPEC is approved, implementation begins.

Individual bolts proceed without team-wide review. The PR process provides sufficient oversight for implementation-level decisions.

### When to Use the Full Pipeline

| Situation | Pipeline Stages |
|---|---|
| New feature (user-facing) | All stages: IDEA through Deploy |
| Bug fix | Skip PRD and SPEC; go straight to INTENTS |
| Refactoring | Skip PRD; write a brief SPEC explaining what changes and why |
| Configuration change | Skip PRD and SPEC; single bolt with PR review |
| Hotfix | Skip everything; fix, test, deploy, then write the captain's log after |

### Multi-Agent Delegation Patterns

Small teams can leverage multi-agent patterns where different team members (or their AI sessions) specialize in different roles:

| Role | Owner | AI Specialization | Gates Owned |
|------|-------|-------------------|-------------|
| **PM / Product** | Product-focused developer | Requirements, user stories, acceptance criteria | Gate 1 (PRD), Gate 2 (SPEC) |
| **Dev / Builder** | Implementation developer | Code generation, test writing, debugging | Gate 3 (Implementation), Gate 4 (Review) |
| **Reviewer** | Reviewing developer | Five-persona review, code analysis | Quality verification |
| **Ops** | Ops-focused developer | Infrastructure, deployment, monitoring | Deploy coordination |

**Delegation flow:**
1. PM role creates IDEA and PRD artifacts with AI assistance
2. Dev role elaborates into SPEC and INTENTS with AI assistance
3. Builder AI executes bolts using The Ascent pattern
4. Reviewer role conducts post-bolt and phase reviews
5. Ops role manages deployment using the Summit pattern

This maps naturally to the [multi-agent specialization model](../reference/AUTONOMOUS-EXECUTION-GUIDE.md) — each developer's AI session is configured for their role.

---

## Communication Patterns

Small teams communicate async-first, sync for blockers. Written communication creates a record. Verbal communication creates alignment.

### Async-First Principles

1. **Default to written communication.** PRs, captain's logs, and CLAUDE.md updates are the primary communication channels.
2. **Use team chat for notifications, not discussions.** "PR ready for review" is a notification. Architecture debates belong in PR comments or a shared document.
3. **Respond within 4 hours during working hours.** PR reviews, blocker questions, and deploy notifications deserve timely responses.
4. **Write for the reader.** Assume the reader has not been following your work closely. Provide enough context to understand without asking follow-up questions.

### Sync Communication

Reserve synchronous communication (calls, pair sessions, standups) for:

- **Blockers that cannot wait 4 hours** — Call the person who can unblock you
- **Architecture disagreements** — When async discussion exceeds 3 rounds without resolution
- **Onboarding** — Walk new team members through CLAUDE.md and recent captain's logs
- **Weekly log review** — 15-30 minutes, can be async if the team prefers

### Daily Standup (Optional)

A daily standup is optional for small teams using AI-DLC. Captain's logs already capture what each developer is doing. If the team does hold standups, keep them to 10 minutes:

1. Each developer: "Yesterday I completed bolt B-{N}. Today I am working on bolt B-{M}. No blockers." (or "Blocked on X, need Y from Z.")
2. Any coordination needed? (overlapping work areas, shared dependencies)
3. Done.

Do not discuss solutions in standup. Take those conversations offline.

---

## Conflict Resolution

When two developers' AI assistants produce conflicting approaches — different error handling patterns, different API designs, different architectural choices — resolve the conflict deliberately.

### The Protocol

**Step 1: Identify the conflict.** Usually surfaced during PR review or CLAUDE.md merge conflict.

**Step 2: Document both approaches.** Each developer writes a brief summary of their approach and its trade-offs.

| Approach | Proposed By | Pros | Cons |
|---|---|---|---|
| Approach A | Alice + AI | Simpler, fewer dependencies | Less scalable |
| Approach B | Bob + AI | More scalable, industry standard | More complex setup |

**Step 3: Apply selection criteria.** Decide based on project priorities documented in CLAUDE.md:

- Which approach better fits the existing architecture?
- Which approach aligns with conventions already in CLAUDE.md?
- Which approach is simpler to maintain long-term?
- If neither is clearly better, prefer the approach that is easier to change later

**Step 4: Record the decision.** Update CLAUDE.md with the chosen approach and the rationale. This prevents the same debate from recurring.

**Step 5: The other developer aligns.** The developer whose approach was not selected updates their code (and their personal CLAUDE-{dev}.md understanding) to match.

### Escalation

If the two developers cannot agree after 15 minutes of discussion:

1. **Flip a coin.** Seriously. If both approaches are approximately equal and the debate is burning time, pick one and move on. You can always revisit.
2. **Timebox a proof of concept.** Each developer builds a 30-minute prototype. Compare results. The code often makes the decision obvious.
3. **Defer to the developer who will maintain it.** The person who will live with the code gets the tiebreaker.

---

## Onboarding a New Team Member

When a developer joins the team, onboard them through the existing artifacts — not a verbal brain dump.

### Onboarding Checklist

- [ ] New developer reads CLAUDE.md end-to-end
- [ ] New developer reads the 3 most recent captain's logs from each existing developer
- [ ] New developer creates their personal CLAUDE-{dev}.md file
- [ ] Existing developer walks through the repository structure (15-minute call or screen recording)
- [ ] New developer completes one small bolt (S-sized) with PR review from an existing team member
- [ ] New developer's first PR includes a CLAUDE.md update (proves they understand the update process)
- [ ] Team chat access, CI/CD access, and deploy permissions configured

### Context Transfer Time

A well-maintained CLAUDE.md and captain's log set should enable a new developer to be productive within 1-2 hours. If onboarding takes longer, the context files need improvement.

| Onboarding Time | Diagnosis |
|---|---|
| < 1 hour | Context files are excellent |
| 1-2 hours | Normal for a well-run project |
| 2-4 hours | Context files are missing information; update them |
| 4+ hours | Context files are stale or absent; schedule a cleanup sprint |

---

## Phase-Specific Guidance for Small Teams

### Phase 0: Foundation

- One developer bootstraps the project (solo+AI for Phase 0)
- Team reviews the foundation together before entering Phase 1
- Governance model is recorded as "Small Team" in CLAUDE.md
- See [Phase 0: Foundation](../framework/PHASE-0-FOUNDATION.md)

### Phase 1: Inception

- Requirements gathering is collaborative — each developer contributes domain knowledge
- Use the structured workflow pipeline: IDEA and PRD stages involve the full team
- One developer owns the requirements document; others review via PR
- See [Phase 1: Inception](../framework/PHASE-1-INCEPTION.md)

### Phase 2: Elaboration

- Architecture decisions require team consensus (or at minimum, no objections)
- SPEC review is mandatory before implementation begins
- User stories can be divided among developers — assign ownership clearly
- The traceability matrix tracks which developer owns which requirement
- See [Phase 2: Elaboration](../framework/PHASE-2-ELABORATION.md) and [Traceability Pillar](../pillars/PILLAR-TRACEABILITY.md)

### Phase 3: Construction

- Developers work in parallel on different bolts
- PR review provides continuous quality assurance
- Branch strategy prevents merge conflicts
- Captain's logs maintain individual and team awareness
- See [Phase 3: Construction](../framework/PHASE-3-CONSTRUCTION.md) and [Quality Pillar](../pillars/PILLAR-QUALITY.md)

### Phase 4: Hardening

- Security review rotates among developers — each developer reviews code they did not write
- AI 5-persona security review is conducted by at least two developers independently
- Performance testing is assigned to one developer; results are reviewed by the team
- See [Phase 4: Hardening](../framework/PHASE-4-HARDENING.md) and [Security Pillar](../pillars/PILLAR-SECURITY.md)

### Phase 5: Operations

- Deploy responsibility rotates or is assigned to a designated deployer
- On-call rotation (if applicable) is documented in the operations runbook
- Incident response involves the developer most familiar with the affected component
- See [Phase 5: Operations](../framework/PHASE-5-OPERATIONS.md)

### Phase 6: Evolution

- Retrospectives include the full team
- Captain's logs from all developers feed into the retrospective
- Process improvements are proposed via PR to CLAUDE.md
- See [Phase 6: Evolution](../framework/PHASE-6-EVOLUTION.md)

---

## Security for Small Teams

Small teams have an advantage over solo developers: peer review catches security issues that one person misses.

### Security Review Process

1. **Every PR gets a security glance.** The reviewer checks for obvious vulnerabilities (hardcoded secrets, SQL injection, missing auth checks).
2. **Security-critical PRs get a dedicated security review.** Authentication, authorization, data handling, and cryptography changes require explicit security approval.
3. **AI 5-persona review during Phase 4.** At least two developers run the review independently and compare findings.

### Security Responsibilities

| Responsibility | Who |
|---|---|
| Secret management | All developers (never commit secrets) |
| Dependency scanning | CI pipeline (automated) |
| Security review for auth/authz changes | Designated reviewer (rotate monthly) |
| Penetration testing | External or designated developer during Phase 4 |
| Incident response | Developer who deployed + most knowledgeable developer |

> See [Security Pillar](../pillars/PILLAR-SECURITY.md) for the complete cross-phase security checklist.

---

## Cost Management for Small Teams

With multiple developers, costs multiply. Track and allocate costs to prevent surprises.

### Team Cost Tracking

| Cost Category | Tracking Method | Owner |
|---|---|---|
| AI API tokens (per developer) | Individual billing or shared budget with per-dev tracking | Each developer |
| Cloud resources | Resource tagging by feature/developer | Designated cost owner |
| CI/CD minutes | Monitor monthly usage against free-tier or budget | Designated cost owner |
| Third-party services | Shared spreadsheet or cost dashboard | Designated cost owner |

### Budget Conversations

Hold a monthly 10-minute cost review:

1. Review actual spend vs. budget
2. Identify unexpected cost spikes
3. Decide whether to optimize, accept, or escalate
4. Update CLAUDE.md if cost constraints have changed

> See [Cost Awareness Pillar](../pillars/PILLAR-COST.md) for the full cross-phase cost checklist.

---

## Quick Reference

### Small Team Decision Framework

    Who decides architecture? -------> Team consensus (SPEC review)
    Who decides conventions? --------> PR to CLAUDE.md, one approval
    Who decides bolt scope? ---------> Individual developer
    Who decides to deploy? ----------> Deploy queue + team notification
    Who decides to roll back? -------> Developer who deployed

### Files the Team Maintains

| File | Update Frequency | Owner |
|---|---|---|
| CLAUDE.md | After architecture decisions and convention changes | Team (via PR) |
| CLAUDE-{dev}.md | As needed by each developer | Individual developer |
| Captain's logs | One per bolt per developer | Individual developer |
| CHANGELOG.md | Per release | Release developer |
| Traceability matrix | Per feature completion | Assigned developer |

### Pillars Checklist for Small Teams

- [ ] **Security:** PR reviews include security checks; Phase 4 review by two developers — see [Security Pillar](../pillars/PILLAR-SECURITY.md)
- [ ] **Quality:** All PRs pass CI; tests required for merge — see [Quality Pillar](../pillars/PILLAR-QUALITY.md)
- [ ] **Traceability:** Captain's logs namespaced; traceability matrix maintained — see [Traceability Pillar](../pillars/PILLAR-TRACEABILITY.md)
- [ ] **Cost:** Monthly cost review; per-developer tracking — see [Cost Awareness Pillar](../pillars/PILLAR-COST.md)

---

## Related Documents

- [Phase 0: Foundation](../framework/PHASE-0-FOUNDATION.md) — Where governance model selection happens
- [Solo + AI Governance](SOLO-AI.md) — For single-developer projects
- [Enterprise Governance](ENTERPRISE.md) — For large teams with compliance requirements
- [Security Pillar](../pillars/PILLAR-SECURITY.md) — Cross-phase security checklist
- [Quality Pillar](../pillars/PILLAR-QUALITY.md) — Cross-phase quality checklist
- [Traceability Pillar](../pillars/PILLAR-TRACEABILITY.md) — Cross-phase traceability checklist
- [Cost Awareness Pillar](../pillars/PILLAR-COST.md) — Cross-phase cost checklist
- [Autonomous Execution Guide](../reference/AUTONOMOUS-EXECUTION-GUIDE.md) — Multi-agent delegation, execution modes
