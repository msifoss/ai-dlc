# Ops Readiness Checklist

> **AI-DLC Reference:** Used in **Phase 4: Hardening**, verified in **Phase 5: Operations**.
>
> Copy this template into your project. Work through each item, marking status as you go.

---

## How to Use This Checklist

1. Review each item and set the status: **Pass**, **Fail**, or **N/A**.
2. Add notes explaining the current state, especially for Fail or N/A items.
3. Calculate your readiness score at the bottom.
4. All **Critical** and **High** severity Fail items must be resolved before production launch.
5. Revisit this checklist at each phase transition and before major releases.

---

## Project Information

| Property | Value |
|---|---|
| **Project Name** | *<!-- TODO: Your project name -->* |
| **Assessment Date** | *<!-- TODO: YYYY-MM-DD -->* |
| **Assessed By** | *<!-- TODO: Name(s) -->* |
| **Target Launch Date** | *<!-- TODO: YYYY-MM-DD -->* |

---

## Category 1: Monitoring and Alerting (10 items)

| # | Item | Priority | Status | Notes |
|---|---|---|---|---|
| 1.1 | **Health check endpoint** exists and returns service status (database connectivity, dependency availability) | Critical | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 1.2 | **Uptime monitoring** configured with external checks at least every 60 seconds | Critical | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 1.3 | **Error rate alerts** fire when error rate exceeds threshold (e.g., > 1% of requests over 5 min) | Critical | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 1.4 | **Latency alerts** fire when p95 latency exceeds threshold (e.g., > 500ms over 5 min) | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 1.5 | **Resource utilization alerts** configured for CPU (> 80%), memory (> 85%), disk (> 90%) | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 1.6 | **Log aggregation** in place; logs from all instances are collected centrally and searchable | Critical | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 1.7 | **Operational dashboard** exists showing key metrics: request rate, error rate, latency, resource usage | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 1.8 | **On-call schedule** defined with primary and secondary contacts | Critical | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 1.9 | **Escalation path** documented (who to contact if primary on-call cannot resolve) | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 1.10 | **Synthetic monitoring** (automated tests simulating user actions) running against production | Medium | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |

---

## Category 2: Error Handling (8 items)

| # | Item | Priority | Status | Notes |
|---|---|---|---|---|
| 2.1 | **Graceful degradation** implemented for non-critical dependencies (system continues operating with reduced functionality) | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 2.2 | **Retry logic** with exponential backoff implemented for transient failures (network, database, external APIs) | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 2.3 | **Circuit breakers** implemented for external service calls to prevent cascade failures | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 2.4 | **Dead letter queues (DLQs)** configured for async message processing; failed messages are preserved for investigation | Medium | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 2.5 | **Structured error logging** captures error type, stack trace, request context, and user impact | Critical | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 2.6 | **Error categorization** distinguishes between client errors (4xx), server errors (5xx), and infrastructure errors | Medium | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 2.7 | **User-facing error messages** are helpful but do not leak internal details (no stack traces, no internal paths) | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 2.8 | **Error budget** defined and tracked (e.g., 99.9% availability = 43 min/month error budget) | Medium | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |

---

## Category 3: Security (8 items)

| # | Item | Priority | Status | Notes |
|---|---|---|---|---|
| 3.1 | **Encryption at rest** enabled for all databases, object storage, and backups | Critical | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 3.2 | **Encryption in transit** enforced (TLS 1.2+ on all endpoints; no plaintext HTTP in production) | Critical | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 3.3 | **Authentication and authorization** implemented and tested on all endpoints; default deny policy | Critical | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 3.4 | **Secrets management** in place; no hardcoded secrets in code or config files | Critical | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 3.5 | **Vulnerability scanning** integrated into CI/CD pipeline; no unresolved Critical/High findings | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 3.6 | **WAF / DDoS protection** configured for public-facing endpoints | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 3.7 | **Audit logging** captures security-relevant events (logins, permission changes, data access) with tamper protection | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 3.8 | **Penetration testing** completed (or scheduled before launch) with findings addressed | Medium | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |

---

## Category 4: Deployment (7 items)

