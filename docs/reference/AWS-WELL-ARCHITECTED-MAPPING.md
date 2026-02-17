# AWS Well-Architected Framework Mapping

Map AI-DLC phases and pillars to the AWS Well-Architected Framework (WAF) six pillars. Use this reference to run WAF reviews alongside AI-DLC delivery, ensure compliance with cloud architecture standards, and translate between frameworks when communicating with stakeholders.

This guide is cloud-neutral in its primary recommendations, with AWS-specific examples and multi-cloud equivalents for Azure and GCP.

---

## Overview: AWS Well-Architected Framework

The AWS Well-Architected Framework provides a consistent approach for evaluating cloud architectures against six pillars:

| WAF Pillar | Core Question |
|-----------|---------------|
| Operational Excellence | How do you run and monitor systems to deliver business value? |
| Security | How do you protect information, systems, and assets? |
| Reliability | How do you prevent failures and recover quickly? |
| Performance Efficiency | How do you use resources efficiently for your requirements? |
| Cost Optimization | How do you eliminate unneeded costs? |
| Sustainability | How do you minimize the environmental impacts of your workloads? |

AI-DLC covers these concerns through its seven phases and four cross-cutting pillars. The mapping below shows where each WAF pillar is addressed.

---

## Mapping Table: WAF Pillar to AI-DLC

### Operational Excellence

**WAF Question:** How do you run and monitor systems to deliver business value?

| WAF Best Practice | AI-DLC Phase/Pillar | Key Activities |
|-------------------|--------------------|--------------------|
| Organize teams around business outcomes | Phase 0 Foundation | Governance model selection, role definitions |
| Design for operations | Phase 2 Elaboration | Technical spec includes operational concerns (monitoring, alerting, runbooks) |
| Reduce defects through quality processes | Quality Pillar (all phases) | Test-paired development, linting, pre-commit hooks |
| Deploy frequently with small changes | Phase 3 Construction | Bolt-driven development: small, focused units of work |
| Automate operations procedures | Phase 4 Hardening | Ops readiness checklist, automated deployments, rollback procedures |
| Monitor and observe system behavior | Phase 5 Operations | Health checks, dashboards, alerting, correlation IDs |
| Evolve operations procedures | Phase 6 Evolution | Context file updates, drift detection, retrospectives |
| Learn from operational events | Phase 6 Evolution | Five-phase learning system, pattern extraction |

**Run the WAF review during:** Phase 4 (Hardening) and Phase 5 (Operations).

### Security

**WAF Question:** How do you protect information, systems, and assets?

| WAF Best Practice | AI-DLC Phase/Pillar | Key Activities |
|-------------------|--------------------|--------------------|
| Implement strong identity foundation | Phase 1 Inception | Authentication and authorization architecture in ADRs |
| Enable traceability | Traceability Pillar (all phases) | Audit trails via git, captain's logs, traceability matrix |
| Apply security at all layers | Security Pillar (all phases) | Five-persona review at every phase boundary |
| Automate security best practices | Phase 0 Foundation | Pre-commit hooks (secret scanning, dependency audit), CI security jobs |
| Protect data in transit and at rest | Phase 4 Hardening | Encryption verification checklist, TLS enforcement |
| Keep people away from data | Phase 4 Hardening | IAM audit, least-privilege enforcement, secrets management |
| Prepare for security events | Phase 5 Operations | Incident response runbooks, security alerting, anomaly detection |

**Run the WAF review during:** Phase 4 (Hardening) for implementation review; Phase 5 (Operations) for monitoring validation.

### Reliability

**WAF Question:** How do you prevent failures and recover quickly?

| WAF Best Practice | AI-DLC Phase/Pillar | Key Activities |
|-------------------|--------------------|--------------------|
| Manage service quotas and constraints | Phase 2 Elaboration | Non-functional requirements in tech spec (throughput, limits) |
| Design for fault isolation | Phase 2 Elaboration | Component-level failure strategies in tech spec |
| Test recovery procedures | Phase 4 Hardening | Rollback testing, DLQ reprocessing, failover verification |
| Automatically recover from failure | Phase 4 Hardening | Circuit breakers, retry with backoff, auto-scaling |
| Use Dead Letter Queues | Phase 4 Hardening | DLQs on all async processors with alarms |
| Scale horizontally | Phase 4 Hardening | Load testing, auto-scaling configuration |
| Stop guessing capacity | Phase 4 Hardening | Performance testing with defined targets (p50, p95, p99) |
| Monitor and alert on reliability metrics | Phase 5 Operations | Health checks, error rate alarms, latency monitoring |

**Run the WAF review during:** Phase 4 (Hardening) for resilience patterns; Phase 5 (Operations) for operational reliability.

### Performance Efficiency

**WAF Question:** How do you use resources efficiently for your requirements?

