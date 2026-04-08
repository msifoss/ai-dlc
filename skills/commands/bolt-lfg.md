# /bolt-lfg — Autonomous Bolt Pipeline

Usage: `/bolt-lfg [feature description or goal]`

**Arguments:** $ARGUMENTS

---

## Purpose

Full autonomous engineering pipeline that chains the AI-DLC bolt workflow end-to-end. Modeled on compound engineering's `/lfg` with our bolt methodology, governance gates, and knowledge capture loop.

> Each step has a gate. The pipeline cannot proceed until the gate passes. This prevents "code first, think later."

---

## Step 0: Classify Work Type

**FIRST — before anything else.** Classify $ARGUMENTS to determine pipeline depth:

| Trigger Pattern | Work Type | Pipeline |
|-----------------|-----------|----------|
| "Build X" / "Add X" / "Create X" / new capability | **Feature** | Full (all steps) |
| "Improve X" / "Enhance X" / "Add Y to existing X" | **Enhancement** | Abbreviated (skip brainstorm, delta plan) |
| "Fix X" / "X is broken" / "bug in X" | **Bug Fix** | Minimal (skip brainstorm + deepen, work → review → log → close) |
| "X is down" / "Urgent" / "production broken" | **Hotfix** | Emergency (work → commit, skip review) |
| "Refactor X" / "Clean up X" / "Extract X" | **Refactoring** | Engineering (plan → work → full review → log → close) |

**Classification rules:**
1. If $ARGUMENTS explicitly names a work type (e.g., "fix this bug"), use it
2. If ambiguous, default to **Enhancement** (not Feature — avoid over-ceremony)
3. If the user previously ran `/brainstorm`, default to **Feature** (they already invested in exploration)

Announce: `"Classified as [Work Type] — using [pipeline name] pipeline."`

**Route to the appropriate pipeline section below.**

---

## Feature Pipeline (Full)

```
brainstorm → plan → deepen → work → review (with fix-retest) → captainslog → close
```

CRITICAL: Execute every step IN ORDER. Do NOT skip steps. Do NOT jump to coding.

### Step 1: Brainstorm (if needed)

**Gate:** Determine if brainstorming is needed before planning.

Check if $ARGUMENTS describes a clear, well-scoped task:

**Clear requirements indicators (skip brainstorm):**
- Specific acceptance criteria provided
- Referenced existing patterns to follow
- Described exact expected behavior
- Constrained, well-defined scope

**Unclear requirements indicators (brainstorm first):**
- Vague goal ("improve the auth system")
- Multiple possible approaches
- New feature with no existing pattern
- User asks to "explore" or "figure out"

**If brainstorming needed:**
```
/brainstorm $ARGUMENTS
```

ARTIFACT GATE: STOP. Run `ls docs/brainstorms/*.md 2>/dev/null | tail -1`. A brainstorm file MUST exist. If not, the brainstorm did not complete — run it again. Do NOT proceed until a brainstorm artifact exists OR requirements were clear enough to skip.

**If skipping brainstorm:** Announce "Requirements are clear — skipping brainstorm, proceeding to planning." and continue to Step 2.

---

### Step 1b: Check Decisions Needed

Before planning, check for unresolved blocking decisions:

```bash
ls docs/decisions-needed.md 2>/dev/null
```

If `docs/decisions-needed.md` exists and contains `[CRITICAL]` items:
1. Read the file and surface CRITICAL items to the user
2. CRITICAL items BLOCK the pipeline — do NOT proceed until resolved
3. STANDARD items can proceed with noted defaults

### Step 2: Plan the Bolt

```
/pm plan
```

During planning:
- If a brainstorm document exists in `docs/brainstorms/` matching this feature, reference it
- Pull items from the backlog or create new ones based on $ARGUMENTS
- Define the bolt goal, items, and success criteria
- Set work type: Feature

ARTIFACT GATE: STOP. Run `grep -l "IN PROGRESS" docs/pm/CURRENT-SPRINT.md 2>/dev/null`. The file MUST exist AND contain an active bolt. If not, planning did not complete — run `/pm plan` again. Do NOT proceed without an active bolt.

