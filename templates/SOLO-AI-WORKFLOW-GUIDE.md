# Solo Developer + AI Workflow Guide

<!-- AI-DLC Phase: Used throughout all phases, especially Phase 3: Construction -->

> Copy this template into your project. Use it as a daily reference for
> working effectively as a solo developer with AI assistance.
> Items marked with <!-- TODO: ... --> need your input.

---

## Daily Workflow Checklist

Use this checklist at the start of each working session.

### Session Start

- [ ] Review your context file (CLAUDE-CONTEXT.md) -- is it current?
- [ ] Check the current bolt's planned items in PM-FRAMEWORK.md
- [ ] Check for any unresolved blockers from the previous session
- [ ] Run the test suite to confirm a green baseline
- [ ] Run the Five Questions Pattern (see below) to decide what to work on

### During the Session

- [ ] Work on one item at a time (respect your WIP limit)
- [ ] Write tests alongside or before implementation
- [ ] Commit frequently with meaningful messages
- [ ] If blocked for more than 15 minutes, log it and switch tasks

### Session End

- [ ] Run the full test suite -- confirm no regressions
- [ ] Update CLAUDE-CONTEXT.md "Current State" section if anything changed
- [ ] Write a Captain's Log entry (see template below)
- [ ] Update the Traceability Matrix if you completed or started new items
- [ ] Commit all work with a clear summary

---

## Five Questions Pattern

The Five Questions Pattern is a structured decision-making exercise you run at the start of each bolt (or each day). Answer these five questions, in order, to create a focused plan.

### The Five Questions

**1. What is the single most important thing to accomplish this bolt?**

*State one clear goal. If you can only finish one thing, what must it be?*

> <!-- TODO: Answer before each bolt -->
> *Example: Get the subscription dashboard rendering real data from the API.*

**2. What is currently blocked or at risk?**

*Identify anything preventing progress. Be specific about the blocker and who or what can resolve it.*

> <!-- TODO: Answer before each bolt -->
> *Example: Waiting on API credentials for the payment provider. I have emailed the vendor; expected by tomorrow.*

**3. What did I learn since the last bolt that changes my plan?**

*Reflect on surprises, new information, or changed assumptions.*

> <!-- TODO: Answer before each bolt -->
> *Example: The CSV export library I planned to use does not support streaming. I need to evaluate alternatives or write a custom solution.*

**4. What are the top 3 items I will work on, in priority order?**

*Pick no more than 3. Be specific. These become your bolt backlog.*

> <!-- TODO: Answer before each bolt -->
> *Example:*
> 1. *Implement dashboard API endpoint (US-201)*
> 2. *Fix session timeout bug (BUG-012)*
> 3. *Write unit tests for auth module (tech debt)*

**5. What will I explicitly NOT work on this bolt?**

*Name at least one thing you are tempted to do but will defer. This protects your focus.*

> <!-- TODO: Answer before each bolt -->
> *Example: I will NOT start the admin impersonation feature (US-401) even though it is interesting. It is a Could-have and I have Must-haves to finish.*

### Using the Answers

After answering, transfer your top 3 items into the "Current Sprint / Bolt" section of PM-FRAMEWORK.md. Reference these answers if you feel pulled toward unplanned work during the bolt.

---

## Bolt Execution Checklist

Each bolt follows four stages: Plan, Build, Review, Retro.

### 1. Plan (start of bolt)

- [ ] Run the Five Questions Pattern
- [ ] Select items from the backlog and add to the current bolt in PM-FRAMEWORK.md
- [ ] Define done criteria for the bolt
- [ ] Ensure CLAUDE-CONTEXT.md is up to date so AI has correct context
- [ ] Brief your AI assistant on the bolt goal

**AI Prompt Tip:** *Start a bolt by giving your AI assistant a message like:*
> *"We are starting Bolt-005. The goal is [goal]. Here are the items: [list]. The context file is at CLAUDE-CONTEXT.md. Let's begin with [first item]."*

### 2. Build (during the bolt)

- [ ] Work through items in priority order
- [ ] Write tests for each piece of functionality
- [ ] Commit after each meaningful unit of work
- [ ] If a task is bigger than expected, split it and defer the second half
- [ ] If blocked, log the blocker and move to the next item

**AI Prompt Tip:** *Keep AI focused by stating what you are working on:*
> *"I am implementing US-201 (subscription dashboard). The acceptance criteria are [criteria]. Let's start with the API endpoint."*

