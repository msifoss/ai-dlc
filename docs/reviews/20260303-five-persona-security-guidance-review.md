# Five-Persona Review — Security Guidance Content
### Date: 2026-03-03
### Scope: PILLAR-SECURITY.md, FIVE-PERSONA-REVIEW.md, PHASE-4-HARDENING.md, scripts/init.sh
### Reviewer: Framework self-assessment (AI-assisted)
### Context: Part of AI-DLC v1.1.0 framework review against March 2026 industry benchmarks

---

## Summary

| Persona | Findings | Critical | High | Medium | Low |
|---------|----------|----------|------|--------|-----|
| Attacker | 4 | 1 | 1 | 2 | 0 |
| Auditor | 5 | 0 | 2 | 3 | 0 |
| Ops Engineer | 4 | 0 | 2 | 1 | 1 |
| Cost Analyst | 2 | 0 | 0 | 2 | 0 |
| End User | 4 | 0 | 1 | 2 | 1 |

**Total: 19 findings** (1 Critical, 6 High, 10 Medium, 2 Low)

---

## Persona 1: Attacker

*Mindset: Motivated external attacker. How would I exploit this framework to compromise a consuming project?*

### ATK-001 — Unverified Template Source in init.sh
**Severity:** Critical
**Component:** `scripts/init.sh`
**Finding:** The init script copies templates via `cp` from `AI_DLC_ROOT` without any integrity verification (checksum, signature, hash). If the source directory is compromised or misconfigured (e.g., `AI_DLC_ROOT` pointing to an attacker-controlled path), malicious content is silently propagated into the consuming project — including `CLAUDE.md`, which AI agents read and execute as instructions.
**Impact:** Full supply-chain compromise of every project bootstrapped from a tampered source.
**Recommendation:** Add SHA-256 checksum verification for template files. Document expected checksums in the repo. Warn loudly if AI_DLC_ROOT is not a git repo with a verified remote.
**Status:** Resolved — source integrity check added to init.sh (git remote + uncommitted modification checks)

### ATK-002 — No Guidance on AI Reviewer Adversarial Prompting
**Severity:** High
**Component:** `FIVE-PERSONA-REVIEW.md`
**Finding:** The five-persona review methodology instructs teams to use AI to review code for security issues, but provides no guidance on validating that the AI reviewer itself has not been adversarially prompted or that its findings are not hallucinated. A compromised or misbehaving model could suppress real findings or inject false ones.
**Impact:** False sense of security if the AI reviewer is unreliable. Teams may ship code believing it has been reviewed when the review was compromised.
**Recommendation:** Add a "Reviewer Integrity" section: cross-validate critical findings manually, use multiple models for high-risk reviews, never treat AI review as the sole security gate.
**Status:** Resolved — Reviewer Integrity section added to FIVE-PERSONA-REVIEW.md

### ATK-003 — git init Runs Without Confirmation
**Severity:** Medium
**Component:** `scripts/init.sh` (lines 59-62)
**Finding:** The script auto-initializes a git repository if none exists, with only a warning (not a confirmation prompt). If run from the wrong directory (home directory, shared path), `git init` creates a repo in an unintended location before any files are written.
**Impact:** Unintended git repository creation. Low direct security impact but creates confusion and could mask subsequent errors.
**Recommendation:** Add a confirmation prompt or `--force` flag requirement when `git init` is needed. Alternatively, error and exit with instructions.
**Status:** Open

### ATK-004 — Lambda Kill Switch Has No Re-Enable Mechanism
**Severity:** Medium
**Component:** `PHASE-4-HARDENING.md` (lines 262-284)
**Finding:** The kill switch example sets Lambda reserved concurrency to 0 (disabling functions) but provides no corresponding re-enable script or runbook reference. An attacker who triggers the kill switch (via cost anomaly spoofing or alarm manipulation) could cause a denial of service with no documented recovery path.
**Impact:** DoS via kill switch activation with no documented recovery.
**Recommendation:** Add a companion re-enable script or runbook link. Document who is authorized to re-enable and how to verify the cost anomaly is resolved before re-enabling.
**Status:** Resolved — re-enable procedure note and TODO marker added to kill switch example

---

## Persona 2: Auditor

*Mindset: Compliance officer. Does this guidance create evidence gaps or inconsistencies that would fail an audit?*

