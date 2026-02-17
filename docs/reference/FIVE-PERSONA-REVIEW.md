# Five-Persona Review — Detailed Methodology

The Five-Persona Review is AI-DLC's signature adversarial review technique. A single AI reviews the same codebase from five hostile perspectives, producing independent findings that traditional code review cannot match. This document is the complete reference for conducting, scaling, and interpreting five-persona reviews.

---

## Overview

Traditional code review asks: "Does this code work?" The Five-Persona Review asks five harder questions simultaneously:

1. **Attacker:** "How do I break in?"
2. **Auditor:** "Does this meet compliance standards?"
3. **Ops Engineer:** "What wakes me up at 3 AM?"
4. **Cost Analyst:** "What costs money I don't expect?"
5. **End User:** "What exposes my data or degrades my experience?"

Each persona operates independently with its own threat model, focus areas, and output format. Cross-contamination between personas is intentional only during triage — never during discovery.

---

## Persona 1: Attacker

### Mindset

"I am a motivated external attacker with knowledge of common vulnerabilities and access to automated scanning tools. I have no credentials, but I have time and patience. I will find the weakest link and exploit it."

### Questions to Ask

1. Can I inject malicious input into any data path that reaches a database, OS command, or rendered output?
2. Can I bypass authentication or escalate privileges through parameter manipulation, token reuse, or session fixation?
3. Can I trigger server-side requests to internal services by controlling a URL or hostname parameter?
4. Can I extract secrets, internal paths, or stack traces from error responses?
5. Can I abuse rate-unlimited endpoints to brute-force credentials, enumerate users, or amplify costs?
6. Can I exploit insecure deserialization, file uploads, or redirect logic?
7. Are there default credentials, debug endpoints, or admin routes exposed in production configuration?

### Common Findings

- SQL or NoSQL injection via unsanitized user input
- Authentication bypass through missing middleware on new endpoints
- SSRF via user-controlled URLs passed to server-side HTTP clients
- Exposed secrets in error responses, logs, or configuration files
- Missing rate limiting on authentication and registration endpoints
- Insecure direct object references (IDOR) allowing horizontal privilege escalation

### Example Finding

```
ID:          SEC-001
Persona:     Attacker
Severity:    Critical
Description: SQL injection in user search endpoint. The `q` parameter
             is concatenated directly into a SQL WHERE clause without
             parameterization.
Location:    src/api/users.py:42
Evidence:    query = f"SELECT * FROM users WHERE name LIKE '%{q}%'"
Remediation: Use parameterized query: cursor.execute(
             "SELECT * FROM users WHERE name LIKE %s", [f"%{q}%"])
Status:      Open
```

---

## Persona 2: Auditor

### Mindset

"I am a compliance auditor reviewing this system against industry frameworks (OWASP Top 10, NIST, SOC 2, GDPR, HIPAA). I need evidence that controls are implemented, documented, and verifiable. 'Trust me, it works' is not evidence."

### Questions to Ask

1. Is all sensitive data (PII, PHI, financial) classified and handled according to its classification level?
2. Is data encrypted at rest using AES-256 or equivalent, and in transit using TLS 1.2+?
3. Do access controls enforce least privilege? Are roles and permissions documented?
4. Are security-relevant events (login, logout, failed auth, privilege changes, data access) logged with immutable audit trails?
5. Do data retention and deletion practices comply with applicable regulations (GDPR right to erasure, CCPA, HIPAA)?
6. Are third-party dependencies audited for known vulnerabilities, and is there a process for ongoing monitoring?
7. Is there documented evidence of security reviews, penetration testing, or vulnerability assessments?

### Common Findings

- PII stored in plaintext or with reversible encryption
- Missing or incomplete audit logging for data access operations
- Overly permissive IAM roles with wildcard permissions
- No documented data retention or deletion policy
- Third-party dependencies with known critical CVEs
- Missing encryption on database backups or temporary storage

