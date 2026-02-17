# Phase 6: Evolution — Learn and Improve

> **The only phase that loops.** Evolution feeds back into every other phase, continuously refining the software, the process, and the AI-assisted development practice itself.

---

## Purpose

Phase 6 transforms production experience into institutional knowledge. Capture what the system teaches you in production, extract patterns from successes and failures, update context files so the AI never repeats a mistake, and detect drift before it becomes an incident. This phase runs indefinitely — it begins after the first deployment and never formally ends.

---

## Entry Criteria

- [ ] Phase 5 (Operations) exit criteria met — system is live and observable
- [ ] Monitoring, alerting, and logging are active and producing data
- [ ] At least one production deployment has completed successfully
- [ ] Runbooks and incident response procedures are in place
- [ ] Team has access to production metrics dashboards
- [ ] [Traceability matrix](../../templates/TRACEABILITY-MATRIX.md) is current through deployment

---

## Activities

### 1. Five-Phase Learning System

Adopt the five-phase learning loop to convert raw production signals into lasting improvements. Run this loop continuously — not as a one-time event.

```
┌────────────────────────────────────────────────────────────┐
│                  FIVE-PHASE LEARNING LOOP                   │
│                                                            │
│   ┌──────────┐    ┌──────────┐    ┌──────────┐            │
│   │ PASSIVE  │───▶│ PATTERN  │───▶│PREFERENCE│            │
│   │ FEEDBACK │    │EXTRACTION│    │ LEARNING │            │
│   └──────────┘    └──────────┘    └──────────┘            │
│        ▲                               │                   │
│        │          ┌──────────┐    ┌──────────┐            │
│        └──────────│  AGENT   │◀───│ CONTEXT  │            │
│                   │DISCOVERY │    │INJECTION │            │
│                   └──────────┘    └──────────┘            │
└────────────────────────────────────────────────────────────┘
```

#### Phase L1: Passive Feedback

Collect outcomes, errors, and behavioral patterns from production without changing the system. Let the data accumulate before acting.

**What to capture:**

| Signal | Source | Storage |
|--------|--------|---------|
| Error rates and types | Application logs, error tracking (Sentry, Datadog) | Time-series database |
| Latency percentiles | APM tooling | Metrics dashboard |
| User behavior patterns | Analytics, session recordings | Analytics platform |
| Cost actuals vs. budget | Cloud billing APIs | [Cost Management Guide](../../templates/COST-MANAGEMENT-GUIDE.md) |
| Deployment outcomes | CI/CD pipeline logs | Captain's log |
| Support ticket themes | Help desk, issue tracker | Categorized backlog |
| AI generation accuracy | Code review results, post-bolt retros | Bolt metrics log |

**Passive feedback checklist:**

- [ ] Configure structured logging with consistent field names
- [ ] Set up weekly automated reports for error trends
- [ ] Track mean time to detection (MTTD) and mean time to resolution (MTTR)
- [ ] Capture bolt retro outcomes in a queryable format
- [ ] Record AI prompt patterns that produced good vs. poor results

#### Phase L2: Pattern Extraction

Analyze accumulated feedback to identify recurring issues, successful approaches, and common mistakes. Run pattern extraction at least monthly; weekly during rapid development periods.

**Extraction techniques:**

1. **Error clustering** — Group errors by root cause, not by symptom. Five "timeout" errors might share one database contention root cause.
2. **Success path analysis** — Identify which bolts shipped cleanly on the first attempt. What did they have in common? (Clear specs? Small scope? Familiar domain?)
3. **Anti-pattern cataloging** — Document recurring mistakes. Example: "Every time we add a new API endpoint without updating the rate limiter config, we get a P1 within two weeks."
4. **Cost anomaly correlation** — Link cost spikes to specific deployments or features.
5. **Security finding trends** — Track findings by category across quarterly reviews. Categories that persist indicate systemic gaps, not one-off oversights.

**Pattern extraction template:**

```markdown
## Pattern: [Name]
- **Type:** Success pattern | Anti-pattern | Cost pattern | Security pattern
- **Frequency:** [How often observed]
- **Impact:** [Severity when it occurs]
- **Root cause:** [Why this keeps happening]
- **Evidence:** [Links to specific incidents, bolts, or findings]
- **Recommended action:** [What to change]
- **Phase affected:** [Which AI-DLC phase should incorporate this learning]
```

