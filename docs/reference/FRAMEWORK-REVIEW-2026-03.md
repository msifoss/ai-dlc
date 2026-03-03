# AI-DLC Framework Review — March 2026

**Date:** 2026-03-03
**Version Reviewed:** 1.1.0
**Method:** Internal review benchmarked against current industry standards, research, and best practices

---

## Purpose

This document captures a comprehensive review of the AI-DLC framework against the most current and widely accepted practices from the world's leading standards bodies, research institutions, consultancies, and technology companies as of early 2026. It identifies what the framework gets right, where gaps exist, and concrete improvement opportunities — including how the existing custom skill ecosystem can be leveraged.

---

## Industry Benchmarks Used

### Standards Bodies

| Standard | Status (March 2026) | Relevance to AI-DLC |
|----------|---------------------|---------------------|
| [NIST AI RMF 1.0](https://www.nist.gov/itl/ai-risk-management-framework) + AI 600-1 (GenAI Profile) | Active; RMF 1.1 addenda expected through 2026 | GOVERN/MAP/MEASURE/MANAGE maps to phase-gated governance |
| [ISO/IEC 42001](https://www.iso.org/standard/42001) | First certifiable AI management system standard (Dec 2023); active enforcement pairing with EU AI Act | PDCA methodology; organizational accountability layer |
| [EU AI Act](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai) | GPAI rules applied Aug 2025; full applicability Aug 2026 | Human oversight, traceability, documentation, QMS — structurally mirrors AI-DLC |
| [Singapore IMDA Agentic AI Framework](https://www.imda.gov.sg/resources/press-releases-factsheets-and-speeches/press-releases/2026/new-model-ai-governance-framework-for-agentic-ai) | Published Jan 2026 (world's first agentic AI governance) | Human checkpoints, agent risk bounding — validates AI-DLC gate model |
| IEEE P3394 / P3428 | In development (2025-2026) | First IEEE standards for agentic AI systems; standards vacuum AI-DLC can fill |
| NIST SP 800-218A | Active | Secure Software Development for GenAI; supplements SSDF |

### Industry Research

| Source | Key Finding |
|--------|-------------|
| [DORA 2025](https://dora.dev/research/2025/dora-report/) (3,000+ professionals) | "The Mirror Effect" — AI amplifies what's already there. 90% adoption. Value Stream Management converts individual gains to organizational advantage. |
| [METR RCT](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/) (16 devs, 246 issues) | Experienced developers took **19% longer** with AI on complex tasks — while believing they were 24% faster. |
| [Sonar 2026](https://www.sonarsource.com/company/press-releases/sonar-data-reveals-critical-verification-gap-in-ai-coding/) (1,100+ devs) | 42% of committed code is AI-generated; only 48% always verify before committing. Projected 65% by 2027. |
| [CodeRabbit](https://www.coderabbit.ai/blog/state-of-ai-vs-human-code-generation-report) (470 PRs) | AI code has 2.74x more security vulnerabilities, 1.7x more major issues, 75% more logic errors. |
| [CodeScene](https://codescene.com/blog/agentic-ai-coding-best-practice-patterns-for-speed-with-quality) | AI increases defect risk by 30%+ on unhealthy codebases. Healthy codebases benefit without penalty. |
| [Qodo 2025](https://www.qodo.ai/reports/state-of-ai-code-quality/) | 65% say AI misses relevant context; inverse trust by experience (seniors least willing to ship unreviewed). |
| [Stack Overflow 2025](https://survey.stackoverflow.co/2025) (49,000+ devs) | Trust in AI accuracy fell to 29%. 46% actively distrust. 66% frustrated by "almost right" output. |
| [Atlassian DevEx 2025](https://www.atlassian.com/blog/developer/developer-experience-report-2025) (3,500 devs) | 99% save time with AI; 50% lose 10+ hours/week to organizational friction — a net wash. |

### Leading Frameworks

| Framework | Organization | Key Pattern |
|-----------|-------------|-------------|
| [AI-Driven Development Lifecycle](https://aws.amazon.com/blogs/devops/ai-driven-development-life-cycle/) | AWS | Same acronym (AI-DLC). Plan → Clarify → Validate → Implement cycle. "Mob Elaboration" ≈ Five Questions. |
| [Spec-Driven Development](https://www.thoughtworks.com/en-us/insights/blog/agile-engineering-practices/spec-driven-development-unpacking-2025-new-engineering-practices) | Thoughtworks (Radar Vol. 33) | Separates specification from implementation; AGENTS.md adopted; "context engineering" named as core discipline. |
| [GitHub Spec Kit](https://techcommunity.microsoft.com/blog/appsonazureblog/an-ai-led-sdlc-building-an-end-to-end-agentic-software-development-lifecycle-with/4491896) | Microsoft (Build 2025) | Specify → Plan → Tasks → Implement. Copilot as async agentic collaborator. |
| [AI-Enabled SDLC](https://www.mckinsey.com/industries/technology-media-and-telecommunications/our-insights/how-an-ai-enabled-software-product-development-life-cycle-will-fuel-innovation) | McKinsey | Organizational operating model must change, not just dev process. 5 dimensions: Structure, Strategy, Ways of Working, Culture, Tooling. |
| [Agentic Coding Trends 2026](https://resources.anthropic.com/2026-agentic-coding-trends-report) | Anthropic | Multi-agent coordination is the dominant pattern. Task horizons expanding from minutes to days. |
| [Responsible Scaling Policy v3](https://www.anthropic.com/news/responsible-scaling-policy-v3) | Anthropic | AI Safety Levels (ASL-1 to ASL-4+); governance embedded from day one. |

---

## What AI-DLC Gets Right (Externally Validated)

### 1. Phase-Gated Human Oversight

Now a **legal requirement** under the EU AI Act and validated by NIST AI RMF, ISO 42001, and Singapore's agentic AI governance framework. AI-DLC had this from v1.0.

**Skill alignment:** The `/dlc-audit` skill's D9 (Human-AI Collaboration Quality) directly scores this capability.

### 2. Separation of Specification from Implementation

The IDEA → INTENT → UNIT → BOLT hierarchy is the same insight Thoughtworks named "Spec-Driven Development" and placed on their Technology Radar as an adopted technique. GitHub Spec Kit, Amazon Kiro, and Martin Fowler's analyses all validate this exact pattern.

**Skill alignment:** The `/dlc-audit` skill's D3 (Specification and Elaboration) scores conformance scoring, which is the quantitative backbone of this separation.

### 3. Context Files as First-Class Artifacts

The CLAUDE.md pattern is now widely adopted as `AGENTS.md` across the industry (Thoughtworks Radar, CodeScene, open-source community). AI-DLC was early here.

**Skill alignment:** The `/init-project` skill creates CLAUDE.md as a foundational artifact. The `/motherhen` skill's Check 1 (Context Freshness) monitors its health — including date currency and numeric accuracy. The `/captainslog` skill maintains the session-level context layer beneath it.

### 4. Five Questions Pattern

AWS independently developed "Mob Elaboration" — essentially the same assumption-surfacing-before-implementation pattern. This is now consensus best practice.

**Skill alignment:** The `/dlc-audit` skill scores this under D9. The `/five-persona-review` skill operationalizes a complementary pattern — assumption testing from adversarial perspectives.

### 5. Cost as a First-Class Pillar

Still uncommon in competing frameworks. McKinsey, FinOps Foundation, and DORA validate this emphasis. Most frameworks treat cost as an afterthought.

**Skill alignment:** The `/budget` skill operationalizes the Cost Pillar with `init`, `update`, `review`, and `optimize` actions. The `/cost-estimate` skill provides T-shirt-sized effort estimation calibrated against real delivery data.

### 6. Build-Then-Harden (Dedicated Phase 4)

The hardening phase remains AI-DLC's most distinctive structural innovation. No major competitor has an equivalent dedicated phase — most embed hardening activities across other phases, diluting them.

**Skill alignment:** The `/security-audit` skill (9 audit categories, finding management) and `/five-persona-review` skill (5 adversarial perspectives) are the operational tools for Phase 4 execution.

### 7. The Bolt as Atomic Work Unit

The bolt cadence (Plan → Build → Review → Retro) with T-shirt sizing provides structure that prevents both the "heroic bolt" anti-pattern and the unbounded scope creep that plagues AI-assisted development.

**Skill alignment:** The `/pm` skill manages bolt lifecycle. The `/bolt-review` skill executes end-of-sprint comprehensive review. The `/captainslog` skill captures per-bolt decision records. The `/cost-estimate` skill sizes new bolts.

### 8. Adversarial Self-Review

The Five-Persona Review methodology (217 findings in real deployment) is validated by the CodeRabbit and CodeScene data showing AI code has significantly more defects. Adversarial review is not optional — it's essential.

**Skill alignment:** The `/five-persona-review` skill operationalizes this with 5 named personas (Staff Engineer / First Principles / Radical Transparency / CTO-Security / SRE-DevOps), severity classification, finding persistence, and fix-by-severity workflow.

---

## Areas That Need Attention

### Gap 1: Internal Inconsistencies (Quick Fixes)

| Issue | Location | Status |
|-------|----------|--------|
| ~~Glossary says "8-dimension assessment"~~ | `docs/reference/GLOSSARY.md` | **FIXED** — Updated to 9 dimensions |
| ~~SOLO-AI.md lists wrong five personas~~ | `docs/governance/SOLO-AI.md` | **FIXED** — Aligned to canonical personas |
| ~~Placeholder GitHub URLs~~ | `README.md`, `CHANGELOG.md` | **FIXED** — Updated to `msifoss/ai-dlc` |

**Skill connection:** The `/motherhen` skill's Check 2 (Documentation Drift) is designed to catch exactly this class of inconsistency. Its detection of "numeric claims consistent across docs and actuals" should flag the 8-vs-9 dimension drift. Consider adding a cross-reference consistency check to `/motherhen` if not already present.

### Gap 2: The Verification Debt Problem (Major Gap)

**The data:** 42% of committed code is AI-generated (Sonar 2026), but only 48% of developers always verify before committing. AI code has 2.74x more security vulnerabilities (CodeRabbit). Projected 65% AI-generated code by 2027.

**What's missing:** AI-DLC assumes human review happens but doesn't address the **verification scaling problem**. As AI code volume grows, human review bandwidth can't keep pace.

**Recommendations:**

1. **AI-generated code provenance tagging** — Add guidance for marking which code was AI-generated (git trailers, metadata). This supports auditability and targeted review.

2. **Tiered verification policies** — Full human review for critical paths, AI-assisted review (the `/five-persona-review` skill) for standard code, automated-only for low-risk changes.

3. **Review bandwidth budgeting** — Treat review capacity as a finite resource, allocated by risk tier. The Trust-Adaptive Gates concept partially addresses this, but the verification debt framing makes it more concrete.

**Skill gap:** No existing skill specifically tags or tracks AI-generated code provenance. The `/five-persona-review` skill could be extended to include a "provenance-aware" mode that flags AI-generated code sections for deeper scrutiny. The `/motherhen` skill could add a "verification coverage" check.

### Gap 3: Codebase Health as a Prerequisite (Missing Concept)

**The data:** CodeScene's research shows AI-coding assistants **increase defect risk by at least 30%** when applied to unhealthy codebases (high technical debt, poor modularity, complex code). Healthy codebases benefit without this penalty.

**What's missing:** AI-DLC assumes greenfield or healthy codebases. There's no guidance for the common case: adopting AI-DLC on an existing project with technical debt.

**Recommendation:** Add a "Codebase Health Assessment" to Phase 0 as a prerequisite gate. If health is below threshold, prescribe a technical debt reduction sprint before enabling AI acceleration. This could include:
- Cyclomatic complexity thresholds
- Test coverage minimums
- Dependency vulnerability counts
- Code duplication percentages

**Skill connection:** The `/motherhen` skill already checks test health and security review currency. An `/arch-audit` skill already performs structural analysis with multi-persona architectural review. These two skills combined could serve as the codebase health gate — formalize this combination as the Phase 0 health check.

### Gap 4: Task Complexity as a Trust Variable (Nuance Needed)

**The data:** METR's RCT found experienced developers on complex, unfamiliar tasks took 19% longer with AI tools — while subjectively believing they were 24% faster. The perception gap is dangerous.

**What's missing:** Trust-Adaptive Gates scale ceremony by team trust level, but don't account for **task complexity**. A Level 3 trust team can still be slowed by AI on novel, complex problems.

**Recommendation:** Add task complexity as a second axis alongside trust level. The gate model becomes a 2D matrix:

|  | Low Complexity | Medium Complexity | High Complexity |
|--|---------------|-------------------|-----------------|
| **Trust 0-1** | Full review | Full review | Full review + pair |
| **Trust 2** | Spot-check | Standard review | Full review |
| **Trust 3** | Post-hoc | Spot-check | Standard review |

The Risk Tier concept partially covers this (Critical tier forces full ceremony), but it's framed around **business risk**, not **cognitive complexity**. These are different things: a simple CRUD endpoint for a payment system is low-complexity but high-risk; a novel algorithm for a logging feature is high-complexity but low-risk.

**Skill connection:** The `/cost-estimate` skill already assesses task complexity through T-shirt sizing. This sizing could feed into the Trust-Adaptive Gate model — an XL bolt should trigger elevated ceremony regardless of trust level.

### Gap 5: Multi-Agent Orchestration (Needs Deepening)

**The data:** Anthropic's 2026 report and Thoughtworks Radar confirm multi-agent systems are the dominant production pattern. Task horizons are expanding from minutes to days.

**Current state:** The Olympian concept (Builder, Reviewer, Scout, Scribe) is solid but abstract. It describes **roles** without prescribing **orchestration patterns**, **context sharing**, or **failure modes**.

**Recommendations:**

1. **Context partitioning guidance** — What goes in shared context (CLAUDE.md) vs. agent-specific context (role instructions). The `/init-project` skill creates the shared context; guidance needed for structuring agent-specific context alongside it.

2. **Orchestration patterns** — Sequential pipeline, fan-out/fan-in, supervisor patterns with concrete examples.

3. **Agent failure handling** — What happens when a sub-agent produces bad output. Fallback strategies, escalation to human.

4. **When multi-agent adds value** — Small tasks (S bolts) rarely benefit from multi-agent overhead. Guidance on when to stay single-agent.

**Skill connection:** The existing skill ecosystem already implements a multi-agent pattern organically:
- `/init-project` = Scout + Scribe (explores, then scaffolds)
- `/five-persona-review` = Reviewer (5 perspectives)
- `/security-audit` = Reviewer (security-focused)
- `/arch-audit` = Reviewer (architecture-focused, multi-persona)
- `/pm` = Scribe (tracks and reports)
- `/captainslog` = Scribe (records decisions)
- `/budget` = Cost Analyst agent
- `/bolt-review` = Orchestrator (coordinates review across multiple concerns)
- `/motherhen` = Monitor agent (health checks)
- `/dlc-audit` = Auditor agent (compliance assessment)

This is a de facto multi-agent system. Document it as such — the skills ARE the Olympians operationalized.

### Gap 6: EU AI Act Compliance Mapping (Growing Importance)

**The data:** As of February 2026, the EU AI Act is in active enforcement. Full applicability for most operators comes August 2026. ISO 42001 is the practical compliance pairing.

**Current state:** There's a NIST AI RMF mapping in the Security Pillar and an AWS Well-Architected Mapping in references. No EU AI Act mapping exists.

**Recommendation:** Add `docs/reference/EU-AI-ACT-MAPPING.md`. The AI-DLC's existing structure already satisfies most requirements — human gates, traceability, documentation, quality management. Making the mapping explicit lets teams use AI-DLC as evidence of compliance.

| EU AI Act Requirement | AI-DLC Coverage |
|-----------------------|-----------------|
| Risk management system | Risk Tiers (Phase 1), Trust-Adaptive Gates (Phase 3) |
| Data governance | Phase 2 data modeling, Phase 4 data integrity checks |
| Technical documentation | 14 foundational documents, Traceability Matrix |
| Logging and auditability | Captain's Logs, git audit trail, Traceability Pillar |
| Human oversight mechanisms | Human Decision Gates (every phase) |
| Quality management system | Quality Pillar, DLC-Audit (9 dimensions) |

**Skill connection:** The `/dlc-audit` skill could add an optional EU AI Act compliance dimension or a separate `compliance` action that maps audit scores to EU AI Act articles.

### Gap 7: The Organizational Operating Model (Blind Spot)

**The data:** McKinsey emphasizes the organizational operating model must change, not just the development process. Atlassian found AI productivity gains are entirely consumed by organizational friction (50% lose 10+ hours/week to finding information). DORA found Value Stream Management converts individual AI gains into organizational advantage.

**What's missing:** AI-DLC is developer-process-centric. It tells you how to **build software** with AI but doesn't address the organizational changes needed to **sustain and benefit from** AI-assisted development.

**Recommendation:** Add a lightweight "Organizational Readiness" section to the governance models covering:
- Role evolution (developer → AI orchestrator, PM → design/QA coordinator)
- Skill requirements (context engineering, specification writing, review judgment)
- Information architecture as the primary value driver (why Context Files, Captain's Logs, and Traceability reduce the friction that consumes AI gains)
- The Atlassian finding: AI time savings are consumed by organizational friction unless information architecture is sound

**Skill connection:** The `/motherhen` skill monitors the information architecture health that McKinsey and Atlassian identify as the actual value driver. Position `/motherhen` not just as a hygiene tool but as the organizational friction detector.

### Gap 8: Context Engineering as a Named Discipline (Terminology Gap)

**The data:** The industry has moved from "prompt engineering" to "context engineering" — the systematic design of all information provided to an LLM. Thoughtworks named it explicitly on their Radar. The analogy gaining traction: "The LLM is a CPU, the context window is RAM, and your job is the operating system."

**Current state:** AI-DLC practices context engineering brilliantly (CLAUDE.md, Five Questions, Captain's Logs) but doesn't name or teach it as a discipline.

**Recommendation:** Elevate "Context Engineering" as a named concept in the Glossary and reference documents. Position the existing artifacts as techniques within this discipline:

| Context Engineering Technique | AI-DLC Artifact | Skill |
|------------------------------|-----------------|-------|
| Persistent project context | CLAUDE.md (Context File) | `/init-project`, `/motherhen` Check 1 |
| Assumption surfacing | Five Questions Pattern | `/dlc-audit` D9 |
| Decision recording | Captain's Log | `/captainslog` |
| Specification as context | IDEA → INTENT → UNIT → BOLT | `/dlc-audit` D3 |
| Adversarial context injection | Five-Persona Review | `/five-persona-review` |
| Session continuity | Captain's Log handoff | `/captainslog` |
| Organizational knowledge | Traceability Matrix | `/motherhen` Check 7 |

---

## Custom Skill Ecosystem: Coverage Map

The existing skill ecosystem provides substantial operational coverage of the AI-DLC framework. This table maps skills to phases and pillars:

### Skills by Phase

| Phase | Primary Skills | Coverage |
|-------|---------------|----------|
| Phase 0: Foundation | `/init-project`, `/dlc-audit init` | Strong — scaffolds all foundational artifacts |
| Phase 1: Inception | `/cost-estimate`, `/arch-audit` | Moderate — architecture review covered; requirements workflow manual |
| Phase 2: Elaboration | `/five-persona-review`, `/dlc-audit` | Moderate — adversarial review covered; spec elaboration manual |
| Phase 3: Construction | `/pm`, `/captainslog`, `/bolt-review`, `/cost-estimate` | Strong — full bolt lifecycle covered |
| Phase 4: Hardening | `/security-audit`, `/five-persona-review`, `/arch-audit` | Strong — multi-perspective adversarial review |
| Phase 5: Operations | `/prodstatus`, `/budget` | Moderate — monitoring covered for CallHero; generic ops tooling gap |
| Phase 6: Evolution | `/motherhen`, `/dlc-audit`, `/changelog` | Strong — drift detection, compliance monitoring, version management |

### Skills by Pillar

| Pillar | Primary Skills | Coverage |
|--------|---------------|----------|
| Security | `/security-audit`, `/five-persona-review` | Strong |
| Quality | `/five-persona-review`, `/bolt-review`, `/motherhen` | Strong |
| Traceability | `/captainslog`, `/pm`, `/changelog`, `/ticky` | Strong |
| Cost | `/budget`, `/cost-estimate` | Strong |

### Identified Skill Gaps

| Gap | Description | Recommendation |
|-----|-------------|----------------|
| Verification provenance | No skill tracks AI-generated code provenance | New skill or `/motherhen` extension |
| Codebase health gate | No skill assesses codebase health as an AI-readiness prerequisite | `/arch-audit` + `/motherhen` combination, formalized |
| EU AI Act compliance | No skill maps to EU AI Act requirements | `/dlc-audit` extension or new action |
| Requirements elaboration | No skill assists with IDEA → INTENT → UNIT decomposition | New skill or `/pm` extension |
| Onboarding/context transfer | No skill assists new team members in absorbing project context | `/captainslog read` partially covers; dedicated onboarding workflow needed |

---

## Priority Roadmap

| Priority | Item | Effort | Skill Impact |
|----------|------|--------|-------------|
| **Fix now** | 3 internal inconsistencies (glossary, personas, URLs) | S | `/motherhen` should catch these |
| **High** | Verification debt / provenance guidance | M | New `/motherhen` check or skill |
| **High** | Codebase health prerequisite in Phase 0 | S | `/arch-audit` + `/motherhen` formalized |
| **High** | EU AI Act compliance mapping | M | `/dlc-audit` extension |
| **Medium** | Task complexity axis in Trust-Adaptive Gates | S | `/cost-estimate` T-shirt size feeds gate model |
| **Medium** | Multi-agent orchestration patterns (deepen Olympians) | M | Document existing skills as the Olympian implementation |
| **Medium** | Context Engineering as named discipline | S | Glossary + reference doc update |
| **Low** | Organizational readiness guidance | M | Governance model updates |

---

## Skill Audit Recommendation

The custom skill ecosystem should itself be audited against these findings. Recommended approach:

1. **Run `/dlc-audit`** against the AI-DLC framework itself to establish baseline scores
2. **Run `/five-persona-review`** against each custom skill definition, focusing on:
   - Internal consistency with AI-DLC framework terminology and concepts
   - Coverage gaps identified in this review
   - Alignment with industry best practices documented here
3. **Run `/motherhen`** to check documentation drift between skill definitions and framework docs
4. **Run `/arch-audit`** to assess the skill ecosystem architecture as a whole — are the skills well-decomposed, or is there overlap and inconsistency?

This creates a virtuous cycle: the framework guides the skills, the skills operationalize the framework, and the audit tools verify both.

---

## Sources

### Standards Bodies
- [NIST AI Risk Management Framework](https://www.nist.gov/itl/ai-risk-management-framework)
- [NIST AI 600-1: Generative AI Profile](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.600-1.pdf)
- [NIST SP 800-218A: Secure Software Development for GenAI](https://csrc.nist.gov/pubs/sp/800/218/a/final)
- [ISO/IEC 42001:2023 — AI Management Systems](https://www.iso.org/standard/42001)
- [EU AI Act](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai)
- [Singapore IMDA: Model AI Governance Framework for Agentic AI](https://www.imda.gov.sg/resources/press-releases-factsheets-and-speeches/press-releases/2026/new-model-ai-governance-framework-for-agentic-ai)
- [IEEE P3394/P3428: Standards for Agentic AI Systems](https://ieeexplore.ieee.org/document/11050630/)

### Industry Frameworks
- [AWS: AI-Driven Development Life Cycle](https://aws.amazon.com/blogs/devops/ai-driven-development-life-cycle/)
- [Thoughtworks: Spec-Driven Development (Radar Vol. 33)](https://www.thoughtworks.com/en-us/insights/blog/agile-engineering-practices/spec-driven-development-unpacking-2025-new-engineering-practices)
- [Microsoft Build 2025: AI-Led SDLC](https://techcommunity.microsoft.com/blog/appsonazureblog/an-ai-led-sdlc-building-an-end-to-end-agentic-software-development-lifecycle-with/4491896)
- [McKinsey: AI-Enabled Software Product Development Lifecycle](https://www.mckinsey.com/industries/technology-media-and-telecommunications/our-insights/how-an-ai-enabled-software-product-development-life-cycle-will-fuel-innovation)
- [Anthropic: 2026 Agentic Coding Trends Report](https://resources.anthropic.com/2026-agentic-coding-trends-report)
- [Martin Fowler: Understanding SDD Tools](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html)

### Research and Surveys
- [DORA 2025: State of AI-Assisted Software Development](https://dora.dev/research/2025/dora-report/)
- [METR: Measuring AI Impact on Developer Productivity](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/)
- [Sonar: The Verification Gap (January 2026)](https://www.sonarsource.com/company/press-releases/sonar-data-reveals-critical-verification-gap-in-ai-coding/)
- [CodeRabbit: AI vs Human Code Generation Report](https://www.coderabbit.ai/blog/state-of-ai-vs-human-code-generation-report)
- [CodeScene: Agentic AI Coding Best Practice Patterns](https://codescene.com/blog/agentic-ai-coding-best-practice-patterns-for-speed-with-quality)
- [Stack Overflow 2025 Developer Survey](https://survey.stackoverflow.co/2025)
- [JetBrains State of Developer Ecosystem 2025](https://devecosystem-2025.jetbrains.com/)
- [Atlassian State of Developer Experience 2025](https://www.atlassian.com/blog/developer/developer-experience-report-2025)
- [Qodo: State of AI Code Quality 2025](https://www.qodo.ai/reports/state-of-ai-code-quality/)
- [GitHub + Accenture: Quantifying Copilot's Enterprise Impact](https://github.blog/news-insights/research/research-quantifying-github-copilots-impact-in-the-enterprise-with-accenture/)
- [Microsoft Research: New Future of Work Report 2025](https://www.microsoft.com/en-us/research/wp-content/uploads/2025/12/New-Future-Of-Work-Report-2025.pdf)

### Responsible AI
- [Anthropic: Responsible Scaling Policy v3](https://www.anthropic.com/news/responsible-scaling-policy-v3)
- [Anthropic: Framework for AI Development Transparency](https://www.anthropic.com/news/the-need-for-transparency-in-frontier-ai)
- [ISO/IEC 42001 and EU AI Act: A Practical Pairing](https://www.isaca.org/resources/news-and-trends/industry-news/2025/isoiec-42001-and-eu-ai-act-a-practical-pairing-for-ai-governance)
