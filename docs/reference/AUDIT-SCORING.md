# Audit Scoring — 9-Dimension Assessment

The `dlc-audit` assessment measures how well a project follows the AI-DLC framework across nine dimensions. Use it to identify gaps, track maturity over time, and demonstrate compliance to stakeholders.

---

## Overview

The assessment evaluates nine dimensions that span the entire AI-DLC lifecycle. Each dimension scores 0-10 based on a rubric. The overall score is the average of all nine dimensions, mapped to a maturity rating.

```
┌─────────────────────────────────────────────────────────────┐
│                    9-DIMENSION ASSESSMENT                     │
│                                                              │
│  1. Foundation & Context ──── Phase 0                        │
│  2. Requirements & Arch ───── Phase 1                        │
│  3. Specification ─────────── Phase 2                        │
│  4. Construction Process ──── Phase 3                        │
│  5. Security Posture ──────── Security Pillar (all phases)   │
│  6. Operational Readiness ─── Phase 4-5                      │
│  7. Cost Management ──────── Cost Pillar (all phases)        │
│  8. Evolution & Learning ──── Phase 6                        │
│  9. Human-AI Collaboration ── Cross-cutting (all phases)     │
│                                                              │
│  Score each 0-10 → Average → Maturity Rating                │
└─────────────────────────────────────────────────────────────┘
```

---

## The 9 Dimensions

### Dimension 1: Foundation & Context (Phase 0)

**What it measures:** Project bootstrap quality, context file completeness, governance setup, and repository structure.

| Score | Criteria |
|-------|----------|
| 0-2 | No context file, or a generic/boilerplate context file. No governance model documented. Repository has no consistent structure. |
| 3-4 | Context file exists but is incomplete (missing conventions, terminology, or architecture). Governance model mentioned but not detailed. Basic repo structure. |
| 5-6 | Context file covers project identity, structure, and conventions. Governance model selected and documented. Repo structure is consistent. Linting configured. |
| 7-8 | Context file is comprehensive, specific, and actionable. Pre-commit hooks installed with secret scanning. CI pipeline runs lint, test, and security jobs. PM framework initialized. |
| 9-10 | Context file is a living document updated regularly. All 14 templates initialized. CI/CD skeleton passes. Context file enables a new developer (or AI session) to orient in under 5 minutes. Governance model has been reviewed and is appropriate for the team. |

**Key artifacts:** CLAUDE.md, README.md, .gitignore, .pre-commit-config.yaml, CI pipeline, PM-FRAMEWORK.md

### Dimension 2: Requirements & Architecture (Phase 1)

**What it measures:** Requirement completeness, architecture decision quality, and initial security review.

| Score | Criteria |
|-------|----------|
| 0-2 | No formal requirements. Architecture is implicit or undocumented. No ADRs. |
| 3-4 | Requirements exist but lack structure (no IDs, no priority, no traceability). Architecture described informally. |
| 5-6 | Requirements have unique IDs (REQ-001). At least one ADR exists. Initial threat model drafted. Technology stack documented. |
| 7-8 | All requirements are numbered, prioritized, and categorized (functional, security, non-functional). Multiple ADRs with trade-off analysis. Threat model covers all major components. Security requirements (REQ-SEC-xxx) exist. |
| 9-10 | Requirements are complete, testable, and stakeholder-approved. ADRs reference relevant industry standards. Threat model is component-level. Context file updated with all Phase 1 decisions. Human sign-off recorded. |

**Key artifacts:** REQUIREMENTS.md, ADRs, threat model, SECURITY.md, updated CLAUDE.md

### Dimension 3: Specification & Elaboration (Phase 2)

**What it measures:** User story quality, technical specification depth, Five Questions usage, and traceability matrix initialization.