#### Phase L3: Preference Learning

Understand and codify team and developer preferences for code style, architecture decisions, tooling choices, and communication patterns. These preferences shape how the AI generates code and suggestions.

**Preference categories:**

| Category | Examples | Where to codify |
|----------|----------|-----------------|
| Code style | Naming conventions, error handling patterns, import ordering | CLAUDE.md `## Conventions` section |
| Architecture | Preferred patterns (repository pattern, CQRS), forbidden patterns | CLAUDE.md `## Architecture` section |
| Tooling | Preferred libraries, test frameworks, deployment tools | CLAUDE.md `## Tech Stack` section |
| Communication | Commit message format, PR description style, documentation depth | CLAUDE.md `## Writing Style` section |
| Review | What the team considers "review ready," acceptable test coverage | CLAUDE.md `## Quality Standards` section |

**Preference capture process:**

1. After each bolt retro, note any "I wish the AI had..." or "The AI should have known..." statements.
2. During code review, flag any corrections that represent team preferences (not bugs).
3. Quarterly, review merged PRs for patterns in human-applied changes to AI-generated code.
4. Synthesize into concrete rules: not "write clean code" but "use early returns instead of nested if/else blocks."

#### Phase L4: Context Injection

Update CLAUDE.md and supporting context files with extracted patterns and learned preferences. This is the mechanism that prevents repeated mistakes and amplifies successful approaches.

**Context injection rules:**

- Write rules as imperative statements: "Use parameterized queries for all database access" not "We prefer parameterized queries."
- Include the *why*: "Use parameterized queries for all database access — we had three SQL injection findings in the Phase 4 security audit."
- Add negative rules when anti-patterns recur: "NEVER use string concatenation to build SQL queries."
- Remove or archive rules that no longer apply (see Context File Evolution below).
- Keep the context file under 500 lines — if it grows beyond this, split into domain-specific context files.

**Example context injection:**

```markdown
## Learned Patterns (v1.2)

### Database
- Use parameterized queries for all database access — SQL injection finding SEC-012
- Always set connection pool max to 20 for Lambda; 100 for ECS — cost spike INC-045
- Index every foreign key column — performance pattern from bolt B-031 retro

### API Design
- Return 202 Accepted for async operations, never 200 — user confusion reports USR-008
- Include request-id in all error responses — MTTR reduced 40% after adding this
```

#### Phase L5: Agent Discovery

Identify new automation opportunities, workflow improvements, and areas where AI assistance could expand. This phase drives the evolution of the development process itself.

**Discovery areas:**

1. **Repetitive manual tasks** — If a human does the same thing three times, automate it. Examples: dependency update PRs, changelog generation, release notes.
2. **Quality gate automation** — Can any human review step become an automated check? Example: AI pre-review before human code review.
3. **New tool integration** — Evaluate emerging AI capabilities against current workflow gaps.
4. **Cross-project patterns** — If multiple projects share patterns, extract them into shared context files or reusable bolt templates.
5. **Monitoring intelligence** — Can anomaly detection replace threshold-based alerts?

**Agent discovery log template:**

```markdown
## Discovery: [Title]
- **Date:** YYYY-MM-DD
- **Current process:** [How it works today]
- **Proposed improvement:** [What could change]
- **Estimated effort:** S / M / L / XL
- **Expected impact:** [Time saved, errors prevented, cost reduced]
- **Decision:** Adopt / Defer / Reject
- **Owner:** [Who will implement]
```

---

### 2. Context File Evolution

CLAUDE.md is a living document. Without active maintenance, it becomes stale — and stale context is worse than no context, because it generates confidently wrong output.

#### Post-Bolt Updates

After every bolt, ask: "Did we learn anything the AI should know next time?"

- Add new conventions discovered during implementation
- Record architecture decisions that emerged (link to ADRs if applicable)
- Note any workarounds for tooling limitations
- Update dependency or API notes if versions changed

#### Quarterly Context Reviews

