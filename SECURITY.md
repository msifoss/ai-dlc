# Security Policy — AI-DLC Framework

## Scope

AI-DLC is a documentation-only framework. It contains no application code, no runtime dependencies, and no executable services. Security concerns for this repository fall into two categories:

1. **Content accuracy** — The framework provides security guidance (Five-Persona Review, Security Pillar, Hardening Phase). Inaccurate guidance could lead consuming projects to implement insecure practices.
2. **Supply chain** — The bootstrap script (`scripts/init.sh`) is executed by consuming projects.

## Reporting Vulnerabilities

If you discover a security issue with the framework's guidance or bootstrap script:

1. **Do not** open a public issue
2. Email security concerns to the repository maintainers
3. Include: the affected document, the specific guidance, why it is incorrect or dangerous, and the recommended correction
4. We will respond within 7 business days

## Security Review History

| Date | Scope | Reviewer | Findings | Status |
|------|-------|----------|----------|--------|
| 2026-02-17 | Initial content review (v1.1.0) | Framework self-assessment | See below | Complete |

### v1.1.0 Content Review Findings

| ID | Document | Finding | Severity | Disposition |
|----|----------|---------|----------|-------------|
| SEC-F-001 | PILLAR-SECURITY.md | Five-persona review process is comprehensive and covers OWASP Top 10 | — | No issue (positive) |
| SEC-F-002 | FIVE-PERSONA-REVIEW.md | Adversarial personas cover attacker, auditor, ops, cost, and user perspectives | — | No issue (positive) |
| SEC-F-003 | PHASE-4-HARDENING.md | Hardening phase includes security audit, ops readiness, and cost controls | — | No issue (positive) |
| SEC-F-004 | AUTONOMOUS-EXECUTION-GUIDE.md | Risk tier system correctly enforces full ceremony for Tier 1 (auth, payments, PII, crypto) | — | No issue (positive) |
| SEC-F-005 | templates/SECURITY.md | Template includes appropriate sections for auth, authz, data protection, and vulnerability reporting | — | No issue (positive) |
| SEC-F-006 | scripts/init.sh | Bootstrap script creates files but does not download, execute remote code, or modify system config | Low | Accepted — script is simple file creation only |
| SEC-F-007 | All templates | Templates use TODO markers — no risk of consuming projects shipping placeholder security guidance as real policy | — | No issue (positive) |

**Summary:** No Critical or High findings. One Low finding (SEC-F-006) accepted. The framework's security guidance is internally consistent and aligns with industry standards (OWASP, NIST AI RMF, AWS WAF).

## Security Practices for This Repository

- **No secrets** — This repository contains no API keys, credentials, or tokens
- **No dependencies** — No package manager, no transitive dependency risk
- **No runtime** — No code execution, no injection surface
- **Review cadence** — Content accuracy reviewed at each version release
- **Template safety** — All templates use TODO markers to prevent accidental use of placeholder content

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.1.x | Yes |
| 1.0.x | Yes |
| < 1.0 | No |

## Related

- [Security Pillar](docs/pillars/PILLAR-SECURITY.md) — Framework's security guidance
- [Five-Persona Review](docs/reference/FIVE-PERSONA-REVIEW.md) — Adversarial review methodology
- [Phase 4: Hardening](docs/framework/PHASE-4-HARDENING.md) — Production readiness phase
