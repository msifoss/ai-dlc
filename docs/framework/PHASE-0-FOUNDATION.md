# Phase 0: Foundation — Project Bootstrap

## Purpose

Phase 0 transforms an empty directory into a structured, AI-ready project. It establishes the persistent context, governance model, repository layout, and tooling that every subsequent phase depends on. Skip this phase and every AI session starts from zero — repeating mistakes, losing decisions, and producing inconsistent output.

**The context file is the highest-leverage artifact in AI-assisted development.** A well-written CLAUDE.md (or equivalent) pays dividends in every bolt, every session, and every phase that follows. Thirty minutes spent here saves dozens of hours downstream.

---

## Entry Criteria

| Criterion | Description |
|-----------|-------------|
| Intent exists | You have a project idea, migration, or initiative to pursue |
| Repository created | A bare repository (local or remote) is available |
| AI tooling accessible | You have access to an AI coding assistant (Claude, Copilot, Cursor, etc.) |

Phase 0 is the starting line. There are no prior deliverables required.

---

## Activities

### 1. Governance Model Selection

Select a governance model before writing any other document. The model determines how many humans approve decisions, how context is shared, and how rigorous each gate must be.

| Model | Team Size | Decision Authority | Context Strategy | Guide |
|-------|-----------|-------------------|------------------|-------|
| Solo + AI | 1 developer + AI | Developer decides all gates | Single CLAUDE.md, captain's logs | [Solo AI](../governance/SOLO-AI.md) |
| Small Team | 2-5 developers + AI | Rotating lead, PR-based gates | Shared CLAUDE.md, namespaced logs | [Small Team](../governance/SMALL-TEAM.md) |
| Enterprise | 5+ developers, multiple teams | Formal RACI, compliance gates | Federated context, central standards | [Enterprise](../governance/ENTERPRISE.md) |

**Selection criteria:**

- **Solo + AI** — Choose when one person owns the entire project. Fastest to bootstrap. All decision gates are self-reviewed. Best for prototypes, personal projects, and small production services.
- **Small Team** — Choose when 2-5 people share a codebase. Requires shared context conventions and branch strategy. PR reviews replace self-review at critical gates.
- **Enterprise** — Choose when compliance, audit trails, or multi-team coordination matter. Adds formal governance documents, approval workflows, and federated context management.

Record your selection in the context file. You can upgrade governance models later (solo to small team is common as projects grow), but establish the baseline now.

---

### 2. Repository Structure Setup

Create the directory layout. Consistent structure lets AI assistants navigate the project without repeated explanation.

```
your-project/
├── CLAUDE.md                        # AI context file (highest-leverage artifact)
├── README.md                        # Human-facing project overview
├── CHANGELOG.md                     # Version history
├── .gitignore                       # Language-appropriate ignores
├── docs/
│   ├── requirements/                # REQ-001 style requirements (Phase 1)
│   ├── architecture/                # ADRs and design documents (Phase 1-2)
│   ├── security/                    # Security reviews and findings (Phase 1+)
│   ├── operations/                  # Runbooks and operational docs (Phase 4-5)
│   └── decisions/                   # Captain's logs and decision records
├── src/                             # Application source code (Phase 3)
│   ├── [module-a]/
│   └── [module-b]/
├── tests/                           # Test files mirroring src/ structure (Phase 3)
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── infrastructure/                  # IaC definitions (Phase 2-5)
│   ├── terraform/                   # or cloudformation/, pulumi/, cdk/
│   └── docker/
├── scripts/                         # Build, deploy, and utility scripts
├── .github/                         # GitHub Actions workflows (or .gitlab-ci.yml, etc.)
│   └── workflows/
│       ├── ci.yml                   # Lint, test, build
│       └── cd.yml                   # Deploy pipeline
└── config/                          # Environment configs, feature flags
    ├── .env.example                 # Environment variable template (never commit .env)
    └── settings/
```

