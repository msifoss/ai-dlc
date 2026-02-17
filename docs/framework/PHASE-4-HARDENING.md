# Phase 4: Hardening — Production Readiness

> "Features complete" does not equal "production ready." The Hardening phase is the key innovation of AI-DLC — dedicated work between Construction and Operations that transforms working code into production-grade software.

---

## Purpose

Phase 4 closes the gap between "it works on my machine" and "it runs reliably in production at scale." This phase dedicates focused effort to security, monitoring, cost controls, and operational readiness — the work that traditional projects skip, defer, or discover the hard way in production.

In real-world practice, hardening consumed **4 dedicated bolts** organized around specific themes:

| Bolt | Focus | Typical Outcomes |
|------|-------|-----------------|
| H1 | Alarms + Monitoring | CloudWatch/Datadog alarms on every critical path, dashboards |
| H2 | Security Fixes | 200+ findings triaged, critical/high items remediated |
| H3 | Cost Controls | Budget alarms, spend dashboards, kill switches for runaway costs |
| H4 | Ops Readiness Verification | 47-item checklist scored, runbooks drafted, rollback tested |

This is not optional polish. This is the phase that determines whether your system survives its first week in production.

---

## Entry Criteria

Before starting Hardening, verify:

- [ ] All planned construction bolts are complete ([Phase 3: Construction](PHASE-3-CONSTRUCTION.md))
- [ ] Core functionality passes acceptance tests (unit + integration)
- [ ] Test coverage meets project minimum (recommend 80%+ line coverage)
- [ ] Code is merged to a release-candidate branch
- [ ] No critical or high-severity bugs remain in the backlog
- [ ] Architecture decision records (ADRs) are current
- [ ] [Traceability matrix](../../templates/TRACEABILITY-MATRIX.md) maps all requirements to tests
- [ ] Human decision gate: **Product owner confirms feature-complete status**

---

## Activities

### 4.1 Five-Persona Adversarial Security Review

The five-persona review is AI-DLC's signature security practice. A single AI reviews the same codebase from five hostile perspectives, each producing independent findings. In practice, this generates **200+ findings** across a medium-sized application.

#### The Five Personas

| Persona | Perspective | What They Look For |
|---------|------------|-------------------|
| **Attacker** | "How do I break in?" | Injection vectors, auth bypasses, SSRF, exposed secrets, insecure deserialization |
| **Auditor** | "Does this meet compliance standards?" | OWASP Top 10, data classification, encryption, audit logging, regulatory gaps |
| **Ops Engineer** | "What wakes me up at 3 AM?" | Missing error handling, silent failures, unmonitored paths, missing DLQs, retry storms |
| **Cost Analyst** | "What costs money I don't expect?" | Unbounded queries, missing pagination, runaway Lambda invocations, unthrottled APIs |
| **End User** | "What exposes my data or degrades my experience?" | PII leaks, broken error messages, missing rate limits, confusing failure modes |

#### Running the Review

1. **Prepare the scope.** Identify all modules, API endpoints, infrastructure definitions, and frontend assets to review.
2. **Execute each persona independently.** Do not cross-contaminate — each persona operates with its own threat model.
3. **Collect findings in structured format:**

```markdown
## Finding: [SEVERITY] Short Description

- **Persona:** Attacker | Auditor | Ops Engineer | Cost Analyst | End User
- **Severity:** Critical | High | Medium | Low | Informational
- **Location:** `path/to/file.py:42`
- **Description:** What the issue is and why it matters.
- **Recommendation:** Specific fix with code example.
- **Effort:** S | M | L | XL
```

4. **Triage findings by severity.** Classify using this priority matrix:

| Severity | Action | Timeline |
|----------|--------|----------|
| Critical | Block release — fix immediately | Before exit gate |
| High | Fix before production deployment | During hardening bolts |
| Medium | Fix within first operations cycle | Phase 5, Sprint 1 |
| Low | Track in backlog | Phase 6 or later |
| Informational | Document for future reference | No deadline |

5. **Produce the security review report.** Aggregate findings, calculate severity distribution, and list remediation status.

> **Practical example:** In the CallHero project, the five-persona review produced 217 findings: 12 critical, 38 high, 89 medium, 54 low, 24 informational. All critical and high items were resolved in Bolt H2.

#### Cross-Reference

