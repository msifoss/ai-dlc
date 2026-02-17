# ADR-003: Build-Then-Harden Philosophy

## Status
Accepted

## Date
2026-02-16

## Context
Traditional security practice advocates "shift left" — address security as early as possible. For AI-assisted development, we needed to decide between:
- Shift-left (security gates at every step)
- Build-then-harden (build working code, then dedicate a phase to production readiness)

## Decision
AI-DLC uses a build-then-harden approach: Phase 3 (Construction) focuses on building working, tested code, and Phase 4 (Hardening) is a dedicated phase for security, monitoring, cost controls, and operational readiness.

Key rationale:
1. **Working code is a better review artifact** — AI-generated code is easier to security-review than abstract specifications. Real code surfaces real vulnerabilities.
2. **Dedicated focus prevents corner-cutting** — When hardening is mixed with feature development, it gets deprioritized. A separate phase ensures it happens.
3. **AI context benefits from focused phases** — AI assistants produce better security reviews when the full codebase is available and the session is dedicated to security.
4. **The Ascent pattern already catches basic issues** — Test-paired development and the verification loop catch implementation bugs during Construction. Hardening catches systemic and architectural issues.

Security is still a cross-cutting pillar active in every phase. The distinction is between *pillar checkpoints* (continuous, lightweight) and *dedicated hardening* (Phase 4, comprehensive).

## Consequences
- Security findings may be discovered later than in a shift-left approach
- Phase 4 can be a significant effort if Construction introduced many issues
- Teams may be tempted to skip Phase 4 ("the code works, let's ship")
- The framework must clearly communicate that Phase 4 is not optional

## Alternatives Considered
- **Pure shift-left:** Rejected because it fragments AI context and makes security review less effective
- **Security as a separate team/phase only:** Rejected because it creates bottlenecks and disconnects security from development
- **No dedicated phase (pillar-only):** Rejected because pillar checkpoints are too lightweight for production readiness

## Related
- [Phase 3: Construction](../framework/PHASE-3-CONSTRUCTION.md)
- [Phase 4: Hardening](../framework/PHASE-4-HARDENING.md)
- [Security Pillar](../pillars/PILLAR-SECURITY.md)
