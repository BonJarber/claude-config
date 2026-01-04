---
description: Generate TODO files from a technical plan
argument-hint: "[plan file path or feature name]"
skills: [file-todos]
---

# Task Generation Workflow

Generate TODO files from a technical plan.

## Input

**Plan:** $ARGUMENTS

---

## Overview

This command creates TODO files from a plan:

1. **Load Plan** - Read the technical plan
2. **Extract Tasks** - Parse implementation phases
3. **Create TODOs** - Generate files with dependencies
4. **Present Summary** - Show created TODOs

**Input:** `specs/<feature-name>/plan.md`
**Output:** `todos/<branch>/XXX-pending-pN-description.md`

---

## Step 1: Load Plan

### Find the Plan

If a path is provided, use it. Otherwise, auto-detect:

```bash
# If argument looks like a path
if [[ "$ARGUMENTS" == *"/"* ]]; then
    plan_path="$ARGUMENTS"
else
    # Try to find plan by feature name
    plan_path="specs/$ARGUMENTS/plan.md"
fi

# Validate it exists
if [ ! -f "$plan_path" ]; then
    echo "Plan not found at $plan_path"
    echo "Available plans:"
    ls specs/*/plan.md 2>/dev/null
fi
```

### Extract Feature Context

From the plan, extract:

- Feature name
- Link to spec file
- Implementation phases and tasks
- Test-first markers `(test-first)`
- Parallelization markers `[P]`
- Files to modify

---

## Step 2: Setup Branch Directory

```bash
# Get branch suffix (alice/feature-auth → feature-auth)
branch_suffix=$(git branch --show-current | sed 's|.*/||')
todo_dir="todos/$branch_suffix"

# Warn if on main branch
if [ "$branch_suffix" = "main" ] || [ "$branch_suffix" = "master" ]; then
    echo "Warning: You're on $branch_suffix. TODOs should be on feature branches."
    # Ask user to create branch or continue
fi

# Ensure directory exists
mkdir -p "$todo_dir"

# Get next issue ID
next_id=$(ls "$todo_dir"/ 2>/dev/null | grep -o '^[0-9]\+' | sort -n | tail -1 | awk '{printf "%03d", $1+1}')
[ -z "$next_id" ] && next_id="001"
```

---

## Step 3: Create TODO Files

For each task in the plan's Implementation Phases:

### Determine Priority

- **P1 (Critical):** Core functionality, blocking other work
- **P2 (Important):** Standard feature tasks
- **P3 (Nice-to-have):** Polish, optimization, cleanup

Default to P2 unless the plan specifies otherwise.

### Determine Dependencies

Tasks in later phases depend on earlier phases:

- Phase 1 tasks: No dependencies
- Phase 2 tasks: Depend on all Phase 1 tasks
- Phase 3 tasks: Depend on all Phase 2 tasks

Tasks marked `[P]` (parallelizable) can run concurrently within their phase.

### Create Each TODO

Use the template at `~/.claude/skills/file-todos/assets/todo-template.md`:

```bash
# For each task
cp ~/.claude/skills/file-todos/assets/todo-template.md \
   "$todo_dir/${next_id}-pending-p2-task-description.md"
```

Fill in:

```yaml
---
status: pending
priority: p2 # or p1/p3 based on task
issue_id: "001"
tags: [feature-name, phase-1]
dependencies: [] # or ["001", "002"] for later phases
test_first: false # or true if marked (test-first)
---
```

**Sections to fill:**

- **Title:** Task name from plan
- **Problem Statement:** Context from plan + spec
- **Proposed Solutions:** Approach from plan
- **Acceptance Criteria:** From plan or derived from spec's US/FR
- **Technical Details:** Files to modify from plan
- **Work Log:** Initial entry noting this was generated from plan

### Test-First Tasks

For tasks marked `(test-first)` in the plan:

1. Set `test_first: true` in frontmatter
2. Add to acceptance criteria:
   - [ ] Tests written and failing before implementation
   - [ ] Implementation makes tests pass

---

## Step 4: Present Summary

```markdown
## TODOs Generated

**Branch:** `<branch-suffix>`
**Plan:** `specs/<feature-name>/plan.md`
**Created:** N TODO files

### Files Created

| ID  | Priority | Task                     | Dependencies | Test-First |
| --- | -------- | ------------------------ | ------------ | ---------- |
| 001 | P2       | Set up project structure | -            | No         |
| 002 | P2       | Implement core logic     | 001          | Yes        |
| 003 | P2       | Add API endpoint         | 001          | Yes        |
| 004 | P3       | Write documentation      | 002, 003     | No         |

### Parallelization

Tasks 002 and 003 can run in parallel (both depend only on 001).

### Next Steps

1. **Triage:** Run `/dev.triage` to review and approve TODOs (pending → ready)
2. **Execute:** Run `/dev.work todos/<branch>/001-ready-p2-...md` to start work
3. **Direct execution:** Run `/dev.work specs/<feature>/plan.md` to skip TODO files
```

---

## When to Skip TODO Generation

Skip creating TODOs and use `/dev.work` directly when:

- Feature is trivial (< 30 minutes total work)
- Single task with no sub-components
- User explicitly requests direct implementation
- Work will complete in one session

---

## TODO File Format Reference

```markdown
---
status: pending
priority: p2
issue_id: "001"
tags: [feature-name]
dependencies: []
test_first: false
---

# Task Title

## Problem Statement

[Context from plan/spec]

## Findings

[From plan research, or filled during work]

## Proposed Solutions

[Approach from plan]

## Acceptance Criteria

- [ ] Criterion from spec/plan
- [ ] Tests written (if test_first: true)
- [ ] Implementation complete

## Technical Details

**Files to modify:**

- `path/to/file.py` - [changes]

**Related:**

- Spec: `specs/<feature>/spec.md`
- Plan: `specs/<feature>/plan.md`

## Work Log

### YYYY-MM-DD - Generated from Plan

**By:** Claude Code
**Actions:** TODO generated from `/dev.tasks`
**Source:** `specs/<feature>/plan.md`
```

---

## Output Summary

After completing this workflow:

1. **TODO files** in `todos/<branch>/`
2. **Dependencies** mapped between tasks
3. **Test-first tasks** marked in metadata
4. **Ready for triage** or direct execution

Use `/dev.triage` to approve TODOs or `/dev.work` to execute.
