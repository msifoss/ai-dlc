# Autonomous Execution Guide

How to move from "human-in-the-loop" to "human-in-the-training-loop" — a reference for AI-assisted development that is disciplined, persistent, and self-improving.

---

## The Five Tenets

These five principles govern how AI agents execute within the AI-DLC framework. They apply regardless of tooling, model, or team size.

### Tenet 1: Exhaust Before Asking

Attempt every reasonable approach before interrupting the human. Research the codebase, read documentation, try alternative implementations. The human's time is the scarcest resource in the system.

**In practice:**
- Search for answers in the context file, captain's logs, and existing code before asking
- Try at least two alternative approaches when the first fails
- When you must ask, present what you tried and why it did not work

**Boundary:** Never proceed silently past a [human decision gate](../framework/PHASE-3-CONSTRUCTION.md). Gates exist precisely because the decision requires human judgment.

### Tenet 2: Prove, Don't Claim

Every assertion must be backed by evidence — a passing test, a working command, a verified output. "It should work" is not acceptable. "All 47 tests pass" is.

**In practice:**
- Run tests after every implementation change
- Verify commands execute successfully before reporting completion
- Include evidence in captain's log entries and completion reports

### Tenet 3: Persist Until Verified Complete (The Ascent)

Do not declare completion at the first sign of success. Continue verifying until every acceptance criterion is satisfied, every test passes, and the system functions as specified. See [The Ascent](#the-ascent) below.

**In practice:**
- Run the full test suite, not just the tests you wrote
- Verify against every acceptance criterion, not just the primary one
- Check for regressions in adjacent components

### Tenet 4: Fail Loudly, Never Silently

When something goes wrong, report it immediately with full context. Silent failures compound into production incidents. A reported failure is a fixable failure.

**In practice:**
- Flag errors the moment they occur — do not bury them in logs
- Include the error, the context, and the attempted resolution
- Escalate blockers per the [blocker management protocol](../framework/PHASE-3-CONSTRUCTION.md)

### Tenet 5: Leave the System Better

Every interaction should improve the project's knowledge base. Update context files, document discoveries, capture patterns. The next session should start smarter than this one.

**In practice:**
- Update CLAUDE.md when you discover new patterns or constraints
- Record technical insights in captain's logs
- Extract reusable patterns into the pattern catalog

---

## The Ascent

The Ascent is the persistence discipline that separates reliable AI-assisted development from chatbot-style collaboration. It is the operational form of Tenet 3.

### The Pattern

```
┌──────────────────────────────────────────────────────────┐
│                      THE ASCENT                           │
│                                                           │
│  1. IMPLEMENT — Write code and tests per specification    │
│  2. VERIFY    — Run full test suite + lint + type check   │
│  3. CHECK     — Compare output against acceptance criteria│
│  4. DECIDE    — All criteria met?                         │
│     ├── NO  → Return to step 1 (fix, extend, retry)      │
│     └── YES → Proceed to step 5                          │
│  5. CONFIRM   — Report completion with evidence           │
│                                                           │
│  The loop repeats until verified complete.                │
│  Premature declaration of "done" is an anti-pattern.      │
└──────────────────────────────────────────────────────────┘
```

### Why It Matters

Without The Ascent, AI-assisted development degrades into a "one-shot" pattern:

| Pattern | Behavior | Outcome |
|---------|----------|---------|
| **One-shot** | Generate code, declare done | Works 60-70% of the time; failures discovered later |
| **The Ascent** | Generate, verify, fix, re-verify, confirm | Works 95%+ of the time; failures caught immediately |

The cost of The Ascent is a few extra minutes per bolt. The cost of skipping it is hours of debugging in production.

### Ascent Completion Criteria

A bolt is complete only when ALL of the following are true:

- [ ] All acceptance criteria from the user story are satisfied
- [ ] All tests pass (unit, integration, and e2e as applicable)
- [ ] Linter and type checker produce zero errors
- [ ] No regressions in existing tests
- [ ] Captain's log entry written with evidence of completion
- [ ] Traceability matrix updated with code path and test ID

### When to Exit the Loop

Exit The Ascent only when:
1. All criteria above are met (normal exit), or
2. A blocker requires human judgment (escalation exit — see [blocker management](../framework/PHASE-3-CONSTRUCTION.md)), or
3. The time box is exceeded by >50% (split exit — break the bolt into smaller units)

Never exit because "it mostly works" or "I'll fix it in the next bolt."

---

## Multi-Agent Specialization

Complex projects benefit from specialized agents — AI sessions configured for specific types of work. This is not about running many agents simultaneously; it is about matching the right agent configuration to the right task.

### Agent Taxonomy

| Agent Type | Specialization | Typical Tasks | Model Routing |
|------------|---------------|---------------|---------------|
| **Architect** | System design and specification | ADRs, technical specs, API contracts | Standard/Complex |
| **Builder** | Implementation and testing | Code generation, test writing, refactoring | Standard |
| **Reviewer** | Quality and security analysis | Five-persona review, code review, audit | Standard/Complex |
| **Ops** | Infrastructure and deployment | Pipeline config, IaC, monitoring setup | Standard |
| **Scout** | Research and investigation | Dependency analysis, API exploration, debugging | Lightweight |
| **Scribe** | Documentation and reporting | Captain's logs, runbooks, release notes | Lightweight |

### Smart Model Routing

Not every task requires the most capable (and expensive) model. Route tasks to the appropriate model tier based on complexity:

| Tier | Complexity Indicators | Examples |
|------|----------------------|----------|
| **Lightweight** | Well-defined, mechanical, low-risk | Formatting, simple refactoring, log writing, boilerplate generation |
| **Standard** | Moderate complexity, established patterns | Feature implementation, test writing, standard code review |
| **Complex** | Novel problems, security-critical, architectural | Architecture decisions, security review, complex debugging, specification writing |

**Routing guidance:**
- Default to Standard tier for most construction work
- Use Lightweight for repetitive, well-defined tasks to reduce cost and latency
- Reserve Complex for decisions that are expensive to reverse (architecture, security, data model)
- When in doubt, route up — the cost of a wrong decision exceeds the cost of a better model

### Delegation Rules

When should work be delegated to a specialized agent versus handled directly?

| Delegate When | Handle Directly When |
|---------------|---------------------|
| Task requires a different skill profile (e.g., security review during construction) | Task is within the current agent's specialization |
| Task would benefit from a fresh context window | Task requires context already loaded in the current session |
| Task is independent and can run in parallel | Task depends on the current agent's output |
| Task is large enough to justify context-switching overhead | Task is small (< 15 minutes) |

### Tool-Agnostic Implementation

Multi-agent specialization can be implemented with any AI tooling:

- **Single-model tools:** Use different sessions with specialized context preambles
- **Multi-model tools:** Route to different models based on task complexity
- **Orchestration frameworks:** Configure agent roles and routing rules declaratively
- **Manual approach:** A developer can act as the orchestrator, switching between specialized sessions

The principle is tool-agnostic: match specialization to task, regardless of how the matching is implemented.

---

## The Learning Paradox

> "Human-in-the-training-loop, not human-in-the-loop."

Traditional AI collaboration puts the human in the loop for every decision — the AI proposes, the human reviews, the AI continues. This works but does not scale. The human becomes the bottleneck.

The Learning Paradox inverts this: the human trains the system (through context files, patterns, and feedback), and the AI executes autonomously within the trained boundaries. The human intervenes only at [human decision gates](../framework/PHASE-3-CONSTRUCTION.md) and when the AI encounters situations outside its trained context.

### How It Works

```
Traditional:    Human ←→ AI ←→ Human ←→ AI ←→ Human (every step)

Learning Loop:  Human trains context → AI executes autonomously →
                Human reviews at gates → Feedback improves context →
                AI executes better next time
```

### The Training Investment

| Investment | Mechanism | Payoff |
|-----------|-----------|--------|
| Write clear context files | CLAUDE.md with specific conventions | AI follows conventions without asking |
| Document decisions with rationale | ADRs, captain's logs | AI makes consistent decisions in similar situations |
| Capture patterns and anti-patterns | Pattern catalog in [Phase 6](../framework/PHASE-6-EVOLUTION.md) | AI avoids known mistakes automatically |
| Define clear acceptance criteria | [Phase 2](../framework/PHASE-2-ELABORATION.md) user stories | AI knows when work is complete |
| Provide corrective feedback | Five Questions corrections, code review comments | AI learns team preferences over time |

### Boundaries of Autonomy

The AI executes autonomously within trained boundaries but always defers to humans for:

- Architecture decisions that are expensive to reverse
- Security acceptance and risk decisions
- Scope changes and priority shifts
- Deployment approval
- Budget and cost threshold decisions
- Any situation not covered by existing context

---

## Trust-Adaptive Gates

Not all work requires the same level of ceremony. Trust-adaptive gates scale review intensity based on earned trust, risk level, and track record.

### Trust Levels

| Level | Name | Description | Gate Ceremony |
|-------|------|-------------|---------------|
| 0 | **New** | First engagement, no track record | Full ceremony — every deliverable reviewed in detail |
| 1 | **Established** | Consistent quality over 5+ bolts | Standard ceremony — review at phase transitions and major decisions |
| 2 | **Trusted** | Proven track record over 20+ bolts with minimal rework | Light ceremony — review at phase transitions, spot-check during construction |
| 3 | **Autonomous** | Extended track record, mature context files, stable patterns | Minimal ceremony — review at human decision gates only, automated verification for the rest |

### Earning Trust

Trust increases through demonstrated reliability:

| Indicator | Trust Impact |
|-----------|-------------|
| Bolt completes with zero rework | +1 toward next level |
| All tests pass on first run | +1 toward next level |
| Security review finds zero critical/high issues | +1 toward next level |
| Captain's log is complete and accurate | +1 toward next level |
| Context file update is relevant and correct | +1 toward next level |

Trust decreases through failures:

| Indicator | Trust Impact |
|-----------|-------------|
| Production incident caused by uncaught defect | Reset to Level 1 |
| Security finding reintroduced after remediation | -1 level |
| Acceptance criteria not met on completion | -1 level |
| Silent failure (error not reported) | Reset to Level 0 |

### Risk Tier Overrides

Regardless of trust level, certain categories of work always require full ceremony:

| Risk Tier | Description | Minimum Gate Level |
|-----------|-------------|-------------------|
| **Tier 1: Critical** | Authentication, authorization, payment processing, PII handling, cryptography | Full ceremony (Level 0 gates) |
| **Tier 2: Significant** | API contracts, data model changes, infrastructure topology, third-party integrations | Standard ceremony (Level 1 gates minimum) |
| **Tier 3: Normal** | Feature implementation, UI changes, configuration updates, documentation | Trust-level ceremony applies |

### Applying Trust-Adaptive Gates

1. Assess the current trust level based on track record
2. Identify the risk tier of the current work
3. Apply the higher of the two ceremony levels
4. Record the gate decision in the captain's log

**Example:** A Trust Level 2 developer working on a Tier 1 (authentication) feature still applies full ceremony because the risk tier overrides the trust level.

---

## Execution Modes

AI-DLC supports four execution modes. Select the mode that matches the project's needs, team structure, and risk profile.

| Mode | Description | Best For | Gate Frequency |
|------|-------------|----------|---------------|
| **The Ascent** | Single agent persists until verified complete | Solo developer, focused tasks, most construction work | Per-bolt verification |
| **Orchestrated** | Coordinator agent delegates to specialists | Complex features requiring multiple specializations | Per-delegation checkpoint |
| **Parallel** | Multiple agents work on independent tasks simultaneously | Independent bolts with no shared state | Per-agent completion, integration checkpoint |
| **Manual** | Human drives every step, AI assists on request | Learning the framework, high-risk work, unfamiliar domains | Every step |

### Mode Selection Guide

```
Is the task a single, focused bolt?
├── Yes → The Ascent
└── No
    ├── Can the work be split into independent pieces?
    │   ├── Yes → Parallel (with integration checkpoint)
    │   └── No  → Orchestrated
    └── Is this high-risk or in an unfamiliar domain?
        └── Yes → Manual
```

### Transitioning Between Modes

Start with Manual mode when adopting AI-DLC. As trust builds and context files mature, transition to The Ascent for most work. Use Orchestrated and Parallel modes when project complexity demands them.

| Transition | When | Prerequisites |
|-----------|------|---------------|
| Manual → The Ascent | After 5+ successful bolts | Context file is comprehensive, conventions are documented |
| The Ascent → Orchestrated | When bolts require multiple specializations | Agent taxonomy defined, delegation rules established |
| The Ascent → Parallel | When independent bolts accumulate | Clear task boundaries, no shared state between tasks |
| Any → Manual | When trust decreases or domain is unfamiliar | Always available as a fallback |

---

## Anti-Patterns

### Chatbot Collaboration

**What it looks like:** The developer treats the AI as a Q&A chatbot — asking one question, getting an answer, asking another. No persistent context, no structured workflow, no verification.

**Why it fails:** Context is lost between messages. The AI cannot build on previous work. Quality depends entirely on the developer remembering to check everything.

**The fix:** Structured bolt cadence with persistent context files and The Ascent verification loop.

### Premature Declaration of Completion

**What it looks like:** The AI generates code, runs one test, and declares the bolt complete. The remaining acceptance criteria are not checked.

**Why it fails:** Unchecked criteria become production bugs. The developer trusts "it's done" and moves on.

**The fix:** The Ascent — verify against ALL acceptance criteria before declaring complete.

### Token Optimization at Human Expense

**What it looks like:** The AI minimizes token usage by skipping context, abbreviating responses, or omitting verification steps. The output looks efficient but misses important details.

**Why it fails:** Saving tokens is false economy when the human must spend time filling in gaps, debugging incomplete implementations, or re-reading unclear summaries.

**The fix:** Optimize for human comprehension, not token count. Include sufficient context, evidence, and explanation.

### Over-Delegation Without Verification

**What it looks like:** The orchestrator agent delegates work to specialists but does not verify the results. Each specialist reports success, but the integrated system fails.

**Why it fails:** Individual component success does not guarantee system-level success. Integration points are where bugs hide.

**The fix:** Every delegation ends with an integration verification step. The orchestrator confirms the delegated work integrates correctly before proceeding.

### Context File Neglect

**What it looks like:** The context file is written once during Phase 0 and never updated. By Phase 3, it is stale. The AI follows outdated conventions and makes decisions based on superseded architecture.

**Why it fails:** Stale context produces confidently wrong output. The AI does not know what it does not know.

**The fix:** Update the context file after every bolt (see [Phase 6: Evolution](../framework/PHASE-6-EVOLUTION.md) for the learning system that keeps context current).

---

## Cross-References

- [Phase 2: Elaboration](../framework/PHASE-2-ELABORATION.md) — Five Questions Pattern and artifact hierarchy
- [Phase 3: Construction](../framework/PHASE-3-CONSTRUCTION.md) — Bolt cadence, human decision gates, blocker management
- [Phase 6: Evolution](../framework/PHASE-6-EVOLUTION.md) — Learning system, context maintenance, pattern extraction
- [Solo + AI Governance](../governance/SOLO-AI.md) — Trust-adaptive gates in solo workflow
- [Enterprise Governance](../governance/ENTERPRISE.md) — Trust-adaptive ceremony in enterprise context
- [Glossary](GLOSSARY.md) — Definitions of key terms
- [Audit Scoring](AUDIT-SCORING.md) — Assessment dimensions referencing autonomous execution
