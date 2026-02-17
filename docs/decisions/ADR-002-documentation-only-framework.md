# ADR-002: Documentation-Only Framework

## Status
Accepted

## Date
2026-02-16

## Context
We needed to decide the distribution format for AI-DLC. Options included:
- Documentation-only (markdown files)
- CLI tool with scaffolding
- IDE plugin/extension
- SaaS platform

## Decision
AI-DLC is distributed as a documentation-only repository of markdown files. No runtime code, no dependencies, no build step.

Key rationale:
1. **Tool-agnostic** — Markdown works with any AI assistant, any IDE, any CI/CD pipeline (FR-009)
2. **Zero dependencies** — No package installation, no version conflicts, no security vulnerabilities from runtime code
3. **Forkable** — Teams can fork and customize without maintaining upstream compatibility
4. **AI-consumable** — Markdown is the native format for AI context files (CLAUDE.md, README.md)
5. **Versionable** — Standard git workflow for tracking changes (CHANGELOG.md)

## Consequences
- No interactive tooling (no CLI wizard, no IDE integration)
- Bootstrap relies on a simple shell script (`scripts/init.sh`) rather than a package manager
- Framework improvements require manual template updates in consuming projects
- Self-assessment (`/dlc-audit`) is implemented as an AI skill, not a CLI tool

## Alternatives Considered
- **CLI tool (npm/pip):** Would add dependencies and lock to a language ecosystem
- **IDE extension:** Would lock to a specific editor
- **SaaS:** Would create vendor dependency and cost
- **Hybrid (docs + CLI):** Considered but rejected to maintain simplicity

## Related
- NFR-003 in [Requirements](../REQUIREMENTS.md)
- [CLAUDE.md](../../CLAUDE.md) — framework context file