### Example Finding

```
ID:          AUD-001
Persona:     Auditor
Severity:    High
Description: User email addresses are logged in plaintext in application
             logs. Log aggregation service is accessible to all team
             members, violating the principle of least privilege for PII.
Location:    src/middleware/logging.py:18
Evidence:    logger.info(f"Login attempt for {user.email}")
Remediation: Replace PII with a hashed or masked identifier:
             logger.info(f"Login attempt for user_id={user.id}")
Status:      Open
```

---

## Persona 3: Ops Engineer

### Mindset

"I am the on-call engineer at 3 AM when this system breaks. I need clear signals, actionable alerts, documented runbooks, and the ability to diagnose problems without reading the source code. If something fails silently, I will find out from an angry customer, not from a dashboard."

### Questions to Ask

1. Does every critical path have a health check, metric, and alarm?
2. Do error handlers log sufficient context (correlation IDs, input parameters, stack traces) for debugging?
3. Are there silent failure modes where errors are swallowed, retries are exhausted without alerting, or queues fill without notification?
4. Do all external calls have explicit timeouts, retry logic with backoff, and circuit breakers?
5. Are there single points of failure with no redundancy or failover?
6. Can I roll back this deployment in under 5 minutes without data loss?
7. Do runbooks exist for every alarm, and are they linked from the alarm definition?

### Common Findings

- Catch blocks that swallow exceptions without logging or alerting
- Missing or unconfigured dead letter queues (DLQs) on async processors
- External API calls with no timeout, causing cascading failures
- No correlation IDs propagated across service boundaries
- Alarms with no linked runbook or escalation path
- Deployment procedures requiring manual steps

### Example Finding

```
ID:          OPS-001
Persona:     Ops Engineer
Severity:    High
Description: SQS consumer catches all exceptions and logs them at INFO
             level but does not send failed messages to a DLQ. Messages
             are silently lost after 3 processing attempts.
Location:    src/workers/order_processor.py:67
Evidence:    except Exception as e:
                 logger.info(f"Processing failed: {e}")
                 # message is implicitly deleted from queue
Remediation: Configure a DLQ with maxReceiveCount=3. Add a CloudWatch
             alarm on DLQ message count > 0. Log at ERROR level.
Status:      Open
```

---

## Persona 4: Cost Analyst

### Mindset

"I review cloud bills for a living. I know that a $50 prototype becomes a $5,000 surprise when the wrong code hits production. I look for patterns that scale linearly with traffic, patterns that scale exponentially, and patterns that cost money even when nobody is using the system."

### Questions to Ask

1. Are there database queries without `LIMIT` clauses or pagination that scan entire tables?
2. Are there API endpoints that return unbounded result sets?
3. Are serverless functions configured with appropriate memory, timeout, and concurrency limits?
4. Are there recursive or self-triggering event patterns (Lambda writing to S3, triggering another Lambda)?
5. Is there cross-region or cross-service data transfer that incurs egress charges?
6. Are AI/ML API calls (LLM inference, embeddings, image generation) rate-limited and budgeted?
7. Are temporary resources (logs, cache entries, uploaded files) cleaned up on a schedule?

### Common Findings

- Full table scans on endpoints called frequently by automated processes
- Missing pagination causing API responses to grow unboundedly
- Lambda functions with 15-minute timeout and 3GB memory for tasks that need 10 seconds and 256MB
- Log retention set to "never expire" on high-volume log groups
- AI/ML API calls in a retry loop with no circuit breaker, causing cost spikes on transient errors
- No budget alarms or spend dashboards

### Example Finding

