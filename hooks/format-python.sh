#!/usr/bin/env bash
# Format Python files with ruff after Write/Edit operations
# Requires: uv and ruff (uv tool install ruff)
# Silently skips if ruff is not available

set -e

# Read JSON input from stdin
input=$(cat)

# Extract file path from tool_input
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# Exit if no file path
if [ -z "$file_path" ]; then
    exit 0
fi

# Only format .py files
if [[ "$file_path" != *.py ]]; then
    exit 0
fi

# Only format if file exists
if [ ! -f "$file_path" ]; then
    exit 0
fi

# Check if uv is available, skip silently if not
if ! command -v uv &>/dev/null; then
    exit 0
fi

# Run ruff format (fails silently if ruff not installed)
uv run ruff format "$file_path" >/dev/null 2>&1 || true

exit 0
