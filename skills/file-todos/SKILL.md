---
name: file-todos
description: This skill manages the file-based TODO tracking system in the todos/ directory. It provides workflows for creating TODOs, managing status and dependencies, conducting triage, and integrating with /review, /address-feedback, and /plan-feature commands.
---

# File-Based TODO Tracking Skill

## Overview

The `todos/` directory contains a file-based tracking system for managing code review feedback, technical debt, feature requests, and work items. TODOs are organized by **branch**, with each branch having its own subdirectory. Each TODO is a markdown file with YAML frontmatter and structured sections.

This skill should be used when:

- Creating new TODOs from findings or feedback
- Managing TODO lifecycle (pending → ready → complete)
- Triaging pending items for approval
- Converting PR comments or code findings into tracked work
- Updating work logs during TODO execution

## Directory Structure

TODOs are organized by git branch:

```
todos/
├── feature-auth/           # Branch: alice/feature-auth
│   ├── 001-pending-p1-fix-login.md
│   └── 002-ready-p2-add-tests.md
└── bugfix-query/           # Branch: bob/bugfix-query
    └── 001-ready-p1-optimize-sql.md
```

**Branch suffix extraction:**

- `alice/feature-auth` → `feature-auth/`
- `bugfix-query` → `bugfix-query/`
- `main` → Warns user to create a feature branch

**Key principle:** Each branch is an isolated unit of work with its own sequential issue IDs (001, 002, 003...).

## File Naming Convention

TODO files follow this naming pattern:

```
{issue_id}-{status}-{priority}-{description}.md
```

**Components:**

- **issue_id**: Sequential number (001, 002, 003...) - never reused
- **status**: `pending` (needs triage), `ready` (approved), `complete` (done)
- **priority**: `p1` (critical), `p2` (important), `p3` (nice-to-have)
- **description**: kebab-case, brief description

**Examples:**

```
001-pending-p1-fix-auth-bug.md
002-ready-p2-optimize-database-query.md
005-complete-p3-add-type-hints.md
```

## File Structure

Each TODO is a markdown file with YAML frontmatter and structured sections. Use the template at `assets/todo-template.md` as a starting point when creating new TODOs.

**Required sections:**

- **Problem Statement** - What is broken, missing, or needs improvement?
- **Findings** - Investigation results, root cause, key discoveries
- **Proposed Solutions** - Options with pros/cons, effort, risk
- **Acceptance Criteria** - Testable checklist items
- **Work Log** - Chronological record with date, actions, learnings

**YAML frontmatter fields:**

```yaml
---
status: ready # pending | ready | complete
priority: p1 # p1 | p2 | p3
issue_id: "002"
tags: [security, api, code-review]
dependencies: ["001"] # Issue IDs this is blocked by
---
```

## Common Workflows

### Branch Detection

Before any TODO operation, detect the current branch and set up the TODO directory:

```bash
# Get branch suffix (alice/feature-auth → feature-auth)
branch_suffix=$(git branch --show-current | sed 's|.*/||')
todo_dir="todos/$branch_suffix"

# Warn if on main branch
if [ "$branch_suffix" = "main" ] || [ "$branch_suffix" = "master" ]; then
    echo "⚠️ Warning: You're on the $branch_suffix branch."
    echo "TODOs should typically be associated with feature branches."
    # Offer to create a new branch or continue anyway
fi

# Ensure directory exists
mkdir -p "$todo_dir"
```

### Creating a New TODO

1. Set up branch directory and determine next issue ID:

   ```bash
   branch_suffix=$(git branch --show-current | sed 's|.*/||')
   todo_dir="todos/$branch_suffix"
   mkdir -p "$todo_dir"
   next_id=$(ls "$todo_dir"/ 2>/dev/null | grep -o '^[0-9]\+' | sort -n | tail -1 | awk '{printf "%03d", $1+1}')
   [ -z "$next_id" ] && next_id="001"
   ```

2. Copy template:

   ```bash
   cp ~/.claude/skills/file-todos/assets/todo-template.md "$todo_dir/{NEXT_ID}-pending-{priority}-{description}.md"
   ```

3. Fill required sections:
   - Problem Statement
   - Findings (if from investigation)
   - Proposed Solutions
   - Acceptance Criteria
   - Initial Work Log entry