---

### Step 2b: Deepen the Plan

```
/deepen-plan
```

This launches parallel research agents to stress-test the plan, including:
- **Learnings Researcher** — past decisions from docs/solutions/ and docs/captains_log/
- **Codebase Researcher** — existing patterns, reusable code, potential conflicts
- **Best Practices Researcher** — pitfalls, security concerns, performance anti-patterns
- **Framework Compliance Researcher** — AI-DLC phase requirements and governance gates
- **Impact Scan Researcher** — greps consumers of files being changed, rates blast radius

ARTIFACT GATE: STOP. Run `grep -c "Research Summary" docs/pm/CURRENT-SPRINT.md 2>/dev/null`. The plan MUST contain a "Research Summary" section. If /deepen-plan found "Must Address" items, they must be integrated before work begins. Do NOT proceed without a research-hardened plan.

---

## Step 2c: Parallel Work Detection (Smart Handoff)

Before starting work, assess whether the bolt items can be parallelized:

Review the items in CURRENT-SPRINT.md and check:

**Parallelizable indicators (handoff to `/slfg`):**
- 3+ independent work items that touch different files
- No sequential dependencies between items
- Each item can be committed independently

**Sequential indicators (stay in `/bolt-lfg`):**
- Items share files or have import dependencies
- Later items depend on earlier items' output
- Single complex feature spanning multiple files
- 2 or fewer items (overhead not worth it)

**If parallelizable:** Announce: "This bolt has [N] independent items — handing off to `/slfg` for parallel execution. Same quality gates, faster throughput." Then invoke `/slfg $ARGUMENTS` and stop.

**If sequential or ambiguous:** Announce: "Items have dependencies — proceeding with sequential execution." Continue to Step 3.

**If the user explicitly requested `/bolt-lfg`:** Skip this check — the user chose sequential for a reason.

---

## Step 3: Work the Bolt

### 3a. Setup Isolation

Before writing code, set up an isolated environment:

```bash
# Check current branch
current_branch=$(git branch --show-current)
default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
if [ -z "$default_branch" ]; then
  default_branch=$(git rev-parse --verify origin/main >/dev/null 2>&1 && echo "main" || echo "master")
fi
```

**If on default branch:** Create a feature branch:
```bash
git checkout -b bolt/$(date +%Y%m%d)-$(echo "$ARGUMENTS" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | head -c 40)
```

**If already on a feature branch:** Ask user whether to continue here or create a new branch.

### 3b. Execute Work Items

For each item in the bolt:
1. Read the plan and any brainstorm documents for context
2. Search `docs/captains_log/` and `docs/solutions/` for relevant past learnings (knowledge retrieval loop)
3. Implement the item following existing codebase patterns
4. Write tests alongside implementation
5. Run the test suite after each logical unit
6. Commit incrementally with conventional messages

### 3c. System-Wide Check (before marking item done)

For each completed item, verify:

| Check | Action |
|-------|--------|
| What fires when this runs? | Trace callbacks, middleware, observers 2 levels out |
| Do tests exercise the real chain? | Ensure integration tests with real objects, not just mocks |
| Can failure leave orphaned state? | Test the failure path for cleanup |
| What other interfaces expose this? | Grep for the method in related classes |
| Do error strategies align? | Verify rescue/catch lists match what lower layers raise |

**Skip when:** Leaf-node changes with no callbacks, no state persistence, no parallel interfaces.

ARTIFACT GATE: STOP. Run `git diff --stat` to confirm files were created or modified. Then run the project's test command. BOTH must pass:
1. `git diff --stat` shows changed files (not empty)
2. Tests pass (exit code 0)
Do NOT proceed to Step 4 if no code changes exist or tests are failing.

---

### Step 4: Review

```
/five-persona-review
```

The review will:
- Run 12 independent persona analyses
- Produce a consolidated findings report at `docs/reviews/`
- Classify findings by severity (Critical/High/Medium/Low)

ARTIFACT GATE: STOP. Run `ls docs/reviews/*$(date +%Y%m%d)* 2>/dev/null | tail -1`. A review document MUST exist from today. If not, the review did not complete — run it again.

