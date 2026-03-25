#!/bin/bash
# teardown.sh — Remove agent symlinks from ~/.claude/agents/
# Only removes symlinks that point back to this repo. Won't touch other agents.

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="$REPO_DIR/agents"
TARGET_DIR="$HOME/.claude/agents"

echo "Removing agent symlinks..."
echo ""

removed=0
for agent_file in "$AGENTS_DIR"/*.md; do
    [ -f "$agent_file" ] || continue
    filename="$(basename "$agent_file")"
    target="$TARGET_DIR/$filename"

    if [ -L "$target" ]; then
        current_target="$(readlink "$target")"
        if [ "$current_target" = "$agent_file" ]; then
            rm "$target"
            echo "  ✅ Removed $filename"
            ((removed++))
        else
            echo "  ⏭️  Skipped $filename (points elsewhere)"
        fi
    else
        echo "  ⏭️  Skipped $filename (not a symlink from this repo)"
    fi
done

echo ""
echo "Done. $removed agent(s) removed."
echo "Restart your Claude Code session to apply changes."
