# AIDLC Framework — Staff Engineer Panel Analysis

**Date:** 2026-04-08
**Panel:** Tim (SpaceX), Rob (Roblox), Fran (Meta), Al (AWS), Will Larson (Moderator)
**Subject:** Deep analysis of AIDLC — a competing orchestrator-based AI development lifecycle framework
**Repository:** /Users/msichris/repos/AIDLC/

---

## Problem Statement

AIDLC represents a fundamentally different architectural approach to AI-assisted development — an orchestrator that spawns specialized agents with hook-enforced phase gates, real-time team coordination via Claude Code's experimental TeamCreate/SendMessage, and a two-repo architecture (docs vs source). We need to assess: What are the genuine engineering strengths? What are the risks and weaknesses? What patterns should our own AI-DLC framework consider adopting? What should we avoid?

---

## Architecture Summary (Pre-Panel Reference)

| Dimension | AIDLC | AI-DLC (Ours) |
|-----------|-------|----------------|
| Core model | Orchestrator spawns 10 role-specific agents | Skills/commands invoked sequentially or in parallel |
| Agent coordination | TeamCreate + SendMessage (real-time) | Sequential pipeline, parallel via `/slfg` |
| Phase gates | 28 bash hooks (PreToolUse, SubagentStart, SubagentStop, etc.) | Trust-adaptive gates + Mission Brief |
| State tracking | `bolt-state.sh` (JSON from file artifacts) | Checkpoint JSON files per phase |
| Repo topology | Two repos (docs in AIDLC, source separate) | Single repo (framework + project) |
| Agent count | 10 named agents + orchestrator | 37 skills/commands (no named agents) |
| Enforcement | Hook scripts block bad actions in real-time | Skill instructions + audit checks |
| Context management | `inject-bolt-context.sh` + `compaction-recovery.sh` | CLAUDE.md + Mission Brief |
| Work unit | Bolt (decomposed from PRD) | Bolt (similar concept) |

---

## Panel Analysis

### Tim — Staff Engineer, SpaceX

**Focus: Blast radius of the hook enforcement layer, failure modes of multi-agent coordination, complexity vs value, what happens when agents go off-script**

#### The Hook Layer Is Genuinely Impressive — And Genuinely Dangerous

I count 28 distinct hook scripts across 6 hook events (PreToolUse, PostToolUse, SubagentStart, SubagentStop, TeammateIdle, TaskCompleted, PreCompact). This is the most comprehensive hook-based enforcement system I have seen built on top of Claude Code. The engineering is real.

**What works well:**

| Hook | Purpose | Assessment |
|------|---------|------------|
| `gate-check.sh` | Blocks agents from starting without prerequisites | Excellent. Parses bolt state, maps agent->phase, checks artifact existence. Prevents the #1 orchestrator mistake (spawning engineering before spec exists). |
| `enforce-team-usage.sh` | Forces engineering agents to use TeamCreate, not solo | Smart. Prevents the orchestrator from accidentally spawning a backend-engineer as a solo subagent, which would lose real-time coordination. Has a fix-cycle bypass. |
| `bolt-state.sh` | Auto-corrects README status drift from artifact presence | Solves a real problem they documented: "218 features out of sync" in their predecessor project (AIDLS). The auto-correction is defensive programming at its best. |
| `spec-completeness.sh` | Validates product-output.md has required sections before engineering | Checks for Acceptance Criteria, API Contracts, Data Models, Wiring Requirements. Even validates table structure. This prevents garbage-in engineering. |
| `inject-bolt-context.sh` | Injects project/stack/bolt context into every agent prompt | Eliminates the "agent reads the wrong config" failure mode. Includes stack-specific wiring checklists from `standards/checklists/`. |
| `compaction-recovery.sh` | Writes orchestrator journal + active bolt state before context compaction | Critical for surviving long sessions. Without this, the orchestrator loses its place after compaction. |

**What concerns me:**

1. **Cascading hook failures.** The hooks call `bolt-state.sh` internally (I see it called from `gate-check.sh`, `inject-bolt-context.sh`, `verify-bolt-output.sh`, `design-system-compliance.sh`, and others). If `bolt-state.sh` breaks — even transiently (disk full, node crash, malformed JSON) — every hook downstream fails. There is no circuit breaker. All hooks exit 0 on errors (fail-open), which is the right default for availability but means a broken `bolt-state.sh` silently disables ALL enforcement.

2. **Hook execution time.** `bolt-state.sh` reads every bolt directory, parses every README.md, every code-review.md, every qa-results.md. For a project with 50+ bolts, this could take 2-5 seconds per invocation. Since SubagentStart fires 4 hooks that each call `bolt-state.sh`, spawning an engineering team could take 15-20 seconds just in hook overhead. With PostToolUse running `build-check.sh` on every Edit/Write, the developer experience degrades as the project grows.