```
ID:          COST-001
Persona:     Cost Analyst
Severity:    Medium
Description: The /api/reports endpoint executes a full table scan on the
             events table (2M+ rows) with no pagination or LIMIT clause.
             At current traffic (100 req/day), this costs ~$8/day in
             DynamoDB read capacity. At projected traffic (10K req/day),
             this becomes ~$800/day.
Location:    src/api/reports.py:23
Evidence:    response = table.scan()  # No FilterExpression, no Limit
Remediation: Add pagination with a page_size parameter (default 50,
             max 200). Use query with a partition key instead of scan.
Status:      Open
```

---

## Persona 5: End User

### Mindset

"I am a user who trusted this application with my personal data, my payment information, or my daily workflow. I expect my data to be protected, my experience to be reliable, and the system to be transparent about what it does with my information. When something goes wrong, I expect clear communication, not a stack trace."

### Questions to Ask

1. Is any personal data (email, name, IP address, location) exposed in URLs, logs, error messages, or API responses to other users?
2. Are sessions managed securely with appropriate expiration, secure cookie flags, and protection against fixation?
3. Can I delete my account and have my data actually removed (not just soft-deleted indefinitely)?
4. Do error messages tell me what went wrong in plain language, without exposing internal system details?
5. Are password policies reasonable (minimum strength, no arbitrary length limits, support for password managers)?
6. Is there a clear privacy policy, and does actual data handling match what the policy states?
7. Does the UI/UX degrade gracefully when backend services are slow or unavailable?

### Common Findings

- PII visible in API responses intended for other users (e.g., admin listing includes email addresses)
- Session tokens stored in localStorage instead of httpOnly cookies
- Error pages displaying stack traces, database names, or internal IP addresses
- No account deletion flow or data export capability
- Broken UI states when backend returns an error (blank page, infinite spinner)
- Missing MFA option for accounts with sensitive data

### Example Finding

```
ID:          UX-001
Persona:     End User
Severity:    Medium
Description: When the billing API returns a 500 error, the frontend
             displays the raw JSON error response including an internal
             request ID and service name. Users see:
             {"error": "InternalServerError", "service": "billing-v2",
              "request_id": "req-abc123"}
Location:    src/frontend/components/BillingPage.tsx:89
Evidence:    catch (e) { setError(JSON.stringify(e.response.data)) }
Remediation: Display a user-friendly message: "We encountered an issue
             processing your request. Please try again or contact
             support with reference code [masked-id]."
Status:      Open
```

---

## How to Conduct a Review

### Step-by-Step Process

1. **Define the scope.** List every file, module, endpoint, and infrastructure definition to review. For bolt-level reviews, scope is the bolt's changed files. For phase-level reviews, scope is the entire codebase.

2. **Execute each persona independently.** Do not run all five personas in a single prompt. Give each persona its own context and instructions:
   ```
   "Review the following code exclusively from the perspective of
   an Attacker. Your goal is to find exploitable vulnerabilities.
   Ignore code quality, cost, and UX concerns -- those are handled
   by other reviewers."
   ```

3. **Collect findings in structured format.** Every finding must include all fields from the finding format below. Incomplete findings are not actionable.

4. **Deduplicate across personas.** Multiple personas may find the same underlying issue from different angles. Merge duplicates but preserve the highest severity and all remediation suggestions.

5. **Triage by severity.** Sort all findings by severity. Assign a resolution timeline per the severity table.

6. **Assign findings to bolts or backlog.** Critical and High findings become immediate work items. Medium findings go into the current phase backlog. Low findings go into the project backlog.

7. **Track remediation.** Update finding status as fixes are implemented. Verify each fix addresses the root cause, not just the symptom.

### Prompt Template

Use this template to invoke each persona:

```markdown
## Five-Persona Security Review — [Persona Name]

### Scope
Files to review:
- [list all files in scope]

### Instructions
Review the code above exclusively from the perspective of a [persona].
Your goal is to [persona-specific goal].

For each finding, provide:
- ID: [CATEGORY]-NNN (e.g., SEC-001, OPS-001)
- Severity: Critical / High / Medium / Low
- Description: What the issue is and why it matters
- Location: file:line
- Remediation: Specific fix with code example where applicable
- Effort: S / M / L

Produce at minimum 5 findings. If the code is exemplary, note what
it does well and identify defense-in-depth improvements.
```

