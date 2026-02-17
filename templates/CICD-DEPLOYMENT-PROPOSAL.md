# CI/CD Deployment Proposal

> **AI-DLC Reference:** Created in **Phase 1: Blueprint**, refined in **Phase 5: Operations**
>
> Copy this template into your project and fill in all `<!-- TODO: ... -->` sections.

---

## 1. Pipeline Overview

<!-- TODO: Replace the project name and add any project-specific context. -->

**Project:** *Your Project Name*
**Last Updated:** *YYYY-MM-DD*
**Owner:** *Pipeline owner / DevOps lead*

### Pipeline Stages

```
validate --> build --> test --> deploy-dev --> approve --> deploy-staging --> approve --> deploy-prod
```

| Stage | Trigger | Gate | Timeout |
|---|---|---|---|
| Validate | Push to any branch | Lint + schema checks pass | 5 min |
| Build | Validate passes | Artifact produced successfully | 10 min |
| Test | Build passes | All test suites green, coverage threshold met | 15 min |
| Deploy Dev | Test passes | Deployment health check passes | 10 min |
| Approve (Staging) | Dev deploy verified | Manual approval from tech lead | 24 hr |
| Deploy Staging | Approval granted | Smoke tests + integration tests pass | 15 min |
| Approve (Prod) | Staging verified | Manual approval from project owner | 48 hr |
| Deploy Prod | Approval granted | Canary checks pass, rollback window clear | 20 min |

<!-- TODO: Adjust stages, triggers, gates, and timeouts for your project. -->

---

## 2. Environment Definitions

| Property | Dev | Staging | Prod |
|---|---|---|---|
| Purpose | Rapid iteration, debugging | Pre-production validation | Live traffic |
| Data | Synthetic / seed data | Anonymized copy of prod | Real user data |
| Scale | Minimal (1 instance) | Reduced (2 instances) | Full (auto-scaled) |
| Access | All developers | Dev team + QA | Restricted (ops + on-call) |
| URL | `dev.example.com` | `staging.example.com` | `app.example.com` |
| Monitoring | Basic logs | Full monitoring, no paging | Full monitoring + paging |

<!-- TODO: Fill in actual URLs, instance counts, and access policies. -->

---

## 3. Build Configuration

### Build Steps

1. **Install dependencies** -- package manager install with lock file
2. **Compile / transpile** -- if applicable
3. **Run linters** -- code style and static analysis
4. **Generate artifacts** -- container image, archive, or bundle

### Artifact Strategy

<!-- TODO: Define your artifact format and registry. -->

- **Format:** *Container image / ZIP archive / static bundle*
- **Registry:** *Container registry or artifact store URL*
- **Tagging:** `<branch>-<short-sha>-<timestamp>` (e.g., `main-a1b2c3d-20260115T1430`)
- **Retention:** Keep last 30 builds; keep all tagged releases indefinitely

---

## 4. Test Gates

### Per-Stage Test Requirements

| Stage | Test Type | Minimum Criteria |
|---|---|---|
| Validate | Linting, formatting | Zero errors |
| Build | Compilation checks | Zero errors |
| Test | Unit tests | 100% pass, >= 80% coverage |
| Test | Integration tests | 100% pass |
| Deploy Dev | Smoke tests | All critical paths respond 200 |
| Deploy Staging | End-to-end tests | All user journeys pass |
| Deploy Staging | Performance tests | p95 latency < 500ms |
| Deploy Prod | Canary checks | Error rate < 0.1% for 10 min |

<!-- TODO: Adjust coverage thresholds, latency targets, and error budgets. -->

### Test Failure Policy

- **Validate / Build / Test:** Automatic pipeline halt. Fix and re-push.
- **Deploy Dev:** Auto-rollback to previous good deployment.
- **Deploy Staging:** Auto-rollback; require root cause analysis before retry.
- **Deploy Prod:** Immediate auto-rollback; incident created automatically.

---

## 5. Deployment Strategy

<!-- TODO: Choose one primary strategy and delete or comment out the others. -->

### Option A: Blue/Green Deployment

- Maintain two identical environments (blue and green).
- Route traffic to the idle environment after deploying and verifying.
- Roll back by switching the router back to the previous environment.
- **Best for:** Zero-downtime requirements, quick rollback needs.

### Option B: Canary Deployment

- Deploy to a small percentage of instances (e.g., 5%).
- Monitor error rates and latency for a soak period (e.g., 10 minutes).
- Gradually increase traffic (5% -> 25% -> 50% -> 100%).
- Roll back by routing 100% back to old version.
- **Best for:** High-traffic services, risk-averse rollouts.

### Option C: Rolling Deployment

- Replace instances one at a time (or in small batches).
- Health check each new instance before proceeding.
- Roll back by re-deploying the previous version in the same rolling fashion.
- **Best for:** Stateless services, cost-constrained environments.

