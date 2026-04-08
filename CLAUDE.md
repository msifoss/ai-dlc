# AI-DLC Framework — Context File

## Project Identity

- **Name:** AI-DLC (AI Development Life Cycle)
- **Type:** Documentation framework / methodology standard
- **Version:** 1.3.0
- **License:** MIT

## What This Project Is

AI-DLC is the definitive framework for producing production-grade, AI-assisted software. It provides seven sequential phases, four cross-cutting pillars, governance models for different team sizes, 16 foundational document templates, and a complete skills ecosystem of 37 Claude Code commands and skills (25 commands + 12 skills).

This is a **documentation + skills repository** — no application code, no runtime dependencies. The deliverables are markdown files that other projects consume as guidance, templates, and executable AI-assisted workflows.

## Repository Structure

```
ai-dlc/
├── README.md                    # Framework overview + quick start
├── CLAUDE.md                    # This file — framework context
├── CHANGELOG.md                 # Version history
├── SECURITY.md                  # Security policy + review history
├── docs/
│   ├── framework/               # 7 phase guides (PHASE-0 through PHASE-6)
│   ├── pillars/                 # 4 cross-cutting concerns
│   ├── governance/              # 3 team models (solo, small, enterprise)
│   ├── reference/               # 7 reference documents
│   ├── decisions/               # Architecture decision records (ADRs)
│   ├── captains_log/            # Session decision logs
│   ├── reviews/                 # Five-persona review archives
│   ├── security/                # Security audit reports
│   └── story/                   # Project narrative history
├── templates/                   # 15 foundational document templates (includes MISSION-BRIEF.md)
├── skills/
│   ├── README.md                # Skills ecosystem overview + install guide
│   ├── commands/                # 25 slash commands (dlc-loop, bolt-lfg, brainstorm, route, compose, etc.)
│   └── skills/                  # 12 full skills (dlc-audit, staff, motherhen, etc.)
├── .github/workflows/           # CI pipeline (lint, links, secrets)
└── scripts/
    ├── init.sh                  # Bootstrap script for new projects
    ├── install-skills.sh        # Install skills into ~/.claude/
    └── dlc-loop.sh              # Multi-session autonomous DLC loop orchestrator
```

## Conventions

### File Naming
- Phase guides: `PHASE-{N}-{NAME}.md` (e.g., `PHASE-0-FOUNDATION.md`)
- Pillar guides: `PILLAR-{NAME}.md` (e.g., `PILLAR-SECURITY.md`)
- Governance models: `{MODEL}.md` (e.g., `SOLO-AI.md`)
- Templates: `{DOCUMENT-NAME}.md` (e.g., `REQUIREMENTS.md`)
- All caps for document names, kebab-case for multi-word names

### Writing Style
- Active voice, imperative mood for instructions
- Concrete examples over abstract descriptions
- Reference real patterns (CallHero bolts, Olympus workflows) as evidence
- Cloud-neutral primary language — AWS, Azure, GCP as sidebar examples
- Every template includes placeholder sections with `<!-- TODO: ... -->` markers

### Cross-References
- Use relative markdown links between documents
- Format: `[Phase 3: Construction](../framework/PHASE-3-CONSTRUCTION.md)`
- Every phase guide links to relevant pillars and templates
- Every template links back to the phase that produces it

### Document Structure
Each phase guide follows this structure:
1. **Purpose** — What this phase achieves
2. **Entry Criteria** — What must be true before starting
3. **Activities** — What happens during this phase
4. **Deliverables** — What this phase produces
5. **Exit Criteria** — What must be true before advancing
6. **Human Decision Gates** — Where humans must approve
7. **Templates** — Links to relevant templates
8. **Pillar Checkpoints** — Security, Quality, Traceability, Cost checks

## Key Terminology