**Adapt this structure to your language and ecosystem.** A Python project uses `src/` differently than a Go project using `cmd/` and `internal/`. A frontend project adds `public/` and `components/`. The key principle is consistency — pick a layout and document it in CLAUDE.md.

---

### 3. Context File Creation

The context file is the single document that orients your AI assistant. Create it first, update it continuously, and treat it as a living artifact.

**Step-by-step creation procedure:**

1. Copy [templates/CLAUDE-CONTEXT.md](../../templates/CLAUDE-CONTEXT.md) to your project root as `CLAUDE.md`
2. Fill in the Project Identity section (name, type, version, license)
3. Write a 2-3 sentence description of what the project does
4. Document the repository structure (update as it evolves)
5. Define naming conventions for your language and framework
6. List key terminology specific to your domain
7. Add any constraints (regulatory, performance, budget)
8. Record the governance model selected in Activity 1

**What makes a good context file:**

| Attribute | Good | Bad |
|-----------|------|-----|
| Specificity | "API responses use snake_case JSON keys" | "Follow standard conventions" |
| Actionability | "Run `make test` before committing" | "Ensure quality" |
| Scope | Project-specific decisions and constraints | Generic programming advice |
| Currency | Updated after every major decision | Written once, never touched |
| Brevity | 50-150 lines of high-signal content | 500 lines of boilerplate |

**Context file sections to include:**

```markdown
# Project Name — Context File

## Project Identity
- Name, type, version, license

## What This Project Is
- 2-3 sentence description
- What it is NOT (prevent scope creep)

## Repository Structure
- Directory tree with explanations

## Conventions
- File naming, code style, commit messages
- Language-specific patterns

## Key Terminology
- Domain terms the AI must understand

## Architecture Decisions
- Critical choices and their rationale
- Updated as ADRs are written in Phase 1

## Constraints
- Regulatory, performance, budget, timeline

## Quality Standards
- Test coverage expectations
- Review requirements per governance model
```

---

### 4. Foundational Document Templates

AI-DLC provides 14 document templates. During Phase 0, copy the templates you will need and customize the headers. Do not fill in content yet — that happens in later phases.

**Phase 0 templates to initialize:**

| Template | Purpose | Fill During |
|----------|---------|-------------|
| [CLAUDE-CONTEXT.md](../../templates/CLAUDE-CONTEXT.md) | AI assistant context | Phase 0 (now) |
| [PM-FRAMEWORK.md](../../templates/PM-FRAMEWORK.md) | Project management setup | Phase 0 (now) |
| [REQUIREMENTS.md](../../templates/REQUIREMENTS.md) | Structured requirements | [Phase 1: Inception](PHASE-1-INCEPTION.md) |
| [SECURITY.md](../../templates/SECURITY.md) | Security policy | [Phase 1: Inception](PHASE-1-INCEPTION.md) |
| [USER-STORIES.md](../../templates/USER-STORIES.md) | Stories with acceptance criteria | [Phase 2: Elaboration](PHASE-2-ELABORATION.md) |
| [TRACEABILITY-MATRIX.md](../../templates/TRACEABILITY-MATRIX.md) | Requirements-to-test mapping | [Phase 2: Elaboration](PHASE-2-ELABORATION.md) |
| [CICD-DEPLOYMENT-PROPOSAL.md](../../templates/CICD-DEPLOYMENT-PROPOSAL.md) | Deployment pipeline design | [Phase 2: Elaboration](PHASE-2-ELABORATION.md) |
| [INFRASTRUCTURE-PLAYBOOK.md](../../templates/INFRASTRUCTURE-PLAYBOOK.md) | Infrastructure setup | [Phase 2: Elaboration](PHASE-2-ELABORATION.md) |
| [COST-MANAGEMENT-GUIDE.md](../../templates/COST-MANAGEMENT-GUIDE.md) | Cost tracking and controls | [Phase 2: Elaboration](PHASE-2-ELABORATION.md) |
| [SOLO-AI-WORKFLOW-GUIDE.md](../../templates/SOLO-AI-WORKFLOW-GUIDE.md) | Solo + AI development guide | [Phase 3: Construction](PHASE-3-CONSTRUCTION.md) |
| [MULTI-DEVELOPER-GUIDE.md](../../templates/MULTI-DEVELOPER-GUIDE.md) | Team collaboration | [Phase 3: Construction](PHASE-3-CONSTRUCTION.md) |
| [SECURITY-REVIEW-PROTOCOL.md](../../templates/SECURITY-REVIEW-PROTOCOL.md) | Review methodology | [Phase 4: Hardening](PHASE-4-HARDENING.md) |
| [OPS-READINESS-CHECKLIST.md](../../templates/OPS-READINESS-CHECKLIST.md) | Production readiness | [Phase 4: Hardening](PHASE-4-HARDENING.md) |
| [AI-DLC-CASE-STUDY.md](../../templates/AI-DLC-CASE-STUDY.md) | Document your journey | [Phase 6: Evolution](PHASE-6-EVOLUTION.md) |

