# Traceability Matrix

<!-- AI-DLC Phase: Initialized in Phase 2: Elaboration, maintained through Phase 6: Deployment -->

> Copy this template into your project and fill in all sections.
> This matrix tracks every requirement from inception through deployment.
> Items marked with <!-- TODO: ... --> need your input.

---

## Purpose

This document provides end-to-end traceability from requirements through deployment. Every requirement should be traceable forward to code and tests, and every test should be traceable backward to a requirement. Gaps in this matrix indicate coverage risks.

**Project Name:** *<!-- TODO: Your project name -->*
**Last Updated:** *<!-- TODO: YYYY-MM-DD -->*
**Owner:** *<!-- TODO: Name or team responsible for maintaining this matrix -->*

---

## Traceability Matrix

<!-- TODO: Replace example rows with your actual traceability data -->
<!-- Status values: Not Started / In Progress / Implemented / Tested / Deployed / Deferred -->

| REQ ID | User Story ID | Spec Section | Code Module | Test ID(s) | Deploy Version | Status |
|--------|---------------|--------------|-------------|------------|----------------|--------|
| REQ-001 | *US-101, US-102* | *3.1 Authentication* | *src/auth/register.ts* | *TEST-001, TEST-002, TEST-003* | *v1.0.0* | *Tested* |
| REQ-002 | *US-201* | *4.1 Dashboard* | *src/dashboard/subscriptions.ts* | *TEST-010, TEST-011* | *v1.0.0* | *In Progress* |
| REQ-003 | *US-301* | *4.3 Export* | *src/export/csv-builder.ts* | *TEST-020* | *--* | *Not Started* |
| REQ-004 | *US-401, US-402* | *5.2 Admin Tools* | *src/admin/impersonate.ts* | *TEST-030, TEST-031, TEST-032* | *--* | *Not Started* |
| <!-- TODO: REQ-005 --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | Not Started |
| <!-- TODO: REQ-006 --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | Not Started |

---

## Non-Functional Requirements Traceability

<!-- TODO: Track NFRs separately since they often span multiple modules -->

