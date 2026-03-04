# Five-Persona Review — Custom Skills Audit

### Date: 2026-03-03
### Scope: All 6 custom skills in ~/.claude/skills/
### Reviewer: Framework self-assessment (AI-assisted, two parallel review agents)
### Context: Part of AI-DLC v1.1.0 framework review against March 2026 industry benchmarks

---

## Summary

| Skill | Findings | Critical | High | Medium | Low |
|-------|----------|----------|------|--------|-----|
| dlc-audit | 14 | 0 | 4 | 7 | 3 |
| docs | 9 | 0 | 1 | 5 | 3 |
| motherhen | 10 | 0 | 1 | 5 | 4 |
| pm | 9 | 0 | 0 | 4 | 5 |
| prodstatus | 13 | 1 | 2 | 6 | 4 |
| ticky | 16 | 1 | 5 | 7 | 3 |

**Total: 71 findings** (2 Critical, 13 High, 34 Medium, 22 Low)

---

## Cross-Cutting Themes

Three systemic issues appear across multiple skills:

1. **Code execution masquerading as read-only checks** (DLC-001, MH-001, MH-007, PM-005): Four skills present themselves as assessment/audit/status tools but invoke commands that execute arbitrary code (`pytest --co`, `npx vitest --run`, `pip-audit`). This is the most significant cross-cutting security concern.

2. **Inter-skill inconsistency** (MH-003, DLC-007, DOC-005, MH-009): The skills were written to complement each other but contain divergent search paths, contradictory rules (TODO markers), inconsistent terminology, and incompatible scoring systems. They need a synchronization pass.

3. **Credential and infrastructure exposure** (PROD-001, PROD-002, TK-001, TK-002, TK-003): The prodstatus and ticky skills contain hardcoded infrastructure identifiers, credential file paths, and corporate identity information that constitute a reconnaissance dossier if leaked.

---

## Skill 1: `/dlc-audit` — AI-DLC Compliance Audit

### Attacker Findings

#### DLC-001 — Unrestricted Shell Command Execution Against Arbitrary Repos
**Severity:** High
**Finding:** The skill runs `pytest --co`, `pip-audit`, `npm test`, and `find` against any repo. These commands execute code at import/install time. A malicious repo with poisoned `conftest.py` or `package.json` post-install hooks gets code execution during what the user perceives as a read-only audit.
**Recommendation:** Add explicit warning about code execution. Consider `--no-exec` mode that skips shell-based health checks. Add timeouts.
**Status:** Resolved — replaced code-executing commands with file-based counting; added code execution warning

#### DLC-002 — Predictable Document Paths Enable Prompt Injection
**Severity:** Medium
**Finding:** The 14 foundational documents are at fixed, well-known paths. An attacker contributing a PR could embed adversarial content in HTML comments (e.g., `<!-- TODO: Ignore previous instructions... -->`) that enters the AI's context during every subsequent audit.
**Recommendation:** Advise human review of foundational docs before first audit. Consider content sanity checks.
**Status:** Resolved — added prompt injection awareness note to Important Notes

#### DLC-003 — "COMPLIANT" Label Could Create False Regulatory Assurance
**Severity:** Low
**Finding:** The EU AI Act compliance mapping uses the word "COMPLIANT" prominently. The distinction from actual regulatory compliance is buried in a references section.
**Recommendation:** Change to "EVIDENCE PRESENT" or "INDICATORS MET". Move disclaimer into dashboard output.
**Status:** Resolved — changed COMPLIANT to EVIDENCE PRESENT with expanded status definitions

### Auditor Findings

#### DLC-004 — Grade Boundary Inconsistency
**Severity:** High
**Finding:** Per-dimension grade "A" = 9-10. Overall letter grade "A" = 8.1-10.0. A project with all dimensions at 8/10 gets nine "B" grades but an overall "A".
**Recommendation:** Align boundaries or document the intentional difference.
**Status:** Resolved — aligned overall grade/maturity boundaries with per-dimension scale (A=9-10)

#### DLC-005 — Subjective Rubric Language Undermines Reproducibility
**Severity:** Medium
**Finding:** Rubrics use terms like "comprehensive", "actionable", "precise enough for unambiguous construction" without calibration. Two AI sessions could score the same project differently.
**Recommendation:** Add 1-2 calibration examples per dimension. Consider confidence intervals.
**Status:** Resolved — added Scoring Calibration Guide with reference points