3. **Single-threaded orchestrator is a bottleneck.** The orchestrator loop is: get state -> pick bolt -> spawn agent -> verify -> update status -> journal -> loop. This is fundamentally serial. Multi-bolt parallelism is described ("BOLT-001 and BOLT-002 pipelines run independently") but the orchestrator itself cannot spawn two engineering teams simultaneously because it is a single Claude session. The parallelism only works for product phases (solo agents) where the orchestrator fires-and-forgets.

4. **Agent off-script blast radius.** Each agent gets `mode: "bypassPermissions"` — meaning every agent can read/write/bash anything. The hook layer is the only guardrail. If an agent ignores its Phase Declaration (the "I STOP and flag it" instruction), the hooks catch some violations (e.g., `block-src-writes.sh` for product agents) but not all. A backend-engineer that decides to modify the frontend has no hook blocking it — only the instruction in its agent definition. This is defense-in-depth by instruction, not by mechanism.

5. **The DBA real-time review pattern is architecturally fragile.** The DBA is supposed to review "EVERY query as engineers write them via SendMessage." This requires the DBA agent to be active and listening while backend-engineer writes code. If the DBA finishes its initial review and becomes idle, new queries written later may not get reviewed in real-time. The `TeammateIdle` hook only runs `build-check.sh`, not DBA re-review.

**Blast radius analysis:**

| Failure | Detection | Blast Radius | Recovery |
|---------|-----------|-------------|----------|
| Hook script breaks (syntax error) | `health-check.sh` at startup | All enforcement disabled (fail-open) | Fix script, re-run |
| Agent ignores phase boundaries | `verify-bolt-output.sh` at SubagentStop | Wrong artifact in wrong place | Manual cleanup |
| Orchestrator picks wrong bolt | `bolt-state.sh` dependency check | Wastes one agent cycle | Re-run loop |
| TeamCreate coordination deadlock | No detection | Engineering stalls indefinitely | Human intervention |
| `bolt-state.sh` returns stale data | Auto-correction catches some drift | Could skip a phase | Re-run bolt-state |
| DBA misses a query | `verify-bolt-output.sh` checks dba-audit exists, not content | Tenant isolation violation ships to QA | QA or code review catches it |

**Key quote:**
"This is the most ambitious hook-based enforcement system I have seen on Claude Code. The engineering quality is high. But it is a complexity bet — they are betting that 28 hooks maintained in bash, calling Node.js for JSON parsing, running `bolt-state.sh` repeatedly, will stay correct as the project evolves. That bet has a shelf life."

**Verdict: ADOPT the artifact-presence gate pattern. AVOID the deep hook coupling and repeated bolt-state.sh calls.**

---

### Rob — Staff Engineer, Roblox

**Focus: Developer experience, cognitive load of the system, latent bugs in the multi-agent handoff patterns, what breaks when things diverge**

#### Cognitive Load Analysis

I mapped the knowledge required to operate this system and found three distinct user personas:

| Persona | What They Need to Know | Cognitive Load |
|---------|----------------------|----------------|
| Framework Author | WORKFLOW.md (760+ lines), 10 agent definitions (avg 200 lines each), 28 hooks, standards, templates | Extreme |
| Project User (setting up) | CLAUDE.md (96 lines), project-config.json structure, init-project.sh, CTO questionnaire flow | Moderate |
| Passive Observer (watching it work) | bolt-state.sh output, README.md statuses | Low |

The framework is designed for a single persona: the **framework author who is also the project user.** It assumes deep familiarity with every hook, every agent, and every handoff. For a new user, the onboarding surface area is enormous.

**WORKFLOW.md is 760+ lines of critical operational knowledge.** Unlike our AI-DLC where CLAUDE.md is the bootstrap and skills are self-contained, AIDLC's CLAUDE.md is 96 lines that say "read WORKFLOW.md for everything." The orchestrator must internalize WORKFLOW.md on every session start. At ~760 lines, this consumes significant context window before any work begins.

#### Handoff Pattern Analysis

I traced the artifact handoff chain for a single bolt:

```
PRD
 -> decomposer -> brief.md + README.md
   -> product-analyst -> product-analysis.md
     -> fullstack-designer -> product-output.md + design-system.md update
       -> tech-lead -> impact-assessment.md (reads product-output.md)
       -> backend-engineer -> implementation.md + code (reads product-output.md)
       -> frontend-engineer -> implementation.md + code (reads product-output.md + design-system.md)
       -> dba -> dba-audit.md (reviews engineer code via SendMessage)
       -> tech-lead -> implementation.md sign-off (reviews all code)
         -> code-reviewer -> code-review.md
           -> security-reviewer -> security-findings.md
             -> qa-engineer -> qa-results.md
```

**11 handoff points for a single Feature bolt.** Each handoff is mediated by a markdown artifact. The chain has several latent bugs:

