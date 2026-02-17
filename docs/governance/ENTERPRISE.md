# Enterprise Governance Model (5+ Developers, Multiple Teams)

## Overview

The Enterprise model scales AI-DLC to organizations with multiple teams, compliance requirements, and cross-team dependencies. It adds formal governance structures, audit trails, and role-based review processes while preserving the core AI-DLC principles: persistent context, bolt-based execution, and structured human-AI collaboration.

This model trades velocity for control. Every added process exists to satisfy a specific need — regulatory compliance, cross-team coordination, or risk management. Do not adopt enterprise governance for a project that does not require it. The overhead is justified only when the consequences of failure (security breaches, compliance violations, customer impact) demand formal controls.

**Choose this model when:**

- 5+ developers work on the project, potentially across multiple teams
- Regulatory or compliance requirements mandate formal review and audit trails (SOC 2, HIPAA, GDPR, PCI-DSS)
- Cross-team dependencies require structured coordination
- The organization requires role-based access control and approval workflows

**Downgrade to [Small Team](SMALL-TEAM.md) when:**

- The team shrinks below 5 developers with no compliance requirements
- Process overhead measurably slows delivery without providing proportional risk reduction

---

## Formal Context Directory

At enterprise scale, a single CLAUDE.md file cannot hold all context. Split context into a structured directory owned by the tech lead and updated via pull request.

### Directory Structure

    docs/context/
      architecture.md       # System architecture, component relationships, data flows
      security.md           # Security policies, threat model, compliance requirements
      conventions.md        # Coding standards, naming patterns, error handling
      infrastructure.md     # Cloud architecture, deployment topology, networking
      api-contracts.md      # API specifications, versioning policy, breaking change rules
      data-model.md         # Database schema, data ownership, retention policies
      team-structure.md     # Team responsibilities, on-call rotations, escalation paths

The project root still contains a CLAUDE.md, but it serves as an index:

    # Project Name — Context Index

    ## Project Identity
    - Name, version, purpose (3 sentences max)

    ## Context Documents
    - [Architecture](docs/context/architecture.md)
    - [Security](docs/context/security.md)
    - [Conventions](docs/context/conventions.md)
    - [Infrastructure](docs/context/infrastructure.md)
    - [API Contracts](docs/context/api-contracts.md)
    - [Data Model](docs/context/data-model.md)
    - [Team Structure](docs/context/team-structure.md)

    ## Current State
    - Active initiatives and their status
    - Known issues and tech debt

### Ownership and Updates

| Context Document | Owner | Update Process | Review Required By |
|---|---|---|---|
| architecture.md | Tech Lead | PR with architecture review | Tech leads from affected teams |
| security.md | Security Champion | PR with security review | Security team |
| conventions.md | Tech Lead | PR with one approval | Any senior developer |
| infrastructure.md | Platform/DevOps Lead | PR with infra review | Platform team |
| api-contracts.md | API Owner | PR with consumer review | Teams that consume the API |
| data-model.md | Data Lead | PR with data review | Data team + security |
| team-structure.md | Engineering Manager | Direct update | No PR required (informational) |

### AI Session Context Loading

When an AI session begins in an enterprise project, load context selectively:

1. Always load CLAUDE.md (the index)
2. Load the context document(s) relevant to the current task
3. Load the team's current captain's logs
4. Do NOT load all context documents — this wastes tokens and dilutes signal

---

## Architecture Decision Log

Enterprise projects require a formal Architecture Decision Record (ADR) process. ADRs capture the context, decision, and consequences of significant technical choices.

### ADR Format

    # ADR-{NNN}: {Title}

    **Status:** Proposed | Accepted | Deprecated | Superseded by ADR-{NNN}
    **Date:** YYYY-MM-DD
    **Author:** {name}
    **Reviewers:** {names}

    ## Context
    Describe the situation and the forces at play. What problem are we
    solving? What constraints exist? What options did we consider?

    ## Decision
    State the decision clearly. Use active voice: "We will use PostgreSQL
    for the primary data store."

    ## Consequences

    ### Positive
    - Benefits of this decision

    ### Negative
    - Trade-offs and risks accepted

    ### Neutral
    - Side effects that are neither clearly positive nor negative

    ## Alternatives Considered
    | Alternative | Why Rejected |
    |---|---|
    | Alternative A | Reason |
    | Alternative B | Reason |