- Full methodology: [Five-Persona Review](../reference/FIVE-PERSONA-REVIEW.md)
- Protocol template: [SECURITY-REVIEW-PROTOCOL.md](../../templates/SECURITY-REVIEW-PROTOCOL.md)
- Security pillar: [Pillar: Security](../pillars/PILLAR-SECURITY.md)

---

### 4.2 Operational Readiness Checklist

Score your system against 47 items across 8 categories. Each item scores 0 (not done), 1 (partial), or 2 (complete). A production-ready system scores **85+/94**.

#### Category 1: Logging (6 items)

| # | Item | Score |
|---|------|-------|
| 1 | Structured logging (JSON) in all services | /2 |
| 2 | Correlation IDs propagated across service boundaries | /2 |
| 3 | Log levels used correctly (ERROR, WARN, INFO, DEBUG) | /2 |
| 4 | Sensitive data excluded from logs (PII, tokens, passwords) | /2 |
| 5 | Log retention policy configured (30/60/90 days per tier) | /2 |
| 6 | Log aggregation in central platform (CloudWatch Logs, ELK, Datadog) | /2 |

#### Category 2: Monitoring (7 items)

| # | Item | Score |
|---|------|-------|
| 7 | Health check endpoints on all services | /2 |
| 8 | Latency metrics (p50, p95, p99) on critical paths | /2 |
| 9 | Error rate alarms on all API endpoints | /2 |
| 10 | Throughput metrics on async processors | /2 |
| 11 | Resource utilization tracked (CPU, memory, connections) | /2 |
| 12 | Dashboard with real-time system overview | /2 |
| 13 | Synthetic canary tests on critical user journeys | /2 |

#### Category 3: Alerting (6 items)

| # | Item | Score |
|---|------|-------|
| 14 | Alarms on every critical path (API errors, queue depth, Lambda failures) | /2 |
| 15 | Escalation paths defined (page on-call, then team lead, then manager) | /2 |
| 16 | Alert fatigue mitigated (tuned thresholds, grouped notifications) | /2 |
| 17 | Alarm actions configured (auto-scale, circuit break, notify) | /2 |
| 18 | Notification channels tested (email, Slack, PagerDuty) | /2 |
| 19 | Alarm runbooks linked to each alarm | /2 |

#### Category 4: Error Handling (6 items)

| # | Item | Score |
|---|------|-------|
| 20 | All external calls wrapped in try/catch with specific error types | /2 |
| 21 | User-facing errors return safe messages (no stack traces, no internal IDs) | /2 |
| 22 | Error responses include correlation IDs for support debugging | /2 |
| 23 | Unhandled exception handlers configured (global catch, process crash handler) | /2 |
| 24 | Error budgets defined for critical services (99.9% = 8.7h/year downtime) | /2 |
| 25 | Graceful degradation paths for non-critical dependencies | /2 |

#### Category 5: Retry Logic and Resilience (6 items)

| # | Item | Score |
|---|------|-------|
| 26 | Retry with exponential backoff on transient failures | /2 |
| 27 | Maximum retry count configured (prevent infinite loops) | /2 |
| 28 | Dead letter queues (DLQs) on all async processors | /2 |
| 29 | DLQ alarms and reprocessing procedures documented | /2 |
| 30 | Circuit breakers on external dependencies | /2 |
| 31 | Idempotency keys on write operations (prevent duplicate processing) | /2 |

#### Category 6: Data Integrity (5 items)

| # | Item | Score |
|---|------|-------|
| 32 | Database backups configured and tested | /2 |
| 33 | Point-in-time recovery enabled | /2 |
| 34 | Data migration scripts tested (forward and rollback) | /2 |
| 35 | Schema versioning in place | /2 |
| 36 | Data validation at service boundaries (input + output) | /2 |

#### Category 7: Security Hardening (6 items)

| # | Item | Score |
|---|------|-------|
| 37 | IAM roles follow least-privilege principle | /2 |
| 38 | Secrets stored in secrets manager (not environment variables) | /2 |
| 39 | Encryption at rest enabled on all data stores | /2 |
| 40 | Encryption in transit (TLS 1.2+) on all connections | /2 |
| 41 | SRI hashes on frontend static assets | /2 |
| 42 | Dependency vulnerability scan passes (pip-audit, npm audit) | /2 |

#### Category 8: Deployment Readiness (5 items)

