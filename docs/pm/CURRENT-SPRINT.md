# Current Sprint

## Bolt: Swarms-Inspired Enhancements

**Status:** ACTIVE
**Started:** 2026-03-23
**Goal:** Add 4 Swarms-inspired features to AI-DLC: Skill Router, Voting Protocol, DAG Smart Handoff, Auto Team Composer

### Brainstorm Reference
- `docs/brainstorms/2026-03-23-swarms-enhancements-brainstorm.md`
- `docs/key_findings/20260323-1430-Swarms-Enhancements-Staff-Engineer-Panel.md`

### Items

| # | Item | Files | Effort | Status |
|---|------|-------|--------|--------|
| 1 | Create `/route` command | `skills/commands/route.md` (new) | 30 min | TODO |
| 2 | Add Voting Protocol to staff-panel | `~/.claude/skills/staff-panel/SKILL.md`, `skills/commands/staff-panel.md` | 45 min | TODO |
| 3 | Add Voting Protocol to exec-review | `~/.claude/skills/exec-review/SKILL.md`, `skills/commands/exec-review.md` | 30 min | TODO |
| 4 | Add smart handoff to `/bolt-lfg` | `skills/commands/bolt-lfg.md` | 20 min | TODO |
| 5 | Enhance `/slfg` dependency detection | `skills/commands/slfg.md` | 30 min | TODO |
| 6 | Create `/compose` command | `skills/commands/compose.md` (new) | 45 min | TODO |
| 7 | Update skills/README.md | `skills/README.md` | 15 min | TODO |

### Success Criteria
- [ ] `/route` correctly suggests right command for diverse intents
- [ ] Voting Protocol produces greppable Decision Record in both panels
- [ ] `/bolt-lfg` detects parallel work and offers handoff to `/slfg`
- [ ] `/slfg` has improved dependency detection heuristics
- [ ] `/compose` outputs sensible pipeline for task descriptions
- [ ] `skills/README.md` updated with new commands and Decision Record convention
- [ ] Staff panel reviewed and endorsed designs

### Research Summary
Staff panel (Tim/SpaceX, Rob/Roblox, Fran/Meta, Al/AWS) reviewed all 4 features. Key amendments:
- **NO DAG engine** — smart handoff from bolt-lfg to slfg instead
- **Voting enhances existing consensus matrix** — adds confidence (1-5), tally row, Decision Record format
- **Decision Record format**: `DECISION: X | VOTE: N-M | CONFIDENCE: avg | DISSENT: panelist: concern`
- **Skill Router reads skills/README.md** as source of truth, not embeddings
- **Auto Team Builder = `/compose`** — standalone + embeddable in `/dlc-loop`
