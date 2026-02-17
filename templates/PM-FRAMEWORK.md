# Project Management Framework

<!-- AI-DLC Phase: Created in Phase 0: Foundation, used throughout Phase 3: Construction -->

> Copy this template into your project and fill in all sections.
> Adapt the sprint/bolt structure to match your team's cadence.
> Items marked with <!-- TODO: ... --> need your input.

---

## Project Information

**Project Name:** *<!-- TODO: Your project name -->*
**Last Updated:** *<!-- TODO: YYYY-MM-DD -->*
**Project Manager / Owner:** *<!-- TODO: Name -->*

---

## Sprint / Bolt Structure

<!-- TODO: Define your iteration structure -->

### Definition

| Field | Value |
|-------|-------|
| **Iteration term** | *<!-- TODO: e.g., Bolt (AI-DLC convention) or Sprint -->* |
| **Duration** | *<!-- TODO: e.g., 1 day, 3 days, 1 week -->* |
| **Planning happens** | *<!-- TODO: e.g., Start of each bolt, using Five Questions Pattern -->* |
| **Review happens** | *<!-- TODO: e.g., End of each bolt, before retro -->* |
| **Retro happens** | *<!-- TODO: e.g., End of each bolt, captured in Captain's Log -->* |

### Bolt Lifecycle

```
Plan --> Build --> Review --> Retro --> (next bolt)
  |                              |
  |   Five Questions Pattern     |   Captain's Log entry
  |   Select backlog items       |   Update context file
  |   Define done criteria       |   Update traceability matrix
```

### Bolt Numbering

<!-- TODO: Define your numbering scheme -->

*<!-- Example: Bolts are numbered sequentially: Bolt-001, Bolt-002, etc. Each bolt has a short descriptive name: Bolt-003-auth-flow. -->*

---

## Backlog Management

### Backlog Sources

<!-- TODO: Define where backlog items come from -->

| Source | How Items Enter the Backlog |
|--------|-----------------------------|
| *Requirements (REQUIREMENTS.md)* | *Broken into user stories during Phase 2* |
| *User Stories (USER-STORIES.md)* | *Prioritized by product owner* |
| *Bug reports* | *Triaged and added with severity label* |
| *Tech debt* | *Identified during retros, labeled as tech-debt* |
| *Security findings* | *From Phase 4 hardening, labeled as security* |

### Backlog Prioritization

<!-- TODO: Define your prioritization approach -->

| Priority | Label | Description |
|----------|-------|-------------|
| **P0 - Critical** | `p0` | *Blocks release or causes data loss. Work on immediately.* |
| **P1 - High** | `p1` | *Must-have for this release. Plan for the next bolt.* |
| **P2 - Medium** | `p2` | *Should-have. Schedule when P0/P1 items are clear.* |
| **P3 - Low** | `p3` | *Could-have / Nice to have. Address if capacity allows.* |
| **P4 - Backlog** | `p4` | *Won't do this release. Documented for future consideration.* |

### Backlog Hygiene

- **Review frequency:** *<!-- TODO: e.g., Start of every bolt -->*
- **Stale item policy:** *<!-- TODO: e.g., Items untouched for 4 bolts are reviewed for relevance -->*
- **Maximum WIP:** *<!-- TODO: e.g., 3 items in progress at a time for solo dev -->*

---

## Current Sprint / Bolt

<!-- TODO: Copy this section for each new bolt. Keep only the current bolt here; move completed bolts to the Sprint Log below. -->

### Bolt-<!-- TODO: NNN -->: <!-- TODO: Descriptive Name -->

**Start Date:** *<!-- TODO: YYYY-MM-DD -->*
**Target End Date:** *<!-- TODO: YYYY-MM-DD -->*
**Goal:** *<!-- TODO: One sentence describing what this bolt achieves -->*

#### Planned Items

| ID | Description | Priority | Estimate | Assignee | Status |
|----|-------------|----------|----------|----------|--------|
| *US-201* | *View active subscriptions on dashboard* | P1 | M | *<!-- TODO -->* | To Do |
| *US-301* | *CSV export backend* | P2 | M | *<!-- TODO -->* | To Do |
| *BUG-012* | *Session timeout not implemented* | P1 | S | *<!-- TODO -->* | To Do |
| <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | To Do |

#### Done Criteria

<!-- TODO: Define what "done" means for this bolt -->

- [ ] All P1 items completed and tested
- [ ] Tests passing with no regressions
- [ ] Context file (CLAUDE-CONTEXT.md) updated
- [ ] Traceability matrix updated
- [ ] Captain's Log entry written

#### Blockers

| Blocker | Impact | Owner | Resolution Plan | Target Date |
|---------|--------|-------|-----------------|-------------|
| *<!-- TODO: e.g., Waiting on API credentials -->* | *Cannot test integration* | *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* |

---

## Sprint / Bolt Log

<!-- TODO: Move completed bolts here. This becomes your project history. -->

### Bolt-<!-- TODO: NNN -->: <!-- TODO: Name -->

**Dates:** *<!-- TODO: Start --> -- <!-- TODO: End -->*
**Goal:** *<!-- TODO: Goal -->*
**Outcome:** *<!-- TODO: Met / Partially Met / Not Met -->*