1. **product-analysis.md -> product-output.md information loss.** The Product Analyst produces research, stories, criteria, scope, and integration requirements. The Full-Stack Designer is instructed to "carry forward" stories and criteria but "condense research into 2-3 paragraphs." This condensation is lossy. Engineers never see product-analysis.md directly — they only see product-output.md. If the Full-Stack Designer drops a criterion during carry-forward, it is silently lost. There is no hook that validates criteria count preservation.

2. **Dual implementation.md ownership.** Both backend-engineer and frontend-engineer write to `implementation.md`. The template at `templates/implementation.md` is a single file. In a TeamCreate scenario, two agents are writing to the same file concurrently via SendMessage coordination. This is a merge conflict waiting to happen. The tech-lead then adds a sign-off section to the same file. Three writers, one file, no locking mechanism.

3. **Design system divergence.** The fullstack-designer adds components to `design-system.md`. The frontend-engineer reads `design-system.md` and implements components. But the `design-system-compliance.sh` hook only warns (exit 0) — it does not block. If the frontend-engineer creates a component not in the design system, the warning may be lost in output noise. Over time, the design system and implementation diverge.

4. **The "Consider the Whole Application" instruction is aspirational.** Every agent definition includes "Read the bolt index to understand how this bolt fits into the broader system." For a project with 30 bolts, reading the index is feasible. For 100 bolts, the agent's context window cannot hold the full index plus its own bolt's artifacts. The instruction does not degrade gracefully.

5. **QA constraint: "Must run in main session."** The qa-engineer explicitly states: "Playwright MCP tools are session-level and are NOT inherited by subagents." This means QA cannot be parallelized, cannot be spawned as a team member, and must run in the foreground of the main Claude session. For a project with 20 bolts, QA is a serial bottleneck. Every bolt waits for the previous bolt's QA to complete before the main session is available.

#### Developer Experience Comparison

| DX Dimension | AIDLC | AI-DLC |
|--------------|-------|--------|
| Bootstrap time | Read CLAUDE.md (96 lines) + run bolt-state.sh + WORKFLOW.md loaded by orchestrator | Read CLAUDE.md (~100 lines) + `/setup` |
| First bolt | init-project.sh -> decomposer -> PA -> FSD -> TeamCreate -> code review -> security -> QA | `/brainstorm` -> `/pm plan` -> `/bolt-lfg` |
| Feedback loop | Hooks fire on every tool use (real-time but noisy) | Checkpoint files after each phase (batch) |
| Error recovery | `compaction-recovery.sh` writes journal before compaction | Mission Brief + checkpoint resume |
| Visibility | bolt-state.sh JSON output, README.md statuses, orchestrator-journal.md | `/motherhen` health checks, `/sitrep` |
| Configuration | project-config.json + tech-stack.yml (two files, manual setup) | `.ai-dlc.local.yaml` (one file, auto-detected) |

**Key quote:**
"AIDLC optimized for correctness at every handoff point. AI-DLC optimized for flow. AIDLC's approach is like a factory assembly line with quality inspection at every station. Ours is like a craft workshop where one person (or one pipeline) carries the work end to end. Both can produce quality output, but the factory model breaks down when the inspection stations outnumber the workers."

**Verdict: ADOPT the two-repo separation pattern (docs vs source). ADOPT the auto-correction in bolt-state.sh. AVOID the 11-handoff chain and the dual-file-ownership pattern.**

---

### Fran — Staff Engineer, Meta

**Focus: Pragmatic assessment of what is "fix yesterday" vs "don't care", the 80/20 of their approach, CI/CD integration quality**

#### Fix Yesterday (Critical Issues)

**1. bypassPermissions on all agents is a ticking time bomb.**
Every agent runs with `mode: "bypassPermissions"`. The hooks provide guardrails, but hooks can fail silently (they exit 0 on error). In production use, one broken hook + one off-script agent = unrestricted file system access with no enforcement. This is security-by-convention, not security-by-design.

Severity: **HIGH.** If this framework is used by teams (not just solo developers), a single misconfigured hook disables all safety.

Fix: Move critical enforcement from hooks to agent-level tool restrictions. The DBA already has `disallowedTools: Bash` — extend this pattern. Backend-engineer should not have Write access to docs paths. Frontend-engineer should not have Write access to backend paths. The `block-src-writes.sh` hook for product agents is the right idea — but it should be belt-and-suspenders with agent-level restrictions too.

**2. No CI/CD integration whatsoever.**
The CTO agent creates a "CI/CD skeleton" during scaffold, but there is zero integration between the AIDLC hook system and any CI pipeline. All enforcement runs locally in the Claude Code session. If an engineer pushes code directly to the repo (bypassing the orchestrator), none of the gates apply. There is no GitHub Actions workflow, no pre-commit hook in the source repo, no PR check.