| Score | Criteria |
|-------|----------|
| 0-2 | No user stories. No technical specification. No traceability matrix. |
| 3-4 | User stories exist but lack acceptance criteria or lack Given-When-Then format. Spec is informal. Matrix is missing or stub. |
| 5-6 | User stories have acceptance criteria. Technical spec covers main components. Traceability matrix links REQ to Story to Spec. Five Questions used on at least some features. |
| 7-8 | All stories satisfy INVEST criteria. Technical spec includes API contracts, data models, and error handling. Traceability matrix has no orphan rows. Momus and Metis gates passed. Five Questions used on all feature areas. |
| 9-10 | Specifications are precise enough that Construction flows without ambiguity. All Five Questions "Correct" responses reflected in specs. Validation gates documented with findings. All edge cases and abuse cases specified. Human sign-off on PRD and tech spec. Artifact hierarchy (IDEA → INTENT → UNIT → BOLT) fully elaborated with conformance scores >= 90%. Dependency graph generated for bolt sequencing. |

**Key artifacts:** USER-STORIES.md, technical specification, TRACEABILITY-MATRIX.md, Five Questions logs

### Dimension 4: Construction Process (Phase 3)

**What it measures:** Bolt discipline, test-paired development, captain's log practice, and code quality.

| Score | Criteria |
|-------|----------|
| 0-2 | No bolt structure. Tests are absent or afterthought. No captain's logs. Code quality is inconsistent. |
| 3-4 | Some bolt structure but inconsistent. Tests exist for some features. Captain's logs written sporadically. |
| 5-6 | Consistent bolt workflow (plan, execute, review, retro). Tests paired with code for most bolts. Captain's logs written for most bolts. Commit messages follow conventions. |
| 7-8 | Every bolt has a captain's log. Test delta is positive for every sprint. Bolt metrics tracked (commits, lines, tests, time). T-shirt sizing used and calibrated. Traceability matrix updated per bolt. |
| 9-10 | Bolt discipline is exemplary: clear scope, accurate estimation, paired tests, retro insights captured. Test coverage exceeds 80%. Commit messages reference requirement IDs. Context file updated during construction. Zero XL bolts (all split during planning). Multi-agent execution model applied where appropriate (specialized agents for review, research, documentation). The Ascent verification loop consistently followed — every bolt verified against all acceptance criteria before completion. |

**Key artifacts:** Captain's logs, bolt metrics, test suite, traceability matrix updates, commit history

### Dimension 5: Security Posture (Security Pillar)

**What it measures:** Five-persona review execution, finding management, OWASP coverage, and security controls.

| Score | Criteria |
|-------|----------|
| 0-2 | No security review conducted. No finding tracking. Default configurations in production. |
| 3-4 | Some security review conducted but informal. Findings noted but not tracked with severity or status. Some controls missing (encryption, IAM). |
| 5-6 | Five-persona review conducted at least once (e.g., Phase 4). Findings have IDs and severity. Critical findings resolved. Basic cloud security controls in place. |
| 7-8 | Five-persona review conducted per phase. All Critical and High findings resolved. OWASP Top 10 checklist complete. IAM audit performed. Encryption at rest and in transit verified. Dependency scan passes. |
| 9-10 | Five-persona review integrated into every bolt. Finding lifecycle tracked from discovery to verification. Won't Fix decisions documented with compensating controls. Quarterly re-reviews scheduled. Security findings trend downward over time. Compliance mapping (NIST, ISO) documented. |

**Key artifacts:** Security review report, findings log, OWASP checklist, IAM audit, dependency scan report

### Dimension 6: Operational Readiness (Phase 4-5)

**What it measures:** Ops readiness checklist score, monitoring, alerting, runbooks, deployment automation, and resilience patterns.

| Score | Criteria |
|-------|----------|
| 0-2 | No ops readiness assessment. No monitoring. Manual deployments. No runbooks. |
| 3-4 | Some monitoring in place. Deployment is semi-automated. Runbooks are sketchy or missing. No DLQs or circuit breakers. |
| 5-6 | Ops readiness checklist scored. Health checks on main services. Basic alerting configured. Deployment is automated. Rollback procedure exists. |
| 7-8 | Ops readiness score >= 70/94. Structured logging with correlation IDs. Alarms on all critical paths with linked runbooks. DLQs on async processors. Load testing completed. Rollback tested. |
| 9-10 | Ops readiness score >= 85/94. Every critical path has a health check, metric, alarm, and runbook. Performance meets defined targets (p50, p95, p99). Circuit breakers and retry logic implemented. Deployment is zero-downtime with automated smoke tests. Canary testing active. |

