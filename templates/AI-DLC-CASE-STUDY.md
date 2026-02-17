# AI-DLC Case Study

> **AI-DLC Reference:** Written in **Phase 6: Evolution**.
>
> Copy this template and fill it in after completing a project (or significant milestone) using the AI-DLC framework. This document captures what happened, what was learned, and what advice you would give to similar projects.

---

## 1. Project Overview

<!-- TODO: Fill in your project details. -->

| Property | Value |
|---|---|
| **Project Name** | *<!-- TODO -->* |
| **One-Line Description** | *<!-- TODO: e.g., "A customer-facing API for real-time inventory management" -->* |
| **Team Size** | *<!-- TODO: e.g., "2 developers + 1 AI coding assistant" -->* |
| **Timeline** | *<!-- TODO: e.g., "8 weeks (Jan 6 - Feb 28, 2026)" -->* |
| **Tech Stack** | *<!-- TODO: e.g., "Python/FastAPI, PostgreSQL, Redis, deployed on containers" -->* |
| **AI Tools Used** | *<!-- TODO: e.g., "Claude Code for development, Claude for code review" -->* |
| **Final Status** | *In production / In development / Paused / Archived* |

### What Was Built

<!-- TODO: Write 2-3 paragraphs describing the project. What problem does it solve? Who are the users? What are the key features? -->

*Describe the project here. Include the business context, the core functionality, and the scale (number of users, request volume, data volume, etc.).*

---

## 2. Governance Model Used

<!-- TODO: Select the governance model you used and describe any customizations. -->

**Model:** *Solo Developer / Small Team (2-5) / Enterprise*

### Why This Model Was Chosen

*<!-- TODO: Explain the rationale. Consider team size, project complexity, regulatory requirements, and organizational context. -->*

### Customizations to the Standard Model

*<!-- TODO: Describe any changes you made to the standard governance model. What did you add, remove, or modify? Why? -->*

| Standard Practice | Your Adaptation | Rationale |
|---|---|---|
| *<!-- TODO: e.g., "Per-bolt security scan" -->* | *<!-- TODO: e.g., "Skipped for UI-only bolts" -->* | *<!-- TODO: e.g., "No security surface in pure UI changes" -->* |
| *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* |

---

## 3. Phase-by-Phase Summary

### Phase 0: Discovery

**Duration:** *<!-- TODO: e.g., "3 days" -->*

**Key Activities:**
- <!-- TODO: What research was done? What stakeholders were consulted? -->
- <!-- TODO: What constraints and requirements were identified? -->
- <!-- TODO: What was the initial scope decision? -->

**Key Outputs:**
- <!-- TODO: e.g., "Project brief document", "Initial cost estimate", "Stakeholder alignment" -->

**Hindsight Notes:**
*<!-- TODO: What would you do differently in Discovery if you could start over? -->*

---

### Phase 1: Blueprint

**Duration:** *<!-- TODO: e.g., "5 days" -->*

**Key Activities:**
- <!-- TODO: What architecture decisions were made? -->
- <!-- TODO: How was the bolt map created? -->
- <!-- TODO: What security review was done? -->

**Key Outputs:**
- <!-- TODO: e.g., "Architecture document", "Bolt map (12 bolts)", "CI/CD proposal", "Initial security review" -->

**Bolt Map Summary:**

| Bolt # | Name | Estimated Effort | Actual Effort |
|---|---|---|---|
| 1 | *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* |
| 2 | *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* |
| 3 | *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* |
| <!-- TODO: Add all bolts --> | | | |

**Hindsight Notes:**
*<!-- TODO: Was the bolt map accurate? What was missed? What was over/under-estimated? -->*

---

### Phase 2: Scaffolding

**Duration:** *<!-- TODO: e.g., "2 days" -->*

**Key Activities:**
- <!-- TODO: What was set up? (repo, CI/CD, dev environment, project structure) -->
- <!-- TODO: How long did it take to get from zero to "first test passing"? -->

**Key Outputs:**
- <!-- TODO: e.g., "Repository with CI/CD pipeline", "Development environment", "Base project structure" -->

**Hindsight Notes:**
*<!-- TODO: Was the scaffolding sufficient? Did you have to redo any of it later? -->*

---

### Phase 3: Construction

**Duration:** *<!-- TODO: e.g., "4 weeks" -->*

