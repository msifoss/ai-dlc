# Phase 5: Operations — Deploy and Observe

> "Deployment is not the finish line — it is the starting line. Production is where software meets reality, and reality is unforgiving."

---

## Purpose

Phase 5 transitions the hardened system from a release candidate into a running production service. This phase establishes the deployment pipeline, monitoring infrastructure, runbooks, and incident response procedures that keep the system healthy over time. It also introduces AI-assisted observability — using the same AI capabilities that built the system to monitor and diagnose it.

Operations is not a one-time event. It is an ongoing discipline that continues until the system is retired or replaced.

---

## Entry Criteria

Before starting Operations, verify:

- [ ] [Phase 4: Hardening](PHASE-4-HARDENING.md) exit criteria met
- [ ] Five-persona security review complete — zero critical/high findings
- [ ] Ops readiness checklist scored >= 85/94
- [ ] Cost controls (dashboard, alarms, kill switches) deployed and tested
- [ ] All critical paths have alarms with notification channels verified
- [ ] Rollback procedure documented and tested in staging
- [ ] Performance testing complete — targets met
- [ ] Human decision gate: **Go/No-go decision approved by project sponsor**

---

## Activities

### 5.1 Deployment Pipeline Design

Build a pipeline that enforces quality at every stage. No manual steps. No exceptions.

#### Pipeline Stages

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ VALIDATE │───>│   DEV    │───>│ APPROVAL │───>│ STAGING  │───>│   PROD   │
│          │    │          │    │   GATE   │    │          │    │          │
│ Lint     │    │ Deploy   │    │ Human    │    │ Deploy   │    │ Deploy   │
│ Test     │    │ Smoke    │    │ review   │    │ Full     │    │ Canary   │
│ Scan     │    │ test     │    │ required │    │ test     │    │ then     │
│ Build    │    │          │    │          │    │ suite    │    │ promote  │
└──────────┘    └──────────┘    └──────────┘    └──────────┘    └──────────┘
```

| Stage | Purpose | Activities | Failure Action |
|-------|---------|-----------|----------------|
| **Validate** | Catch problems before deployment | Lint, unit tests, security scan, build artifacts | Block pipeline, notify developer |
| **Dev** | Verify deployment works | Deploy to dev environment, run smoke tests | Block pipeline, notify developer |
| **Approval Gate** | Human oversight | Tech lead reviews diff, approves promotion | Hold until approved or rejected |
| **Staging** | Verify in production-like environment | Deploy, run full test suite (integration + e2e), soak test | Block pipeline, notify team |
| **Prod** | Ship to users | Canary deploy (10%), monitor, promote to 100% | Auto-rollback on error spike |

#### Pipeline Definition

```yaml
# Example: GitHub Actions deployment pipeline
name: Deploy
on:
  push:
    branches: [main]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Lint
        run: npm run lint
      - name: Unit Tests
        run: npm test -- --coverage
      - name: Security Scan
        run: npm audit --audit-level=high
      - name: Build
        run: npm run build
      - name: Upload Artifacts
        uses: actions/upload-artifact@v4
        with:
          name: build
          path: dist/

  deploy-dev:
    needs: validate
    runs-on: ubuntu-latest
    environment: dev
    steps:
      - name: Deploy to Dev
        run: ./scripts/deploy.sh dev
      - name: Smoke Tests
        run: ./scripts/smoke-test.sh dev

  approval:
    needs: deploy-dev
    runs-on: ubuntu-latest
    environment: staging  # Requires manual approval in GitHub settings
    steps:
      - name: Approval Recorded
        run: echo "Deployment approved by reviewer"

  deploy-staging:
    needs: approval
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - name: Deploy to Staging
        run: ./scripts/deploy.sh staging
      - name: Full Test Suite
        run: ./scripts/integration-tests.sh staging
      - name: Performance Validation
        run: ./scripts/perf-test.sh staging --quick

  deploy-prod:
    needs: deploy-staging
    runs-on: ubuntu-latest
    environment: production
    steps:
      - name: Canary Deploy (10%)
        run: ./scripts/deploy.sh prod --canary 10
      - name: Monitor Canary (10 minutes)
        run: ./scripts/monitor-canary.sh --duration 600 --error-threshold 1
      - name: Promote to 100%
        run: ./scripts/deploy.sh prod --promote
      - name: Post-Deploy Smoke Tests
        run: ./scripts/smoke-test.sh prod