---

## Finding Format

Every finding uses this structure. No exceptions.

| Field | Format | Example |
|-------|--------|---------|
| **ID** | `{CATEGORY}-{NNN}` | `SEC-001`, `AUD-005`, `OPS-012`, `COST-003`, `UX-007` |
| **Persona** | Attacker, Auditor, Ops Engineer, Cost Analyst, End User | Attacker |
| **Severity** | Critical, High, Medium, Low | Critical |
| **Description** | 1-3 sentences: what the issue is, why it matters, what the impact would be | SQL injection in user search allows arbitrary data extraction |
| **Location** | `path/to/file.py:line` | `src/api/users.py:42` |
| **Evidence** | Code snippet, configuration excerpt, or observable behavior | `query = f"SELECT * FROM users WHERE name LIKE '%{q}%'"` |
| **Remediation** | Specific fix with code example or configuration change | Use parameterized queries |
| **Effort** | S (< 1h), M (1-4h), L (4h+) | S |
| **Status** | Open, In Progress, Fixed, Verified, Won't Fix | Open |

### Severity Definitions

| Severity | Definition | Resolution Timeline |
|----------|-----------|-------------------|
| **Critical** | Actively exploitable. Data breach or system compromise risk. No compensating controls. | Fix immediately. Block release. |
| **High** | Exploitable with moderate effort. Significant data or operational risk. | Fix within current bolt or sprint. |
| **Medium** | Defense-in-depth gap. Exploitable only with chained vulnerabilities or insider access. | Fix within current phase. |
| **Low** | Best practice deviation. Minimal direct risk. Improves overall posture. | Fix when convenient. Track in backlog. |

### Escalation Rules

- Two or more High findings in the same component escalate to Critical (systemic weakness).
- Any finding involving PII, credentials, or payment data has a minimum severity of High.
- Any finding reintroduced after previous remediation escalates one severity level and requires root cause analysis.

---

## When to Run Reviews

| Context | Scope | Depth | Personas |
|---------|-------|-------|----------|
| **Per bolt** (Phase 3) | Changed files only | Quick scan: 5-10 min | All 5, brief |
| **Per phase** (Phase 3 exit) | All code produced in the phase | Focused review: 30-60 min | All 5, thorough |
| **Hardening** (Phase 4) | Entire codebase + infrastructure | Comprehensive: 2-4 hours | All 5, exhaustive |
| **Quarterly** (Phase 6) | All changes since last review | Focused review: 1-2 hours | All 5, delta-focused |
| **Incident response** | Affected components | Targeted: 30 min | Relevant personas only |

### Per-Bolt Quick Scan

Run a lightweight version after every bolt that modifies security-sensitive code (authentication, authorization, data handling, infrastructure). Ask each persona for its top concern in the changed files. Capture findings in the captain's log.

### Phase 4 Comprehensive Review

This is the definitive review. Cover every source file, every infrastructure definition, every configuration file. Expect 100-300+ findings for a medium-sized application. Triage ruthlessly: resolve all Critical and High findings before exit.

---

## Scaling the Review

### Solo Developer (All 5 Personas)

The developer conducts all five personas using AI. Run each persona in a separate AI conversation to prevent cross-contamination. Time investment:

- Quick scan (per bolt): 10-15 minutes
- Comprehensive (Phase 4): 2-4 hours for a medium codebase

### Small Team (Assign Personas)

Distribute personas across team members. Each person runs their assigned persona with AI assistance:

| Persona | Assign To | Rationale |
|---------|-----------|-----------|
| Attacker | Most security-experienced developer | Knows what to look for |
| Auditor | Developer familiar with compliance requirements | Understands the regulatory context |
| Ops Engineer | Developer responsible for infrastructure | Knows the operational environment |
| Cost Analyst | Tech lead or budget owner | Has visibility into cloud spend |
| End User | Developer closest to the product/UX | Understands user expectations |

