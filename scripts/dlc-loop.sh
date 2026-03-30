#!/usr/bin/env bash
# dlc-loop.sh — Autonomous DLC Loop Controller
#
# Runs the AI-DLC lifecycle (Phase 0–6) in a loop, invoking Claude Code
# for each phase. Claude is the executor; this script is the orchestrator.
#
# Usage:
#   bash scripts/dlc-loop.sh [options]
#
# Options:
#   --mission <file>    Path to mission brief (default: MISSION-BRIEF.md)
#   --start-phase <N>   Start at phase N (default: auto-detect from state)
#   --end-phase <N>     Stop after phase N (default: 6)
#   --dry-run           Show what would execute without running
#   --skip-permissions  Use --dangerously-skip-permissions (ONLY in containers)
#   --verbose           Show Claude's full output
#   --max-retries <N>   Max retries per phase (default: 3)
#
# Prerequisites:
#   - Claude Code CLI installed and authenticated
#   - .claude/settings.local.json configured with comprehensive allowlist
#   - MISSION-BRIEF.md filled out in project root
#
# State Management:
#   State is tracked in .dlc-state/ directory:
#   - current.json      — current phase and session tracking
#   - phase-N-complete.json — evidence checkpoint per completed phase
#   - progress.log      — human-readable progress log
#   - error.json        — last error (if halted)

set -euo pipefail

# ─── Configuration ───────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
STATE_DIR="$PROJECT_DIR/.dlc-state"
MISSION_BRIEF="$PROJECT_DIR/MISSION-BRIEF.md"
START_PHASE=""
END_PHASE=6
DRY_RUN=false
SKIP_PERMISSIONS=false
VERBOSE=false
MAX_RETRIES=3
SESSION_ID=""

# Phase names for display
declare -A PHASE_NAMES=(
  [0]="Foundation"
  [1]="Inception"
  [2]="Elaboration"
  [3]="Construction"
  [4]="Hardening"
  [5]="Operations"
  [6]="Evolution"
)

# ─── Argument Parsing ────────────────────────────────────────────────────────

while [[ $# -gt 0 ]]; do
  case $1 in
    --mission)     MISSION_BRIEF="$2"; shift 2 ;;
    --start-phase) START_PHASE="$2"; shift 2 ;;
    --end-phase)   END_PHASE="$2"; shift 2 ;;
    --dry-run)     DRY_RUN=true; shift ;;
    --skip-permissions) SKIP_PERMISSIONS=true; shift ;;
    --verbose)     VERBOSE=true; shift ;;
    --max-retries) MAX_RETRIES="$2"; shift 2 ;;
    -h|--help)     head -30 "$0" | tail -28; exit 0 ;;
    *)             echo "Unknown option: $1"; exit 1 ;;
  esac
done

# ─── Helpers ─────────────────────────────────────────────────────────────────

log() {
  local timestamp
  timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
  echo "[$timestamp] $*"
  echo "[$timestamp] $*" >> "$STATE_DIR/progress.log" 2>/dev/null || true
}

write_state() {
  local phase="$1" status="$2"
  cat > "$STATE_DIR/current.json" <<EOF
{
  "phase": $phase,
  "phase_name": "${PHASE_NAMES[$phase]}",
  "status": "$status",
  "session_id": "$SESSION_ID",
  "updated_at": "$(date -u '+%Y-%m-%dT%H:%M:%SZ')",
  "start_phase": ${START_PHASE:-0},
  "end_phase": $END_PHASE,
  "mission_brief": "$MISSION_BRIEF",
  "retries": 0
}
EOF
}

write_error() {
  local phase="$1" message="$2"
  cat > "$STATE_DIR/error.json" <<EOF
{
  "phase": $phase,
  "phase_name": "${PHASE_NAMES[$phase]}",
  "error": "$message",
  "timestamp": "$(date -u '+%Y-%m-%dT%H:%M:%SZ')",
  "session_id": "$SESSION_ID",
  "recovery": "Fix the issue and run: bash scripts/dlc-loop.sh --start-phase $phase"
}
EOF
}