| NFR ID | Category | Verification Method | Test ID(s) | Evidence Location | Status |
|--------|----------|---------------------|------------|-------------------|--------|
| NFR-PERF-001 | *Performance* | *Load test* | *PERF-TEST-001* | *reports/load-test-results/* | *Not Started* |
| NFR-SEC-001 | *Security* | *Security review + penetration test* | *SEC-TEST-001* | *reports/security-review/* | *Not Started* |
| NFR-AVL-001 | *Availability* | *Chaos test + monitoring* | *AVL-TEST-001* | *reports/availability/* | *Not Started* |
| <!-- TODO: Add your NFR traceability rows --> | | | | | |

---

## Coverage Summary

<!-- TODO: Update these counts as the project progresses -->

| Metric | Count | Notes |
|--------|-------|-------|
| Total Requirements | *<!-- TODO: e.g., 12 -->* | *Functional + Non-functional* |
| Requirements with User Stories | *<!-- TODO: e.g., 10 -->* | *Target: 100% of functional requirements* |
| Requirements with Tests | *<!-- TODO: e.g., 6 -->* | *Target: 100% of Must/Should requirements* |
| Requirements Deployed | *<!-- TODO: e.g., 0 -->* | *Tracks release progress* |
| Orphan Tests (no linked REQ) | *<!-- TODO: e.g., 2 -->* | *Target: 0 -- every test should trace to a requirement* |
| Untested Requirements | *<!-- TODO: e.g., 6 -->* | *Target: 0 for Must/Should before release* |

---

## How to Maintain This Matrix

### When to Update

| Event | Action |
|-------|--------|
| New requirement added | Add row with REQ ID; fill User Story when written |
| User story written | Link User Story ID to REQ ID |
| Specification updated | Update Spec Section column |
| Code module created/changed | Update Code Module column |
| Test written | Add Test ID to relevant row |
| Feature deployed | Update Deploy Version and set Status to Deployed |
| Requirement deferred | Set Status to Deferred; note reason in commit message |

### Column Definitions

| Column | Description | Format |
|--------|-------------|--------|
| **REQ ID** | Unique requirement identifier | REQ-NNN (from REQUIREMENTS.md) |
| **User Story ID** | Linked user story or stories | US-NNN (from USER-STORIES.md) |
| **Spec Section** | Section in the design/spec document | Numeric section reference |
| **Code Module** | Primary source file or module | Relative file path |
| **Test ID(s)** | All test cases verifying this requirement | TEST-NNN, comma-separated |
| **Deploy Version** | Version where this was first deployed | Semantic version (vX.Y.Z) |
| **Status** | Current state of the requirement | See status values above |

### Review Cadence

<!-- TODO: Adjust cadence to match your sprint/bolt structure -->

- **Every bolt/sprint:** Review matrix for newly implemented items. Update Code Module and Test ID columns.
- **Before each release:** Verify all Must requirements show Status = Tested or Deployed. Verify no orphan tests exist.
- **Phase 5 (Validation):** Full matrix review. Every Must/Should requirement must have Test IDs and passing results.
- **Phase 6 (Deployment):** Update Deploy Version for all released requirements.

---

## Gap Analysis

<!-- TODO: Periodically review and document gaps -->

### Current Gaps

| Gap Type | Details | Remediation Plan | Target Date |
|----------|---------|------------------|-------------|
| *Untested requirement* | *REQ-003 has no test coverage* | *Write CSV export integration test* | *<!-- TODO: Date -->* |
| *Missing spec section* | *REQ-004 needs admin spec review* | *Schedule spec review with security team* | *<!-- TODO: Date -->* |
| <!-- TODO: Document your gaps --> | | | |

### Resolved Gaps

| Gap Type | Details | Resolution | Resolved Date |
|----------|---------|------------|---------------|
| *Example: Missing user story* | *REQ-001 had no user story* | *Created US-101 and US-102* | *<!-- TODO: Date -->* |

---

## Automation Tips

<!-- Suggestions for keeping the matrix accurate with less manual effort -->

### Naming Conventions That Enable Traceability

Adopt consistent naming so that matrix entries can be validated by searching the codebase:

| Element | Convention | Example |
|---------|-----------|---------|
| Requirement IDs in code comments | `// REQ-NNN` or `# REQ-NNN` | `// REQ-001: Email validation` |
| Test names reference Test IDs | `test("TEST-001: valid email creates account")` | Searchable from matrix |
| Commit messages reference story IDs | `feat(auth): implement US-101 registration` | Links commits to stories |
| Branch names include story IDs | `feature/US-201-dashboard` | Links branches to stories |

### Quick Validation

Run these checks periodically to verify matrix accuracy:

1. **Forward traceability:** For each REQ ID, confirm that a Test ID exists and the test passes.
2. **Backward traceability:** For each Test ID, confirm it maps to a REQ ID. Tests without a linked requirement are orphans.
3. **Code coverage:** For each Code Module listed, confirm the file still exists at that path.
4. **Deployment verification:** For each Deployed status, confirm the Deploy Version is actually released.

---

## Cross-References

- **Requirements:** See [REQUIREMENTS.md](./REQUIREMENTS.md)
- **User Stories:** See [USER-STORIES.md](./USER-STORIES.md)
- **Security Requirements:** See [SECURITY.md](./SECURITY.md)
- **PM Framework:** See [PM-FRAMEWORK.md](./PM-FRAMEWORK.md) for sprint/bolt tracking that drives status updates.

---

## Revision History

| Date | Version | Author | Changes |
|------|---------|--------|---------|
| *<!-- TODO: Date -->* | *0.1* | *<!-- TODO: Author -->* | *Initial matrix created with Phase 1 requirements* |
