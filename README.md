# AI-DLC: AI Development Life Cycle

**The definitive framework for producing production-grade, AI-assisted software.**

AI-DLC is a universal standard that transforms AI-assisted coding from "expensive autocomplete" into a disciplined engineering process. It provides the phases, pillars, templates, and governance models needed to ship reliable software — whether you're a solo developer with an AI pair, a small team, or an enterprise.

---

## Why AI-DLC?

AI coding assistants are powerful but undisciplined. Without structure, they produce code that:
- Works in demos but fails in production
- Has no tests, no security review, no operational readiness
- Loses context between sessions, repeating mistakes
- Ships without cost awareness, monitoring, or rollback plans

AI-DLC fixes this. It's built from real production experience — not theory — synthesizing lessons from:
- **Battle-tested delivery** — 25 bolts, 216 tests, 200+ security findings, 9-day production deployment
- **Autonomous execution philosophy** — structured workflows with validation gates
- **Industry standards** — AWS Well-Architected Framework, NIST AI RMF, ISO/IEC 42001, OWASP Top 10 for LLMs

---

## Quick Start (5 Minutes)

```bash
# 1. Clone the framework
git clone https://github.com/your-org/ai-dlc.git

# 2. Bootstrap a new project
cd your-project
../ai-dlc/scripts/init.sh

# 3. Start with Phase 0
# The init script creates your foundational documents
# Open CLAUDE.md and customize for your project
```

Or manually:

1. Copy `templates/CLAUDE-CONTEXT.md` to your project as `CLAUDE.md`
2. Read [Phase 0: Foundation](docs/framework/PHASE-0-FOUNDATION.md) to bootstrap your project
3. Follow the phases sequentially — each builds on the previous

---

## The Seven Phases

AI-DLC organizes work into seven sequential phases. Each phase has clear entry criteria, deliverables, and exit gates.

```
┌─────────────────────────────────────────────────────────────────────┐
│                        AI DEVELOPMENT LIFE CYCLE                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Phase 0   Phase 1    Phase 2      Phase 3       Phase 4           │
│ FOUNDATION─INCEPTION──ELABORATION──CONSTRUCTION──HARDENING─┐       │
│  Bootstrap  Require-   Specify &    Bolt-driven   Security  │       │
│  & govern   ments &    validate     development   & ops     │       │
│             arch                    with tests    readiness │       │
│                                                             │       │
│                                                    Phase 5  │       │
│                                                  OPERATIONS─┤       │
│                                                   Deploy &  │       │
│                                                   observe   │       │
│                                                             │       │
│                                                    Phase 6  │       │
│                                                  EVOLUTION──┘       │
│                                                   Learn &           │
│                                                   improve           │
├─────────────────────────────────────────────────────────────────────┤
│  ┌──────────┐ ┌──────────┐ ┌──────────────┐ ┌──────────────┐      │
│  │ SECURITY │ │ QUALITY  │ │ TRACEABILITY │ │    COST      │      │
│  │ Pillar   │ │ Pillar   │ │ Pillar       │ │  AWARENESS   │      │
│  │          │ │          │ │              │ │   Pillar     │      │
│  └──────────┘ └──────────┘ └──────────────┘ └──────────────┘      │
│              Four Pillars — Active in ALL Phases                    │
└─────────────────────────────────────────────────────────────────────┘
```

| Phase | Name | Purpose | Key Deliverables |
|-------|------|---------|-----------------|
| 0 | [Foundation](docs/framework/PHASE-0-FOUNDATION.md) | Bootstrap project structure and governance | CLAUDE.md, repo structure, CI/CD skeleton |
| 1 | [Inception](docs/framework/PHASE-1-INCEPTION.md) | From intent to architecture | Requirements (REQ-001), ADRs, initial security review |
| 2 | [Elaboration](docs/framework/PHASE-2-ELABORATION.md) | From architecture to specification | User stories, technical spec, traceability matrix |
| 3 | [Construction](docs/framework/PHASE-3-CONSTRUCTION.md) | Bolt-driven development | Working code, paired tests, captain's logs |
| 4 | [Hardening](docs/framework/PHASE-4-HARDENING.md) | Production readiness | Security audit, ops checklist, cost controls |
| 5 | [Operations](docs/framework/PHASE-5-OPERATIONS.md) | Deploy and observe | Deployment pipeline, runbooks, monitoring |
| 6 | [Evolution](docs/framework/PHASE-6-EVOLUTION.md) | Learn and improve | Retrospectives, pattern extraction, drift detection |

---

## The Four Pillars

Pillars are cross-cutting concerns active in **every** phase. They're not sequential — they run continuously.

| Pillar | Concern | Key Practice |
|--------|---------|-------------|
| [Security](docs/pillars/PILLAR-SECURITY.md) | Adversarial review & compliance | Five-persona security review |
| [Quality](docs/pillars/PILLAR-QUALITY.md) | Testing, linting, code review | Test-paired development |
| [Traceability](docs/pillars/PILLAR-TRACEABILITY.md) | Requirements-to-deployment chain | Traceability matrix |
| [Cost Awareness](docs/pillars/PILLAR-COST.md) | Budget tracking & optimization | Monitor, dashboard, kill switch |

