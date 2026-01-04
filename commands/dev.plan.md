---
description: Create a technical implementation plan (HOW)
argument-hint: "[spec file path or feature name]"
---

# Technical Planning Workflow

Create a technical plan that defines HOW we're implementing the feature.

## Input

**Specification:** $ARGUMENTS

---

## Overview

This command creates a technical plan from a specification:

1. **Load Specification** - Read and validate the spec
2. **Constitution Check** - Advisory compliance review
3. **Technical Design** - Architecture and implementation approach
4. **Plan Review** - Parallel review agents catch issues
5. **Save Plan** - Output to `specs/<feature>/plan.md`

**Input:** `specs/<feature-name>/spec.md`
**Output:** `specs/<feature-name>/plan.md`

---

## Step 1: Load Specification

### Find the Specification

If a path is provided, use it. Otherwise, auto-detect:

```bash
# If argument looks like a path
if [[ "$ARGUMENTS" == *"/"* ]]; then
    spec_path="$ARGUMENTS"
else
    # Try to find spec by feature name
    spec_path="specs/$ARGUMENTS/spec.md"
fi

# Validate it exists
if [ ! -f "$spec_path" ]; then
    echo "Specification not found at $spec_path"
    echo "Available specs:"
    ls specs/*/spec.md 2>/dev/null
fi
```

### Read and Summarize

Read the specification and extract:

- Problem Statement
- User Stories (US-1, US-2...)
- Functional Requirements (FR-001...)
- Success Criteria (SC-001...)
- Open Questions
- Research Findings

If the spec has unresolved `[NEEDS CLARIFICATION]` items, ask the user to resolve them before proceeding.

---

## Step 2: Constitution Check

Check the specification against `~/.claude/constitution.md` (advisory):

| Article             | Check                                  | Status |
| ------------------- | -------------------------------------- | ------ |
| Test-First          | Will plan include test-first tasks?    | [ ]    |
| Measurable Outcomes | Spec has SC-xxx metrics?               | [ ]    |
| Simplicity          | Approach is minimal/simple?            | [ ]    |
| Clarification       | No unresolved [NEEDS CLARIFICATION]?   | [ ]    |
| Interview-Driven    | Spec informed by research + interview? | [ ]    |
| Security by Design  | Security considerations addressed?     | [ ]    |

**Advisory Mode:** Warn about violations but don't block. Document any warnings in the plan.

---

## Step 3: Technical Design

### Research Phase (If Needed)

If the specification's research findings are insufficient, launch additional agents:

```
architecture-strategist:
"Design the technical approach for [feature].
Based on spec: [summarize key requirements]
Consider: component placement, data flow, API design.
Identify files to modify and integration points."

pattern-recognition-specialist:
"Find implementation patterns for [feature type].
Look for similar existing code to reference.
Identify conventions to follow."
```

### Design Decisions

For each major decision, document:

- **What:** The decision
- **Why:** Rationale
- **Alternatives considered:** What else was evaluated

### Select Plan Complexity

Match plan depth to feature complexity:

#### Simple Features (1-2 files, <100 LOC)

Use a lightweight inline plan:

```markdown
## Plan: [Feature Name]

### Summary

[One paragraph description]

### Changes Required

1. [File] - [What to change]
2. [File] - [What to change]

### Implementation Notes

- [Key considerations]
```

#### Standard Features (3-5 files, ~100-500 LOC)

Use `~/.claude/templates/plan-template.md` with core sections:

- Constitution Check, Summary, Technical Context
- Implementation Phases, Test Strategy, Files to Modify

#### Major Features (Many files, architectural changes)

Use full template including all sections:

- Constitution Check, Summary, Technical Context, Architecture
- Implementation Phases, Test Strategy, Files to Modify
- API Changes, Database Changes, Security Considerations
- Risks & Mitigations, Rollout Plan, Open Questions

### Create Technical Plan

Use the template at `~/.claude/templates/plan-template.md`:

1. **Constitution Check** - Fill the compliance table (all 6 articles)
2. **Summary** - 2-3 sentence technical approach
3. **Technical Context** - Language, framework, dependencies
4. **Architecture** - How it fits into the system
5. **Implementation Phases** - Ordered task breakdown with:
   - `(test-first)` marker for tasks needing tests first
   - `[P]` marker for parallelizable tasks
