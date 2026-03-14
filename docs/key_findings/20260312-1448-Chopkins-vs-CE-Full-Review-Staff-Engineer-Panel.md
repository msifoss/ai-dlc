# Chopkins vs Compound Engineering — Full Comparative Review

**Date:** 2026-03-11
**Panel:** Tim (SpaceX), Rob (Roblox), Fran (Meta), Al (AWS Developer Tools), Will Larson (Moderator)
**Trigger:** Full comparative review of Chopkins (AI-DLC + skills ecosystem) vs Compound Engineering (EveryInc/compound-engineering-plugin v2.33.0)

---

## Problem Statement

A comprehensive, brutally honest comparative review of two AI-assisted engineering ecosystems:

- **Chopkins:** AI-DLC framework (7 phases, 4 pillars, 3 governance models, 14 templates) + 33-tool skills ecosystem (21 commands, 12 skills) on the Chopkins branch. Prompt-template-based (100% markdown + 1 bash CLI).
- **Compound Engineering (CE):** EveryInc plugin v2.33.0. 26 agents, 13-19 skills, 22-23 commands, 2 MCP servers. Hybrid architecture (TypeScript runtime + prompt templates). 9,300+ GitHub stars.

**Evaluated across 15 dimensions** including methodology, governance, review quality, distribution, plan depth, execution speed, panels, health monitoring, configuration, documentation, platform reach, and community maturity.

---

## Panel Analysis

### Tim — Staff Engineer, SpaceX

**Risk assessment:**

These are two different tools solving two different problems. CE is an **execution engine** optimized for shipping features faster — 50+ agents, parallelized everything, knowledge compounding. Chopkins is a **governance framework with an execution engine bolted on** — 7 phases, 4 pillars, risk tiers, trust-adaptive gates, plus a skills ecosystem.

Comparing them head-to-head on individual features misses the point. It's like comparing a Formula 1 car to a Boeing 747.

Quantified risk by dimension:

| Dimension | Chopkins Risk | CE Risk |
|-----------|-------------|---------|
| Methodology depth | Low (comprehensive) | HIGH (none) |
| Governance | Low (21 gates) | HIGH (1 gate) |
| Knowledge compounding | Low (closed loop) | Low (closed loop) |
| Review quality (code) | Medium (5 personas) | Low (14 reviewers) |
| Self-improvement | Medium (3 tools, untested) | Low (4 tools, proven) |
| Distribution | HIGH (git clone only) | Low (npm + 11 formats) |
| Plan quality | Medium (4 agents) | Low (40+ agents) |
| Rapid coding | Medium (slfg, untested) | Low (slfg, proven) |
| Panel analysis | Low (4 panels) | HIGH (zero panels) |
| Health monitoring | Low (motherhen) | HIGH (nothing) |

**Key quote:**
"CE is a race car with no seatbelts. Chopkins is an armored personnel carrier with a turbocharger. Both are fast, but only one will keep you alive when things go wrong."

**Unique contribution:**
The real gap is **battle-testing**. Chopkins' 5 newest commands were written hours ago with zero production usage. A command that's never been run is a hypothesis, not a feature. P(undiscovered bugs): ~70%.

---

### Rob — Staff Engineer, Roblox

**Risk assessment:**

Developer experience comparison:

- **CE:** `npm install` → `/lfg "build X"` → 50+ agents spawn → code ships. ~15 concepts to learn.
- **Chopkins:** Clone repo → `dlc install` → read CLAUDE.md → understand phases/pillars/governance → `/bolt-lfg "build X"` → 6 gates stop you along the way. ~80 concepts to learn.

The cognitive load difference is 5x. That's not necessarily bad (a hospital has more protocols than a clinic) but it IS a barrier to adoption.

**Where Chopkins genuinely wins:** The multi-panel system. `/staff-panel`, `/exec-review`, `/marketing-team`, `/llm-team` produce strategic analysis that code reviewers can't replicate. CE reviews code. Chopkins reviews *decisions*.

**Where CE genuinely wins:**
1. Parallelism depth: 40+ agents vs 4 (10x)
2. Code review breadth: 14 reviewers vs 5 personas (2.8x)
3. Production maturity: 9,300 stars vs hours old
4. Browser testing: agent-browser CLI vs nothing
5. Platform reach: 11 platforms vs 1

**Key quote:**
"Chopkins doesn't have a code review problem. It has a cognitive load problem. 33 tools is a lot of surface area for a developer to hold in their head."

**Unique contribution:**
The previous "Chopkins 11, CE 0" scorecard was designed to make Chopkins win by including categories CE never attempted (panels, health monitoring) while excluding categories where CE excels (platform reach, community, browser testing). An honest scorecard must include all dimensions.

---

### Fran — Staff Engineer, Meta

**Risk assessment:**

Three clean buckets:

