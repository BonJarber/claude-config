#!/bin/bash
input=$(cat)
MODEL=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')

# Show git branch if available
BRANCH=$(git branch --show-current 2>/dev/null)
[ -n "$BRANCH" ] && BRANCH=" | $BRANCH"

echo "[$MODEL] $CURRENT_DIR$BRANCH"