### ADR Process

1. **Propose:** Any developer writes an ADR in `Proposed` status and opens a PR
2. **Review:** The ADR review board (tech leads from each team) reviews within 3 business days
3. **Discuss:** Comments and revisions happen in the PR
4. **Accept or Reject:** The review board reaches consensus. The ADR moves to `Accepted` or the PR is closed with an explanation
5. **Implement:** The accepted decision is implemented in subsequent bolts
6. **Supersede:** When a decision is revisited, write a new ADR that references the old one. Mark the old ADR as `Superseded by ADR-{NNN}`

### ADR Review Board

The review board consists of:

- Tech lead from each team affected by the decision
- Security champion (for security-relevant decisions)
- Platform/DevOps lead (for infrastructure decisions)
- Data lead (for data model decisions)

Not every ADR needs the full board. The proposing developer tags relevant reviewers based on the decision's scope.

### ADR Numbering

Use sequential numbering: ADR-001, ADR-002, ADR-003. Store ADRs in:

    docs/architecture/
      ADR-001-database-selection.md
      ADR-002-authentication-strategy.md
      ADR-003-api-versioning.md
      ...

### When to Write an ADR

| Change Type | ADR Required? |
|---|---|
| New technology or framework adoption | Yes |
| Database schema design or migration strategy | Yes |
| API versioning or breaking change policy | Yes |
| Security architecture change | Yes |
| Coding convention change | No — update conventions.md via PR |
| Bug fix | No |
| Feature implementation within existing architecture | No |
| Infrastructure topology change | Yes |

---

## Multi-Team Traceability

When multiple teams contribute to a system, traceability becomes critical. Track requirements, implementations, tests, and ownership across team boundaries.

### Cross-Team Traceability Matrix

Extend the standard traceability matrix with team ownership columns:

| Requirement ID | Description | Owning Team | Implementing Team | Test Owner | Status | Bolt IDs |
|---|---|---|---|---|---|---|
| REQ-001 | User authentication | Platform | Platform | Platform | Complete | B-012, B-013 |
| REQ-002 | Payment processing | Payments | Payments | Payments + QA | In Progress | B-045 |
| REQ-003 | Audit logging | Compliance | Platform | Compliance | Planned | — |
| REQ-004 | Search API | Search | Search + Platform | Search | In Progress | B-031, B-032 |

### Cross-Team Dependency Tracking

Maintain a dependency tracker for work that spans teams:

| Dependency ID | Requesting Team | Providing Team | Description | Status | Due Date | Blocker? |
|---|---|---|---|---|---|---|
| DEP-001 | Payments | Platform | OAuth token exchange endpoint | Complete | 2026-01-15 | No |
| DEP-002 | Search | Data | Real-time index update pipeline | In Progress | 2026-02-01 | Yes |
| DEP-003 | Frontend | Platform | Rate limiting headers in API responses | Planned | 2026-02-15 | No |

**Rules for cross-team dependencies:**

1. The requesting team files the dependency with a clear description and desired date
2. The providing team acknowledges within 2 business days with a commitment or counter-proposal
3. Blocked dependencies escalate to engineering management after 5 business days without resolution
4. Both teams update status weekly

### Integration Test Ownership

Integration tests that cross team boundaries require clear ownership:

| Integration Point | Test Owner | Contributing Teams | Run Frequency |
|---|---|---|---|
| Auth + Payments | Platform | Platform, Payments | Every deploy |
| Search + Data Pipeline | Search | Search, Data | Nightly |
| API Gateway + All Services | Platform | All teams | Every deploy to staging |

> See [Traceability Pillar](../pillars/PILLAR-TRACEABILITY.md) for the full cross-phase traceability checklist.

---

## Compliance and Regulatory Gates

Enterprise projects often operate under regulatory frameworks. AI-DLC integrates compliance evidence collection into each phase rather than bolting it on at the end.

### Supported Frameworks

| Framework | Primary Concern | AI-DLC Integration Point |
|---|---|---|
| SOC 2 | Security, availability, confidentiality | Security pillar, access controls, audit logs |
| HIPAA | Protected health information | Data model context, encryption, access logs |
| GDPR | Personal data protection | Data model context, consent tracking, data deletion |
| PCI-DSS | Payment card data | Security pillar, network segmentation, encryption |