---

### 5. Tool Configuration

Configure the development toolchain before writing any application code. Automated enforcement prevents entire categories of defects.

#### 5a. Linting and Formatting

Choose a linter and formatter for your language. Configure them with opinionated defaults — debates about style waste AI tokens and human attention.

| Language | Linter | Formatter | Config File |
|----------|--------|-----------|-------------|
| Python | ruff | ruff format | `pyproject.toml` |
| JavaScript/TypeScript | ESLint | Prettier | `.eslintrc.js`, `.prettierrc` |
| Go | golangci-lint | gofmt | `.golangci.yml` |
| Rust | clippy | rustfmt | `clippy.toml`, `rustfmt.toml` |
| Java | Checkstyle | google-java-format | `checkstyle.xml` |

**Commit your configuration files.** The AI assistant reads these to produce conforming code. An uncommitted `.prettierrc` means the AI cannot follow your style.

#### 5b. Pre-commit Hooks

Install pre-commit hooks to catch issues before they enter version control.

```yaml
# .pre-commit-config.yaml (example for Python)
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.8.0
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
        args: ['--maxkb=500']
      - id: detect-private-key
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.21.0
    hooks:
      - id: gitleaks
```

```bash
# Install hooks
pip install pre-commit    # or brew install pre-commit
pre-commit install
pre-commit run --all-files  # Validate on existing files
```

#### 5c. Editor Configuration

```ini
# .editorconfig
root = true

[*]
indent_style = space
indent_size = 4
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.{yml,yaml,json}]
indent_size = 2

[Makefile]
indent_style = tab
```

---

### 6. CI/CD Pipeline Skeleton

Create a minimal CI pipeline that runs on every push. It does not need to deploy anything yet — that comes in [Phase 5: Operations](PHASE-5-OPERATIONS.md). The skeleton ensures that quality gates exist from the first commit.

```yaml
# .github/workflows/ci.yml (GitHub Actions example)
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up environment
        # Language-specific setup here
        run: echo "Configure your language runtime"
      - name: Lint
        run: echo "Run your linter here"

  test:
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v4
      - name: Set up environment
        run: echo "Configure your language runtime"
      - name: Run tests
        run: echo "Run your test suite here"
      - name: Upload coverage
        run: echo "Upload coverage report"

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Dependency audit
        run: echo "Run dependency vulnerability scan"
      - name: Secret scan
        run: echo "Run secret detection"
```

**Cloud-specific alternatives:**

- **AWS:** CodePipeline + CodeBuild with `buildspec.yml`
- **Azure:** Azure Pipelines with `azure-pipelines.yml`
- **GCP:** Cloud Build with `cloudbuild.yaml`
- **GitLab:** `.gitlab-ci.yml` with stages for lint, test, security

Replace the `echo` placeholder commands with real tool invocations as you configure your language toolchain. The structure — lint then test then security scan — stays the same regardless of provider.

---

### 7. PM Framework Setup

Initialize your project management approach using [templates/PM-FRAMEWORK.md](../../templates/PM-FRAMEWORK.md).

