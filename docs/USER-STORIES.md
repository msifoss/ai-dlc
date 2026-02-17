# AI-DLC Framework — User Stories

User stories for the AI-DLC framework itself. These describe what the framework's users need.

---

## US-001: Project Bootstrap
**As a** developer starting a new AI-assisted project,
**I want** a clear bootstrap process with templates and structure,
**so that** I can go from zero to a working project foundation in under 30 minutes.

**Acceptance Criteria:**
- [ ] Given I run the init script, when it completes, then I have CLAUDE.md and a docs/ directory with template stubs
- [ ] Given I read Phase 0, when I follow the steps, then my project has governance model selected and context file initialized
- [ ] Given I copy a template, when I fill in the TODO markers, then I have a usable project document

**Traces to:** FR-003, FR-006 | **Phase:** 0 | **Status:** Implemented

---

## US-002: Sequential Phase Guidance
**As a** developer building software with AI assistance,
**I want** clear phase-by-phase guidance with entry/exit criteria,
**so that** I know exactly what to do at each stage and when to advance.

**Acceptance Criteria:**
- [ ] Given I am in any phase, when I read the phase guide, then I know the entry criteria, activities, deliverables, and exit criteria
- [ ] Given I complete a phase's exit criteria, when I advance to the next phase, then I have all prerequisites met
- [ ] Given I encounter a gap during Construction, when I need to return to Elaboration, then the phase guide tells me how

**Traces to:** FR-001, FR-002 | **Phase:** 0-6 | **Status:** Implemented

---

## US-003: Requirements Elaboration
**As a** developer translating ideas into specifications,
**I want** a structured elaboration process that surfaces hidden assumptions,
**so that** I don't build the wrong thing based on unstated assumptions.

**Acceptance Criteria:**
- [ ] Given I start elaboration, when I use the Five Questions Pattern, then the AI surfaces 5 assumptions per cycle for human validation
- [ ] Given assumptions are validated, when I write user stories, then acceptance criteria reflect the validated assumptions
- [ ] Given stories are written, when I run Momus/Metis gates, then specification gaps are identified before construction

**Traces to:** FR-001, FR-008 | **Phase:** 2 | **Status:** Implemented

---

## US-004: Bolt-Driven Construction
**As a** developer implementing features,
**I want** a focused work unit (bolt) with plan/build/review/retro cadence,
**so that** I maintain quality and context across multiple implementation sessions.

**Acceptance Criteria:**
- [ ] Given I start a bolt, when I follow the 4-step cycle, then I produce working code, paired tests, and a captain's log entry
- [ ] Given I complete implementation, when I run The Ascent verification loop, then all acceptance criteria are verified before declaring done
- [ ] Given I finish a bolt, when I write the retro, then insights are captured in the captain's log and context file updated

**Traces to:** FR-001, FR-008 | **Phase:** 3 | **Status:** Implemented

---

## US-005: Security Review
**As a** developer shipping to production,
**I want** a structured adversarial security review process,
**so that** I catch vulnerabilities that standard code review misses.

**Acceptance Criteria:**
- [ ] Given I invoke the five-persona review, when the review completes, then I have findings from 5 hostile perspectives (attacker, auditor, ops, cost, user)
- [ ] Given findings are produced, when I triage them, then each has severity (Critical/High/Medium/Low) and disposition (fixed/accepted/deferred)
- [ ] Given a finding is deferred, when the next review occurs, then the deferred finding is re-evaluated

**Traces to:** REQ-SEC-001, REQ-SEC-002, REQ-SEC-003 | **Phase:** 4 | **Status:** Implemented

---

## US-006: Governance Scaling
**As a** team lead deciding how to adopt AI-DLC,
**I want** governance models appropriate to my team size,
**so that** ceremony matches team complexity without over- or under-engineering.

**Acceptance Criteria:**
- [ ] Given I am a solo developer, when I read the Solo+AI guide, then I know exactly which gates to follow and which to skip
- [ ] Given I lead a 3-person team, when I read the Small Team guide, then I know how to share context and divide review responsibility
- [ ] Given I work in enterprise, when I read the Enterprise guide, then I understand RACI, compliance gates, and cross-team traceability

**Traces to:** FR-004 | **Phase:** 0 | **Status:** Implemented

---

## US-007: Self-Assessment
**As a** developer or team using AI-DLC,
**I want** to measure how well I'm following the framework,
**so that** I can identify gaps and improve my process.

**Acceptance Criteria:**
- [ ] Given I run /dlc-audit, when the assessment completes, then I see scores across 9 dimensions with letter grades
- [ ] Given I score below 5 on a dimension, when I read the action items, then I have specific steps to improve
- [ ] Given I choose to fix items, when the fixes are applied, then re-assessment shows improved scores

**Traces to:** FR-007 | **Phase:** 6 | **Status:** Implemented

---

## US-008: Autonomous Execution
**As a** developer working with AI agents,
**I want** clear guidelines for autonomous AI execution with appropriate guardrails,
**so that** AI agents can work independently while humans maintain control at decision points.

**Acceptance Criteria:**
- [ ] Given I configure an AI session, when I follow the Autonomous Execution Guide, then the AI knows The Ascent pattern, trust levels, and execution modes
- [ ] Given trust is earned over 20+ clean bolts, when ceremony is reduced, then high-risk work still receives full review (risk tier override)
- [ ] Given the AI encounters a situation outside its trained context, when it reaches a human decision gate, then it escalates rather than guessing

**Traces to:** FR-008, REQ-SEC-004, REQ-SEC-005 | **Phase:** 3 | **Status:** Implemented

---

## US-009: Framework Evolution
**As a** long-term AI-DLC user,
**I want** a learning system that improves over time,
**so that** each development session is smarter than the last.

**Acceptance Criteria:**
- [ ] Given I complete a bolt retro, when I capture patterns, then the context file is updated with new rules
- [ ] Given patterns are older than 30 days without reinforcement, when the decay check runs, then stale patterns are flagged for review
- [ ] Given I run drift detection, when deviations are found, then they are classified and remediation steps are proposed

**Traces to:** FR-001 | **Phase:** 6 | **Status:** Implemented

---

## US-010: Tool Agnosticism
**As a** developer using any AI assistant,
**I want** the framework to work regardless of my tooling choices,
**so that** I'm not locked into a specific AI provider, IDE, or cloud platform.

**Acceptance Criteria:**
- [ ] Given I use any AI coding assistant, when I follow AI-DLC phases, then the process works without tool-specific features
- [ ] Given I use any cloud provider, when I read infrastructure guidance, then cloud-neutral language is used with provider-specific sidebars
- [ ] Given I use any project management tool, when I adopt bolt cadence, then the framework adapts to my existing workflow

**Traces to:** FR-009, NFR-007 | **Phase:** 0-6 | **Status:** Implemented
