# Changelog

All notable changes to the AI-DLC framework are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0] - 2026-04-08

### Added
- **Work-type classification** in `/bolt-lfg`: Routes work through adaptive pipeline depths (Feature/Enhancement/Bug Fix/Hotfix/Refactoring) — biggest single improvement, stops running 7-step ceremony on one-line fixes
- **Fix-retest loop** in `/bolt-lfg` Step 4: Reviewer-owns-verdict pattern with max 2 cycles before human escalation — prevents self-certification of fixes
- **Artifact-gated transitions** in `/bolt-lfg`: All gates now verify artifact existence (not just command completion) — derived from AIDLC's bolt-state.sh pattern that prevented 218+ status drifts
- **5 abbreviated pipelines** in `/bolt-lfg`: Feature (full), Enhancement (abbreviated), Bug Fix (minimal), Hotfix (emergency), Refactoring (engineering) — each with appropriate ceremony depth
- **`/pm verify` action**: Drift detection comparing claimed sprint status against actual artifacts — auto-corrects when reality diverges from claims
- **`/pm decisions` action**: Structured decisions-needed protocol with CRITICAL/STANDARD severity, categories, and defaults — CRITICAL items hard-block the pipeline
- **Work-type tracking** in `/pm plan`: Bolts now carry a Work Type field (Feature/Enhancement/Bug Fix/Hotfix/Refactoring)
- **Condensed context block** in `/pm plan`: Generates `docs/pm/PROJECT-CONTEXT.md` with stack, patterns, completed bolts — prevents re-reading everything on bolt 2+
- **Impact Scan Researcher** (Agent 11) in `/deepen-plan`: Greps consumers of files being changed, rates blast radius LOW/MEDIUM/HIGH — catches integration breakage early
- **Impact assessment** in `/staff` Phase 0: Greps consumers, counts blast radius, checks test coverage before panel convenes — gives panelists concrete data
- **Work-type context** in `/staff` Phase 0: Frames panel analysis appropriately for features vs bug fixes vs refactoring
- **`DECISIONS-NEEDED.md` template**: 16th foundational template with CRITICAL/STANDARD escalation protocol, 8 decision categories
- **AIDLC gap analysis**: Staff Engineer Panel + Five-Persona Review of competing AIDLC framework (`docs/key_findings/20260408-1045-AIDLC-vs-AI-DLC-Gap-Analysis.md`)

### Changed
- `/bolt-lfg` pipeline restructured: Step 0 (classify) routes to appropriate pipeline depth before any other work
- `/deepen-plan` upgraded from 10 to 11 research agents (added Impact Scan Researcher)
- `/pm plan` now loads PROJECT-CONTEXT.md and checks decisions-needed.md during planning
- `/staff` Phase 0 expanded with impact assessment (0d) and work-type classification (0c) before Deep Problem Understanding (now 0e)

### Sources
- AIDLC framework analysis: 47 findings (5C, 11H, 18M, 13L), composite 5.6/10
- Staff Engineer Panel: unanimous 4-0 ADOPT on artifact-gated transitions, DBA-style veto, auto-correcting state
- Five-Persona Review: Critical findings on bypassPermissions, eval injection, O(n^2) hook overhead
- 6 patterns adopted, 4 anti-patterns documented to avoid

## [1.2.0] - 2026-03-30