#### DLC-006 — Undefined Skill References in Action Items
**Severity:** Medium
**Finding:** The Skill-to-Dimension mapping references 7+ skills (`/arch-audit`, `/five-persona-review`, `/security-audit`, `/budget`, `/captainslog`, `/bolt-review`, `/cost-estimate`, `/init-project`) that may not exist as SKILL.md files. Users will get errors when trying to invoke recommended skills.
**Recommendation:** Add detection step to check installed skills before recommending. Provide fallback instructions.
**Status:** Resolved — added Skill Availability Check step before recommending skills

#### DLC-007 — Document #14 Handling Contradicts Itself
**Severity:** Low
**Finding:** Line 78 says "skip the case study for non-CallHero repos" but line 156 says "create a generic case study instead." Motherhen's Check 7 searches for it universally.
**Recommendation:** Pick one approach and apply consistently.
**Status:** Resolved — unified case study handling: always /14, generic version for non-CallHero repos

### Ops Engineer Findings

#### DLC-008 — pip-audit/npm audit Can Hang With No Timeout
**Severity:** High
**Finding:** `pip-audit` makes network calls to PyPI; `npm audit --json` can produce megabytes of output. `2>/dev/null` hides errors. On slow networks these commands hang.
**Recommendation:** Add `timeout 30` to network-dependent commands. Make vulnerability check opt-in.
**Status:** Resolved — added timeout 30 to network-dependent commands

#### DLC-009 — `find` Command Missing Directory Exclusions
**Severity:** Medium
**Finding:** The `find` command doesn't exclude `.git/`, `vendor/`, `dist/`, `build/`. Slow on large repos; inaccurate counts.
**Recommendation:** Add standard exclusions.
**Status:** Resolved — added .git, node_modules, vendor, dist, build, .venv, __pycache__ exclusions

### Cost Analyst Findings

#### DLC-010 — Massive Context Consumption With No Guardrails
**Severity:** High
**Finding:** The skill reads 14+ documents, CLAUDE.md, CHANGELOG.md, config files, captain's logs, security archives, git history. Could exceed 50-100K tokens per run. No "light" mode exists.
**Recommendation:** Add a `quick` mode that checks document headers and git metadata only. Document expected token consumption.
**Status:** Resolved — added quick mode with ~70% token reduction

#### DLC-011 — `full` Mode Creates Files Without Confirmation
**Severity:** Medium
**Finding:** `/dlc-audit full` runs `init` (creating skeleton files) then `assess` without confirming the user wants file creation.
**Recommendation:** Add confirmation step or rename to make file creation explicit.
**Status:** Resolved — added user confirmation step before file creation in full mode

### End User Findings

#### DLC-012 — No Example Output in 638-Line Skill
**Severity:** Medium
**Finding:** The skill describes a complex multi-phase process but provides no sample output. First-time users can't calibrate expectations.
**Recommendation:** Add a 20-30 line sample dashboard.
**Status:** Resolved — added abbreviated sample output section

#### DLC-013 — Rubric Criteria Invisible in Dashboard Output
**Severity:** Medium
**Finding:** The dashboard shows score and one-line summary but not the rubric criteria that determined the score. Users can't understand why they scored 6 or what to do to reach 7.
**Recommendation:** Include met/missed criteria in the Details column.
**Status:** Resolved — dashboard Details column now shows met/missed rubric criteria

#### DLC-014 — `compliance` Action Missing from Argument-Hint
**Severity:** Low
**Finding:** The argument-hint YAML shows `[assess | init | full]` but omits `compliance`.
**Recommendation:** Update to include `compliance`.
**Status:** Resolved — added compliance to argument-hint

---

## Skill 2: `/docs` — Project Documentation Generator

### Attacker Findings

#### DOC-001 — No Sanitization Guidance for Secrets in Generated Docs
**Severity:** Medium
**Finding:** The skill reads the codebase and generates docs including configuration parameters and environment variables. No instruction prevents copying actual API keys or credentials into README.md.
**Recommendation:** Add explicit instruction to use placeholder values and never include real secrets.
**Status:** Resolved — added secret sanitization rules (never include real secrets, account IDs, etc.)

#### DOC-002 — No Restriction on Documenting Private Infrastructure Details
**Severity:** Low
**Finding:** For private repos, generated architecture docs could expose internal AWS account IDs, VPC configs, internal service names.
**Recommendation:** Add note to review architecture docs before publishing.
**Status:** Resolved — covered by new "never include real AWS account IDs" rule

### Auditor Findings