| WAF Best Practice | AI-DLC Phase/Pillar | Key Activities |
|-------------------|--------------------|--------------------|
| Select appropriate resource types | Phase 1 Inception | Technology stack selection, ADRs with trade-off analysis |
| Review architecture against requirements | Phase 2 Elaboration | Momus and Metis validation gates |
| Make informed decisions with data | Phase 4 Hardening | Load testing, performance budgets, profiling |
| Use managed services to reduce burden | Phase 2 Elaboration | Cloud-neutral design guidance (prefer managed over self-hosted) |
| Benchmark and test regularly | Phase 4 Hardening | Performance testing: baseline, load, stress, soak |
| Monitor performance metrics | Phase 5 Operations | Latency dashboards (p50, p95, p99), throughput metrics |
| Evolve with new offerings | Phase 6 Evolution | Agent discovery, quarterly technology review |

**Run the WAF review during:** Phase 4 (Hardening) for performance validation.

### Cost Optimization

**WAF Question:** How do you eliminate unneeded costs?

| WAF Best Practice | AI-DLC Phase/Pillar | Key Activities |
|-------------------|--------------------|--------------------|
| Implement cloud financial management | Cost Awareness Pillar (all phases) | Budget setting, cost tracking, spend dashboards |
| Adopt a consumption model | Phase 2 Elaboration | Cost estimates per component in tech spec |
| Measure overall efficiency | Phase 4 Hardening | Cost baseline, cost-per-transaction metrics |
| Stop spending on undifferentiated heavy lifting | Phase 1 Inception | Architecture decisions favoring managed services |
| Analyze and attribute expenditure | Phase 4 Hardening | Cost dashboard with per-service breakdown |
| Use budget alerts and kill switches | Phase 4 Hardening | Budget alarms, cost kill switches for runaway spend |
| Decommission unused resources | Phase 6 Evolution | Decommissioning procedures, resource cleanup |
| Optimize over time | Phase 6 Evolution | Cost trend analysis, right-sizing, reserved capacity review |

**Run the WAF review during:** Phase 4 (Hardening) for cost controls; Phase 6 (Evolution) for optimization.

### Sustainability

**WAF Question:** How do you minimize the environmental impacts of your workloads?

| WAF Best Practice | AI-DLC Phase/Pillar | Key Activities |
|-------------------|--------------------|--------------------|
| Understand your impact | Phase 4 Hardening | Cost analyst persona reviews resource efficiency |
| Establish sustainability goals | Phase 1 Inception | Include sustainability in non-functional requirements |
| Maximize utilization | Phase 4 Hardening | Right-size compute, eliminate idle resources |
| Adopt efficient hardware and software | Phase 6 Evolution | Review newer instance types, ARM architectures, serverless options |
| Reduce downstream impact | Phase 6 Evolution | Optimize API response sizes, minimize unnecessary data transfer |
| Use managed services | Phase 1 Inception | Architecture decisions favoring serverless and managed services |

**Run the WAF review during:** Phase 6 (Evolution) for sustainability optimization.

---

## Summary Mapping Matrix

| WAF Pillar | Primary AI-DLC Phase(s) | Primary AI-DLC Pillar(s) | WAF Review Timing |
|-----------|------------------------|-------------------------|-------------------|
| Operational Excellence | Phase 5 Operations, Phase 6 Evolution | Quality | Phase 4-5 |
| Security | Phase 4 Hardening | Security | Phase 4 |
| Reliability | Phase 4 Hardening, Phase 5 Operations | Quality | Phase 4-5 |
| Performance Efficiency | Phase 4 Hardening | — | Phase 4 |
| Cost Optimization | Phase 4 Hardening, Phase 6 Evolution | Cost Awareness | Phase 4, 6 |
| Sustainability | Phase 6 Evolution | Cost Awareness | Phase 6 |

---

## ML Lens Considerations

For AI/ML workloads, the AWS Well-Architected ML Lens adds considerations that map to AI-DLC as follows:

| ML Lens Area | AI-DLC Mapping |
|-------------|----------------|
| **Data management** | Phase 1 data classification, Phase 2 data model specification |
| **Model development** | Phase 3 bolt-driven development with test-paired training pipelines |
| **Model deployment** | Phase 4 hardening for inference endpoints, Phase 5 canary deployments |
| **Model monitoring** | Phase 5 model drift detection, accuracy monitoring dashboards |
| **Model governance** | Phase 0 governance model, Traceability Pillar for model versioning |
| **Responsible AI** | Security Pillar bias review, Phase 2 fairness acceptance criteria |

### AI/ML-Specific Review Checklist

When conducting a WAF review on AI/ML workloads, add these items:

- [ ] Training data is versioned, classified, and access-controlled
- [ ] Model artifacts are stored with provenance metadata (training data, hyperparameters, metrics)
- [ ] Inference endpoints have latency SLAs and cost-per-inference tracking
- [ ] Model monitoring detects accuracy degradation and data drift
- [ ] A/B testing or canary deployment strategy exists for model updates
- [ ] Bias and fairness metrics are defined and monitored
- [ ] Kill switch exists for reverting to the previous model version
- [ ] AI/ML API costs (LLM tokens, GPU hours) are tracked and budgeted

