#!/usr/bin/env bash
# Format markdown files with prettier after Write/Edit operations
# Requires: npx and prettier (npm install -g prettier)
# Silently skips if prettier is not available

set -e

# Read JSON input from stdin
input=$(cat)

# Extract file path from tool_input
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# Exit if no file path
if [ -z "$file_path" ]; then
    exit 0
fi

# Only format .md files
if [[ "$file_path" != *.md ]]; then
    exit 0
fi

# Only format if file exists (Edit on non-existent file would fail)
if [ ! -f "$file_path" ]; then
    exit 0
fi

# Check if npx is available, skip silently if not
if ! command -v npx &>/dev/null; then
    exit 0
fi

# Run prettier (fails silently if prettier not installed)
npx prettier --write "$file_path" >/dev/null 2>&1 || true

exit 0