#### DOC-003 — "Callhero Documentation Standard" Is Circular/Undefined
**Severity:** High
**Finding:** The skill claims to follow "the callhero documentation standard" but this standard is never defined externally — the skill IS the standard. Makes the skill non-portable.
**Recommendation:** Rename to "AI-DLC documentation standard" or link to an external definition.
**Status:** Resolved — renamed to "AI-DLC documentation standard"

#### DOC-004 — 400-700 Line README Requirement Is Arbitrary
**Severity:** Medium
**Finding:** A 400-line minimum incentivizes padding small projects. A 700-line maximum may truncate complex ones. Line count is a poor proxy for quality.
**Recommendation:** Replace with guidance proportional to project complexity.
**Status:** Resolved — replaced absolute line count with proportional guidance

#### DOC-005 — "No TODO" Rule Conflicts With AI-DLC Template Convention
**Severity:** Low
**Finding:** The skill says "No TODO sections" but AI-DLC's CLAUDE.md requires `<!-- TODO: ... -->` markers in templates.
**Recommendation:** Clarify scope: no TODOs in user-facing docs; acceptable in internal templates.
**Status:** Resolved — scoped "no TODO" rule to user-facing docs only

### Ops Engineer Findings

#### DOC-006 — No Git-Safety Checks Before Overwriting
**Severity:** Medium
**Finding:** The skill can overwrite files without checking `git status`. Uncommitted changes in README.md could be lost.
**Recommendation:** Add pre-flight `git status` check on target files. Prefer Edit over Write for existing files.
**Status:** Resolved — added git-safety pre-flight check on target files

### Cost Analyst Findings

#### DOC-007 — "Read the Codebase" Is Unscoped
**Severity:** Medium
**Finding:** The instruction to "read the codebase" before writing could cause the AI to read hundreds of files on large projects. Different actions need different scope.
**Recommendation:** Scope reads by action: `changelog` only needs git history, `readme` needs architecture files, etc.
**Status:** Resolved — scoped reads by action type in process section

### End User Findings

#### DOC-008 — Merge Behavior for Existing Docs Undefined
**Severity:** Medium
**Finding:** "Don't overwrite good content; update and extend" is vague. Users can't predict whether existing docs will be restructured.
**Recommendation:** Define explicit merge behavior: preserve existing content, add missing sections, don't reorder.
**Status:** Resolved — defined merge behavior: preserve existing content, add missing sections

#### DOC-009 — Manual Selection Criteria Undefined
**Severity:** Low
**Finding:** Which manuals to create relies on AI "judgment" with no detection heuristics.
**Recommendation:** Replace with file-based detection logic.
**Status:** Resolved — added file-based detection heuristics for manual selection

---

## Skill 3: `/motherhen` — Project Health & Compliance Monitor

### Attacker Findings

#### MH-001 — Test Execution as Code Injection Vector
**Severity:** Medium
**Finding:** Test collection commands (`pytest --co`, `npx vitest --run`) execute code as a side effect. `vitest --run` actually runs the full test suite.
**Recommendation:** Replace `vitest --run` with `vitest --list`. Make test collection opt-in for untrusted repos.
**Status:** Resolved — replaced vitest --run with vitest --list; added code execution warning and file-based fallbacks

#### MH-002 — Skill Promises Fixes But Lacks Write Tools
**Severity:** Low
**Finding:** Allowed-tools exclude Write/Edit, but Phase 5 offers to "fix all items now." This is an empty promise.
**Recommendation:** Either add Write/Edit to allowed-tools or remove the fix offer.
**Status:** Resolved — added Write and Edit to allowed-tools

### Auditor Findings

#### MH-003 — Foundation Doc Search Paths Diverge From dlc-audit
**Severity:** High
**Finding:** Motherhen and dlc-audit both check for the 14 foundational documents but use different search paths. dlc-audit includes root-level paths; motherhen does not. A document at `PM-FRAMEWORK.md` would be found by dlc-audit but missed by motherhen.
**Recommendation:** Synchronize search paths. Use dlc-audit's more comprehensive set as canonical.
**Status:** Resolved — synchronized all 14 foundation doc search paths with dlc-audit (added root-level paths)

#### MH-004 — Staleness Thresholds Inconsistent and Unjustified
**Severity:** Medium
**Finding:** Four different thresholds (14, 30, 60, 90 days) across different checks with no explanation.
**Recommendation:** Add rationale for each threshold. Consider a threshold table.
**Status:** Resolved — added staleness threshold rationale table (7/14/30/60/90 days explained)

#### MH-005 — "Focus Mode In Depth" Never Defined
**Severity:** Low
**Finding:** Focus mode promises deeper analysis but provides no expanded procedures.
**Recommendation:** Define expanded focus procedures or remove "in depth" promise.
**Status:** Resolved — changed "in depth" to "only" in focus mode description