---

## Multi-Cloud Equivalents

### Azure Well-Architected Framework

Azure's WAF mirrors the AWS pillars with minor naming differences.

| AWS WAF Pillar | Azure WAF Pillar | Key Azure Tools |
|---------------|-----------------|-----------------|
| Operational Excellence | Operational Excellence | Azure Monitor, Application Insights, Azure DevOps |
| Security | Security | Microsoft Defender for Cloud, Entra ID, Key Vault |
| Reliability | Reliability | Azure Availability Zones, Traffic Manager, Backup |
| Performance Efficiency | Performance Efficiency | Azure Load Testing, Application Insights, Advisor |
| Cost Optimization | Cost Optimization | Azure Cost Management, Advisor, Budgets API |
| Sustainability | Sustainability | Azure Carbon Optimization, Emissions Dashboard |

**Azure WAF Review Tool:** Use the Azure Well-Architected Review tool in the Azure portal for automated assessment.

### GCP Architecture Framework

GCP uses a slightly different structure but covers the same concerns.

| AWS WAF Pillar | GCP Architecture Framework Pillar | Key GCP Tools |
|---------------|----------------------------------|---------------|
| Operational Excellence | Operational Excellence | Cloud Monitoring, Cloud Logging, Error Reporting |
| Security | Security, Privacy, and Compliance | Security Command Center, IAM Recommender, VPC Service Controls |
| Reliability | Reliability | Cloud Load Balancing, Cloud DNS, GKE multi-zone |
| Performance Efficiency | Performance Optimization | Cloud Profiler, Cloud Trace, Recommender |
| Cost Optimization | Cost Optimization | Billing Budgets, Recommender, Committed Use Discounts |
| Sustainability | Sustainability | Carbon Footprint dashboard, Region Picker |

**GCP Architecture Review:** Use the Architecture Framework Review in GCP Console or the Cloud Architecture Center.

### Cloud-Neutral Recommendation

Regardless of cloud provider, the AI-DLC approach is the same:

1. **Design cloud-neutral.** Write specifications using generic terms (object storage, serverless compute, managed database). Add cloud-specific implementation notes as sidebars.
2. **Review with the provider's framework.** Run the provider's WAF review tool during Phase 4 Hardening.
3. **Map findings to AI-DLC findings.** WAF review findings become entries in the five-persona review findings log with severity, remediation, and tracking.
4. **Track provider-specific optimizations.** Use Phase 6 Evolution to evaluate provider-specific services that could improve cost, performance, or reliability.

---

## How to Use This Mapping

### During Phase 4 Hardening

1. Complete the AI-DLC five-persona review first.
2. Run the WAF review (using the provider's tool or the checklist above).
3. Compare WAF findings against existing AI-DLC findings. The five-persona review should have caught most issues.
4. Add any new findings from the WAF review to the security findings log.
5. Resolve all critical and high findings before Phase 5.

### During Phase 5 Operations

1. Validate operational excellence and reliability controls are active.
2. Confirm monitoring, alerting, and incident response procedures map to WAF best practices.
3. Schedule quarterly WAF re-reviews as part of Phase 6 Evolution.

### During Phase 6 Evolution

1. Review cost optimization and sustainability findings from the most recent WAF review.
2. Evaluate new provider services against current architecture.
3. Update the architecture and context files with optimization decisions.

### Communicating with Stakeholders

Use this mapping to translate between AI-DLC and WAF when speaking with:

- **Cloud architects** who think in WAF pillars: "Our Phase 4 Hardening addresses your Security, Reliability, and Performance Efficiency pillars."
- **Compliance teams** who audit against frameworks: "Our five-persona review produces findings that map to OWASP, NIST, and WAF Security pillar requirements."
- **Finance teams** who care about cost: "Our Cost Awareness Pillar and Phase 4 cost controls align with the WAF Cost Optimization pillar."
- **Leadership** who want assurance: "We run a formal Well-Architected review during every hardening phase, mapping to all six pillars."

---

## Cross-References

- [Phase 4: Hardening](../framework/PHASE-4-HARDENING.md) — Primary WAF review timing
- [Phase 5: Operations](../framework/PHASE-5-OPERATIONS.md) — Operational excellence validation
- [Phase 6: Evolution](../framework/PHASE-6-EVOLUTION.md) — Ongoing optimization and sustainability
- [Security Pillar](../pillars/PILLAR-SECURITY.md) — Maps to WAF Security pillar
- [Quality Pillar](../pillars/PILLAR-QUALITY.md) — Maps to WAF Operational Excellence and Reliability
- [Cost Awareness Pillar](../pillars/PILLAR-COST.md) — Maps to WAF Cost Optimization
- [Audit Scoring](AUDIT-SCORING.md) — 8-dimension assessment complements WAF review
- [Glossary](GLOSSARY.md) — Key terms
