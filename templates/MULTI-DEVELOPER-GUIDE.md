# Multi-Developer Collaboration Guide

> **AI-DLC Reference:** Used in **Small Team** and **Enterprise** governance models.
>
> Copy this template into your project and fill in all `<!-- TODO: ... -->` sections.

---

## 1. Team Roster

<!-- TODO: List all team members and their roles. -->

| Name | Role | GitHub Handle | Timezone | Availability |
|---|---|---|---|---|
| *Jane Smith* | *Tech Lead* | *@jsmith* | *UTC-5* | *Mon-Fri 9-17* |
| *Alex Chen* | *Developer* | *@achen* | *UTC+8* | *Mon-Fri 10-18* |
| <!-- TODO: Add team members --> | | | | |

---

## 2. Branch Strategy

### Short-Lived Feature Branches

All work happens on short-lived feature branches created from `main`. Branches should live no longer than **2-3 days** before being merged or abandoned.

### Branch Naming Convention

```
<type>/<ticket-id>-<short-description>

Examples:
  feat/PROJ-42-user-auth
  fix/PROJ-108-login-timeout
  chore/PROJ-200-update-deps
```

<!-- TODO: Replace PROJ with your actual ticket prefix. -->

### Branch Rules

| Rule | Setting |
|---|---|
| Base branch | `main` |
| Max branch lifetime | 3 days (soft limit) |
| Require PR for merge | Yes |
| Require passing CI | Yes |
| Require approvals | 1 minimum (2 for critical paths) |
| Allow force push to `main` | No |
| Delete branch after merge | Yes |

### Workflow

1. Pull latest `main`.
2. Create a feature branch: `git checkout -b feat/PROJ-42-user-auth`.
3. Make small, focused commits with clear messages.
4. Push and open a PR when ready (or open a draft PR early for visibility).
5. Address review feedback.
6. Squash-merge into `main` once approved and CI passes.

---

## 3. Pull Request Review Process

### PR Requirements

- [ ] Title follows convention: `[PROJ-XX] Brief description`
- [ ] Description explains **what** and **why** (not just what changed)
- [ ] Tests added or updated for all behavioral changes
- [ ] No unrelated changes bundled in
- [ ] CI pipeline passes
- [ ] Self-review completed before requesting others

<!-- TODO: Adjust PR title convention to match your project. -->

### Review Expectations

| Aspect | Expectation |
|---|---|
| First review response | Within 4 business hours |
| Review thoroughness | Check logic, tests, security, naming, readability |
| Blocking concerns | Must be labeled "Request Changes" with clear explanation |
| Nit-picks | Prefix with `nit:` -- these do not block merge |
| Approval | Explicit "Approve" required; comments alone do not count |

### Review Checklist for Reviewers

- [ ] Does the code do what the PR description says?
- [ ] Are edge cases handled?
- [ ] Are error messages helpful?
- [ ] Is there adequate test coverage?
- [ ] Are there any security concerns (input validation, auth, data exposure)?
- [ ] Is the code readable without the PR description for context?

---

## 4. Context File Management

### Shared Project Context: `CLAUDE.md`

The project-level `CLAUDE.md` lives at the repository root and contains:

- Project architecture overview
- Coding conventions and standards
- Common patterns and anti-patterns
- Build and test commands
- Environment setup instructions

**Rules:**
- Changes to `CLAUDE.md` require a PR with team review.
- Keep it concise -- link to detailed docs rather than duplicating them.

### Personal Developer Context: `CLAUDE-{dev}.md`

Each developer maintains a personal context file for their AI coding assistant.

```
CLAUDE-jsmith.md    # Jane's personal context
CLAUDE-achen.md     # Alex's personal context
```

**Contents include:**
- Current working context and active tasks
- Personal notes on areas of the codebase
- Preferred patterns or approaches for ongoing work
- Temporary context that does not belong in the shared file

**Rules:**
- Personal files are committed to the repo (they help with async context sharing).
- Other developers should not modify your personal context file without asking.
- Clean up stale entries weekly.

<!-- TODO: Decide on file naming convention and whether personal files are gitignored or committed. -->

---

## 5. Captain's Log Namespacing

Captain's logs track decisions, progress, and context across development sessions.

### Naming Convention

```
captains-log/
  YYYY-MM-DD-<developer>-<topic>.md

Examples:
  captains-log/2026-01-15-jsmith-auth-refactor.md
  captains-log/2026-01-15-achen-api-design.md
```

### Log Structure

Each entry should include:

```markdown
# Captain's Log: <Topic>
**Date:** YYYY-MM-DD
**Developer:** <name>
**Bolt/Phase:** <current bolt or phase>

## Context
What I'm working on and why.

## Decisions Made
- Decision 1: rationale
- Decision 2: rationale

## Open Questions
- Question that needs team input

## Next Steps
- What comes next
```