### Compliance Evidence Collection by Phase

| Phase | Evidence Collected | Storage |
|---|---|---|
| Phase 0: Foundation | Governance model selection, access control setup | CLAUDE.md, ADR |
| Phase 1: Inception | Requirements with compliance tags (e.g., REQ-HIPAA-001) | Requirements document |
| Phase 2: Elaboration | Architecture decisions addressing compliance requirements | ADRs, security context doc |
| Phase 3: Construction | Code reviews, test results, security scan results | PR history, CI artifacts |
| Phase 4: Hardening | Security review results, penetration test reports, compliance audit | Security review documents |
| Phase 5: Operations | Deploy logs, access logs, incident response records | Operations runbook, monitoring |
| Phase 6: Evolution | Retrospective findings, process improvement records | Retrospective documents |

### Compliance-Tagged Requirements

Tag requirements that have compliance implications:

    REQ-AUTH-001 [SOC2] [HIPAA]: Multi-factor authentication for all user accounts
    REQ-DATA-003 [GDPR]: User data export within 30 days of request
    REQ-PAY-001 [PCI-DSS]: Payment card numbers encrypted at rest and in transit
    REQ-LOG-002 [SOC2]: All administrative actions logged with timestamp and actor

These tags flow through to the traceability matrix, ensuring every compliance requirement has an implementation, a test, and an owner.

### Audit Trail Requirements

Maintain an immutable audit trail for:

- [ ] All code changes (git history with signed commits)
- [ ] All deployment events (who, when, what version)
- [ ] All access grants and revocations (IAM change log)
- [ ] All security review outcomes (approved, findings, remediation)
- [ ] All ADR decisions (PR history with reviewers and approvals)
- [ ] All incident responses (timeline, actions, resolution)

> See [Security Pillar](../pillars/PILLAR-SECURITY.md) for the complete cross-phase security checklist.

---

## Role-Based Security Review

Enterprise projects require layered security review with clear roles and escalation paths.

### Security Champion Model

Each team designates a **Security Champion** — a developer with security training who serves as the first line of defense.

**Security Champion responsibilities:**

- Review all PRs in their team for security concerns
- Escalate security-critical changes to the centralized security review process
- Attend monthly security champion sync meetings
- Stay current on OWASP Top 10 and relevant threat vectors
- Maintain the team's section of the security context document

### Centralized Security Review

Changes to security-critical components require centralized review:

| Component | Review Required By | SLA |
|---|---|---|
| Authentication and authorization | Security team + security champion | 3 business days |
| Cryptography and key management | Security team | 3 business days |
| Payment processing | Security team + compliance | 5 business days |
| Data handling (PII, PHI) | Security team + data lead | 3 business days |
| Infrastructure access controls | Security team + platform lead | 3 business days |
| Third-party integrations | Security team + security champion | 5 business days |

### Security Review Process

1. Developer opens PR for a security-critical change
2. AI conducts 5-persona security review (see [Solo + AI](SOLO-AI.md) for the pattern)
3. Security champion reviews the PR and AI findings
4. If the change affects a centralized review component, the security champion escalates
5. Centralized security review is conducted within the SLA
6. Findings are documented in the PR and in the security context document
7. The PR is approved only after all security findings are addressed or explicitly accepted with risk documentation

### Quarterly Security Activities

| Activity | Frequency | Owner | Participants |
|---|---|---|---|
| Penetration testing | Quarterly | Security team | External vendor or internal red team |
| Dependency vulnerability scan | Weekly (automated) | CI pipeline | All teams (review findings) |
| Access control audit | Quarterly | Security team | Engineering managers |
| Security champion training | Quarterly | Security team | All security champions |
| Threat model review | Bi-annually | Security team | Tech leads |

### Bug Bounty Program Considerations

For production-facing enterprise systems, consider a bug bounty program:

- **Scope:** Define which systems are in scope (public APIs, web applications)
- **Rewards:** Set reward tiers based on severity (Critical, High, Medium, Low)
- **Process:** Triage reports within 48 hours, fix critical issues within 7 days
- **Integration:** Feed bug bounty findings into the security context document and the ADR process if architectural changes are needed