Define:

- **Work unit:** Bolt (1-4 hours of focused work with planning, execution, review, retro)
- **Estimation:** T-shirt sizes (S: <1h, M: 1-2h, L: 2-4h, XL: 4h+ — break it down)
- **Tracking:** Captain's logs per bolt, summarized in context file
- **Cadence:** Define review frequency per governance model

| Governance Model | Review Cadence | Log Format |
|-----------------|----------------|------------|
| Solo + AI | After each bolt | Single captain's log file, append-only |
| Small Team | Daily standup + PR reviews | Namespaced logs per developer |
| Enterprise | Sprint reviews + formal gates | Structured reports with sign-off |

---

## Deliverables

Phase 0 produces the following artifacts. Check each before proceeding.

- [ ] **CLAUDE.md** (or equivalent context file) — filled in with project identity, structure, conventions
- [ ] **README.md** — human-facing project overview with quick start instructions
- [ ] **Repository structure** — directories created per the layout in Activity 2
- [ ] **Governance model** — selected and documented in context file
- [ ] **.gitignore** — language-appropriate, includes `.env`, credentials, build artifacts
- [ ] **Linter/formatter config** — committed and passing on empty/seed project
- [ ] **Pre-commit hooks** — installed and verified with `pre-commit run --all-files`
- [ ] **CI pipeline skeleton** — committed and passing (even if jobs are placeholder `echo` commands)
- [ ] **PM framework** — work unit, estimation, tracking, and cadence defined
- [ ] **Template files** — copied from AI-DLC templates directory, headers customized

---

## Exit Criteria

| Criterion | Verification |
|-----------|-------------|
| Context file exists and is specific | Review CLAUDE.md — it names the project, describes the structure, lists conventions |
| Repository structure matches the documented layout | Run `tree -d -L 2` and compare against CLAUDE.md |
| Governance model is recorded | Grep CLAUDE.md for governance model selection |
| Linting passes on seed project | Run the linter — zero errors |
| Pre-commit hooks fire on commit | Make a test commit — hooks execute |
| CI pipeline runs | Push to remote — pipeline triggers and passes |
| All Phase 0 deliverables are committed | `git status` shows clean working tree |

---

## Human Decision Gates

Phase 0 contains two human decision gates. These require deliberate human judgment — do not delegate them to AI.

### Gate 0.1: Governance Model Selection

**Decision:** Which governance model fits this project?

**Decide based on:**
- Current team size and expected growth
- Regulatory or compliance requirements
- Risk tolerance (solo + AI has faster iteration but less oversight)
- Project lifespan (short prototype vs. long-lived production system)

**Record:** Document the selection and rationale in CLAUDE.md.

### Gate 0.2: Foundation Review

**Decision:** Is the foundation sufficient to begin [Phase 1: Inception](PHASE-1-INCEPTION.md)?

**Verify:**
- Read CLAUDE.md end-to-end. Does it accurately describe the project?
- Check that the repository structure supports the planned architecture
- Confirm tooling works (lint, pre-commit, CI)
- Confirm you could hand this project to another developer (or a new AI session) and they could orient themselves within 5 minutes

**Record:** Note the review date in CLAUDE.md or in a captain's log entry.

---

## Templates

| Template | Usage in Phase 0 |
|----------|-------------------|
| [CLAUDE-CONTEXT.md](../../templates/CLAUDE-CONTEXT.md) | Copy as CLAUDE.md, fill in completely |
| [PM-FRAMEWORK.md](../../templates/PM-FRAMEWORK.md) | Initialize project management approach |