Severity: **HIGH.** The entire enforcement layer is client-side only. It evaporates when code leaves the local machine.

Fix: Extract the key gate checks (spec-completeness, tenant isolation grep, build verification) into CI-runnable scripts. The hooks already exist as bash scripts — they just need to be made CI-friendly (read from environment variables instead of Claude-specific stdin JSON).

**3. The TeamCreate/SendMessage dependency on experimental APIs.**
The settings.json enables `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS: "1"`. This is an experimental feature. The entire engineering phase depends on it. If Anthropic changes the API, deprecates it, or modifies its behavior, the core of AIDLC breaks. There is no fallback mode.

Severity: **MEDIUM-HIGH.** Experimental API dependency for a critical path.

Fix: Design a fallback where engineering agents run as sequential solo agents (like the product phase) if TeamCreate is unavailable. Degraded but functional.

#### Don't Care (Low-Priority)

- Windows path normalization in every hook (`${CLAUDE_PROJECT_DIR//\\//}`): Defensive, harmless, skip.
- The `detectors/` directory for stack-specific verification: Nice-to-have, not critical.
- Agent memory (`projects/{project}/.claude/agent-memory/`): Interesting pattern but effectiveness is unproven.
- Metrics logging (`projects/{project}/metrics.md`): Append-only log, useful for analysis, low cost.

#### The 80/20 of AIDLC

The 80% of value comes from:

1. **Artifact-gated phase transitions.** The principle that "product-output.md must exist before engineering starts" is enforced mechanically, not by instruction. This single pattern prevents the most common failure mode in AI-assisted development: building before specifying.

2. **The DBA tenant isolation gate.** The idea that one agent has absolute veto power over a specific concern (tenant isolation) — and that veto cannot be overridden by the tech lead, only by a human — is a powerful governance pattern. It separates operational authority from technical authority.

3. **Auto-correcting state tracking.** `bolt-state.sh` derives status from artifact presence, not from manually maintained status fields. It auto-corrects drift. This is the right approach to state management in a system where multiple agents modify state.

4. **Context injection via hooks.** `inject-bolt-context.sh` solves the "agent starts cold" problem by pre-loading project context, stack info, and bolt state into every agent's prompt. The agent does not need to discover this information — it is given.

The 20% that is over-engineered:

1. The 10-agent roster. Most projects need 3-4 distinct agent behaviors (spec, build, review, test). The decomposition into product-analyst, fullstack-designer, backend-engineer, frontend-engineer, dba, tech-lead, code-reviewer, qa-engineer, cto, and decomposer creates coordination overhead that exceeds the specialization benefit for typical projects.

2. The design system enforcement chain. Three enforcement points (fullstack-designer writes it, frontend-engineer reads it, design-system-compliance.sh warns about drift) for a concern that matters only for UI-heavy projects. Infrastructure and backend-only bolts carry this overhead for zero benefit.

3. The fix-retest loop with max 2 cycles. Codifying "max 2 fix attempts, then escalate" assumes a universal retry budget. Some defects are trivial (typo in error message), some are fundamental (wrong data model). A cycle count is a blunt instrument.

**Key quote:**
"The 80/20 here is clear: artifact gates, DBA veto, auto-correcting state, and context injection are worth stealing. The 10-agent coordination, design system enforcement chain, and retry-count governance are over-engineered for most use cases."

**Verdict: ADOPT artifact-gated transitions, DBA-style absolute veto for critical concerns, auto-correcting state. SKIP the agent proliferation and design system enforcement chain.**

---

### Al — Staff Engineer, AWS

**Focus: The platform architecture (hooks, agent teams, two-repo model), scaling concerns, deployment coupling, whether this architecture is sustainable**

#### Two-Repo Architecture: Genuinely Novel

AIDLC separates documentation artifacts (in the AIDLC repo) from source code (in a separate repo). This is configured via `project-config.json`:

```json
{
  "docsPath": "projects/myproject",
  "srcPath": "C:/Projects/MyApp/src",
  "srcRepoRoot": "C:/Projects/MyApp"
}
```

**Why this matters:**

1. **Clean separation of concerns.** The orchestrator, agent definitions, hooks, standards, and bolt artifacts live in one repo. The actual software lives in another. They evolve independently. A change to the AIDLC workflow does not create a commit in the project repo.

2. **Multi-project support.** The `activeProject` pattern in `project-config.json` allows one AIDLC installation to manage multiple projects. Switching projects is a config change, not a repo change. Each project has its own bolts, PRDs, design system, and tech stack.

3. **Agent isolation.** `block-src-writes.sh` prevents product agents from writing to the source repo. `block-inactive-project-writes.sh` prevents writes to non-active projects. The two-repo model makes these boundaries physical, not just logical.