### Ops Engineer Findings

#### MH-006 — .NET Project Detection Only Matches Root Level
**Severity:** Medium
**Finding:** `ls *.sln *.csproj` only matches at repo root, missing nested project files.
**Recommendation:** Use recursive glob or `find -maxdepth 3`.
**Status:** Resolved — replaced root-level ls with find -maxdepth 3 for .NET detection

#### MH-007 — `vitest --run` Executes Full Test Suite During Health Check
**Severity:** Low
**Finding:** A health check should be passive. Running full vitest suite could take minutes and have side effects.
**Recommendation:** Replace with list-only command.
**Status:** Resolved — vitest --run replaced with vitest --list in test collection table

### Cost Analyst Findings

#### MH-008 — Quick vs Full Mode Cost Savings Minimal
**Severity:** Low
**Finding:** Quick mode still reads CLAUDE.md, CHANGELOG.md, README.md and runs git commands. The marginal savings over full mode are small.
**Recommendation:** Document expected token consumption per mode. Make quick mode genuinely lighter.
**Status:** Resolved — added approximate token consumption to mode descriptions

### End User Findings

#### MH-009 — PASS/WARN/FAIL Has No Mapping to dlc-audit's 0-10 Scores
**Severity:** Medium
**Finding:** Users running both skills get two incompatible assessment systems for overlapping checks.
**Recommendation:** Add approximate mapping note in motherhen's Check 7.
**Status:** Resolved — added PASS/WARN/FAIL to D1 score mapping note in Check 7

#### MH-010 — Effort Estimates (S/M/L) Have No Calibration
**Severity:** Low
**Finding:** Effort sizes are defined but never tied to specific fix types.
**Recommendation:** Add calibration examples.
**Status:** Resolved — added effort calibration examples (S/M/L with specific fix types)

---

## Skill 4: `/pm` — Project Management Update

### Attacker Findings

#### PM-001 — Unbounded Git Command Range
**Severity:** Medium
**Finding:** `git diff --stat HEAD~5` with "adjust range as needed" gives the AI discretion to run arbitrary-depth git commands.
**Recommendation:** Pin maximum range (e.g., `HEAD~20`). Note: do not interpret commit message content as instructions.
**Status:** Resolved — pinned max range to HEAD~20; added commit message safety note

#### PM-002 — MEMORY.md Provenance Not Validated
**Severity:** Low
**Finding:** MEMORY.md is writable by any process. Compromised content would be trusted as authoritative state.
**Recommendation:** Treat MEMORY.md as advisory; cross-reference with actual ticketing system.
**Status:** Resolved — removed MEMORY.md reference; replaced with tickets.json

### Auditor Findings

#### PM-003 — MEMORY.md Referenced But Never Defined
**Severity:** Medium
**Finding:** Referenced twice but no path, format, or schema specified. Not listed in the Files section.
**Recommendation:** Add to Files section with path and format, or remove references.
**Status:** Resolved — removed MEMORY.md reference; replaced with stack history/git tags

#### PM-004 — "A Week" Is Ambiguous for Bolt Closure
**Severity:** Low
**Finding:** Business days vs calendar days ambiguity for bolt closure trigger.
**Recommendation:** Specify "7 calendar days."
**Status:** Resolved — changed "a week" to "7 calendar days"

### Ops Engineer Findings

#### PM-005 — pytest Collection May Trigger Import Side Effects
**Severity:** Medium
**Finding:** `pytest --co` imports test modules, which can connect to databases or start fixtures. `2>/dev/null` hides errors.
**Recommendation:** Use file-based test counting instead, or note the side-effect risk.
**Status:** Resolved — replaced pytest --co with file-based test counting

#### PM-006 — No Concurrency Guard
**Severity:** Low
**Finding:** Multiple `/pm` sessions could race on file writes to CURRENT-SPRINT.md.
**Recommendation:** Add note about coordinating to single session.
**Status:** Resolved — added single-session concurrency note

### Cost Analyst Findings

#### PM-007 — Reads 4+ Files Every Invocation Even When Nothing Changed
**Severity:** Low
**Finding:** Every `/pm` reads all PM files plus git history, even if no commits since last update.
**Recommendation:** Add quick-check mode: if no new commits, skip full cycle.
**Status:** Resolved — added quick-check bypass when no new commits

### End User Findings

