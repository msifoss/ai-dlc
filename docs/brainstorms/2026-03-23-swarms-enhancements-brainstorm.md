---
date: 2026-03-23
topic: swarms-inspired-enhancements
status: complete
---

# Swarms-Inspired Enhancements to AI-DLC

## What We're Building

Four features inspired by patterns found in the Swarms multi-agent orchestration framework (v10.0.0), adapted to strengthen AI-DLC's skills ecosystem. These bring structured routing, formal decision-making, parallel execution, and intelligent composition to the existing 28 commands/skills.

## Why These Features

Analysis of the Swarms codebase revealed patterns that address real friction points in AI-DLC:
- Users must memorize 23+ command names (Skill Router solves this)
- Panel decisions lack formal structure (Voting Protocol solves this)
- Pipeline execution is strictly sequential even when it doesn't need to be (DAG Workflows solves this)
- Users manually decide which skills to compose (Auto Team Builder solves this)

## Key Decisions

- **Skill Router:** New `/route` command (or enhance `using-superpowers` routing). Uses keyword/semantic matching against skill descriptions to suggest the right command.
- **Voting Protocol:** Enhance existing `staff-panel` and `exec-review` with formal vote tallying, not replace them. Add structured voting rounds after debate.
- **DAG Workflows:** Enhance existing `/bolt-lfg` and `/dlc-loop` with dependency graph awareness. Phases that don't depend on each other run concurrently.
- **Auto Team Builder:** New `/compose` command that reads a Mission Brief or task description and outputs a recommended skill sequence with rationale.

## Features Detail

### 1. Skill Router
- Match user intent to best command via keyword/description matching
- Suggest top 1-3 commands with confidence and rationale
- Can be invoked explicitly (`/route "I need to review code quality"`) or integrated into the superpowers flow

### 2. Voting Protocol for Panels
- After independent analysis and debate, each panelist casts a formal vote
- Votes include: choice, confidence (1-5), key concern
- Tally produces: majority decision, dissent record, confidence-weighted result
- Dissent is preserved (not suppressed) — minority concerns become risk items

### 3. DAG Workflows
- Define phase dependencies as a directed acyclic graph
- Phases with no mutual dependencies execute in parallel via background agents
- Apply to both bolt pipeline (brainstorm→plan are sequential, but review+captainslog could parallel) and DLC loop (security+cost reviews concurrent)
- Fallback to sequential if dependency detection is ambiguous

### 4. Auto Team Builder
- Read Mission Brief or task description
- Match against skill catalog (descriptions, triggers, capabilities)
- Output recommended execution sequence as a DAG
- Include rationale for each skill selection
- User confirms or modifies before execution

## Constraints & Requirements

- All features are markdown skill files — no runtime dependencies, no Python code
- Must work within Claude Code's existing tool system (Agent, Bash, Read, Write, etc.)
- Voting protocol must preserve adversarial debate quality — voting supplements, not replaces, discussion
- DAG execution uses existing Agent tool with background agents
- Skill router must be maintainable as new skills are added (no hardcoded mappings)

## Success Criteria

- Skill Router correctly suggests the right command for 10 test scenarios
- Voting Protocol produces clearer, more traceable decisions in panel reviews
- DAG Workflows demonstrably reduce wall-clock time for parallel-eligible work
- Auto Team Builder produces sensible skill sequences for 5 sample Mission Briefs
- `/staff-panel` reviews and endorses all 4 designs (plus suggests improvements)

## Open Questions

- Should the Skill Router be a standalone command or embedded in the superpowers flow?
- What voting threshold constitutes consensus (simple majority, supermajority, unanimous)?
- How aggressive should DAG parallelization be (conservative = fewer parallel, aggressive = more)?
- Should Auto Team Builder auto-execute or always require human confirmation?

## Next Steps

Run `/staff-panel` on these 4 designs for expert review, then `/pm plan` to create implementation plan.