**Scaling concern:** The `srcPath` is an absolute filesystem path. This works for solo developers on one machine. For teams, the path differs per developer. There is no abstraction for this — each developer would need their own `project-config.json`. For CI, the path would need to be parameterized via environment variables.

#### Hook Architecture: Platform Analysis

The hook system uses 6 Claude Code hook events:

| Event | Count | Purpose |
|-------|-------|---------|
| PreToolUse | 3 matchers (Bash, Edit\|Write, Agent) with 8 hooks | Block bad actions before they happen |
| PostToolUse | 1 matcher (Edit\|Write) with 1 hook | Build check after code changes |
| SubagentStart | 2 matchers (universal + engineering-specific) with 8 hooks | Gate, context inject, prerequisites |
| SubagentStop | 2 matchers (all agents + engineers) with 6 hooks | Verify output, update status, check wiring |
| TeammateIdle | 1 matcher (engineers) with 1 hook | Build check when engineer goes idle |
| TaskCompleted | 1 universal hook | Final output verification |
| PreCompact | 1 universal hook | Save state before context compaction |

Total: **28 hooks across 6 event types.**

**Sustainability assessment:**

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Correctness | 8/10 | Hooks are well-written bash+node. JSON parsing is correct. Error handling exits 0 (fail-open). |
| Performance | 5/10 | `bolt-state.sh` called repeatedly by multiple hooks. No caching layer. O(n) on bolt count. |
| Maintainability | 4/10 | 28 bash scripts with embedded Node.js. No test suite for hooks. Modifying one hook can break others via bolt-state.sh coupling. |
| Extensibility | 6/10 | New hooks can be added to settings.json. But the hook->bolt-state->node pipeline is complex to extend. |
| Observability | 7/10 | `health-check.sh` verifies hook health. Hooks output warnings via stderr and hookSpecificOutput JSON. |
| Resilience | 6/10 | Fail-open design prevents hooks from blocking work. But silent failures mean enforcement gaps. |

**The lib/ directory shows maturity.** The presence of `lib/resolve-paths.sh`, `lib/read-tech-stack.sh`, `lib/verdict.sh`, and `lib/dispatch.sh` indicates the hook system has been refactored at least once. The `detectors/` directory with 7 detector categories (api-contracts, design-system, docker-config, frontend-wiring, integration-wiring, route-wiring, schema-drift) shows investment in automated verification beyond simple file-existence checks.

#### TeamCreate Architecture: Scaling Analysis

The Engineering Team uses TeamCreate with 4 agents (backend-engineer, frontend-engineer, dba, tech-lead) communicating via SendMessage. This is a real-time multi-agent system.

**Scaling characteristics:**

| Dimension | Current State | At Scale |
|-----------|--------------|----------|
| Agents per team | 4 (fixed) | 4 (fixed — no dynamic scaling) |
| Communication | SendMessage (point-to-point) | O(n^2) message volume as agents coordinate |
| Context window | Each agent has its own context | No shared context — each agent reads files independently |
| Token cost | 4 opus agents * prompt size | Linear in team size, but team size is fixed |
| Coordination overhead | Tech Lead mediates disputes | Single bottleneck for all coordination |

**Critical architecture observation:** The TeamCreate model assumes that 4 agents can coordinate effectively via point-to-point messaging. This works when:
- The work is cleanly separable (backend vs frontend)
- The DBA reviews after the fact (not blocking during implementation)
- The tech-lead has bandwidth to review all code while also coordinating

It breaks when:
- Backend and frontend are tightly coupled (shared types, real-time features)
- Multiple integration points require simultaneous coordination
- The DBA finds a tenant isolation violation mid-implementation (blocks the engineer, creates coordination cascade)

**The QA bottleneck is architectural.** QA requires Playwright MCP, which is session-level only. This means:
1. QA cannot run as a subagent (confirmed in agent definition and hook)
2. QA runs in the main session, blocking the orchestrator
3. While QA runs, no other bolts can progress
4. For a 20-bolt project, QA alone could consume 40-60% of total runtime

**Comparison to our approach:** AI-DLC's `/bolt-lfg` runs the full pipeline (brainstorm -> plan -> work -> review -> captainslog -> close) in a single session. There is no agent coordination overhead because there are no separate agents — one session handles all phases. The trade-off is less specialization but dramatically less coordination cost.

#### Is This Architecture Sustainable?

**Short-term (1-6 months): Yes.** For a solo developer building multi-tenant SaaS applications (the clear target use case), this system provides strong guardrails. The hook enforcement is real. The agent specialization catches real bugs (especially tenant isolation).

**Medium-term (6-18 months): Fragile.** The dependency on experimental APIs (TeamCreate/SendMessage), the 28-hook maintenance burden, the performance degradation with bolt count, and the QA bottleneck will compound. Each new project adds complexity to `project-config.json` and the two-repo model.