read_current_phase() {
  if [[ -f "$STATE_DIR/current.json" ]]; then
    jq -r '.phase' "$STATE_DIR/current.json" 2>/dev/null || echo "0"
  else
    echo "0"
  fi
}

validate_checkpoint() {
  local phase="$1"
  local checkpoint="$STATE_DIR/phase-${phase}-complete.json"

  if [[ ! -f "$checkpoint" ]]; then
    log "ERROR: Phase $phase checkpoint not found at $checkpoint"
    return 1
  fi

  local status
  status=$(jq -r '.status' "$checkpoint" 2>/dev/null)
  if [[ "$status" != "complete" ]]; then
    log "ERROR: Phase $phase checkpoint status is '$status', expected 'complete'"
    return 1
  fi

  log "Phase $phase checkpoint validated: $(jq -c '.evidence // {}' "$checkpoint" 2>/dev/null)"
  return 0
}

build_claude_command() {
  local phase="$1"
  local prompt

  prompt="$(cat <<PROMPT
You are executing Phase $phase (${PHASE_NAMES[$phase]}) of an autonomous DLC loop.

READ THESE FILES FIRST:
1. .dlc-state/current.json — your current state
2. $(basename "$MISSION_BRIEF") — the mission brief with all pre-approved decisions
3. docs/framework/PHASE-${phase}-${PHASE_NAMES[$phase]^^}.md — the phase guide

INSTRUCTIONS:
- Execute Phase $phase completely, following the phase guide
- Use the Mission Brief for ALL decisions — do not ask the human
- For verification gates: check against the acceptance criteria in the Mission Brief
- For judgment gates: use the pre-approved decisions in the Mission Brief
- Run /bolt-lfg for construction work (Phase 3), /five-persona-review for hardening (Phase 4)
- When the phase is COMPLETE, write a checkpoint file to .dlc-state/phase-${phase}-complete.json with:
  {
    "phase": $phase,
    "phase_name": "${PHASE_NAMES[$phase]}",
    "status": "complete",
    "timestamp": "$(date -u '+%Y-%m-%dT%H:%M:%SZ')",
    "evidence": {
      "deliverables": ["list of files created or modified"],
      "tests_passed": <number or null>,
      "coverage": <percent or null>,
      "critical_findings": <number or null>,
      "high_findings": <number or null>,
      "notes": "summary of what was accomplished"
    }
  }
- If you encounter a HALT condition from the Mission Brief risk boundaries, write an error to .dlc-state/error.json and STOP.
- Update .dlc-state/current.json phase to $((phase + 1)) when done.
- Do NOT ask the human any questions. All answers are in the Mission Brief.
- Do NOT run git push. Queue it for post-loop human review.
PROMPT
)"

  local cmd="claude -p"

  if [[ -n "$SESSION_ID" ]]; then
    cmd="$cmd --continue $SESSION_ID"
  fi

  if [[ "$SKIP_PERMISSIONS" == "true" ]]; then
    cmd="$cmd --dangerously-skip-permissions"
  fi

  if [[ "$VERBOSE" != "true" ]]; then
    cmd="$cmd --output-format json"
  fi

  echo "$cmd"
  echo "---PROMPT---"
  echo "$prompt"
}