| # | Item | Score |
|---|------|-------|
| 43 | Rollback procedure documented and tested | /2 |
| 44 | Feature flags for risky functionality | /2 |
| 45 | Deployment does not require manual steps | /2 |
| 46 | Environment parity verified (dev matches staging matches prod) | /2 |
| 47 | Smoke tests run automatically after deployment | /2 |

**Scoring thresholds:**

| Score | Status | Action |
|-------|--------|--------|
| 85-94 | Production ready | Proceed to Phase 5 |
| 70-84 | Conditionally ready | Fix gaps, re-score in 48 hours |
| Below 70 | Not ready | Return to hardening bolts, address deficiencies |

#### Cross-Reference

- Full template: [OPS-READINESS-CHECKLIST.md](../../templates/OPS-READINESS-CHECKLIST.md)
- Quality pillar: [Pillar: Quality](../pillars/PILLAR-QUALITY.md)

---

### 4.3 Cost Management Implementation

Cost awareness is a first-class citizen in AI-DLC. During hardening, implement the full cost control stack: **Monitor, Dashboard, Kill Switch**.

#### Step 1: Monitor Current Spend

Establish a baseline before setting thresholds.

```bash
# AWS example: Get last 30 days of cost by service
aws ce get-cost-and-usage \
  --time-period Start=2024-01-01,End=2024-01-31 \
  --granularity DAILY \
  --metrics BlendedCost \
  --group-by Type=DIMENSION,Key=SERVICE
```

Document the cost baseline:

| Service | Monthly Baseline | Expected Growth | Budget Limit |
|---------|-----------------|-----------------|--------------|
| Compute (Lambda/EC2/Functions) | $X | +20%/month | $Y |
| Database (RDS/DynamoDB/Cosmos) | $X | +10%/month | $Y |
| Storage (S3/Blob/GCS) | $X | +5%/month | $Y |
| API Gateway | $X | Proportional to traffic | $Y |
| AI/ML Services (Bedrock/OpenAI) | $X | Varies with usage | $Y |
| **Total** | **$X** | | **$Y** |

#### Step 2: Build Cost Dashboard

Create a dashboard that answers three questions at a glance:
1. **What are we spending right now?** (Real-time or near-real-time)
2. **Are we trending within budget?** (Projection vs. limit)
3. **What is driving cost?** (Breakdown by service, function, endpoint)

```python
# Example: CloudWatch dashboard definition (infrastructure-as-code)
cost_dashboard = {
    "widgets": [
        {"type": "metric", "title": "Daily Spend", "metrics": ["AWS/Billing"]},
        {"type": "metric", "title": "Lambda Invocations", "metrics": ["AWS/Lambda"]},
        {"type": "metric", "title": "API Requests", "metrics": ["AWS/ApiGateway"]},
        {"type": "metric", "title": "DB Read/Write Units", "metrics": ["AWS/DynamoDB"]},
    ]
}
```

> **Azure sidebar:** Use Azure Cost Management + Budgets API. **GCP sidebar:** Use Cloud Billing Budgets API with Pub/Sub notifications.

#### Step 3: Implement Kill Switches

Kill switches prevent runaway costs by automatically throttling or disabling expensive operations when thresholds are breached.

| Trigger | Threshold | Action |
|---------|-----------|--------|
| Daily spend exceeds 2x baseline | $X/day | Alert team, throttle non-critical APIs |
| AI/ML service spend exceeds budget | $Y/month | Disable AI features, fall back to cached responses |
| Lambda concurrent executions spike | 500+ concurrent | Reserved concurrency limit, queue overflow to DLQ |
| Database read units exceed 3x baseline | X RCU/sec | Enable read replica, throttle non-critical reads |
| Total monthly spend hits 80% of budget | 80% of $Z | Alert with projected overage and recommended actions |

```python
# Example: Lambda kill switch using reserved concurrency
import boto3

def cost_kill_switch(event, context):
    """Triggered by CloudWatch alarm when spend exceeds threshold."""
    lambda_client = boto3.client('lambda')

    # Throttle non-critical functions to 0 concurrency
    non_critical_functions = ['report-generator', 'analytics-processor']
    for func in non_critical_functions:
        lambda_client.put_function_concurrency(
            FunctionName=func,
            ReservedConcurrentExecutions=0  # Effectively disables the function
        )

    # Notify team
    sns_client = boto3.client('sns')
    sns_client.publish(
        TopicArn='arn:aws:sns:us-east-1:123456789:cost-alerts',
        Subject='COST KILL SWITCH ACTIVATED',
        Message=f'Daily spend exceeded threshold. Non-critical functions disabled.'
    )
```

