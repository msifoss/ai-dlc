# Cost Management Guide

> **AI-DLC Reference:** Created in **Phase 0: Discovery**, implemented in **Phase 4: Hardening**.
>
> Copy this template into your project and fill in all `<!-- TODO: ... -->` sections.

---

## 1. Project Budget

<!-- TODO: Define your budget targets. -->

| Period | Budget | Notes |
|---|---|---|
| **Monthly Target** | *$X,XXX* | Steady-state operating cost |
| **Quarterly Target** | *$XX,XXX* | Monthly target x 3, plus buffer |
| **Annual Target** | *$XXX,XXX* | Full-year projection |
| **One-Time Setup** | *$X,XXX* | Initial infrastructure provisioning, migrations |

### Budget Breakdown by Category

| Category | Monthly Allocation | % of Total |
|---|---|---|
| Compute (servers / containers / serverless) | *$<!-- TODO -->* | *<!-- TODO -->%* |
| Database and storage | *$<!-- TODO -->* | *<!-- TODO -->%* |
| Networking (bandwidth, CDN, DNS) | *$<!-- TODO -->* | *<!-- TODO -->%* |
| AI / LLM services | *$<!-- TODO -->* | *<!-- TODO -->%* |
| Monitoring and logging | *$<!-- TODO -->* | *<!-- TODO -->%* |
| CI/CD pipeline | *$<!-- TODO -->* | *<!-- TODO -->%* |
| Misc (domains, certificates, SaaS tools) | *$<!-- TODO -->* | *<!-- TODO -->%* |
| **Buffer (10-15% of total)** | *$<!-- TODO -->* | *<!-- TODO -->%* |
| **Total** | *$<!-- TODO -->* | 100% |

---

## 2. Cost Tracking Setup

### Tagging Strategy

All cloud resources must be tagged with the following labels for cost allocation.

| Tag Key | Required | Example Value | Purpose |
|---|---|---|---|
| `project` | Yes | `myproject` | Top-level cost grouping |
| `environment` | Yes | `dev` / `staging` / `prod` | Per-environment cost tracking |
| `team` | Yes | `backend` / `frontend` / `infra` | Per-team cost attribution |
| `component` | Yes | `api` / `web` / `worker` / `database` | Per-component cost tracking |
| `owner` | Recommended | `jsmith` | Individual accountability |
| `cost-center` | If applicable | `engineering-2026` | Finance/accounting alignment |
| `managed-by` | Recommended | `terraform` / `manual` | Track IaC vs. manual resources |

<!-- TODO: Adjust tag keys to match your organization's conventions. -->

### Cost Allocation Rules

- Every resource must have at least the four required tags.
- Untagged resources are flagged in weekly cost reviews and assigned an owner within 48 hours.
- Shared resources (e.g., VPC, load balancer) are allocated proportionally across teams.

---

## 3. Dashboard Requirements

### Primary Cost Dashboard

<!-- TODO: Select your dashboard tool and configure these views. -->

**Tool:** *Cloud provider console / Grafana / custom dashboard*

| Panel | Description | Refresh Rate |
|---|---|---|
| Total spend (MTD) | Current month total vs. budget | Hourly |
| Spend by environment | Stacked bar: dev / staging / prod | Hourly |
| Spend by category | Pie chart: compute, database, AI, etc. | Hourly |
| Daily burn rate | Line chart: daily cost over past 30 days | Daily |
| Projected month-end | Extrapolated from current burn rate | Daily |
| Top 10 resources | Table of most expensive individual resources | Daily |
| AI/LLM token usage | Token consumption and cost by model | Hourly |
| Budget remaining | Gauge chart: remaining budget this month | Hourly |

### Dashboard Access

| Role | Access Level |
|---|---|
| Finance / Management | Read-only, all environments |
| Tech Lead | Read-only, all environments |
| Developers | Read-only, dev environment only |
| Infra / DevOps | Read-write, all environments |

---

## 4. Alert Thresholds

### Budget Alerts

| Threshold | % of Monthly Budget | Action |
|---|---|---|
| **Info** | 50% | Notification to cost dashboard and team channel |
| **Warning** | 75% | Notification to Tech Lead and Project Owner |
| **Critical** | 90% | Notification to Tech Lead, Project Owner, and Finance |
| **Emergency** | 100% | Kill switch review triggered; all stakeholders notified |

<!-- TODO: Configure these alerts in your cloud provider or monitoring tool. -->

### Anomaly Alerts

| Condition | Threshold | Action |
|---|---|---|
| Daily cost spike | > 2x average daily cost | Alert to Tech Lead |
| Single resource spike | > 3x its 7-day average | Alert to resource owner |
| New untagged resource | Any | Alert to Infra Lead |
| Idle resource detected | CPU < 5% for 7 days | Alert to resource owner |
| AI/LLM token spike | > 2x daily average | Alert to Tech Lead |

---

## 5. Kill Switch Design

The kill switch is a mechanism to rapidly reduce cloud spend when costs exceed acceptable limits.

### Kill Switch Tiers

| Tier | Trigger | Action | Approval Required |
|---|---|---|---|
| **Tier 1: Reduce** | 90% budget | Scale non-prod environments to minimum | Tech Lead |
| **Tier 2: Pause** | 100% budget | Shut down dev environment; reduce staging to minimum | Tech Lead + Project Owner |
| **Tier 3: Emergency** | 120% budget or runaway anomaly | Shut down all non-essential services; prod remains at minimum viable | Project Owner + Finance |