Schedule a 60-minute quarterly review of all context files.

**Quarterly review checklist:**

- [ ] Remove references to deprecated features or APIs
- [ ] Consolidate duplicate or overlapping rules
- [ ] Verify all cross-referenced files still exist
- [ ] Update version-specific sections for current release
- [ ] Archive patterns that are now enforced by automated checks
- [ ] Review context file size — split if over 500 lines
- [ ] Validate that AI-generated code still follows documented conventions

#### Version-Specific Sections

As the product evolves, conventions change. Maintain version-scoped sections when breaking changes occur.

```markdown
## Conventions — v2.0+
- Use the new AuthService for all authentication (replaces legacy AuthMiddleware)
- API responses use envelope format: { data, meta, errors }

## Conventions — v1.x (maintenance mode)
- AuthMiddleware is frozen; security patches only
- API responses use flat format (no envelope)
```

---

### 3. Quarterly Security Re-Review

Schedule security re-reviews every 90 days. Production systems accumulate new code, new dependencies, and new attack surfaces between reviews.

#### Re-Review Scope

| Activity | Tool/Method | Cadence |
|----------|-------------|---------|
| Five-persona security review | AI-assisted review against current codebase | Quarterly |
| Dependency vulnerability scan | `npm audit`, `pip-audit`, Snyk, Dependabot | Weekly (automated), quarterly (manual review) |
| IAM permission audit | Cloud provider IAM analyzer | Quarterly |
| Encryption and key rotation | Verify key ages, rotation schedules | Quarterly |
| Secret scanning | TruffleHog, GitLeaks, GitHub secret scanning | Continuous (automated), quarterly (manual review) |
| Penetration testing | Internal or third-party | Annually (minimum) |

#### Five-Persona Re-Review Process

Re-run the [Five-Persona Review](../reference/FIVE-PERSONA-REVIEW.md) against all code changed since the last review.

1. **Scope** — Identify all commits since the last quarterly review.
2. **Attacker persona** — Review new endpoints, input handling, and authentication changes.
3. **Auditor persona** — Verify logging, compliance controls, and data handling.
4. **Ops persona** — Check new failure modes, scaling implications, and runbook gaps.
5. **Cost persona** — Assess cost impact of new features and resource usage patterns.
6. **User persona** — Evaluate new user-facing changes for data exposure or confusion.

#### Re-Review Deliverables

- Updated security findings log with severity ratings
- Dependency vulnerability report with remediation timeline
- IAM permissions delta report (what changed, what should change)
- Key rotation status report
- Comparison to previous quarter (findings should trend downward)

> **Cloud sidebar:** AWS — use IAM Access Analyzer + Security Hub. Azure — use Defender for Cloud + Entra ID access reviews. GCP — use IAM Recommender + Security Command Center.

---

### 4. Drift Detection and Correction

Drift is the silent accumulator of technical debt. Detect it systematically across four dimensions.

#### Infrastructure Drift

The gap between infrastructure-as-code definitions and actual deployed state.

**Detection methods:**

- Run `terraform plan` or equivalent on a schedule (daily in CI, minimum weekly)
- Compare IaC state files against cloud provider APIs
- Alert on any unplanned diff

**Correction process:**

1. Classify the drift: intentional (manual hotfix) or unintentional (configuration error)
2. If intentional — update IaC to match reality, then document the reason in a captain's log
3. If unintentional — revert the actual state to match IaC
4. Add a guard to prevent recurrence (e.g., deny console-level changes via SCP/policy)

#### Configuration Drift

The gap between documented settings and deployed settings.

**Detection methods:**

- Maintain a configuration registry (environment variables, feature flags, service configs)
- Run automated comparison between the registry and deployed configs
- Flag any setting that exists in production but not in the registry

**Common culprits:**

- Environment variables added during incident response and never documented
- Feature flags left in a temporary state
- Database connection strings changed manually

#### Process Drift

The gap between documented procedures and actual team practices.

**Detection methods:**

- Quarterly team survey: "Which documented processes do you actually follow?"
- Audit recent bolts against the documented bolt workflow
- Check if captain's logs are being written (count vs. expected)
- Verify that code reviews include the five-persona checklist