#### Cross-Reference

- Full guide: [COST-MANAGEMENT-GUIDE.md](../../templates/COST-MANAGEMENT-GUIDE.md)
- Cost pillar: [Pillar: Cost Awareness](../pillars/PILLAR-COST.md)

---

### 4.4 Infrastructure Hardening

Harden every infrastructure component to handle failures gracefully, alert operators immediately, and recover automatically where possible.

#### Alarms for Every Critical Path

Map each critical path to an alarm:

| Critical Path | Metric | Alarm Threshold | Action |
|---------------|--------|-----------------|--------|
| API health | 5xx error rate | > 1% for 5 min | Page on-call, trigger runbook |
| Async processing | Queue age | > 300 seconds | Scale consumers, alert team |
| Database | Connection count | > 80% max | Alert team, investigate queries |
| Authentication | Login failure rate | > 10% for 5 min | Alert security, check for brute force |
| Background jobs | DLQ message count | > 0 | Alert team, investigate failures |
| Cost | Daily spend | > 2x baseline | Trigger kill switch |

```yaml
# Example: CloudFormation alarm definition
ApiErrorAlarm:
  Type: AWS::CloudWatch::Alarm
  Properties:
    AlarmName: api-5xx-error-rate
    MetricName: 5XXError
    Namespace: AWS/ApiGateway
    Statistic: Average
    Period: 300
    EvaluationPeriods: 1
    Threshold: 0.01
    ComparisonOperator: GreaterThanThreshold
    AlarmActions:
      - !Ref OpsAlertTopic
    TreatMissingData: notBreaching
```

#### Dead Letter Queues for Async Processing

Every queue consumer must have a DLQ configured:

```yaml
# Example: SQS queue with DLQ
MainQueue:
  Type: AWS::SQS::Queue
  Properties:
    QueueName: order-processing
    VisibilityTimeout: 300
    RedrivePolicy:
      deadLetterTargetArn: !GetAtt OrderDLQ.Arn
      maxReceiveCount: 3  # Move to DLQ after 3 failed attempts

OrderDLQ:
  Type: AWS::SQS::Queue
  Properties:
    QueueName: order-processing-dlq
    MessageRetentionPeriod: 1209600  # 14 days
```

#### Retry with Exponential Backoff

Implement retry logic with jitter to prevent thundering herd:

```python
import time
import random

def retry_with_backoff(func, max_retries=5, base_delay=1.0):
    """Retry with exponential backoff and jitter."""
    for attempt in range(max_retries):
        try:
            return func()
        except TransientError as e:
            if attempt == max_retries - 1:
                raise  # Final attempt failed — propagate error
            delay = base_delay * (2 ** attempt) + random.uniform(0, 1)
            time.sleep(delay)
```

#### Circuit Breaker Pattern

Protect services from cascading failures:

```python
class CircuitBreaker:
    def __init__(self, failure_threshold=5, recovery_timeout=60):
        self.failure_count = 0
        self.failure_threshold = failure_threshold
        self.recovery_timeout = recovery_timeout
        self.state = "CLOSED"  # CLOSED | OPEN | HALF_OPEN
        self.last_failure_time = None

    def call(self, func):
        if self.state == "OPEN":
            if time.time() - self.last_failure_time > self.recovery_timeout:
                self.state = "HALF_OPEN"
            else:
                raise CircuitOpenError("Circuit breaker is open")

        try:
            result = func()
            if self.state == "HALF_OPEN":
                self.state = "CLOSED"
                self.failure_count = 0
            return result
        except Exception as e:
            self.failure_count += 1
            self.last_failure_time = time.time()
            if self.failure_count >= self.failure_threshold:
                self.state = "OPEN"
            raise
```

---

### 4.5 Security Hardening

#### SRI Hashes for Frontend Assets

Generate Subresource Integrity hashes for all externally loaded scripts and stylesheets:

```bash
# Generate SRI hash
cat bundle.js | openssl dgst -sha384 -binary | openssl base64 -A
```

```html
<script src="https://cdn.example.com/bundle.js"
        integrity="sha384-oqVuAfXRKap7fdgcCY5uykM6+R9GqQ8K/uxy9rx7HNQlGYl1kPzQho1wx4JwY8w"
        crossorigin="anonymous"></script>
```