**Long-term (18+ months): Unlikely to survive without major refactoring.** If Claude Code stabilizes agent teams as a first-class feature, the hook system could be simplified. If agent teams are deprecated, the entire engineering phase must be redesigned. The bet on experimental APIs is the biggest risk.

**Key quote:**
"AIDLC is a bet that the coordination cost of 10 specialized agents is less than the error rate of 1 generalist agent doing all the work. That bet pays off for complex multi-tenant SaaS where tenant isolation is existential. It does not pay off for most other project types."

**Verdict: ADOPT the two-repo separation concept. ADOPT the context injection pattern. MONITOR the TeamCreate/SendMessage pattern for when it stabilizes. AVOID building on experimental APIs for critical paths.**

---

## Consensus Matrix

| Finding | Tim | Rob | Fran | Al | Consensus |
|---------|-----|-----|------|-----|-----------|
| Artifact-gated phase transitions are the key innovation | ADOPT | ADOPT | ADOPT | ADOPT | **Unanimous ADOPT** |
| DBA-style absolute veto for critical concerns | ADOPT | ADOPT | ADOPT | ADOPT | **Unanimous ADOPT** |
| Auto-correcting state from artifact presence | ADOPT | ADOPT | ADOPT | ADOPT | **Unanimous ADOPT** |
| Context injection via hooks (inject-bolt-context pattern) | ADOPT | ADOPT | NEUTRAL | ADOPT | **Strong ADOPT** |
| Two-repo separation (docs vs source) | NEUTRAL | ADOPT | NEUTRAL | ADOPT | **Mild ADOPT** |
| 10-agent roster as default | AVOID | AVOID | AVOID | NEUTRAL | **Strong AVOID** |
| TeamCreate/SendMessage for engineering coordination | RISKY | AVOID | RISKY | MONITOR | **Consensus: WAIT** |
| 28-hook enforcement layer | RISKY | AVOID | NEUTRAL | RISKY | **Consensus: SELECTIVE** |
| bypassPermissions on all agents | AVOID | AVOID | FIX | AVOID | **Unanimous concern** |
| QA in main session (Playwright MCP constraint) | AVOID | AVOID | DON'T CARE | AVOID | **Strong AVOID** |
| Design system enforcement chain | NEUTRAL | NEUTRAL | SKIP | NEUTRAL | **Low priority** |
| Fix-retest loop with max 2 cycles | NEUTRAL | RISKY | SKIP | NEUTRAL | **Mixed** |

### Formal Votes

| Question | Tim | Rob | Fran | Al | Result |
|----------|-----|-----|------|-----|--------|
| Should we adopt artifact-gated transitions? | YES | YES | YES | YES | **4-0 YES** |
| Should we adopt the DBA veto pattern? | YES | YES | YES | YES | **4-0 YES** |
| Should we adopt auto-correcting state tracking? | YES | YES | YES | YES | **4-0 YES** |
| Should we adopt the two-repo model? | ABSTAIN | YES | ABSTAIN | YES | **2-0-2 YES** |
| Should we adopt TeamCreate coordination? | NO | NO | NO | WAIT | **3-0-1 NO** |
| Should we adopt the 10-agent model? | NO | NO | NO | NO | **4-0 NO** |
| Should we adopt the hook enforcement layer? | SELECTIVE | NO | SELECTIVE | SELECTIVE | **3-1 SELECTIVE** |
| Overall: Is AIDLC a threat to AI-DLC? | NO | NO | NO | NO | **4-0 NO** |
| Overall: Does AIDLC have patterns worth stealing? | YES | YES | YES | YES | **4-0 YES** |

---

## Will Larson — Moderator Questions & Investigation

### Question 1: "The panel says artifact-gated transitions are the key innovation. How does this differ from what AI-DLC already does with checkpoint files?"

**Investigation:** AI-DLC's checkpoint system writes JSON evidence files after each phase. AIDLC's gate-check.sh blocks agent spawning if prerequisite artifacts do not exist. The key difference:

| Aspect | AI-DLC Checkpoints | AIDLC Artifact Gates |
|--------|-------------------|---------------------|
| Timing | Written AFTER phase completes | Checked BEFORE next phase starts |
| Enforcement | `/gatekeeper` skill validates on demand | Hook fires automatically on every agent spawn |
| Granularity | Phase-level (7 checkpoints) | Artifact-level (specific files per agent) |
| Failure mode | Manual — skip if `/gatekeeper` not invoked | Automatic — cannot spawn agent without prerequisites |

**Finding:** Our checkpoint system is post-hoc validation. AIDLC's is pre-emptive blocking. Both have value, but the pre-emptive approach catches errors earlier. We could add SubagentStart-equivalent checks to `/bolt-lfg` — before each pipeline step, verify the previous step's artifact exists and has expected content.