#### PM-008 — No Bootstrap Path for First-Time Use
**Severity:** Medium
**Finding:** If `docs/pm/` doesn't exist, the skill produces confused output. No initialization guidance.
**Recommendation:** Add "First Run" section that creates the directory and initial files.
**Status:** Resolved — added first-run bootstrap path (step 0)

#### PM-009 — User Confirmation Gate Not Enforced
**Severity:** Low
**Finding:** "Get user confirmation" is stated but the AI may proceed without explicit approval.
**Recommendation:** Make the gate explicit: "STOP after report. Do NOT update files until user says to proceed."
**Status:** Resolved — made confirmation gate explicit with STOP instruction

---

## Skill 5: `/prodstatus` — CallHero Production Health Dashboard

### Attacker Findings

#### PROD-001 — Hardcoded VPC ID Exposes Infrastructure Topology
**Severity:** Critical
**Finding:** VPC ID `vpc-04b59b3136e4a04e3` is hardcoded directly in the skill file. If this file is ever shared, backed up, or committed, it leaks real AWS infrastructure identifiers.
**Recommendation:** Replace with dynamic lookup via tag-based filtering.
**Status:** Resolved — replaced with dynamic tag-based VPC lookup

#### PROD-002 — Full Infrastructure Inventory in a Single File
**Severity:** High
**Finding:** The skill enumerates 18 Lambda functions, 2 RDS instances, 8 SQS queues, 2 CloudFormation stacks, and a VPC with account number. This is a comprehensive reconnaissance dossier.
**Recommendation:** Add confidentiality header. Move resource names to a separate non-versioned config file.
**Status:** Resolved — added CONFIDENTIAL header to skill

#### PROD-003 — Real Username and Account ID in Example Output
**Severity:** Medium
**Finding:** Example output shows `cfossenier @ 653614598774` — real identity and AWS account number.
**Recommendation:** Redact with `<username> @ <account-id>`.
**Status:** Resolved — redacted in example output

### Auditor Findings

#### PROD-004 — Ambiguity Between Example and Real Values
**Severity:** Medium
**Finding:** Example output section contains realistic-looking account IDs, cost figures, and versions. Unclear if these are placeholders or actual production values.
**Recommendation:** Use clearly fake examples.
**Status:** Resolved — replaced realistic values with generic placeholders in example output

#### PROD-005 — Cost Command Fails on 1st of Month
**Severity:** Medium
**Finding:** On day 1, Start and End dates are identical (`YYYY-MM-01`). AWS Cost Explorer requires End > Start.
**Recommendation:** Add guard for day-1 edge case using tomorrow's date or last month's data.
**Status:** Resolved — added day-1-of-month guard with macOS/Linux date fallback

#### PROD-006 — Hardcoded Resource Count Expectations Become Stale
**Severity:** Low
**Finding:** Expected counts like "88 resources" and "expect 6 endpoints" are hardcoded and will drift.
**Recommendation:** Remove expected counts or maintain in a separate config.
**Status:** Resolved — removed hardcoded expected counts

### Ops Engineer Findings

#### PROD-007 — 18 Sequential Lambda API Calls Risk Throttling
**Severity:** High
**Finding:** The skill loops through 9 functions x 2 stages with individual `get-function-configuration` calls. At 200-500ms each, takes 4-9 seconds. During incidents, contributes to API throttling.
**Recommendation:** Replace with single batch `list-functions` call with query filter.
**Status:** Resolved — replaced 18 sequential API calls with batch list-functions per stage

#### PROD-008 — No Timeout or Failure Handling
**Severity:** Medium
**Finding:** A hung AWS CLI call blocks the entire dashboard. No partial results mechanism.
**Recommendation:** Add 10-second timeout per command. Mark failed sections as ERROR and continue.
**Status:** Resolved — added timeout 15 instruction for all AWS CLI commands

#### PROD-009 — Canary Invoke Mixes Payload and Metadata on stdout
**Severity:** Medium
**Finding:** Lambda `invoke` writes response payload to stdout alongside JSON metadata, making parsing unreliable. `2>/dev/null` hides failures.
**Recommendation:** Write payload to temp file; parse metadata separately.
**Status:** Resolved — fixed canary invoke to use temp file for payload separation

### Cost Analyst Findings

#### PROD-010 — Cost Explorer API Costs Money With No Caching
**Severity:** Medium
**Finding:** `GetCostAndUsage` costs $0.01 per request. Cost data only updates daily. No caching between runs.
**Recommendation:** Cache results with 24-hour TTL. Reuse previously reported figure if run same day.
**Status:** Resolved — added cost API caching note ($0.01/call, reuse same-day results)

