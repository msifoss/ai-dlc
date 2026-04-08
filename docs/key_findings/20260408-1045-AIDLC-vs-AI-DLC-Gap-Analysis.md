# AIDLC vs AI-DLC — Gap Analysis & Adoption Recommendations

**Date:** 2026-04-08
**Analyst:** Staff + Five-Persona Review Panel
**Scope:** Full framework comparison — AIDLC (orchestrator-based) vs AI-DLC (methodology-based)

---

## Executive Summary

AIDLC and AI-DLC are fundamentally different architectures solving the same problem: disciplined AI-assisted development. AIDLC is an **orchestrator that does the work** (spawns agents, enforces gates via hooks, manages state); AI-DLC is a **methodology that guides the work** (provides frameworks, skills, and review panels for a human+AI pair). Both have significant strengths the other lacks.

**Key finding:** AIDLC has 6 patterns that would materially improve AI-DLC, and 4 anti-patterns we should explicitly avoid.

---

## Architectural Comparison

| Dimension | AIDLC | AI-DLC |
|-----------|-------|--------|
| **Core model** | Orchestrator spawns specialized agents | Human + AI follow methodology via skills |
| **Enforcement** | 30+ bash hooks on 7 lifecycle events | Skill-embedded gate checks (honor system) |
| **Agent model** | 10 named agents with distinct roles | Single AI with persona rotation |
| **Team coordination** | TeamCreate + SendMessage (real-time) | Sequential skill invocation |
| **State management** | bolt-state.sh auto-corrects drift | Manual PM tracking |
| **Scope** | Builds software (code output) | Provides methodology (docs + skills output) |
| **Portability** | Tightly coupled to Claude Code experimental features | Works across 11 AI platforms |
| **Two-repo model** | Docs in AIDLC, code in separate repo | Single repo (methodology + skills) |
| **Work classification** | 7 pipeline depths (Feature → Hotfix) | Single bolt pipeline |
| **Cost model** | 10 Opus agents per bolt (~$50-100/bolt) | Single session (~$5-15/bolt) |

---

## What AIDLC Does Better (Candidates for Adoption)

### 1. WORK-TYPE CLASSIFICATION & ADAPTIVE PIPELINES
**Priority: HIGH — Adopt**

AIDLC classifies every incoming request into one of 7 types (New Feature, Enhancement, Bug Fix, Hotfix, Refactoring, Tech Debt, PRD Decomposition) and routes each through a pipeline of appropriate depth. This prevents the "full ceremony for a one-line fix" anti-pattern.

**Current ai-dlc gap:** `/bolt-lfg` runs the same pipeline regardless of work type. A typo fix gets brainstorm → plan → deepen-plan → work → review → captainslog → close. That's excessive.

**Recommendation:** Add a classification step at the top of `/bolt-lfg`:
```
classify → (route to appropriate pipeline depth) → execute
```

| Work Type | Pipeline |
|-----------|----------|
| New Feature | Full: brainstorm → plan → deepen → work → review → log → close |
| Enhancement | Abbreviated: plan (delta) → work → review → log → close |
| Bug Fix | Minimal: work → review → log → close |
| Hotfix | Emergency: work → commit (skip review for speed) |
| Refactoring | Engineering: plan → work → review (full) → log → close |

### 2. FIX-RETEST LOOP (REVIEWER OWNS VERDICT)
**Priority: HIGH — Adopt**

AIDLC's most rigorous pattern: when a reviewer finds issues, the **same reviewer** must re-evaluate the fix. Engineers cannot self-certify. Max 2 cycles, then human escalation.

**Current ai-dlc gap:** `/bolt-lfg` Step 4 says "fix Critical findings" but doesn't mandate re-review by the same panel. There's no cycle limit or escalation path.

**Recommendation:** Add fix-retest loop to `/bolt-lfg` Step 4:
```
review → (findings?) → fix → re-review (same reviewer) → pass/fail
                                          ↓ fail (cycle 2)
                                    escalate to human
```

### 3. BOLT STATE MANAGEMENT WITH DRIFT DETECTION
**Priority: HIGH — Adopt**

AIDLC's `bolt-state.sh` auto-corrects status drift by checking actual artifacts against reported status. If `qa-results.md` exists with PASS but README says ENGINEERING, it flags the discrepancy. This is battle-tested — their predecessor (AIDLS) had 218 out-of-sync statuses.

**Current ai-dlc gap:** Our PM tracking is entirely manual. `CURRENT-SPRINT.md` can drift from reality with no automated detection.

