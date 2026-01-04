---
description: Execute work plans efficiently while maintaining quality
argument-hint: "[plan file, spec file, or TODO file path]"
skills: [file-todos]
---

# Work Execution Command

Execute a work plan as a **manager agent** that coordinates subagents.

## Introduction

This command takes a work document (plan, specification, or TODO file) and executes it by spawning specialized subagents. You are the manager—your job is to understand the plan, break it into delegatable tasks, spawn subagents to do the work, and verify their output. This pattern prevents context exhaustion on large features by offloading implementation details to fresh agent contexts.

## Input Document

<input_document> $ARGUMENTS </input_document>

---

## Overview

Execute work by spawning specialized subagents. **You are the manager** - your job is to understand the plan, break it into tasks, delegate to subagents, and verify their work. You should NOT implement code directly.

---

## Step 0: Gather Context

### Find Related Documents

Based on the input, locate related context:

**If input is a TODO file (`todos/<branch>/XXX-...md`):**

1. Check TODO's frontmatter for related spec/plan
2. Look for plan in `specs/<feature>/plan.md`
3. Check for sibling TODOs in same branch directory

**If input is a plan file (`specs/<feature>/plan.md`):**

1. Read the associated spec at `specs/<feature>/spec.md`
2. Check if TODOs exist in `todos/<branch>/`

**If input is a spec file (`specs/<feature>/spec.md`):**

1. Check if a plan exists at `specs/<feature>/plan.md`
2. If no plan, suggest running `/dev.plan` first

### Constitution Check (Advisory)

Before starting, check `~/.claude/constitution.md`:

| Article             | Check                            |
| ------------------- | -------------------------------- |
| Test-First          | Are test-first tasks identified? |
| Measurable Outcomes | Are success criteria defined?    |
| Simplicity          | Is the approach minimal?         |

Warn about any issues but don't block execution.

---

## Your Role as Manager

**You are an orchestrator.** Your responsibilities:

- **Understand** the plan and requirements
- **Break down** work into delegatable chunks
- **Spawn subagents** to do implementation and verification
- **Review** subagent results and decide next steps
- **Track progress** via TodoWrite
- **Report** status to the user

**You should NOT:**

- Write implementation code directly
- Run tests or linting commands directly
- Make file edits yourself (except TodoWrite)

---

## Execution Workflow

### Phase 1: Quick Start

1. **Read Input Document**
   - Read the work document completely
   - Review any references or links provided
   - Load related spec/plan for context

2. **Clarify if Needed**
   - If anything is unclear or ambiguous, ask clarifying questions
   - Get user approval to proceed
   - **Do not skip this step** - better to ask questions now than build the wrong thing

3. **Create Todo List**
   - Use TodoWrite to break work into actionable tasks
   - Each task should be delegatable to a subagent
   - Include dependencies between tasks
   - Mark test-first tasks

### Phase 2: Execute via Subagents

For each task or logical group:

#### 1. Spawn Implementation Agent

```
Task(general-purpose): "
Implement [specific task description].

Context:
- Spec: [path to spec if available]
- Plan: [path to plan if available]
- [Relevant context from the plan]
- [Files to reference for patterns]

Requirements:
- Follow existing patterns in the codebase
- Follow CLAUDE.md coding standards
- [If test_first: true] Write failing tests FIRST, then implement

Return:
- Summary of changes made
- List of files modified/created
- Any concerns or decisions made
"
```

**Tips for good delegation:**

- Be specific about what to implement
- Include context from spec/plan
- Tell the agent what patterns to follow
- Ask for a summary of what was done
- Specify if tests should come first

#### 2. Spawn Verification Agent

After implementation, verify:

```
Task(general-purpose): "
Verify the recent implementation changes.

Run the following checks:
1. Python linting: `uv run ruff check` and `uv run basedpyright`
2. Python tests: `make test` (or specific test files)
3. Frontend (if applicable): `npx tsc`, `npx eslint`

Return:
- Pass/fail status for each check
- If failures: specific errors and file locations
- Summary of test coverage for new code
"
```

#### 3. Handle Failures

If verification fails, spawn a fix agent:

```
Task(general-purpose): "
Fix the following issues found during verification:

[Paste specific errors from verification agent]

Files likely involved: [list files]

Fix the issues and return a summary of changes.
"
```

#### 4. Update Progress

- Mark task as completed in TodoWrite once verified
- Move to next task
- Repeat the spawn → verify → fix cycle

### Phase 3: Quality Check

For complex or risky changes, spawn specialized reviewers **in parallel**:

```
# Run in parallel using multiple Task calls in one message
Task(python-reviewer): "Review the changes for Python conventions"
Task(code-simplicity-reviewer): "Check for unnecessary complexity"
```

**When to use reviewers:**

- Large refactor (10+ files)
- Security-sensitive changes
- Database migrations
- Complex business logic

### Phase 4: Final Validation

Spawn a final verification agent:

```
Task(general-purpose): "
Run final validation for the completed feature:

1. Run full test suite
2. Run all linting
3. Verify project builds

Return:
- Overall pass/fail
- Any warnings or issues
- Confirmation all checks pass
"
```

