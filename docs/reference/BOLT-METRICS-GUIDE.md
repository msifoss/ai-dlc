# Bolt Metrics Guide — Measuring Velocity and Quality

Bolts are the atomic unit of work in AI-DLC. Measuring bolt performance tells you whether your AI-assisted delivery is accelerating, stalling, or drifting. This guide defines the metrics, how to calculate them, how to display them, and what the numbers mean.

---

## Per-Bolt Metrics

Track these metrics for every bolt. Capture them in the captain's log or a dedicated metrics file at bolt completion.

| Metric | Definition | How to Measure |
|--------|-----------|----------------|
| **Commits** | Number of atomic commits in this bolt | `git log --oneline` for the bolt's branch/range |
| **Lines Changed** | Net lines added + removed | `git diff --stat` between bolt start and end |
| **Tests Added** | New test functions or test cases introduced | Count new `test_*` or `it(...)` functions in diff |
| **Tests Modified** | Existing tests updated to reflect changes | Count modified test functions in diff |
| **Test Delta** | Net new tests (added minus deleted) | Tests Added - Tests Deleted |
| **Deploys** | Number of deployments triggered by this bolt | CI/CD pipeline logs |
| **Blocked Time %** | Percentage of bolt duration spent waiting (reviews, dependencies, external APIs) | (Blocked minutes / Total bolt minutes) x 100 |
| **Time Spent** | Wall-clock hours from bolt start to bolt close | Timestamp difference (plan to retro) |
| **T-shirt Size** | Pre-bolt estimate: S, M, L, XL | Assigned during bolt planning |
| **Actual Size** | Post-bolt actual effort category | Assigned during bolt retro |

### Calculating Lines Changed

Use the diff between the commit before the bolt started and the final bolt commit:

```bash
# Lines added and removed for a bolt
git diff --stat <bolt-start-commit>..<bolt-end-commit>

# Net lines changed (additions + deletions)
git diff --numstat <bolt-start-commit>..<bolt-end-commit> | \
  awk '{added+=$1; removed+=$2} END {print "+" added " -" removed " net:" added-removed}'
```

### Calculating Test Delta

```bash
# Count test functions in the diff (Python example)
git diff <start>..<end> --name-only | grep test | \
  xargs git diff <start>..<end> -- | grep "^+.*def test_" | wc -l
```

Adjust the grep pattern for your language: `it(` for JavaScript/TypeScript, `func Test` for Go, `@Test` for Java.

---

## Sprint/Phase-Level Metrics

Aggregate per-bolt metrics into sprint or phase summaries. Calculate these at every sprint boundary and every phase transition.

| Metric | Formula | Target |
|--------|---------|--------|
| **Velocity (bolts/week)** | Completed bolts / Weeks elapsed | Stable or increasing |
| **Test Coverage Trend** | Coverage % at sprint end vs. sprint start | Stable or increasing; never declining >2% |
| **Security Findings Trend** | New findings this sprint / New findings last sprint | Ratio < 1.0 (decreasing) |
| **Deployment Frequency** | Deploys per week | Increasing or stable |
| **Bolt Success Rate** | Bolts completed without rework / Total bolts | > 85% |
| **Estimation Accuracy** | Bolts where actual size = estimated size / Total bolts | > 70% |
| **Blocked Time (avg)** | Sum of all bolt blocked time % / Bolt count | < 15% |
| **Test-to-Code Ratio** | Total tests / Total source files | > 2:1 for mature projects |

### Velocity Calculation Example

```
Sprint 3: Feb 10-21 (2 weeks)
Bolts completed: 8
Velocity: 8 / 2 = 4 bolts/week
```

Compare against previous sprints to detect trends. A declining velocity with constant team size signals process friction, unclear specs, or growing technical debt.

### Test Coverage Trend

Record coverage at sprint boundaries:

| Sprint | Line Coverage | Branch Coverage | Test Count | Delta |
|--------|-------------|----------------|------------|-------|
| Sprint 1 | 62% | 48% | 47 | — |
| Sprint 2 | 78% | 63% | 112 | +65 |
| Sprint 3 | 84% | 71% | 168 | +56 |
| Sprint 4 | 87% | 74% | 216 | +48 |

A coverage plateau is normal as the codebase grows. A coverage decline requires investigation.

---

## Dashboard Template

Use this table format in your sprint log, captain's log summary, or project dashboard.

### Bolt-Level Dashboard

