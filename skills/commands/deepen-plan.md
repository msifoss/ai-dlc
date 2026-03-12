# /deepen-plan — Parallel Research to Strengthen Any Plan

Usage: `/deepen-plan [plan file or topic]`

**Arguments:** $ARGUMENTS

---

## Purpose

Before work begins, launch parallel research agents to stress-test and enrich a plan. Inspired by compound engineering's deepen-plan pattern but integrated with AI-DLC's knowledge compounding loop.

> Plans fail because of what you don't know. This command sends 4 research agents out simultaneously to find what you missed — past learnings, codebase patterns, best practices, and framework constraints.

---

## Instructions for Claude

### Step 0: Locate the Plan

Parse $ARGUMENTS to find the plan to deepen:

**If a file path:** Read that file directly.
**If a topic:** Search `docs/pm/CURRENT-SPRINT.md` for a matching bolt, or `docs/brainstorms/` for a matching brainstorm.
**If empty:** Read `docs/pm/CURRENT-SPRINT.md` and use the active bolt.

GATE: STOP. A plan or brainstorm must exist. If nothing found, suggest: "Run `/brainstorm` or `/pm plan` first."

---

### Step 1: Launch 4 Parallel Research Agents

Use the Agent tool to launch ALL FOUR agents simultaneously in a single message. Each agent works independently — do NOT let one agent's results influence another.

#### Agent 1: Learnings Researcher
```
Search the project's knowledge base for anything relevant to this plan:
- docs/solutions/*.md — past solutions to similar problems
- docs/captains_log/*.txt — decisions and lessons from prior bolts
- docs/reviews/*.txt — findings from code reviews that relate

For each relevant finding, extract:
- What was learned
- How it applies to the current plan
- What risk it mitigates

Return a structured list of learnings sorted by relevance.
```

#### Agent 2: Codebase Researcher
```
Analyze the existing codebase for patterns relevant to this plan:
- Find existing implementations of similar features
- Identify shared utilities, helpers, or abstractions to reuse
- Map the dependency graph for files that will be touched
- Flag potential conflicts with in-progress work (check git branches)
- Identify test patterns used in adjacent code

Return: existing patterns to follow, code to reuse, potential conflicts, test strategy.
```

#### Agent 3: Best Practices Researcher
```
Research best practices for the technical approach in this plan:
- Search for common pitfalls with the technologies involved
- Identify security considerations (OWASP top 10 relevance)
- Check for performance anti-patterns
- Look for accessibility or compliance requirements
- Review error handling patterns appropriate to this domain

Return: best practices checklist, pitfalls to avoid, security notes.
```

#### Agent 4: Framework Compliance Researcher
```
Check this plan against AI-DLC framework requirements:
- Which phase(s) does this work fall under?
- What deliverables are required by the framework?
- Are there governance gates that apply?
- What pillar checkpoints (Security, Quality, Traceability, Cost) are relevant?
- Does the plan's scope match the risk tier?

Read: docs/framework/PHASE-*.md and docs/pillars/PILLAR-*.md as needed.

Return: compliance checklist, missing deliverables, applicable gates.
```

GATE: STOP. Wait for ALL 4 agents to complete before proceeding.

---

### Step 2: Synthesize Research

Combine the 4 agents' findings into a single enrichment report:

#### 2a. Identify Conflicts
Where do agents disagree or surface conflicting guidance? Flag these for human decision.

#### 2b. Rank Findings
Sort all findings into:

| Priority | Criteria | Action |
|----------|----------|--------|
| **Must Address** | Blocks success, security risk, or framework violation | Integrate into plan before work begins |
| **Should Address** | Improves quality, prevents known pitfalls | Add to plan or create backlog items |
| **Nice to Have** | Best practice, optimization, polish | Note for future reference |

#### 2c. Generate Plan Amendments

For each "Must Address" finding, write a specific amendment:
```
**Amendment [N]:** [Title]
**Source:** [Which agent found this]
**Finding:** [What was discovered]
**Plan Change:** [Specific modification to the plan]
**Rationale:** [Why this matters]
```

---

### Step 3: Update the Plan

Apply all "Must Address" amendments to the plan document. For each amendment:
1. Read the current plan file
2. Insert the amendment in the appropriate section
3. Mark it with `<!-- deepened: YYYY-MM-DD -->` so it's traceable

Add a "Research Summary" section at the bottom of the plan:

```markdown
## Research Summary (deepened YYYY-MM-DD)

### Learnings Applied
- [List of past learnings that informed amendments]

### Codebase Patterns to Follow
- [List of existing patterns to reuse]

### Best Practices Checklist
- [ ] [Practice 1]
- [ ] [Practice 2]
- [ ] [Practice 3]

### Framework Compliance
- [ ] [Required deliverable 1]
- [ ] [Required deliverable 2]
- [ ] [Gate requirement]

### Deferred Items
- [Should-address items moved to backlog]
```

---

### Step 4: Report

Display a summary:

```
## Plan Deepened ✓

**Amendments applied:** [N] must-address changes
**Backlog items created:** [N] should-address items deferred
**Research agents:** 4/4 completed
**Learnings referenced:** [N] past solutions, [N] captain's logs
**Compliance gaps found:** [N] (all addressed)

The plan is now research-hardened and ready for work.
```

---

## Integration

- Called by `/bolt-lfg` between Step 2 (plan) and Step 3 (work)
- Reads artifacts from `/brainstorm`, `/pm plan`, `/captainslog`
- Feeds into `/five-persona-review` (research findings reduce review surprises)
- Knowledge retrieval from `docs/solutions/` and `docs/captains_log/` closes the compound loop