### Kill Switch Implementation

<!-- TODO: Implement these scripts/runbooks and link them here. -->

```
kill-switch/
  tier-1-reduce.sh      # Scale down non-prod
  tier-2-pause.sh        # Shut down dev, minimize staging
  tier-3-emergency.sh    # Emergency shutdown of non-essential services
  restore.sh             # Restore from kill switch state
```

### Kill Switch Checklist

- [ ] Kill switch scripts are tested quarterly in a non-production environment
- [ ] Kill switch can be triggered within 15 minutes of decision
- [ ] Restore procedure is documented and tested
- [ ] Kill switch activation is logged and triggers a post-incident review

---

## 6. Cost Optimization Checklist

Review this checklist monthly. Check off items that are in place.

### Right-Sizing

- [ ] All compute instances are sized for actual workload (not over-provisioned)
- [ ] Database instances are sized based on actual query load and storage needs
- [ ] Auto-scaling is configured with appropriate min/max limits
- [ ] Dev and staging environments use smaller instance sizes than prod

### Reserved Capacity and Commitments

- [ ] Evaluated reserved instances / savings plans for stable prod workloads
- [ ] Committed-use discounts applied where workload is predictable (> 12 months)
- [ ] Spot/preemptible instances used for fault-tolerant batch workloads

### Unused and Idle Resources

- [ ] No orphaned storage volumes (snapshots, disks not attached to any instance)
- [ ] No idle load balancers or static IPs
- [ ] No running instances in dev/staging outside business hours (schedule on/off)
- [ ] No unused database instances or replicas
- [ ] Old container images and artifacts cleaned up per retention policy

### Architecture Optimizations

- [ ] Caching layer in place to reduce database and API calls
- [ ] CDN in place for static assets
- [ ] Serverless used for infrequent or bursty workloads where appropriate
- [ ] Data transfer costs minimized (same-region traffic, VPC endpoints)
- [ ] Log retention policies set to avoid unlimited storage growth

---

## 7. AI/LLM-Specific Cost Tracking

### Model Usage Tracking

<!-- TODO: Fill in the models your project uses. -->

| Model | Use Case | Cost per 1K Input Tokens | Cost per 1K Output Tokens | Monthly Budget |
|---|---|---|---|---|
| *Model A (large)* | *Complex reasoning, code generation* | *$X.XX* | *$X.XX* | *$<!-- TODO -->* |
| *Model B (small)* | *Simple tasks, classification* | *$X.XX* | *$X.XX* | *$<!-- TODO -->* |
| *Embedding model* | *Search, similarity* | *$X.XX* | *N/A* | *$<!-- TODO -->* |

### Token Usage Controls

| Control | Setting |
|---|---|
| Max tokens per request | *<!-- TODO: e.g., 4096 -->* |
| Max requests per minute (per user) | *<!-- TODO: e.g., 20 -->* |
| Max requests per minute (system-wide) | *<!-- TODO: e.g., 200 -->* |
| Daily token budget (non-prod) | *<!-- TODO: e.g., 500K tokens -->* |
| Daily token budget (prod) | *<!-- TODO: e.g., 5M tokens -->* |

### AI Cost Optimization Strategies

- [ ] Use the smallest model that meets quality requirements for each task
- [ ] Cache frequent or identical prompts/responses
- [ ] Implement prompt compression or summarization for long contexts
- [ ] Batch requests where latency allows
- [ ] Monitor and reduce unnecessary retries
- [ ] Set hard limits on token usage per user/session
- [ ] Review prompt design monthly for token efficiency

---

## 8. Monthly Cost Review Process

### Review Cadence

| Review | Frequency | Attendees | Duration |
|---|---|---|---|
| Quick cost check | Weekly | Infra Lead (async, dashboard review) | 15 min |
| Monthly cost review | Monthly | Tech Lead, Infra Lead, Project Owner | 30 min |
| Quarterly budget review | Quarterly | Above + Finance | 60 min |

### Monthly Review Agenda

1. **Actual vs. budget** -- Are we on track? Where are we over/under?
2. **Anomalies** -- Any unexpected spikes? Root cause identified?
3. **Top cost drivers** -- What are the most expensive resources? Can any be optimized?
4. **AI/LLM costs** -- Token usage trends. Model selection still appropriate?
5. **Optimization actions** -- Review checklist; assign action items.
6. **Forecast** -- Project next month's spend based on current trajectory.
7. **Budget adjustments** -- Propose changes if sustained over/under budget.

### Monthly Review Output

After each review, update this document with:

| Month | Actual Spend | Budget | Variance | Key Actions |
|---|---|---|---|---|
| *Jan 2026* | *$X,XXX* | *$X,XXX* | *+/- $XXX* | *Describe key actions taken* |
| *Feb 2026* | *$X,XXX* | *$X,XXX* | *+/- $XXX* | *Describe key actions taken* |
| <!-- TODO: Add rows as months progress --> | | | | |

---

## 9. Approval & Sign-Off

| Role | Name | Date |
|---|---|---|
| Project Owner | <!-- TODO --> | |
| Tech Lead | <!-- TODO --> | |
| Finance Approver | <!-- TODO --> | |

---

*This guide is a living document. Update it after each monthly cost review and whenever budget targets change.*