#### Encryption Verification

Run this checklist:

- [ ] All S3 buckets/Blob containers/GCS buckets have encryption at rest enabled
- [ ] All database instances use encryption at rest (AES-256 or equivalent)
- [ ] All API endpoints enforce TLS 1.2 or higher
- [ ] All inter-service communication uses TLS
- [ ] Certificate expiration monitored with alarms (30-day, 7-day warnings)
- [ ] No hardcoded secrets in source code (scan with `trufflehog`, `gitleaks`, or `detect-secrets`)

#### IAM Audit (Least-Privilege)

Review every IAM role/service principal against least-privilege:

```bash
# AWS example: Find overly permissive policies
aws iam list-policies --scope Local --query 'Policies[?contains(PolicyName, `Admin`)]'

# Check for wildcard actions
aws iam get-policy-version --policy-arn <arn> --version-id v1 \
  --query 'PolicyVersion.Document.Statement[?Effect==`Allow`].Action' | grep '"*"'
```

Produce an IAM audit table:

| Role | Current Permissions | Required Permissions | Action |
|------|-------------------|---------------------|--------|
| api-lambda-role | `s3:*`, `dynamodb:*` | `s3:GetObject`, `s3:PutObject`, `dynamodb:Query`, `dynamodb:PutItem` | Restrict to specific actions and resources |
| deploy-role | `AdministratorAccess` | Specific deploy permissions | Create scoped deploy policy |

---

### 4.6 Performance and Load Testing

Validate the system handles expected and peak load:

#### Performance Testing Approach

1. **Establish baselines.** Measure p50, p95, p99 latency for all API endpoints under normal load.
2. **Define targets.** Set performance budgets based on user experience requirements.
3. **Run load tests.** Use tools like `k6`, `locust`, `artillery`, or `JMeter`.
4. **Stress test.** Push beyond expected peak (2x-5x normal) to identify breaking points.
5. **Soak test.** Run sustained load for 4-8 hours to detect memory leaks and resource exhaustion.

```javascript
// Example: k6 load test script
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 100 },   // Ramp up to 100 users
    { duration: '5m', target: 100 },   // Sustain 100 users
    { duration: '2m', target: 200 },   // Ramp up to 200 users (peak)
    { duration: '5m', target: 200 },   // Sustain peak
    { duration: '2m', target: 0 },     // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],  // 95% of requests under 500ms
    http_req_failed: ['rate<0.01'],    // Less than 1% failure rate
  },
};

export default function () {
  const res = http.get('https://api.example.com/health');
  check(res, { 'status 200': (r) => r.status === 200 });
  sleep(1);
}
```

#### Performance Budget

| Endpoint | p50 Target | p95 Target | p99 Target | Max Throughput |
|----------|-----------|-----------|-----------|----------------|
| GET /api/health | < 50ms | < 100ms | < 200ms | 1000 rps |
| POST /api/orders | < 200ms | < 500ms | < 1000ms | 100 rps |
| GET /api/reports | < 500ms | < 1500ms | < 3000ms | 50 rps |

---

### 4.7 Dependency Vulnerability Scanning

Scan all dependency trees for known vulnerabilities before every release.

#### Tool Matrix

| Ecosystem | Tool | Command | Integration |
|-----------|------|---------|-------------|
| Python | pip-audit | `pip-audit --strict` | CI pipeline, pre-commit |
| Node.js | npm audit | `npm audit --audit-level=high` | CI pipeline, pre-commit |
| Multi-language | Snyk | `snyk test` | CI pipeline, GitHub integration |
| Multi-language | Dependabot | GitHub configuration | Automated PRs |
| Container | Trivy | `trivy image myapp:latest` | CI pipeline |
| IaC | checkov | `checkov -d .` | CI pipeline |

#### Vulnerability Triage

```yaml
# Example: .snyk policy file for accepted risks
ignore:
  SNYK-PYTHON-REQUESTS-5595532:
    - '*':
        reason: 'Low severity, no exposure in our usage pattern'
        expires: '2025-03-01'  # Re-evaluate before this date
```

| Severity | Policy |
|----------|--------|
| Critical | Block deployment. Fix or remove dependency within 24 hours. |
| High | Block deployment. Fix within current hardening cycle. |
| Medium | Track in backlog. Fix within 30 days. |
| Low | Track in backlog. Fix at next dependency update cycle. |

---