run_phase() {
  local phase="$1"
  local retries=0

  while [[ $retries -lt $MAX_RETRIES ]]; do
    log "Phase $phase (${PHASE_NAMES[$phase]}) — attempt $((retries + 1))/$MAX_RETRIES"
    write_state "$phase" "in_progress"

    local cmd_and_prompt
    cmd_and_prompt="$(build_claude_command "$phase")"
    local cmd prompt
    cmd="$(echo "$cmd_and_prompt" | sed '/^---PROMPT---$/q' | head -n -1)"
    prompt="$(echo "$cmd_and_prompt" | sed -n '/^---PROMPT---$/,$ p' | tail -n +2)"

    if [[ "$DRY_RUN" == "true" ]]; then
      log "[DRY RUN] Would execute: $cmd"
      log "[DRY RUN] Prompt: $(echo "$prompt" | head -5)..."
      # Simulate checkpoint for dry run
      mkdir -p "$STATE_DIR"
      cat > "$STATE_DIR/phase-${phase}-complete.json" <<EOF
{"phase": $phase, "status": "complete", "evidence": {"notes": "dry run"}}
EOF
      write_state "$((phase + 1))" "pending"
      return 0
    fi

    # Execute Claude
    local exit_code=0
    if [[ "$VERBOSE" == "true" ]]; then
      echo "$prompt" | eval "$cmd" || exit_code=$?
    else
      local output
      output="$(echo "$prompt" | eval "$cmd" 2>&1)" || exit_code=$?

      # Extract session ID from JSON output for --continue
      if [[ -n "$output" ]] && echo "$output" | jq -e '.session_id' >/dev/null 2>&1; then
        SESSION_ID="$(echo "$output" | jq -r '.session_id')"
        log "Session ID: $SESSION_ID"
      fi
    fi

    if [[ $exit_code -ne 0 ]]; then
      log "WARNING: Claude exited with code $exit_code"
      retries=$((retries + 1))
      continue
    fi

    # Check for error state
    if [[ -f "$STATE_DIR/error.json" ]]; then
      local error_phase
      error_phase="$(jq -r '.phase' "$STATE_DIR/error.json" 2>/dev/null)"
      if [[ "$error_phase" == "$phase" ]]; then
        log "HALTED: Phase $phase encountered a halt condition"
        log "Error: $(jq -r '.error' "$STATE_DIR/error.json")"
        log "Recovery: $(jq -r '.recovery' "$STATE_DIR/error.json")"
        return 1
      fi
    fi

    # Validate checkpoint
    if validate_checkpoint "$phase"; then
      log "Phase $phase (${PHASE_NAMES[$phase]}) COMPLETE"
      write_state "$((phase + 1))" "pending"
      return 0
    fi

    retries=$((retries + 1))
    log "Phase $phase checkpoint validation failed — retrying ($retries/$MAX_RETRIES)"
  done

  log "FAILED: Phase $phase exhausted $MAX_RETRIES retries"
  write_error "$phase" "Exhausted $MAX_RETRIES retries without producing a valid checkpoint"
  return 1
}

# ─── Preflight Checks ───────────────────────────────────────────────────────

preflight() {
  log "=== DLC Loop Preflight ==="

  # Check Claude CLI
  if ! command -v claude >/dev/null 2>&1; then
    log "ERROR: Claude Code CLI not found. Install from https://claude.com/cli"
    exit 1
  fi
  log "Claude CLI: $(claude --version 2>/dev/null || echo 'found')"

  # Check Mission Brief
  if [[ ! -f "$MISSION_BRIEF" ]]; then
    log "ERROR: Mission Brief not found at $MISSION_BRIEF"
    log "Create one: cp templates/MISSION-BRIEF.md MISSION-BRIEF.md"
    exit 1
  fi

  # Check for TODO markers
  local todo_count
  todo_count=$(grep -c '<!-- TODO' "$MISSION_BRIEF" 2>/dev/null || echo "0")
  if [[ "$todo_count" -gt 0 ]]; then
    log "WARNING: Mission Brief has $todo_count unfilled TODO markers"
    log "The AI will lack guidance for those decisions. Consider filling them in."
    read -rp "Continue anyway? [y/N] " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
      exit 0
    fi
  fi

  # Check allowlist
  local settings="$PROJECT_DIR/.claude/settings.local.json"
  if [[ -f "$settings" ]]; then
    local allow_count
    allow_count=$(jq '.permissions.allow | length' "$settings" 2>/dev/null || echo "0")
    log "Allowlist: $allow_count entries in settings.local.json"
    if [[ "$allow_count" -lt 10 ]]; then
      log "WARNING: Allowlist seems small. The loop may hit permission prompts."
    fi
  else
    log "WARNING: No settings.local.json found. Permission prompts will interrupt the loop."
  fi

  # Initialize state directory
  mkdir -p "$STATE_DIR"

  # Determine start phase
  if [[ -z "$START_PHASE" ]]; then
    if [[ -f "$STATE_DIR/current.json" ]]; then
      START_PHASE=$(read_current_phase)
      local status
      status=$(jq -r '.status' "$STATE_DIR/current.json" 2>/dev/null || echo "unknown")
      log "Resuming from Phase $START_PHASE (status: $status)"
    else
      START_PHASE=0
      log "Fresh start from Phase 0"
    fi
  else
    log "Starting from Phase $START_PHASE (user override)"
  fi

  log "Mission Brief: $MISSION_BRIEF"
  log "Phase range: $START_PHASE → $END_PHASE"
  log "Max retries per phase: $MAX_RETRIES"
  log "Dry run: $DRY_RUN"
  log "==========================="
}

