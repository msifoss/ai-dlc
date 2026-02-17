# Glossary — AI-DLC Key Terms and Definitions

Alphabetical reference of key terms used throughout the AI-DLC framework.

---

### Acceptance Criteria

Specific, testable conditions that a user story must satisfy to be considered complete. Write in Given-When-Then format. Acceptance criteria drive test creation during Construction.

**Related:** [Phase 2: Elaboration](../framework/PHASE-2-ELABORATION.md), [USER-STORIES.md](../../templates/USER-STORIES.md)

---

### ADR (Architecture Decision Record)

A document that captures a significant architecture decision, the context in which it was made, the alternatives considered, and the rationale for the chosen option. ADRs are created during Phase 1 and referenced throughout all subsequent phases.

**Related:** [Phase 1: Inception](../framework/PHASE-1-INCEPTION.md)

---

### Agent Routing

The practice of directing AI tasks to models of appropriate capability based on task complexity. Lightweight tasks (formatting, boilerplate) use faster models; standard tasks (implementation, testing) use default models; complex tasks (security review, architecture) use the most capable models. Reduces cost without sacrificing quality.

**Related:** [Autonomous Execution Guide](AUTONOMOUS-EXECUTION-GUIDE.md)

---

### The Ascent

The persistence discipline in AI-DLC that requires AI agents to verify completion against all acceptance criteria before declaring a bolt done. The Ascent loop (implement → verify → check criteria → fix or confirm) replaces the common "generate and declare done" pattern. Premature declaration of completion is an anti-pattern.

**Related:** [Autonomous Execution Guide](AUTONOMOUS-EXECUTION-GUIDE.md), [Phase 3: Construction](../framework/PHASE-3-CONSTRUCTION.md)

---

### Bolt

The atomic unit of work in AI-DLC. A bolt is a focused task typically lasting 1-4 hours that follows a four-step cycle: plan, execute, review, retro. Every bolt produces code, tests, and a captain's log entry. Bolts replace sprints as the primary planning unit in AI-assisted development.

**Related:** [Phase 3: Construction](../framework/PHASE-3-CONSTRUCTION.md), [Bolt Metrics Guide](BOLT-METRICS-GUIDE.md)

---

### Bolt Metrics

Quantitative measurements captured for every bolt: commits, lines changed, tests added/modified, test delta, deploys, blocked time percentage, and time spent. Aggregated into sprint-level velocity, coverage trends, and estimation accuracy.

**Related:** [Bolt Metrics Guide](BOLT-METRICS-GUIDE.md)

---

### Build-Then-Harden

AI-DLC's philosophy that working code is a better artifact for review than abstract specifications. Build the system in Phase 3, then dedicate Phase 4 to security, monitoring, cost controls, and operational readiness. This replaces the traditional approach of over-specifying before writing code.

**Related:** [Phase 3: Construction](../framework/PHASE-3-CONSTRUCTION.md), [Phase 4: Hardening](../framework/PHASE-4-HARDENING.md)

---

### Conformance Score

A percentage (0-100%) measuring how well a child artifact addresses its parent artifact in the IDEA → INTENT → UNIT → BOLT hierarchy. Scores below 70% indicate significant gaps requiring revision before proceeding. Used during Phase 2 Elaboration validation gates.

**Related:** [Phase 2: Elaboration](../framework/PHASE-2-ELABORATION.md)

---

### Canary-Bug

An error that arises from an unstated assumption baked into early implementation. Canary-bugs go undetected because they match what the AI "thought" was correct. The Five Questions Pattern prevents canary-bugs by forcing assumptions into the open before implementation begins.

**Related:** [Phase 2: Elaboration](../framework/PHASE-2-ELABORATION.md), [Solo + AI Governance](../governance/SOLO-AI.md)

---

### Captain's Log

A decision record written during or after each bolt. Captures context, decisions, rationale, alternatives considered, and traceability links (REQ-xxx, US-xxx). Captain's logs are the bridge between ephemeral AI conversations and permanent project knowledge.

**Related:** [Traceability Pillar](../pillars/PILLAR-TRACEABILITY.md), [Phase 3: Construction](../framework/PHASE-3-CONSTRUCTION.md)

---

### Circuit Breaker

A resilience pattern that prevents cascading failures by stopping calls to a failing dependency after a threshold of failures. The circuit "opens" to block requests, then "half-opens" after a timeout to test recovery. Implemented during Phase 4 Hardening.

**Related:** [Phase 4: Hardening](../framework/PHASE-4-HARDENING.md)

---

### Context File

A persistent document (typically `CLAUDE.md`) that provides an AI assistant with project knowledge, conventions, architecture decisions, and constraints. The highest-leverage artifact in AI-assisted development. Updated continuously throughout all phases.