**Correction approach:**

- If the team drifted to a *better* process — update the documentation
- If the team drifted to a *worse* process — retrain and add guardrails
- If the team stopped following a process entirely — question whether it was valuable

#### Dependency Drift

The gap between pinned dependency versions and latest available versions, including known vulnerabilities.

**Detection methods:**

- Automated weekly dependency update PRs (Dependabot, Renovate)
- Monthly manual review of major version updates
- Continuous vulnerability scanning against CVE databases

**Triage categories:**

| Category | Action | Timeline |
|----------|--------|----------|
| Critical CVE in direct dependency | Patch immediately | 24 hours |
| High CVE in direct dependency | Schedule patch | 1 week |
| Medium/Low CVE | Bundle with next release | Next sprint |
| Major version update (no CVE) | Evaluate breaking changes, schedule | Next quarter |
| Transitive dependency CVE | Evaluate exposure, update parent | 1-2 weeks |

---

### 5. Decommissioning Procedures

Removing features is as important as adding them. Undisciplined removal creates orphaned resources, dangling references, and security gaps.

#### When to Decommission

- Feature usage drops below a defined threshold (e.g., < 1% of users over 90 days)
- Maintenance cost exceeds the value delivered
- A replacement feature is fully adopted
- Security risk cannot be mitigated at reasonable cost
- Regulatory or compliance requirements mandate removal

#### Decommissioning Checklist

- [ ] **Announce** — Notify users with a deprecation timeline (minimum 30 days for internal, 90 days for external)
- [ ] **Measure** — Confirm usage metrics support decommissioning
- [ ] **Migrate** — Provide migration path to replacement (if applicable)
- [ ] **Remove code** — Delete feature code, tests, and configuration
- [ ] **Clean data** — Apply data retention policy; archive or purge as required
- [ ] **Remove infrastructure** — Tear down dedicated resources (queues, tables, endpoints)
- [ ] **Remove dependencies** — Uninstall libraries that were only used by this feature
- [ ] **Update context files** — Remove references from CLAUDE.md, runbooks, and documentation
- [ ] **Update traceability** — Mark requirements as "Decommissioned" in the [traceability matrix](../../templates/TRACEABILITY-MATRIX.md)
- [ ] **Close monitoring** — Remove or redirect alerts, dashboards, and health checks
- [ ] **Final review** — Run a targeted security scan to verify no orphaned resources remain

#### Data Retention and Cleanup

Follow this decision tree for data associated with decommissioned features:

```
Is the data subject to regulatory retention requirements?
├── Yes → Archive to cold storage for required retention period
│         Tag with retention expiry date and auto-delete policy
└── No  → Is the data needed for analytics or ML training?
          ├── Yes → Anonymize and archive
          └── No  → Schedule deletion with 30-day grace period
```

---

### 6. Framework Versioning and Self-Improvement

AI-DLC is itself a product that evolves. The framework uses semantic versioning and maintains backwards compatibility commitments.

#### Semantic Versioning for AI-DLC

| Version Component | When to Increment | Example |
|-------------------|-------------------|---------|
| **Major** (X.0.0) | Breaking changes to phase structure, pillar definitions, or template formats | Removing a phase, restructuring pillars |
| **Minor** (1.X.0) | New phases, templates, governance models, or significant process additions | Adding a new template, new governance model |
| **Patch** (1.0.X) | Corrections, clarifications, typo fixes, improved examples | Fixing cross-references, adding examples |

#### Backwards Compatibility

- **Major versions** may break compatibility. Provide a migration guide for each major release.
- **Minor versions** add capabilities without changing existing guidance. Projects on the same major version can adopt minor updates without rework.
- **Patch versions** are always safe to adopt immediately.

#### Framework Self-Improvement Process

1. **Collect feedback** — After each project completes a full AI-DLC cycle, capture what worked and what didn't in an [AI-DLC Case Study](../../templates/AI-DLC-CASE-STUDY.md).
2. **Identify gaps** — Review case studies quarterly. Where did teams struggle? What was missing?
3. **Propose changes** — Submit framework change proposals with rationale and impact assessment.
4. **Review and approve** — Framework changes require review against all existing phases and pillars for consistency.
5. **Release** — Publish the new version with changelog and migration notes.

