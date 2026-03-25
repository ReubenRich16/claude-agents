#!/bin/bash
# setup.sh — Link agents from this repo into ~/.claude/agents/
# Run this once on each machine after cloning.
# Re-run after pulling new agents to pick up changes automatically (symlinks stay current).

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="$REPO_DIR/agents"
TARGET_DIR="$HOME/.claude/agents"

echo "Claude Code Agent Setup"
echo "======================="
echo "Source:  $AGENTS_DIR"
echo "Target:  $TARGET_DIR"
echo ""

# Create target directory
mkdir -p "$TARGET_DIR"

# Count agents
agent_count=0
updated_count=0

for agent_file in "$AGENTS_DIR"/*.md; do
    [ -f "$agent_file" ] || continue
    filename="$(basename "$agent_file")"
    target="$TARGET_DIR/$filename"

    if [ -L "$target" ]; then
        # Symlink already exists — check if it points to the right place
        current_target="$(readlink "$target")"
        if [ "$current_target" = "$agent_file" ]; then
            echo "  ✓ $filename (already linked)"
            ((agent_count++))
            continue
        else
            # Points somewhere else — update it
            rm "$target"
            echo "  🔄 $filename (updated link)"
            ((updated_count++))
        fi
    elif [ -f "$target" ]; then
        # Regular file exists — back it up and replace
        backup="$target.backup.$(date +%Y%m%d%H%M%S)"
        mv "$target" "$backup"
        echo "  📦 $filename (backed up existing → $(basename "$backup"))"
    fi

    ln -s "$agent_file" "$target"
    echo "  ✅ $filename → linked"
    ((agent_count++))
done

echo ""
echo "Done. $agent_count agents linked, $updated_count updated."
echo ""
echo "Next steps:"
echo "  1. Restart your Claude Code session (or run /agents to verify)"
echo "  2. Try: 'Use the codebase-auditor agent for a health check'"
echo ""
echo "To uninstall, run: ./teardown.sh"
