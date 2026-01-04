---
feature: [feature-name]
spec: specs/[feature-name]/spec.md
created: [DATE]
status: draft
---

# Technical Plan: [Title]

## Constitution Check

| Article             | Status | Notes                            |
| ------------------- | ------ | -------------------------------- |
| Test-First          | [ ]    | [Tests planned before impl?]     |
| Measurable Outcomes | [ ]    | [SC-xxx metrics defined?]        |
| Simplicity          | [ ]    | [Simplest approach chosen?]      |
| Clarification       | [ ]    | [No unresolved questions?]       |
| Interview-Driven    | [ ]    | [Research + interview complete?] |
| Security by Design  | [ ]    | [Security implications covered?] |

---

## Summary

[Technical approach in 2-3 sentences. What are we building and how?]

---

## Technical Context

- **Language/Framework:** [e.g., Python 3.11, FastAPI]
- **Key Dependencies:** [relevant libraries or services]
- **Affected Areas:** [list of system components touched]
- **Database Changes:** [Yes/No - describe if yes]

---

## Architecture

[How this fits into the system. Include data flow if relevant.]

```
[Optional: ASCII diagram or description of component interactions]
```

---

## Implementation Phases

### Phase 1: [Name - e.g., Foundation]

- [ ] Task 1 (test-first)
- [ ] Task 2

### Phase 2: [Name - e.g., Core Feature]

- [ ] Task 3 [P]
- [ ] Task 4 [P]

### Phase 3: [Name - e.g., Polish]

- [ ] Task 5

**Legend:**

- `(test-first)` - Write tests before implementation
- `[P]` - Parallelizable with other [P] tasks in same phase

---

## Test Strategy

### Test-First Tasks

Tasks that require failing tests before implementation:

1. [Task from phases above]
2. [Task from phases above]

### Unit Tests

- [What to test at unit level]

### Integration Tests

- [What to test at integration level]

---

## Files to Modify

| File                  | Changes            |
| --------------------- | ------------------ |
| `path/to/file.py`     | [What changes]     |
| `path/to/another.tsx` | [What changes]     |
| `path/to/new.py`      | [Create - purpose] |

---

## API Changes

[If applicable - new endpoints, changed signatures, etc.]

```
[Method] /path/to/endpoint
Request: { ... }
Response: { ... }
```

---

## Database Changes

[If applicable - new tables, migrations, etc.]

```sql
-- Migration description
```

---

## Security Considerations

| Concern          | Assessment              | Mitigation                 |
| ---------------- | ----------------------- | -------------------------- |
| Authentication   | [Changes required?]     | [Approach]                 |
| Authorization    | [Permission changes?]   | [Approach]                 |
| Input Validation | [User input processed?] | [Validation strategy]      |
| Data Access      | [Isolation risk?]       | [Scoping/isolation method] |

---

## Risks & Mitigations

| Risk        | Likelihood | Impact | Mitigation       |
| ----------- | ---------- | ------ | ---------------- |
| [Risk desc] | Low/Med/Hi | Low/Hi | [How to address] |

---

## Rollout Plan

- **Feature Flags:** [If applicable - flag name and rollout strategy]
- **Migration Strategy:** [If applicable - data migration approach]
- **Monitoring:** [Key metrics to watch post-deployment]
- **Rollback Plan:** [How to revert if issues arise]

---

## Open Questions

Resolved during planning but worth noting:

- [Question] → [Resolution]

Still open:

- [NEEDS CLARIFICATION] [Question]