**Chopkins dominates (unbridgeable gaps):**
- Lifecycle methodology (7 phases vs 0)
- Governance models (3 models vs none)
- Risk-tier enforcement (Critical/Significant/Normal vs flat)
- Strategic panels (4 expert panels vs 0)
- Compliance audit (9-dimension scoring vs none)
- Project health monitoring (7-category dashboard vs none)
- Template library (14 docs vs none)

**CE dominates (architectural gaps):**
- Parallel agent scale (50+ vs 4-6, 10x gap)
- Code review breadth (14 vs 5, 2.8x gap)
- Platform reach (11 platforms vs 1, unbridgeable without runtime)
- MCP servers (Context7 + browser vs none, unbridgeable)
- Community (9,300 stars vs private repo)
- Production maturity (months vs hours)

**Actually equivalent:**
- Knowledge compounding (both close the capture → retrieval loop)
- Meta-tools (3 vs 4, same capabilities)
- Per-project config (YAML vs CLAUDE.md, same purpose)
- Autonomous pipeline (/bolt-lfg vs /lfg, same concept)

**Key quote:**
"The previous 'Chopkins 11, CE 0' scorecard is intellectually dishonest. When you cherry-pick categories where you have features and your competitor doesn't, anyone can win 11-0."

**Unique contribution:**
**The architectural ceiling.** Chopkins is 100% markdown prompt templates. CE is TypeScript + prompts + MCP servers. Chopkins' ceiling is what Claude Code's Agent tool can do with markdown. CE's ceiling is what TypeScript + Claude Code can do together. Certain CE capabilities (MCP servers, browser testing, cross-platform, 40+ agent orchestration) are literally impossible for Chopkins without adding runtime code.

---

### Al — Staff Engineer, AWS (Developer Tools)

**Risk assessment:**

The fundamental difference: CE is a **plugin with runtime** (TypeScript). Chopkins is a **prompt library with governance** (markdown).

Like comparing CloudFormation (YAML interpreted by AWS) to Terraform (Go binary with state management). Both deploy infrastructure, but Terraform can do things CloudFormation architecturally cannot (multi-cloud, custom providers).

**CE can do things Chopkins architecturally cannot:**
- MCP servers (requires runtime)
- Cross-platform conversion (requires CLI tool)
- Task lifecycle management (requires task system)
- TeammateTool orchestration (requires runtime coordination)
- Browser testing (requires browser automation)

**Chopkins can do things CE architecturally doesn't attempt:**
- Lifecycle methodology (governance concept, not a tool)
- Risk-tier enforcement (policy framework, not code)
- Strategic panels (domain expertise prompts)
- Compliance audit (assessment criteria, not runtime)

**Per-dimension scores (0-10):**

| Dimension | Chopkins | CE |
|-----------|---------|-----|
| Methodology depth | 9 | 2 |
| Governance & compliance | 9 | 1 |
| Knowledge compounding | 8 | 8 |
| Code review quality | 6 | 9 |
| Strategic review | 9 | 0 |
| Self-improvement | 7 | 7 |
| Distribution & reach | 3 | 9 |
| Plan quality (depth) | 5 | 9 |
| Rapid autonomous coding | 5 | 8 |
| Panel-based analysis | 9 | 0 |
| Project health monitoring | 9 | 0 |
| Per-project configuration | 8 | 6 |
| Documentation & templates | 9 | 5 |
| Platform reach | 1 | 9 |
| Community & maturity | 2 | 9 |

**Key quote:**
"You're not comparing two tools. You're comparing a methodology-with-tools to a tool-with-methodology. The question isn't which is better — it's which problem you're solving."

**Unique contribution:**
**The runtime ceiling.** Chopkins chose the Lambda path (serverless, constrained but simple). CE chose the EC2 path (full control, unlimited but complex). Chopkins is simpler and more portable, but has hard ceilings. This isn't a gap that more markdown can close.

---

## Consensus Matrix

| Dimension | Tim | Rob | Fran | Al | Winner |
|-----------|-----|-----|------|-----|--------|
| Methodology depth | Chopkins | Chopkins | Chopkins | Chopkins | **Chopkins** |
| Governance & compliance | Chopkins | Chopkins | Chopkins | Chopkins | **Chopkins** |
| Knowledge compounding | TIE | TIE | TIE | TIE | **TIE** |
| Code review quality | CE | CE | CE | CE | **CE** |
| Strategic review (panels) | Chopkins | Chopkins | Chopkins | Chopkins | **Chopkins** |
| Self-improvement | CE | TIE | TIE | TIE | **TIE** |
| Distribution & reach | CE | CE | CE | CE | **CE** |
| Plan quality (depth) | CE | CE | CE | CE | **CE** |
| Rapid autonomous coding | CE | CE | CE | CE | **CE** |
| Panel-based analysis | Chopkins | Chopkins | Chopkins | Chopkins | **Chopkins** |
| Project health monitoring | Chopkins | Chopkins | Chopkins | Chopkins | **Chopkins** |
| Per-project configuration | Chopkins | Chopkins | Chopkins | Chopkins | **Chopkins** |
| Documentation & templates | Chopkins | Chopkins | Chopkins | Chopkins | **Chopkins** |
| Platform reach | CE | CE | CE | CE | **CE** |
| Community & maturity | CE | CE | CE | CE | **CE** |

