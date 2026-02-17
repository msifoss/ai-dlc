# ADR-001: Seven-Phase Sequential Lifecycle

## Status
Accepted

## Date
2026-02-16

## Context
AI-assisted development needs a structured lifecycle, but traditional methodologies (waterfall, agile/scrum) don't account for AI as a first-class development partner. We needed to decide between:
- Adapting an existing methodology (e.g., adding AI to Scrum)
- Creating a purpose-built lifecycle

## Decision
We created a seven-phase lifecycle (Foundation, Inception, Elaboration, Construction, Hardening, Operations, Evolution) designed specifically for AI-assisted development.

Key design choices:
1. **Sequential phases with clear gates** — AI agents work best with well-defined scope and explicit completion criteria. Open-ended workflows degrade quality.
2. **Hardening as a dedicated phase** — "Features complete" ≠ "production ready." AI-generated code needs dedicated security, ops, and cost review. This is the framework's key innovation.
3. **Evolution as a continuous phase** — Unlike traditional methodologies that end at deployment, Phase 6 captures the learning loop that makes AI assistance improve over time.
4. **Bolt-driven construction** — Replacing sprints with bolts (1-4 hour focused units) matches AI context window limitations and attention patterns.

## Consequences
- Teams must follow phases sequentially (no skipping Hardening)
- The bolt cadence is more granular than sprint stories, requiring more frequent planning
- The framework is opinionated about structure but flexible about tooling
- Phase 6 Evolution creates ongoing maintenance overhead but prevents context file decay

## Alternatives Considered
- **Scrum + AI overlay:** Rejected because sprint ceremonies don't map to AI context management
- **Kanban flow:** Rejected because the lack of gates enables quality drift
- **Three-phase (plan, build, deploy):** Rejected because it lacks dedicated hardening and evolution

## Related
- [Phase 0: Foundation](../framework/PHASE-0-FOUNDATION.md) through [Phase 6: Evolution](../framework/PHASE-6-EVOLUTION.md)
- FR-001, FR-002 in [Requirements](../REQUIREMENTS.md)
