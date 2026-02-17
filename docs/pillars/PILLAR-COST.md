# Pillar: Cost Awareness

**Cross-cutting concern active in ALL phases of the AI Development Life Cycle.**

Cost awareness is not an optimization you bolt on after launch. It is a design discipline woven into every phase, every architecture decision, and every deployment. Uncontrolled cloud spend is the silent project killer — it does not crash your app, it drains your budget until someone notices the invoice.

This pillar defines the patterns, controls, and practices that keep costs visible, predictable, and bounded from day one through production operations.

---

## Table of Contents

1. [Cost-Aware Architecture from Day One](#cost-aware-architecture-from-day-one)
2. [Budget Management Pattern](#budget-management-pattern)
3. [Kill Switch Design](#kill-switch-design)
4. [Cost Dashboard Requirements](#cost-dashboard-requirements)
5. [Cloud-Neutral Cost Patterns](#cloud-neutral-cost-patterns)
6. [FinOps Integration](#finops-integration)
7. [AI-Specific Cost Considerations](#ai-specific-cost-considerations)
8. [Phase-by-Phase Cost Activities](#phase-by-phase-cost-activities)
9. [Anti-Patterns](#anti-patterns)
10. [Templates and Cross-References](#templates-and-cross-references)

---

## Cost-Aware Architecture from Day One

Every architecture decision has a cost dimension. Evaluate it explicitly during design, not after the first invoice arrives.

### Right-Size Compute

Default to the smallest instance that meets your requirements. Scale up based on evidence, not assumption.

```
# Bad: defaulting to the biggest instance "just in case"
instance_type = "8xlarge"

# Good: start small, measure, scale with evidence
instance_type = "medium"  # Handles 500 req/s in load test
# Scale trigger: CPU > 70% sustained for 5 minutes
```

### Serverless vs Always-On

| Factor | Serverless | Always-On |
|--------|-----------|-----------|
| Traffic pattern | Spiky, unpredictable, low average | Steady, high-volume |
| Cost model | Pay per invocation | Pay per hour (running or not) |
| Break-even | Below ~1M invocations/month (varies) | Above break-even threshold |
| Cold starts | Acceptable (async, background) | Unacceptable (real-time) |

**Decision rule:** Start serverless. Move to always-on when utilization exceeds 40% consistently and cost analysis confirms savings.

### Caching Strategies

| Cache Layer | Use Case | TTL Guidance |
|-------------|----------|-------------|
| **Application** (in-memory) | Config, lookup tables | Minutes to hours |
| **Distributed** (Redis) | Sessions, API responses | Minutes to hours |
| **CDN** | Static assets, stable API responses | Hours to days |
| **LLM response** | Identical or similar prompts | Hours to days |

**Cost impact example:**
```
Without cache: 10,000 API calls/hr x $0.01/call = $72,000/month
With cache (95% hit rate): 500 calls/hr x $0.01 + $50/mo = $410/month
Savings: $71,590/month (99.4% reduction)
```

### Data Lifecycle Management

| Tier | Access Pattern | Cost (relative) |
|------|---------------|-----------------|
| **Hot** | Multiple times per day | $$$ |
| **Warm** | Weekly to monthly | $$ |
| **Cold** | Rarely (compliance, audit) | $ |
| **Frozen** | Legal hold, never unless required | cents |

Implement automatic tiering: move logs older than 30 days to warm, 90 days to cold, 1 year to frozen. Delete non-regulated data after retention expires.

### Reserved Capacity vs On-Demand

**Decision framework:**
1. Run on-demand for 2-3 months to establish baseline.
2. Identify the minimum always-on capacity (the floor).
3. Reserve the floor (30-72% savings). Keep on-demand for burst above the floor.
4. Re-evaluate quarterly as baselines shift.

---

## Budget Management Pattern

Implement all four steps. Skipping any step creates a gap that allows cost overruns to go undetected or uncontrolled.

```
┌──────────┐    ┌───────────┐    ┌─────────┐    ┌─────────────┐
│  MONITOR │───→│ DASHBOARD │───→│  ALERT  │───→│ KILL SWITCH │
│ Track    │    │ Visualize │    │ Notify  │    │ Stop spend  │
│ by tag   │    │ & forecast│    │ at %    │    │ immediately │
└──────────┘    └───────────┘    └─────────┘    └─────────────┘
```

### Step 1: Monitor
- [ ] Tag all resources with: `project`, `environment`, `team`, `service`, `cost-center`
- [ ] Enable cost allocation reports grouped by tags
- [ ] Track spend daily, not just monthly
- [ ] Separate spend by environment (dev / staging / prod)
- [ ] Track AI/ML-specific costs separately (GPU, API calls, training jobs)

### Step 2: Dashboard
- [ ] Display daily, weekly, and monthly spend by service
- [ ] Show trend lines and forecasted month-end spend
- [ ] Compare actual vs budgeted spend
- [ ] Highlight anomalies (spend > 2x normal daily average)
- [ ] Break down by environment so dev costs do not hide in prod totals

### Step 3: Alert

| Threshold | Action | Recipient |
|-----------|--------|-----------|
| 50% of monthly budget | Informational notification | Team lead |
| 75% of monthly budget | Warning — review trajectory | Team lead + finance |
| 90% of monthly budget | Urgent — evaluate kill switch | Team lead + management |
| 100% of monthly budget | Critical — activate kill switch or justify | Management + auto |
| Daily spend > 2x average | Immediate investigation | On-call engineer |

### Step 4: Kill Switch

See [Kill Switch Design](#kill-switch-design) below.

---

## Kill Switch Design

A kill switch is a mechanism to immediately stop or throttle resources generating unexpected costs. Every production system must have one.

### When to Trigger

| Trigger | Automation | Response |
|---------|-----------|----------|
| Budget exceeded (100%) | Automated or manual approval | Shut down non-prod, throttle prod |
| Anomaly (2x daily avg) | Alert + manual review | Investigate within 1 hour |
| Off-hours spike | Automated for non-prod | Shut down dev/staging outside business hours |
| Runaway training job | Automated (time/cost cap) | Kill job, preserve checkpoint |
| Compromised credentials | Automated + manual | Revoke keys, kill spawned resources |

### Implementation Patterns

**Pattern 1: Compute Kill Switch**
```python
def kill_switch_compute(event, context):
    """Stop all non-production compute resources."""
    instances = compute_client.list_instances(
        filters=[{"tag:environment": ["dev", "staging"]}, {"state": "running"}]
    )
    for instance in instances:
        compute_client.stop_instance(instance.id)
        log.warning(f"Kill switch: stopped {instance.id}")
    notify_team("Kill switch activated: non-prod compute stopped")
```

**Pattern 2: API Gateway Throttle**
```yaml
kill_switch_throttle:
  default_rate_limit: 10       # requests/sec (down from 1000)
  expensive_endpoints:
    /api/v1/generate:  0       # Disable (LLM-backed)
    /api/v1/analyze:   0       # Disable (GPU-backed)
    /api/v1/users:     10      # Reduce to minimum
```

**Pattern 3: Queue Pause**
```python
def kill_switch_queues(event, context):
    """Pause all non-critical queue consumers."""
    for queue in ["email-notifications", "report-generation", "ml-inference-batch"]:
        queue_client.pause_consumer(queue)
        log.warning(f"Kill switch: paused {queue}")
```

### Testing the Kill Switch

A kill switch that has never been tested will fail when you need it most.

- [ ] Test in non-prod environments monthly
- [ ] Verify resources actually stop (do not just check API responses)
- [ ] Measure time from trigger to full shutdown
- [ ] Verify clean restart after a kill switch event
- [ ] Document restart procedure alongside kill procedure
- [ ] Run a kill switch drill quarterly in production (off-peak)

---

## Cost Dashboard Requirements

### Minimum Viable Dashboard

| View | Granularity | Update Frequency |
|------|-------------|-----------------|
| Daily spend by service | Per-service | Daily |
| Weekly spend trend | Per-service | Weekly |
| Monthly spend vs budget | Per-environment | Daily (cumulative) |
| Forecast: projected month-end | Aggregate | Daily |
| Anomaly indicators | Per-service | Real-time or hourly |

### Anomaly Detection Rules

| Rule | Threshold | Action |
|------|-----------|--------|
| Daily spend spike | > 2x rolling 7-day average | Alert team lead |
| New service appears | Any new service incurring cost | Alert team lead |
| Off-hours compute | Non-prod running outside business hours | Auto-stop or alert |
| Storage growth rate | > 20% month-over-month | Review data lifecycle policies |
| Unused resources | < 5% utilization for 7 days | Flag for termination |

---

## Cloud-Neutral Cost Patterns

The patterns in this pillar are cloud-neutral. Map them to your provider using these equivalents.

### Monitoring and Budgets

| Capability | AWS | Azure | GCP |
|-----------|-----|-------|-----|
| Cost visibility | Cost Explorer | Cost Management + Billing | Cloud Billing Reports |
| Budget alerts | AWS Budgets | Azure Budgets | GCP Budget Alerts |
| Anomaly detection | Cost Anomaly Detection | Cost Management Anomaly Alerts | Billing Anomaly Detection |
| Recommendations | Trusted Advisor, Compute Optimizer | Azure Advisor | Active Assist, Recommender |
| Tag enforcement | Tag Policies (Organizations) | Azure Policy | Organization Policy |

### Budget Alert Example (AWS CloudFormation)

```yaml
Resources:
  MonthlyBudget:
    Type: AWS::Budgets::Budget
    Properties:
      Budget:
        BudgetName: project-monthly-budget
        BudgetLimit: { Amount: 5000, Unit: USD }
        TimeUnit: MONTHLY
      NotificationsWithSubscribers:
        - Notification:
            NotificationType: ACTUAL
            ComparisonOperator: GREATER_THAN
            Threshold: 75
          Subscribers:
            - { SubscriptionType: EMAIL, Address: team-lead@example.com }
```

> **Azure:** Use `Microsoft.Consumption/budgets` with `threshold` and `contactEmails` properties.
> **GCP:** Use `google_billing_budget` Terraform resource with `threshold_rules` and notification channels.

---

## FinOps Integration

For enterprise teams, integrate AI-DLC cost practices into a broader FinOps discipline.

### Tagging Strategy

| Tag Key | Purpose | Example Values |
|---------|---------|---------------|
| `project` | Cost allocation to project | `myapp`, `platform` |
| `environment` | Separate dev/staging/prod costs | `dev`, `staging`, `prod` |
| `team` | Chargeback to team | `backend`, `ml-team` |
| `service` | Identify individual services | `auth-api`, `inference` |
| `cost-center` | Finance department allocation | `CC-1001`, `CC-2050` |
| `owner` | Responsible individual or group | `jane.doe`, `ml-team` |
| `expiry` | Auto-cleanup for temporary resources | `2026-03-01`, `never` |

Enforce tagging: reject untagged resource creation, run weekly compliance scans, auto-tag resources created by CI/CD.

### Chargeback and Showback Models

| Model | When to Use |
|-------|------------|
| **Showback** | Building cost culture; report costs per team, no billing |
| **Chargeback** | Mature FinOps; charge costs to team budgets |
| **Shared cost allocation** | Distribute shared infrastructure proportionally |

### Reserved Instance Optimization

1. **Analyze** — Review 3 months of usage data to identify stable baselines.
2. **Calculate** — Compare on-demand vs reserved cost; determine break-even utilization.
3. **Purchase** — Reserve the stable baseline (typically 60-80% of peak).
4. **Monitor** — Track reservation utilization monthly.
5. **Adjust** — Modify or exchange reservations as workloads change.

### Spot / Preemptible Instance Usage

Use for fault-tolerant, interruptible workloads: batch processing, CI/CD build agents, model training (with checkpointing), dev/test environments, load testing. Do not use for production API serving (without fallback), stateful workloads, or time-critical jobs without retry logic.

---

## AI-Specific Cost Considerations

AI workloads introduce cost patterns that traditional applications do not have.

### LLM API Costs

| Optimization | Savings | Effort |
|-------------|---------|--------|
| **Response caching** | 80-95% for identical queries | Low |
| **Prompt caching** | 50-90% for repeated patterns | Low |
| **Batch API** | 30-50% (non-real-time) | Low |
| **Prompt optimization** | 10-30% (shorter prompts) | Medium |
| **Model routing** | 50-90% (cheaper model for simpler tasks) | Medium |
| **Fine-tuning** | Variable (fewer tokens per call) | High |

**Model routing example:**
```python
def select_model(task_complexity: str) -> str:
    """Route to cheapest model meeting quality requirements."""
    return {
        "simple":   "gpt-4o-mini",      # Classification, extraction
        "moderate": "gpt-4o",            # Summarization, code gen
        "complex":  "claude-opus-4-6",  # Multi-step reasoning
    }.get(task_complexity, "gpt-4o")
```

**Token budget enforcement:**
```python
DAILY_TOKEN_BUDGET = 1_000_000

def check_budget(tokens_used_today: int, request_tokens: int) -> bool:
    if tokens_used_today + request_tokens > DAILY_TOKEN_BUDGET:
        log.warning("Daily token budget exceeded. Request rejected.")
        return False
    return True
```

### Training vs Inference Cost Management

| Dimension | Training | Inference |
|-----------|----------|-----------|
| Cost profile | Large, infrequent, predictable | Small per-request, continuous |
| Kill switch | Time limit or cost cap | Budget threshold or anomaly |
| Optimization | Fewer epochs, mixed precision, smaller models | Caching, batching, distillation |
| Spot/preemptible | Viable with checkpointing | Risky for real-time serving |

### GPU Instance Management

- [ ] Never leave GPU instances idle. Auto-stop after 30 minutes of inactivity.
- [ ] Use spot instances for training. Save 60-90% with checkpointing.
- [ ] Right-size GPU memory to model size, not to "biggest available."
- [ ] Monitor GPU utilization. Below 50% means the instance is oversized.

### Model Selection: Cost/Performance

| Task | Cheap | Mid-Range | Premium |
|------|-------|-----------|---------|
| Classification | Fine-tuned small model | GPT-4o-mini / Haiku | GPT-4o / Sonnet |
| Summarization | GPT-4o-mini / Haiku | GPT-4o / Sonnet | Opus |
| Code generation | GPT-4o-mini / Haiku | Sonnet | Opus |
| Complex reasoning | — | Sonnet | Opus |

Start cheap. Upgrade only if accuracy demands it.

---

## Phase-by-Phase Cost Activities

### Phase 0: Foundation
- [ ] Define initial monthly budget target
- [ ] Select and configure cost monitoring tool
- [ ] Establish mandatory tagging strategy
- [ ] Document cost constraints in CLAUDE.md
- [ ] Create [Cost Management Guide](../../templates/COST-MANAGEMENT-GUIDE.md) from template

### Phase 1: Inception
- [ ] Estimate cost for each architectural option (order of magnitude)
- [ ] Include cost as a factor in architecture decision records (ADRs)
- [ ] Identify the most expensive components (databases, AI APIs, compute)
- [ ] Set per-service and per-environment budget targets

### Phase 2: Elaboration
- [ ] Refine cost estimates based on technical specifications
- [ ] Design caching strategies for expensive operations
- [ ] Plan data lifecycle policies (hot/warm/cold tiers)
- [ ] Document cost assumptions in the spec (request volumes, data sizes)

### Phase 3: Construction
- [ ] Implement resource tagging in all infrastructure code
- [ ] Add token/API call budgets to AI integrations
- [ ] Implement caching for expensive operations
- [ ] Monitor dev/staging costs (they predict prod costs)

### Phase 4: Hardening
- [ ] Build the cost dashboard
- [ ] Configure budget alerts at 50%, 75%, 90%, 100% thresholds
- [ ] Implement and test the kill switch
- [ ] Run cost projection for production traffic (use load test data)
- [ ] Verify all resources are tagged
- [ ] Right-size instance types based on load test metrics

### Phase 5: Operations
- [ ] Activate budget alerts for production
- [ ] Review cost dashboard weekly
- [ ] Investigate anomalies within 1 business day
- [ ] Test kill switch monthly (non-prod), quarterly (prod off-peak)
- [ ] Evaluate reserved capacity after 2-3 months of data

### Phase 6: Evolution
- [ ] Analyze cost trends over the past quarter
- [ ] Identify top 3 cost drivers; evaluate optimization opportunities
- [ ] Review and adjust reserved capacity
- [ ] Evaluate new pricing models (providers change frequently)
- [ ] Conduct FinOps review if operating at enterprise scale

---

## Anti-Patterns

| Anti-Pattern | Symptom | Fix |
|-------------|---------|-----|
| **"We'll optimize later"** | Cost not discussed until invoice shock | Include cost estimates in every ADR and spec |
| **GPU graveyard** | Idle GPU instances running 24/7 | Auto-stop after 30 min inactivity |
| **Untagged resources** | Cannot attribute costs to teams | Enforce tagging via policy |
| **Biggest instance syndrome** | Every service on largest instance | Start small; scale with evidence |
| **Cache-free architecture** | Every request hits DB or API directly | Cache anything called > 10x/min |
| **Alert fatigue** | Too many alerts, all ignored | Tune thresholds; route to right people |
| **Missing kill switch** | No way to stop runaway costs | Build and test during Phase 4 |
| **Token hemorrhage** | LLM costs grow linearly, no caching | Cache responses; route to cheaper models |
| **Dev equals prod** | Dev environments mirror prod sizing | Right-size dev; auto-stop off-hours |

---

## Templates and Cross-References

### Templates

- [Cost Management Guide Template](../../templates/COST-MANAGEMENT-GUIDE.md) — Copy, customize, and maintain for your project.

### Cross-References

This pillar applies to every phase:

- [Phase 0: Foundation](../framework/PHASE-0-FOUNDATION.md) — Set budget targets and monitoring
- [Phase 1: Inception](../framework/PHASE-1-INCEPTION.md) — Cost-aware architecture decisions
- [Phase 2: Elaboration](../framework/PHASE-2-ELABORATION.md) — Refine estimates, plan caching
- [Phase 3: Construction](../framework/PHASE-3-CONSTRUCTION.md) — Implement tagging, budgets, caching
- [Phase 4: Hardening](../framework/PHASE-4-HARDENING.md) — Dashboard, alerts, kill switch, cost projection
- [Phase 5: Operations](../framework/PHASE-5-OPERATIONS.md) — Monitor, alert, optimize, test kill switch
- [Phase 6: Evolution](../framework/PHASE-6-EVOLUTION.md) — Trend analysis, reservation review, FinOps

### Related Pillars

- [Security Pillar](PILLAR-SECURITY.md) — Compromised credentials can cause massive cost spikes.
- [Quality Pillar](PILLAR-QUALITY.md) — Performance testing provides data for right-sizing.
- [Traceability Pillar](PILLAR-TRACEABILITY.md) — Cost decisions are recorded in captain's logs.