### Added
- Chapter 1 narrative history (`docs/story/chapter1.md`)
- Chapter 2 narrative history (`docs/story/chapter2.md`)
- Framework self-compliance artifacts (REQUIREMENTS, TRACEABILITY-MATRIX, USER-STORIES)
- GitHub Actions CI pipeline: markdown lint, link checking (lychee), secret scanning (gitleaks)
- Branch protection on main (1 approver required, force push disabled)
- Full 9-category security audit (`docs/security/20260306-212355-security-audit.txt`)
- Five-persona code review of full repository (`docs/reviews/20260306-five-persona-code-review.txt`): 52 unique findings (0C, 7H, 24M, 21L)
- Comprehensive References & Sources section in README (40+ entries across 7 categories)
- SLO/SLI guidance section in Phase 5 Operations
- Security Scanning stage in CI/CD deployment proposal template
- Captain's log for March 6 hardening session
- 4 Swarms-inspired enhancements: `/route` skill router, `/compose` pipeline composer, voting protocol, smart handoff
- `/dlc-loop` command for full-lifecycle autonomous execution (Phase 0–6)
- `MISSION-BRIEF.md` template for front-loading human judgment before autonomous loops
- `scripts/dlc-loop.sh` multi-session autonomous DLC loop orchestrator
- Autonomous execution guide updated with DLC Loop tenets and checkpoint validation

### Changed
- Five-persona security guidance review: 19 findings, 14 fixed, 4 deferred, 1 accepted
- Five-persona custom skills review: 71 findings across 6 skills, all 71 resolved
- Retrospective action items 1-4 marked complete
- init.sh hardened: MODE allowlist validation, remote URL verification, dynamic version banner, --strict flag, source file validation, argument loop parser, captain-logs directory naming fix
- CI pipeline: actions pinned to SHA commits, gitleaks replaced with free CLI
- Phase 3 Construction: consolidated multi-agent/Ascent/trust-adaptive sections into summary with forward references (792→736 lines)
- CLAUDE.md repo structure and reference count updated
- Renamed `/staff-panel` to `/staff` across all commands, skills, and cross-references
- Updated skill/command counts: 25 commands + 12 skills = 37 total (was 30)
- Updated template count: 15 (was 14)

## [1.1.0] - 2026-02-17

### Added