### Final Tally: **Chopkins 7, CE 6, Tie 2**

---

## Clarifying Questions & Answers

| Question | Answer | Impact |
|----------|--------|--------|
| How many agents in Chopkins' /deepen-plan? | 4 | Confirms 10x gap vs CE's 40+ |
| Has /slfg ever been executed? | No — created hours ago | Validates maturity concern |
| Does Chopkins have any runtime code? | No — 100% markdown + bash | Confirms architectural ceiling |
| Can Chopkins expand to 10+ agents? | Yes, but unreliable beyond ~8-10 without runtime | Partially mitigates plan depth gap |
| Does CE have governance? | 1 gate (plan approval), no phases/pillars/risk tiers | Confirms governance gap is structural |
| Has Chopkins CI run on the branch? | No — CI triggers on main only | New skills are unvalidated by own pipeline |

---

## Will Larson's Decision

### The Honest Verdict

**Chopkins 7, CE 6, Tie 2.** Both are excellent in their lane.

- **Solo dev shipping product fast → CE.** Execution velocity, plan depth, parallel scale, proven track record.
- **Production software needing governance → Chopkins.** Lifecycle management, risk enforcement, strategic review, compliance.
- **Best answer → use both.** CE for execution engine, Chopkins for governance wrapper. They're complementary.

### Recommended Next Steps for Chopkins

| # | Action | Effort | Priority |
|---|--------|--------|----------|
| 1 | Merge to main and run CI pipeline | 5 min | Critical |
| 2 | Expand /deepen-plan to 8-10 agents | 1 hour | High |
| 3 | Publish repo publicly | 5 min | High |
| 4 | Add browser testing command | 2-3 hours | Medium |
| 5 | Add more code review personas (8-10) | 2 hours | Medium |
| 6 | Create /quickstart for cognitive load reduction | 1 hour | Medium |
| 7 | Production-test all new commands | Ongoing | Critical |

### What's Explicitly Deferred

| Item | Rationale | Revisit When |
|------|-----------|--------------|
| TypeScript runtime | Markdown simplicity is a feature | MCP servers become critical |
| npm package | Requires runtime code | Public release drives demand |
| 40+ parallel agents | Unreliable beyond ~10 without runtime | Agent tool improves |
| Cross-platform conversion | Markdown is already portable | Non-Claude platforms prioritized |

### Key Takeaways

1. **Different tools for different problems.** Claiming either "wins everything" is dishonest. CE excels at execution velocity. Chopkins excels at lifecycle governance.

2. **The architectural ceiling matters.** Prompt-only vs hybrid-runtime is a fundamental constraint, not a feature gap. Certain CE capabilities are impossible for Chopkins without adding runtime code.

3. **Battle-testing > feature counts.** 33 tools with 5 untested vs fewer tools with thousands of production hours. Maturity matters more than inventory.

4. **Cognitive load is a real risk.** 80 concepts vs 15. A tool too complex to adopt has zero value. Chopkins needs a /quickstart onramp.

5. **The honest answer: use both.** CE for execution, Chopkins for governance. Complementary, not competitive.

---

## Files Referenced

| File | Role |
|------|------|
| skills/commands/*.md (21 files) | Chopkins command inventory |
| skills/skills/*/SKILL.md (12 files) | Chopkins skill inventory |
| scripts/dlc | Distribution CLI |
| docs/framework/PHASE-*.md (7 files) | Lifecycle methodology |
| docs/pillars/PILLAR-*.md (4 files) | Cross-cutting concerns |
| docs/governance/*.md (3 files) | Governance models |
| templates/*.md (14 files) | Foundational templates |
| .github/workflows/ci.yml | CI pipeline |
| EveryInc/compound-engineering-plugin (GitHub) | CE source |

---

## Appendix: Previous Scorecard Critique

The "Chopkins 11, CE 0, Tie 1" scorecard from the prior panel was biased:

**Categories included that favor Chopkins:**
- "Panel-based analysis" — CE never attempted this
- "Project health monitoring" — CE never attempted this
- "Per-project configuration" — Was scored as a Chopkins win despite both having config
- "Documentation" — Scored on framework docs which CE doesn't have by design

**Categories excluded that favor CE:**
- "Platform reach" (11 platforms vs 1) — not in scorecard
- "Community & maturity" (9,300 stars vs private) — not in scorecard
- "Code review breadth" (14 vs 5 reviewers) — merged into "Review quality" where persona depth hid breadth gap
- "Browser testing" — not in scorecard
- "Parallel agent scale" — merged into other categories

An honest comparison requires including dimensions where you lose, not just where you win.