### AUD-001 — Severity Taxonomy Inconsistency (Informational Level)
**Severity:** High
**Component:** `PHASE-4-HARDENING.md` vs `PILLAR-SECURITY.md` vs `FIVE-PERSONA-REVIEW.md`
**Finding:** Phase 4 references an "Informational" severity level (line 84: "54 low, 24 informational") that does not exist in the four-level taxonomy defined in PILLAR-SECURITY.md or FIVE-PERSONA-REVIEW.md (Critical/High/Medium/Low only). A consuming team that produces an Informational finding during Phase 4 has no defined lifecycle stage for it.
**Impact:** Audit evidence gap. Findings at a severity level with no defined handling process.
**Recommendation:** Either add Informational to the official taxonomy in PILLAR-SECURITY.md and FIVE-PERSONA-REVIEW.md, or reclassify the Phase 4 example as Low.
**Status:** Resolved — Informational severity level added to PILLAR-SECURITY.md taxonomy

### AUD-002 — Escalation Rule Wording Divergence
**Severity:** High
**Component:** `PILLAR-SECURITY.md` (lines 152-154) vs `FIVE-PERSONA-REVIEW.md` (lines 322-325)
**Finding:** Escalation rules are duplicated with divergent wording. PILLAR-SECURITY.md says findings reintroduced after "closure" escalate. FIVE-PERSONA-REVIEW.md says after "remediation." Closure and remediation are different lifecycle stages — a finding can be remediated but not yet verified or closed.
**Impact:** Ambiguous escalation policy. Teams could interpret the same situation differently depending on which document they reference.
**Recommendation:** Unify wording. Use "verified closure" in both locations to be unambiguous.
**Status:** Resolved — both PILLAR-SECURITY.md and FIVE-PERSONA-REVIEW.md now use "verified closure"

### AUD-003 — Snyk Policy Contains Expired Date
**Severity:** Medium
**Component:** `PHASE-4-HARDENING.md` (line 527)
**Finding:** The Snyk policy YAML example contains `expires: '2025-03-01'` — a date now over a year in the past. Any team copying this example deploys an already-expired ignore rule. The example is not marked as needing date updates.
**Impact:** Copied policy immediately ineffective. Teams may believe they have a valid exception when they don't.
**Recommendation:** Change to a relative marker (e.g., `<!-- TODO: Set expiry 90 days from today -->`) or use a clearly future placeholder date with a note.
**Status:** Resolved — date updated to 2026-09-01 with TODO marker

### AUD-004 — OWASP Version Pinned Without Sunset Note
**Severity:** Medium
**Component:** `PILLAR-SECURITY.md`
**Finding:** References "OWASP Top 10 (2021)" without noting that OWASP updates the list periodically. Projects using this guidance in 2026+ should verify currency.
**Impact:** Teams may follow an outdated checklist without realizing a newer version exists.
**Recommendation:** Add a note: "Verify current OWASP Top 10 version at owasp.org. This guide references the 2021 edition."
**Status:** Resolved — currency note added to PILLAR-SECURITY.md

### AUD-005 — Finding Lifecycle Has No SLA Enforcement
**Severity:** Medium
**Component:** `PILLAR-SECURITY.md` (lines 157-184)
**Finding:** The taxonomy defines remediation timelines ("fix immediately," "fix within the current bolt") but the lifecycle state machine has no time-bound triggers. A finding can stay in "Triaged" indefinitely with no escalation rule.
**Impact:** Findings can stall without visibility. No audit trail for SLA compliance.
**Recommendation:** Add time-based escalation: findings in Triaged > 2 bolts escalate to project lead. Findings in Assigned > 1 sprint escalate to risk register.
**Status:** Open

---

## Persona 3: Ops Engineer

*Mindset: SRE responsible for production stability. Can I rely on this guidance for incident response?*

### OPS-001 — CircuitBreaker Code Sample Is Not Thread-Safe
**Severity:** High
**Component:** `PHASE-4-HARDENING.md` (lines 374-401)
**Finding:** The CircuitBreaker class uses instance variables (`self.failure_count`, `self.state`, `self.last_failure_time`) with no locking mechanism. In any concurrent environment (async Python, threaded services, multiple Lambda invocations sharing state), this is a race condition. Presented as a reusable production pattern without caveat.
**Impact:** Teams copying this pattern into production could experience intermittent, hard-to-debug failures under concurrent load.
**Recommendation:** Add a threading caveat comment. Either add `threading.Lock()` to the example or explicitly note: "This example is single-threaded. For concurrent environments, add locking or use a thread-safe circuit breaker library."
**Status:** Resolved — thread-safety caveat added to CircuitBreaker docstring

### OPS-002 — retry_with_backoff References Undefined Exception
**Severity:** High
**Component:** `PHASE-4-HARDENING.md` (lines 354-368)
**Finding:** The `retry_with_backoff` function catches `TransientError`, which is not a built-in Python exception. Copying this code verbatim produces a `NameError` at runtime.
**Impact:** Production code copied from the framework fails immediately when a transient error occurs.
**Recommendation:** Either define `TransientError` as a custom exception in the example, or use a built-in exception (e.g., `ConnectionError`, `TimeoutError`) with a note about customization.
**Status:** Resolved — changed to (ConnectionError, TimeoutError) with customization comment