**Key artifacts:** Ops readiness scorecard, alarm inventory, dashboards, runbooks, load test report, deployment pipeline

### Dimension 7: Cost Management (Cost Awareness Pillar)

**What it measures:** Budget awareness, cost monitoring, dashboards, kill switches, and ongoing optimization.

| Score | Criteria |
|-------|----------|
| 0-2 | No cost awareness. No budget set. No monitoring of cloud spend. No kill switches. |
| 3-4 | Budget exists informally. Cost checked occasionally via console. No automated alerts. |
| 5-6 | Cost baseline documented. Budget alarms configured. Basic cost dashboard exists. AI/ML costs tracked. |
| 7-8 | Cost dashboard with per-service breakdown. Budget alarms at 50%, 80%, 100% thresholds. Kill switches implemented for runaway costs. Cost-per-transaction metric tracked. Cost analyst persona findings addressed. |
| 9-10 | Cost management is proactive. Kill switches tested and verified. 3-month and 12-month cost projections documented. Cost trends reviewed monthly. Decommissioned resources cleaned up. Cost is a design input, not an afterthought. FinOps practices integrated into bolt planning. |

**Key artifacts:** Cost baseline, budget alarms, cost dashboard, kill switch implementations, cost projections

### Dimension 8: Evolution & Learning (Phase 6)

**What it measures:** Learning system adoption, context file maintenance, drift detection, retrospective practice, and framework self-improvement.

| Score | Criteria |
|-------|----------|
| 0-2 | No evolution activities. Context file unchanged since Phase 0. No retrospectives. |
| 3-4 | Occasional retrospectives. Context file updated sporadically. No drift detection. |
| 5-6 | Regular bolt retros. Context file updated with major learnings. Some drift detection (dependency updates). Quarterly security re-review scheduled. |
| 7-8 | Five-phase learning loop active (passive feedback, pattern extraction, preference learning, context injection, agent discovery). Drift detection across infrastructure, configuration, process, and dependencies. Quarterly retrospectives with action items. Patterns extracted and documented. |
| 9-10 | Learning system is continuous and measurable. Context file accuracy audited quarterly. Decommissioning procedures followed for retired features. Metrics dashboard current with positive trends. Framework improvement proposals submitted. Case study documented. Team demonstrates measurable improvement in velocity, quality, and security over time. Automated learning system active: feedback capture, pattern extraction with 30-day decay, preference learning, and context injection. Agent discoveries documented and integrated. |

**Key artifacts:** Updated CLAUDE.md, pattern catalog, drift reports, retrospective records, metrics dashboard, case study

### Dimension 9: Human-AI Collaboration Quality (Cross-cutting)

**What it measures:** Whether humans are steering development decisions or just accepting AI output. The quality of the partnership between human judgment and AI capability.

| Score | Criteria |
|-------|----------|
| 0-2 | No evidence of human decision-making in the development process. AI appears to be running on autopilot. No captain's logs or decision records. |
| 3-4 | Some human decisions visible but sparse. Most logs read like AI-generated output. Deploys appear automated without human review. Security findings lack human triage. |
| 5-6 | Human decisions visible in some logs. Security reviews have human-assigned dispositions. Deploys are human-initiated. Some architecture choices show human judgment. Five Questions Pattern used occasionally. |
| 7-8 | Captain's logs clearly show human voice and decision-making. Security findings human-triaged with rationale. Deploy approval gates in place. Five Questions Pattern used consistently. Architecture decisions include human rationale and rejected alternatives. |
| 9-10 | Exemplary human-AI partnership. Logs show clear division of labor. Human overrides documented with rationale. AI suggestions rejected when appropriate. Human owns scope, priorities, and final approval. Evidence of the human teaching the AI through context file improvements. Five Questions Pattern is second nature. Trust-adaptive gates implemented — ceremony scales with track record while risk tiers enforce full review on critical work. The Learning Paradox embraced: human invests in training the system, not reviewing every output. |

