# Infrastructure Playbook

> **AI-DLC Reference:** Created in **Phase 1: Blueprint**, hardened in **Phase 4: Hardening**.
>
> Copy this template into your project and fill in all `<!-- TODO: ... -->` sections.

---

## 1. Project Overview

<!-- TODO: Replace with your project details. -->

| Property | Value |
|---|---|
| **Project Name** | *Your Project Name* |
| **Last Updated** | *YYYY-MM-DD* |
| **Infra Owner** | *Name / team responsible for infrastructure* |
| **IaC Repository** | *Link to infrastructure code repository* |
| **Cloud Provider(s)** | *Provider(s) in use -- keep descriptions cloud-neutral below* |

---

## 2. Environment Architecture

### Environment Summary

| Property | Dev | Staging | Prod |
|---|---|---|---|
| Purpose | Development and debugging | Pre-production validation | Live user traffic |
| Region(s) | *Single region* | *Single region* | *Primary + failover region* |
| Isolation | Shared account/project | Separate account/project | Separate account/project |
| Data | Synthetic only | Anonymized production copy | Real user data |
| SLA Target | Best effort | 99.5% | 99.9% |

<!-- TODO: Fill in regions, account/project IDs, and SLA targets. -->

### Environment Diagram

```
                    +------------------+
                    |   DNS / CDN      |
                    +--------+---------+
                             |
                    +--------+---------+
                    |  Load Balancer   |
                    +--------+---------+
                             |
              +--------------+--------------+
              |              |              |
        +-----+----+  +-----+----+  +------+---+
        | App Srv 1 |  | App Srv 2 |  | App Srv N |
        +-----------+  +-----------+  +----------+
              |              |              |
        +-----+--------------+--------------+-----+
        |              Database Cluster            |
        +------------------------------------------+
              |
        +-----+-------------------+
        |   Object Storage /      |
        |   File Storage          |
        +-------------------------+
```

<!-- TODO: Replace with a diagram reflecting your actual architecture. -->

---

## 3. Compute Resources

### Application Servers / Containers

<!-- TODO: Select your compute model and fill in specifications. -->

| Property | Dev | Staging | Prod |
|---|---|---|---|
| **Compute Model** | *Containers / VMs / Serverless* | *Same* | *Same* |
| **Instance Type/Size** | *Small (2 vCPU, 4 GB RAM)* | *Medium (4 vCPU, 8 GB RAM)* | *Large (8 vCPU, 16 GB RAM)* |
| **Min Instances** | 1 | 2 | 3 |
| **Max Instances** | 2 | 4 | 20 |
| **Container Registry** | *registry.example.com/dev* | *registry.example.com/staging* | *registry.example.com/prod* |

### Background Workers (if applicable)

<!-- TODO: Define worker specifications or remove this section if not needed. -->

| Property | Dev | Staging | Prod |
|---|---|---|---|
| **Worker Type** | *Queue consumer / cron job / event-driven* | *Same* | *Same* |
| **Instance Size** | *Small* | *Medium* | *Medium* |
| **Min Instances** | 1 | 1 | 2 |
| **Max Instances** | 1 | 2 | 10 |

---

## 4. Database and Storage

### Primary Database

<!-- TODO: Fill in your database details. -->

| Property | Dev | Staging | Prod |
|---|---|---|---|
| **Engine** | *PostgreSQL 16 / MySQL 8 / other* | *Same* | *Same* |
| **Instance Size** | *Small* | *Medium* | *Large* |
| **Storage** | *20 GB* | *50 GB* | *200 GB + auto-expand* |
| **High Availability** | No | No | Yes (multi-AZ / replica) |
| **Backups** | Daily, 7-day retention | Daily, 14-day retention | Continuous, 30-day retention |
| **Encryption at Rest** | Yes | Yes | Yes |

### Object / File Storage

| Property | Value |
|---|---|
| **Bucket/Container Name** | *<!-- TODO: e.g., myproject-assets-prod -->* |
| **Access** | Private; pre-signed URLs for user access |
| **Lifecycle Policy** | *Move to cold storage after 90 days; delete after 365 days* |
| **Versioning** | Enabled in prod |
| **Replication** | Cross-region in prod |

### Cache Layer (if applicable)

<!-- TODO: Define cache details or remove this section. -->

| Property | Dev | Staging | Prod |
|---|---|---|---|
| **Engine** | *Redis / Memcached* | *Same* | *Same* |
| **Instance Size** | *Small* | *Medium* | *Large* |
| **Eviction Policy** | `allkeys-lru` | `allkeys-lru` | `allkeys-lru` |
| **High Availability** | No | No | Yes (cluster mode) |

---

## 5. Networking

### VPC / Virtual Network

<!-- TODO: Fill in your network CIDR ranges and subnet layout. -->

| Component | CIDR / Config |
|---|---|
| **VPC CIDR** | *10.0.0.0/16* |
| **Public Subnets** | *10.0.1.0/24, 10.0.2.0/24* (load balancers, bastion) |
| **Private Subnets (App)** | *10.0.10.0/24, 10.0.11.0/24* |
| **Private Subnets (Data)** | *10.0.20.0/24, 10.0.21.0/24* |
| **Availability Zones** | *Minimum 2 per environment* |

### Security Groups / Firewall Rules

| Rule Name | Source | Destination | Port | Protocol | Direction |
|---|---|---|---|---|---|
| Public HTTPS | 0.0.0.0/0 | Load Balancer | 443 | TCP | Inbound |
| LB to App | Load Balancer SG | App SG | 8080 | TCP | Inbound |
| App to DB | App SG | Data SG | 5432 | TCP | Inbound |
| App to Cache | App SG | Cache SG | 6379 | TCP | Inbound |
| Outbound All | App SG | 0.0.0.0/0 | All | All | Outbound |

