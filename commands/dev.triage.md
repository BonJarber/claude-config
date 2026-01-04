---
description: Interactive triage of pending TODO items
skills: [file-todos]
---

# TODO Triage Workflow

## Overview

This workflow helps you triage pending TODO items, making decisions about priority and next steps. TODOs are organized by branch, so this workflow operates on the current branch's TODOs.

---

## Step 0: Branch Detection & Setup

Before triaging, detect the current branch and check for issues:

```bash
# Get branch suffix (alice/feature-auth → feature-auth)
branch_suffix=$(git branch --show-current | sed 's|.*/||')
todo_dir="todos/$branch_suffix"
```

### Main Branch Warning

If on `main` or `master`:

```markdown
You're on the `main` branch.

TODOs should typically be associated with feature branches. Would you like to:

1. Create a new feature branch first
2. Continue triaging main branch TODOs anyway
```

If option 1: Help create and switch to a new branch.

---

## Step 1: Gather Pending TODOs

Find all pending TODO files for the current branch:

```bash
mkdir -p "$todo_dir"
ls -la "$todo_dir"/*-pending-*.md 2>/dev/null || echo "No pending TODOs found for branch: $branch_suffix"
```

If no TODOs exist for this branch, check for other TODO tracking:

- TODOs in other branches: `find todos -name "*-pending-*.md"`
- GitHub issues assigned to you
- Comments in code (grep for TODO/FIXME)

---

## Step 2: Present Each TODO

For each pending TODO, present it to the user with this format:

```markdown
---
## TODO [X of Y]: [Title]

**File:** `todos/$branch_suffix/[filename].md`
**Current Priority:** [p1/p2/p3]
**Tags:** [tags]
**Test-First:** [Yes/No]

### Problem
[Summarize the problem statement]

### Context
[Key findings or background]

### Proposed Solutions
[List solution options if present]

---

**What would you like to do?**

1. Approve - Mark as ready to work on
2. Skip - Leave as pending, move to next
3. Delete - Remove this TODO
4. Edit - Modify priority, details, or approach
5. Merge - Combine with another TODO
```

---

## Step 3: Process User Decision

Based on user choice:

### Approve

- Rename file: `*-pending-*` → `*-ready-*`
- Update YAML frontmatter: `status: ready`
- Add to work log: "Approved during triage on [date]"

### Skip

- Leave file unchanged
- Move to next TODO

### Delete

- Confirm with user: "Are you sure? This cannot be undone."
- If confirmed, delete the file
- Log deletion in session notes

### Edit

- Ask what to change:
  - Priority (p1/p2/p3)
  - Title/description
  - Proposed solution
  - Tags
  - Test-first flag
- Update file accordingly
- Then ask: Approve or continue editing?

### Merge

- Show list of other pending TODOs
- Ask which to merge with
- Combine problem statements and solutions
- Delete the merged-from file

---

## Step 4: Triage Summary

After processing all TODOs (or user ends early), show summary:

```markdown
## Triage Complete

**Branch:** `$branch_suffix`

### Session Results

- **Reviewed:** [X] items
- **Approved:** [Y] items → Ready to work
- **Skipped:** [Z] items → Still pending
- **Deleted:** [W] items
- **Edited:** [V] items

### Ready to Work (by priority)

**P1 - Critical:**

- `todos/$branch_suffix/001-ready-p1-security-fix.md` - [title]

**P2 - Important:**

- `todos/$branch_suffix/002-ready-p2-performance.md` - [title]

**P3 - Nice-to-Have:**

- `todos/$branch_suffix/003-ready-p3-cleanup.md` - [title]

### Test-First Tasks

- `todos/$branch_suffix/002-ready-p2-performance.md` - Requires tests before implementation

### Still Pending

- `todos/$branch_suffix/004-pending-p2-feature.md` - [title]

### Next Steps

Would you like to:

1. Start working on P1 items with `/dev.work`
2. Continue with another triage session
3. View detailed plan for a specific TODO
```

---

## TODO File Format Reference

TODOs should follow this structure:

```markdown
---
status: pending | ready | complete
priority: p1 | p2 | p3
issue_id: "001"
tags: [security, api, etc]
dependencies: []
test_first: false
---

# Issue Title

## Problem Statement

[What's broken/missing, why it matters]

## Findings

[Discoveries with evidence/location]

## Proposed Solutions

[Options with pros/cons/effort/risk]

## Acceptance Criteria

- [ ] Criterion 1
- [ ] Criterion 2

## Work Log

### YYYY-MM-DD - Session Title

**Actions:** [What was done]
**Learnings:** [What was learned]
```

---

## Quick Commands

During triage, user can say:

- "approve all p1" - Approve all P1 priority items
- "skip rest" - Skip remaining items, show summary
- "show [filename]" - Display full TODO details
- "stop" - End triage, show summary