### Question 2: "The panel unanimously wants the DBA veto pattern. What would that look like in AI-DLC?"

**Investigation:** AIDLC's DBA has three properties that make it powerful:
1. It has absolute veto on tenant isolation (cannot be overridden by tech-lead)
2. It runs in real-time during engineering (not post-hoc)
3. Its FAIL verdict requires human override (not just re-run)

In AI-DLC, the closest equivalent would be a security gate in `/bolt-lfg` that:
- Runs a tenant isolation scan (grep for queries without tenant_id) after engineering completes
- Produces a PASS/FAIL verdict
- FAIL blocks the pipeline and requires human intervention (not just retry)
- The scan is a specific, automated check — not a general "review" instruction

This maps to our `/sentinel` skill's role but with harder enforcement. Currently `/sentinel` tracks dispositions in SECURITY.md but does not block pipelines.

### Question 3: "Tim says the hook layer has a shelf life. How long?"

**Investigation:** The hooks depend on:
1. Claude Code's hook API (PreToolUse, SubagentStart, etc.) — stable since early 2026
2. Claude Code's experimental agent teams API — experimental, could change
3. Node.js for JSON parsing — stable
4. bash for orchestration — stable

The shelf life is bounded by (2) — the experimental API. If Anthropic stabilizes agent teams, the hooks can simplify. If Anthropic deprecates them, the SubagentStart/SubagentStop hooks lose their trigger mechanism and the entire engineering phase must be redesigned.

Conservative estimate: 6-12 months before the experimental API either stabilizes or forces a rewrite.

### Question 4: "Rob says the 11-handoff chain is a problem. What is the minimum handoff chain for equivalent quality?"

**Investigation:** Mapping the AIDLC chain to minimal equivalents:

| AIDLC Agent | What It Actually Does | Can Be Combined With |
|-------------|----------------------|---------------------|
| decomposer | Breaks PRD into bolts | Orchestrator (rule-based decomposition) |
| product-analyst | Research + requirements | fullstack-designer (one "spec" agent) |
| fullstack-designer | Design + architecture | product-analyst (one "spec" agent) |
| backend-engineer | Backend code | frontend-engineer (one "build" agent) |
| frontend-engineer | Frontend code | backend-engineer (one "build" agent) |
| dba | Tenant isolation review | Automated grep scan + review agent |
| tech-lead | Coordination + sign-off | Orchestrator (automated checks) |
| code-reviewer | PR review | Review agent |
| security-reviewer | Security scan | Review agent |
| qa-engineer | Playwright testing | Separate (requires MCP) |

**Minimum viable chain:** 4 handoffs, not 11.

```
PRD -> Spec Agent (research + design + architecture) -> product-output.md
    -> Build Agent (backend + frontend) -> implementation.md + code
    -> Review Agent (code review + security + DBA checks) -> review.md
    -> QA Agent (Playwright) -> qa-results.md
```

This is essentially what AI-DLC's `/bolt-lfg` already does, minus the explicit QA step.

### Question 5: "Al says the QA bottleneck is architectural. Is there a workaround?"

**Investigation:** The Playwright MCP constraint is real — it requires the main session. AIDLC has no workaround. Their QA runs serially, one bolt at a time, in the foreground.

Possible workarounds not explored by AIDLC:
1. **Headless testing in subagents.** Use `npx playwright test` via Bash instead of MCP tools. Loses the interactive inspection capability but enables parallelism.
2. **Split QA into automated + manual.** Run automated Playwright test suites in CI (no MCP needed). Reserve MCP-based QA for exploratory testing of complex flows.
3. **Batch QA.** Instead of QA per bolt, batch multiple bolts and run QA once for the batch. Reduces QA cycles but increases blast radius of defects.

---

## Will Larson's Final Decision

### Summary Assessment

AIDLC is a serious, well-engineered framework with a clear target use case (multi-tenant SaaS built by a solo developer using Claude Code). The engineering quality of the hooks, agent definitions, and workflow documentation is high. This is not a toy project — it solves real problems that its author clearly encountered.

However, it has made a fundamental architectural bet that I believe is wrong for the general case: **that coordinating 10 specialized agents produces better outcomes than a well-orchestrated pipeline of fewer, more capable steps.** The coordination overhead — 28 hooks, TeamCreate/SendMessage, 11 handoff points, experimental API dependencies — is the price of that bet.

### What We Should Adopt

**P0 — Adopt Immediately:**

1. **Artifact-gated phase transitions.** Add pre-emptive artifact checks to `/bolt-lfg` before each pipeline step. If the previous step did not produce the expected artifact, block and report. This is strictly better than our current post-hoc checkpoint validation.

2. **Auto-correcting state from artifact presence.** Our checkpoint system should derive state from what files exist, not just from what was written to a state file. If `implementation.md` exists but the checkpoint says "still in planning," auto-correct.

