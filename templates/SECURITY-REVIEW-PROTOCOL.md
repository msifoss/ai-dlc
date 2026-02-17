# Security Review Protocol

> **AI-DLC Reference:** Used in **Phase 1: Blueprint** (initial review) and **Phase 4: Hardening** (comprehensive review).
>
> Copy this template into your project and fill in all `<!-- TODO: ... -->` sections.

---

## 1. Overview

| Property | Value |
|---|---|
| **Project Name** | *<!-- TODO: Your project name -->* |
| **Last Review Date** | *<!-- TODO: YYYY-MM-DD -->* |
| **Review Lead** | *<!-- TODO: Name of the person leading this review -->* |
| **Review Type** | *Per-bolt quick scan / Per-phase deep review / Quarterly re-review* |

---

## 2. Five-Persona Security Review

Each review is conducted through five distinct security personas. The same person or AI assistant can adopt each persona sequentially, or different team members can take one persona each.

### Persona 1: The Attacker

**Mindset:** "How would I break into this system?"

**Procedure:**
1. Map the attack surface: list all entry points (APIs, forms, file uploads, webhooks, admin panels).
2. For each entry point, attempt to identify:
   - Input validation weaknesses (injection, overflow, unexpected types)
   - Authentication bypasses (default credentials, token leaks, session fixation)
   - Authorization flaws (privilege escalation, IDOR, missing role checks)
3. Review error messages for information leakage.
4. Check for exposed debug endpoints, stack traces, or verbose logging in production.
5. Document all findings using the Finding Template in Section 3.

### Persona 2: The Defender

**Mindset:** "Are our defenses properly configured and layered?"

**Procedure:**
1. Verify TLS/SSL configuration (minimum TLS 1.2, strong cipher suites).
2. Check authentication mechanisms (MFA support, password policies, token expiry).
3. Review authorization model (RBAC/ABAC, least privilege, deny by default).
4. Verify rate limiting and throttling on all public endpoints.
5. Check WAF/DDoS protection configuration.
6. Review CSP, CORS, and security headers.
7. Verify audit logging captures who did what, when, and from where.
8. Document gaps using the Finding Template.

### Persona 3: The Insider

**Mindset:** "What damage could a malicious or compromised team member do?"

**Procedure:**
1. Review access controls: who has access to production systems, databases, secrets?
2. Check for shared credentials or service accounts used by multiple people.
3. Verify that the principle of least privilege is enforced.
4. Review code commit and deploy permissions (can one person push directly to prod?).
5. Check database access: can developers query production data directly?
6. Review logging: would insider actions be detected and attributed?
7. Document findings using the Finding Template.

### Persona 4: The Auditor

**Mindset:** "Can we prove our security posture to a third party?"

**Procedure:**
1. Verify all security controls are documented, not just implemented.
2. Check that access reviews are conducted on a defined schedule.
3. Confirm incident response procedures exist and have been tested.
4. Review data handling practices against applicable regulations (GDPR, CCPA, HIPAA, SOC 2).
5. Verify that third-party dependencies are inventoried and their security posture assessed.
6. Check that security training records exist for team members.
7. Document compliance gaps using the Finding Template.

<!-- TODO: Add any regulatory or compliance frameworks specific to your project. -->

### Persona 5: The Architect

**Mindset:** "Are there systemic design weaknesses?"

**Procedure:**
1. Review the overall architecture for single points of failure with security implications.
2. Check network segmentation: are sensitive components isolated?
3. Review data flow diagrams: does sensitive data cross trust boundaries unnecessarily?
4. Evaluate the blast radius of a compromise in each component.
5. Check that secrets management follows a zero-trust model (no hardcoded secrets, rotated regularly).
6. Review dependency tree for supply chain risks (pinned versions, verified sources).
7. Document design-level findings using the Finding Template.

---

## 3. Finding Template

Use this template for every security finding.