### Step 4b: Fix-Retest Loop (Reviewer Owns Verdict)

If the review found Critical or High issues, enter the fix-retest loop:

```
┌─────────────┐     findings      ┌──────────────┐
│  Review      │ ───────────────→ │  Fix          │
│  (owns       │                  │  (implement)  │
│   verdict)   │  ←────────────── │               │
│              │   "fixed, ready  └──────────────┘
│  Re-reviews  │    for retest"          │
│  ┌─────┐    │                          │
│  │PASS │────│──→ Proceed to Step 5     │
│  └─────┘    │                          │
│  ┌─────┐    │   cycle < 2?             │
│  │FAIL │────│──→ YES → back to fix ────┘
│  └─────┘    │   NO  → ESCALATE to user
└─────────────┘
```

**Cycle 1:**
1. Fix all Critical findings immediately
2. Fix High findings or create backlog items for them with rationale
3. Re-run affected tests
4. Commit fixes referencing finding IDs (e.g., "fix: resolve F1 from five-persona review")
5. Re-run `/five-persona-review` on the changed files only (scoped review)

**Cycle 2 (if Cycle 1 re-review found new issues):**
1. Fix remaining issues
2. Re-run scoped review
3. If STILL failing after Cycle 2: **ESCALATE TO USER**
   - Present: original findings, what was fixed, what remains
   - Ask: "Ship with known issues? Redesign? Defer?"

**Rules:**
- The **same review process** must re-evaluate fixes — you cannot self-certify
- Fix teams fix ONLY the reported issues — no scope creep, no "while I'm here" improvements
- If Cycle 2 finds the SAME issues as Cycle 1, the problem is likely architectural — escalate
- Critical security findings are a HARD BLOCK — cannot proceed without resolution

---

## Step 5: Capture Knowledge

```
/captainslog new $(echo "$ARGUMENTS" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | head -c 40)
```

The captain's log will:
- Gather git context (recent commits, branch, changes)
- Reference the previous log for continuity
- Document decisions made, issues encountered, lessons learned
- Record next steps

ARTIFACT GATE: STOP. Run `ls docs/captains_log/*$(date +%Y%m%d)* 2>/dev/null | tail -1`. A captain's log from today MUST exist. If not, knowledge capture failed — run `/captainslog new` again.

---

## Step 6: Close the Bolt

```
/pm close
```

This will:
- Gather final metrics (commits, tests, deploys)
- Archive the bolt to `SPRINT-LOG.md` with retrospective
- Move completed backlog items to done
- Update `CURRENT-SPRINT.md` status to COMPLETE

### 6b. Push and PR (if on a feature branch)

```bash
# Push the branch
git push -u origin $(git branch --show-current)

# Create PR
gh pr create --title "Bolt: $ARGUMENTS" --body "$(cat <<'EOF'
## Summary
[Auto-generated from bolt items]

## Review
- Five-persona review completed — see docs/reviews/
- Critical findings: [count] (all fixed)
- Captain's log: docs/captains_log/[latest]

## Test Plan
- [ ] All tests pass
- [ ] Review findings addressed
- [ ] Captain's log captured

Generated with Claude Code
EOF
)"
```

---

## Step 7: Compound (Optional)

If this bolt solved a non-trivial problem:

1. Check if the solution is worth documenting (multiple investigation attempts, tricky debugging, non-obvious fix)
2. If yes, create a solution document:

```bash
mkdir -p docs/solutions
```

Write to `docs/solutions/YYYY-MM-DD-[topic].md`:

```markdown
---
date: YYYY-MM-DD
topic: [kebab-case-topic]
bolt: [bolt number]
tags: [relevant-tags]
---

# [Problem Title]

## Symptom
[What was observed]

## Root Cause
[What actually caused it]

## Solution
[What fixed it]

## Prevention
[How to avoid in future]
```

3. If 3+ similar solutions exist in `docs/solutions/`, promote to a pattern document

---

## Pipeline Summary