#### Community Contribution Model

- **Bug fixes and clarifications** — Submit directly. Low barrier, quick review.
- **New templates or examples** — Propose with a use case. Moderate review.
- **Phase or pillar changes** — Require a formal proposal with evidence from at least two production projects. Thorough review.
- **Governance model changes** — Require broad team consensus and evidence from multiple team sizes.

---

### 7. Metrics and Retrospectives

Track improvement over time. If Phase 6 is working, these metrics trend in the right direction.

#### Key Metrics Dashboard

| Metric | Target Trend | Measurement | Frequency |
|--------|-------------|-------------|-----------|
| Bolt velocity | Stable or increasing | Bolts completed per week | Weekly |
| Bolt success rate | Increasing | % of bolts that ship without rework | Weekly |
| Security findings (new) | Decreasing | New findings per quarterly review | Quarterly |
| Security findings (open) | Decreasing | Unresolved findings at quarter end | Quarterly |
| Test coverage | Stable or increasing | Line and branch coverage % | Per bolt |
| MTTD (mean time to detect) | Decreasing | Time from issue occurrence to alert | Monthly |
| MTTR (mean time to resolve) | Decreasing | Time from alert to resolution | Monthly |
| Infrastructure cost efficiency | Improving | Cost per transaction / request / user | Monthly |
| Dependency freshness | Maintaining | % of dependencies within one minor version of latest | Monthly |
| Context file accuracy | High | % of context rules that still apply (quarterly audit) | Quarterly |
| Process adherence | High | % of bolts following documented workflow | Quarterly |

#### Retrospective Cadence

| Retrospective Type | Frequency | Duration | Participants |
|--------------------|-----------|----------|-------------|
| Bolt retro | After every bolt | 10-15 min | Developer(s) who executed the bolt |
| Sprint/cycle retro | Bi-weekly or per cycle | 30-45 min | Full team |
| Quarterly review | Every 90 days | 60-90 min | Team leads + stakeholders |
| Annual framework review | Yearly | Half day | All practitioners |

#### Retrospective Questions

**Bolt retro (quick):**
1. Did the AI have the context it needed?
2. What would make the next bolt faster?
3. Should anything be added to CLAUDE.md?

**Quarterly review (thorough):**
1. Which patterns recurred this quarter? Are they captured in context files?
2. Did security findings decrease? If not, what systemic issue persists?
3. Are cost actuals within 15% of budget? What drove variance?
4. Which documented processes did the team actually follow? Which did they skip?
5. What new automation opportunities emerged?
6. Is the traceability matrix current and accurate?

---

## Deliverables

| Deliverable | Description | Template |
|-------------|-------------|----------|
| Updated CLAUDE.md | Context file with new patterns, preferences, and conventions | [Context File](../../templates/CLAUDE-CONTEXT.md) |
| Pattern catalog | Documented success patterns and anti-patterns | See Pattern Extraction template above |
| Quarterly security report | Re-review findings, trends, and remediation status | [Security Review Protocol](../../templates/SECURITY-REVIEW-PROTOCOL.md) |
| Drift assessment | Four-dimension drift report with correction actions | See Drift Detection section above |
| Metrics dashboard | Current state of key metrics with trend indicators | [Bolt Metrics Guide](../reference/BOLT-METRICS-GUIDE.md) |
| Decommissioning records | Documentation of retired features and cleanup status | See Decommissioning Checklist above |
| Framework feedback | Case study or improvement proposal | [AI-DLC Case Study](../../templates/AI-DLC-CASE-STUDY.md) |

---

## Exit Criteria

Phase 6 does not have traditional exit criteria — it runs continuously. However, each *cycle* of the learning loop has completion criteria:

- [ ] All production feedback from the period has been reviewed
- [ ] Patterns have been extracted and cataloged
- [ ] Context files have been updated with new learnings
- [ ] Quarterly security re-review is complete (if due)
- [ ] Drift assessment is complete across all four dimensions
- [ ] Metrics dashboard is current and reviewed by the team
- [ ] Retrospective has been conducted and action items assigned
- [ ] Action items from the previous cycle are closed or explicitly deferred