```

#### Cross-Reference

- Pipeline template: [CICD-DEPLOYMENT-PROPOSAL.md](../../templates/CICD-DEPLOYMENT-PROPOSAL.md)
- Quality pillar: [Pillar: Quality](../pillars/PILLAR-QUALITY.md)

---

### 5.2 Multi-Environment Strategy

Maintain three environments with strict promotion gates between them.

#### Environment Matrix

| Attribute | Dev | Staging | Production |
|-----------|-----|---------|------------|
| **Purpose** | Rapid iteration and debugging | Pre-production validation | Serves real users |
| **Data** | Synthetic / seed data | Anonymized copy of production | Real user data |
| **Scale** | Minimal (single instance) | Production-like (reduced scale) | Full scale, auto-scaling |
| **Access** | All developers | Developers + QA | Restricted (ops team + deploy pipeline) |
| **Deploy frequency** | On every push to dev branch | On approval after dev validation | On approval after staging validation |
| **Monitoring** | Basic (errors + logs) | Full (alarms + dashboards) | Full + on-call alerts |
| **Cost profile** | Low ($) | Medium ($$) | Full ($$$) |

#### Environment Parity Verification

Differences between environments cause "works in staging, fails in production" bugs. Verify parity systematically:

```bash
# Compare infrastructure-as-code between environments
diff <(terraform show -json staging.tfstate | jq '.values.root_module') \
     <(terraform show -json prod.tfstate | jq '.values.root_module')
```

Parity checklist:

- [ ] Same runtime versions (language, framework, OS)
- [ ] Same infrastructure topology (same services, same configurations)
- [ ] Same environment variable names (different values are expected)
- [ ] Same IAM policy structure (different resource ARNs are expected)
- [ ] Same networking rules (security groups, firewall rules)
- [ ] Same database schema version
- [ ] Same feature flags (unless intentionally different)

#### Promotion Gates

| Transition | Gate | Criteria |
|-----------|------|----------|
| Dev to Staging | Automated + human | All tests pass, smoke tests pass, tech lead approves |
| Staging to Prod | Human approval required | Full test suite passes, performance validated, ops lead approves |
| Prod rollback | Automated trigger or manual | Error rate > threshold or human decision |

---

### 5.3 Runbook Creation

Runbooks translate operational knowledge into executable procedures. Write them in symptom-based format: "Given symptom X, check Y, fix Z."

#### Runbook Structure

Every runbook follows this template:

```markdown
# Runbook: [Symptom or Scenario]

## Severity: P1 | P2 | P3 | P4
## Last Updated: YYYY-MM-DD
## Owner: [team or individual]

### Symptom
What the operator observes (alarm, user report, dashboard anomaly).

### Impact
What breaks if this is not resolved. Who is affected.

### Diagnosis Steps
1. Check [specific metric/log/dashboard] — look for [specific pattern]
2. Run [specific command] — expected output is [X], problem output is [Y]
3. Verify [specific condition]

### Resolution Steps
1. [Specific action with exact command]
2. [Verification that action worked]
3. [Communication steps — who to notify]

### Rollback
If resolution makes things worse:
1. [Revert action]
2. [Escalate to next level]

### Prevention
What changes would prevent this from recurring.
```

#### Example Runbooks

Create runbooks for at minimum these scenarios:

| Runbook | Trigger | Key Actions |
|---------|---------|-------------|
| API error rate spike | 5xx rate > 1% alarm | Check logs for error pattern, identify failing endpoint, restart or rollback |
| Database connection exhaustion | Connection count > 80% alarm | Identify long-running queries, kill stuck connections, scale if needed |
| Queue processing stalled | Queue age > 5 min alarm | Check consumer logs, verify consumer health, restart consumers |
| DLQ messages accumulating | DLQ count > 0 alarm | Inspect failed messages, identify failure pattern, fix and reprocess |
| Cost spike | Daily spend > 2x alarm | Identify cost source, activate kill switch if needed, investigate root cause |
| Authentication failures | Login failure > 10% alarm | Check for brute force, verify auth service health, check certificate expiry |
| Deployment failure | Deploy pipeline fails | Check pipeline logs, verify artifacts, rollback if partially deployed |
| Data inconsistency | User report or monitoring | Identify affected records, determine root cause, plan data fix |

#### Symptom-Based Triage Decision Tree

```
Symptom: Users report errors
  │
  ├── Check: API error rate dashboard
  │   ├── Error rate elevated? → Runbook: API Error Rate Spike
  │   └── Normal? → Continue diagnosis
  │
  ├── Check: Health check endpoints
  │   ├── Endpoint down? → Runbook: Service Outage
  │   └── All healthy? → Continue diagnosis
  │
  ├── Check: Database metrics
  │   ├── Connections exhausted? → Runbook: DB Connection Exhaustion
  │   ├── High latency? → Runbook: DB Performance Degradation
  │   └── Normal? → Continue diagnosis
  │
  └── Check: External dependency status
      ├── Dependency down? → Runbook: External Dependency Failure
      └── All healthy? → Escalate to engineering for investigation