**Related:** [Phase 0: Foundation](../framework/PHASE-0-FOUNDATION.md), [CLAUDE-CONTEXT.md](../../templates/CLAUDE-CONTEXT.md)

---

### Dead Letter Queue (DLQ)

A queue that captures messages that failed processing after a configured number of retry attempts. DLQs prevent message loss and enable manual or automated reprocessing. Every async processor must have a DLQ with an alarm. Configured during Phase 4 Hardening.

**Related:** [Phase 4: Hardening](../framework/PHASE-4-HARDENING.md)

---

### Dependency Graph

An ordered map of UNIT-level artifacts showing which units must complete before others can begin. Generated during Phase 2 Elaboration and used to drive bolt sequencing in Phase 3 Construction.

**Related:** [Phase 2: Elaboration](../framework/PHASE-2-ELABORATION.md)

---

### Decommissioning

The structured process of removing features, components, or infrastructure from a production system. Includes announcement, migration, code removal, data cleanup, infrastructure teardown, and traceability updates. Performed during Phase 6 Evolution.

**Related:** [Phase 6: Evolution](../framework/PHASE-6-EVOLUTION.md)

---

### DLC-Audit

An 8-dimension assessment that measures how well a project follows the AI-DLC framework. Scores each dimension 0-10 and produces an overall maturity rating (Foundational, Developing, Operational, Optimized, Exemplary).

**Related:** [Audit Scoring](AUDIT-SCORING.md)

---

### Drift Detection

The practice of identifying and correcting deviations between intended state and actual state across four dimensions: infrastructure drift, configuration drift, process drift, and dependency drift. Active during Phase 6 Evolution.

**Related:** [Phase 6: Evolution](../framework/PHASE-6-EVOLUTION.md)

---

### Escalation Rules

Rules that automatically increase finding severity based on patterns: two or more High findings in the same component escalate to Critical; findings involving PII or credentials have a minimum severity of High; reintroduced findings escalate one level.

**Related:** [Security Pillar](../pillars/PILLAR-SECURITY.md), [Five-Persona Review](FIVE-PERSONA-REVIEW.md)

---

### Five-Phase Learning Loop

The continuous improvement cycle in Phase 6 Evolution: Passive Feedback, Pattern Extraction, Preference Learning, Context Injection, Agent Discovery. Converts production experience into institutional knowledge.

**Related:** [Phase 6: Evolution](../framework/PHASE-6-EVOLUTION.md)

---

### Forge

The construction execution phase in the Olympus orchestration system. Corresponds to Phase 3 (Construction) in AI-DLC. Named for the idea that working software is forged through disciplined, iterative bolt execution.

**Related:** [Phase 3: Construction](../framework/PHASE-3-CONSTRUCTION.md)

---

### Five Questions Pattern

AI-DLC's signature elaboration technique. Before implementation, the AI surfaces exactly five assumptions about the requirements. The human validates, corrects, or defers each assumption. This cycle repeats until no critical assumptions remain unvalidated. Prevents canary-bug errors.

**Related:** [Phase 2: Elaboration](../framework/PHASE-2-ELABORATION.md), [Solo + AI Governance](../governance/SOLO-AI.md)

---

### Five-Persona Review

AI-DLC's core adversarial review technique. A single AI reviews code from five hostile perspectives: Attacker, Auditor, Ops Engineer, Cost Analyst, and End User. Each persona produces independent findings. Run per bolt (quick scan), per phase (focused), and comprehensively during Phase 4 Hardening.

**Related:** [Five-Persona Review](FIVE-PERSONA-REVIEW.md), [Security Pillar](../pillars/PILLAR-SECURITY.md)

---

### Governance Model

The organizational structure that determines how decisions are made, reviews are conducted, and gates are enforced. AI-DLC defines three models: Solo + AI, Small Team, and Enterprise. Selected during Phase 0 Foundation.

**Related:** [Solo + AI](../governance/SOLO-AI.md), [Small Team](../governance/SMALL-TEAM.md), [Enterprise](../governance/ENTERPRISE.md)

---

### INTENT (Artifact)

The second level of the artifact hierarchy (IDEA → INTENT → UNIT → BOLT). An INTENT is a measurable objective derived from an IDEA, with specific success criteria and scope boundaries. INTENTs are elaborated during Phase 2 and validated through conformance scoring against their parent IDEA.

**Related:** [Phase 2: Elaboration](../framework/PHASE-2-ELABORATION.md)

---

### Hardening

Phase 4 of AI-DLC. A dedicated phase between Construction and Operations focused on production readiness. Organized into four bolts: Alarms + Monitoring (H1), Security Fixes (H2), Cost Controls (H3), and Ops Readiness Verification (H4). The key innovation of AI-DLC.