All 14 templates are listed in [Activity 4](#4-foundational-document-templates). Copy the full set into your project during Phase 0, but only fill in CLAUDE-CONTEXT.md and PM-FRAMEWORK.md now. The rest are populated in their respective phases.

---

## Pillar Checkpoints

Each pillar has specific Phase 0 obligations. Address these before exiting the phase.

### Security Pillar

- [ ] `.gitignore` includes `.env`, credentials, private keys, and platform-specific secrets
- [ ] Pre-commit hook includes secret detection (gitleaks or equivalent)
- [ ] No secrets are committed in the initial repository
- [ ] Security template ([SECURITY.md](../../templates/SECURITY.md)) is copied to the project

> See [Security Pillar](../pillars/PILLAR-SECURITY.md) for the full cross-phase security checklist.

### Quality Pillar

- [ ] Linter and formatter are configured and passing
- [ ] Pre-commit hooks enforce linting on every commit
- [ ] CI pipeline includes lint and test jobs (even if placeholder)
- [ ] Code review expectations are documented per governance model

> See [Quality Pillar](../pillars/PILLAR-QUALITY.md) for the full cross-phase quality checklist.

### Traceability Pillar

- [ ] CLAUDE.md documents the project's purpose and constraints
- [ ] Repository structure is documented and matches the actual layout
- [ ] Governance model selection is recorded with rationale
- [ ] Template files include `<!-- TODO: ... -->` markers for future content

> See [Traceability Pillar](../pillars/PILLAR-TRACEABILITY.md) for the full cross-phase traceability checklist.

### Cost Awareness Pillar

- [ ] Cost management template ([COST-MANAGEMENT-GUIDE.md](../../templates/COST-MANAGEMENT-GUIDE.md)) is copied to the project
- [ ] AI token/API cost tracking approach is defined (if applicable)
- [ ] Cloud resource budget expectations are noted in CLAUDE.md (if applicable)
- [ ] Free-tier or development-tier resource preferences are documented

> See [Cost Awareness Pillar](../pillars/PILLAR-COST.md) for the full cross-phase cost checklist.

---

## Why Foundation Matters

A project without Phase 0 looks like this:

> **Session 1:** "Build me a REST API for task management."
> AI produces code. No tests, no structure, no context file.
>
> **Session 2:** "Add authentication."
> AI has no memory of Session 1. It guesses at the existing structure. It picks a different naming convention. It adds a second, incompatible error handling pattern.
>
> **Session 5:** "Fix the bugs."
> AI cannot find the bugs because it does not understand the architecture. It introduces new inconsistencies. The developer spends more time correcting AI output than writing code manually.

A project with Phase 0 looks like this:

> **Session 1:** AI reads CLAUDE.md. It understands the project, its conventions, and its constraints. It produces code that follows the established patterns.
>
> **Session 2:** AI reads the updated CLAUDE.md (which now includes decisions from Session 1). It extends the existing architecture consistently.
>
> **Session 5:** AI reads the captain's logs and context file. It understands what was built, what was decided, and why. It fixes bugs without introducing new ones.

**The difference is Phase 0.** The context file is the memory that bridges AI sessions. The repository structure is the map that prevents the AI from getting lost. The tooling is the guardrail that catches mistakes automatically.

Invest in Phase 0. The return compounds with every subsequent phase.

---

## Step-by-Step Bootstrap Procedure

For those who prefer a linear checklist, here is the complete Phase 0 procedure:

```
 1. Create repository (local or remote)
 2. Select governance model (Gate 0.1)
 3. Create directory structure per Activity 2
 4. Copy CLAUDE-CONTEXT.md template → CLAUDE.md
 5. Fill in CLAUDE.md (project identity, structure, conventions)
 6. Write README.md (project overview, quick start)
 7. Create .gitignore (language-appropriate + secrets)
 8. Configure linter and formatter (commit config files)
 9. Install pre-commit hooks (verify with --all-files)
10. Create CI pipeline skeleton (commit workflow file)
11. Copy remaining 13 templates to project
12. Initialize PM framework (work unit, estimation, cadence)
13. Make initial commit
14. Review foundation (Gate 0.2)
15. Proceed to Phase 1: Inception
```

---

## Next Phase

When all exit criteria are met and both human decision gates are passed, proceed to [Phase 1: Inception](PHASE-1-INCEPTION.md) to transform your project intent into structured requirements and architecture decisions.
