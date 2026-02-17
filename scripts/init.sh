#!/usr/bin/env bash
#
# AI-DLC Bootstrap Script
# Initializes a new project with AI-DLC foundational documents and structure.
#
# Usage:
#   ../ai-dlc/scripts/init.sh              # Run from your project directory
#   ../ai-dlc/scripts/init.sh --minimal    # Only essential files
#   ../ai-dlc/scripts/init.sh --full       # All 14 foundational documents
#
# Prerequisites:
#   - Git initialized in the target project directory
#   - AI-DLC repo cloned as a sibling directory (or set AI_DLC_ROOT)

set -euo pipefail

# --- Configuration ---

AI_DLC_ROOT="${AI_DLC_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
TEMPLATES_DIR="${AI_DLC_ROOT}/templates"
TARGET_DIR="$(pwd)"
MODE="${1:-default}"

# --- Colors ---

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- Functions ---

info() { echo -e "${BLUE}[ai-dlc]${NC} $1"; }
success() { echo -e "${GREEN}[ai-dlc]${NC} $1"; }
warn() { echo -e "${YELLOW}[ai-dlc]${NC} $1"; }
error() { echo -e "${RED}[ai-dlc]${NC} $1" >&2; }

copy_template() {
    local src="$1"
    local dest="$2"
    if [ -f "$dest" ]; then
        warn "Skipping $dest (already exists)"
    else
        cp "$src" "$dest"
        success "Created $dest"
    fi
}

# --- Validation ---

if [ ! -d "$TEMPLATES_DIR" ]; then
    error "AI-DLC templates directory not found: $TEMPLATES_DIR"
    error "Set AI_DLC_ROOT to the ai-dlc repository root."
    exit 1
fi

if [ ! -d ".git" ]; then
    warn "No git repository detected. Initializing..."
    git init
    success "Git repository initialized."
fi

# --- Banner ---

echo ""
echo -e "${BLUE}╔══════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         AI-DLC Project Bootstrap         ║${NC}"
echo -e "${BLUE}║     AI Development Life Cycle v1.0.0     ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════╝${NC}"
echo ""
info "Target directory: $TARGET_DIR"
info "Templates source: $TEMPLATES_DIR"
info "Mode: $MODE"
echo ""

# --- Create Directory Structure ---

info "Creating directory structure..."

mkdir -p docs
mkdir -p captain-logs
mkdir -p tests

success "Directory structure created."

# --- Essential Files (always copied) ---

info "Copying essential documents..."

# Context file (most important)
copy_template "$TEMPLATES_DIR/CLAUDE-CONTEXT.md" "CLAUDE.md"

# Security policy
copy_template "$TEMPLATES_DIR/SECURITY.md" "SECURITY.md"

# Requirements
copy_template "$TEMPLATES_DIR/REQUIREMENTS.md" "docs/REQUIREMENTS.md"

# PM framework
copy_template "$TEMPLATES_DIR/PM-FRAMEWORK.md" "docs/PM-FRAMEWORK.md"

if [ "$MODE" = "--minimal" ]; then
    echo ""
    success "Minimal bootstrap complete! (4 documents)"
    info "Next steps:"
    info "  1. Edit CLAUDE.md with your project details"
    info "  2. Read Phase 0: ${AI_DLC_ROOT}/docs/framework/PHASE-0-FOUNDATION.md"
    echo ""
    exit 0
fi

# --- Default Files (essential + workflow) ---

info "Copying workflow documents..."

# Traceability matrix
copy_template "$TEMPLATES_DIR/TRACEABILITY-MATRIX.md" "docs/TRACEABILITY-MATRIX.md"

# User stories
copy_template "$TEMPLATES_DIR/USER-STORIES.md" "docs/USER-STORIES.md"

# Solo AI workflow (most common starting point)
copy_template "$TEMPLATES_DIR/SOLO-AI-WORKFLOW-GUIDE.md" "docs/SOLO-AI-WORKFLOW-GUIDE.md"

if [ "$MODE" = "default" ] || [ "$MODE" = "" ]; then
    echo ""
    success "Default bootstrap complete! (7 documents)"
    info "Next steps:"
    info "  1. Edit CLAUDE.md with your project details"
    info "  2. Review docs/REQUIREMENTS.md and add your requirements"
    info "  3. Read Phase 0: ${AI_DLC_ROOT}/docs/framework/PHASE-0-FOUNDATION.md"
    info "  4. Start your first bolt!"
    echo ""
    exit 0
fi

# --- Full Files (all 14 foundational documents) ---

if [ "$MODE" = "--full" ]; then
    info "Copying remaining foundational documents..."

    copy_template "$TEMPLATES_DIR/CICD-DEPLOYMENT-PROPOSAL.md" "docs/CICD-DEPLOYMENT-PROPOSAL.md"
    copy_template "$TEMPLATES_DIR/MULTI-DEVELOPER-GUIDE.md" "docs/MULTI-DEVELOPER-GUIDE.md"
    copy_template "$TEMPLATES_DIR/INFRASTRUCTURE-PLAYBOOK.md" "docs/INFRASTRUCTURE-PLAYBOOK.md"
    copy_template "$TEMPLATES_DIR/COST-MANAGEMENT-GUIDE.md" "docs/COST-MANAGEMENT-GUIDE.md"
    copy_template "$TEMPLATES_DIR/SECURITY-REVIEW-PROTOCOL.md" "docs/SECURITY-REVIEW-PROTOCOL.md"
    copy_template "$TEMPLATES_DIR/OPS-READINESS-CHECKLIST.md" "docs/OPS-READINESS-CHECKLIST.md"
    copy_template "$TEMPLATES_DIR/AI-DLC-CASE-STUDY.md" "docs/AI-DLC-CASE-STUDY.md"

    echo ""
    success "Full bootstrap complete! (14 documents)"
    info "Next steps:"
    info "  1. Edit CLAUDE.md with your project details"
    info "  2. Review docs/REQUIREMENTS.md and add your requirements"
    info "  3. Select your governance model:"
    info "     - Solo+AI:    ${AI_DLC_ROOT}/docs/governance/SOLO-AI.md"
    info "     - Small Team: ${AI_DLC_ROOT}/docs/governance/SMALL-TEAM.md"
    info "     - Enterprise: ${AI_DLC_ROOT}/docs/governance/ENTERPRISE.md"
    info "  4. Read Phase 0: ${AI_DLC_ROOT}/docs/framework/PHASE-0-FOUNDATION.md"
    info "  5. Start your first bolt!"
    echo ""
    exit 0
fi

# --- Unknown Mode ---

error "Unknown mode: $MODE"
error "Usage: $0 [--minimal|--full]"
error "  (no flag)   Default — 7 essential + workflow documents"
error "  --minimal   4 essential documents only"
error "  --full      All 14 foundational documents"
exit 1
