#!/usr/bin/env bash
#
# AI-DLC Bootstrap Script
# Initializes a new project with AI-DLC foundational documents and structure.
#
# Usage:
#   ../ai-dlc/scripts/init.sh              # Run from your project directory
#   ../ai-dlc/scripts/init.sh --minimal    # Only essential files
#   ../ai-dlc/scripts/init.sh --full       # All 14 foundational documents
#   ../ai-dlc/scripts/init.sh --strict     # Fail on integrity warnings
#
# Flags can be combined: ../ai-dlc/scripts/init.sh --full --strict
#
# Prerequisites:
#   - Git initialized in the target project directory
#   - AI-DLC repo cloned as a sibling directory (or set AI_DLC_ROOT)

set -euo pipefail

# --- Configuration ---

AI_DLC_ROOT="${AI_DLC_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
TEMPLATES_DIR="${AI_DLC_ROOT}/templates"
TARGET_DIR="$(pwd)"
MODE="default"
STRICT=false
INTEGRITY_WARNINGS=0

# Parse arguments
for arg in "$@"; do
    case "$arg" in
        --minimal|--full) MODE="$arg" ;;
        --strict) STRICT=true ;;
        *) echo "Error: Unknown argument: $arg" >&2
           echo "Usage: $0 [--minimal|--full] [--strict]" >&2
           echo "  (no flag)   Default — 8 essential + workflow documents" >&2
           echo "  --minimal   4 essential documents only" >&2
           echo "  --full      All 14 foundational documents" >&2
           echo "  --strict    Fail on source integrity warnings" >&2
           exit 1 ;;
    esac
done

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

integrity_warn() {
    warn "$1"
    INTEGRITY_WARNINGS=$((INTEGRITY_WARNINGS + 1))
}

copy_template() {
    local src="$1"
    local dest="$2"
    if [ -f "$dest" ]; then
        warn "Skipping $dest (already exists)"
    else
        if [ ! -f "$src" ]; then
            error "Template not found: $src"
            return 1
        fi
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

# Source integrity check: verify AI_DLC_ROOT is a git repo with a known remote
if [ -d "${AI_DLC_ROOT}/.git" ]; then
    REMOTE_URL=$(git -C "$AI_DLC_ROOT" remote get-url origin 2>/dev/null || echo "")
    if [ -z "$REMOTE_URL" ]; then
        integrity_warn "AI-DLC source has no git remote configured. Templates are unverified."
        integrity_warn "Ensure $AI_DLC_ROOT is a trusted, unmodified clone of the AI-DLC repository."
    elif [[ ! "$REMOTE_URL" =~ github\.com[:/]msifoss/ai-dlc ]]; then
        integrity_warn "AI-DLC remote ($REMOTE_URL) does not match the expected source."
        integrity_warn "Expected: github.com/msifoss/ai-dlc"
        integrity_warn "Ensure this is a trusted fork or mirror before proceeding."
    fi
    # Check for uncommitted modifications to templates
    if git -C "$AI_DLC_ROOT" diff --quiet -- templates/ 2>/dev/null; then
        : # Templates are clean
    else
        integrity_warn "AI-DLC templates have uncommitted local modifications."
        integrity_warn "Review changes with: git -C $AI_DLC_ROOT diff -- templates/"
    fi
else
    integrity_warn "AI-DLC source ($AI_DLC_ROOT) is not a git repository."
    integrity_warn "Template integrity cannot be verified. Ensure this is a trusted source."
fi

# In strict mode, abort if any integrity warnings were raised
if [ "$STRICT" = true ] && [ "$INTEGRITY_WARNINGS" -gt 0 ]; then
    error "Strict mode: $INTEGRITY_WARNINGS integrity warning(s) detected. Aborting."
    error "Fix the warnings above or run without --strict to proceed anyway."
    exit 1
fi

if [ ! -d ".git" ]; then
    warn "No git repository detected. Initializing..."
    git init
    success "Git repository initialized."
fi

# --- Banner ---

echo ""
AI_DLC_VERSION=$(git -C "$AI_DLC_ROOT" describe --tags --abbrev=0 2>/dev/null || echo "dev")
echo -e "${BLUE}╔══════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         AI-DLC Project Bootstrap         ║${NC}"
printf "${BLUE}║     AI Development Life Cycle %-10s ║${NC}\n" "$AI_DLC_VERSION"
echo -e "${BLUE}╚══════════════════════════════════════════╝${NC}"
echo ""
info "Target directory: $TARGET_DIR"
info "Templates source: $TEMPLATES_DIR"
info "Mode: $MODE"
if [ "$STRICT" = true ]; then
    info "Strict mode: enabled"
fi
echo ""

# --- Create Directory Structure ---

info "Creating directory structure..."

mkdir -p docs
mkdir -p docs/captains_log
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

# Security review protocol (procedural guide for conducting reviews)
copy_template "$TEMPLATES_DIR/SECURITY-REVIEW-PROTOCOL.md" "docs/SECURITY-REVIEW-PROTOCOL.md"

if [ "$MODE" = "default" ]; then
    echo ""
    success "Default bootstrap complete! (8 documents)"
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
