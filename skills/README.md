# AI-DLC Skills Ecosystem

Custom Claude Code commands and skills that implement the AI-DLC methodology. These are prompt-based tools that Claude Code executes as slash commands.

## Installation

Copy to your Claude Code configuration directory:

```bash
# Commands (slash commands)
cp skills/commands/*.md ~/.claude/commands/

# Skills (full agent-based skills)
for skill in skills/skills/*/; do
  name=$(basename "$skill")
  mkdir -p ~/.claude/skills/$name
  cp -r "$skill"* ~/.claude/skills/$name/
done
```

Or use the bootstrap script:

```bash
bash scripts/install-skills.sh
```

## Architecture

```
skills/
├── commands/          # 16 slash commands (lightweight, single-phase)
│   ├── bolt-lfg.md        # Autonomous bolt pipeline
│   ├── brainstorm.md      # Explore before you plan
│   ├── setup.md           # Per-project configuration
│   ├── pm.md              # Bolt sprint management
│   ├── captainslog.md     # Session decision records
│   ├── five-persona-review.md  # Adversarial code review
│   └── ...
└── skills/            # 12 full skills (multi-phase, rich personas)
    ├── dlc-audit/         # 9-dimension compliance audit
    ├── staff-panel/       # Staff engineer panel analysis
    ├── exec-review/       # Executive review panel
    ├── motherhen/         # Project health monitor
    └── ...
```

## Workflow

The AI-DLC bolt lifecycle, now with an autonomous pipeline:

```
/brainstorm → /pm plan → work → /five-persona-review → /captainslog → /pm close
     │              │                    │                      │
     └── docs/brainstorms/  ←──── auto-discovered ────→  docs/solutions/
                                  (knowledge loop)
```

Or run the full autonomous pipeline:

```bash
/bolt-lfg "feature description"
```

## Commands Reference

| Command | Purpose | Lines |
|---------|---------|-------|
| `/bolt-lfg` | Autonomous bolt pipeline with gate enforcement | 252 |
| `/brainstorm` | WHAT-before-HOW exploration with document handoff | 165 |
| `/setup` | Per-project `.ai-dlc.local.yaml` configuration | 185 |
| `/pm` | Bolt sprint management (plan/close/status/backlog) | 288 |
| `/captainslog` | Session decision records with auto-invoke triggers | 253 |
| `/five-persona-review` | 5-persona adversarial code review with worktree isolation | 208 |
| `/arch-audit` | Multi-persona architectural audit with C4 diagrams | ~330 |
| `/bolt-review` | End-of-sprint comprehensive review | ~110 |
| `/budget` | Infrastructure cost tracking | ~150 |
| `/changelog` | Auto-generate CHANGELOG.md from git history | ~100 |
| `/cost-estimate` | Development effort estimation | ~100 |
| `/exec-review` | Executive review panel (stub → skill) | ~22 |
| `/init-project` | Full AI-DLC project scaffold | ~675 |
| `/readme` | Auto-generated README.md | ~20 |
| `/security-audit` | 9-category OWASP security audit | ~180 |
| `/staff-panel` | Staff engineer panel (stub → skill) | ~22 |

## Skills Reference

| Skill | Purpose | Lines |
|-------|---------|-------|
| `/dlc-audit` | 9-dimension AI-DLC compliance scoring (0-10, A-F) | 716 |
| `/staff-panel` | 4 staff engineers + Will Larson moderator | 313 |
| `/exec-review` | 5 executives + Jim Collins, Good-to-Great frameworks | ~440 |
| `/motherhen` | Adaptive project health monitor (7 checks) | 459 |
| `/llm-team` | AI search visibility panel (5 GEO/AIO experts) | ~420 |
| `/marketing-team` | B2B SaaS marketing panel (5 experts) | ~335 |
| `/docs` | Documentation generator (README, CHANGELOG, SECURITY) | ~235 |
| `/pm` | Full PM framework implementation | ~105 |
| `/ticky` | Azure DevOps ticket lifecycle management | 398 |
| `/webteam` | Astro website team sync & deployment | 576 |
| `/webby` | Plain-English website team guide | ~425 |
| `/prodstatus` | Production health dashboard (AWS) | 277 |

## Key Patterns

### Gate-Enforced Pipelines
Each step in `/bolt-lfg` has a GATE that must pass before proceeding. Prevents "code first, think later."

### Brainstorm → Plan Document Handoff
`/brainstorm` writes to `docs/brainstorms/`. `/pm plan` auto-discovers these docs and carries forward decisions with explicit references. Structural handoff, not just conceptual.

### Knowledge Capture → Retrieval Loop
- **Capture:** `/captainslog` records decisions, `/bolt-lfg` Step 7 creates solution docs
- **Retrieval:** `/pm plan` and `/bolt-lfg` search `docs/solutions/` and `docs/captains_log/` before implementation
- **Result:** Each solved problem compounds — the second occurrence takes minutes, not hours

### Panel-Based Architecture
Skills like `/staff-panel`, `/exec-review`, `/llm-team`, and `/marketing-team` use independent expert personas that analyze separately, then synthesize consensus through adversarial debate.

### Per-Project Configuration
`/setup` creates `.ai-dlc.local.yaml` with project-specific settings (review focus areas, test commands, health thresholds). Skills read this file to adapt behavior per project.

### Portable Paths
All skills use environment variables with defaults (`${TICKY_HOME:-$HOME/repos/ticky}`) instead of hardcoded paths. Override via `.ai-dlc.local.yaml` or environment.

## Compound Engineering Credits

Several patterns in this ecosystem were adopted from [EveryInc/compound-engineering-plugin](https://github.com/EveryInc/compound-engineering-plugin):

- Gate-enforced autonomous pipelines (`/lfg` pattern)
- Brainstorm → plan document handoff
- Knowledge compounding through solution docs
- Per-project configuration via local config file
- Worktree isolation for code reviews

Our additions on top: methodology governance (7 phases, trust-adaptive gates, risk tiers), compliance scoring (dlc-audit, EU AI Act mapping), adversarial panel debate, cost management, and process monitoring (motherhen).
