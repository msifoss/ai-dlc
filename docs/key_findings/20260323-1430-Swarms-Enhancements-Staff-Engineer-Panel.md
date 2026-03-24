# Swarms-Inspired Enhancements — Staff Engineer Panel Analysis

**Date:** 2026-03-23
**Panel:** Tim (SpaceX), Rob (Roblox), Fran (Meta), Al (AWS/Claude Code Platform), Will Larson (Moderator)
**Trigger:** Analysis of Swarms multi-agent framework revealed 4 patterns to adopt into AI-DLC

---

## Problem Statement

AI-DLC has 28 skills/commands but lacks intelligent routing, formal decision protocols, parallel execution awareness, and automated composition. Users must know command names, panels debate without structured voting, pipelines run sequentially even when parallelizable, and users manually decide skill sequences.

| Friction Point | Impact | Cost of Inaction |
|---|---|---|
| No skill routing | Users run wrong command or ask "which one?" | Adoption friction, wasted iterations |
| No formal voting | Panel decisions are narrative-only, hard to trace | Ambiguous decisions, no audit trail |
| Sequential-only pipelines | Wall-clock time 2-5x longer than necessary | Slower delivery, context window waste |
| Manual composition | Users must understand all 28 skills to chain them | Expert-only usage, no self-service |

---

## Panel Analysis

### Tim — Staff Engineer, SpaceX

**Risk assessment:** Four features at once is a red flag. Each feature should be stripped to the bone. Skill Router = keyword table, not embeddings. Voting = table appended to output, not new phase. DAG = annotate existing commands. Auto Team = lookup prompt.

**Key quote:** "The best orchestration is no orchestration. Before adding a router, ask: would a better README solve this?"

**Recommendation:** Build all 4 but ruthlessly scoped. Effort: 2-3 hours.

**Unique contribution:** Hardcoded skill catalog IS correct — read `skills/README.md` as source of truth. Embeddings are overkill for 23 items. You'd need 200+ before semantic matching beats keyword scan.

### Rob — Staff Engineer, Roblox

**Risk assessment:** `using-superpowers` already IS a router (for Claude). `/slfg` already handles parallel execution. The consensus matrix already HAS per-panelist positions. Half the proposal duplicates existing functionality.

**Key quote:** "You don't have a routing problem. You have a disambiguation problem. And you don't have a parallelism gap — you have `/slfg` already."

**Recommendation:** Enhance superpowers + add `/route` for humans. Enhance existing consensus matrix (add confidence column). Enhance `/slfg` instead of adding DAG to bolt-lfg. New `/compose` for workflow recommendation. Effort: 3-4 hours.

**Unique contribution:** The consensus matrix is already a vote — add confidence column and tally row. Don't build a new voting system.

### Fran — Staff Engineer, Meta

**Risk assessment:** Two buckets. Fix yesterday: Voting Protocol + Skill Router. Don't care: DAG Workflows + Auto Team Builder.

**Key quote:** "The consensus matrix is already a vote. It just doesn't know it yet."

**Recommendation:** Ship Voting + Router this bolt. Defer or minimally scope DAG and Auto Team. Effort: 1-2 hours for priority features.

**Unique contribution:** Decision Record format — `DECISION: X | VOTE: N-M | CONFIDENCE: avg | DISSENT: panelist: concern` — greppable, loggable, traceable. One format across ALL panels.

### Al — Staff Engineer, AWS (Claude Code Platform)

**Risk assessment:** Claude Code's Agent tool with `run_in_background` IS the parallel engine. Don't build a scheduler in markdown. Auto Team Builder's natural home is `/dlc-loop` Step 0, not standalone.

**Key quote:** "Don't build a scheduler in markdown. Teach `/bolt-lfg` to recognize when it's holding a parallel problem and hand off to `/slfg`."

**Recommendation:** `/route` reads catalog. Voting enhances existing matrix. Smart handoff bolt→slfg. Compose embeds in `/dlc-loop` + standalone. Effort: 3-4 hours.

**Unique contribution:** Pipeline spec format (YAML-like) as lingua franca between `/compose`, `/dlc-loop`, and `/bolt-lfg`. But only if earned — don't build until two commands need it.

---

## Consensus Matrix

| Question | Tim (SpaceX) | Rob (Roblox) | Fran (Meta) | Al (AWS) |
|---|---|---|---|---|
| Build Skill Router? | YES — keyword table | YES — enhance superpowers + `/route` | YES — standalone `/route` | YES — `/route` reads catalog |
| Build Voting Protocol? | YES — minimal table | YES — enhance existing matrix | YES — greppable decision record | YES — compact format |
| Build DAG Workflows? | NO — annotate existing | ENHANCE `/slfg` | DEFER | SMART HANDOFF bolt→slfg |
| Build Auto Team Builder? | YES — minimal lookup | YES — `/compose` | DEFER | EMBED in `/dlc-loop` |

DECISION: Build all 4 as surgical enhancements | VOTE: 4-0 (router), 4-0 (voting), 3-1 (DAG as handoff), 3-1 (auto team) | CONFIDENCE: 4.2 | DISSENT: Fran prefers deferring DAG and Auto Team

**Unanimous:** Build Router + Voting. No DAG engine. Greppable Decision Record format.
**Majority (3-1):** DAG as smart handoff in bolt-lfg → slfg. Auto Team Builder as `/compose` + `/dlc-loop` embed.

---

## Will Larson's Decision

Build all 4 features as surgical enhancements to existing skills, plus 2 new commands.

| Step | What | Why | Effort |
|---|---|---|---|
| 1 | Create `/route` command | Human-invokable skill discovery via catalog matching | 30 min |
| 2 | Add Voting Protocol to staff-panel | Confidence scores + tally + Decision Record in Phase 3 | 45 min |
| 3 | Add Voting Protocol to exec-review | Same Decision Record format for consistency | 30 min |
| 4 | Add smart handoff to `/bolt-lfg` | Detect parallel-eligible work, delegate to `/slfg` | 20 min |
| 5 | Enhance `/slfg` dependency detection | Better heuristics for file/import-level deps | 30 min |
| 6 | Create `/compose` command | Pipeline recommendation from task/Mission Brief | 45 min |
| 7 | Update `skills/README.md` | Catalog updates, Decision Record convention | 15 min |

**Total: ~3.5 hours.**

### Additional features suggested by panel

| Feature | By | Description | Priority |
|---|---|---|---|
| Decision Record format | Fran | Standardized greppable line across all panels | HIGH — build with voting |
| Pipeline Spec format | Al | YAML-like output from `/compose` | MEDIUM — build if natural |
| Superpowers routing enhancement | Rob | Improve `using-superpowers` matching | LOW — separate bolt |

### Deferred

| Item | Rationale | Revisit When |
|---|---|---|
| DAG scheduler/engine | Markdown can't execute topology sorts | Never |
| Embedding-based routing | 23 skills don't need semantic search | Skill count > 100 |
| Pipeline spec YAML | Premature until two commands need it | `/dlc-loop` integration tested |

### Key Takeaways

1. **Enhance before you create.** Three of four features enhance existing skills.
2. **Decision Record format is the real win.** Greppable decisions across all panels.
3. **Smart handoff > smart scheduling.** bolt-lfg delegates to slfg.
4. **Route for humans, superpowers for Claude.** Different use cases.
