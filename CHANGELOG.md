# Changelog

All notable changes to the AI-DLC framework are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

[1.0.0]: https://github.com/your-org/ai-dlc/releases/tag/v1.0.0