```

---

### 5.4 Release Runbook

The release runbook is a step-by-step deployment guide executed for every production release.

#### Pre-Deployment Checklist

- [ ] All [Phase 4: Hardening](PHASE-4-HARDENING.md) exit criteria met
- [ ] Release branch created and tagged (e.g., `v1.2.0`)
- [ ] Changelog updated with release notes
- [ ] Staging deployment successful and validated
- [ ] On-call engineer identified and available
- [ ] Rollback plan reviewed with ops team
- [ ] Deployment window confirmed (avoid Fridays, holidays, end-of-quarter)

#### Deployment Steps

```bash
# Step 1: Tag the release
git tag -a v1.2.0 -m "Release 1.2.0: [brief description]"
git push origin v1.2.0

# Step 2: Deploy canary (10% of traffic)
./scripts/deploy.sh prod --canary 10 --version v1.2.0

# Step 3: Monitor canary (minimum 10 minutes)
./scripts/monitor-canary.sh --duration 600 --error-threshold 1
# If errors exceed threshold, auto-rollback triggers

# Step 4: Promote to 50% (if canary healthy)
./scripts/deploy.sh prod --canary 50 --version v1.2.0

# Step 5: Monitor at 50% (minimum 10 minutes)
./scripts/monitor-canary.sh --duration 600 --error-threshold 0.5

# Step 6: Promote to 100%
./scripts/deploy.sh prod --promote --version v1.2.0

# Step 7: Post-deployment verification
./scripts/smoke-test.sh prod
./scripts/verify-deployment.sh --version v1.2.0
```

#### Post-Deployment Checklist

- [ ] Smoke tests pass in production
- [ ] Error rate stable (no increase from baseline)
- [ ] Latency stable (no increase from baseline)
- [ ] New features functional (manual spot-check)
- [ ] Cost metrics normal (no unexpected spikes)
- [ ] Deployment recorded in changelog / release log
- [ ] Team notified of successful deployment

#### Rollback Procedure

```bash
# Immediate rollback (< 5 minutes)
# Use when: Critical errors detected during or after deployment

# Step 1: Revert to previous version
./scripts/deploy.sh prod --rollback --to-version v1.1.0

# Step 2: Verify rollback
./scripts/smoke-test.sh prod
./scripts/verify-deployment.sh --version v1.1.0

# Step 3: Notify team
# Post in ops channel: "Rollback to v1.1.0 complete. Investigating v1.2.0 issues."

# Step 4: Create incident ticket
# Document: what failed, when detected, rollback time, root cause investigation plan
```

---

### 5.5 Monitoring Setup

Establish layered monitoring that catches problems at every level.

#### Monitoring Layers

| Layer | What It Catches | Tools | Example |
|-------|----------------|-------|---------|
| **Infrastructure** | Resource exhaustion, hardware failures | CloudWatch / Azure Monitor / GCP Monitoring | CPU > 80%, disk > 90% |
| **Application** | Errors, latency, throughput degradation | Datadog / New Relic / custom metrics | 5xx rate > 1%, p99 > 3s |
| **Business** | Functional degradation, revenue impact | Custom dashboards, analytics | Orders/min drops 50%, signup conversion drops |
| **Synthetic** | User-facing availability | Canary tests, uptime monitors | Homepage loads in < 2s from 5 regions |
| **Cost** | Spend anomalies | Cloud billing alerts | Daily spend > 2x baseline |

#### Alarm Design

Design alarms to be actionable, not noisy. Every alarm must answer: "What do I do when this fires?"

```yaml
# Good alarm: Specific, actionable, linked to runbook
- name: api-order-endpoint-5xx-rate
  description: "Order API returning server errors"
  metric: aws/apigateway/5xx
  filter: resource=/api/orders
  threshold: "> 1% for 5 minutes"
  action: page on-call
  runbook: https://wiki.example.com/runbooks/order-api-errors
  severity: P1