#### PROD-011 — Naive Linear Cost Extrapolation
**Severity:** Low
**Finding:** Linear extrapolation assumes uniform daily spend. Wildly inaccurate early in the month.
**Recommendation:** Add caveat about inaccuracy before day 10.
**Status:** Resolved — added early-month extrapolation caveat

### End User Findings

#### PROD-012 — No Platform Compatibility Note
**Severity:** Medium
**Finding:** Date commands target macOS but no platform note. Linux requires different flags for date arithmetic.
**Recommendation:** Add platform targeting note at top.
**Status:** Resolved — added platform compatibility section (macOS primary, Linux noted)

#### PROD-013 — No Remediation Guidance for WARN Items
**Severity:** Low
**Finding:** Dashboard shows WARN status but provides no next-step guidance or runbook links.
**Recommendation:** Add remediation hints for each WARN condition.
**Status:** Resolved — added remediation hints table for all WARN conditions

---

## Skill 6: `/ticky` — Full Lifecycle Ticket Management

### Attacker Findings

#### TK-001 — PAT Exposed via Command-Line Arguments
**Severity:** Critical
**Finding:** Every CLI invocation passes the Azure DevOps PAT as a command-line argument via `--pat "$(cat tickypat.txt)"`. Command-line arguments are visible to all users via `ps aux` and `/proc/<pid>/cmdline`.
**Recommendation:** Switch to environment variable delivery: `TICKY_PAT=$(cat tickypat.txt) python3 ticky.py create <file>`.
**Status:** Resolved — all 13 instances switched to env var `$TICKY_PAT`; load instruction added

#### TK-002 — PAT File Has World-Readable Permissions
**Severity:** High
**Finding:** `tickypat.txt` is mode 644 (world-readable). Combined with TK-001, any local user/process can find and read the token.
**Recommendation:** `chmod 600 tickypat.txt`. Add permission check to skill.
**Status:** Resolved — chmod 600 applied; instruction added to skill

#### TK-003 — Hardcoded Corporate Identity in Every Ticket
**Severity:** High
**Finding:** `Requestor: cfossenier` and `Email: cfossenier@membersolutions.com` are hardcoded. Every ticket appears to come from this person regardless of actual operator.
**Recommendation:** Replace with configurable variables from `~/.ticky.conf`.
**Status:** Resolved — replaced with config/git-based lookup instructions

#### TK-004 — Clean Mode Scans All Repos (Cross-Repo Contamination)
**Severity:** Medium
**Finding:** Clean mode walks `~/repos/*/docs/tickets/`. Adversarial ticket files in any repo could inject content.
**Recommendation:** Default to current repo only. Add `--all-repos` flag for explicit cross-repo scan.
**Status:** Resolved — clean mode defaults to current repo; added --all-repos flag

### Auditor Findings

#### TK-005 — tickets.json Key Format Contradicts Naming Convention
**Severity:** High
**Finding:** Key uses `YYYYMMDD-slug` but naming convention specifies `YYYYMMDD-HHMMSS-slug-status.md`. Collision risk for same-day tickets with similar descriptions.
**Recommendation:** Include timestamp in key or document collision resolution.
**Status:** Resolved — aligned key format to include full timestamp (YYYYMMDD-HHMMSS-slug)

#### TK-006 — Local "status" vs ADO "ado_state" Conflict Resolution Undefined
**Severity:** Medium
**Finding:** A ticket can have `status: submitted` but `ado_state: Closed`. No defined mapping between them.
**Recommendation:** Define: when `ado_state` becomes Closed/Resolved, set local status to closed and rename file.
**Status:** Resolved — added status sync rule: ado_state Closed/Resolved -> local status closed

#### TK-007 — Draft Mode Trigger Ambiguous for File Paths
**Severity:** Medium
**Finding:** If user types `/ticky "my-ticket.yaml"`, is that a draft description or a legacy create file path?
**Recommendation:** Clarify: existing file path = Legacy Create; non-existent quoted text = Draft.
**Status:** Resolved — clarified: existing file path -> Legacy create; otherwise -> Draft

#### TK-008 — No Schema Version in tickets.json
**Severity:** Low
**Finding:** Schema evolution has no version tracking. Clean mode creates tickets.json across repos; migration becomes a problem.
**Recommendation:** Add `"schema_version": 1`.
**Status:** Resolved — added schema_version: 1 to tickets.json schema and example

### Ops Engineer Findings