# ─── Main Loop ───────────────────────────────────────────────────────────────

main() {
  preflight

  local start_time
  start_time=$(date +%s)

  log "=== DLC Loop Started ==="

  for phase in $(seq "$START_PHASE" "$END_PHASE"); do
    # Skip already-completed phases
    if [[ -f "$STATE_DIR/phase-${phase}-complete.json" ]]; then
      local status
      status=$(jq -r '.status' "$STATE_DIR/phase-${phase}-complete.json" 2>/dev/null)
      if [[ "$status" == "complete" ]]; then
        log "Phase $phase (${PHASE_NAMES[$phase]}) already complete — skipping"
        continue
      fi
    fi

    if ! run_phase "$phase"; then
      local end_time duration
      end_time=$(date +%s)
      duration=$(( end_time - start_time ))
      log "=== DLC Loop HALTED at Phase $phase after ${duration}s ==="
      log "Review: $STATE_DIR/error.json"
      log "Resume: bash scripts/dlc-loop.sh --start-phase $phase"
      exit 1
    fi
  done

  local end_time duration
  end_time=$(date +%s)
  duration=$(( end_time - start_time ))

  log "=== DLC Loop COMPLETE ==="
  log "Phases $START_PHASE–$END_PHASE completed in ${duration}s"
  log ""
  log "Post-loop checklist:"
  log "  1. Review changes: git log --oneline"
  log "  2. Review state: cat $STATE_DIR/current.json"
  log "  3. Push when ready: git push -u origin \$(git branch --show-current)"
  log "  4. Create PR if needed: gh pr create"

  # Write completion report
  cat > "$STATE_DIR/completion-report.md" <<EOF
# DLC Loop Completion Report

**Date:** $(date '+%Y-%m-%d %H:%M:%S')
**Duration:** ${duration}s
**Phases:** $START_PHASE → $END_PHASE
**Mission Brief:** $(basename "$MISSION_BRIEF")

## Phase Checkpoints

$(for p in $(seq "$START_PHASE" "$END_PHASE"); do
  if [[ -f "$STATE_DIR/phase-${p}-complete.json" ]]; then
    echo "### Phase $p — ${PHASE_NAMES[$p]}"
    echo '```json'
    cat "$STATE_DIR/phase-${p}-complete.json"
    echo '```'
    echo ""
  fi
done)

## Next Steps

- [ ] Review all changes (\`git diff main...HEAD\`)
- [ ] Push to remote (\`git push\`)
- [ ] Create pull request (\`gh pr create\`)
- [ ] Run \`/motherhen\` for health check
- [ ] Run \`/dlc-audit\` for compliance score
EOF

  log "Completion report: $STATE_DIR/completion-report.md"
}

main "$@"