# Bad alarm: Vague, no action, no runbook
- name: high-cpu
  description: "CPU is high"
  metric: cpu_utilization
  threshold: "> 50%"
  action: email team
```

#### Synthetic Canary Tests

Run automated tests that simulate real user journeys on a schedule:

```python
# Example: Synthetic canary test
import requests
import time

def canary_test():
    """Run every 5 minutes. Verify critical user journeys."""
    results = []

    # Test 1: Homepage loads
    start = time.time()
    resp = requests.get('https://app.example.com/', timeout=10)
    results.append({
        'test': 'homepage_load',
        'status': resp.status_code,
        'latency_ms': (time.time() - start) * 1000,
        'pass': resp.status_code == 200
    })

    # Test 2: API health check
    start = time.time()
    resp = requests.get('https://api.example.com/health', timeout=5)
    results.append({
        'test': 'api_health',
        'status': resp.status_code,
        'latency_ms': (time.time() - start) * 1000,
        'pass': resp.status_code == 200 and resp.json().get('status') == 'healthy'
    })

    # Test 3: Authentication flow
    start = time.time()
    resp = requests.post('https://api.example.com/auth/token', json={
        'username': 'canary-user@example.com',
        'password': CANARY_PASSWORD  # Stored in secrets manager
    }, timeout=10)
    results.append({
        'test': 'auth_flow',
        'status': resp.status_code,
        'latency_ms': (time.time() - start) * 1000,
        'pass': resp.status_code == 200
    })

    # Emit metrics and alarm on failures
    for result in results:
        emit_metric(f"canary.{result['test']}.pass", 1 if result['pass'] else 0)
        emit_metric(f"canary.{result['test']}.latency", result['latency_ms'])

    return all(r['pass'] for r in results)
```

#### Weekly Ops Report

Generate a weekly operations report covering system health:

```markdown
# Weekly Ops Report — Week of YYYY-MM-DD

## Availability
- Uptime: 99.97% (target: 99.9%)
- Downtime: 12 minutes (scheduled maintenance)
- Incidents: 0 P1, 1 P2, 2 P3

## Performance
- API p50: 45ms (target: < 100ms)
- API p95: 180ms (target: < 500ms)
- API p99: 420ms (target: < 1000ms)

## Errors
- Total 5xx errors: 127 (down 15% from last week)
- Top error: TimeoutError in /api/reports (68 occurrences)
- Action: Investigating slow query in report generation

## Cost
- Weekly spend: $342 (budget: $400/week)
- Trend: +5% from last week (within expected growth)
- Largest line item: Lambda invocations ($128)

## Action Items
- [ ] Optimize report generation query (owner: @engineer)
- [ ] Review alarm thresholds for queue depth (owner: @ops)
- [ ] Update canary test for new checkout flow (owner: @qa)
```

---

### 5.6 AI-Assisted Observability (The /prodstatus Pattern)

Use AI to synthesize operational data into human-readable summaries. The `/prodstatus` pattern asks the AI to review system health and produce an executive summary.

#### How It Works

1. **Gather data.** Pull metrics from monitoring, recent alarms, error logs, and cost data.
2. **Feed to AI.** Provide the data to the AI with the prompt: "Summarize system health. Flag anything that needs attention."
3. **AI produces a status report.** The AI identifies patterns humans might miss — correlating error spikes with deployments, cost anomalies with traffic patterns, degradation trends before they become incidents.

#### Example /prodstatus Interaction

```
Human: /prodstatus

AI: ## Production Status — 2024-01-15 14:30 UTC

### Overall: HEALTHY with 1 item requiring attention

**Services:**
- API Gateway: HEALTHY — 99.98% success rate, p95 latency 180ms
- Order Processing: HEALTHY — Queue depth normal, DLQ empty
- Authentication: HEALTHY — Login success rate 99.2%
- Report Generator: DEGRADED — p95 latency increased 40% over 7 days

**Attention Required:**
1. Report generator latency trending upward (p95: 850ms → 1,190ms over 7 days).
   This correlates with a 25% increase in report table row count. Recommend:
   - Add index on `reports.created_at` column
   - Consider pagination for large result sets
   - Monitor: if p95 exceeds 1,500ms, the CloudWatch alarm will trigger

**Cost:**
- MTD spend: $1,247 of $1,800 budget (69%, 50% through month — on track)
- No anomalies detected