| # | Item | Priority | Status | Notes |
|---|---|---|---|---|
| 4.1 | **Automated deployment pipeline** in place; no manual steps required for production deployment | Critical | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 4.2 | **Rollback procedure** documented, tested, and can be executed within 5 minutes | Critical | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 4.3 | **Progressive deployment** strategy in place (blue/green, canary, or rolling) | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 4.4 | **Database migration** strategy handles forward and backward compatibility; migrations are tested before prod | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 4.5 | **Feature flags** available for controlling new functionality rollout independent of deployment | Medium | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 4.6 | **Smoke tests** run automatically after each production deployment | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 4.7 | **Deployment runbook** documents step-by-step procedure, common issues, and troubleshooting | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |

---

## Category 5: Data (7 items)

| # | Item | Priority | Status | Notes |
|---|---|---|---|---|
| 5.1 | **Backup strategy** defined and automated (database snapshots, file backups) | Critical | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 5.2 | **Recovery testing** performed; backup restoration verified within the last quarter | Critical | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 5.3 | **Data retention policy** defined and enforced (how long data is kept, when it is deleted) | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 5.4 | **PII handling** procedures in place (identification, encryption, access control, deletion on request) | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 5.5 | **Data classification** applied (public, internal, confidential, restricted) with handling rules for each level | Medium | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 5.6 | **Backup monitoring** alerts if a backup fails or is overdue | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 5.7 | **Cross-region replication** configured for critical data (if multi-region resilience is required) | Medium | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |

---

## Category 6: Cost (4 items)

| # | Item | Priority | Status | Notes |
|---|---|---|---|---|
| 6.1 | **Budget alerts** configured at 50%, 75%, 90%, and 100% of monthly budget | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 6.2 | **Cost dashboard** available showing spend by environment, category, and trend | Medium | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 6.3 | **Kill switch** implemented and tested to rapidly reduce spend if budget is exceeded | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 6.4 | **Resource tagging** enforced; all resources tagged with project, environment, team, and component | Medium | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |

---

## Category 7: Documentation (3 items)

| # | Item | Priority | Status | Notes |
|---|---|---|---|---|
| 7.1 | **Operational runbooks** exist for common tasks (deploy, rollback, restart, scale, rotate secrets) | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 7.2 | **Architecture diagram** is current and shows all components, data flows, and external dependencies | High | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |
| 7.3 | **Incident response plan** exists with defined roles, communication templates, and post-mortem process | Critical | <!-- TODO: Pass/Fail/N-A --> | <!-- TODO --> |

---

## Readiness Score

### Scoring Instructions

1. Count total items assessed (exclude N/A items): **_____ / 47**
2. Count Pass items: **_____**
3. Calculate score: **Pass items / Total applicable items = _____%**

### Scoring Thresholds

| Score | Rating | Action |
|---|---|---|
| >= 90% | **Ready** | Proceed to production launch |
| 75% - 89% | **Conditionally Ready** | Launch permitted if all Critical items pass; address remaining items within 30 days |
| 50% - 74% | **Not Ready** | Significant gaps; resolve Critical and High items before launch |
| < 50% | **Major Gaps** | Return to Phase 4: Hardening; systematic remediation needed |

### Score Summary

| Category | Total Items | Applicable | Pass | Fail | Score |
|---|---|---|---|---|---|
| Monitoring and Alerting | 10 | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO -->% |
| Error Handling | 8 | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO -->% |
| Security | 8 | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO -->% |
| Deployment | 7 | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO -->% |
| Data | 7 | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO -->% |
| Cost | 4 | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO -->% |
| Documentation | 3 | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO -->% |
| **Overall** | **47** | **<!-- TODO -->** | **<!-- TODO -->** | **<!-- TODO -->** | **<!-- TODO -->%** |

### Critical Item Gate

All items marked **Critical** priority must pass before production launch. List any Critical items that are currently Fail:

| # | Item | Remediation Plan | Target Date |
|---|---|---|---|
| <!-- TODO: List any failing Critical items --> | | | |

---

## Approval & Sign-Off

| Role | Name | Date | Readiness Score |
|---|---|---|---|
| Tech Lead | <!-- TODO --> | | |
| DevOps Lead | <!-- TODO --> | | |
| Security Lead | <!-- TODO --> | | |
| Project Owner | <!-- TODO --> | | |

---

*Reassess this checklist after each major release and at minimum quarterly during Phase 5: Operations.*