```markdown
### Finding: SEC-XXX

| Field | Value |
|---|---|
| **ID** | SEC-XXX |
| **Severity** | Critical / High / Medium / Low / Informational |
| **Persona** | Attacker / Defender / Insider / Auditor / Architect |
| **Summary** | One-line description of the finding |
| **Location** | File path, endpoint, or component affected |
| **Description** | Detailed explanation of the vulnerability or weakness |
| **Impact** | What could happen if this is exploited |
| **Remediation** | Specific steps to fix this finding |
| **Status** | Open / In Progress / Resolved / Accepted Risk / Won't Fix |
| **Assigned To** | Name of the person responsible for remediation |
| **Due Date** | Target date for resolution |
| **Resolved Date** | Date the fix was verified |
```

<!-- TODO: Start numbering findings from SEC-001. -->

---

## 4. Finding Log

Track all findings here for a consolidated view.

| ID | Severity | Summary | Persona | Status | Assigned | Due |
|---|---|---|---|---|---|---|
| SEC-001 | *High* | *Example: API endpoint lacks rate limiting* | *Defender* | *Open* | *<!-- TODO -->* | *<!-- TODO -->* |
| SEC-002 | *Medium* | *Example: Error responses leak stack traces* | *Attacker* | *Open* | *<!-- TODO -->* | *<!-- TODO -->* |
| <!-- TODO: Add findings as they are discovered --> | | | | | | |

### Finding Summary

| Severity | Open | In Progress | Resolved | Accepted Risk | Total |
|---|---|---|---|---|---|
| Critical | 0 | 0 | 0 | 0 | 0 |
| High | 0 | 0 | 0 | 0 | 0 |
| Medium | 0 | 0 | 0 | 0 | 0 |
| Low | 0 | 0 | 0 | 0 | 0 |
| Informational | 0 | 0 | 0 | 0 | 0 |

<!-- TODO: Update this table after each review. -->

---

## 5. Review Schedule

| Review Type | Trigger | Scope | Depth | Duration |
|---|---|---|---|---|
| **Per-bolt quick scan** | After each bolt is completed | Changed code and new endpoints | Persona 1 (Attacker) + Persona 2 (Defender) | 30 min - 1 hr |
| **Per-phase deep review** | At each phase boundary | Full system scope | All 5 personas | Half day - full day |
| **Quarterly re-review** | Calendar (every 3 months) | Full system + dependencies | All 5 personas + dependency audit | 1-2 days |
| **Incident-triggered review** | After any security incident | Affected components + related systems | All 5 personas focused on incident area | Varies |

### Review Log

| Date | Type | Reviewer(s) | Findings | Notes |
|---|---|---|---|---|
| *YYYY-MM-DD* | *Per-phase (Phase 1)* | *Name(s)* | *3 High, 2 Medium* | *Initial architecture review* |
| <!-- TODO: Log each review as it occurs --> | | | | |

---

## 6. Dependency Scanning Procedure

### Automated Scanning

- [ ] Dependency scanning tool integrated into CI/CD pipeline
  - **Tool:** *<!-- TODO: e.g., Dependabot, Snyk, Trivy, Grype -->*
  - **Scan frequency:** Every build + daily scheduled scan
  - **Fail threshold:** Block deployment on Critical or High severity
- [ ] Container image scanning enabled
  - **Tool:** *<!-- TODO: e.g., Trivy, Snyk Container -->*
  - **Base image policy:** Use minimal base images; rebuild on new CVE

### Manual Review Triggers

Perform a manual dependency review when:
- Adding a new dependency to the project
- Upgrading a major version of an existing dependency
- A Critical CVE is published for a dependency in use
- Quarterly, as part of the full security review

### Dependency Review Checklist

- [ ] Is the dependency actively maintained (commits in last 6 months)?
- [ ] Does it have a security policy or vulnerability disclosure process?
- [ ] Are there known unpatched vulnerabilities?
- [ ] Is the package downloaded from a verified source (official registry, signed)?
- [ ] Is the dependency pinned to a specific version (not a floating range)?
- [ ] Has the license been reviewed for compatibility?

---

## 7. Secrets Audit Checklist

- [ ] No secrets (API keys, passwords, tokens) in source code or commit history
- [ ] Secrets scanner integrated into pre-commit hooks and CI/CD
  - **Tool:** *<!-- TODO: e.g., git-secrets, truffleHog, detect-secrets -->*