**Related:** [Phase 4: Hardening](../framework/PHASE-4-HARDENING.md)

---

### Human Decision Gate

A point in the AI-DLC lifecycle where a conscious human decision is required. AI proposes, but only humans approve architecture decisions, security acceptance, deployment triggers, and phase transitions. Gates exist in every phase.

**Related:** All phase guides document their specific gates.

---

### Kill Switch

An automated mechanism that throttles or disables expensive operations when cost thresholds are breached. Kill switches prevent runaway cloud spend. Implemented during Phase 4 Hardening and tested before production deployment.

**Related:** [Phase 4: Hardening](../framework/PHASE-4-HARDENING.md), [Cost Awareness Pillar](../pillars/PILLAR-COST.md)

---

### Learning Paradox

The principle that the most effective AI-assisted development invests in training the system (context files, patterns, feedback) rather than reviewing every output. "Human-in-the-training-loop, not human-in-the-loop." The human's role shifts from reviewing individual outputs to improving the system that produces them.

**Related:** [Autonomous Execution Guide](AUTONOMOUS-EXECUTION-GUIDE.md), [Phase 6: Evolution](../framework/PHASE-6-EVOLUTION.md)

---

### Magic Keywords

Trigger phrases in context files or prompts that activate specific AI behaviors or workflows. Examples include `/prodstatus` for operational health summaries and `/dlc-audit` for compliance assessment. Magic keywords codify common operations into repeatable commands.

**Related:** [Phase 5: Operations](../framework/PHASE-5-OPERATIONS.md)

---

### Maturity Rating

The overall assessment of a project's AI-DLC adoption, derived from the 8-dimension audit score: Foundational (0-3), Developing (3.1-5), Operational (5.1-7), Optimized (7.1-9), Exemplary (9.1-10).

**Related:** [Audit Scoring](AUDIT-SCORING.md)

---

### Metis Gate

A validation gate during Phase 2 Elaboration that reviews specifications for strategic alignment. Named after the concept of wisdom. Asks: "Does this specification actually solve the user's problem? Is there a simpler approach?"

**Related:** [Phase 2: Elaboration](../framework/PHASE-2-ELABORATION.md)

---

### Momus Gate

A validation gate during Phase 2 Elaboration that reviews specifications for gaps, contradictions, and ambiguities through adversarial questioning. Named after the concept of critique. Asks: "What happens if the user does X while Y is in state Z?"

**Related:** [Phase 2: Elaboration](../framework/PHASE-2-ELABORATION.md)

---

### Ops Readiness Checklist

A 47-item scored checklist across 8 categories (Logging, Monitoring, Alerting, Error Handling, Retry/Resilience, Data Integrity, Security Hardening, Deployment Readiness). Each item scores 0-2. Production-ready systems score 85+ out of 94.

**Related:** [Phase 4: Hardening](../framework/PHASE-4-HARDENING.md), [OPS-READINESS-CHECKLIST.md](../../templates/OPS-READINESS-CHECKLIST.md)

---

### Olympian

A specialized AI agent configured for a specific type of work within the multi-agent execution model. Examples include Builder (implementation), Reviewer (quality analysis), Scout (research), and Scribe (documentation). The term originates from the Olympus orchestration system, which pioneered multi-agent specialization for AI-DLC workflows.

**Related:** [Autonomous Execution Guide](AUTONOMOUS-EXECUTION-GUIDE.md)

---

### Pattern Extraction

The process of analyzing accumulated production feedback to identify recurring issues, successful approaches, and common mistakes. Part of the Five-Phase Learning Loop in Phase 6. Extracted patterns are injected into context files.

**Related:** [Phase 6: Evolution](../framework/PHASE-6-EVOLUTION.md)

---

### Prometheus (Pattern)

An interview-based requirement gathering pattern where the AI systematically interviews the human to extract requirements, constraints, and success criteria. Named for the Titan who brought knowledge to humanity. Used during Phase 1 Inception to formalize the IDEA artifact.

**Related:** [Phase 1: Inception](../framework/PHASE-1-INCEPTION.md)

---

### Risk Tier

A three-level classification of work based on potential impact. Tier 1 (Critical): authentication, payments, PII, cryptography. Tier 2 (Significant): API contracts, data model, infrastructure. Tier 3 (Normal): feature implementation, UI, configuration. Risk tiers override trust levels for gate ceremony decisions.

**Related:** [Autonomous Execution Guide](AUTONOMOUS-EXECUTION-GUIDE.md), [Phase 1: Inception](../framework/PHASE-1-INCEPTION.md)

---

### Severity (Finding)

A four-level classification for security and operational findings: Critical (fix immediately, block release), High (fix within current bolt/sprint), Medium (fix within current phase), Low (fix when convenient, track in backlog).