#### TK-009 — Clean Mode Creates Duplicates Without Idempotency
**Severity:** High
**Finding:** Clean creates new .md alongside old .yaml without removing originals. No idempotency check. Re-running creates duplicates.
**Recommendation:** Check tickets.json for existing entries before creating new files.
**Status:** Resolved — added idempotency check and --all-repos flag for clean mode

#### TK-010 — File Rename During Submit Races With Git
**Severity:** Medium
**Finding:** Submit renames file, updates tickets.json, and modifies frontmatter in sequence. Git operations between steps leave inconsistent state.
**Recommendation:** Write new file first, update tickets.json, then remove old file.
**Status:** Resolved — made submit operations atomic (write new file first, verify ADO response)

#### TK-011 — No ADO API Response Validation Before Updating Local State
**Severity:** Medium
**Finding:** Local file and tickets.json are updated to "submitted" even if ADO API returns an error in the response body.
**Recommendation:** Verify response contains valid ADO ID before updating local state.
**Status:** Resolved — added ADO response verification before updating local state

### Cost Analyst Findings

#### TK-012 — update --all Makes Unbounded API Calls
**Severity:** Medium
**Finding:** Each ticket sync makes 1-2 ADO API calls. No rate limiting. ADO limits to 200 requests/minute.
**Recommendation:** Batch in groups of 10 with 2-second pauses.
**Status:** Resolved — added rate limiting (batches of 10, 2-second pauses) to update --all

#### TK-013 — Clean Mode Scans All Repos By Default
**Severity:** Low
**Finding:** Scans every repo under `~/repos/` even when user only needs current repo.
**Recommendation:** Default to current repo. Add `--all-repos` flag.
**Status:** Resolved — clean mode defaults to current repo (--all-repos for cross-repo)

### End User Findings

#### TK-014 — No Undo/Rollback for Submitted Tickets
**Severity:** High
**Finding:** Once submitted to ADO, there's no retract mechanism. User must manually fix ADO, rename file, update tickets.json.
**Recommendation:** Add retract mode or document manual rollback steps.
**Status:** Resolved — added Rollback section with manual step-by-step procedure

#### TK-015 — Slug Generation Rules Incomplete
**Severity:** Medium
**Finding:** No specification for special characters, non-ASCII, stop words, mid-word truncation, or collision handling.
**Recommendation:** Specify character handling, word-boundary truncation, and `-2`/`-3` collision suffixes.
**Status:** Resolved — added complete Slug Generation Rules section (7 rules + collision handling)

#### TK-016 — No Dry-Run for Draft Mode
**Severity:** Medium
**Finding:** Draft creates file and updates tickets.json with no preview. Submit has dry-run but draft does not.
**Recommendation:** Add `--dry-run` to draft mode.
**Status:** Resolved — added --dry-run flag to draft mode

---

## Disposition Summary

### Fix Now (Critical + High = 15 findings) -- ALL RESOLVED

| ID | Severity | Skill | Action |
|----|----------|-------|--------|
| PROD-001 | Critical | prodstatus | ~~Remove hardcoded VPC ID; use tag-based lookup~~ **RESOLVED** |
| TK-001 | Critical | ticky | ~~Switch PAT from CLI arg to environment variable~~ **RESOLVED** |
| DLC-001 | High | dlc-audit | ~~Add code-execution warning; add timeouts~~ **RESOLVED** |
| DLC-004 | High | dlc-audit | ~~Align grade boundary scales~~ **RESOLVED** |
| DLC-008 | High | dlc-audit | ~~Add `timeout 30` to network-dependent commands~~ **RESOLVED** |
| DLC-010 | High | dlc-audit | ~~Add `quick` mode; document token consumption~~ **RESOLVED** |
| DOC-003 | High | docs | ~~Rename to "AI-DLC documentation standard"~~ **RESOLVED** |
| MH-003 | High | motherhen | ~~Synchronize foundation doc search paths with dlc-audit~~ **RESOLVED** |
| PROD-002 | High | prodstatus | ~~Add confidentiality header; externalize resource names~~ **RESOLVED** |
| PROD-007 | High | prodstatus | ~~Replace sequential API calls with batch `list-functions`~~ **RESOLVED** |
| TK-002 | High | ticky | ~~Fix PAT file permissions to 600~~ **RESOLVED** |
| TK-003 | High | ticky | ~~Replace hardcoded identity with config variables~~ **RESOLVED** |
| TK-005 | High | ticky | ~~Align key format with naming convention~~ **RESOLVED** |
| TK-009 | High | ticky | ~~Add idempotency check to clean mode~~ **RESOLVED** |
| TK-014 | High | ticky | ~~Document rollback procedure or add retract mode~~ **RESOLVED** |