| Bolt | Date | Size (Est) | Size (Act) | Commits | Lines | Tests +/- | Time | Blocked % |
|------|------|-----------|-----------|---------|-------|----------|------|-----------|
| B-001 | 02-10 | M | M | 4 | +180/-20 | +8/0 | 2.5h | 0% |
| B-002 | 02-10 | S | S | 2 | +45/-10 | +3/0 | 1.0h | 0% |
| B-003 | 02-11 | L | L | 7 | +320/-85 | +12/-2 | 4.0h | 10% |
| B-004 | 02-11 | M | L | 5 | +210/-30 | +6/0 | 3.5h | 20% |
| B-005 | 02-12 | S | S | 3 | +60/-15 | +4/0 | 1.5h | 0% |

### Sprint Summary Dashboard

| Metric | Sprint 1 | Sprint 2 | Sprint 3 | Trend |
|--------|----------|----------|----------|-------|
| Bolts completed | 6 | 8 | 9 | Up |
| Velocity (bolts/week) | 3.0 | 4.0 | 4.5 | Up |
| Tests added | 47 | 65 | 56 | Stable |
| Test coverage (line) | 62% | 78% | 84% | Up |
| Security findings (new) | — | 12 | 5 | Down |
| Deploys | 2 | 3 | 4 | Up |
| Avg blocked time | 18% | 12% | 8% | Down |
| Estimation accuracy | 60% | 68% | 76% | Up |

---

## Interpreting Metrics: What Good Looks Like

### Healthy Project Signals

- **Velocity is stable or gradually increasing.** A mature project sustains 3-5 bolts/week for a solo developer + AI.
- **Test delta is positive every sprint.** Net new tests grow with every sprint. Zero or negative test delta is a red flag.
- **Blocked time is below 15%.** The developer spends most time building, not waiting.
- **Estimation accuracy exceeds 70%.** The team predicts bolt sizes well, indicating clear specs and familiar technology.
- **Security findings trend downward.** Each quarterly review finds fewer new issues than the previous one.
- **Deployment frequency is stable or increasing.** Frequent, small deploys indicate confidence and mature CI/CD.

### Warning Signs

| Signal | What It Means | Action |
|--------|--------------|--------|
| Velocity drops 2+ sprints in a row | Increasing complexity, unclear specs, or tech debt | Review specs for clarity; dedicate a bolt to tech debt |
| Test delta is negative | Tests are being deleted without replacement | Investigate why; restore coverage or document the rationale |
| Blocked time exceeds 25% | External dependencies or review bottlenecks | Identify the blocker; escalate or restructure the workflow |
| Estimation accuracy below 50% | Specs are ambiguous or scope creep is occurring | Run additional Five Questions cycles; tighten scope |
| Security findings increasing | New code introduces vulnerabilities faster than remediation | Add five-persona review to every bolt, not just hardening |
| Zero deploys in a sprint | Pipeline issues or fear of deployment | Investigate CI/CD health; deploy smaller increments |

---

## T-Shirt Sizing Calibration

Use consistent sizing to make velocity meaningful across sprints and projects.

| Size | Time Range | Characteristics | Example |
|------|-----------|-----------------|---------|
| **S** | 1-2 hours | Single file or small change, clear requirements, no new dependencies | Add a validation rule to an existing endpoint |
| **M** | 2-4 hours | Multiple files, moderate complexity, well-understood domain | Build a new API endpoint with tests |
| **L** | 4-8 hours | Multiple components, cross-cutting concerns, some unknowns | Implement authentication flow end-to-end |
| **XL** | 8+ hours | **Split it.** XL bolts indicate unclear scope or multiple concerns bundled together | Break into 2-4 smaller bolts with clear boundaries |

### Calibration Rules

1. **Never accept XL.** An XL bolt means the scope is not well enough understood. Return to elaboration, run Five Questions, and split into smaller bolts.
2. **Track accuracy per size.** If M bolts consistently take 5+ hours, your M calibration is off. Adjust the definitions.
3. **Re-calibrate quarterly.** As the team becomes more proficient with the codebase and AI tooling, sizes naturally compress. A task that was L in Sprint 1 may be M by Sprint 6.
4. **Use actuals to predict.** When planning a new bolt, reference completed bolts of similar scope and complexity.

---

## Real-World Example: CallHero Delivery

The following metrics come from a real AI-DLC delivery: 25 bolts over 9 days, resulting in a production deployment.

### Project Summary