---

## Centralized Cost Management

Enterprise cost management requires visibility, accountability, and controls across all teams.

### FinOps Ownership

Designate a FinOps owner (individual or team) responsible for:

- Aggregate cost visibility across all teams and environments
- Budget setting and tracking per team and per project
- Cost anomaly detection and alerting
- Optimization recommendations (right-sizing, reserved instances, spot usage)
- Quarterly cost review with engineering leadership

### Per-Team Cost Allocation via Tagging

Enforce resource tagging across all cloud providers:

| Tag Key | Required | Example Values | Purpose |
|---|---|---|---|
| `team` | Yes | `platform`, `payments`, `search` | Cost allocation by team |
| `project` | Yes | `main-app`, `data-pipeline`, `admin-tool` | Cost allocation by project |
| `environment` | Yes | `production`, `staging`, `development` | Cost allocation by environment |
| `owner` | Yes | `alice`, `bob` | Individual accountability for dev resources |
| `cost-center` | If applicable | `engineering`, `data-science` | Finance department allocation |
| `temporary` | If applicable | `true` (with expiry date) | Flag resources for cleanup |

### Chargeback and Showback Models

| Model | Description | When to Use |
|---|---|---|
| **Showback** | Show each team their costs; no actual billing | Early stage — building cost awareness |
| **Chargeback** | Bill each team for their actual resource usage | Mature FinOps — teams have cost budgets |
| **Hybrid** | Shared infrastructure costs split equally; team-specific costs charged back | Most enterprise teams start here |

### Cost Controls

| Control | Scope | Implementation |
|---|---|---|
| Budget alerts | Per team, per project | Cloud provider budget alarms at 50%, 75%, 90%, 100% |
| Spend approval | Above threshold | Changes exceeding $X/month require manager approval |
| Auto-shutdown | Development environments | Shut down dev/staging resources outside business hours |
| Centralized kill switch | Organization-wide | Ability to halt all non-production spend immediately |
| Team-level overrides | Per team | Teams can override auto-shutdown for specific resources with justification |
| Resource lifecycle | All environments | Tag temporary resources with expiry dates; auto-delete after expiry |

### Monthly Cost Review

Hold a monthly cost review (30 minutes) with team leads:

1. Review total spend vs. budget (5 minutes)
2. Per-team cost breakdown and trends (10 minutes)
3. Top 5 cost drivers and optimization opportunities (10 minutes)
4. Action items and budget adjustments (5 minutes)

> See [Cost Awareness Pillar](../pillars/PILLAR-COST.md) for the full cross-phase cost checklist.

---

## Scaling AI-DLC Practices

Enterprise adoption of AI-DLC requires standardization across teams without stifling team autonomy.

### Inner-Source Model for AI Context

Share AI context across teams using an inner-source model:

- **Shared conventions repository:** A central repository containing organization-wide coding standards, security policies, and AI prompt patterns. Teams fork or reference this repo.
- **Context template library:** Standardized templates for CLAUDE.md, captain's logs, and ADRs that all teams use as a starting point.
- **Cross-team context sharing:** When Team A builds a library that Team B consumes, Team A publishes a context document describing the library's API, conventions, and known issues. Team B includes this in their AI sessions when working with the library.

### Standardized Bolt Metrics

Track bolt metrics consistently across teams for visibility and planning:

| Metric | Definition | Target |
|---|---|---|
| Bolt cycle time | Time from bolt start to merge | < 4 hours (S/M), < 8 hours (L) |
| Bolt completion rate | Bolts completed vs. planned per week | > 80% |
| Review turnaround | Time from PR opened to review completed | < 4 hours |
| Defect escape rate | Defects found in production per bolt | < 5% |
| Test coverage per bolt | Lines covered by tests in the bolt's changes | > 80% |
| Security findings per bolt | Security issues found during review | Trending downward |

### Cross-Team Retrospectives

Hold quarterly cross-team retrospectives to share learnings:

1. Each team presents their top 3 process improvements from the quarter
2. Teams share AI-DLC patterns that worked well (and patterns that did not)
3. Identify cross-team friction points and assign owners for resolution
4. Update organization-wide conventions based on shared learnings
5. Celebrate wins — bolts shipped, defects prevented, velocity improvements