## The 4 Bolts of Hardening

Organize hardening work into four focused bolts. Each bolt has a clear objective, activities, and exit condition.

### Bolt H1: Alarms + Monitoring

**Objective:** Ensure the system signals when something goes wrong before users notice.

| Activity | Deliverable |
|----------|-------------|
| Map every critical path to a metric | Critical path inventory |
| Create alarms with tuned thresholds | Alarm definitions in IaC |
| Build operational dashboard | Dashboard URL documented |
| Configure notification channels | PagerDuty/Slack/email tested |
| Deploy synthetic canary tests | Canary scripts running |

**Exit condition:** Every critical path has an alarm. Dashboard shows system health at a glance. Canary tests run on schedule.

### Bolt H2: Security Fixes

**Objective:** Remediate all critical and high findings from the five-persona review.

| Activity | Deliverable |
|----------|-------------|
| Execute five-persona adversarial review | Findings report (200+ items) |
| Triage findings by severity | Prioritized findings list |
| Fix all critical findings | Code changes, verified |
| Fix all high findings | Code changes, verified |
| Run dependency vulnerability scan | Clean scan report |
| Verify encryption at rest and in transit | Encryption audit checklist |
| Audit IAM for least-privilege | IAM audit table |

**Exit condition:** Zero critical findings. Zero high findings. Dependency scan passes. IAM audit complete.

### Bolt H3: Cost Controls

**Objective:** Prevent runaway costs and establish visibility into spend.

| Activity | Deliverable |
|----------|-------------|
| Document cost baseline | Cost baseline table |
| Set budget alarms | Budget alarm configuration |
| Build cost dashboard | Dashboard URL documented |
| Implement kill switches | Kill switch functions deployed |
| Test kill switch activation | Test results documented |
| Review AI/ML service usage costs | AI cost analysis |

**Exit condition:** Cost dashboard live. Budget alarms configured. Kill switches deployed and tested.

### Bolt H4: Ops Readiness Verification

**Objective:** Verify the system is ready for production operation.

| Activity | Deliverable |
|----------|-------------|
| Score the 47-item ops readiness checklist | Completed checklist with score |
| Run performance/load tests | Performance test report |
| Draft initial runbooks | Runbook documents |
| Test rollback procedure | Rollback test results |
| Verify environment parity | Environment comparison report |
| Conduct final ops review | Ops review sign-off |

**Exit condition:** Ops readiness score >= 85/94. Performance meets targets. Rollback procedure tested. Runbooks drafted.

---

## Deliverables

| Deliverable | Description | Template |
|-------------|-------------|----------|
| Security review report | All findings from five-persona review with severity, status | [SECURITY-REVIEW-PROTOCOL.md](../../templates/SECURITY-REVIEW-PROTOCOL.md) |
| Ops readiness scorecard | 47-item checklist with scores | [OPS-READINESS-CHECKLIST.md](../../templates/OPS-READINESS-CHECKLIST.md) |
| Cost management plan | Baseline, dashboard, budget alarms, kill switches | [COST-MANAGEMENT-GUIDE.md](../../templates/COST-MANAGEMENT-GUIDE.md) |
| Security policy | Updated with hardening findings | [SECURITY.md](../../templates/SECURITY.md) |
| Performance test report | Load test results against targets | (project-specific) |
| Dependency scan report | Clean vulnerability scan | (CI artifact) |
| IAM audit report | Least-privilege verification | (project-specific) |
| Alarm inventory | Every alarm with threshold and runbook link | (project-specific) |
| Captain's logs | H1-H4 bolt logs | [Phase 3 log format](PHASE-3-CONSTRUCTION.md) |

---

## Exit Criteria

Before advancing to [Phase 5: Operations](PHASE-5-OPERATIONS.md), verify:

- [ ] Five-persona security review complete — zero critical, zero high findings
- [ ] Ops readiness checklist scored >= 85/94
- [ ] Cost dashboard live and budget alarms active
- [ ] Kill switches deployed and tested
- [ ] All critical paths have alarms with tested notification channels
- [ ] DLQs configured on all async processors with alarms
- [ ] Dependency vulnerability scan passes (zero critical/high)
- [ ] Encryption at rest and in transit verified
- [ ] IAM audit complete — least-privilege confirmed
- [ ] Performance testing complete — targets met
- [ ] Rollback procedure documented and tested
- [ ] SRI hashes applied to frontend assets (if applicable)
- [ ] Human decision gate: **Security lead and ops lead sign off on production readiness**

