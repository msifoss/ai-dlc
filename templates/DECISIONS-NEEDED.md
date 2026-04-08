# Decisions Needed

> Structured escalation protocol for blocking questions. Inspired by AIDLC's decisions-needed pattern where CRITICAL items hard-block the pipeline until resolved.

## How to Use

- Any phase (brainstorm, planning, work, review) can add items here
- **CRITICAL** items BLOCK the pipeline — work cannot proceed until resolved
- **STANDARD** items can proceed with noted defaults — review when convenient
- Categories help route decisions to the right person
- Resolved decisions stay as a permanent record

## Categories

| Category | Examples |
|----------|---------|
| `credentials` | API keys, service accounts, secret values needed |
| `business-rule` | How should X behave? What's the policy for Y? |
| `ux` | Should the modal close on backdrop click? Sort order preference? |
| `scope` | Is Z in scope? Should we include edge case W? |
| `integration` | Which third-party service? What API version? |
| `technical` | Database choice, caching strategy, architecture decision |
| `legal` | Data retention, compliance, licensing questions |
| `operational` | Deployment target, monitoring thresholds, SLA requirements |

---

## Unresolved

<!-- Format: - [ ] [CRITICAL|STANDARD] [Category: type] Description -->
<!-- For STANDARD items, include: Default: [action if not resolved] -->
<!-- CRITICAL items block the pipeline. STANDARD items proceed with defaults. -->

## Resolved

<!-- Format: - [x] [Category: type] Description — Decision: [outcome] (YYYY-MM-DD) -->