**Recent Changes:**
- v1.2.1 deployed 2024-01-14 (minor: updated dependencies)
- No correlation between deployment and performance changes
```

#### Setting Up /prodstatus

Add this to your project's context file (CLAUDE.md):

```markdown
## /prodstatus Command

When I say /prodstatus, perform the following:
1. Query CloudWatch/Datadog for: error rates, latency (p50/p95/p99), queue depths,
   DLQ counts, and active alarms — for the last 24 hours
2. Query billing data for MTD spend vs. budget
3. Check recent deployments (last 7 days)
4. Produce a status report in this format:
   - Overall health: HEALTHY | DEGRADED | UNHEALTHY
   - Per-service status with key metrics
   - Items requiring attention with recommended actions
   - Cost summary
   - Recent changes and any correlation with issues
```

#### Cross-Reference

- Traceability pillar: [Pillar: Traceability](../pillars/PILLAR-TRACEABILITY.md)
- Cost pillar: [Pillar: Cost Awareness](../pillars/PILLAR-COST.md)

---

### 5.7 Incident Response Procedures

Establish clear procedures for when things go wrong.

#### Severity Classification

| Severity | Definition | Response Time | Examples |
|----------|-----------|---------------|---------|
| **P1 — Critical** | Service down or data loss for all users | Respond in 15 min, resolve in 4 hours | API completely unavailable, data corruption, security breach |
| **P2 — High** | Major feature unavailable or degraded for many users | Respond in 30 min, resolve in 8 hours | Payment processing down, auth intermittently failing |
| **P3 — Medium** | Minor feature impacted or degraded for some users | Respond in 2 hours, resolve in 24 hours | Report generation slow, non-critical API returning errors |
| **P4 — Low** | Cosmetic issues, minor bugs, no user impact | Respond in 24 hours, resolve in 1 week | UI alignment issues, log formatting errors |

#### Escalation Paths

```
P1 (Critical):
  0 min  → On-call engineer alerted (PagerDuty/Opsgenie)
  15 min → If not acknowledged: escalate to backup on-call
  30 min → If not resolved: escalate to team lead
  60 min → If not resolved: escalate to engineering manager
  4 hrs  → If not resolved: escalate to VP Engineering / CTO

P2 (High):
  0 min  → On-call engineer alerted
  30 min → If not acknowledged: escalate to backup
  2 hrs  → If not resolved: escalate to team lead
  8 hrs  → If not resolved: escalate to engineering manager

P3 (Medium):
  0 min  → Ticket created, assigned to on-call
  Next business day → Triage and plan resolution

P4 (Low):
  0 min  → Ticket created, added to backlog
  Next sprint → Prioritize with other work
```

#### Incident Response Workflow

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ DETECT   │───>│ TRIAGE   │───>│ RESPOND  │───>│ RESOLVE  │───>│ REVIEW   │
│          │    │          │    │          │    │          │    │          │
│ Alarm    │    │ Classify │    │ Diagnose │    │ Fix or   │    │ Post-    │
│ User     │    │ severity │    │ using    │    │ rollback │    │ mortem   │
│ report   │    │ Assign   │    │ runbooks │    │ Verify   │    │ Action   │
│ Canary   │    │ owner    │    │ Comms    │    │ stable   │    │ items    │
└──────────┘    └──────────┘    └──────────┘    └──────────┘    └──────────┘
```

1. **Detect.** Alarm fires, user reports, or canary test fails.
2. **Triage.** Classify severity, assign incident owner, open incident channel.
3. **Respond.** Follow relevant runbook. Communicate status to stakeholders every 15 min (P1) or 30 min (P2).
4. **Resolve.** Apply fix or rollback. Verify system returns to healthy state. Close incident channel.
5. **Review.** Conduct blameless post-mortem within 48 hours.

#### Post-Mortem Template

```markdown
# Post-Mortem: [Incident Title]

## Summary
- **Date:** YYYY-MM-DD
- **Duration:** X hours Y minutes
- **Severity:** P1 | P2 | P3
- **Impact:** [Who was affected and how]
- **Detection:** [How was it detected — alarm, user report, canary]
- **Resolution:** [What fixed it]

## Timeline
| Time (UTC) | Event |
|------------|-------|
| HH:MM | [Event description] |
| HH:MM | [Event description] |

## Root Cause
[What actually caused the incident. Be specific and technical.]

## Contributing Factors
- [Factor 1 — e.g., missing alarm on this code path]
- [Factor 2 — e.g., integration test did not cover this scenario]

## What Went Well
- [Positive observation — e.g., runbook was accurate and saved time]

## What Could Be Improved
- [Improvement opportunity — e.g., alarm should have fired 10 minutes earlier]

## Action Items
| Action | Owner | Deadline | Status |
|--------|-------|----------|--------|
| [Specific action] | @person | YYYY-MM-DD | Open |
```