### Phase 5: Documentation Review

Check if documentation needs updating:

```
Task(docs-guardian): "
Review whether documentation needs updating.

Changes made:
- [Summary of implementation]
- Files modified: [list key files]

Check:
1. Are existing docs now outdated?
2. Do new features need documentation?
3. Should CLAUDE.md be updated for new patterns?
4. Should new Agent Skills be created for reusable patterns?
5. Are code comments sufficient for complex logic?

Return:
- List of docs that need updates (if any)
- Suggested changes
"
```

**Skip for:** Simple bug fixes or internal refactors.

---

## Test-First Enforcement

For tasks with `test_first: true`:

1. **Instruct implementation agent** to write tests first
2. **Verify tests exist and fail** before implementation
3. **Then implement** to make tests pass
4. **Verify tests now pass**

Example delegation:

```
Task(general-purpose): "
This is a TEST-FIRST task. Follow this order:

1. Write tests that define expected behavior
2. Run tests - confirm they FAIL
3. Implement the feature
4. Run tests - confirm they PASS

[Rest of task details...]
"
```

---

## Updating TODO Files

If working from a TODO file:

### During Work

Add work log entries:

```markdown
### YYYY-MM-DD - Implementation Session

**By:** Claude Code
**Actions:**

- Delegated implementation to subagent
- Verified with linting and tests
- Fixed 2 issues found during verification

**Learnings:**

- [Any discoveries or notes]
```

### On Completion

1. Verify all acceptance criteria checked
2. Rename file: `ready` → `complete`
3. Update frontmatter: `status: complete`
4. Check for unblocked work (dependents)

---

## Example Workflow

```
1. Read plan → Ask clarifying questions → Get approval
2. Create TodoWrite with 3 tasks: A, B, C

3. Task A:
   - Mark A as in_progress
   - Spawn implementation agent for A
   - Review result, spawn verification agent
   - If pass: mark A complete
   - If fail: spawn fix agent, re-verify

4. Task B:
   - Mark B as in_progress
   - Spawn implementation agent for B
   - (same pattern)

5. Task C:
   - (same pattern)

6. All tasks done:
   - Spawn reviewer agents (if complex)
   - Spawn final validation agent
   - Spawn documentation reviewer
   - Report completion to user
```

---

## Key Principles

### You Are the Manager

- Don't do implementation yourself
- Delegate, verify, iterate
- Keep the big picture while agents handle details

### Tight Feedback Loops

- Implement → Verify → Fix for each task
- Don't batch multiple tasks before verification
- Catch issues early

### Clear Delegation

- Be specific in prompts to subagents
- Include relevant context from spec/plan
- Ask for structured responses

### Track Everything

- Update TodoWrite after each task completes
- Keep user informed of progress
- Note any blockers or scope changes

---

## Common Pitfalls

- **Doing work yourself** - Delegate to subagents
- **Vague delegation** - Be specific about what each agent should do
- **Skipping verification** - Always verify after implementation
- **Batching too much** - Implement and verify in small increments
- **Forgetting context** - Pass spec/plan context to subagents
- **Ignoring test-first** - Enforce for tasks marked `test_first: true`

---

## Subagent Prompt Templates

Reusable templates for common subagent delegations:

### Implementation Agent

```
Task(general-purpose): "
You are implementing [TASK DESCRIPTION].

Context:
- Spec file: [path to spec, or 'N/A']
- Plan file: [path to plan, or 'N/A']
- Key requirements: [summarize from plan]
- Related files to reference: [list files with similar patterns]

Requirements:
- Follow existing patterns in the codebase
- Follow CLAUDE.md coding standards
- [If test_first: true] Write failing tests FIRST, then implement

Deliverables:
- Summary of changes made
- List of files modified/created
- Any concerns, decisions, or deviations from plan
"
```

### Test Writing Agent

```
Task(general-purpose): "
Write tests for [FEATURE/CHANGES].

Context:
- Files changed: [list of implementation files]
- Existing test patterns: Look at tests in [test directory path]
- Test framework: [pytest/vitest/etc.]

Requirements:
- Follow existing test patterns and conventions
- Cover happy path and key edge cases
- Include integration tests if touching multiple components

Deliverables:
- List of test files created/modified
- Summary of test coverage added
"
```

### Verification Agent

```
Task(general-purpose): "
Run verification checks on recent changes.

Commands to run:
- Linting: [uv run ruff check . / npx eslint]
- Type checking: [uv run basedpyright / npx tsc]
- Tests: [make test / pytest / npm test]

Deliverables:
- Pass/fail status for each check
- If failures: specific errors with file locations
- Summary of any warnings
"
```

### Fix Agent

```
Task(general-purpose): "
Fix the following errors found during verification:

[PASTE SPECIFIC ERRORS HERE]

Files likely involved: [list files from error messages]

Requirements:
- Fix the root cause, not just symptoms
- Don't break other tests while fixing
- Follow existing code patterns

Deliverables:
- Summary of what was fixed
- Files modified
- Confirmation that re-running verification should pass
"
```
