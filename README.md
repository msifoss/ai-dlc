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
- **Battle-tested delivery** — synthesized from the CallHero reference implementation (25 bolts, 216 tests, 200+ security findings, 9-day production deployment)
- **Autonomous execution philosophy** — structured workflows with validation gates
- **Industry standards** — AWS Well-Architected Framework, NIST AI RMF, ISO/IEC 42001, OWASP Top 10 for LLMs

---

## Quick Start (5 Minutes)

```bash
# 1. Clone the framework
git clone https://github.com/msifoss/ai-dlc.git

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

### 7. Autonomous Execution with The Ascent
AI agents persist until verified complete — not until the first test passes. The Ascent loop (implement → verify → check criteria → fix or confirm) replaces the "generate and declare done" pattern with disciplined self-verification.

### 8. Trust-Adaptive Gates
Review ceremony scales with earned trust. New projects start with full review of every diff. Mature projects with proven track records earn reduced ceremony — but high-risk work (auth, payments, PII) always receives full scrutiny regardless of trust level.

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
- [Audit Scoring](docs/reference/AUDIT-SCORING.md) — 9-dimension assessment methodology
- [Autonomous Execution Guide](docs/reference/AUTONOMOUS-EXECUTION-GUIDE.md) — The Ascent, multi-agent execution, trust-adaptive gates
- [Framework Review (March 2026)](docs/reference/FRAMEWORK-REVIEW-2026-03.md) — Industry benchmark against 17 external sources
- [Glossary](docs/reference/GLOSSARY.md) — Key terms and definitions

---

## References & Sources

AI-DLC was built by synthesizing standards, research, frameworks, and production experience. Every claim in the framework traces to at least one external source. This is the complete bibliography.

### Standards & Regulations

| Standard | Organization | How AI-DLC Uses It |
|----------|-------------|-------------------|
| [NIST AI Risk Management Framework (AI RMF 1.0)](https://www.nist.gov/itl/ai-risk-management-framework) | NIST | GOVERN/MAP/MEASURE/MANAGE maps directly to AI-DLC's phase-gated governance model |
| [NIST AI 600-1: Generative AI Profile](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.600-1.pdf) | NIST | AI-specific risk categories inform the Security Pillar and Five-Persona Review |
| [NIST SP 800-218A: Secure Software Development for GenAI](https://csrc.nist.gov/pubs/sp/800/218/a/final) | NIST | Supplements SSDF with GenAI-specific practices; validates Phase 4 Hardening |
| [ISO/IEC 42001:2023 — AI Management Systems](https://www.iso.org/standard/42001) | ISO/IEC | First certifiable AI management standard; PDCA methodology aligns with AI-DLC's phase cycle |
| [EU AI Act](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai) | European Commission | Human oversight (Art. 14), traceability (Art. 12), documentation (Art. 11) requirements structurally mirror AI-DLC phases. GPAI rules in force Aug 2025; full applicability Aug 2026 |
| [Singapore IMDA Agentic AI Framework](https://www.imda.gov.sg/resources/press-releases-factsheets-and-speeches/press-releases/2026/new-model-ai-governance-framework-for-agentic-ai) | IMDA Singapore | World's first agentic AI governance framework (Jan 2026). Human checkpoints and graduated autonomy validate AI-DLC's trust-adaptive gates |
| [IEEE P3394 / P3428](https://ieeexplore.ieee.org/document/11050630/) | IEEE | First IEEE standards for agentic AI systems (in development). AI-DLC fills the standards vacuum these aim to address |
| [OWASP Top 10](https://owasp.org/www-project-top-ten/) | OWASP | Security vulnerability classification integrated into the Five-Persona Review methodology |
| [OWASP Top 10 for LLM Applications](https://owasp.org/www-project-top-10-for-large-language-model-applications/) | OWASP | AI-specific attack vectors (prompt injection, training data poisoning, supply chain) inform the Security Pillar |
| [ISO/IEC 42001 + EU AI Act: A Practical Pairing](https://www.isaca.org/resources/news-and-trends/industry-news/2025/isoiec-42001-and-eu-ai-act-a-practical-pairing-for-ai-governance) | ISACA | Compliance pairing guidance that validates AI-DLC's dual alignment approach |

### Industry Research

| Source | Organization | Key Finding | AI-DLC Response |
|--------|-------------|-------------|-----------------|
| [DORA 2025 Report](https://dora.dev/research/2025/dora-report/) | DORA | "The Mirror Effect" — AI amplifies existing practices, good or bad. 90% developer adoption. | Bolt discipline and quality pillar ensure AI amplifies good practices |
| [METR RCT Study](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/) | METR | Experienced devs 19% *slower* with AI on complex tasks — while believing they were 24% *faster* | The Ascent pattern and trust-adaptive gates directly address this overconfidence gap |
| [Sonar 2026 Report](https://www.sonarsource.com/company/press-releases/sonar-data-reveals-critical-verification-gap-in-ai-coding/) | SonarSource | 42% of committed code is AI-generated; only 48% always verify before committing | Five-Persona Review and test-paired development enforce verification |
| [CodeRabbit AI vs Human Code Report](https://www.coderabbit.ai/blog/state-of-ai-vs-human-code-generation-report) | CodeRabbit | AI code has 2.74x more security vulnerabilities, 1.7x more major issues | Five-Persona Review catches the vulnerability classes AI introduces |
| [CodeScene Agentic AI Patterns](https://codescene.com/blog/agentic-ai-coding-best-practice-patterns-for-speed-with-quality) | CodeScene | AI increases defect risk by 30%+ on unhealthy codebases; healthy codebases benefit | Phase 0 Foundation ensures codebase health before AI-assisted construction |
| [Qodo State of AI Code Quality](https://www.qodo.ai/reports/state-of-ai-code-quality/) | Qodo | 65% say AI misses relevant context; senior devs least willing to ship unreviewed | Context files (CLAUDE.md) solve the context gap; trust-adaptive gates address review scaling |
| [Stack Overflow 2025 Survey](https://survey.stackoverflow.co/2025) | Stack Overflow | 49,000+ devs: trust in AI accuracy fell to 29%; 66% frustrated by "almost right" output | The Ascent persistence loop replaces "almost right" with verified complete |
| [JetBrains Developer Ecosystem 2025](https://devecosystem-2025.jetbrains.com/) | JetBrains | Developer ecosystem trends and AI adoption patterns | Informs governance model design and toolchain recommendations |
| [Atlassian Developer Experience 2025](https://www.atlassian.com/blog/developer/developer-experience-report-2025) | Atlassian | 99% save time with AI; 50% lose 10+ hours/week to organizational friction — net wash | Bolt-driven development and PM framework reduce organizational friction |
| [GitHub + Accenture Copilot Impact](https://github.blog/news-insights/research/research-quantifying-github-copilots-impact-in-the-enterprise-with-accenture/) | GitHub + Accenture | Enterprise-scale productivity impact measurement | Validates bolt metrics approach to measuring AI-assisted productivity |
| [Microsoft New Future of Work 2025](https://www.microsoft.com/en-us/research/wp-content/uploads/2025/12/New-Future-Of-Work-Report-2025.pdf) | Microsoft Research | Future of work trends with AI integration | Informs multi-agent coordination and task delegation patterns |

### Leading Frameworks

| Framework | Organization | Relationship to AI-DLC |
|-----------|-------------|----------------------|
| [AI-Driven Development Life Cycle](https://aws.amazon.com/blogs/devops/ai-driven-development-life-cycle/) | AWS | Same acronym, convergent thinking. AWS's Plan-Clarify-Validate-Implement cycle parallels AI-DLC phases. Their "Mob Elaboration" is our Five Questions Pattern. |
| [Spec-Driven Development (Radar Vol. 33)](https://www.thoughtworks.com/en-us/insights/blog/agile-engineering-practices/spec-driven-development-unpacking-2025-new-engineering-practices) | Thoughtworks | Separates specification from implementation — the same insight behind IDEA-INTENT-UNIT-BOLT. Named "context engineering" as a core discipline. Adopted AGENTS.md (our CLAUDE.md). |
| [AI-Led SDLC / GitHub Spec Kit](https://techcommunity.microsoft.com/blog/appsonazureblog/an-ai-led-sdlc-building-an-end-to-end-agentic-software-development-lifecycle-with/4491896) | Microsoft (Build 2025) | Specify-Plan-Tasks-Implement cycle with Copilot as async agentic collaborator. Validates AI-DLC's phase-first approach. |
| [AI-Enabled Software Product Development](https://www.mckinsey.com/industries/technology-media-and-telecommunications/our-insights/how-an-ai-enabled-software-product-development-life-cycle-will-fuel-innovation) | McKinsey | Argues the operating model must change, not just dev process. Five dimensions: Structure, Strategy, Ways of Working, Culture, Tooling. Validates AI-DLC's governance models. |
| [Agentic Coding Trends 2026](https://resources.anthropic.com/2026-agentic-coding-trends-report) | Anthropic | Multi-agent coordination is the dominant pattern; task horizons expanding from minutes to days. Validates AI-DLC's Olympian agent taxonomy. |
| [Understanding SDD Tools](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html) | Martin Fowler | Deep analysis of Spec-Driven Development tooling. Validates the specification-first approach. |
| [AWS Well-Architected Framework](docs/reference/AWS-WELL-ARCHITECTED-MAPPING.md) | AWS | Six pillars mapped to AI-DLC phases and pillars. See the [full mapping](docs/reference/AWS-WELL-ARCHITECTED-MAPPING.md). |

### Responsible AI

| Source | Organization | Contribution |
|--------|-------------|-------------|
| [Responsible Scaling Policy v3](https://www.anthropic.com/news/responsible-scaling-policy-v3) | Anthropic | AI Safety Levels (ASL-1 to ASL-4+); governance embedded from day one. Informs trust-adaptive gates. |
| [The Need for Transparency in Frontier AI](https://www.anthropic.com/news/the-need-for-transparency-in-frontier-ai) | Anthropic | Transparency principles that inform AI-DLC's traceability pillar and captain's log practice |

### Tools Referenced

AI-DLC is tool-agnostic, but references these tools as examples in templates and guides:

| Tool | Purpose | Referenced In |
|------|---------|--------------|
| [Ruff](https://github.com/astral-sh/ruff-pre-commit) | Python linting and formatting | Phase 0, Quality Pillar |
| [Black](https://github.com/psf/black) | Python code formatting | Quality Pillar |
| [Mypy](https://github.com/pre-commit/mirrors-mypy) | Python static type checking | Quality Pillar |
| [pre-commit](https://github.com/pre-commit/pre-commit-hooks) | Git hook framework | Phase 0, Quality Pillar |
| [Gitleaks](https://github.com/gitleaks/gitleaks) | Secret detection in repositories | Phase 0, Security Pillar |
| [golangci-lint](https://github.com/golangci/golangci-lint) | Go linting | Quality Pillar |
| [Go pre-commit hooks](https://github.com/dnephin/pre-commit-golang) | Go formatting | Quality Pillar |

### Format Standards

| Standard | Usage |
|----------|-------|
| [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) | CHANGELOG.md format |
| [Semantic Versioning](https://semver.org/spec/v2.0.0.html) | Version numbering (MAJOR.MINOR.PATCH) |

### Production Experience

AI-DLC was built from lessons learned in the **CallHero** project — a production AWS serverless application developed using AI-assisted practices over 25 bolts. That project produced 216 tests, surfaced 200+ security findings across 4 review rounds, and went from zero to production deployment in 9 days. The patterns that worked became AI-DLC's phases. The patterns that failed became AI-DLC's warnings.

---

## Contributing

AI-DLC practices what it preaches. See [CLAUDE.md](CLAUDE.md) for contribution conventions. The framework uses its own Phase 0-6 lifecycle for development.

---

## License

[MIT](LICENSE)