6. **Test Strategy** - Unit, integration, test-first tasks
7. **Security Considerations** - Auth, authz, input validation, data access
8. **Files to Modify** - Specific file changes
9. **Risks & Mitigations** - Potential issues and how to address
10. **Rollout Plan** - Feature flags, migration, monitoring (for major features)

---

## Step 4: Plan Review

Launch review agents **in parallel** to catch issues:

### Always Launch

```
plan-reviewer:
"Review this implementation plan for [feature].
[Include the full plan]
Search the codebase to validate assumptions about existing code.
Check for hidden complexity, missing edge cases, ripple effects."

architecture-strategist:
"Review this plan for architectural soundness.
Check for:
- Architectural inconsistencies
- Missing integration points
- Data flow issues
- Security gaps
- Scalability concerns"

pattern-recognition-specialist:
"Review this plan against codebase patterns.
Check for:
- Deviations from conventions
- Missed reuse opportunities
- Naming inconsistencies
- Anti-patterns being introduced"
```

### Conditionally Launch

Based on the feature:

- `python-reviewer` - If plan has Python code snippets
- `typescript-reviewer` - If plan has TypeScript code snippets
- `best-practices-researcher` - If involving unfamiliar patterns

### Domain-Specific Review Agents

Launch additional `general-purpose` agents for concerns not covered by specialized reviewers:

```
general-purpose (security focus):
"Review this plan from a security perspective.
Check for: auth/authz gaps, data exposure risks, injection vectors,
secrets handling, audit logging needs.
[Include relevant plan sections]"

general-purpose (testing strategy):
"Review the testing strategy in this plan.
Check for: missing test coverage, hard-to-test designs,
integration test gaps, edge cases not covered.
[Include relevant plan sections]"

general-purpose (migration/rollout):
"Review the migration and rollout approach.
Check for: backwards compatibility issues, data migration risks,
feature flag strategy, rollback plan gaps.
[Include relevant plan sections]"
```

Choose which to launch based on the feature's risk areas:

- **Security focus** - If feature involves auth, data access, or external inputs
- **Testing strategy** - If feature has complex logic or integration points
- **Migration/rollout** - If feature requires database changes or phased rollout

### Process Review Feedback

1. **Collect all feedback** from review agents
2. **Categorize by severity:**
   - **Blocking:** Must address before proceeding
   - **Important:** Should address
   - **Minor:** Note but don't block
3. **Update plan** to address blocking and important issues
4. **Document tradeoffs** if you disagree with feedback

### Skip Review For

- Simple features (1-2 files, well-defined)
- Trivial changes where review overhead exceeds benefit

---

## Step 5: Save and Present

1. **Save plan** to `specs/<feature-name>/plan.md`

2. **Present summary** to user:

```markdown
## Technical Plan Complete

**Saved to:** `specs/<feature-name>/plan.md`

### Summary

[Technical approach summary]

### Constitution Compliance

| Article             | Status |
| ------------------- | ------ |
| Test-First          | [x]    |
| Measurable Outcomes | [x]    |
| Simplicity          | [x]    |

[Any advisory warnings]

### Implementation Phases

1. [Phase 1]: [N tasks]
2. [Phase 2]: [N tasks]
3. [Phase 3]: [N tasks]

### Review Findings

[Key feedback addressed]

### Key Decisions

- [Decision 1]: [rationale]
- [Decision 2]: [rationale]

---

**Next Steps:**

1. Review the plan
2. Run `/dev.tasks specs/<feature-name>/plan.md` to generate TODO files
3. Or run `/dev.work specs/<feature-name>/plan.md` to execute directly
```

---

## Output Summary

After completing this workflow:

1. **Technical plan** at `specs/<feature-name>/plan.md`
2. **Constitution compliance** documented
3. **Implementation phases** with task breakdown
4. **Test strategy** including test-first tasks
5. **Review feedback** addressed

The plan feeds into `/dev.tasks` for TODO generation or `/dev.work` for direct execution.