### AI-DLC Maturity Model for Enterprise

| Level | Description | Indicators |
|---|---|---|
| **Level 1: Ad Hoc** | Teams use AI assistants without consistent process | No context files, no captain's logs, inconsistent quality |
| **Level 2: Established** | Teams follow AI-DLC basics (context files, bolts, logs) | CLAUDE.md exists, captain's logs written, bolt cadence consistent |
| **Level 3: Measured** | Teams track bolt metrics and conduct retrospectives | Metrics dashboards, quarterly retros, continuous improvement |
| **Level 4: Optimized** | Cross-team sharing, standardized practices, compliance integrated | Inner-source context, automated compliance evidence, organization-wide metrics |

---

## Enterprise Workflow Pipeline

The enterprise pipeline extends the Small Team structured workflow with formal gates and compliance checkpoints.

### The Pipeline

    IDEA --> PRD --> SPEC --> ADR --> INTENTS --> Implementation --> Review --> Security Gate --> Deploy

| Stage | Description | Owner | Reviewers | Compliance |
|---|---|---|---|---|
| IDEA | Feature proposal | Any developer | Team lead | None |
| PRD | Requirements with compliance tags | Product + Dev | Cross-team stakeholders | Tag compliance reqs |
| SPEC | Technical specification | Dev team | Tech leads, security champion | Review against compliance |
| ADR | Architecture decisions | Tech lead | ADR review board | Record for audit |
| INTENTS | Bolt plan with acceptance criteria | Dev team | Team lead | None |
| Implementation | Code, tests, documentation | Dev + AI | PR reviewer | Automated scans |
| Review | Human + AI review | PR reviewer | Security champion (if needed) | Review evidence collected |
| Security Gate | Formal security approval | Security team | Compliance officer (if needed) | Sign-off documented |
| Deploy | Production release | Deploy owner | Team notification | Deploy log recorded |

### Gate Definitions

**Gate: PRD Approval**
- All compliance-tagged requirements reviewed by compliance officer
- Cross-team dependencies identified and acknowledged
- Budget impact assessed

**Gate: SPEC Approval**
- Architecture aligns with existing ADRs or new ADR proposed
- Security champion has reviewed for security implications
- Infrastructure requirements identified and resourced

**Gate: Security Approval**
- All security review findings addressed or risk-accepted
- Penetration testing completed (for major releases)
- Compliance evidence collected and filed

**Gate: Deploy Approval**
- All tests passing (unit, integration, e2e)
- Security gate passed
- Rollback procedure documented and tested
- Monitoring and alerting configured for the new feature
- Team notified of deploy window

---

## Team Structure and Roles

### RACI Matrix for Enterprise AI-DLC

| Activity | Tech Lead | Developer | Security Champion | FinOps Owner | Engineering Manager |
|---|---|---|---|---|---|
| Context file maintenance | Accountable | Responsible | Consulted | — | Informed |
| Architecture decisions (ADR) | Accountable | Responsible | Consulted | — | Informed |
| Implementation (bolts) | Informed | Responsible | — | — | — |
| Security review | Consulted | Responsible | Accountable | — | Informed |
| Cost management | Informed | — | — | Accountable | Consulted |
| Compliance evidence | Consulted | Responsible | Accountable | — | Informed |
| Deploy approval | Accountable | Responsible | Consulted | — | Informed |
| Incident response | Accountable | Responsible | Consulted | — | Informed |

**Legend:** R = Responsible (does the work), A = Accountable (approves/owns), C = Consulted (input required), I = Informed (kept in the loop)

### Team-Level Captain's Logs

At enterprise scale, captain's logs serve two audiences:

1. **Individual logs** — Same as [Small Team](SMALL-TEAM.md) namespaced logs. Written by developers for developers.
2. **Team-level weekly summaries** — Written by the tech lead or a rotating author. Summarize the team's progress, decisions, and blockers for cross-team visibility.

Team-level summaries go in:

    docs/decisions/
      captain-logs/
        team-platform/
          2026-W03-summary.md
          2026-W04-summary.md
        team-payments/
          2026-W03-summary.md
        individual/
          alice/
            2026-01-15-bolt-B012.md
          bob/
            2026-01-15-bolt-B010.md