| Step | Command | Gate | Deliverable |
|------|---------|------|-------------|
| 1 | `/brainstorm` (conditional) | Brainstorm doc exists OR skip justified | `docs/brainstorms/*.md` |
| 2 | `/pm plan` | Active bolt in CURRENT-SPRINT.md | `docs/pm/CURRENT-SPRINT.md` |
| 2b | `/deepen-plan` | Research summary + amendments applied | Research-hardened plan |
| 3 | (implementation) | Code changes + tests pass | Modified source files |
| 4 | `/five-persona-review` | Review doc + critical findings fixed | `docs/reviews/*.txt` |
| 5 | `/captainslog new` | Captain's log created | `docs/captains_log/*.txt` |
| 6 | `/pm close` + PR | Bolt archived, PR created | `docs/pm/SPRINT-LOG.md` |
| 7 | (compound, optional) | Solution doc if non-trivial | `docs/solutions/*.md` |

**If classified as Feature:** Start with Step 1 now. Remember: brainstorm/plan FIRST, then work. Never skip the gates.

---

## Enhancement Pipeline (Abbreviated)

```
plan (delta) → deepen → work → review (with fix-retest) → captainslog → close
```

Skip brainstorming — the feature already exists. Planning produces a DELTA spec (only what's changing).

1. **Plan:** Run `/pm plan` — but scope to ONLY the change, not the full feature. Set work type: Enhancement.
2. **Deepen:** Run `/deepen-plan` — impact scan is especially important (existing consumers may break).
3. **Work:** Same as Feature Step 3 (3a, 3b, 3c). Engineers READ existing implementation first.
4. **Review:** Same as Feature Step 4 (with fix-retest loop).
5. **Log:** Same as Feature Step 5.
6. **Close:** Same as Feature Step 6.

---

## Bug Fix Pipeline (Minimal)

```
work → review → captainslog → close
```

Skip brainstorming AND deepening. The bug report IS the spec.

1. **Work:** Same as Feature Step 3 — but fix ONLY the reported defect. No scope creep.
   - Branch: `fix/$(date +%Y%m%d)-description`
   - ARTIFACT GATE: `git diff --stat` shows changes + tests pass.
2. **Review:** Run `/five-persona-review` scoped to changed files only.
   - Fix-retest loop applies (max 2 cycles).
3. **Log:** Run `/captainslog new` — brief, focused on root cause and prevention.
4. **Close:** Run `/pm close` + push + PR.

---

## Hotfix Pipeline (Emergency)

```
work → commit
```

Production is broken. Speed matters.

1. **Work:** Surgical fix on a `hotfix/` branch from main. NO feature work, NO refactoring.
   - `git checkout -b hotfix/$(date +%Y%m%d)-description main`
   - Fix ONLY the production issue.
   - Run tests — if tests pass, proceed.
2. **Commit + Push:** Commit, push, create PR to main AND dev.
   - Skip formal review (speed > ceremony for emergencies).
   - Log the hotfix in captain's log AFTER deployment.

---

## Refactoring Pipeline (Engineering)

```
plan → work → review (full) → captainslog → close
```

Improving code without changing behavior. High regression risk.

1. **Plan:** Run `/pm plan` — document what's being refactored and why. Set work type: Refactoring. Impact scan is MANDATORY (refactoring touches shared code).
2. **Deepen:** Run `/deepen-plan` — focus on codebase impact and test coverage.
3. **Work:** Same as Feature Step 3. Verify behavior didn't change (existing tests must still pass with no modifications).
4. **Review:** FULL review (`/five-persona-review`). Refactoring is high-risk for regression. Fix-retest loop applies.
5. **Log:** Run `/captainslog new`.
6. **Close:** Run `/pm close` + push + PR.

---

## Pipeline Summary

| Work Type | Steps | When |
|-----------|-------|------|
| **Feature** | brainstorm → plan → deepen → work → review → log → close | New capability |
| **Enhancement** | plan (delta) → deepen → work → review → log → close | Improve existing feature |
| **Bug Fix** | work → review → log → close | Fix broken thing |
| **Hotfix** | work → commit | Production emergency |
| **Refactoring** | plan → deepen → work → review (full) → log → close | Code quality improvement |

Start with Step 0 (Classify) now.