---

### 5.8 Shared Infrastructure Management

For systems with shared infrastructure (VPCs, networking, shared databases), establish clear ownership and access patterns.

#### VPC Design Principles

- Separate VPCs (or virtual networks) for dev, staging, and production
- Private subnets for compute and data resources
- Public subnets only for load balancers and NAT gateways
- Security groups with explicit allow rules (deny by default)
- VPC flow logs enabled for security audit

```
Production VPC (10.0.0.0/16)
├── Public Subnet A (10.0.1.0/24) — ALB, NAT Gateway
├── Public Subnet B (10.0.2.0/24) — ALB, NAT Gateway
├── Private Subnet A (10.0.10.0/24) — Compute (ECS/EKS/Lambda)
├── Private Subnet B (10.0.11.0/24) — Compute (ECS/EKS/Lambda)
├── Data Subnet A (10.0.20.0/24) — RDS, ElastiCache
└── Data Subnet B (10.0.21.0/24) — RDS, ElastiCache
```

> **Azure sidebar:** Use Virtual Networks with NSGs. **GCP sidebar:** Use VPC with firewall rules and Private Google Access.

#### Cross-Account / Cross-Project Access

When multiple services or teams share infrastructure:

| Pattern | Use Case | Implementation |
|---------|----------|---------------|
| Assume role (AWS) / Service principal (Azure) / Service account (GCP) | Cross-account API access | Scoped trust policy with external ID |
| Shared VPC / VNet peering | Cross-service networking | Peered VPCs with restrictive routing |
| Shared secrets | Cross-service configuration | Centralized secrets manager with scoped access policies |
| Event bus | Cross-service communication | EventBridge / Event Grid / Pub/Sub with schema registry |

#### Infrastructure-as-Code

All infrastructure must be defined in code. No manual changes in production.

```
infrastructure/
├── modules/
│   ├── networking/     # VPC, subnets, security groups
│   ├── compute/        # Lambda, ECS, VM definitions
│   ├── data/           # RDS, DynamoDB, storage
│   └── monitoring/     # Alarms, dashboards, log groups
├── environments/
│   ├── dev.tfvars      # Dev-specific values
│   ├── staging.tfvars  # Staging-specific values
│   └── prod.tfvars     # Production-specific values
└── main.tf             # Root module composition
```

#### Cross-Reference

- Infrastructure template: [INFRASTRUCTURE-PLAYBOOK.md](../../templates/INFRASTRUCTURE-PLAYBOOK.md)
- Security pillar: [Pillar: Security](../pillars/PILLAR-SECURITY.md)

---

### 5.9 Blue/Green and Canary Deployment Strategies

Choose a deployment strategy based on risk tolerance and rollback requirements.

#### Strategy Comparison

| Strategy | Risk | Rollback Speed | Cost | Complexity | Best For |
|----------|------|---------------|------|-----------|----------|
| **Rolling** | Medium | Minutes | Low (no extra infra) | Low | Stateless services |
| **Blue/Green** | Low | Seconds (DNS/LB switch) | High (2x infra during deploy) | Medium | Stateful services, databases |
| **Canary** | Lowest | Seconds (route change) | Medium (10% extra during test) | High | High-traffic, critical services |
| **Feature flags** | Lowest | Instant (toggle) | Low | Medium | Per-feature rollback |

#### Blue/Green Deployment

Maintain two identical environments. Deploy to inactive, switch traffic, keep old environment for rollback.

```
                    ┌──────────────┐
                    │ Load Balancer │
                    └──────┬───────┘
                           │
              ┌────────────┼────────────┐
              │                         │
      ┌───────▼───────┐       ┌────────▼───────┐
      │   BLUE (v1)   │       │  GREEN (v2)    │
      │   (current)   │       │  (new deploy)  │
      │               │       │                │
      │  100% traffic │       │   0% traffic   │
      └───────────────┘       └────────────────┘

After validation:

      ┌───────────────┐       ┌────────────────┐
      │   BLUE (v1)   │       │  GREEN (v2)    │
      │  (standby)    │       │  (current)     │
      │               │       │                │
      │   0% traffic  │       │  100% traffic  │
      └───────────────┘       └────────────────┘
```

#### Canary Deployment