### OPS-003 — Secrets Guidance Conflicts Between Documents
**Severity:** Medium
**Component:** `PHASE-4-HARDENING.md` (Checklist item 38) vs `PILLAR-SECURITY.md`
**Finding:** Ops Readiness Checklist item 38 says "Secrets stored in secrets manager (not environment variables)." PILLAR-SECURITY.md says "Never store secrets in environment variables *in plain text*." The Phase 4 checklist strips the "in plain text" qualifier, implying environment variables are always prohibited — conflicting with 12-factor app patterns where secrets managers inject values into environment variables at runtime.
**Impact:** Teams following the checklist may unnecessarily refactor working, secure patterns (e.g., AWS Lambda environment variable injection from Secrets Manager).
**Recommendation:** Align wording: "Secrets managed by a secrets manager. If injected via environment variables, ensure the secret value is never committed to source or visible in logs."
**Status:** Resolved — wording aligned in both PHASE-4-HARDENING.md and PILLAR-SECURITY.md

### OPS-004 — init.sh Banner Version Mismatch
**Severity:** Low
**Component:** `scripts/init.sh` (line 69)
**Finding:** Banner displays "AI Development Life Cycle v1.0.0" while the framework is at v1.1.0.
**Impact:** User confusion. Teams may believe they are bootstrapping an older version.
**Recommendation:** Update banner to match CLAUDE.md version, or read version dynamically.
**Status:** Resolved — banner updated to v1.1.0

---

## Persona 4: Cost Analyst

*Mindset: FinOps engineer. Does this guidance create cost risk or miss cost considerations?*

### COST-001 — No Guidance on Five-Persona Review Token Cost
**Severity:** Medium
**Component:** `FIVE-PERSONA-REVIEW.md`
**Finding:** The methodology recommends running each persona as a separate AI conversation against the full codebase. For a medium application (100+ files), five full-context reviews consume significant API tokens. The real-world example (217 findings, ~3 hours) gives no cost data. At current frontier model pricing, a comprehensive Phase 4 review could cost $50-200+ in API calls per review cycle.
**Impact:** Teams may be surprised by review costs, especially if running reviews per-bolt as recommended for mature practices.
**Recommendation:** Add a "Cost Considerations" section estimating token consumption per review scope. Reference the `/cost-estimate` skill for planning.
**Status:** Open

### COST-002 — AWS Cost Query Uses Hardcoded Stale Dates
**Severity:** Medium
**Component:** `PHASE-4-HARDENING.md` (lines 209-215)
**Finding:** The AWS CLI cost query example uses hardcoded date strings (`2024-01-01,End=2024-01-31`). These are stale. Teams copying the example get cost data from 2+ years ago.
**Impact:** Misleading cost data if copied verbatim. Wasted troubleshooting time.
**Recommendation:** Replace with dynamic date calculation: `$(date -d 'first day of last month' +%Y-%m-%d)` or add a prominent TODO marker.
**Status:** Resolved — replaced with dynamic date calculation

---

## Persona 5: End User (Consuming Project Developer)

*Mindset: Developer bootstrapping their first AI-DLC project. Does this guidance set me up for success?*

### USR-001 — "Minimum 5 Findings" Prompt Incentivizes Hallucination
**Severity:** High
**Component:** `FIVE-PERSONA-REVIEW.md` (Prompt Template, line ~275)
**Finding:** The prompt template instructs the AI to "Produce at minimum 5 findings." For trivially simple or already-hardened code, this incentivizes hallucinated or over-inflated findings to meet the quota. The March 2026 Sonar research shows 96% of developers already believe AI-generated code is not fully correct — mandating a finding quota erodes trust further.
**Impact:** Teams waste remediation effort on false findings. Trust in the review process degrades. Experienced developers may abandon the methodology.
**Recommendation:** Replace minimum quota with: "Report all genuine findings. If fewer than 5 issues exist, state 'No additional findings for this persona' rather than inflating severity or manufacturing issues."
**Status:** Resolved — minimum quota replaced with quality-over-quantity instruction

### USR-002 — Default Bootstrap Mode Omits Security Review Protocol
**Severity:** Medium
**Component:** `scripts/init.sh`
**Finding:** The default bootstrap mode copies SECURITY.md (the policy) but not SECURITY-REVIEW-PROTOCOL.md (the procedure for conducting reviews). Teams bootstrapping in default mode receive a security policy without the procedural guidance for how to execute it, creating a documentation gap not discovered until Phase 4.
**Impact:** Teams reach Phase 4 without knowing how to conduct a five-persona review. Must then find and copy the template manually.
**Recommendation:** Include SECURITY-REVIEW-PROTOCOL.md in default mode, or add a prominent note in SECURITY.md pointing to the protocol template.
**Status:** Resolved — added to default bootstrap mode (now 8 documents)