<!-- TODO: Restrict outbound rules in prod to known destinations. -->

---

## 6. DNS and Load Balancing

<!-- TODO: Fill in your DNS and load balancer configuration. -->

| Property | Value |
|---|---|
| **DNS Provider** | *Cloud DNS / Route53 / Cloudflare / other* |
| **Domain** | *example.com* |
| **TLS Certificates** | *Managed auto-renewal via certificate service* |
| **Load Balancer Type** | *Application (Layer 7)* |
| **Health Check Path** | `/health` |
| **Health Check Interval** | 30 seconds |
| **Unhealthy Threshold** | 3 consecutive failures |
| **SSL Termination** | At load balancer |

### DNS Records

| Record | Type | Target | TTL |
|---|---|---|---|
| `app.example.com` | A / CNAME | Load Balancer | 300s |
| `api.example.com` | A / CNAME | Load Balancer | 300s |
| `dev.example.com` | CNAME | Dev Load Balancer | 300s |
| `staging.example.com` | CNAME | Staging Load Balancer | 300s |

<!-- TODO: Add all DNS records for your project. -->

---

## 7. Secrets and Configuration Management

### Secrets Manager

| Property | Value |
|---|---|
| **Tool** | *Cloud secrets manager / Vault / other* |
| **Access Method** | Injected as environment variables at deploy time |
| **Rotation** | Automated every 90 days where supported |
| **Audit Logging** | Enabled -- all access logged |

### Application Configuration

| Property | Value |
|---|---|
| **Config Method** | *Environment variables / config files / feature flag service* |
| **Environment Overrides** | Per-environment variable files or parameter store paths |
| **Feature Flags** | *Service name or library* |
| **Config Change Process** | PR-reviewed, deployed via CI/CD (never manual in prod) |

<!-- TODO: List specific secrets and config keys (not values) that your application requires. -->

---

## 8. Infrastructure-as-Code Tool Selection

<!-- TODO: Choose your IaC tool and justify the decision. -->

| Criteria | Tool A: *Terraform* | Tool B: *Pulumi* | Tool C: *CloudFormation/ARM* |
|---|---|---|---|
| Multi-cloud support | Yes | Yes | Single-cloud |
| Language | HCL | General-purpose languages | YAML/JSON |
| State management | Remote backend | Managed service | Managed by provider |
| Team familiarity | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |
| Community/ecosystem | Large | Growing | Provider-specific |

**Selected Tool:** *<!-- TODO: State your choice. -->*
**Rationale:** *<!-- TODO: Explain why. -->*

### IaC Repository Structure

```
infrastructure/
  modules/             # Reusable modules
    networking/
    compute/
    database/
    monitoring/
  environments/        # Environment-specific configs
    dev/
    staging/
    prod/
  scripts/             # Helper scripts
```

---

## 9. Disaster Recovery Plan

<!-- TODO: Define RPO and RTO for your project. -->

| Metric | Target |
|---|---|
| **Recovery Point Objective (RPO)** | *< 1 hour (max data loss)* |
| **Recovery Time Objective (RTO)** | *< 4 hours (max downtime)* |

### Backup Strategy

| Component | Backup Method | Frequency | Retention | Tested |
|---|---|---|---|---|
| Database | Automated snapshots | Continuous / Daily | 30 days | <!-- TODO: Date of last test --> |
| Object Storage | Cross-region replication | Real-time | Indefinite | <!-- TODO --> |
| Application Config | Version control | Every commit | Indefinite | N/A |
| Secrets | Secrets manager replication | Real-time | N/A | <!-- TODO --> |

### Recovery Procedures

1. **Database failure:** Restore from latest snapshot to a new instance; update connection strings.
2. **Region failure:** Failover DNS to secondary region; promote read replica to primary.
3. **Application failure:** Redeploy last known good artifact from the CI/CD pipeline.
4. **Complete disaster:** Rebuild from IaC in a new region; restore database from cross-region backup.

<!-- TODO: Write detailed runbooks for each scenario and link them here. -->

### DR Test Schedule

| Test Type | Frequency | Last Tested | Next Scheduled |
|---|---|---|---|
| Database restore | Quarterly | <!-- TODO --> | <!-- TODO --> |
| Failover drill | Semi-annually | <!-- TODO --> | <!-- TODO --> |
| Full DR exercise | Annually | <!-- TODO --> | <!-- TODO --> |

---

## 10. Scaling Strategy

### Horizontal Scaling (add more instances)

| Trigger | Scale Out | Scale In | Cooldown |
|---|---|---|---|
| CPU > 70% for 5 min | Add 2 instances | Remove 1 instance | 5 min |
| Memory > 80% for 5 min | Add 2 instances | Remove 1 instance | 5 min |
| Request queue depth > 100 | Add 1 instance | Remove 1 instance | 3 min |

### Vertical Scaling (increase instance size)

- Performed during maintenance windows only.
- Requires testing in staging before applying to prod.
- Document the change in the captain's log.

### Auto-Scaling Limits

| Environment | Min Instances | Max Instances | Max Monthly Cost Cap |
|---|---|---|---|
| Dev | 1 | 2 | *$<!-- TODO -->* |
| Staging | 2 | 4 | *$<!-- TODO -->* |
| Prod | 3 | 20 | *$<!-- TODO -->* |

<!-- TODO: Set actual cost caps aligned with your budget. -->

---

## 11. Approval & Sign-Off

| Role | Name | Date |
|---|---|---|
| Infra Lead | <!-- TODO --> | |
| Tech Lead | <!-- TODO --> | |
| Security Lead | <!-- TODO --> | |

---

*This playbook is a living document. Review after each phase transition and during quarterly infrastructure reviews.*