4. Add relevant tags for filtering

**When to create a TODO:**

- Requires more than 15-20 minutes of work
- Needs research, planning, or multiple approaches
- Has dependencies on other work
- Requires approval or prioritization
- Part of larger feature or refactor

**When to act immediately instead:**

- Issue is trivial (< 15 minutes)
- Complete context available now
- No planning needed
- Simple fix with obvious solution

### Triaging Pending Items

Use `/triage` command or manually:

1. Set up branch directory:
   ```bash
   branch_suffix=$(git branch --show-current | sed 's|.*/||')
   todo_dir="todos/$branch_suffix"
   ```
2. List pending items: `ls "$todo_dir"/*-pending-*.md`
3. For each TODO:
   - Read Problem Statement and Findings
   - Review Proposed Solutions
   - Make decision: approve, defer, or modify priority
4. Update approved TODOs:
   - Rename file: `pending` → `ready`
   - Update frontmatter: `status: ready`
   - Fill "Recommended Action" section
5. Deferred TODOs stay in `pending` status

### Managing Dependencies

Dependencies are tracked within the same branch only (no cross-branch dependencies).

**Track dependencies:**

```yaml
dependencies: ["002", "005"]  # Blocked by issues 002 and 005 in same branch
dependencies: []               # No blockers
```

**Check what blocks a TODO:**

```bash
branch_suffix=$(git branch --show-current | sed 's|.*/||')
grep "^dependencies:" "todos/$branch_suffix"/003-*.md
```

**Find what a TODO blocks:**

```bash
branch_suffix=$(git branch --show-current | sed 's|.*/||')
grep -l 'dependencies:.*"002"' "todos/$branch_suffix"/*.md
```

### Completing a TODO

1. Verify all acceptance criteria checked off
2. Update Work Log with final session
3. Rename file: `ready` → `complete`
4. Update frontmatter: `status: complete`
5. Check for unblocked work
6. Commit with issue reference

## Integration with Commands

| Command        | Creates TODOs                   | Uses TODOs              |
| -------------- | ------------------------------- | ----------------------- |
| `/dev.spec`    | No                              | No                      |
| `/dev.plan`    | No                              | No                      |
| `/dev.tasks`   | Yes - generates TODOs from plan | No                      |
| `/dev.work`    | No                              | Yes - executes TODOs    |
| `/dev.triage`  | No                              | Yes - manages lifecycle |
| `/dev.commits` | No                              | No                      |

## Quick Reference

**Setup (run before any TODO operation):**

```bash
branch_suffix=$(git branch --show-current | sed 's|.*/||')
todo_dir="todos/$branch_suffix"
mkdir -p "$todo_dir"
```

**Finding work (current branch):**

```bash
# List highest priority unblocked work
ls "$todo_dir"/*-ready-p1-*.md

# List pending items needing triage
ls "$todo_dir"/*-pending-*.md

# Find next issue ID for this branch
next_id=$(ls "$todo_dir"/ 2>/dev/null | grep -o '^[0-9]\+' | sort -n | tail -1 | awk '{printf "%03d", $1+1}')
[ -z "$next_id" ] && next_id="001"

# Count by status (current branch)
for status in pending ready complete; do
  echo "$status: $(ls -1 "$todo_dir"/*-$status-*.md 2>/dev/null | wc -l)"
done
```

**Searching (current branch):**

```bash
# Search by tag
grep -l "tags:.*security" "$todo_dir"/*.md

# Search by priority
ls "$todo_dir"/*-p1-*.md

# Full-text search
grep -r "user_id" "$todo_dir"/
```

**Searching (all branches):**

```bash
# Find all pending TODOs across branches
find todos -name "*-pending-*.md"

# Search all branches by tag
grep -r "tags:.*security" todos/

# List all branch directories
ls -d todos/*/
```

## Key Distinctions

**File-todos system (this skill):**

- Markdown files in `todos/<branch>/` directories
- Branch-based organization (one directory per feature branch)
- Development/project tracking
- Standalone markdown files with YAML frontmatter
- Used by humans and Claude Code agents

**TodoWrite tool:**

- In-memory task tracking during agent sessions
- Temporary tracking for single conversation
- Not persisted to disk
- Different from this file-based system