### USR-003 — Real-World Example Anchors Without Context
**Severity:** Medium
**Component:** `FIVE-PERSONA-REVIEW.md` (lines 400-446)
**Finding:** The 217-finding CallHero example is presented as a benchmark ("expect 100-300+ findings for a medium-sized application") without disclosing application size, language, prior security investment, or whether counts are pre- or post-deduplication. Teams with smaller or more mature codebases may feel inadequate with 40 findings.
**Impact:** Anchoring bias. Teams may over-invest in review to hit an arbitrary finding count, or feel the methodology failed if their count is lower.
**Recommendation:** Add context (app size, lines of code, language, initial security posture). Note that finding counts vary widely. The goal is coverage, not count.
**Status:** Open

### USR-004 — No AI-Specific Attack Surface Guidance
**Severity:** Low
**Component:** `PILLAR-SECURITY.md`
**Finding:** The security pillar covers OWASP-traditional categories but says nothing about prompt injection, model output trust, or AI-assisted code review introducing biased assessments. For a framework explicitly built around AI-assisted development, this is a notable omission. NIST AI 600-1 (GenAI Profile) and the OWASP Top 10 for LLM Applications both address these AI-specific attack surfaces.
**Impact:** Consuming projects may address traditional web security but miss AI-specific risks unique to their AI-assisted workflow.
**Recommendation:** Add an "AI-Specific Attack Surfaces" subsection to PILLAR-SECURITY.md covering: prompt injection, model output validation, context file integrity, and AI reviewer reliability.
**Status:** Resolved — AI-Specific Attack Surfaces section added to PILLAR-SECURITY.md

---

## Disposition Summary

| ID | Severity | Disposition | Action | Status |
|----|----------|-------------|--------|--------|
| ATK-001 | Critical | **Fix** | Add integrity verification to init.sh template source | **RESOLVED** — source integrity check added to init.sh |
| ATK-002 | High | **Fix** | Add reviewer integrity section to FIVE-PERSONA-REVIEW.md | **RESOLVED** — Reviewer Integrity section added |
| ATK-003 | Medium | **Defer** | Low direct impact; add --force flag in future release | Deferred |
| ATK-004 | Medium | **Fix** | Add re-enable script reference to kill switch example | **RESOLVED** — re-enable note and TODO added |
| AUD-001 | High | **Fix** | Unify severity taxonomy — add Informational or reclassify | **RESOLVED** — Informational level added to PILLAR-SECURITY.md |
| AUD-002 | High | **Fix** | Unify escalation wording to "verified closure" | **RESOLVED** — both documents aligned |
| AUD-003 | Medium | **Fix** | Replace expired Snyk date with TODO marker | **RESOLVED** — date updated with TODO marker |
| AUD-004 | Medium | **Fix** | Add OWASP currency note | **RESOLVED** — currency note added |
| AUD-005 | Medium | **Defer** | Add SLA escalation in future release | Deferred |
| OPS-001 | High | **Fix** | Add thread-safety caveat to CircuitBreaker | **RESOLVED** — docstring caveat added |
| OPS-002 | High | **Fix** | Define TransientError or use built-in exception | **RESOLVED** — changed to ConnectionError, TimeoutError |
| OPS-003 | Medium | **Fix** | Align secrets guidance between documents | **RESOLVED** — wording aligned |
| OPS-004 | Low | **Fix** | Update init.sh banner version | **RESOLVED** — updated to v1.1.0 |
| COST-001 | Medium | **Defer** | Add cost considerations section in future release | Deferred |
| COST-002 | Medium | **Fix** | Replace hardcoded dates with TODO marker | **RESOLVED** — dynamic date calculation added |
| USR-001 | High | **Fix** | Replace minimum-5 quota with quality-over-quantity instruction | **RESOLVED** — quota replaced |
| USR-002 | Medium | **Fix** | Include SECURITY-REVIEW-PROTOCOL.md in default mode | **RESOLVED** — added to default bootstrap |
| USR-003 | Medium | **Defer** | Add context to CallHero example in future release | Deferred |
| USR-004 | Low | **Fix** | Add AI-specific attack surface section | **RESOLVED** — section added to PILLAR-SECURITY.md |

**Fixed:** 14/14 findings resolved on 2026-03-03
**Deferred to next release:** 4 findings (ATK-003, AUD-005, COST-001, USR-003)

---

## Traceability

- **Initiated by:** Framework Review 2026-03 (`docs/reference/FRAMEWORK-REVIEW-2026-03.md`)
- **DLC-Audit dimension:** D5 Security Posture (scored 6/10, target 8/10)
- **Related:** SECURITY.md (v1.1.0 review history)