| Metric | Value |
|--------|-------|
| Total bolts | 25 |
| Construction bolts | 21 |
| Hardening bolts | 4 (H1-H4) |
| Total tests | 216 |
| Test coverage (line) | 87% |
| Security findings (total) | 217 |
| Critical findings | 12 (all resolved) |
| High findings | 38 (all resolved) |
| Calendar days | 9 |
| Average velocity | 2.8 bolts/day |

### Bolt Distribution by Size

| Size | Count | % of Total | Avg Time |
|------|-------|-----------|----------|
| S | 8 | 32% | 1.2h |
| M | 11 | 44% | 2.8h |
| L | 6 | 24% | 5.5h |
| XL | 0 | 0% | — |

### Phase-Level Breakdown

| Phase | Bolts | Tests Added | Security Findings | Days |
|-------|-------|-------------|-------------------|------|
| Phase 3 (Construction) | 21 | 196 | 0 (reviewed in Phase 4) | 6 |
| Phase 4 (Hardening) | 4 | 20 | 217 found, 50 fixed (Critical+High) | 3 |

### Key Observations

- **Zero XL bolts.** Every large scope item was split during planning. This discipline kept velocity predictable.
- **44% M bolts.** The sweet spot for AI-assisted development. M bolts are complex enough to benefit from AI but small enough to complete in a single session.
- **216 tests in 25 bolts.** Average of 8.6 tests per bolt. Test-paired development produced high coverage without a separate testing phase.
- **217 security findings in one review.** The five-persona review is thorough. Without it, these findings would have surfaced in production.

---

## Anti-Patterns

Avoid these measurement pitfalls.

| Anti-Pattern | Why It Fails | Instead |
|-------------|-------------|---------|
| **Gaming metrics** | Writing trivial tests to inflate test count; splitting bolts to inflate velocity | Measure outcomes (coverage %, defect rate) not vanity counts |
| **Vanity metrics** | "Lines of code written" tells you nothing about value | Track lines changed (net), not lines added |
| **Measuring input, not output** | Hours worked measures effort, not delivery | Track bolts completed and tests passing, not hours logged |
| **Ignoring blocked time** | Pretending all time is productive hides systemic issues | Track and report blocked time honestly; it drives process improvement |
| **Cherry-picking sprints** | Comparing your best sprint to every sprint | Use trailing 4-sprint averages for trend analysis |
| **Metric obsession** | Spending more time measuring than building | Keep measurement lightweight: 5 minutes per bolt, 15 minutes per sprint |
| **No baseline** | Metrics without history have no meaning | Establish baselines in Sprint 1 and track trends from there |
| **Comparing across teams** | Different projects have different complexity profiles | Compare a team against its own history, never against other teams |

---

## Setting Up Metrics Collection

### Lightweight Approach (Solo + AI)

Add a metrics section to your captain's log:

```markdown
## Bolt Metrics — bolt-014

| Metric | Value |
|--------|-------|
| Estimated size | M |
| Actual size | M |
| Commits | 5 |
| Lines changed | +180/-25 |
| Tests added | 7 |
| Tests modified | 2 |
| Test delta | +7 |
| Time spent | 2.5h |
| Blocked time | 10% (waiting for API key provisioning) |
```

### Automated Approach (Small Team / Enterprise)

Extract metrics from git and CI/CD automatically:

```bash
# Generate bolt metrics from git
BOLT_START="abc1234"
BOLT_END="def5678"

echo "Commits: $(git rev-list --count $BOLT_START..$BOLT_END)"
echo "Files changed: $(git diff --name-only $BOLT_START..$BOLT_END | wc -l)"
echo "Lines: $(git diff --stat $BOLT_START..$BOLT_END | tail -1)"
echo "Test files changed: $(git diff --name-only $BOLT_START..$BOLT_END | grep -c test)"
```

Feed these into a spreadsheet, dashboard, or metrics service. The key is consistency — collect the same metrics for every bolt, every sprint.

---

## Cross-References

- [Phase 3: Construction](../framework/PHASE-3-CONSTRUCTION.md) — Where bolts execute
- [Phase 6: Evolution](../framework/PHASE-6-EVOLUTION.md) — Where metrics drive improvement
- [Traceability Pillar](../pillars/PILLAR-TRACEABILITY.md) — Captain's logs as bolt records
- [Quality Pillar](../pillars/PILLAR-QUALITY.md) — Test coverage and code quality metrics
- [Audit Scoring](AUDIT-SCORING.md) — Metrics feed the 8-dimension assessment
- [Glossary](GLOSSARY.md) — Definitions of bolt, captain's log, T-shirt sizing