**Selected Strategy:** *<!-- TODO: State your choice and rationale. -->*

---

## 6. Rollback Procedures

### Automatic Rollback Triggers

- Health check failure for > 2 consecutive checks
- Error rate exceeds 1% of requests over a 5-minute window
- Latency p95 exceeds 2x baseline for 5 minutes
- Memory or CPU utilization exceeds 90% for 5 minutes

<!-- TODO: Adjust thresholds to match your SLOs. -->

### Manual Rollback Steps

1. Identify the last known good artifact tag from the deployment log.
2. Trigger a deployment of that artifact to the affected environment.
3. Verify health checks pass on the rolled-back version.
4. Notify the team via the incident channel.
5. Create a post-rollback investigation ticket.

### Rollback SLA

| Environment | Rollback Target |
|---|---|
| Dev | Best effort |
| Staging | < 15 minutes |
| Prod | < 5 minutes |

---

## 7. Secrets Management

<!-- TODO: Choose your secrets management approach. -->

| Secret Type | Storage Location | Rotation Frequency | Access Method |
|---|---|---|---|
| API keys | *Secrets manager service* | Every 90 days | Injected at deploy time |
| Database credentials | *Secrets manager service* | Every 90 days | Injected at deploy time |
| TLS certificates | *Certificate manager* | Auto-renewed before expiry | Mounted by load balancer |
| Service tokens | *Secrets manager service* | Every 30 days | Injected at runtime |
| CI/CD tokens | *Pipeline secret store* | Every 90 days | Pipeline variable |

### Secrets Hygiene Rules

- Secrets are **never** committed to version control.
- All secrets are encrypted at rest and in transit.
- Access to secrets is logged and auditable.
- Leaked secrets are revoked within 1 hour and rotated immediately.

---

## 8. Infrastructure-as-Code Approach

<!-- TODO: Specify your IaC tool and repository layout. -->

- **IaC Tool:** *Terraform / Pulumi / CloudFormation / CDK / other*
- **Repository:** *Monorepo subfolder or dedicated infra repo*
- **State Management:** *Remote state with locking (e.g., object storage + lock table)*
- **Module Strategy:** Shared modules for common patterns; environment-specific variable files

### IaC Review Process

1. All infrastructure changes require a PR with a plan/preview output attached.
2. At least one reviewer with infrastructure expertise must approve.
3. Apply runs only from the CI/CD pipeline (no local applies to staging/prod).

---

## 9. Example Pipeline Configuration

```yaml
# Generic pipeline definition -- adapt to your CI/CD platform
# (GitHub Actions, GitLab CI, Jenkins, CircleCI, etc.)

pipeline:
  name: "deploy-pipeline"

  stages:
    - name: validate
      steps:
        - run: install-dependencies
        - run: lint
        - run: check-formatting
      on_failure: stop

    - name: build
      steps:
        - run: compile
        - run: build-artifact
        - run: push-artifact --tag $BRANCH-$SHA-$TIMESTAMP
      on_failure: stop

    - name: test
      steps:
        - run: unit-tests --coverage-min 80
        - run: integration-tests
      on_failure: stop

    - name: deploy-dev
      environment: dev
      steps:
        - run: deploy --env dev --artifact $ARTIFACT_TAG
        - run: smoke-tests --target dev.example.com
      on_failure: rollback

    - name: approve-staging
      type: manual-gate
      approvers:
        - tech-lead
      timeout: 24h

    - name: deploy-staging
      environment: staging
      steps:
        - run: deploy --env staging --artifact $ARTIFACT_TAG
        - run: smoke-tests --target staging.example.com
        - run: e2e-tests --target staging.example.com
        - run: performance-tests --target staging.example.com
      on_failure: rollback

    - name: approve-prod
      type: manual-gate
      approvers:
        - project-owner
      timeout: 48h

    - name: deploy-prod
      environment: prod
      strategy: canary  # or blue-green, rolling
      steps:
        - run: deploy --env prod --artifact $ARTIFACT_TAG --canary-percent 5
        - run: monitor --duration 10m --error-threshold 0.1
        - run: deploy --env prod --artifact $ARTIFACT_TAG --canary-percent 100
      on_failure: rollback
```

<!-- TODO: Translate this generic definition into your CI/CD platform's syntax. -->

---

## 10. Approval & Sign-Off

| Role | Name | Date | Signature |
|---|---|---|---|
| Tech Lead | <!-- TODO --> | | |
| DevOps Lead | <!-- TODO --> | | |
| Project Owner | <!-- TODO --> | | |
| Security Lead | <!-- TODO --> | | |

---

*This document is a living artifact. Update it as the pipeline evolves through Phase 5: Operations and beyond.*