---

## Phase-Specific Guidance for Enterprise

### Phase 0: Foundation

- Tech lead bootstraps with one developer (solo+AI for initial setup)
- Full team reviews the foundation, including compliance requirements
- Formal context directory structure established from day one
- See [Phase 0: Foundation](../framework/PHASE-0-FOUNDATION.md)

### Phase 1: Inception

- Requirements tagged with compliance framework identifiers
- Cross-team dependency analysis conducted
- Budget and resource planning included in requirements
- See [Phase 1: Inception](../framework/PHASE-1-INCEPTION.md)

### Phase 2: Elaboration

- ADR process required for all architecture decisions
- Security champion reviews all specifications
- Traceability matrix includes team ownership columns
- See [Phase 2: Elaboration](../framework/PHASE-2-ELABORATION.md)

### Phase 3: Construction

- PR workflow with mandatory security champion review for critical changes
- Cross-team integration points tested continuously
- Bolt metrics tracked for velocity and quality
- See [Phase 3: Construction](../framework/PHASE-3-CONSTRUCTION.md)

### Phase 4: Hardening

- Formal security gate with sign-off
- Penetration testing conducted by external vendor or internal red team
- Compliance evidence audit before production release
- See [Phase 4: Hardening](../framework/PHASE-4-HARDENING.md)

### Phase 5: Operations

- On-call rotation across teams for shared infrastructure
- Incident response runbooks with escalation paths
- Deploy coordination across dependent teams
- See [Phase 5: Operations](../framework/PHASE-5-OPERATIONS.md)

### Phase 6: Evolution

- Cross-team retrospectives quarterly
- AI-DLC maturity assessment annually
- Process improvements standardized across teams
- See [Phase 6: Evolution](../framework/PHASE-6-EVOLUTION.md)

---

## Quick Reference

### Enterprise Decision Framework

    Architecture decision? ---------> ADR process with review board
    Security-critical change? ------> Centralized security review
    Cross-team dependency? ---------> Dependency tracker + team sync
    Compliance-relevant change? ----> Tag requirement, collect evidence
    Cost exceeds threshold? --------> Manager approval required
    Routine implementation? --------> Standard PR workflow with team review

### Files the Organization Maintains

| File | Update Frequency | Owner |
|---|---|---|
| CLAUDE.md (index) | When context docs change | Tech Lead |
| docs/context/*.md | Per relevant decision | Designated owners (see table above) |
| ADR-*.md | Per architecture decision | Proposing developer, approved by review board |
| Traceability matrix | Per feature completion | Assigned team |
| Captain's logs (individual) | Per bolt | Individual developer |
| Captain's logs (team summary) | Weekly | Tech Lead or rotating author |
| Cost reports | Monthly | FinOps Owner |

### Pillars Checklist for Enterprise

- [ ] **Security:** Security champion per team, centralized review for critical changes, quarterly pen testing — see [Security Pillar](../pillars/PILLAR-SECURITY.md)
- [ ] **Quality:** Standardized bolt metrics, cross-team integration tests, mandatory PR reviews — see [Quality Pillar](../pillars/PILLAR-QUALITY.md)
- [ ] **Traceability:** Formal ADRs, compliance-tagged requirements, cross-team dependency tracking — see [Traceability Pillar](../pillars/PILLAR-TRACEABILITY.md)
- [ ] **Cost:** FinOps ownership, resource tagging enforced, monthly cost reviews — see [Cost Awareness Pillar](../pillars/PILLAR-COST.md)

---

## Related Documents

- [Phase 0: Foundation](../framework/PHASE-0-FOUNDATION.md) — Where governance model selection happens
- [Solo + AI Governance](SOLO-AI.md) — For single-developer projects
- [Small Team Governance](SMALL-TEAM.md) — For 2-5 developer teams
- [Security Pillar](../pillars/PILLAR-SECURITY.md) — Cross-phase security checklist
- [Quality Pillar](../pillars/PILLAR-QUALITY.md) — Cross-phase quality checklist
- [Traceability Pillar](../pillars/PILLAR-TRACEABILITY.md) — Cross-phase traceability checklist
- [Cost Awareness Pillar](../pillars/PILLAR-COST.md) — Cross-phase cost checklist