#### Autonomous Execution Guide (New Reference Document)
- Five Tenets of autonomous AI-assisted development (Exhaust Before Asking, Prove Don't Claim, Persist Until Verified, Fail Loudly, Leave the System Better)
- The Ascent pattern — persistence loop that verifies completion against all acceptance criteria
- Multi-agent specialization model with agent taxonomy (Builder, Reviewer, Scout, Scribe, Architect, Ops)
- Smart model routing by task complexity (Lightweight, Standard, Complex tiers)
- The Learning Paradox — "human-in-the-training-loop, not human-in-the-loop"
- Trust-adaptive gates with four levels (New, Established, Trusted, Autonomous)
- Risk tier overrides (Critical, Significant, Normal) that enforce ceremony regardless of trust
- Four execution modes (The Ascent, Orchestrated, Parallel, Manual) with selection guide
- Anti-patterns catalog (chatbot collaboration, premature declaration, token optimization at human expense)

#### Enriched Phase Guides
- Phase 1: Structured IDEA artifact format with risk tier assessment
- Phase 2: IDEA → INTENT → UNIT → BOLT artifact hierarchy, conformance scoring (0-100%), dual validation, dependency graph generation, enriched Momus and Metis gate checklists
- Phase 3: Multi-agent execution model, The Ascent as construction discipline, trust-adaptive review, execution mode selection
- Phase 5: AI-generated deployment artifacts (Summit pattern) for auto-generated runbooks, monitoring configs, and release notes
- Phase 6: Preference storage lifecycle with 30-day decay, technical insights capture in agent discovery, trust level metric

#### Enriched Governance Models
- Solo + AI: The Ascent persistence practice, Learning Paradox, trust-adaptive gates for solo workflow, execution mode selection
- Small Team: Multi-agent delegation patterns with role-specific gate ownership
- Enterprise: Trust-adaptive ceremony at enterprise scale with compliance overlay, risk tier override rules, PM/Dev/AI responsibility matrix

#### Enriched Pillars and Reference
- Quality Pillar: Oracle verification pattern, artifact conformance scoring, trust-adaptive review thresholds
- Five-Persona Review: Agent-backed review scaling approach, Momus/Metis persona mapping
- Audit Scoring: Updated D3 (artifact hierarchy), D4 (multi-agent + Ascent), D8 (learning system), D9 (trust-adaptive gates) rubrics
- Glossary: ~18 new terms including The Ascent, Conformance Score, Olympian, Trust Level, Risk Tier, and more
- dlc-audit skill: Updated D3, D4, D8, D9 checks and scoring to reference new Olympus-origin concepts

### Changed
- Version bumped from 1.0.0 to 1.1.0
- Reference document count updated from 5 to 6
- Audit scoring updated from 8-dimension to 9-dimension assessment

## [1.0.0] - 2026-02-16

### Added

#### Seven-Phase Lifecycle
- Phase 0: Foundation — project bootstrap, context file creation, governance selection
- Phase 1: Inception — requirements gathering, architecture decisions, initial security review
- Phase 2: Elaboration — Five Questions Pattern, user stories, technical specification, traceability matrix
- Phase 3: Construction — bolt-driven development with test-paired implementation
- Phase 4: Hardening — dedicated production readiness phase (alarms, security, cost controls, ops checklist)
- Phase 5: Operations — deployment, monitoring, incident response
- Phase 6: Evolution — five-phase learning loop, drift detection, retrospectives, decommissioning

#### Four Cross-Cutting Pillars
- Security Pillar — five-persona adversarial review, OWASP integration, finding lifecycle, compliance mapping
- Quality Pillar — test-paired development, linting, code review standards
- Traceability Pillar — traceability matrix, captain's logs, git audit trail, PM artifacts
- Cost Awareness Pillar — budget tracking, dashboards, kill switches, cost-per-unit metrics

#### Three Governance Models
- Solo + AI — single developer with AI pair, Five Questions Pattern, self-review with structured gates
- Small Team — 2-5 developers, shared context, namespaced logs, PR-based gates
- Enterprise — formal RACI, compliance gates, multi-team traceability, federated context

#### 14 Foundational Document Templates
- CLAUDE-CONTEXT.md, PM-FRAMEWORK.md, REQUIREMENTS.md, SECURITY.md
- USER-STORIES.md, TRACEABILITY-MATRIX.md, CICD-DEPLOYMENT-PROPOSAL.md
- INFRASTRUCTURE-PLAYBOOK.md, COST-MANAGEMENT-GUIDE.md
- SOLO-AI-WORKFLOW-GUIDE.md, MULTI-DEVELOPER-GUIDE.md
- SECURITY-REVIEW-PROTOCOL.md, OPS-READINESS-CHECKLIST.md, AI-DLC-CASE-STUDY.md

#### 5 Reference Guides
- Bolt Metrics Guide — velocity and quality measurement methodology
- Five-Persona Review — detailed adversarial review reference
- AWS Well-Architected Mapping — AI-DLC to WAF alignment with multi-cloud equivalents
- Audit Scoring — 8-dimension assessment with scoring rubric
- Glossary — key terms and definitions

#### Bootstrap Tooling
- scripts/init.sh — project bootstrap script

#### Framework Self-Compliance
- CLAUDE.md — framework context file (practices what it preaches)
- README.md — framework overview with quick start, comparison table, and architecture diagram
- CHANGELOG.md — this file
- docs/REQUIREMENTS.md — 23 framework requirements (10 FR, 8 NFR, 5 SEC) with IDs and traceability
- docs/USER-STORIES.md — 10 user stories with acceptance criteria (Given/When/Then)
- docs/TRACEABILITY-MATRIX.md — full REQ → Story → Spec → Document → Verification mapping
- SECURITY.md — security policy with v1.1.0 content review findings
- docs/decisions/ADR-001 through ADR-003 — architecture decision records
- docs/captains_log/ — captain's log and retrospective for v1.1.0 meld

[Unreleased]: https://github.com/msifoss/ai-dlc/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/msifoss/ai-dlc/releases/tag/v1.1.0
[1.0.0]: https://github.com/msifoss/ai-dlc/releases/tag/v1.0.0