---

## Key Innovations

### 1. The Hardening Phase
"Features complete" ≠ "production ready." Phase 4 is dedicated to alarms, monitoring, security fixes, and kill switches — the work that turns a demo into a product.

### 2. Build-Then-Harden
For AI-assisted development, working code is a better artifact for review than abstract specifications. Build it, then harden it — don't over-specify before writing a line of code.

### 3. Five Questions Pattern
Before implementing, the AI surfaces its own assumptions. The human validates or corrects. This replaces traditional elaboration ceremonies and prevents entire classes of errors.

### 4. Persistent Context as First-Class Artifact
CLAUDE.md (or equivalent context file) is the highest-leverage artifact in AI-assisted development. Without it, every session starts from zero.

### 5. Adversarial Self-Review
Five-persona security review: the AI reviews its own code from hostile perspectives (attacker, auditor, ops engineer, cost analyst, end user), producing findings that traditional code review cannot match.

### 6. Cost as a First-Class Citizen
Cost management is designed from day one, not bolted on post-deployment. Budget → Monitor → Dashboard → Kill Switch.

---

## Governance Models

AI-DLC scales from solo developers to enterprise teams:

| Model | Team Size | Guide |
|-------|-----------|-------|
| [Solo + AI](docs/governance/SOLO-AI.md) | 1 developer + AI | Five Questions, captain's logs, context files |
| [Small Team](docs/governance/SMALL-TEAM.md) | 2-5 developers + AI | Shared context, namespaced logs, branch strategy |
| [Enterprise](docs/governance/ENTERPRISE.md) | 5+ developers, multiple teams | Formal governance, compliance gates, multi-team traceability |

---

## Comparison to Traditional Approaches

| Dimension | Traditional SDLC | Agile/Scrum | AI-DLC |
|-----------|------------------|-------------|--------|
| Planning unit | Phase/milestone | Sprint/story | **Bolt** (focused unit of work) |
| Estimation | Hours/days | Story points | **T-shirt sizes** (S/M/L/XL) |
| Security | End-of-project audit | Per-sprint review | **Continuous + hardening phase** |
| Documentation | Heavyweight upfront | Minimal | **Context files** (living, AI-consumed) |
| Cost management | Post-deployment | Sprint budget | **Day-one design concern** |
| AI integration | None/ad-hoc | Tool-level | **First-class development partner** |
| Quality assurance | QA team | Dev-tested | **Test-paired development** |
| Knowledge retention | Wiki/Confluence | Tribal knowledge | **Persistent context files** |

---

## Templates

AI-DLC includes [14 foundational document templates](templates/) ready to use in any project:

- [Requirements](templates/REQUIREMENTS.md) — Structured requirements with IDs
- [Traceability Matrix](templates/TRACEABILITY-MATRIX.md) — REQ → Story → Code → Test mapping
- [User Stories](templates/USER-STORIES.md) — Stories with acceptance criteria
- [Context File](templates/CLAUDE-CONTEXT.md) — AI context file template
- [Security](templates/SECURITY.md) — Security policy and practices
- [PM Framework](templates/PM-FRAMEWORK.md) — Project management setup
- [Solo AI Workflow](templates/SOLO-AI-WORKFLOW-GUIDE.md) — Solo + AI development guide
- [CI/CD Proposal](templates/CICD-DEPLOYMENT-PROPOSAL.md) — Deployment pipeline design
- [Multi-Developer Guide](templates/MULTI-DEVELOPER-GUIDE.md) — Team collaboration
- [Infrastructure Playbook](templates/INFRASTRUCTURE-PLAYBOOK.md) — Infrastructure setup
- [Cost Management](templates/COST-MANAGEMENT-GUIDE.md) — Cost tracking and controls
- [Security Review Protocol](templates/SECURITY-REVIEW-PROTOCOL.md) — Review methodology
- [Ops Readiness Checklist](templates/OPS-READINESS-CHECKLIST.md) — Production readiness
- [Case Study](templates/AI-DLC-CASE-STUDY.md) — Document your AI-DLC journey

---

## Reference

- [Bolt Metrics Guide](docs/reference/BOLT-METRICS-GUIDE.md) — Measure velocity and quality
- [Five-Persona Review](docs/reference/FIVE-PERSONA-REVIEW.md) — Detailed review methodology
- [AWS Well-Architected Mapping](docs/reference/AWS-WELL-ARCHITECTED-MAPPING.md) — AI-DLC to WAF alignment
- [Audit Scoring](docs/reference/AUDIT-SCORING.md) — 8-dimension assessment methodology
- [Glossary](docs/reference/GLOSSARY.md) — Key terms and definitions

---

## Contributing

AI-DLC practices what it preaches. See [CLAUDE.md](CLAUDE.md) for contribution conventions. The framework uses its own Phase 0-6 lifecycle for development.

---

## License

[MIT](LICENSE)