3. **DBA-style absolute veto for critical concerns.** Add a hard-gate security/isolation scan to `/bolt-lfg` that cannot be overridden by the pipeline — only by human intervention. Wire this to `/sentinel` with a BLOCK mode.

**P1 — Adopt When Convenient:**

4. **Context injection pattern.** Pre-load project context, stack info, and bolt state into every skill invocation. Our skills currently discover this information independently, which is redundant and error-prone.

5. **Compaction recovery.** Write essential state to a journal file before context compaction. Our `/dlc-loop` should adopt this pattern for long-running autonomous sessions.

6. **Two-repo separation concept.** Not as a requirement, but as a supported pattern. Some projects benefit from keeping AI lifecycle artifacts separate from source code.

### What We Should Avoid

1. **The 10-agent model.** Specialization beyond 3-4 distinct behaviors (spec, build, review, test) creates coordination overhead that exceeds the benefit. Our skill-based approach is more flexible and lower overhead.

2. **Deep dependency on experimental APIs.** TeamCreate/SendMessage is interesting but not stable. Do not build critical paths on experimental features.

3. **28-hook enforcement.** Selective hooks for critical gates (artifact presence, build verification) are valuable. 28 hooks that all depend on `bolt-state.sh` are a maintenance burden and performance drag.

4. **bypassPermissions as default.** Any framework-level security should not require disabling the platform's security model.

### Competitive Assessment

AIDLC is not a competitive threat to AI-DLC. The frameworks target different architectural philosophies:

| Dimension | AIDLC | AI-DLC |
|-----------|-------|--------|
| Philosophy | Factory model (specialized stations) | Workshop model (versatile pipeline) |
| Target user | Solo dev building multi-tenant SaaS | Any team, any project type |
| Agent model | 10 role-specific agents with coordination | Skills invoked by pipeline orchestrator |
| Strength | Enforcement rigor for specific concerns | Flexibility, breadth, ecosystem size |
| Weakness | Coordination overhead, experimental API risk | Less granular enforcement |
| Ecosystem | 10 agents + 28 hooks | 37 skills/commands + growing |

AIDLC excels at one thing we do not: **hard enforcement of domain-specific concerns (tenant isolation) during the build phase.** This is worth adopting. Everything else — the framework breadth, the governance models, the skill ecosystem, the methodology depth — AI-DLC is ahead.

### Action Items

| # | Action | Priority | Effort | Owner |
|---|--------|----------|--------|-------|
| 1 | Add pre-emptive artifact checks to `/bolt-lfg` pipeline steps | P0 | 1 day | Framework |
| 2 | Add auto-correcting state to checkpoint system | P0 | 1 day | Framework |
| 3 | Add hard-gate security scan (BLOCK mode) to `/sentinel` + wire to `/bolt-lfg` | P0 | 2 days | Framework |
| 4 | Add context pre-loading to skill invocations in `/bolt-lfg` and `/slfg` | P1 | 1 day | Framework |
| 5 | Add compaction recovery journal to `/dlc-loop` | P1 | 0.5 days | Framework |
| 6 | Document two-repo separation as supported pattern | P1 | 0.5 days | Docs |
| 7 | Monitor Claude Code agent teams API for stabilization | P2 | Ongoing | Watch |

---

## Key Takeaways

1. **AIDLC's strongest pattern is artifact-gated phase transitions** — preventing agents from starting work without verified prerequisites. This is strictly better than post-hoc validation and costs almost nothing to implement.

2. **The DBA absolute veto pattern is the right governance model for critical concerns.** Not everything should be overridable by the pipeline. Tenant isolation, security findings, and compliance checks should have BLOCK authority that requires human override.

3. **Auto-correcting state from artifact presence eliminates an entire class of status-tracking bugs.** AIDLC learned this the hard way from their predecessor project's 218-feature status drift.

4. **The 10-agent coordination model is over-engineered for most use cases.** The coordination overhead (28 hooks, TeamCreate, SendMessage, 11 handoff points) exceeds the specialization benefit. 3-4 well-defined pipeline steps achieve 90% of the quality with 20% of the complexity.

5. **Building on experimental APIs is a risk.** AIDLC's entire engineering phase depends on `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`. If this API changes, the framework requires a significant rewrite.

6. **The two-repo model is a genuine architectural insight** worth supporting as an option. Separating lifecycle artifacts from source code creates cleaner boundaries, better multi-project support, and stronger access control.

7. **AIDLC targets a narrow but valuable niche** — solo developers building multi-tenant SaaS applications where tenant isolation is an existential concern. For that niche, it may outperform AI-DLC. For everything else, AI-DLC's breadth, flexibility, and ecosystem are superior.

---

*Panel completed 2026-04-08. Next action: implement P0 items (artifact gates, auto-correcting state, hard-gate security scan).*