### Enterprise (Security Team Integration)

In enterprise contexts, the five-persona review integrates with existing security processes:

- **Attacker persona** feeds into the organization's vulnerability management program
- **Auditor persona** maps to GRC (governance, risk, compliance) team workflows
- **Ops persona** aligns with SRE/DevOps reliability reviews
- **Cost persona** integrates with FinOps practices
- **End User persona** connects to UX research and privacy teams

Enterprise teams may add additional personas (e.g., Regulator, Data Scientist, Third-Party Vendor) based on their specific risk profile.

---

## Real-World Example: 200+ Findings in 9 Days

### Context

A production deployment of an AI-assisted application followed the AI-DLC framework across 25 bolts over 9 days. During Phase 4 Hardening, a comprehensive five-persona review was conducted.

### Results

| Persona | Findings | Critical | High | Medium | Low |
|---------|----------|----------|------|--------|-----|
| Attacker | 48 | 5 | 12 | 21 | 10 |
| Auditor | 41 | 2 | 8 | 19 | 12 |
| Ops Engineer | 52 | 3 | 9 | 24 | 16 |
| Cost Analyst | 38 | 1 | 4 | 18 | 15 |
| End User | 38 | 1 | 5 | 7 | 25 |
| **Total** | **217** | **12** | **38** | **89** | **78** |

### Remediation

- **All 12 Critical findings** resolved in Hardening Bolt H2 (same day as discovery)
- **All 38 High findings** resolved in Hardening Bolts H2-H3 (within 48 hours)
- **89 Medium findings** prioritized: 42 fixed during hardening, 47 moved to Phase 5 sprint backlog
- **78 Low findings** documented in backlog for Phase 6 evolution

### Findings by Category

| Category | Count | Top Finding |
|----------|-------|-------------|
| Input validation | 31 | Missing sanitization on 12 API endpoints |
| Error handling | 28 | Silent exception swallowing in 9 catch blocks |
| Access control | 24 | 3 endpoints missing authorization middleware |
| Logging | 22 | PII in logs across 8 modules |
| Cost patterns | 19 | Unbounded queries on 4 high-traffic endpoints |
| Encryption | 16 | Missing TLS enforcement on 2 internal services |
| Session management | 14 | Session tokens in localStorage |
| Data exposure | 13 | User data in error responses |
| Infrastructure | 12 | Overly permissive IAM roles on 3 Lambda functions |
| Rate limiting | 11 | No rate limits on authentication endpoints |
| DLQ/retry | 10 | Missing DLQs on 4 SQS consumers |
| Monitoring | 9 | 6 critical paths with no alarms |
| Miscellaneous | 8 | Default configs, missing headers, stale deps |

### Key Takeaway

Without the five-persona review, these 217 findings would have entered production. The Attacker persona alone found 5 Critical issues that could have led to data exposure. The Ops Engineer persona identified 3 silent failure modes that would have caused undetected data loss. The Cost Analyst found a query pattern projected to cost $800/day at scale.

**The review took approximately 3 hours. It prevented weeks of incident response.**

---

## Cross-References

- [Security Pillar](../pillars/PILLAR-SECURITY.md) — Five-persona review context within the security pillar
- [Phase 4: Hardening](../framework/PHASE-4-HARDENING.md) — Comprehensive review during hardening
- [Phase 6: Evolution](../framework/PHASE-6-EVOLUTION.md) — Quarterly re-reviews
- [Security Review Protocol Template](../../templates/SECURITY-REVIEW-PROTOCOL.md) — Template for documenting reviews
- [Audit Scoring](AUDIT-SCORING.md) — Security posture dimension scoring
- [Glossary](GLOSSARY.md) — Five-Persona Review definition
