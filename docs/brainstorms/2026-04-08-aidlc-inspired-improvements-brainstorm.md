---
date: 2026-04-08
topic: aidlc-inspired-improvements
status: complete
---

# AIDLC-Inspired Improvements to AI-DLC Skills

## What We're Building
Nine improvements across `/bolt-lfg`, `/pm`, `/staff`, `/deepen-plan`, and a new `decisions-needed.md` template. All sourced from the AIDLC gap analysis, Staff Engineer Panel (unanimous 4-0 adopt votes), and Five-Persona Review (47 findings, 5.6/10 composite).

## Why This Approach
AIDLC's *patterns* scored well across all reviews. Their *implementation* (30+ hooks, bypassPermissions, O(n^2) state checks) scored poorly. We adopt the patterns within our existing skill-based architecture — no hooks, no experimental APIs, no multi-agent coordination.

## Key Decisions
- **Skill-embedded enforcement over hooks:** Gates stay in skill instructions, not bash hooks
- **Work-type classification is the #1 priority:** Stops running 7-step ceremony on one-line fixes
- **Fix-retest is reviewer-owns-verdict:** Same panel re-reviews, max 2 cycles
- **Drift detection is artifact-based:** Derive state from what exists, not what's claimed
- **Decisions-needed is a template + integration:** Not a separate skill, just a protocol

## Constraints & Requirements
- Must not break existing skill invocations
- Must maintain cross-platform compatibility (no Claude Code-specific APIs)
- Must not increase token cost significantly
- All changes are to markdown skill files and templates

## Success Criteria
- `/bolt-lfg` classifies work type and routes through appropriate pipeline depth
- `/bolt-lfg` has fix-retest loop with 2-cycle limit
- `/bolt-lfg` has artifact-gated transitions (not honor-system)
- `/pm verify` action exists and detects drift
- `/pm` tracks work type per bolt
- `/deepen-plan` includes impact scan agent
- `decisions-needed.md` template exists
- `/staff` includes impact assessment in Phase 0
- Condensed context block generated during planning

## Next Steps
Execute implementation — all changes are to skill markdown files.