### 3. Review (end of bolt)

- [ ] Run the full test suite
- [ ] Review all code written this bolt (use AI to assist)
- [ ] Verify acceptance criteria for completed items
- [ ] Update item statuses in PM-FRAMEWORK.md
- [ ] Update the Traceability Matrix

**AI Prompt Tip:** *Ask for a review:*
> *"Review all changes I made this bolt. Check for bugs, missing edge cases, and adherence to our conventions in CLAUDE-CONTEXT.md."*

### 4. Retro (end of bolt)

- [ ] Write a Captain's Log entry (see below)
- [ ] Update CLAUDE-CONTEXT.md "Current State" and "Known Issues"
- [ ] Note any process improvements for the next bolt
- [ ] Celebrate what you shipped

---

## Captain's Log Template

Write a Captain's Log entry at the end of every bolt. This is your personal project journal and helps maintain continuity between sessions.

```markdown
## Captain's Log: Bolt-NNN -- YYYY-MM-DD

### Goal
<!-- What was this bolt supposed to accomplish? -->

### What Got Done
- <!-- Item 1 and its outcome -->
- <!-- Item 2 and its outcome -->

### What Did Not Get Done
- <!-- Item and reason (blocked, underestimated, deprioritized) -->

### Surprises / Learnings
- <!-- Anything unexpected that came up -->
- <!-- Technical discoveries, changed assumptions -->

### Blockers
- <!-- Current blockers and their status -->

### AI Effectiveness
- <!-- How well did AI assist this bolt? -->
- <!-- What prompts worked well? What did not? -->
- <!-- Any context the AI was missing? -->

### Next Bolt Should Focus On
- <!-- Top priority for the next bolt -->
```

### Example Entry

```markdown
## Captain's Log: Bolt-003 -- 2025-06-15

### Goal
Get the subscription dashboard rendering real data from the API.

### What Got Done
- Dashboard API endpoint implemented and tested (US-201)
- Session timeout bug fixed (BUG-012) -- was missing middleware

### What Did Not Get Done
- Auth module unit tests (deprioritized; will carry to Bolt-004)

### Surprises / Learnings
- The ORM's lazy loading caused N+1 queries on the dashboard.
  Fixed with eager loading. Added a lint rule to catch this pattern.

### Blockers
- None currently.

### AI Effectiveness
- AI was very helpful for generating test cases from acceptance criteria.
- AI initially suggested a library that was incompatible with our runtime.
  Adding the runtime version to CLAUDE-CONTEXT.md prevented this from repeating.

### Next Bolt Should Focus On
- Auth module test coverage (carried over)
- CSV export backend (US-301)
```

---

## Context File Update Checklist

Run this checklist whenever you update CLAUDE-CONTEXT.md.

- [ ] **Project Identity:** Version number is current
- [ ] **Architecture Overview:** Diagram and component table reflect actual code
- [ ] **Conventions:** Any new conventions adopted this bolt are documented
- [ ] **Current State -- What Is Built:** Newly completed features listed
- [ ] **Current State -- In Progress:** Reflects actual current work
- [ ] **Current State -- Known Issues:** New bugs or tech debt added; resolved items removed
- [ ] **Key Decisions:** Any architectural decisions made this bolt are recorded
- [ ] **Environment Setup:** Still accurate (new dependencies, changed commands)
- [ ] **Testing:** Test commands and conventions still accurate
- [ ] **Deployment:** Any deployment changes reflected

**Why this matters:** Your AI assistant's effectiveness is directly proportional to the accuracy of this context file. Stale context produces stale suggestions.

---

## Blocker Management Flowchart

When you hit a blocker, follow this decision tree:

```
Encounter a blocker
        |
        v
Can I resolve it myself in < 15 minutes?
        |                |
       YES              NO
        |                |
        v                v
   Resolve it.     Log the blocker in PM-FRAMEWORK.md
                         |
                         v
                   Is someone else needed to unblock?
                         |                |
                        YES              NO (e.g., waiting on external service)
                         |                |
                         v                v
                   Contact them      Set a calendar reminder
                   immediately.      to check daily.
                         |                |
                         v                v
                   Switch to the next prioritized item.
                   Do NOT sit idle on a blocker.
```

### Blocker Log Format

When logging a blocker, include:

| Field | Description |
|-------|-------------|
| **What** | Clear description of what is blocked |
| **Why** | Root cause or dependency |
| **Impact** | What cannot proceed until this is resolved |
| **Owner** | Who can unblock (could be you, a vendor, a teammate) |
| **Workaround** | Is there a temporary workaround? |
| **Target Resolution** | When do you expect this resolved? |

---

## Common Pitfalls and How to Avoid Them

### 1. Stale Context File

**Pitfall:** You forget to update CLAUDE-CONTEXT.md and the AI gives suggestions based on outdated architecture or conventions.

**Fix:** Add context file update to your bolt retro checklist. Never end a bolt without updating it. Treat it like committing code -- non-negotiable.

### 2. Scope Creep Within a Bolt

**Pitfall:** You start a bolt with 3 items and end up working on 7 because "this quick fix will only take a minute."

**Fix:** Use Question 5 of the Five Questions Pattern. If unplanned work appears, add it to the backlog for the next bolt. The only exception is a P0 blocker.

### 3. Skipping Tests

**Pitfall:** You skip writing tests to "move faster" and accumulate hidden defects.

**Fix:** Track test delta as a metric. Your test count should increase every bolt. If it does not, something is wrong. Use AI to help generate test cases from acceptance criteria -- it is fast.

### 4. Over-Relying on AI Without Review

**Pitfall:** You accept AI-generated code without reading it carefully. Subtle bugs, security issues, or convention violations slip in.

**Fix:** Always review AI output. Use the bolt Review phase to do a second pass. Ask the AI to review its own code against your conventions.

### 5. Not Logging Blockers

**Pitfall:** You get stuck, try to power through for hours, and waste an entire session.

**Fix:** Apply the 15-minute rule. If you have not made progress on a blocker in 15 minutes, log it and switch tasks. Fresh eyes (or a new AI session) often solve it immediately.

### 6. Giant Commits

**Pitfall:** You work for an entire bolt without committing, then create one massive commit.

**Fix:** Commit after every meaningful unit of work. A good rule: if you can describe what you did in one sentence, commit it. This also creates better context for AI when reviewing history.

### 7. Losing Track of What Was Decided and Why

**Pitfall:** You make a design decision, forget why a week later, and revisit the same debate.

**Fix:** Record every significant decision in the Key Decisions table of CLAUDE-CONTEXT.md. Include the rationale and alternatives considered.

### 8. Ignoring the Retro

**Pitfall:** You skip the Captain's Log because it feels like overhead. A month later, you cannot remember what happened in early bolts.

**Fix:** Keep entries short (5 minutes to write). The example entry above took 3 minutes. Future-you will thank present-you.

---

## Quick Reference Card

| Activity | When | Reference |
|----------|------|-----------|
| Five Questions Pattern | Start of every bolt | This guide, "Five Questions" section |
| Bolt execution (Plan/Build/Review/Retro) | Every bolt | This guide, "Bolt Execution Checklist" |
| Captain's Log | End of every bolt | This guide, "Captain's Log Template" |
| Update context file | End of every bolt | CLAUDE-CONTEXT.md + this guide's checklist |
| Update traceability matrix | When items start/complete | TRACEABILITY-MATRIX.md |
| Update PM metrics | End of every bolt | PM-FRAMEWORK.md "Metrics Tracking" |
| Blocker escalation | After 15 minutes stuck | This guide, "Blocker Management" |

---

## Cross-References

- **Context File:** See [CLAUDE-CONTEXT.md](./CLAUDE-CONTEXT.md) -- keep this current
- **PM Framework:** See [PM-FRAMEWORK.md](./PM-FRAMEWORK.md) -- sprint/bolt structure and metrics
- **Requirements:** See [REQUIREMENTS.md](./REQUIREMENTS.md) -- source of truth for what to build
- **User Stories:** See [USER-STORIES.md](./USER-STORIES.md) -- detailed story specifications
- **Traceability:** See [TRACEABILITY-MATRIX.md](./TRACEABILITY-MATRIX.md) -- requirement-to-deployment tracking
- **Security:** See [SECURITY.md](./SECURITY.md) -- security practices and review checklist

---

## Revision History

| Date | Version | Author | Changes |
|------|---------|--------|---------|
| *<!-- TODO: Date -->* | *0.1* | *<!-- TODO: Author -->* | *Initial workflow guide created* |
