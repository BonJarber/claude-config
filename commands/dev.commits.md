---
allowed-tools: Bash(git:*)
description: Intelligently group and commit changes
---

## Context

- Current branch: !`git branch --show-current`
- Status: !`git status`
- All changes (staged + unstaged): !`git diff HEAD`
- Partially staged files: !`git diff --name-only --cached`
- Recent commit style: !`git log --oneline -20 --pretty=format:"%s"`
- File tree context: !`git ls-tree -r --name-only HEAD`

## Your Task

### Phase 1: Analyze

Examine all changes and identify logical groupings based on:

- Functional relationships (what works together?)
- File dependencies and imports
- Type of change (new feature vs refactor vs fix vs cleanup)
- Potential for atomic, revertable commits

Determine optimal commit order considering:

- Dependencies (infrastructure before features using it)
- Logical narrative (what story does this tell?)
- Each commit should leave the code in a working state

Analyze recent commits to match the team's message style (tone, length, capitalization, punctuation).

### Phase 2: Execute

For each logical commit group:

1. Stage only the relevant files with `git add`
2. Create the commit with `git commit -m` using a message that matches the team's style
3. Show the result

### Phase 3: Offer to Push

After all commits are created, offer to push:

```
All commits created. Would you like to push?

1. **Push** - run `git push` (or `git push -u origin <branch>` if no upstream)
2. **Skip** - don't push, I'll do it later
```

If the user chooses to push:

1. Check if the branch has an upstream (`git rev-parse --abbrev-ref @{u}`)
2. If no upstream, use `git push -u origin <branch>`
3. If upstream exists, use `git push`

## Constraints

- DO NOT add any co-authorship footers
- If there are conflicts or partially staged files, explain the situation and ask how to proceed
- Only create one commit per file, don't try to split changes in one file into multiple commits
- Keep messages natural and conversational, matching the team's style
- Each commit should be atomic and potentially revertable
