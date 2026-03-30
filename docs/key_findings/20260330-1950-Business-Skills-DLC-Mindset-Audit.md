# Business Skills DLC Mindset Compliance Audit

**Date:** 2026-03-30
**Scope:** 21 business-specific skills installed globally but outside the ai-dlc repo
**Method:** Each skill assessed against 8 AI-DLC patterns

## DLC Patterns Assessed

1. Gate enforcement (sequential steps, each must complete before next)
2. Brainstorm-first / WHAT-before-HOW
3. Decision records (greppable `DECISION:` lines)
4. Five Questions pattern (surface assumptions before acting)
5. Panel/adversarial review (multiple perspectives or debate)
6. Knowledge capture (write outputs to docs/ for future retrieval)
7. Trust-adaptive gates (scale review ceremony based on risk)
8. The Ascent (verify completion against acceptance criteria)

## Summary Table (sorted by score, lowest first)

| Score | Skill | Patterns Present | Patterns Missing | Type |
|-------|-------|-----------------|------------------|------|
| 2 | /chealth | Gates | 7 of 8 | Ops utility |
| 2 | /mytodo | Gates | 7 of 8 | Utility |
| 2 | /sitrep | Knowledge capture | 7 of 8 | Reporting |
| 2 | /truck-incentives | Phases, Knowledge | 6 of 8 | Personal utility |
| 2 | /vehicle-finder | Phases, Knowledge | 6 of 8 | Personal utility |
| 3 | /am | Gates, Knowledge | 6 of 8 | Workflow |
| 3 | /ticky | Gates, Knowledge | 6 of 8 | Ticket mgmt |
| 3 | /weekly-update | Phases, Knowledge, Gates | 5 of 8 | Reporting |
| 4 | /internal-link-builder | Gates, Knowledge, Ascent | 5 of 8 | Website worker |
| 4 | /seo-meta-agent | Gates, Knowledge, Ascent | 5 of 8 | Website worker |
| 4 | /vertical-builder | Gates, Knowledge, Ascent | 5 of 8 | Website worker |
| 5 | /conversion-plumber | Gates, Knowledge, Ascent | 4 of 8 | Website worker |
| 5 | /moat-content-writer | Gates, Brainstorm, Knowledge, Ascent | 4 of 8 | Content creator |
| 5 | /monthly-refresh | Gates (4x), Knowledge, Ascent | 4 of 8 | Data ops |
| 5 | /qb | Gates, Knowledge, Five Questions | 4 of 8 | Question mgmt |
| 7 | /design-panel | Panel, Gates, Brainstorm, Knowledge, Ascent | 3 of 8 | Review panel |
| 7 | /fin-audit | Panel, Gates, Brainstorm, Knowledge, Ascent | 3 of 8 | Review panel |
| 7 | /prd-go | Gates (2x), Brainstorm, Knowledge, Five Questions, Ascent | 2 of 8 | Spec writer |
| 8 | /refine-page | Gates (5x), Brainstorm, Panel (2x), Knowledge, Ascent | 2 of 8 | Page refinement |
| 8 | /staff-rfc | Gates, Brainstorm, Panel, Knowledge, Five Questions, Ascent | 1 of 8 | RFC generator |
| 8 | /webgeni | Gates (3x+), Brainstorm, Panel (3x), Knowledge, Ascent | 2 of 8 | Orchestrator |

## Key Observations

### Two patterns are universally missing

- **Trust-adaptive gates** -- zero skills implement scaled review ceremony based on risk or earned trust. Every skill has the same gate depth regardless of whether it is a first run or a routine repeat. This is the single biggest gap across the entire catalog.
- **Decision records** -- no skill produces greppable `DECISION: X | VOTE: N-M | CONFIDENCE: avg | DISSENT: panelist: concern` lines. Panel skills generate rich consensus matrices but do not distill them into the one-liner format the AI-DLC framework specifies.

### Knowledge capture is the strongest pattern

17 of 21 skills write outputs to persistent locations (`docs/key_findings/`, `docs/prds/`, `docs/team/`, `am_stuff/`, `data/`). The capture-to-retrieval loop is well established.

### Bottom tier skills are appropriately simple

Skills like `/chealth`, `/mytodo`, `/sitrep`, `/truck-incentives`, `/vehicle-finder` are lightweight utilities where most DLC patterns genuinely do not apply. The exception is `/am`, which is workflow-heavy and would benefit from Five Questions in `prep` and `negotiate` modes.

### Website workers rely on orchestrator compliance

`/conversion-plumber`, `/seo-meta-agent`, `/internal-link-builder`, `/vertical-builder`, and `/moat-content-writer` all score 4-5 individually but are typically run via `/webgeni` (score 8), which adds panel review as outer gates. Practical compliance is higher than individual scores suggest.

## Highest-Impact Improvements

1. **Add `DECISION:` one-liners to panel skills** (design-panel, fin-audit, staff-rfc) -- small lift, big traceability gain
2. **Add trust-adaptive gating to /refine-page and /webgeni** -- pages refined multiple times should get lighter gates
3. **Add Five Questions to `/am prep` and `/am negotiate`** -- surface assumptions before generating advice