- [ ] All secrets stored in a dedicated secrets management service
- [ ] Secrets are rotated on schedule (see table below)
- [ ] Revoked secrets are confirmed non-functional (test after revocation)
- [ ] Access to secrets is logged and auditable
- [ ] Secrets are scoped to minimum required permissions
- [ ] Emergency secret rotation procedure is documented and tested

### Secret Rotation Schedule

| Secret Type | Rotation Frequency | Last Rotated | Next Due |
|---|---|---|---|
| Database credentials | Every 90 days | <!-- TODO --> | <!-- TODO --> |
| API keys (external services) | Every 90 days | <!-- TODO --> | <!-- TODO --> |
| Service-to-service tokens | Every 30 days | <!-- TODO --> | <!-- TODO --> |
| TLS certificates | Auto-renewed (30 days before expiry) | <!-- TODO --> | <!-- TODO --> |
| CI/CD pipeline tokens | Every 90 days | <!-- TODO --> | <!-- TODO --> |

---

## 8. Access Control Review Checklist

- [ ] All user accounts use individual credentials (no shared accounts)
- [ ] Multi-factor authentication (MFA) is enforced for all team members
- [ ] MFA is enforced for production system access
- [ ] Role-based access control (RBAC) is implemented
- [ ] Roles follow the principle of least privilege
- [ ] Production database access requires justification and is time-limited
- [ ] Admin/root access is limited to designated personnel and requires MFA
- [ ] Service accounts have scoped permissions and no interactive login
- [ ] Access reviews are conducted quarterly
- [ ] Offboarding procedure revokes all access within 24 hours
- [ ] Access to logs and monitoring is restricted to appropriate roles

### Current Access Matrix

<!-- TODO: Fill in your access matrix. -->

| System / Resource | Developers | Tech Lead | DevOps | Project Owner |
|---|---|---|---|---|
| Source code (read/write) | Yes | Yes | Yes | Read-only |
| CI/CD pipeline (trigger) | Yes | Yes | Yes | No |
| Dev environment | Full | Full | Full | View-only |
| Staging environment | Deploy | Full | Full | View-only |
| Prod environment | View logs only | Deploy (with approval) | Full | Approve deploys |
| Secrets manager | No | Read (non-prod) | Full | No |
| Production database | No (request access) | Read-only (time-limited) | Full | No |

---

## 9. Common Vulnerability Checklist (OWASP Top 10 Mapped)

| # | OWASP Category | Check | Status |
|---|---|---|---|
| A01 | Broken Access Control | Authorization checks on every endpoint; deny by default | <!-- TODO: Pass/Fail --> |
| A02 | Cryptographic Failures | Sensitive data encrypted at rest and in transit; no weak algorithms | <!-- TODO: Pass/Fail --> |
| A03 | Injection | Parameterized queries; input validation; output encoding | <!-- TODO: Pass/Fail --> |
| A04 | Insecure Design | Threat modeling completed; secure design patterns applied | <!-- TODO: Pass/Fail --> |
| A05 | Security Misconfiguration | Default credentials removed; unnecessary features disabled; headers set | <!-- TODO: Pass/Fail --> |
| A06 | Vulnerable Components | Dependencies scanned; no known Critical/High CVEs unpatched | <!-- TODO: Pass/Fail --> |
| A07 | Authentication Failures | Strong password policy; MFA; account lockout; secure session management | <!-- TODO: Pass/Fail --> |
| A08 | Data Integrity Failures | Signed artifacts; verified CI/CD pipeline; dependency integrity checked | <!-- TODO: Pass/Fail --> |
| A09 | Logging & Monitoring Failures | Security events logged; alerts configured; log tampering prevented | <!-- TODO: Pass/Fail --> |
| A10 | Server-Side Request Forgery | SSRF protections in place; outbound requests restricted to allowlist | <!-- TODO: Pass/Fail --> |

---

## 10. Approval & Sign-Off

| Role | Name | Date |
|---|---|---|
| Security Review Lead | <!-- TODO --> | |
| Tech Lead | <!-- TODO --> | |
| Project Owner | <!-- TODO --> | |

---

*This protocol is a living document. Update the finding log after every review and refine procedures based on lessons learned.*