---

## Human Decision Gates

| Gate | Decision Maker | Question | Artifacts Required |
|------|---------------|----------|-------------------|
| Feature freeze confirmation | Product owner | Are all planned features complete? | Traceability matrix, test results |
| Security review acceptance | Security lead | Are residual security risks acceptable? | Security review report, remediation evidence |
| Ops readiness approval | Ops lead / SRE | Is this system safe to run in production? | Ops readiness scorecard, alarm inventory, runbooks |
| Cost controls approval | Budget owner | Are cost controls adequate to prevent surprises? | Cost baseline, dashboard, kill switch test results |
| Go/No-go for deployment | Project sponsor | Considering all factors, do we proceed to production? | All hardening deliverables |

---

## Templates

- [SECURITY-REVIEW-PROTOCOL.md](../../templates/SECURITY-REVIEW-PROTOCOL.md) — Five-persona review methodology and findings template
- [OPS-READINESS-CHECKLIST.md](../../templates/OPS-READINESS-CHECKLIST.md) — 47-item scored checklist
- [COST-MANAGEMENT-GUIDE.md](../../templates/COST-MANAGEMENT-GUIDE.md) — Monitor, dashboard, kill switch implementation
- [SECURITY.md](../../templates/SECURITY.md) — Security policy and practices documentation

---

## Pillar Checkpoints

### Security Pillar

- [ ] Five-persona adversarial review complete
- [ ] All critical and high findings remediated
- [ ] Dependency vulnerability scan passes
- [ ] Encryption at rest and in transit verified
- [ ] IAM least-privilege audit complete
- [ ] SRI hashes on frontend assets
- [ ] Secrets stored in secrets manager (not code or environment variables)
- [ ] Security policy ([SECURITY.md](../../templates/SECURITY.md)) updated with hardening findings

### Quality Pillar

- [ ] All tests pass (unit, integration, end-to-end)
- [ ] Test coverage meets project minimum
- [ ] Performance testing complete and targets met
- [ ] Load testing identifies no critical bottlenecks
- [ ] Error handling covers all external call sites
- [ ] Retry logic and circuit breakers tested

### Traceability Pillar

- [ ] [Traceability matrix](../../templates/TRACEABILITY-MATRIX.md) current: requirements map to tests map to code
- [ ] Security findings traced to code locations and fix commits
- [ ] Captain's logs (H1-H4) document all hardening decisions
- [ ] Ops readiness checklist version-controlled

### Cost Awareness Pillar

- [ ] Cost baseline documented
- [ ] Budget alarms configured and tested
- [ ] Cost dashboard deployed and accessible
- [ ] Kill switches implemented, deployed, and tested
- [ ] AI/ML service costs reviewed and throttling configured
- [ ] Cost projections documented for 3-month and 12-month horizons

---

## Anti-Patterns

Avoid these common hardening mistakes:

| Anti-Pattern | Why It Fails | Instead |
|-------------|-------------|---------|
| Skipping hardening ("we'll fix it in prod") | Production incidents on day one | Dedicate 4 bolts to hardening |
| Alarm-free deployments | Silent failures accumulate until catastrophic | Alarm every critical path |
| Permissive IAM ("just give it admin") | Blast radius of compromise is total | Audit every role for least-privilege |
| No cost controls | $50 prototype becomes $5,000 surprise | Implement kill switches before production |
| Security review as checkbox | Generic review misses context-specific risks | Five-persona review from hostile perspectives |
| No DLQs on async processors | Failed messages vanish silently | DLQ + alarm + reprocessing procedure |
| Hardcoded thresholds | Alarm thresholds drift from reality | Review and tune thresholds monthly |

---

## Relationship to Other Phases

- **Inputs from [Phase 3: Construction](PHASE-3-CONSTRUCTION.md):** Working code with tests, architecture decision records, captain's logs
- **Outputs to [Phase 5: Operations](PHASE-5-OPERATIONS.md):** Hardened system with alarms, dashboards, runbooks, cost controls, security clearance
- **Ongoing interaction with [Phase 6: Evolution](PHASE-6-EVOLUTION.md):** Medium/low findings from hardening feed the evolution backlog

---

*Phase 4 is where AI-DLC earns its name. Any framework can describe how to build software. AI-DLC describes how to build software that survives production.*