Route a small percentage of traffic to the new version. Monitor. Gradually increase.

```
Phase 1:  [==========] 90% v1    [=] 10% v2     ← Monitor 10 min
Phase 2:  [=======]    70% v1    [===] 30% v2   ← Monitor 10 min
Phase 3:  [=====]      50% v1    [=====] 50% v2 ← Monitor 10 min
Phase 4:  [=]          10% v1    [=========] 90% v2 ← Monitor 10 min
Phase 5:                         [==========] 100% v2 ← Full promotion
```

Auto-rollback criteria during canary:
- Error rate exceeds baseline by > 0.5%
- p95 latency exceeds baseline by > 50%
- Any P1 alarm fires

---

### 5.10 Rollback Procedures and Blast Radius Management

#### Rollback Decision Matrix

| Scenario | Decision | Method |
|----------|----------|--------|
| Error rate spikes during canary | Automatic rollback | Route 100% to previous version |
| P1 incident within 1 hour of deploy | Manual rollback | Redeploy previous version |
| Data migration failure | Manual rollback | Run reverse migration, redeploy |
| Feature causes business impact (not errors) | Feature flag toggle | Disable feature, keep deployment |
| Performance degradation discovered after hours | Scheduled rollback | Plan rollback for next maintenance window |

#### Blast Radius Management

Contain the impact of failures:

| Technique | Purpose | Implementation |
|-----------|---------|---------------|
| **Feature flags** | Isolate new functionality | Toggle features without redeployment |
| **Canary deployment** | Limit user exposure | Route minority traffic to new version |
| **Circuit breakers** | Prevent cascading failures | Open circuit when dependency fails |
| **Bulkheads** | Isolate failure domains | Separate thread pools/containers per dependency |
| **Rate limiting** | Prevent overload | Throttle requests per client/IP/API key |
| **Graceful degradation** | Maintain core function | Disable non-critical features under load |

```python
# Example: Feature flag with graceful degradation
def get_recommendations(user_id):
    """Return product recommendations with graceful degradation."""
    if not feature_flags.is_enabled('ai-recommendations', user_id):
        return get_static_recommendations()  # Fallback: curated list

    try:
        return ai_service.get_recommendations(user_id, timeout=2.0)
    except (TimeoutError, ServiceUnavailableError):
        # AI service down — degrade gracefully
        log.warning(f"AI recommendations unavailable, falling back to static")
        return get_static_recommendations()
```

---

## Deliverables

| Deliverable | Description | Template |
|-------------|-------------|----------|
| Deployment pipeline | Automated validate-deploy-verify pipeline | [CICD-DEPLOYMENT-PROPOSAL.md](../../templates/CICD-DEPLOYMENT-PROPOSAL.md) |
| Environment configuration | Dev, staging, prod environment definitions | [INFRASTRUCTURE-PLAYBOOK.md](../../templates/INFRASTRUCTURE-PLAYBOOK.md) |
| Operational runbooks | Symptom-based triage procedures | (project-specific) |
| Release runbook | Step-by-step deployment with rollback | (project-specific) |
| Monitoring dashboard | Real-time system health view | (project-specific) |
| Ops readiness scorecard | Final verification before go-live | [OPS-READINESS-CHECKLIST.md](../../templates/OPS-READINESS-CHECKLIST.md) |
| Incident response plan | Severity classification, escalation paths, post-mortem template | (project-specific) |
| /prodstatus configuration | AI-assisted observability setup | Context file addition |
| Weekly ops report template | Ongoing health tracking | (project-specific) |

---

## Exit Criteria

Before advancing to [Phase 6: Evolution](PHASE-6-EVOLUTION.md), verify:

- [ ] Deployment pipeline operational — automated from commit to production
- [ ] All three environments (dev, staging, prod) running and verified
- [ ] Production deployment successful with zero-downtime
- [ ] Monitoring dashboard live with all critical metrics visible
- [ ] All alarms verified (test-fired and confirmed notification delivery)
- [ ] Synthetic canary tests running on schedule
- [ ] Runbooks created for all known failure scenarios
- [ ] Release runbook tested with at least one production deployment
- [ ] Rollback procedure tested successfully
- [ ] Incident response plan documented and communicated to team
- [ ] /prodstatus (or equivalent observability) configured and tested
- [ ] First weekly ops report generated
- [ ] Human decision gate: **Ops lead confirms system is stable in production for 72+ hours**

---

## Human Decision Gates

