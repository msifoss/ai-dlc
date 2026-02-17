# AI-DLC Framework — Context File

## Project Identity

- **Name:** AI-DLC (AI Development Life Cycle)
- **Type:** Documentation framework / methodology standard
- **Version:** 1.1.0
- **License:** MIT

## What This Project Is

AI-DLC is the definitive framework for producing production-grade, AI-assisted software. It provides seven sequential phases, four cross-cutting pillars, governance models for different team sizes, and 14 foundational document templates.

This is a **documentation-only repository** — no application code, no runtime dependencies. The deliverables are markdown files that other projects consume as guidance and templates.

## Repository Structure

```
ai-dlc/
├── README.md                    # Framework overview + quick start
├── CLAUDE.md                    # This file — framework context
├── CHANGELOG.md                 # Version history
├── docs/
│   ├── framework/               # 7 phase guides (PHASE-0 through PHASE-6)
│   ├── pillars/                 # 4 cross-cutting concerns
│   ├── governance/              # 3 team models (solo, small, enterprise)
│   └── reference/               # 6 reference documents
├── templates/                   # 14 foundational document templates
└── scripts/
    └── init.sh                  # Bootstrap script for new projects
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

- **Bolt** — A focused unit of work (typically 1-4 hours) with planning, execution, review, and retro
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

## Quality Standards

- All documents must be self-consistent (no contradictory guidance)
- Cross-references must resolve to existing documents
- Templates must be immediately usable (copy, fill in placeholders, done)
- Phase guides must be actionable without external dependencies
- Framework must pass its own dlc-audit assessment

## Contributing

1. Read this context file first
2. Follow the conventions above
3. Ensure cross-references are valid
4. Test templates by using them on a sample project
5. Update CHANGELOG.md with changes