**Recommendation:** Add a `/pm verify` action that:
1. Reads CURRENT-SPRINT.md items
2. Checks git log for related commits
3. Checks docs/reviews/ for review artifacts
4. Checks docs/captains_log/ for knowledge capture
5. Flags any phase that claims complete but lacks artifacts

### 4. DECISIONS-NEEDED PROTOCOL (EXPLICIT ESCALATION)
**Priority: MEDIUM — Adopt**

AIDLC has a structured `decisions-needed.md` pattern where agents document blocking questions with categories, defaults, and CRITICAL/STANDARD severity. CRITICAL items block engineering via hooks.

**Current ai-dlc gap:** Our skills don't have a structured way to surface decisions that require human input. Questions get buried in conversation context and lost on compaction.

**Recommendation:** Add a `decisions-needed.md` template and integrate it into `/brainstorm` and `/pm plan`:
- During brainstorming, capture unresolved questions
- During planning, flag blocking decisions
- During `/bolt-lfg`, gate on CRITICAL decisions before work begins

### 5. IMPACT ANALYSIS BEFORE ENGINEERING
**Priority: MEDIUM — Adopt**

AIDLC's Tech Lead performs an impact scan at engineering start — grep the codebase for files that will be modified, identify consumers, check for shared type changes. This takes 5-10 minutes and catches integration issues early.

**Current ai-dlc gap:** `/deepen-plan` does research but doesn't specifically analyze codebase impact (which files change, what depends on them, what breaks).

**Recommendation:** Add an "Impact Scan" research agent to `/deepen-plan`:
- Grep for files referenced in the plan
- Identify importers/consumers of those files
- Check for shared type/interface changes
- Rate risk: LOW/MEDIUM/HIGH
- Add findings to the Research Summary

### 6. CONDENSED CONTEXT BLOCK FOR FOLLOW-ON WORK
**Priority: MEDIUM — Adopt**

AIDLC injects a "Condensed Context Block" for bolts 2+ so agents don't re-read everything:
```
Stack: [summary], Build: [command], Existing tables: [list], 
API pattern: [pattern], Completed bolts: [list]
```

**Current ai-dlc gap:** Each bolt starts fresh. The knowledge retrieval loop in `/pm plan` searches past logs, but there's no structured "project state summary" carried forward.

**Recommendation:** Add a project context snapshot to `/pm plan` Step 3b:
- After searching past learnings, generate a condensed context block
- Store in `docs/pm/PROJECT-CONTEXT.md`
- Reference in subsequent bolt planning

---

## What AIDLC Does Differently (Consider but Don't Adopt Wholesale)

### 7. MULTI-AGENT TEAM COORDINATION
**Assessment: Monitor, don't adopt yet**

AIDLC uses Claude Code's experimental `TeamCreate + SendMessage` for real-time 4-agent engineering teams. This enables parallel backend/frontend development with DBA and Tech Lead oversight.

**Why not adopt:** The feature is experimental, token-expensive ($50-100/bolt), and tightly coupled to Claude Code. AI-DLC's portability across 11 platforms is more valuable than faster single-platform execution. When agent teams become stable and cross-platform, revisit.

### 8. TWO-REPO ARCHITECTURE
**Assessment: Don't adopt**

AIDLC separates docs (in AIDLC repo) from source code (separate repo). This allows one AIDLC instance to manage multiple projects.

**Why not adopt:** Adds complexity without clear benefit for AI-DLC's use case. Our single-repo model with `.ai-dlc.local.yaml` per-project config is simpler and sufficient.

### 9. CTO AGENT FOR PROJECT SCAFFOLDING
**Assessment: Partial adoption — enhance /init-project**

AIDLC's CTO agent reads all bolt briefs, creates tech-stack.yml, gets user approval, then scaffolds the project. Two-pass pattern (questions → approval → scaffold) is thoughtful.

**Recommendation:** Enhance `/init-project` with a tech-stack questionnaire step. Not a separate agent — just a structured set of questions before scaffolding (deployment target, auth requirements, database choice, etc.).

### 10. DESIGN SYSTEM ENFORCEMENT
**Assessment: Adopt for web projects only**

AIDLC maintains a `design-system.md` and hooks that enforce frontend engineers reference it. No one-off UI components.

**Recommendation:** Add as optional guidance in Phase 3 (Construction) for web projects. Not hook-enforced — just a "Check: Does this project have a design system? Reference it before creating components."

---

## What AIDLC Gets Wrong (Anti-Patterns to Avoid)

