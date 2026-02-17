# Pillar: Security

> Cross-cutting concern active in **all seven phases** of the AI Development Life Cycle.

Security is not a phase — it is a continuous discipline. Every bolt, every merge, every deployment carries security implications. This pillar defines how AI-DLC projects identify, classify, remediate, and verify security findings from inception through evolution.

---

## Table of Contents

- [Five-Persona Review Methodology](#five-persona-review-methodology)
- [Security Finding Taxonomy](#security-finding-taxonomy)
- [Finding Lifecycle](#finding-lifecycle)
- [OWASP Top 10 Integration](#owasp-top-10-integration)
- [Cloud Security Controls](#cloud-security-controls)
- [Compliance Mapping](#compliance-mapping)
- [Phase-by-Phase Security Activities](#phase-by-phase-security-activities)
- [Templates and Cross-References](#templates-and-cross-references)

---

## Five-Persona Review Methodology

The Five-Persona Review is AI-DLC's core adversarial technique. The AI reviews every code change from five hostile perspectives, each with distinct objectives, attack surface focus, and output format.

Run this review on every bolt that modifies application code, infrastructure, or configuration. In Solo+AI workflows, this replaces traditional human PR review for security concerns.

### Persona 1: Attacker

**Objective:** Find exploitable vulnerabilities before a real attacker does.

**Focus Areas:**

| Attack Class | What to Look For | Example |
|---|---|---|
| Injection | Unsanitized user input reaching SQL, NoSQL, OS commands, LDAP | `query = f"SELECT * FROM users WHERE id = {user_input}"` |
| Cross-Site Scripting (XSS) | User input rendered in HTML without encoding | `innerHTML = request.getParameter("name")` |
| Cross-Site Request Forgery (CSRF) | State-changing operations without anti-CSRF tokens | POST endpoint with no CSRF validation |
| Server-Side Request Forgery (SSRF) | User-controlled URLs fetched server-side | `requests.get(user_provided_url)` |
| Authentication Bypass | Missing or weak authentication on sensitive endpoints | Admin route with no auth middleware |
| Privilege Escalation | Horizontal or vertical access control failures | User A can modify User B's resources by changing an ID |
| Insecure Deserialization | Untrusted data deserialized without validation | `pickle.loads(request.body)` |

**Output:** List of exploitable paths with severity, attack vector, and remediation.

### Persona 2: Auditor

**Objective:** Verify the code meets compliance and regulatory requirements.

**Focus Areas:**

- **Data Classification** — Identify PII, PHI, financial data, and their handling
- **Encryption** — Verify data at rest uses AES-256 (or equivalent) and data in transit uses TLS 1.2+
- **Access Controls** — Confirm role-based access, least privilege, and separation of duties
- **Audit Trails** — Check that security-relevant events produce immutable logs
- **Data Retention** — Validate retention policies align with regulations (GDPR, CCPA, HIPAA)
- **Consent Management** — Confirm data processing respects user consent preferences

**Output:** Compliance gap assessment mapped to relevant frameworks (NIST, ISO, SOC 2).

### Persona 3: Ops Engineer

**Objective:** Identify what breaks at 3 AM and whether the team can diagnose and recover.

**Focus Areas:**

- **Error Handling** — Catch blocks that swallow errors silently, missing fallback logic
- **Logging** — Sensitive data in logs, insufficient operational logging, missing correlation IDs
- **Monitoring Gaps** — Endpoints with no health checks, missing alerting thresholds
- **Single Points of Failure** — Components with no redundancy, missing circuit breakers
- **Secrets in Failure Paths** — Stack traces or error messages that expose secrets or internal structure
- **Timeout Configuration** — Missing or unreasonable timeouts on external calls

**Output:** Operational risk register with blast radius assessment for each finding.

### Persona 4: Cost Analyst

**Objective:** Identify code patterns that can cause unexpected or runaway costs.

**Focus Areas:**

- **Unbounded Queries** — Database queries with no `LIMIT`, full table scans
- **Missing Pagination** — API endpoints that return entire datasets
- **No Rate Limiting** — Endpoints vulnerable to abuse-driven cost amplification
- **Runaway Compute** — Lambda/Cloud Functions with no timeout, recursive triggers
- **Storage Leaks** — Temporary files or logs that grow without rotation or cleanup
- **Data Transfer** — Cross-region or cross-service transfers that incur egress charges

**Output:** Cost risk assessment with estimated monthly impact under normal and abuse scenarios.

### Persona 5: End User

**Objective:** Determine whether a user's data, privacy, and trust are protected.

**Focus Areas:**

- **PII Exposure** — Personal data visible in URLs, logs, error messages, or API responses
- **Session Management** — Session fixation, missing expiration, insecure cookie flags
- **Data Retention** — Clear path for users to request data deletion
- **Consent** — Data collection aligns with what users agreed to
- **Account Security** — Password policies, MFA availability, account lockout behavior
- **Transparency** — Users understand what data is collected and why

**Output:** User trust risk assessment with remediation recommendations.

### Running the Review

```markdown
## Five-Persona Security Review — Bolt {N}

### Scope
- Files changed: [list files]
- Feature area: [describe]

### Attacker Perspective
[findings]

### Auditor Perspective
[findings]

### Ops Engineer Perspective
[findings]

### Cost Analyst Perspective
[findings]

### End User Perspective
[findings]

### Summary
- Critical: {count}
- High: {count}
- Medium: {count}
- Low: {count}
```

---

## Security Finding Taxonomy

Classify every finding using this four-level severity scale. Severity determines remediation urgency.

| Severity | Definition | Remediation Timeline | Examples |
|---|---|---|---|
| **Critical** | Actively exploitable. Data breach risk. No compensating controls. | Fix immediately. Stop current work. | SQL injection on login, exposed secrets in public repo, unauthenticated admin endpoint |
| **High** | Exploitable with moderate effort. Significant data or system risk. | Fix within the current bolt. | Missing CSRF protection on state-changing routes, weak password hashing, overly permissive IAM role |
| **Medium** | Defense-in-depth gap. Exploitable only with chained vulnerabilities. | Fix within the current phase. | Missing rate limiting, verbose error messages, HTTP-only flag missing on cookies |
| **Low** | Best practice deviation. Minimal direct risk. | Fix when convenient. | Security headers missing (CSP, HSTS), outdated but unaffected dependency, log format inconsistency |

### Escalation Rules

- Two or more **High** findings in the same component — escalate to **Critical** (systemic issue).
- Any finding involving PII or credentials — minimum severity is **High**.
- Any finding reintroduced after previous closure — escalate one level and add root cause analysis.

---

## Finding Lifecycle

Track every security finding through this lifecycle. No finding disappears without explicit closure.

```
Discovered → Triaged → Assigned → Fixed → Verified → Closed
    │                                          │
    └─── Won't Fix (requires justification) ◄──┘
```

| Stage | Owner | Action | Artifact |
|---|---|---|---|
| **Discovered** | Reviewer (AI or human) | Identify and document finding with severity | Finding entry in security log |
| **Triaged** | Tech lead / project owner | Confirm severity, assign priority | Updated finding with confirmed severity |
| **Assigned** | Tech lead | Assign to bolt or backlog | Finding linked to bolt or backlog item |
| **Fixed** | Developer + AI | Implement remediation | Code change with tests |
| **Verified** | Reviewer | Confirm fix addresses root cause and does not introduce new issues | Verification note on finding |
| **Closed** | Tech lead | Mark as resolved | Closed finding with resolution date |

### Won't Fix Policy

Document every "Won't Fix" decision with:
- Justification (why the risk is acceptable)
- Compensating controls (what mitigates the residual risk)
- Review date (when to reassess the decision)
- Approver (who accepted the risk)

---

## OWASP Top 10 Integration

Map each OWASP Top 10 (2021) category to specific AI-DLC review activities.

| # | OWASP Category | AI-DLC Review Activity | Phase Focus |
|---|---|---|---|
| A01 | Broken Access Control | Verify authorization on every endpoint. Test horizontal and vertical privilege escalation. Review role definitions. | Phase 3, Phase 4 |
| A02 | Cryptographic Failures | Audit encryption at rest and in transit. Check for hardcoded keys, weak algorithms (MD5, SHA1 for passwords), missing TLS. | Phase 3, Phase 4 |
| A03 | Injection | Test all input paths for SQL, NoSQL, OS command, LDAP injection. Verify parameterized queries and input validation. | Phase 3 |
| A04 | Insecure Design | Review architecture decisions for security anti-patterns. Validate threat model. Check for missing abuse cases. | Phase 1, Phase 2 |
| A05 | Security Misconfiguration | Audit cloud resource configurations, default credentials, unnecessary services, overly permissive CORS. | Phase 4, Phase 5 |
| A06 | Vulnerable Components | Run dependency audit. Check for known CVEs. Verify update process exists. | Phase 3, Phase 4 |
| A07 | Auth and Identification Failures | Test authentication flows, session management, password policies, MFA implementation. | Phase 3, Phase 4 |
| A08 | Data Integrity Failures | Verify CI/CD pipeline integrity, software update mechanisms, deserialization safety. | Phase 4, Phase 5 |
| A09 | Logging and Monitoring Failures | Confirm security events are logged, alerts exist for anomalous behavior, logs are protected from tampering. | Phase 4, Phase 5 |
| A10 | Server-Side Request Forgery | Test any functionality that fetches URLs or interacts with internal services based on user input. Validate allowlists. | Phase 3, Phase 4 |

### OWASP Checklist Template

Use this checklist during Phase 4 Hardening:

```markdown
## OWASP Top 10 Checklist — [Project Name]

- [ ] A01: Access control tested on all endpoints
- [ ] A02: Encryption verified (at rest + in transit)
- [ ] A03: All input paths tested for injection
- [ ] A04: Architecture reviewed for insecure design patterns
- [ ] A05: Cloud/server configuration hardened
- [ ] A06: Dependency audit clean (no critical/high CVEs)
- [ ] A07: Authentication and session management validated
- [ ] A08: CI/CD pipeline integrity confirmed
- [ ] A09: Security logging and alerting operational
- [ ] A10: SSRF protections verified on URL-handling endpoints
```

---

## Cloud Security Controls

Apply these controls regardless of cloud provider. Sidebar examples show provider-specific implementations.

### Identity and Access Management

Enforce least privilege. Grant the minimum permissions needed for each role, service, and automation.

| Control | Implementation | Cloud Examples |
|---|---|---|
| Least-privilege roles | Define roles with only required permissions. No wildcards (`*`) in production policies. | AWS IAM Policies, Azure RBAC, GCP IAM Roles |
| Service accounts | Dedicated accounts per service, no shared credentials. Rotate keys on schedule. | AWS IAM Roles for EC2/Lambda, Azure Managed Identities, GCP Service Accounts |
| MFA enforcement | Require MFA for all human accounts, especially admin access. | AWS IAM MFA, Azure Conditional Access, GCP 2-Step Verification |
| Temporary credentials | Prefer short-lived tokens over long-lived keys. | AWS STS AssumeRole, Azure AD tokens, GCP Workload Identity |

### Encryption

Encrypt everything. No exceptions.

| Control | Implementation | Cloud Examples |
|---|---|---|
| At rest | AES-256 or equivalent for all stored data (databases, object storage, volumes). | AWS KMS + S3/EBS encryption, Azure Key Vault + Storage encryption, GCP CMEK |
| In transit | TLS 1.2+ for all network communication. Enforce HTTPS. Reject plaintext. | AWS ACM + ALB, Azure App Gateway, GCP managed SSL |
| Key management | Use managed key services. Rotate keys at minimum annually. Never store keys in code. | AWS KMS, Azure Key Vault, GCP Cloud KMS |

### Network Isolation

Segment networks to contain blast radius.

| Control | Implementation | Cloud Examples |
|---|---|---|
| Virtual networks | Place resources in private subnets. Minimize public-facing endpoints. | AWS VPC, Azure VNet, GCP VPC |
| Security groups / firewalls | Allow only required ports and protocols. Default deny. | AWS Security Groups, Azure NSGs, GCP Firewall Rules |
| Private endpoints | Access managed services over private network, not public internet. | AWS PrivateLink, Azure Private Endpoints, GCP Private Service Connect |

### Secrets Management

Never store secrets in code, environment variables in plain text, or configuration files committed to version control.

| Control | Implementation | Cloud Examples |
|---|---|---|
| Vault storage | Store all secrets in a dedicated secrets manager. | AWS Secrets Manager / SSM, Azure Key Vault, GCP Secret Manager |
| Rotation | Automate rotation for database credentials, API keys, and service account keys. | AWS Secrets Manager rotation, Azure Key Vault rotation, GCP Secret Manager rotation |
| Access audit | Log and alert on all secret access. Review access patterns monthly. | CloudTrail, Azure Monitor, GCP Audit Logs |
| Code scanning | Run pre-commit hooks to detect secrets in code before they reach the repository. | git-secrets, trufflehog, gitleaks |

### API Security

Protect every API endpoint as a potential attack surface.

| Control | Implementation |
|---|---|
| Authentication | Require authentication on all non-public endpoints. Use OAuth 2.0 / OIDC or API keys with scoping. |
| Rate limiting | Enforce request limits per client. Use tiered limits (authenticated vs. anonymous). |
| Input validation | Validate all input against schemas. Reject unexpected fields. Enforce size limits. |
| Output encoding | Encode responses to prevent XSS. Use Content-Type headers. |
| Versioning | Version APIs to manage breaking changes. Deprecate, don't remove. |

---

## Compliance Mapping

### NIST AI Risk Management Framework (AI RMF)

| NIST AI RMF Function | AI-DLC Mapping |
|---|---|
| **GOVERN** — Establish AI risk management policies | Phase 0 governance setup, CLAUDE.md security sections, team security roles |
| **MAP** — Identify and categorize AI risks | Phase 1 threat modeling, Phase 2 abuse case analysis, security finding taxonomy |
| **MEASURE** — Assess and track AI risks | Five-persona review metrics, finding lifecycle tracking, OWASP checklist scoring |
| **MANAGE** — Mitigate and monitor AI risks | Phase 3 remediation in bolts, Phase 4 hardening, Phase 5 monitoring, Phase 6 retrospectives |

### ISO/IEC 42001 (AI Management System)

| ISO/IEC 42001 Clause | AI-DLC Mapping |
|---|---|
| 4. Context of the organization | Phase 0 Foundation — project context, stakeholder analysis |
| 5. Leadership | Governance models (Solo, Small Team, Enterprise), human decision gates |
| 6. Planning | Phase 1 Inception — risk assessment, requirements with security attributes |
| 7. Support | Templates (SECURITY.md, SECURITY-REVIEW-PROTOCOL.md), training via context files |
| 8. Operation | Phase 3 Construction — security in bolts, Phase 4 Hardening — dedicated security work |
| 9. Performance evaluation | Phase 6 Evolution — security metrics, finding trends, audit scoring |
| 10. Improvement | Phase 6 Evolution — retrospectives, pattern extraction, process improvements |

---

## Phase-by-Phase Security Activities

### Phase 0: Foundation

- [ ] Define security policy in CLAUDE.md (acceptable risk levels, compliance requirements)
- [ ] Set up secret scanning in pre-commit hooks
- [ ] Configure branch protection rules (require reviews, no force push to main)
- [ ] Establish security finding log structure
- [ ] Choose and configure dependency vulnerability scanner

### Phase 1: Inception

- [ ] Identify data classification levels (public, internal, confidential, restricted)
- [ ] Perform initial threat modeling for each architectural component
- [ ] Document security requirements (REQ-SEC-xxx) alongside functional requirements
- [ ] Define authentication and authorization architecture
- [ ] Record security-relevant architecture decisions as ADRs

### Phase 2: Elaboration

- [ ] Add abuse cases to user stories ("As an attacker, I try to...")
- [ ] Specify security acceptance criteria on every story handling sensitive data
- [ ] Validate API specifications include authentication, rate limits, and input schemas
- [ ] Review third-party dependencies for known vulnerabilities
- [ ] Map security requirements to technical specifications

### Phase 3: Construction

- [ ] Run five-persona review on every bolt that modifies security-sensitive code
- [ ] Write security-focused tests (authentication bypass, injection, authorization)
- [ ] Validate input at system boundaries
- [ ] Log security events (login, logout, failed auth, privilege changes)
- [ ] Keep dependencies updated; address critical CVEs immediately

### Phase 4: Hardening

- [ ] Execute full OWASP Top 10 checklist
- [ ] Run comprehensive five-persona review across entire codebase
- [ ] Perform dependency audit — resolve all critical and high CVEs
- [ ] Validate cloud security controls (IAM, encryption, network, secrets)
- [ ] Harden error handling — remove stack traces and internal details from responses
- [ ] Verify security logging and alerting is operational
- [ ] Complete ops readiness security section
- [ ] Document all accepted risks with justification

### Phase 5: Operations

- [ ] Enable security monitoring and alerting in production
- [ ] Configure anomaly detection for authentication and API usage
- [ ] Establish incident response procedures and runbooks
- [ ] Set up automated dependency scanning on schedule
- [ ] Monitor security advisories for all dependencies
- [ ] Verify secrets rotation is operational

### Phase 6: Evolution

- [ ] Review all security findings from the cycle — identify patterns
- [ ] Update threat model based on production observations
- [ ] Extract reusable security patterns into context files
- [ ] Assess whether security tooling needs improvement
- [ ] Benchmark against OWASP, NIST, and ISO requirements
- [ ] Plan security improvements for the next cycle

---

## Templates and Cross-References

### Related Templates

- [SECURITY.md](../../templates/SECURITY.md) — Security policy and practices template
- [SECURITY-REVIEW-PROTOCOL.md](../../templates/SECURITY-REVIEW-PROTOCOL.md) — Detailed review methodology template
- [OPS-READINESS-CHECKLIST.md](../../templates/OPS-READINESS-CHECKLIST.md) — Production readiness checklist with security section

### Related Phases

- [Phase 0: Foundation](../framework/PHASE-0-FOUNDATION.md) — Security policy and tooling setup
- [Phase 1: Inception](../framework/PHASE-1-INCEPTION.md) — Threat modeling and security requirements
- [Phase 2: Elaboration](../framework/PHASE-2-ELABORATION.md) — Abuse cases and security specifications
- [Phase 3: Construction](../framework/PHASE-3-CONSTRUCTION.md) — Security in every bolt
- [Phase 4: Hardening](../framework/PHASE-4-HARDENING.md) — Dedicated security hardening (primary phase)
- [Phase 5: Operations](../framework/PHASE-5-OPERATIONS.md) — Security monitoring and incident response
- [Phase 6: Evolution](../framework/PHASE-6-EVOLUTION.md) — Security retrospective and improvement

### Related Pillars

- [Quality](PILLAR-QUALITY.md) — Testing validates security controls
- [Traceability](PILLAR-TRACEABILITY.md) — Security requirements traced through implementation
- [Cost Awareness](PILLAR-COST.md) — Cost Analyst persona overlaps with security cost concerns

### Related Reference Documents

- [Five-Persona Review](../reference/FIVE-PERSONA-REVIEW.md) — Full methodology reference
- [Audit Scoring](../reference/AUDIT-SCORING.md) — Assessment methodology including security dimension
