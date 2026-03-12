# Five-Persona Code Review

Usage: `/five-persona-review [scope]`

**Arguments:** $ARGUMENTS

---

## Purpose

Conducts a deep, multi-perspective code review using five expert personas — a battle-tested methodology that found 155 security findings across 3 rounds in the AI-DLC reference project. Each persona independently reviews the codebase (or specified scope) and produces findings categorized by severity.

---

## Instructions for Claude

### 0. Parse Arguments

Extract `scope` from: `$ARGUMENTS`

- If no scope provided, review the **entire codebase**
- If scope is a file path, review that file/directory
- If scope is a feature name, find and review related files
- Examples: `/five-persona-review`, `/five-persona-review src/auth/`, `/five-persona-review "the API layer"`

### 1. Setup Review Environment

**Worktree isolation (recommended):** To avoid disrupting the main working directory during review, use an isolated worktree when available:

```bash
# Check if we're on a feature branch or reviewing a PR
current_branch=$(git branch --show-current)
default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
```

**If reviewing a PR or specific branch:**
- Use `EnterWorktree` to create an isolated copy for the review
- This prevents review analysis from polluting the main working directory
- Exit the worktree after review is complete

**If reviewing the current working directory:**
- Proceed in-place (worktree not needed for reviewing your own uncommitted work)

### 2. Read the Codebase

Before reviewing, read ALL files in scope. Understand:
- Architecture and data flow
- Error handling patterns
- Security controls
- Test coverage
- Configuration and secrets management
- Infrastructure as code (if present)

### 2b. Check Per-Project Config

Check for `.ai-dlc.local.yaml` in the project root for review customizations:

```bash
ls .ai-dlc.local.yaml 2>/dev/null
```

If found, read it and apply any `review` section overrides:
- `review.focus_areas` — prioritize certain types of findings
- `review.skip_personas` — skip specific personas if not relevant
- `review.extra_context` — additional context passed to all personas

If not found, proceed with default 5-persona configuration.

### 3. Conduct Five Independent Reviews

Each persona reviews independently. Do NOT let one persona's findings influence another.

#### Persona 1: Staff Engineer (Will Larson)
**Focus:** Code quality, error handling, testing gaps, operational readiness
**Looks for:**
- Error paths that silently fail or lose data
- Missing edge cases in tests
- Code that works but will cause operational pain
- Anti-patterns that will compound over time
- Insufficient logging or observability
- Race conditions and concurrency issues

#### Persona 2: First Principles (Elon Musk)
**Focus:** Over-engineering, unnecessary complexity, dead code
**Looks for:**
- Code that exists "just in case" but serves no current purpose
- Abstractions that add complexity without clear benefit
- Features that could be simpler
- Dependencies that could be eliminated
- Configuration that could be hardcoded (if truly static)
- Speculative future-proofing

#### Persona 3: Radical Transparency (Ray Dalio)
**Focus:** Documentation accuracy, operational readiness, honest assessment
**Looks for:**
- README/docs that don't match the code
- Outdated comments
- Missing runbook entries for failure modes
- Metrics that aren't being tracked but should be
- Gaps between what's claimed and what's real
- Deployment procedures that skip steps

#### Persona 4: CTO / Security Architect
**Focus:** Security, architecture, scalability, data protection
**Looks for:**
- Input validation gaps
- Authentication/authorization weaknesses
- Injection vulnerabilities (SQL, command, XSS)
- Secrets in code or logs
- Overly permissive IAM/RBAC
- Missing encryption (at rest and in transit)
- Network exposure
- Dependency vulnerabilities

#### Persona 5: SRE / DevOps Staff Engineer
**Focus:** Infrastructure, monitoring, deployment, reliability
**Looks for:**
- Missing health checks or monitoring
- Alarm gaps (failure modes without alerts)
- Deployment risks (no rollback, no canary)
- Resource limits not set (memory, CPU, concurrency, timeouts)
- Missing retry/backoff on external calls
- Cost risks (unbounded resource creation)
- Log volume or log loss risks
- Infrastructure drift from IaC

### 4. Classify Findings

Each finding gets a severity:

| Severity | Meaning | Examples |
|----------|---------|---------|
| **Critical** | Data loss, security breach, or system failure | Missing auth, SQL injection, silent data corruption |
| **High** | Significant operational or security risk | Missing retries, unvalidated input, overpermissive IAM |
| **Medium** | Will cause problems under stress or at scale | Missing monitoring, incomplete error handling |
| **Low** | Code quality, documentation, minor improvements | Naming, comments, minor inefficiencies |

### 5. Deduplicate

After all 5 personas have reviewed, consolidate duplicate findings. Track which personas flagged each issue (consensus = higher confidence).

### 6. Output Report

Save to `docs/reviews/[YYYYMMDD]-five-persona-code-review.txt`:

```
================================================================================
FIVE-PERSONA CODE REVIEW
Date: [YYYY-MM-DD]
Scope: [what was reviewed]
================================================================================

## Overview

| # | Persona | Focus Area | Findings |
|---|---------|------------|----------|
| 1 | Staff Engineer | Code quality, error handling | [count] |
| 2 | First Principles | Simplification | [count] |
| 3 | Radical Transparency | Docs accuracy, ops readiness | [count] |
| 4 | CTO / Security | Security, architecture | [count] |
| 5 | SRE / DevOps | Infrastructure, monitoring | [count] |
| | **Total raw findings** | | **[count]** |

After deduplication: **[count] unique findings**

================================================================================
## CONSOLIDATED FINDINGS — SORTED BY SEVERITY
================================================================================

### CRITICAL ([count])

**F1 — [Title]**
File: [path:line]
Personas: [which personas flagged this]
[Description of the issue]
Fix: [Recommended fix]

---

### HIGH ([count])
[Same format]

### MEDIUM ([count])
[Same format]

### LOW ([count])
[Same format]

================================================================================
## SUMMARY
================================================================================

- Critical: [count] — must fix before deploy
- High: [count] — fix this sprint
- Medium: [count] — fix within 2 sprints
- Low: [count] — address when convenient
- Total unique: [count]
```

### 7. Offer to Fix

After presenting findings, ask the user:
1. Fix all Critical findings now?
2. Fix Critical + High?
3. Fix everything?
4. Just save the report?

If fixing, work through findings by severity (Critical first), updating the report as each is resolved.