| ID | Description | Status | Notes |
|----|-------------|--------|-------|
| *<!-- TODO -->* | *<!-- TODO -->* | *Done / Carried Over / Dropped* | *<!-- TODO -->* |

**Velocity:** *<!-- TODO: Story points or items completed -->*
**Retro Notes:** *<!-- TODO: Key takeaways -->*

---

## Metrics Tracking

<!-- TODO: Update these metrics at the end of each bolt -->

### Velocity

| Bolt | Planned Items | Completed Items | Carry-Over | Velocity |
|------|---------------|-----------------|------------|----------|
| *Bolt-001* | *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* |
| *Bolt-002* | *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* |
| *Bolt-003* | *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* |

### Quality Metrics

| Bolt | Test Count (Start) | Test Count (End) | Test Delta | Pass Rate | Coverage |
|------|-------------------|------------------|------------|-----------|----------|
| *Bolt-001* | *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* |
| *Bolt-002* | *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* |

### Health Indicators

| Metric | Current Value | Target | Status |
|--------|--------------|--------|--------|
| *Velocity (items/bolt)* | *<!-- TODO -->* | *<!-- TODO: e.g., 3-5 -->* | *<!-- TODO: On Track / At Risk / Off Track -->* |
| *Test delta per bolt* | *<!-- TODO -->* | *<!-- TODO: e.g., +5 minimum -->* | *<!-- TODO -->* |
| *Blocked %* | *<!-- TODO -->* | *<!-- TODO: e.g., < 10% -->* | *<!-- TODO -->* |
| *Carry-over %* | *<!-- TODO -->* | *<!-- TODO: e.g., < 20% -->* | *<!-- TODO -->* |
| *Context file freshness* | *<!-- TODO: Last update date -->* | *Updated every bolt* | *<!-- TODO -->* |

---

## Status Reporting

### Status Report Template

<!-- TODO: Use this format when communicating status to stakeholders -->

```
## Status Report: Bolt-NNN (YYYY-MM-DD)

**Overall Status:** On Track / At Risk / Off Track

### Completed This Bolt
- Item 1
- Item 2

### In Progress
- Item 3 (expected completion: next bolt)

### Blockers
- Blocker description (owner, resolution plan)

### Key Decisions Made
- Decision and rationale

### Next Bolt Plan
- Planned Item 1
- Planned Item 2

### Metrics
- Velocity: X items
- Test delta: +Y
- Blocked: Z%
```

---

## Stakeholder Communication

<!-- TODO: Define your communication cadence -->

| Audience | Format | Frequency | Owner |
|----------|--------|-----------|-------|
| *Product Owner* | *Status report (above)* | *End of every bolt* | *<!-- TODO -->* |
| *Development Team* | *Stand-up / async check-in* | *Daily (or start of bolt)* | *<!-- TODO -->* |
| *Stakeholders* | *Summary email or demo* | *<!-- TODO: e.g., Every 3 bolts -->* | *<!-- TODO -->* |
| *End Users* | *Release notes* | *Each deployment* | *<!-- TODO -->* |

---

## Risk Register

<!-- TODO: Track project-level risks -->

| ID | Risk | Probability | Impact | Mitigation | Owner | Status |
|----|------|-------------|--------|------------|-------|--------|
| *RISK-001* | *<!-- TODO: e.g., Key dependency deprecated -->* | *Medium* | *High* | *<!-- TODO: e.g., Pin version, monitor for alternatives -->* | *<!-- TODO -->* | *Open* |
| *RISK-002* | *<!-- TODO: e.g., Scope creep from stakeholder requests -->* | *High* | *Medium* | *<!-- TODO: e.g., Enforce change control via REQUIREMENTS.md -->* | *<!-- TODO -->* | *Open* |
| <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | Open |

---

## Definition of Done

<!-- TODO: Define your project's Definition of Done -->

An item is considered Done when:

- [ ] Code is written and follows project conventions (see CLAUDE-CONTEXT.md)
- [ ] Unit tests written and passing
- [ ] Integration tests written and passing (if applicable)
- [ ] Code reviewed (or AI-assisted review completed)
- [ ] No new lint warnings or errors
- [ ] Acceptance criteria from user story verified
- [ ] Traceability matrix updated
- [ ] Documentation updated (if user-facing change)

---

## Cross-References

- **Requirements:** See [REQUIREMENTS.md](./REQUIREMENTS.md)
- **User Stories:** See [USER-STORIES.md](./USER-STORIES.md)
- **Traceability:** See [TRACEABILITY-MATRIX.md](./TRACEABILITY-MATRIX.md)
- **Context File:** See [CLAUDE-CONTEXT.md](./CLAUDE-CONTEXT.md)
- **Workflow Guide:** See [SOLO-AI-WORKFLOW-GUIDE.md](./SOLO-AI-WORKFLOW-GUIDE.md)

---

## Revision History

| Date | Version | Author | Changes |
|------|---------|--------|---------|
| *<!-- TODO: Date -->* | *0.1* | *<!-- TODO: Author -->* | *Initial PM framework created in Phase 0* |