**Key Activities:**
- <!-- TODO: How many bolts were completed? In what order? -->
- <!-- TODO: How was the bolt cycle (implement -> test -> review -> commit) experienced? -->
- <!-- TODO: What technical challenges arose? -->

**Construction Metrics:**

| Metric | Value |
|---|---|
| Bolts completed | *<!-- TODO -->* |
| Total commits | *<!-- TODO -->* |
| Tests written | *<!-- TODO -->* |
| Test coverage achieved | *<!-- TODO -->%* |
| Average bolt duration | *<!-- TODO: e.g., "2 days" -->* |
| Bolts that required re-planning | *<!-- TODO -->* |

**Hindsight Notes:**
*<!-- TODO: What patterns emerged during construction? What slowed you down? What accelerated you? -->*

---

### Phase 4: Hardening

**Duration:** *<!-- TODO: e.g., "1 week" -->*

**Key Activities:**
- <!-- TODO: What security review was done? What was found? -->
- <!-- TODO: What performance testing was done? Results? -->
- <!-- TODO: What operational readiness items were addressed? -->

**Security Review Summary:**

| Severity | Findings | Resolved | Accepted Risk |
|---|---|---|---|
| Critical | *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* |
| High | *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* |
| Medium | *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* |
| Low | *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* |

**Ops Readiness Score:** *<!-- TODO -->%*

**Hindsight Notes:**
*<!-- TODO: Was hardening sufficient? Were there issues found in production that should have been caught here? -->*

---

### Phase 5: Operations

**Duration:** *<!-- TODO: e.g., "Ongoing since YYYY-MM-DD" -->*

**Key Activities:**
- <!-- TODO: How was the launch? Any issues? -->
- <!-- TODO: What operational patterns emerged? -->
- <!-- TODO: What incidents occurred? How were they handled? -->

**Operational Metrics:**

| Metric | Value |
|---|---|
| Uptime since launch | *<!-- TODO -->%* |
| Incidents (P1/P2) | *<!-- TODO -->* |
| Mean time to detect (MTTD) | *<!-- TODO -->* |
| Mean time to resolve (MTTR) | *<!-- TODO -->* |
| Deployments per week | *<!-- TODO -->* |
| Monthly operating cost | *$<!-- TODO -->* |

**Hindsight Notes:**
*<!-- TODO: What operational surprises occurred? What monitoring gaps were discovered? -->*

---

### Phase 6: Evolution

**Key Activities:**
- <!-- TODO: What has changed since initial launch? -->
- <!-- TODO: What new features or capabilities were added? -->
- <!-- TODO: Has the architecture evolved? How? -->

**Hindsight Notes:**
*<!-- TODO: How well did the initial architecture accommodate change? What would you design differently? -->*

---

## 4. Metrics Summary

### Development Metrics

| Metric | Value |
|---|---|
| Total project duration | *<!-- TODO -->* |
| Bolts planned | *<!-- TODO -->* |
| Bolts completed | *<!-- TODO -->* |
| Bolts added mid-project | *<!-- TODO -->* |
| Bolts removed/deferred | *<!-- TODO -->* |
| Total commits | *<!-- TODO -->* |
| Lines of code (application) | *<!-- TODO -->* |
| Lines of code (tests) | *<!-- TODO -->* |
| Test coverage | *<!-- TODO -->%* |
| AI-assisted commits (%) | *<!-- TODO -->%* |

### Quality Metrics

| Metric | Value |
|---|---|
| Security findings (total) | *<!-- TODO -->* |
| Security findings (critical/high resolved) | *<!-- TODO -->* |
| Bugs found before production | *<!-- TODO -->* |
| Bugs found in production (first 30 days) | *<!-- TODO -->* |
| Ops readiness score at launch | *<!-- TODO -->%* |

### Cost Metrics

| Metric | Value |
|---|---|
| Development cost (human time) | *<!-- TODO -->* |
| AI/LLM token cost during development | *$<!-- TODO -->* |
| Monthly operating cost | *$<!-- TODO -->* |
| Cost vs. initial estimate | *<!-- TODO: e.g., "+15% over estimate" -->* |

---

## 5. Key Decisions and Rationale

Document the most important technical and process decisions made during the project.

<!-- TODO: Add 3-7 key decisions. -->

### Decision 1: *<!-- TODO: Decision title -->*