**Related:** [Security Pillar](../pillars/PILLAR-SECURITY.md), [Five-Persona Review](FIVE-PERSONA-REVIEW.md)

---

### Summit (Phase)

The deployment artifact generation phase in the Olympus orchestration system. Corresponds to Phase 5 (Operations) in AI-DLC. The Summit pattern auto-generates deployment guides, runbooks, monitoring configurations, and release notes from the codebase and operational context.

**Related:** [Phase 5: Operations](../framework/PHASE-5-OPERATIONS.md), [Autonomous Execution Guide](AUTONOMOUS-EXECUTION-GUIDE.md)

---

### Test Delta

The net change in test count for a bolt or sprint: tests added minus tests deleted. A positive test delta indicates growing test coverage. A negative or zero test delta is a warning sign that requires investigation.

**Related:** [Bolt Metrics Guide](BOLT-METRICS-GUIDE.md), [Quality Pillar](../pillars/PILLAR-QUALITY.md)

---

### Trust Level

A four-level scale (0-3) measuring earned confidence in AI execution quality. Level 0 (New): full ceremony required. Level 1 (Established): standard ceremony after 5+ clean bolts. Level 2 (Trusted): light ceremony after 20+ bolts with minimal rework. Level 3 (Autonomous): minimal ceremony with extended track record. Trust levels are overridden by risk tiers for high-impact work.

**Related:** [Autonomous Execution Guide](AUTONOMOUS-EXECUTION-GUIDE.md)

---

### Test-Paired Development

The practice of writing tests alongside code within the same bolt, rather than deferring tests to a separate phase. Every bolt that produces code also produces corresponding tests. The AI writes both simultaneously.

**Related:** [Phase 3: Construction](../framework/PHASE-3-CONSTRUCTION.md), [Quality Pillar](../pillars/PILLAR-QUALITY.md)

---

### Traceability Matrix

A living document that maps every requirement through its lifecycle: REQ-xxx to User Story to Spec Section to Code File to Test ID to Deployment Version. Updated at every phase transition. Gaps in the matrix indicate process failures.

**Related:** [Traceability Pillar](../pillars/PILLAR-TRACEABILITY.md), [TRACEABILITY-MATRIX.md](../../templates/TRACEABILITY-MATRIX.md)

---

### T-Shirt Sizing

The estimation method used for bolts: S (1-2 hours), M (2-4 hours), L (4-8 hours), XL (8+ hours, must be split). T-shirt sizes replace story points as the estimation unit. Calibrate quarterly based on actual delivery data.

**Related:** [Bolt Metrics Guide](BOLT-METRICS-GUIDE.md), [Phase 3: Construction](../framework/PHASE-3-CONSTRUCTION.md)

---

### Unit of Work

See **Bolt**. The bolt is the fundamental unit of work in AI-DLC, replacing the sprint story or task from traditional methodologies.

**Related:** [Bolt Metrics Guide](BOLT-METRICS-GUIDE.md)

---

### UNIT (Artifact)

The third level of the artifact hierarchy (IDEA → INTENT → UNIT → BOLT). A UNIT is a testable specification chunk derived from an INTENT, with specific acceptance criteria and defined scope. UNITs are validated through Momus and Metis gates during Phase 2 Elaboration.

**Related:** [Phase 2: Elaboration](../framework/PHASE-2-ELABORATION.md)

---

### Velocity

The number of bolts completed per week. Measured at the sprint level. Healthy projects sustain 3-5 bolts/week for a solo developer + AI. Velocity should be stable or gradually increasing; declining velocity signals process friction or growing complexity.

**Related:** [Bolt Metrics Guide](BOLT-METRICS-GUIDE.md)

---

### Vision Phase

The initial planning phase in the Olympus orchestration system. Corresponds to Phases 0-1 (Foundation and Inception) in AI-DLC. The Vision phase establishes project identity, requirements, and architecture through structured IDEA artifacts and the Prometheus interview pattern.

**Related:** [Phase 0: Foundation](../framework/PHASE-0-FOUNDATION.md), [Phase 1: Inception](../framework/PHASE-1-INCEPTION.md)

---

### Well-Architected Review

A structured review against a cloud provider's architecture framework (AWS Well-Architected, Azure Well-Architected, GCP Architecture Framework). Run during Phase 4 Hardening alongside the AI-DLC five-persona review.

**Related:** [AWS Well-Architected Mapping](AWS-WELL-ARCHITECTED-MAPPING.md)

---

### Won't Fix

A finding status indicating an accepted risk. Every Won't Fix decision must include: justification (why the risk is acceptable), compensating controls (what mitigates residual risk), review date (when to reassess), and approver (who accepted the risk).

**Related:** [Security Pillar](../pillars/PILLAR-SECURITY.md)
