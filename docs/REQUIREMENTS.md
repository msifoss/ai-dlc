# AI-DLC Framework — Requirements

Requirements for the AI-DLC framework itself. These define what the framework must provide and the quality standards its artifacts must meet.

## Functional Requirements

| ID | Requirement | Priority | Status |
|----|------------|----------|--------|
| FR-001 | Framework must define a complete software development lifecycle in sequential phases with clear entry/exit criteria | Critical | Implemented |
| FR-002 | Each phase guide must include Purpose, Entry Criteria, Activities, Deliverables, Exit Criteria, Human Decision Gates, Templates, and Pillar Checkpoints | Critical | Implemented |
| FR-003 | Framework must provide foundational document templates that are immediately usable (copy, fill placeholders, done) | Critical | Implemented |
| FR-004 | Framework must support three governance models: Solo+AI, Small Team (2-5 devs), and Enterprise (5+ devs) | High | Implemented |
| FR-005 | Framework must define four cross-cutting pillars (Security, Quality, Traceability, Cost) active in every phase | High | Implemented |
| FR-006 | Framework must provide a bootstrap mechanism (init script) for new projects | Medium | Implemented |
| FR-007 | Framework must include a self-assessment mechanism (dlc-audit) for measuring adoption | Medium | Implemented |
| FR-008 | Framework must define autonomous execution practices (The Ascent, trust-adaptive gates, multi-agent specialization) | High | Implemented |
| FR-009 | Framework must remain tool-agnostic — implementations may vary but principles are universal | Critical | Implemented |
| FR-010 | Framework must include a glossary defining all key terminology | Medium | Implemented |

## Non-Functional Requirements

| ID | Requirement | Priority | Status |
|----|------------|----------|--------|
| NFR-001 | All documents must be self-consistent (no contradictory guidance between phases) | Critical | Implemented |
| NFR-002 | Cross-references between documents must resolve to existing files | Critical | Implemented |
| NFR-003 | Framework must be understandable without external dependencies or paid tools | High | Implemented |
| NFR-004 | Phase guides must be actionable by a developer with no prior AI-DLC experience | High | Implemented |
| NFR-005 | Templates must contain clear TODO markers indicating what to fill in | High | Implemented |
| NFR-006 | Framework documentation should use active voice, imperative mood | Medium | Implemented |
| NFR-007 | Cloud-specific guidance must be cloud-neutral with provider sidebars | Medium | Implemented |
| NFR-008 | Context file (CLAUDE.md) must enable project orientation in under 5 minutes | High | Implemented |

## Security Requirements

| ID | Requirement | Priority | Status |
|----|------------|----------|--------|
| REQ-SEC-001 | Security pillar must cover OWASP Top 10 for LLMs | High | Implemented |
| REQ-SEC-002 | Five-Persona Review must include adversarial perspectives (attacker, auditor) | Critical | Implemented |
| REQ-SEC-003 | Framework must define finding severity levels and disposition workflow | High | Implemented |
| REQ-SEC-004 | Framework must define human decision gates for security-critical decisions | Critical | Implemented |
| REQ-SEC-005 | Risk tier system must enforce full ceremony for authentication, payments, PII, and cryptography regardless of trust level | High | Implemented |