### A1. OVER-HOOKING (30+ hooks = brittle)
AIDLC has 30+ bash hooks across 7 lifecycle events. Each hook is a potential failure point. `health-check.sh` exists specifically to diagnose hook failures. This is a sign that the enforcement layer is too complex.

**Our approach is better:** Gate checks embedded in skill instructions are more resilient. They degrade gracefully (the AI skips a check) rather than catastrophically (a hook blocks all progress).

### A2. BYPASS-PERMISSIONS AS DEFAULT
`defaultMode: "bypassPermissions"` in settings.json means ALL agents run with full permissions. This is pragmatic for development velocity but removes a safety net. A misbehaving agent can write anywhere.

**Our approach is better:** Trust-adaptive gates with risk tier overrides. Full permissions earned, not granted by default.

### A3. 10x TOKEN COST PER BOLT
Running 10 agents (many on Opus) per bolt means each bolt costs $50-100+ in API tokens. For a solo developer, this is prohibitive for routine work.

**Our approach is better:** Single-session bolt execution with persona rotation costs 5-20x less for equivalent quality. Panel-based review (5 personas in one session) is more token-efficient than 5 separate agent spawns.

### A4. EXPERIMENTAL FEATURE DEPENDENCY
AIDLC requires `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1"`. This couples the entire framework to an unstable API that could change or be removed.

**Our approach is better:** Skills work with stable Claude Code APIs. Cross-platform compatibility is a feature, not a limitation.

---

## Proposed Improvements to AI-DLC Skills

### /bolt-lfg Improvements

| # | Improvement | Source | Priority |
|---|------------|--------|----------|
| B1 | Add work-type classification at top of pipeline | AIDLC intake classification | HIGH |
| B2 | Add fix-retest loop to Step 4 (review) | AIDLC fix-retest pattern | HIGH |
| B3 | Add cycle limit (max 2) with human escalation | AIDLC escalation protocol | HIGH |
| B4 | Add impact scan to Step 2b (deepen-plan) | AIDLC Tech Lead impact scan | MEDIUM |
| B5 | Add decisions-needed gate before Step 3 (work) | AIDLC decisions-check.sh | MEDIUM |
| B6 | Reduce pipeline for bug fixes (skip brainstorm + deepen) | AIDLC work-type routing | HIGH |

### /pm Improvements

| # | Improvement | Source | Priority |
|---|------------|--------|----------|
| P1 | Add `verify` action — drift detection for sprint status | AIDLC bolt-state.sh | HIGH |
| P2 | Add condensed context block generation | AIDLC condensed context | MEDIUM |
| P3 | Add `decisions` action — manage decisions-needed.md | AIDLC decisions protocol | MEDIUM |
| P4 | Track work type per bolt (feature/enhancement/fix/refactor) | AIDLC bolt types | MEDIUM |
| P5 | Add post-merge verification step to `close` | AIDLC post-merge check | LOW |

### /staff Improvements

| # | Improvement | Source | Priority |
|---|------------|--------|----------|
| S1 | Add "Impact Assessment" to Phase 0 (trace consumers before panel) | AIDLC Tech Lead impact scan | MEDIUM |
| S2 | Add fix-verification loop — panel reconvenes to verify fix was correct | AIDLC fix-retest pattern | LOW |
| S3 | Add work-type context to panel briefing (is this feature/fix/refactor?) | AIDLC bolt types | LOW |

---

## Implementation Priority

### Sprint 1 (Critical path — biggest impact)
1. **B1 + B6:** Work-type classification in `/bolt-lfg` (adaptive pipeline depth)
2. **B2 + B3:** Fix-retest loop with cycle limits
3. **P1:** Drift detection (`/pm verify`)

### Sprint 2 (Structured decision-making)
4. **B5 + P3:** Decisions-needed protocol
5. **P4:** Work-type tracking in PM artifacts
6. **B4:** Impact scan in `/deepen-plan`

### Sprint 3 (Knowledge compounding)
7. **P2:** Condensed context block
8. **S1:** Impact assessment in `/staff` Phase 0
9. Design system guidance in Phase 3 docs

---

## Conclusion

AIDLC is an impressive engineering system with genuinely novel patterns (work-type classification, fix-retest loops, drift detection, decisions protocol). Its weaknesses (over-hooking, token cost, experimental dependencies) are architectural trade-offs we should learn from but not replicate. The 6 adoption candidates above would materially improve AI-DLC's rigor without compromising our portability, cost-efficiency, or simplicity advantages.

The biggest gap in AI-DLC today: **we treat all work the same.** A one-line bug fix runs the same pipeline as a new feature. AIDLC's work-type classification is the single highest-impact improvement we should make.
