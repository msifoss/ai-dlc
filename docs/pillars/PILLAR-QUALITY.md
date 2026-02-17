# Pillar: Quality

> Cross-cutting concern active in **all seven phases** of the AI Development Life Cycle.

Quality is not a gate at the end — it is a discipline woven into every bolt, every merge, every deployment. AI-assisted development amplifies both productivity and risk: the AI can produce large volumes of plausible code that silently fails in production. This pillar defines the practices, tools, and standards that prevent that outcome.

---

## Table of Contents

- [Code Quality Gates](#code-quality-gates)
- [Pre-Commit Hook Configuration](#pre-commit-hook-configuration)
- [Testing Pyramid](#testing-pyramid)
- [Mock-Only vs Real-Data Testing](#mock-only-vs-real-data-testing)
- [CI/CD Quality Gates](#cicd-quality-gates)
- [Code Review Standards](#code-review-standards)
- [Test-Paired Development](#test-paired-development)
- [Phase-by-Phase Quality Activities](#phase-by-phase-quality-activities)
- [Templates and Cross-References](#templates-and-cross-references)

---

## Code Quality Gates

Every code change must pass four quality gates before merge. No exceptions, no overrides, no "we'll fix it later."

| Gate | Purpose | Fails On |
|---|---|---|
| **Formatting** | Consistent style, zero ambiguity | Any formatting difference from standard |
| **Linting** | Catch bugs, enforce patterns | Any lint error (warnings are errors in CI) |
| **Type Checking** | Catch type mismatches at build time | Any type error |
| **Testing** | Verify behavior matches intent | Any test failure, coverage below threshold |

### Gate Enforcement

- **Local:** Pre-commit hooks block commits that fail any gate.
- **CI:** Pull request checks block merge on any gate failure.
- **No bypass:** Do not use `--no-verify`, `# noqa`, `// @ts-ignore`, or `// nolint` without a documented justification comment explaining why the suppression is necessary.

### Coverage Thresholds

| Level | Threshold | Rationale |
|---|---|---|
| Overall line coverage | 80% minimum | Baseline safety net |
| New code coverage | 90% minimum | Fresh code has no excuse for missing tests |
| Critical path coverage | 100% | Authentication, payment, data mutation — full coverage or no merge |

---

## Pre-Commit Hook Configuration

Install quality gates as pre-commit hooks so violations never reach the repository. Below are configurations for common stacks.

### Python (black + ruff + mypy)

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/psf/black
    rev: 24.4.2
    hooks:
      - id: black
        args: [--line-length=99]
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.4.4
    hooks:
      - id: ruff
        args: [--fix, --exit-non-zero-on-fix]
  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.10.0
    hooks:
      - id: mypy
        additional_dependencies: [types-requests, types-pyyaml]
        args: [--strict]
```

Install: `pip install pre-commit && pre-commit install && pre-commit run --all-files`

### JavaScript / TypeScript (prettier + eslint)

```json
{
  "scripts": {
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "lint": "eslint . --max-warnings 0",
    "typecheck": "tsc --noEmit"
  },
  "lint-staged": {
    "*.{ts,tsx,js,jsx}": ["prettier --write", "eslint --fix --max-warnings 0"],
    "*.{json,md,yaml}": ["prettier --write"]
  }
}
```

Install: `npm i -D husky lint-staged prettier eslint typescript && npx husky init`
Then add `npx lint-staged` to `.husky/pre-commit`.

### Go (gofmt + golangci-lint)

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/dnephin/pre-commit-golang
    rev: v0.5.1
    hooks:
      - id: go-fmt
      - id: go-vet
  - repo: https://github.com/golangci/golangci-lint
    rev: v1.59.0
    hooks:
      - id: golangci-lint
        args: [--timeout=5m]
```

Enable linters in `.golangci.yml`: errcheck, gosimple, govet, ineffassign, staticcheck, unused, gosec, bodyclose, nilerr.

---

## Testing Pyramid

Structure tests in layers. Each layer has a distinct purpose, speed, and scope.

```
          ┌───────────┐
          │   E2E     │  10%  — Slow, expensive, high confidence
          │  Tests    │
         ┌┴───────────┴┐
         │ Integration  │  20%  — Medium speed, real connections
         │   Tests      │
        ┌┴──────────────┴┐
        │   Unit Tests    │  70%  — Fast, isolated, foundational
        └─────────────────┘
```

### Unit Tests (70% of test suite)

**Purpose:** Verify individual functions and classes in isolation. Execute in milliseconds. Mock all external dependencies. Same input always produces same output.

Use descriptive names: `test_expired_token_returns_401` not `test_auth_3`.

```python
def test_calculate_discount_applies_10_percent_for_annual_plan():
    result = calculate_discount(plan="annual", base_price=100.00)
    assert result == 90.00

def test_calculate_discount_rejects_negative_price():
    with pytest.raises(ValueError, match="Price must be positive"):
        calculate_discount(plan="annual", base_price=-50.00)
```

### Integration Tests (20% of test suite)

**Purpose:** Verify components work together with real connections. Use actual databases, APIs, and message queues. Focus on the seams between components. Reset state between tests.

```python
@pytest.mark.integration
def test_user_repository_persists_and_retrieves_user(db_session):
    repo = UserRepository(db_session)
    repo.create(User(name="Ada", email="ada@example.com"))
    user = repo.find_by_email("ada@example.com")
    assert user.name == "Ada"
```

### End-to-End Tests (10% of test suite)

**Purpose:** Verify critical user paths through the entire system. Test only critical paths (login, checkout, data export). Run against staging or a full local stack. Use `data-testid` selectors, not CSS classes.

```typescript
test("user can log in and view dashboard", async ({ page }) => {
  await page.goto("/login");
  await page.getByTestId("email-input").fill("user@example.com");
  await page.getByTestId("password-input").fill("secure-password");
  await page.getByTestId("login-button").click();
  await expect(page.getByTestId("dashboard-heading")).toBeVisible();
});
```

---

## Mock-Only vs Real-Data Testing

> **Lesson learned:** In a prior production project, Bolt 6 had all tests passing — 100% green. But every test used mocks that did not match real API responses. When the code hit production, it failed on the first real request. Mocks had different field names, missing nested objects, and wrong status codes.

### The Problem with Mock-Only Testing

Mocks encode assumptions about external systems. Those assumptions drift. When they drift, tests pass but code fails.

| Failure Mode | What Happens | Detection |
|---|---|---|
| Schema drift | Mock returns `{user_name: "Ada"}`, real API returns `{userName: "Ada"}` | Integration test against real API |
| Missing fields | Mock returns all fields, real API omits optional fields | Integration test with minimal responses |
| Error shape mismatch | Mock returns `{error: "msg"}`, real API returns `{errors: [{code: 422, detail: "msg"}]}` | Integration test for error paths |
| Rate limiting | Mock never rate-limits, real API returns 429 | Integration test with rate limit simulation |
| Pagination | Mock returns all records, real API paginates at 100 | Integration test with >100 records |

### The Fix: Layered Testing Strategy

1. **Unit tests** use mocks — this is correct and expected. Mocks keep unit tests fast and isolated.
2. **Integration tests** use real connections — at minimum one test per external dependency validates real behavior.
3. **Contract tests** (optional but recommended) — Record real API responses and replay them as validated mocks.

### Contract Testing Pattern

```python
# Record real response (run in CI nightly)
def record_api_contract():
    response = requests.get("https://api.example.com/v1/users/1")
    Path("contracts/users_get.json").write_text(json.dumps({
        "status_code": response.status_code,
        "body": response.json(),
    }, indent=2))

# Use recorded contract as validated mock in unit tests
@pytest.fixture
def user_api_response():
    return json.loads(Path("contracts/users_get.json").read_text())

def test_parse_user_response(user_api_response):
    user = parse_user(user_api_response["body"])
    assert user.name is not None
```

### Rules for Mock Usage

- **Allowed in unit tests:** Mock external services, databases, file systems, and network calls.
- **Forbidden in integration tests:** Use real connections or validated contract mocks only.
- **Validate mocks quarterly:** Schedule a CI job that compares mock shapes against live API responses.
- **Flag mock-only coverage:** If a service has only unit tests with mocks and no integration tests, flag it as a risk in the quality report.

---

## CI/CD Quality Gates

Enforce quality at three pipeline stages. Each stage adds confidence. No stage can be skipped.

### Stage 1: Pull Request Checks

Run on every PR before merge is allowed.

| Check | Tool Examples | Fail Behavior |
|---|---|---|
| Format check | black, prettier, gofmt | Block merge |
| Lint | ruff, eslint, golangci-lint | Block merge |
| Type check | mypy, tsc, go vet | Block merge |
| Unit tests | pytest, jest, go test | Block merge |
| Coverage check | coverage.py, istanbul, go cover | Block merge if below threshold |
| Secret scan | gitleaks, trufflehog | Block merge |

```yaml
# Example: GitHub Actions PR quality gate (adapt for your CI provider)
name: PR Quality Gate
on: pull_request
jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: black --check .        # Format
      - run: ruff check .            # Lint
      - run: mypy --strict src/      # Type check
      - run: pytest tests/unit/ --cov=src --cov-fail-under=80
      - run: gitleaks detect --source .  # Secret scan
```

### Stage 2: Merge Checks

Run after PR approval, before or immediately after merge to main.

| Check | Tool Examples | Fail Behavior |
|---|---|---|
| Integration tests | pytest (integration marker), testcontainers | Block deploy |
| Security scan | Snyk, Trivy, Dependabot | Block deploy on critical/high |
| License audit | license-checker, pip-licenses | Block deploy on copyleft in proprietary |

### Stage 3: Deploy Checks

Run in staging before production promotion.

| Check | Tool Examples | Fail Behavior |
|---|---|---|
| E2E tests | Playwright, Cypress, Selenium | Block production deploy |
| Dependency audit | npm audit, pip-audit, govulncheck | Block on critical CVEs |
| Smoke tests | Custom health check scripts | Block if core endpoints fail |
| Performance baseline | k6, Artillery, Locust | Warn if >20% regression |

---

## Code Review Standards

Adapt review rigor to team size. In all models, the AI Five-Persona Review provides baseline coverage.

### Solo + AI (1 developer)

The Five-Persona Review replaces human PR review. Complete the bolt, run the five-persona review against all changed files, address all Critical and High findings, log Medium and Low in backlog, then merge.

| Activity | Frequency | Output |
|---|---|---|
| Five-persona review | Every bolt | Finding log with severity |
| Self-review with AI | Every PR / merge | Code walkthrough, assumption check |
| Architecture review | Phase transitions | ADR validation, pattern check |

### Small Team (2-5 developers)

Human PR review plus AI-assisted review. The AI catches what humans miss; humans catch what AI misses. Open PR, run AI five-persona review and attach findings, human reviewer reviews both code and findings, address Critical/High, then merge.

| Activity | Frequency | Output |
|---|---|---|
| Human PR review | Every PR | Approval with comments |
| AI five-persona review | Every PR | Finding log |
| Pair programming | Complex features | Shared understanding |

### Enterprise (5+ developers, multiple teams)

Formal review with AI augmentation and dedicated security review for sensitive changes. Two human reviewers plus AI five-persona review. Security team reviews PRs touching auth, payment, or PII. Architecture review board at phase transitions.

| Activity | Frequency | Output |
|---|---|---|
| Human PR review (2+ reviewers) | Every PR | Approvals with comments |
| AI five-persona review | Every PR | Finding log |
| Security-team review | PRs touching auth, payment, PII | Security sign-off |
| Architecture review board | Phase transitions | Architecture approval |
| Compliance review | Before release | Compliance attestation |

### Oracle Verification Pattern

The Oracle pattern is a production-ready checklist that AI agents run before declaring any deliverable complete. It acts as the final quality gate before human review.

**Oracle checklist:**

- [ ] All acceptance criteria from the user story are explicitly verified
- [ ] All tests pass (unit, integration, and e2e as applicable)
- [ ] Linter and type checker produce zero errors
- [ ] No regressions in existing tests
- [ ] Code matches the technical specification (no drift)
- [ ] Security-sensitive changes flagged for Phase 4 review
- [ ] Traceability matrix updated with code path and test ID
- [ ] Captain's log entry written with evidence of completion

Run the Oracle checklist at the Review step of every bolt. The Oracle does not replace human review — it ensures human reviewers receive verified, complete work.

### Artifact Conformance Scoring

Validate specifications against their parent artifacts using conformance scoring:

| Score | Meaning | Quality Impact |
|-------|---------|---------------|
| 90-100% | Full alignment | Proceed to construction — specification is sound |
| 70-89% | Partial alignment | Address gaps before construction; flag for reviewer |
| 50-69% | Significant gaps | Return to elaboration; do not proceed to construction |
| Below 50% | Misalignment | Reject; restart elaboration from parent artifact |

See [Phase 2: Elaboration](../framework/PHASE-2-ELABORATION.md) for the artifact hierarchy and validation process.

### Trust-Adaptive Review Thresholds

Scale review intensity based on earned trust:

| Trust Level | Review Depth | Coverage Check |
|-------------|-------------|---------------|
| Level 0 (New) | Line-by-line review of all changes | 100% of new code reviewed |
| Level 1 (Established) | Focus on logic, security, and API surfaces | 80% of new code reviewed |
| Level 2 (Trusted) | Focus on architecture-impacting and security-sensitive changes | 50% of new code reviewed |
| Level 3 (Autonomous) | Automated checks + human review at phase gates only | Spot-check 20% of new code |

**Risk tier override:** All Tier 1 (Critical) changes receive Level 0 review regardless of trust. See the [Autonomous Execution Guide](../reference/AUTONOMOUS-EXECUTION-GUIDE.md) for trust level definitions.

---

## Test-Paired Development

> **This is the single most important quality practice in AI-DLC.**

Every code change must include corresponding tests. No code merges without tests. No "I'll add tests later." The tests ship with the code, in the same bolt, in the same PR.

### Why This Matters for AI-Assisted Development

AI generates large volumes of code quickly. Without test-paired discipline, a developer can ship 500 lines of untested code in an hour. Test-paired development forces **clarity of intent** (what should the code do?), **boundary definition** (what is the contract?), **regression safety** (can future changes break this?), and **AI accountability** (prove it works, don't just claim it).

### The Test-Paired Rule

Add a function -- add a test. Fix a bug -- add a regression test first. Refactor -- verify existing tests pass. Delete code -- delete or update tests. No exceptions.

### Test-Paired Checklist (Per Bolt)

- [ ] New functions have unit tests covering happy path and at least one error path
- [ ] Bug fixes include a regression test that fails before the fix
- [ ] API endpoint changes have integration tests validating request/response contract
- [ ] Configuration changes have tests verifying behavior under new configuration
- [ ] Test names describe the scenario and expected outcome
- [ ] No test uses `# pragma: no cover` or `/* istanbul ignore */` without documented justification

### What "Corresponding Tests" Means

| Code Change | Required Test |
|---|---|
| New function/method | Unit test: happy path + error path + edge cases |
| New API endpoint | Integration test: request/response, auth, validation, error responses |
| Bug fix | Regression test that fails before fix, passes after |
| Configuration change | Test verifying behavior under new config |
| Database migration | Test verifying data integrity after migration |
| UI component | Render test + interaction test for critical paths |
| Infrastructure change | Validation test (connectivity, permissions, configuration) |

---

## Phase-by-Phase Quality Activities

### Phase 0: Foundation

- [ ] Set up pre-commit hooks (formatting, linting, type checking)
- [ ] Configure CI pipeline with quality gates
- [ ] Establish test directory structure and conventions
- [ ] Set coverage thresholds in CI configuration
- [ ] Document testing strategy in project context file (CLAUDE.md)
- [ ] Choose test frameworks and add to project dependencies

### Phase 1: Inception

- [ ] Define quality requirements alongside functional requirements
- [ ] Identify critical paths that require 100% test coverage
- [ ] Establish integration test environment strategy (containers, cloud sandboxes)
- [ ] Document testability requirements in architecture decisions
- [ ] Plan contract testing approach for external dependencies

### Phase 2: Elaboration

- [ ] Add acceptance criteria to every user story (testable, specific)
- [ ] Write test scenarios for complex business logic before implementation
- [ ] Validate that API specifications are testable (clear inputs/outputs)
- [ ] Identify E2E test scenarios for critical user paths
- [ ] Establish test data management strategy

### Phase 3: Construction

- [ ] Follow test-paired development on every bolt — no exceptions
- [ ] Run full quality gate suite on every PR
- [ ] Maintain coverage above thresholds
- [ ] Write integration tests for each external service integration
- [ ] Log quality metrics per bolt (tests added, coverage delta, findings)
- [ ] Address lint and type-check violations immediately — do not accumulate debt

### Phase 4: Hardening

- [ ] Run full test suite and fix all failures
- [ ] Achieve coverage targets across all critical paths
- [ ] Validate mock fidelity against real data (contract test refresh)
- [ ] Execute E2E tests against staging environment
- [ ] Run performance tests and establish baselines
- [ ] Complete ops readiness quality section
- [ ] Resolve all Critical and High quality findings

### Phase 5: Operations

- [ ] Monitor test execution in CI — investigate flaky tests immediately
- [ ] Run E2E tests against production on schedule (synthetic monitoring)
- [ ] Track quality metrics (coverage trends, test pass rate, mean time to fix)
- [ ] Update tests when production incidents reveal gaps
- [ ] Maintain integration test environments

### Phase 6: Evolution

- [ ] Review quality metrics from the cycle — identify trends
- [ ] Identify test patterns that caught (or missed) production issues
- [ ] Update testing strategy based on production experience
- [ ] Extract reusable test utilities and patterns
- [ ] Assess whether quality tooling needs improvement
- [ ] Plan quality improvements for the next cycle

---

## Templates and Cross-References

### Related Templates

- [OPS-READINESS-CHECKLIST.md](../../templates/OPS-READINESS-CHECKLIST.md) — Production readiness checklist with quality section

### Related Phases

- [Phase 0: Foundation](../framework/PHASE-0-FOUNDATION.md) — Quality tooling and CI setup
- [Phase 1: Inception](../framework/PHASE-1-INCEPTION.md) — Quality requirements and test strategy
- [Phase 2: Elaboration](../framework/PHASE-2-ELABORATION.md) — Acceptance criteria and test scenarios
- [Phase 3: Construction](../framework/PHASE-3-CONSTRUCTION.md) — Test-paired development (primary phase)
- [Phase 4: Hardening](../framework/PHASE-4-HARDENING.md) — Full test validation and coverage targets
- [Phase 5: Operations](../framework/PHASE-5-OPERATIONS.md) — Synthetic monitoring and quality tracking
- [Phase 6: Evolution](../framework/PHASE-6-EVOLUTION.md) — Quality retrospective and improvement

### Related Pillars

- [Security](PILLAR-SECURITY.md) — Testing validates security controls; five-persona review is a quality activity
- [Traceability](PILLAR-TRACEABILITY.md) — Tests are traced to requirements via traceability matrix
- [Cost Awareness](PILLAR-COST.md) — Test infrastructure has cost implications; optimize CI pipeline costs

### Related Reference Documents

- [Bolt Metrics Guide](../reference/BOLT-METRICS-GUIDE.md) — Quality metrics per bolt
- [Audit Scoring](../reference/AUDIT-SCORING.md) — Assessment methodology including quality dimension
- [Autonomous Execution Guide](../reference/AUTONOMOUS-EXECUTION-GUIDE.md) — Oracle verification, trust-adaptive review