### Namespacing Rules

- One log file per developer per topic per day.
- Prefix entries with your name or handle to avoid conflicts.
- Reference other developers' logs rather than duplicating content.
- Archive logs older than 30 days into `captains-log/archive/`.

<!-- TODO: Adjust the directory structure and archival policy to suit your project. -->

---

## 6. Deploy Coordination

### Deploy Schedule

<!-- TODO: Define your deploy windows. -->

| Environment | Deploy Window | Frequency | Coordinator |
|---|---|---|---|
| Dev | Anytime | On every merge to `main` | Automated |
| Staging | Business hours | Daily or on-demand | Tech Lead |
| Prod | *Tue/Thu 10:00-14:00 UTC* | *2x per week* | *Rotating on-call* |

### Deploy Protocol

1. **Announce** intent to deploy in the team channel (e.g., `#deploys`).
2. **Check** that no other deploy is in progress.
3. **Verify** the staging environment is healthy and matches the intended release.
4. **Deploy** using the CI/CD pipeline (never deploy manually).
5. **Monitor** dashboards for 15 minutes post-deploy.
6. **Confirm** success or initiate rollback in the team channel.

### Deploy Freeze Policy

- No deploys on Fridays after 14:00 UTC (unless emergency).
- No deploys during company-wide events or holidays.
- Freeze exceptions require Tech Lead + Project Owner approval.

<!-- TODO: Adjust freeze policies to match your team's preferences. -->

---

## 7. Conflict Resolution

### Code Conflicts

1. The developer who opened the PR is responsible for resolving merge conflicts.
2. Rebase on `main` rather than merge commits when possible.
3. If two PRs touch the same code, coordinate in the team channel before merging.

### Technical Disagreements

1. **Discuss async first** -- write up your position in the PR or team channel.
2. **Timebox the discussion** -- 24 hours for async resolution.
3. **Escalate to Tech Lead** if no consensus is reached.
4. **Tech Lead decides** and documents the rationale in the relevant captain's log.
5. **Disagree and commit** -- once decided, the team moves forward together.

### Process Disagreements

1. Raise in the next team retrospective.
2. If urgent, raise in the team channel with a proposed alternative.
3. Changes to team process require majority agreement.

---

## 8. Communication Patterns

### Async-First Principles

- Default to async communication (written messages, PR comments, log entries).
- Use synchronous meetings only when async is insufficient (complex design discussions, retrospectives, incident response).
- Write context-rich messages that do not require real-time clarification.

### Communication Channels

<!-- TODO: Fill in your team's actual channels and tools. -->

| Purpose | Channel / Tool | Response Expectation |
|---|---|---|
| Code review | *PR comments* | < 4 business hours |
| General discussion | *#team-channel* | < 8 business hours |
| Deploy coordination | *#deploys* | < 30 minutes during deploy windows |
| Incidents | *#incidents* | < 15 minutes during on-call hours |
| Design decisions | *RFC documents / design docs* | < 2 business days |
| Daily check-in | *Async standup post* | By end of working day |

### Async Standup Format

Post daily in the team channel:

```
**Yesterday:** What I completed.
**Today:** What I'm working on.
**Blockers:** Anything preventing progress (tag relevant people).
```

---

## 9. Onboarding Checklist for New Team Members

### Week 1: Setup and Orientation

- [ ] Access granted to code repository
- [ ] Access granted to CI/CD platform
- [ ] Access granted to communication channels
- [ ] Access granted to project management tool
- [ ] Local development environment set up and verified
- [ ] Read project `CLAUDE.md` and `README.md`
- [ ] Read this Multi-Developer Guide
- [ ] Read the most recent 5 captain's log entries
- [ ] Successfully build and run the project locally
- [ ] Successfully run the full test suite

### Week 1-2: First Contribution

- [ ] Paired with a buddy/mentor on the team
- [ ] Assigned a small starter task (labeled `good-first-issue` or similar)
- [ ] Opened and merged first PR
- [ ] Created personal `CLAUDE-{dev}.md` file
- [ ] Written first captain's log entry
- [ ] Reviewed at least one PR from another team member

### Week 2-4: Ramp-Up

- [ ] Completed a full feature or bug fix independently
- [ ] Participated in a deploy to staging
- [ ] Read the Security Review Protocol
- [ ] Read the Ops Readiness Checklist
- [ ] Familiar with monitoring dashboards
- [ ] Added to on-call rotation (if applicable, with shadow period)

<!-- TODO: Add project-specific onboarding items (domain knowledge, external services, etc.). -->

---

## 10. Approval & Sign-Off

| Role | Name | Date |
|---|---|---|
| Tech Lead | <!-- TODO --> | |
| Project Owner | <!-- TODO --> | |

---

*This guide is a living document. Review and update it during team retrospectives.*
