---
description: Create a feature specification (WHAT/WHY)
argument-hint: "[feature description]"
---

# Feature Specification Workflow

Create a specification document that defines WHAT we're building and WHY.

## Feature Request

**Feature:** $ARGUMENTS

---

## Overview

This command creates a specification document through:

1. **Initial Scoping** - Quick context gathering
2. **Research Phase** - Parallel agents explore the codebase
3. **Deep Interview** - Informed questions to surface requirements
4. **Synthesis** - Compile into specification document

**Output:** `specs/<feature-name>/spec.md`

---

## Scaling to Feature Size

Adapt the process to the scope:

- **Small features** (well-defined, few files): Light research, brief interview, simple spec
- **Medium features** (moderate complexity): Full process as described
- **Large features** (architectural impact): Extended research, deeper interviews, comprehensive spec

---

## Step 1: Initial Scoping

Gather just enough context to guide research. Ask via `AskUserQuestion`:

1. **What problem does this solve?** (the "why")
2. **Who is the primary user/stakeholder?**
3. **Any known constraints or preferences?**

Keep this brief - deeper questions come after research.

---

## Step 2: Research Phase

Launch research agents **in parallel** to gather codebase context:

### Always Launch

```
pattern-recognition-specialist:
"Find existing patterns for [feature type].
Look for: similar implementations, related services, relevant models.
Document conventions and patterns to follow."

architecture-strategist:
"Analyze architectural implications of [feature].
Consider: data flow, API design, component boundaries.
Identify integration points and potential conflicts."

Explore agent:
"Explore the codebase for [relevant area].
Find: related files, existing functionality, dependencies."
```

### Conditionally Launch

- `best-practices-researcher` - If involving new patterns or technologies
- `framework-docs-researcher` - If involving specific framework features

---

## Step 3: Deep Interview Phase

Now that you have codebase context, conduct an in-depth interview using `AskUserQuestion`.

### Interview Principles

- **Ask non-obvious questions** - Skip basic questions (we know the stack). Dig into nuance.
- **Be informed by research** - Reference specific patterns, services, or decisions you discovered.
- **Probe edge cases** - "What happens when X fails?" "How should this behave if Y is empty?"
- **Explore tradeoffs** - "Would you prefer A (simpler) or B (more flexible)?"
- **Surface concerns** - "What worries you most?" "What could go wrong?"
- **Challenge assumptions** - Push back on scope creep or unclear requirements

### Dimensions to Cover

- Technical implementation details
- UI/UX considerations (if applicable)
- Data model and storage
- Error handling and failure modes
- Security and authorization
- Performance implications
- Migration and backwards compatibility

### Interview Guidelines

- **Depth over speed** - Fully understand before moving on
- **Flexible batching** - Multiple related questions together, or one-at-a-time for complex topics
- **Adaptive length** - Continue until you have clarity
- **Build on answers** - Use responses to inform follow-ups
- **Flag uncertainties** - Note unresolved items with `[NEEDS CLARIFICATION]`

### Example Questions (Informed by Research)

After finding `ExactDeduplicationService`:

> "The existing dedup service uses hash-based matching. Should this follow that pattern, or does your use case need fuzzy matching?"

After discovering a similar feature:

> "There's already a webhook notification system. Should this integrate with that, extend it, or be separate?"

After identifying an architectural boundary:

> "This could live in platform (closer to user data) or engine (closer to operations). What's the access pattern here?"

### Red Flags to Watch For

- **Scope creep** - Requirements keep expanding
- **Conflicting goals** - X and Y are mutually exclusive
- **Solving wrong problem** - Solution doesn't address root cause
- **Over-engineering** - Complex solution for simple problem
- **Missing prerequisites** - Depends on things that don't exist
- **Unclear ownership** - Nobody knows where this belongs
- **Bundled unrelated work** - Feature plus unrelated refactor

**When you spot red flags:**

1. Name it directly - "I'm noticing scope keeps growing. Should we define an MVP?"
2. Offer alternatives - "What if we did Y instead, which is simpler?"
3. Suggest phasing - "This feels like two features. Could we do A first?"
4. Question the premise - "Would users actually use this?"
5. Separate unrelated work - "This includes X and Y which should be separate. Create a TODO for Y?"

---

## Step 4: Synthesize Specification

Compile everything into a specification document.

### Create Spec Directory

```bash
feature_name="[kebab-case-feature-name]"
mkdir -p "specs/$feature_name"
```

### Fill Specification Template

Use the template at `~/.claude/templates/spec-template.md`:

1. **Problem Statement** - From interview (the "why")
2. **User Stories** - With Given/When/Then acceptance scenarios
3. **Functional Requirements** - FR-001, FR-002... with `[NEEDS CLARIFICATION]` markers
4. **Success Criteria** - SC-001, SC-002... with measurable outcomes
5. **Edge Cases** - From interview probing
6. **Out of Scope** - Explicitly excluded items
7. **Open Questions** - Unresolved items
8. **Research Findings** - Patterns, files, architecture notes

### Constitution Advisory Check

Before saving, check against `~/.claude/constitution.md`:

| Article             | Check                                         |
| ------------------- | --------------------------------------------- |
| Test-First          | N/A (handled in planning)                     |
| Measurable Outcomes | At least one SC-xxx defined?                  |
| Simplicity          | Scope reasonable? No over-engineering?        |
| Clarification       | Uncertainties marked `[NEEDS CLARIFICATION]`? |
| Interview-Driven    | Research + interview completed?               |

Warn about any violations but don't block.

---

## Step 5: Save and Present

1. **Save specification** to `specs/<feature-name>/spec.md`

2. **Present summary** to user:

```markdown
## Specification Complete

**Saved to:** `specs/<feature-name>/spec.md`

### Summary

[1-2 sentence summary of the feature]

### Key User Stories

- US-1: [title]
- US-2: [title]

### Success Criteria

- SC-001: [metric]
- SC-002: [metric]

### Constitution Check

[Any advisory warnings]

### Open Questions

- [Any unresolved items]

---

**Next Steps:**

1. Review the specification
2. Run `/dev.plan specs/<feature-name>/spec.md` to create technical plan
```

---

## Output Summary

After completing this workflow:

1. **Specification document** at `specs/<feature-name>/spec.md`
2. **User stories** with acceptance scenarios
3. **Success criteria** with measurable outcomes
4. **Research findings** documented
5. **Open questions** flagged

The specification feeds into `/dev.plan` for technical planning.