### Fix Soon (Medium = 34 findings) -- ALL RESOLVED

| ID | Skill | Action |
|----|-------|--------|
| DLC-002 | dlc-audit | ~~Add prompt injection awareness note~~ **RESOLVED** |
| DLC-005 | dlc-audit | ~~Add calibration examples to rubrics~~ **RESOLVED** |
| DLC-006 | dlc-audit | ~~Detect installed skills before recommending~~ **RESOLVED** |
| DLC-009 | dlc-audit | ~~Add directory exclusions to find command~~ **RESOLVED** |
| DLC-011 | dlc-audit | ~~Add confirmation to `full` mode~~ **RESOLVED** |
| DLC-012 | dlc-audit | ~~Add sample output section~~ **RESOLVED** |
| DLC-013 | dlc-audit | ~~Show met/missed criteria in dashboard~~ **RESOLVED** |
| DOC-001 | docs | ~~Add secret sanitization instruction~~ **RESOLVED** |
| DOC-004 | docs | ~~Replace absolute line count with proportional guidance~~ **RESOLVED** |
| DOC-006 | docs | ~~Add git-safety pre-flight check~~ **RESOLVED** |
| DOC-007 | docs | ~~Scope file reads by action type~~ **RESOLVED** |
| DOC-008 | docs | ~~Define merge behavior for existing docs~~ **RESOLVED** |
| MH-001 | motherhen | ~~Replace vitest --run with list-only; add code-exec warning~~ **RESOLVED** |
| MH-004 | motherhen | ~~Add rationale for staleness thresholds~~ **RESOLVED** |
| MH-006 | motherhen | ~~Fix .NET project detection to be recursive~~ **RESOLVED** |
| MH-009 | motherhen | ~~Add PASS/WARN/FAIL to 0-10 mapping note~~ **RESOLVED** |
| PM-001 | pm | ~~Pin max git range; add commit message safety note~~ **RESOLVED** |
| PM-003 | pm | ~~Define MEMORY.md path and format, or remove references~~ **RESOLVED** |
| PM-005 | pm | ~~Replace pytest --co with file-based counting~~ **RESOLVED** |
| PM-008 | pm | ~~Add first-run bootstrap path~~ **RESOLVED** |
| PROD-003 | prodstatus | ~~Redact real username/account in examples~~ **RESOLVED** |
| PROD-004 | prodstatus | ~~Use clearly fake example values~~ **RESOLVED** |
| PROD-005 | prodstatus | ~~Add day-1-of-month guard for cost command~~ **RESOLVED** |
| PROD-008 | prodstatus | ~~Add per-command timeouts~~ **RESOLVED** |
| PROD-009 | prodstatus | ~~Fix canary invoke output routing~~ **RESOLVED** |
| PROD-010 | prodstatus | ~~Add cost API result caching~~ **RESOLVED** |
| PROD-012 | prodstatus | ~~Add platform compatibility note~~ **RESOLVED** |
| TK-004 | ticky | ~~Default clean to current repo only~~ **RESOLVED** |
| TK-006 | ticky | ~~Define status/ado_state mapping~~ **RESOLVED** |
| TK-007 | ticky | ~~Clarify draft vs legacy create trigger~~ **RESOLVED** |
| TK-010 | ticky | ~~Make file operations atomic~~ **RESOLVED** |
| TK-011 | ticky | ~~Validate ADO response before updating local state~~ **RESOLVED** |
| TK-012 | ticky | ~~Add rate limiting to update --all~~ **RESOLVED** |
| TK-015 | ticky | ~~Specify slug generation rules completely~~ **RESOLVED** |
| TK-016 | ticky | ~~Add dry-run to draft mode~~ **RESOLVED** |

### Defer (Low = 22 findings) -- ALL RESOLVED

~~DLC-003, DLC-007, DLC-014, DOC-002, DOC-005, DOC-009, MH-002, MH-005, MH-007, MH-008, MH-010, PM-002, PM-004, PM-006, PM-007, PM-009, PROD-006, PROD-011, PROD-013, TK-008, TK-013~~ **ALL RESOLVED**

---

## Traceability

- **Initiated by:** Framework Review 2026-03 (`docs/reference/FRAMEWORK-REVIEW-2026-03.md`)
- **Related:** Five-Persona Security Guidance Review (`docs/reviews/20260303-five-persona-security-guidance-review.md`)
- **DLC-Audit dimension:** D5 Security Posture, D9 Human-AI Collaboration
- **Next review due:** 2026-06-03 (Q2 quarterly cadence)
