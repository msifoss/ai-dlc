# Fully Autonomous AI-DLC Loop — Staff Engineer Panel Analysis

**Date:** 2026-03-16
**Panel:** Tim (SpaceX), Rob (Roblox), Fran (Meta), Al (AWS/Anthropic Platform), Will Larson (Moderator)
**Trigger:** User request to make AI-DLC fully autonomous — running Phase 0 through Phase 6 in a loop until complete, without permission prompts.

---

## Problem Statement

The AI-DLC framework has a sophisticated 7-phase lifecycle (Phase 0–6) with trust-adaptive gates, bolt-driven construction, and autonomous pipelines (`/bolt-lfg`, `/slfg`). However, it still requires:

1. **Human permission prompts** at every tool invocation (Claude Code's security model)
2. **Human decision gates** at phase transitions (28 gates across 7 phases)
3. **No orchestrator** above `/bolt-lfg` that chains Phase 0→6
4. **Trust Level 3 ("Autonomous")** is defined but never mechanically enforced

**Root cause chain:** Permission model interrupts execution → human gates block automation → no loop controller exists → trust levels are aspirational not operational.

**Impact:** The framework's own philosophy states "human-in-the-training-loop, not human-in-the-loop." Currently, the human is firmly in the loop.

---

## Panel Analysis

### Tim — Staff Engineer, SpaceX

**Risk assessment:**
Two distinct failure modes with vastly different blast radii:

| Type | Example | Blast Radius | Recovery | Risk Score |
|------|---------|-------------|----------|------------|
| Contained | Bad refactor, wrong test | 1 file | `git checkout` | 0.03 |
| Uncontained | Push to main, deploy, send message | Team/infra/customers | Manual | 1.0 |

Permission prompts conflate two things: tool ceremony (noise) and risk management (signal). Kill the first, transform the second.

**Options evaluated:**
- `--dangerously-skip-permissions` — Sledgehammer, no granularity. **Reject.**
- Allowlist in settings.json — Granular, persistent, correct. **Accept.**
- Claude Code hooks — Pre/post execution safety enforcement. **Accept as guard.**

**Key quote:**
"The best permission system is one where you never see it because everything safe is pre-approved, and everything dangerous is physically impossible."

**Recommendation:**
- Comprehensive allowlist for all local operations
- Shell wrapper as loop controller (NOT inside Claude)
- State machine with filesystem checkpoints
- Effort: 2-3 days

**On autonomous loops:**
"Don't build a daemon. Build a state machine that resumes. Each `claude` invocation reads the state file, executes the next phase, writes updated state, and exits. A cron or wrapper script re-invokes."

**Unique contribution:** The loop must be OUTSIDE Claude. Claude is the executor; the shell script is the loop controller. This survives context window limits, crashes, and token exhaustion.

---

### Rob — Staff Engineer, Roblox

**Risk assessment:**
The 28 human decision gates are actually three distinct types:

| Type | % of Gates | Example | Automatable? |
|------|-----------|---------|-------------|
| Verification | 65% | "Tests pass? Coverage >80%? Zero criticals?" | YES — script checks |
| Judgment | 25% | "Right requirements? Right architecture?" | FRONT-LOAD — decide before loop starts |
| Political | 10% | "Product owner approves?" | REPLACE — post-hoc review for Solo+AI |

**Key quote:**
"You don't need the AI to ask permission. You need the AI to have already been told what 'good' looks like before it starts."

**Recommendation:**
- **Mission Brief** template: consolidate all human judgment into one document consumed before the loop starts
- Front-load ALL decisions into Phase 0
- Automated verification replaces 65% of gates
- Post-hoc review replaces remaining gates
- Effort: 2 days

**Unique contribution:** The Mission Brief pattern. Currently, requirements, architecture, and acceptance criteria are scattered across Phase 1-2 deliverables. A consolidated brief that the loop controller reads at startup answers every question upfront.

---

### Fran — Staff Engineer, Facebook/Meta

**Risk assessment:**
Two clean buckets:

**Bucket 1: Fix yesterday (blocks autonomy, zero risk)**

| Blocker | Fix | Effort |
|---------|-----|--------|
| Permission prompts for file read/write/edit | Allowlist in settings.json | 15 min |
| Permission prompts for git operations | Allowlist Bash(git:*) | 15 min |
| Permission prompts for test runners | Allowlist Bash(npm test), etc. | 15 min |
| Permission prompts for skills | Allowlist Skill(*) | 5 min |
| No loop controller | Shell wrapper + state file | 2 hours |

**Bucket 2: Don't touch (real safety)**

| Gate | Why Keep |
|------|----------|
| git push to remote | Affects others |
| Deploy to production | Irreversible |
| External API calls | Visible to others |
| Delete outside project dir | Blast radius |

**Key quote:**
"The 80/20 here is dead simple: allowlist everything local, gate everything external. Local operations are all reversible via git. External operations are not."

**Recommendation:**
- Settings.json overhaul (15 min)
- Loop wrapper script (2 hours)
- Checkpoint files per phase (30 min)
- CI-style automated gates
- Effort: 1 day

**Unique contribution:** The checkpoint file pattern — each phase writes evidence JSON:
```json
{
  "phase": 3,
  "status": "complete",
  "evidence": {
    "tests_passed": 142,
    "coverage": 87.3,
    "critical_findings": 0
  },
  "next_phase": 4
}
```

---

### Al — Staff Engineer, AWS (Claude Code / Anthropic Platform)

**Risk assessment:**
What Claude Code actually supports for autonomous operation:

| Feature | Exists? | Notes |
|---------|---------|-------|
| `--print` mode | YES | Non-interactive, full tool access |
| Allowlist in settings.json | YES | Granular permission pre-approval |
| `--continue` flag | YES | Resume previous conversation |
| `--allowedTools` CLI flag | YES | Per-invocation tool policy |
| `--dangerously-skip-permissions` | YES | Nuclear option |
| Hooks (pre/post tool) | YES | Can enforce safety policies |
| Built-in loop/daemon mode | NO | Must use external wrapper |
| Automated trust escalation | NO | Trust levels are conceptual |

**Key quote:**
"The allowlist is your permission policy. The hook is your guardrail. The state file is your control plane. Together they give you autonomous execution with safety."

**Recommendation:**
- Allowlist-first approach
- `claude -p --continue` for non-interactive resumable execution
- State machine in `.dlc-state/`
- Shell orchestrator script
- Effort: 2 days

**Unique contribution:** The `--continue` flag enables multi-session loops with conversation continuity:
```bash
SESSION_ID=""
while [[ $(jq -r .status .dlc-state/current.json) != "COMPLETE" ]]; do
  if [[ -z "$SESSION_ID" ]]; then
    SESSION_ID=$(claude -p "Start DLC loop." --output-format json | jq -r .session_id)
  else
    claude -p --continue "$SESSION_ID" "Continue DLC loop."
  fi
done
```

---

## Consensus Matrix

| Question | Tim (SpaceX) | Rob (Roblox) | Fran (Meta) | Al (Anthropic) |
|----------|-------------|-------------|-------------|----------|
| Use allowlist for permissions? | YES | YES | YES | YES |
| Shell wrapper as loop controller? | YES | YES | YES | YES |
| State file for phase tracking? | YES | YES | YES | YES |
| Front-load human judgment? | YES | YES | YES | YES |
| Automated verification gates? | YES | YES | YES | YES |
| Allow git push autonomously? | NO | NO | NO | NO |
| Allow deploy autonomously? | NO | NO | NO | NO |
| Build loop inside Claude? | NO | NO | NO | NO |
| `--dangerously-skip-permissions`? | NO | NO | NO | Only in containers |
| Mission Brief essential? | Nice-to-have | ESSENTIAL | Nice-to-have | Nice-to-have |
| Total effort | 2-3 days | 2 days | 1 day | 2 days |

**Unanimous:** Allowlist + shell wrapper + state file + keep git push/deploy gated
**Majority (3-of-4):** Mission Brief is valuable but not blocking for v1

---

## Clarifying Questions

| Question | Answer | Impact |
|----------|--------|--------|
| Does Claude Code support Bash glob patterns in allowlists? | Yes — `Bash(find:*)` pattern exists in current settings | Confirms glob-style allowlists work |
| Does `claude -p` support tool use? | Yes — full tool access in print mode | Shell wrapper approach is viable |
| Does `--continue` work across invocations? | Yes — resumes previous conversation | Enables multi-session loops |
| What happens at context limit? | Auto-compresses prior messages | Loop doesn't NEED to restart per phase |
| Can `/bolt-lfg` run unattended with allowlist? | Yes — if all tools are allowlisted | MVP is just: fix allowlist + wrap in loop |

---

## Will Larson's Decision

**Scope:** Two-tier delivery — immediate fix today, proper command this week.

### Tier 1: Immediate (4 hours) — Make bolt-lfg run unattended

| Step | What | Why | Effort |
|------|------|-----|--------|
| 1 | Overhaul `.claude/settings.local.json` | Eliminates 95% of permission prompts | 30 min |
| 2 | Create `scripts/dlc-loop.sh` shell wrapper | External loop survives context limits | 1 hour |
| 3 | Create `.dlc-state/` checkpoint pattern | Phase tracking between iterations | 30 min |
| 4 | Test end-to-end on sample project | Verify hands-free operation | 2 hours |

### Tier 2: Proper (9 hours) — Full DLC Loop Command

| Step | What | Why | Effort |
|------|------|-----|--------|
| 5 | Create Mission Brief template | Front-loads all human judgment | 1 hour |
| 6 | Create `/dlc-loop` command | Orchestrates Phase 0→6 with automated gates | 4 hours |
| 7 | Define automated gate criteria per phase | Replaces human verification gates | 2 hours |
| 8 | Add `autonomous` section to `.ai-dlc.local.yaml` | Per-project autonomy config | 1 hour |
| 9 | Update AUTONOMOUS-EXECUTION-GUIDE.md | Document the architecture | 1 hour |

**Total: 13 hours across both tiers.**

### The Allowlist (Recommended)

```json
{
  "permissions": {
    "allow": [
      "Read", "Write", "Edit", "Glob", "Grep",
      "Skill(*)", "Agent(*)", "WebSearch",
      "Bash(git add:*)", "Bash(git commit:*)",
      "Bash(git checkout:*)", "Bash(git branch:*)",
      "Bash(git diff:*)", "Bash(git log:*)", "Bash(git status:*)",
      "Bash(npm:*)", "Bash(npx:*)", "Bash(node:*)",
      "Bash(python:*)", "Bash(mkdir:*)", "Bash(ls:*)",
      "Bash(find:*)", "Bash(jq:*)", "Bash(bash scripts/*)"
    ]
  }
}
```

### The Loop Architecture

```
┌──────────────────────────────────────────────────────┐
│                  dlc-loop.sh (shell)                  │
│                                                       │
│  1. Human fills out Mission Brief                     │
│  2. while state != COMPLETE:                          │
│       phase = read .dlc-state/current.json            │
│       claude -p --continue $SESSION \                 │
│         "Execute Phase $phase. Read state + brief."   │
│       validate_checkpoint $phase                      │
│       if invalid: HALT                                │
│     done                                              │
│  3. echo "DLC complete. Review at your convenience."  │
└──────────────────────────────────────────────────────┘
```

### What's Explicitly Deferred

| Item | Rationale | Revisit When |
|------|-----------|--------------|
| Autonomous git push | Affects shared state | CI can validate before merge |
| Autonomous deploy | Irreversible | Canary + auto-rollback proven |
| `--dangerously-skip-permissions` | Sledgehammer | Never in dev; consider for CI |
| Multi-agent swarm for full DLC | Phases are sequential | Phase parallelism identified |
| Mechanical trust enforcement | Needs persistent scoring | Bolt count tracking automated |

---

## Key Takeaways

1. **Loop outside, execute inside.** Claude is the executor, not the orchestrator. A shell script loops; Claude does one phase per invocation.

2. **Allowlist = autonomy.** Permission prompts are an unconfigured Claude Code, not a limitation. A comprehensive settings.json eliminates them for safe operations.

3. **Front-load judgment, automate verification.** Human decisions belong in the Mission Brief (before the loop). Machine verification belongs in checkpoint files (during the loop).

4. **Gate on evidence, not ceremony.** "Tests pass at 87% coverage with 0 critical findings" beats "human clicked approve."

5. **State file is the control plane.** Read state → do work → write state → validate. Survives crashes, context limits, and token exhaustion.

---

## Eliminating Permission Prompts — Practical Methods

| Method | How | When to Use |
|--------|-----|-------------|
| **Allowlist** (recommended) | `.claude/settings.local.json` → `permissions.allow` array | Always — permanent, granular, auditable |
| **CLI flag** | `claude --allowedTools "Read,Write,Edit,Bash,Skill,Agent"` | Per-session scripts |
| **Accept-all in session** | Type `!` at permission prompt | Quick interactive sessions |
| **Nuclear** | `claude --dangerously-skip-permissions` | Only in isolated containers |

---

## Files Referenced

| File | Role |
|------|------|
| `.claude/settings.local.json` | Permission allowlist configuration |
| `docs/reference/AUTONOMOUS-EXECUTION-GUIDE.md` | Current autonomy model |
| `docs/governance/SOLO-AI.md` | Solo+AI governance with trust levels |
| `skills/commands/bolt-lfg.md` | Existing autonomous bolt pipeline |
| `skills/commands/slfg.md` | Parallel swarm variant |
| `docs/framework/PHASE-0-FOUNDATION.md` through `PHASE-6-EVOLUTION.md` | All 7 phase guides |

---

## Implementation Plan

1. **Overhaul allowlist** — Edit `.claude/settings.local.json` with comprehensive tool permissions
2. **Create `scripts/dlc-loop.sh`** — Shell wrapper with state machine and `claude -p --continue`
3. **Create `.dlc-state/` pattern** — `current.json` for phase tracking, `phase-N-complete.json` for evidence
4. **Create `templates/MISSION-BRIEF.md`** — Consolidated human judgment document
5. **Create `skills/commands/dlc-loop.md`** — Full DLC orchestrator command
6. **Define automated gate criteria** — Threshold-based verification per phase transition
7. **Add `autonomous` config section** — To `.ai-dlc.local.yaml` schema in setup command
8. **Update `AUTONOMOUS-EXECUTION-GUIDE.md`** — Document loop architecture and permission config
9. **Test end-to-end** — Run on a sample project to verify hands-free operation

## Findings to Fix

| # | File | Description | Fix |
|---|------|-------------|-----|
| F1 | `.claude/settings.local.json` | Allowlist is minimal — only covers a few specific commands | Expand to comprehensive tool coverage |
| F2 | `skills/commands/` | No `/dlc-loop` command exists | Create orchestrator that chains Phase 0→6 |
| F3 | `templates/` | No Mission Brief template | Create consolidated judgment document |
| F4 | `.ai-dlc.local.yaml` schema | No `autonomous` config section | Add thresholds, excluded operations, gate config |
| F5 | `docs/reference/AUTONOMOUS-EXECUTION-GUIDE.md` | Describes graduated autonomy but no mechanical enforcement | Add loop architecture, permission config, checkpoint pattern |
| F6 | `scripts/` | No loop controller script | Create `dlc-loop.sh` with state machine |
