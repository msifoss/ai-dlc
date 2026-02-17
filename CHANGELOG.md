# Changelog

All notable changes to the AI-DLC framework are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

[1.1.0]: https://github.com/your-org/ai-dlc/releases/tag/v1.1.0
[1.0.0]: https://github.com/your-org/ai-dlc/releases/tag/v1.0.0