- **Bolt** — A focused unit of work (typically 1-4 hours) with planning, execution, review, and retro. Classified by work type (Feature/Enhancement/Bug Fix/Hotfix/Refactoring) which determines pipeline depth
- **Captain's Log** — Decision record written during/after each bolt
- **Context File** — CLAUDE.md or equivalent that provides AI with persistent project knowledge
- **Five Questions Pattern** — AI surfaces assumptions before implementation; human validates
- **Five-Persona Review** — AI reviews code from 5 hostile perspectives (attacker, auditor, ops, cost, user)
- **Hardening** — Dedicated phase between construction and operations for production readiness
- **Traceability Matrix** — Maps requirements → stories → specs → code → tests → deployments
- **The Ascent** — Persistence loop that verifies completion against all acceptance criteria before declaring done
- **Trust-Adaptive Gates** — Review ceremony that scales with earned trust (levels 0-3) while risk tiers enforce full review on critical work
- **IDEA → INTENT → UNIT → BOLT** — Four-level artifact hierarchy with conformance scoring between levels
- **Conformance Score** — Percentage (0-100%) measuring how well a child artifact addresses its parent
- **Risk Tier** — Three-level classification (Critical, Significant, Normal) that overrides trust level for gate ceremony
- **Olympian** — A specialized AI agent configured for a specific type of work (Builder, Reviewer, Scout, Scribe)
- **Mission Brief** — Document that front-loads all human judgment before autonomous loop execution, replacing interactive decision gates
- **DLC Loop** — Full-lifecycle autonomous execution from Phase 0 through Phase 6, driven by Mission Brief and checkpoint validation
- **Checkpoint** — JSON evidence file written after each phase completion, containing measurable proof (test counts, coverage, findings)
- **Decision Record** — Greppable one-liner produced by panel skills: `DECISION: X | VOTE: N-M | CONFIDENCE: avg | DISSENT: panelist: concern`
- **Smart Handoff** — Pattern where `/bolt-lfg` detects parallelizable work and delegates to `/slfg` for concurrent execution
- **Skill Router** — `/route` command that matches user intent to the right skill from the catalog
- **Pipeline Composer** — `/compose` command that recommends optimal skill sequences for a given task
- **Work-Type Classification** — Step 0 of `/bolt-lfg` that routes work through appropriate pipeline depth (Feature → full, Bug Fix → minimal, Hotfix → emergency)
- **Fix-Retest Loop** — Reviewer-owns-verdict pattern: the reviewer who found issues must re-verify the fix. Max 2 cycles before human escalation. Prevents self-certification.
- **Artifact Gate** — Pipeline transition that verifies artifact existence (not just command completion). State derived from what exists, not what's claimed.
- **Decisions-Needed Protocol** — Structured escalation with CRITICAL (blocks pipeline) and STANDARD (proceed with defaults) severity levels
- **Impact Scan** — Pre-implementation analysis that greps consumers of files being changed, rates blast radius LOW/MEDIUM/HIGH
- **Condensed Context Block** — `PROJECT-CONTEXT.md` generated during planning that carries stack, patterns, and completed bolts forward to avoid re-reading everything on subsequent bolts

## Quality Standards

- All documents must be self-consistent (no contradictory guidance)
- Cross-references must resolve to existing documents
- Templates must be immediately usable (copy, fill in placeholders, done)
- Phase guides must be actionable without external dependencies
- Framework must pass its own dlc-audit assessment

## Review Cadence

- **Per-release:** Run `/dlc-audit` before tagging any version
- **Quarterly:** Full `/dlc-audit` + `/five-persona-review` on dimensions scoring below 7/10
- **CLAUDE.md accuracy audit:** Quarterly — verify repo structure, terminology, and conventions still match reality
- **Drift detection:** Check for stale dates, expired examples, and outdated references in code samples
- **Last review:** 2026-04-08 (AIDLC competitive analysis: Staff Panel + Five-Persona Review, 47 findings; gap analysis yielding 9 improvements implemented)
- **Next review due:** 2026-07-08 (Q3)

## Contributing

1. Read this context file first
2. Follow the conventions above
3. Ensure cross-references are valid
4. Test templates by using them on a sample project
5. Update CHANGELOG.md with changes
