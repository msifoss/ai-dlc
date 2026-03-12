#!/usr/bin/env bash
# Install AI-DLC skills and commands into Claude Code configuration
# Usage: bash scripts/install-skills.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
CLAUDE_DIR="${HOME}/.claude"

echo "Installing AI-DLC skills ecosystem..."
echo "  Source: ${REPO_DIR}/skills/"
echo "  Target: ${CLAUDE_DIR}/"
echo ""

# Create target directories
mkdir -p "${CLAUDE_DIR}/commands"
mkdir -p "${CLAUDE_DIR}/skills"

# Install commands
COMMANDS_SRC="${REPO_DIR}/skills/commands"
COMMANDS_DST="${CLAUDE_DIR}/commands"
count=0
for cmd in "${COMMANDS_SRC}"/*.md; do
  name=$(basename "$cmd")
  if [ -f "${COMMANDS_DST}/${name}" ]; then
    echo "  Updating command: ${name}"
  else
    echo "  Installing command: ${name}"
  fi
  cp "$cmd" "${COMMANDS_DST}/${name}"
  count=$((count + 1))
done
echo "  ${count} commands installed."
echo ""

# Install skills
SKILLS_SRC="${REPO_DIR}/skills/skills"
SKILLS_DST="${CLAUDE_DIR}/skills"
count=0
for skill_dir in "${SKILLS_SRC}"/*/; do
  name=$(basename "$skill_dir")
  mkdir -p "${SKILLS_DST}/${name}"
  if [ -f "${SKILLS_DST}/${name}/SKILL.md" ]; then
    echo "  Updating skill: ${name}"
  else
    echo "  Installing skill: ${name}"
  fi
  cp -r "${skill_dir}"* "${SKILLS_DST}/${name}/"
  count=$((count + 1))
done
echo "  ${count} skills installed."
echo ""

echo "Done. Skills are available immediately in Claude Code."
echo ""
echo "New commands available:"
echo "  /bolt-lfg     — Autonomous bolt pipeline"
echo "  /brainstorm   — Explore before you plan"
echo "  /setup        — Per-project configuration"
echo ""
echo "Run /setup in your project to create .ai-dlc.local.yaml"