| Gate | Decision Maker | Question | Artifacts Required |
|------|---------------|----------|-------------------|
| Deployment approval | Tech lead | Is this build safe to deploy to staging? | Pipeline output, test results |
| Production go/no-go | Ops lead + product owner | Do we deploy to production? | Staging validation results, release runbook |
| Go-live confirmation | Project sponsor | Is the system ready for real users? | 72-hour stability report, all ops deliverables |
| Incident severity classification | On-call engineer | What severity is this incident? | Symptom data, impact assessment |
| Post-mortem closure | Team lead | Are all action items addressed? | Post-mortem document, action item status |

---

## Templates

- [CICD-DEPLOYMENT-PROPOSAL.md](../../templates/CICD-DEPLOYMENT-PROPOSAL.md) — Deployment pipeline design and configuration
- [INFRASTRUCTURE-PLAYBOOK.md](../../templates/INFRASTRUCTURE-PLAYBOOK.md) — Infrastructure setup and management
- [OPS-READINESS-CHECKLIST.md](../../templates/OPS-READINESS-CHECKLIST.md) — 47-item production readiness verification

---

## Pillar Checkpoints

### Security Pillar

- [ ] Production secrets stored in secrets manager with rotation policy
- [ ] TLS certificates valid and expiration monitored
- [ ] Security groups / firewall rules reviewed and minimized
- [ ] Deployment pipeline has no hardcoded credentials
- [ ] Incident response plan includes security breach scenario
- [ ] VPC flow logs and audit trails enabled
- [ ] Cross-account access uses scoped roles with external IDs

### Quality Pillar

- [ ] Deployment pipeline enforces lint, test, scan gates
- [ ] Canary tests verify critical user journeys
- [ ] Performance baselines established and monitored
- [ ] Error budgets defined and tracked
- [ ] Post-deployment smoke tests run automatically
- [ ] Rollback tested and verified to work within SLA

### Traceability Pillar

- [ ] [Traceability matrix](../../templates/TRACEABILITY-MATRIX.md) updated: requirements traced through to production deployment
- [ ] Every deployment tagged with version and linked to changelog
- [ ] Incident post-mortems link to root cause code and fix commit
- [ ] Runbooks version-controlled alongside application code
- [ ] Weekly ops reports archived for trend analysis

### Cost Awareness Pillar

- [ ] Cost dashboard accessible to all stakeholders
- [ ] Budget alarms verified in production
- [ ] Kill switches tested in production (not just staging)
- [ ] Multi-environment cost tracked separately (dev vs. staging vs. prod)
- [ ] Weekly ops report includes cost section with trend analysis
- [ ] Unused resources identified and cleaned up (orphaned volumes, idle instances)

---

## Anti-Patterns

Avoid these common operations mistakes:

| Anti-Pattern | Why It Fails | Instead |
|-------------|-------------|---------|
| Manual deployments ("just SSH in and update") | Unrepeatable, error-prone, unauditable | Fully automated pipeline |
| No staging environment ("test in prod") | Production users absorb bugs | Three-environment strategy with promotion gates |
| Deploy on Friday afternoon | Weekend incidents with reduced staffing | Deploy early in the week, during business hours |
| Alarm without runbook | Operator sees alarm, does not know what to do | Link every alarm to a runbook |
| Monitoring only errors (not latency or business metrics) | Slow degradation goes unnoticed | Layer monitoring: infra, app, business, synthetic |
| Skipping post-mortems ("it's fixed, move on") | Same incident recurs | Blameless post-mortem within 48 hours |
| Single point of failure in deployment | One person's laptop is the deploy server | Pipeline runs in CI/CD platform, not local machines |
| No rollback plan | Stuck with broken deployment | Test rollback before every production deploy |

---

## Relationship to Other Phases

- **Inputs from [Phase 4: Hardening](PHASE-4-HARDENING.md):** Hardened system with security clearance, alarms, dashboards, cost controls, ops readiness score
- **Outputs to [Phase 6: Evolution](PHASE-6-EVOLUTION.md):** Production telemetry, incident post-mortems, ops reports, performance baselines, pattern library
- **Ongoing feedback to [Phase 3: Construction](PHASE-3-CONSTRUCTION.md):** Production insights inform future construction bolts (bug fixes, performance improvements, feature additions)

---

*Phase 5 is where the system meets reality. Good operations turn a hardened build into a reliable service. Great operations turn production data into continuous improvement fuel for [Phase 6: Evolution](PHASE-6-EVOLUTION.md).*