**Key artifacts:** Captain's logs with human voice, security finding dispositions, deploy approval records, Five Questions logs, architecture decision rationale

---

## Scoring Rubric

### Per-Dimension Scale

| Score Range | Label | Description |
|-------------|-------|-------------|
| 0-2 | **Not Started** | Dimension is absent or negligible. No evidence of intentional practice. |
| 3-4 | **Minimal** | Some activities exist but are inconsistent, informal, or incomplete. |
| 5-6 | **Developing** | Core practices are in place. Key artifacts exist. Gaps remain in coverage or consistency. |
| 7-8 | **Mature** | Practices are thorough and consistent. Artifacts are complete and maintained. Evidence of continuous improvement. |
| 9-10 | **Exemplary** | Best-in-class execution. Practices are proactive, measurable, and continuously improving. Could serve as a reference implementation. |

### Overall Score

Calculate the overall score as the unweighted average of all nine dimensions:

```
Overall Score = (D1 + D2 + D3 + D4 + D5 + D6 + D7 + D8 + D9) / 9
```

### Maturity Rating

| Overall Score | Rating | Letter | Description |
|---------------|--------|--------|-------------|
| 0.0 - 2.0 | **Foundational** | F | The project lacks essential AI-DLC structure. Start with Phase 0 and build up. |
| 2.1 - 4.0 | **Developing** | D | Core framework elements are in place but significant gaps remain. Focus on the lowest-scoring dimensions. |
| 4.1 - 6.0 | **Operational** | C | The project follows AI-DLC practices consistently. Address remaining gaps to reach maturity. |
| 6.1 - 8.0 | **Optimized** | B | The project demonstrates mature, thorough AI-DLC adoption. Continuous improvement is active. |
| 8.1 - 10.0 | **Exemplary** | A | The project is a reference implementation of AI-DLC. All dimensions are strong and measurable. |

---

## The 14 Foundational Documents

These 14 documents are the artifacts that demonstrate AI-DLC adoption. Each contributes to one or more assessment dimensions.

| # | Document | Dimensions | Created In |
|---|----------|-----------|------------|
| 1 | CLAUDE-CONTEXT.md (CLAUDE.md) | D1 Foundation, D8 Evolution | Phase 0, updated continuously |
| 2 | PM-FRAMEWORK.md | D1 Foundation, D4 Construction | Phase 0 |
| 3 | REQUIREMENTS.md | D2 Requirements | Phase 1 |
| 4 | SECURITY.md | D2 Requirements, D5 Security | Phase 1 |
| 5 | USER-STORIES.md | D3 Specification | Phase 2 |
| 6 | TRACEABILITY-MATRIX.md | D3 Specification, D4 Construction | Phase 2, updated through Phase 5 |
| 7 | CICD-DEPLOYMENT-PROPOSAL.md | D6 Ops Readiness | Phase 2 |
| 8 | INFRASTRUCTURE-PLAYBOOK.md | D6 Ops Readiness | Phase 2 |
| 9 | COST-MANAGEMENT-GUIDE.md | D7 Cost Management | Phase 2 |
| 10 | SOLO-AI-WORKFLOW-GUIDE.md | D4 Construction | Phase 3 |
| 11 | MULTI-DEVELOPER-GUIDE.md | D4 Construction | Phase 3 |
| 12 | SECURITY-REVIEW-PROTOCOL.md | D5 Security | Phase 4 |
| 13 | OPS-READINESS-CHECKLIST.md | D6 Ops Readiness | Phase 4 |
| 14 | AI-DLC-CASE-STUDY.md | D8 Evolution | Phase 6 |

### Document Presence Scoring Quick Check

Use this quick check to establish a baseline: count how many of the 14 documents exist and are populated (not just stub files).

| Documents Present | Quick Rating |
|-------------------|-------------|
| 0-3 | Foundational — significant framework gaps |
| 4-7 | Developing — core structure exists |
| 8-11 | Operational — most framework artifacts in place |
| 12-14 | Optimized/Exemplary — comprehensive adoption |