---

## Human Decision Gates

| Gate | Decision | Who Decides |
|------|----------|-------------|
| **Pattern adoption** | Accept or reject a proposed pattern for inclusion in context files | Tech lead or architect |
| **Decommissioning approval** | Approve the removal of a feature or component | Product owner + tech lead |
| **Framework version bump** | Approve changes to AI-DLC framework itself | Framework maintainers |
| **Security exception** | Accept risk for a finding that will not be remediated | Security lead + engineering manager |
| **Cost threshold adjustment** | Raise or lower cost alert thresholds | Engineering manager + finance |
| **Process change** | Modify a documented workflow or ceremony | Team consensus |

---

## Templates

- [AI-DLC Case Study](../../templates/AI-DLC-CASE-STUDY.md) — Document your project's journey through the framework
- [Context File](../../templates/CLAUDE-CONTEXT.md) — Template for CLAUDE.md updates
- [Cost Management Guide](../../templates/COST-MANAGEMENT-GUIDE.md) — Cost tracking and optimization
- [Security Review Protocol](../../templates/SECURITY-REVIEW-PROTOCOL.md) — Quarterly review methodology
- [Ops Readiness Checklist](../../templates/OPS-READINESS-CHECKLIST.md) — Verify operational health
- [Traceability Matrix](../../templates/TRACEABILITY-MATRIX.md) — Keep the requirements chain current

---

## Pillar Checkpoints

### Security Pillar — [PILLAR-SECURITY.md](../pillars/PILLAR-SECURITY.md)

- [ ] Quarterly five-persona re-review completed
- [ ] Dependency vulnerabilities scanned and triaged
- [ ] IAM permissions audited — no unused or overly broad permissions
- [ ] Key rotation schedule verified and current
- [ ] Secret scanning reports reviewed — no exposed credentials
- [ ] Security finding trend is flat or decreasing quarter-over-quarter

### Quality Pillar — [PILLAR-QUALITY.md](../pillars/PILLAR-QUALITY.md)

- [ ] Test coverage is stable or increasing
- [ ] No known regressions in production
- [ ] Code style rules in context files match actual codebase
- [ ] Bolt success rate (ships without rework) is tracked and trending upward
- [ ] Linting and formatting rules are enforced in CI, not just documented

### Traceability Pillar — [PILLAR-TRACEABILITY.md](../pillars/PILLAR-TRACEABILITY.md)

- [ ] Traceability matrix is current — all requirements map to code and tests
- [ ] Decommissioned features are marked in the matrix
- [ ] Captain's logs exist for all bolts in the review period
- [ ] ADRs exist for all significant architecture decisions
- [ ] Pattern catalog links back to originating incidents or bolts

### Cost Awareness Pillar — [PILLAR-COST.md](../pillars/PILLAR-COST.md)

- [ ] Cost actuals are within 15% of budget
- [ ] Cost anomalies have been investigated and explained
- [ ] Decommissioned resources have been removed from billing
- [ ] Cost per unit metric (transaction, request, user) is tracked
- [ ] Kill switches are tested and functional

---

## Cross-References

| Phase | Relationship to Phase 6 |
|-------|------------------------|
| [Phase 0: Foundation](PHASE-0-FOUNDATION.md) | Evolution updates the foundational CLAUDE.md and repo conventions |
| [Phase 1: Inception](PHASE-1-INCEPTION.md) | Learned patterns inform future requirements gathering and architecture |
| [Phase 2: Elaboration](PHASE-2-ELABORATION.md) | Preference learning improves specification quality in future iterations |
| [Phase 3: Construction](PHASE-3-CONSTRUCTION.md) | Pattern extraction directly improves bolt execution and AI code generation |
| [Phase 4: Hardening](PHASE-4-HARDENING.md) | Quarterly security re-reviews extend the hardening practice indefinitely |
| [Phase 5: Operations](PHASE-5-OPERATIONS.md) | Passive feedback depends on operational monitoring; drift detection extends ops |

---

*Phase 6 is what separates teams that use AI from teams that get better at using AI. Run the learning loop. Update the context. Measure the improvement. Repeat.*