| Property | Value |
|---|---|
| **Phase** | *<!-- TODO: When was this decided? -->* |
| **Context** | *<!-- TODO: What was the situation? -->* |
| **Decision** | *<!-- TODO: What was decided? -->* |
| **Alternatives Considered** | *<!-- TODO: What else was considered? -->* |
| **Rationale** | *<!-- TODO: Why was this chosen? -->* |
| **Outcome** | *<!-- TODO: How did it turn out? -->* |

### Decision 2: *<!-- TODO: Decision title -->*

| Property | Value |
|---|---|
| **Phase** | *<!-- TODO -->* |
| **Context** | *<!-- TODO -->* |
| **Decision** | *<!-- TODO -->* |
| **Alternatives Considered** | *<!-- TODO -->* |
| **Rationale** | *<!-- TODO -->* |
| **Outcome** | *<!-- TODO -->* |

### Decision 3: *<!-- TODO: Decision title -->*

| Property | Value |
|---|---|
| **Phase** | *<!-- TODO -->* |
| **Context** | *<!-- TODO -->* |
| **Decision** | *<!-- TODO -->* |
| **Alternatives Considered** | *<!-- TODO -->* |
| **Rationale** | *<!-- TODO -->* |
| **Outcome** | *<!-- TODO -->* |

<!-- TODO: Add more decisions as needed. -->

---

## 6. Lessons Learned

### What Worked Well

<!-- TODO: List 3-7 things that worked well. Be specific. -->

1. *<!-- TODO: e.g., "The bolt-based approach kept scope manageable and progress visible." -->*
2. *<!-- TODO: e.g., "Per-bolt testing caught integration issues early." -->*
3. *<!-- TODO -->*

### What Did Not Work Well

<!-- TODO: List 3-7 things that did not work well. Be honest. -->

1. *<!-- TODO: e.g., "Initial bolt estimates were too optimistic for database-heavy bolts." -->*
2. *<!-- TODO: e.g., "Security review in Phase 1 was too superficial; Phase 4 found significant issues." -->*
3. *<!-- TODO -->*

### Surprises

<!-- TODO: What was unexpected? -->

1. *<!-- TODO: e.g., "AI-assisted development was 3x faster for CRUD operations but only 1.2x for complex business logic." -->*
2. *<!-- TODO -->*

---

## 7. Framework Adaptations

Describe how you customized the AI-DLC framework for your project. This helps future teams decide what to adopt and what to adapt.

### Additions (practices you added that are not in the standard framework)

| Practice | Description | Recommendation |
|---|---|---|
| *<!-- TODO -->* | *<!-- TODO -->* | *Keep / Situational / Drop* |

### Modifications (standard practices you changed)

| Standard Practice | Your Version | Why | Recommendation |
|---|---|---|---|
| *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* | *Keep modification / Revert to standard* |

### Removals (standard practices you skipped)

| Practice | Why Skipped | Impact | Recommendation |
|---|---|---|---|
| *<!-- TODO -->* | *<!-- TODO -->* | *<!-- TODO -->* | *Skip again / Do not skip* |

---

## 8. Recommendations for Similar Projects

<!-- TODO: Write specific, actionable advice for teams starting a project similar to yours. -->

### If You Are Starting a Similar Project, Do This

1. *<!-- TODO: e.g., "Spend an extra day in Phase 1 on database schema design -- changes later are expensive." -->*
2. *<!-- TODO: e.g., "Set up CI/CD with automated testing before writing any application code." -->*
3. *<!-- TODO -->*
4. *<!-- TODO -->*
5. *<!-- TODO -->*

### Avoid These Mistakes

1. *<!-- TODO: e.g., "Do not skip the ops readiness checklist -- we launched without proper monitoring and regretted it." -->*
2. *<!-- TODO: e.g., "Do not let bolt scope creep -- if a bolt takes more than 3 days, split it." -->*
3. *<!-- TODO -->*

### Tools and Resources That Helped

| Tool / Resource | How It Helped |
|---|---|
| *<!-- TODO -->* | *<!-- TODO -->* |
| *<!-- TODO -->* | *<!-- TODO -->* |

---

## 9. Approval & Sign-Off

| Role | Name | Date |
|---|---|---|
| Tech Lead | <!-- TODO --> | |
| Project Owner | <!-- TODO --> | |

---

*This case study contributes to the collective knowledge of the AI-DLC community. Consider sharing anonymized versions with other teams adopting the framework.*