---

## How to Run a Self-Audit

### Step 1: Gather Evidence

Collect all project artifacts. Check each of the 14 foundational documents for presence and completeness.

### Step 2: Score Each Dimension

For each of the nine dimensions, read the scoring rubric and assign a score based on the evidence. Be honest — inflated scores hide real gaps.

Use this scoring worksheet:

```markdown
## DLC Audit — [Project Name] — [Date]

| # | Dimension | Score | Grade | Evidence | Gaps |
|---|-----------|-------|-------|----------|------|
| 1 | Foundation & Context | /10 | | | |
| 2 | Requirements & Architecture | /10 | | | |
| 3 | Specification & Elaboration | /10 | | | |
| 4 | Construction Process | /10 | | | |
| 5 | Security Posture | /10 | | | |
| 6 | Operational Readiness | /10 | | | |
| 7 | Cost Management | /10 | | | |
| 8 | Evolution & Learning | /10 | | | |
| 9 | Human-AI Collaboration | /10 | | | |

**Overall Score:** ___ / 10
**Maturity Rating:** ___
**Letter Grade:** ___

### Top 3 Gaps
1.
2.
3.

### Action Items
1.
2.
3.
```

### Step 3: Identify the Lowest-Scoring Dimensions

Focus improvement on the two or three dimensions with the lowest scores. A project with D5 (Security) at 3 and D7 (Cost) at 2 should prioritize security controls and cost management before optimizing D4 (Construction) from 7 to 8.

### Step 4: Create an Improvement Plan

For each low-scoring dimension, identify specific activities:

| Dimension | Current Score | Target Score | Actions | Timeline |
|-----------|-------------|-------------|---------|----------|
| D5 Security | 3 | 6 | Run five-persona review, set up finding tracking, complete OWASP checklist | 2 weeks |
| D7 Cost | 2 | 5 | Document cost baseline, configure budget alarms, create cost dashboard | 1 week |

### Step 5: Re-Audit

Schedule a re-audit after completing the improvement actions. Recommended cadence:

- **During active development:** Audit at every phase transition
- **Post-deployment:** Audit quarterly as part of Phase 6 Evolution
- **Annual:** Full audit with team review and stakeholder report

---

## Cross-References

- [Phase 0: Foundation](../framework/PHASE-0-FOUNDATION.md) — Dimension 1 activities
- [Phase 1: Inception](../framework/PHASE-1-INCEPTION.md) — Dimension 2 activities
- [Phase 2: Elaboration](../framework/PHASE-2-ELABORATION.md) — Dimension 3 activities
- [Phase 3: Construction](../framework/PHASE-3-CONSTRUCTION.md) — Dimension 4 activities
- [Phase 4: Hardening](../framework/PHASE-4-HARDENING.md) — Dimensions 5-6 activities
- [Phase 5: Operations](../framework/PHASE-5-OPERATIONS.md) — Dimension 6 activities
- [Phase 6: Evolution](../framework/PHASE-6-EVOLUTION.md) — Dimension 8 activities
- [Security Pillar](../pillars/PILLAR-SECURITY.md) — Dimension 5 pillar guide
- [Quality Pillar](../pillars/PILLAR-QUALITY.md) — Dimensions 4, 6 pillar guide
- [Traceability Pillar](../pillars/PILLAR-TRACEABILITY.md) — Dimensions 3, 4 pillar guide
- [Cost Awareness Pillar](../pillars/PILLAR-COST.md) — Dimension 7 pillar guide
- [Solo+AI Governance](../governance/SOLO-AI.md) — Dimension 9 practices
- [Five-Persona Review](FIVE-PERSONA-REVIEW.md) — Dimension 5 methodology
- [Bolt Metrics Guide](BOLT-METRICS-GUIDE.md) — Dimension 4 metrics
- [Glossary](GLOSSARY.md) — Key terms
- [Autonomous Execution Guide](AUTONOMOUS-EXECUTION-GUIDE.md) — Execution model and trust-adaptive gates
