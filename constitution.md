# Constitution

Global principles that guide all `/dev.*` commands. These are **advisory** - commands check and warn about violations but don't block progress.

---

## Article I: Test-First Development

Tests SHOULD be written before implementation code.

**Acceptance:** Tests exist and fail before implementation begins.

**Guidance:**

- Write test cases that define expected behavior
- Confirm tests fail (proving they test something real)
- Then implement code to make tests pass
- Applies to new features and bug fixes

---

## Article II: Measurable Outcomes

Features SHOULD have quantifiable success criteria.

**Acceptance:** At least one SC-xxx metric defined in the specification.

**Guidance:**

- Define how success will be measured
- Include specific, observable metrics where possible
- Examples: response time < 200ms, error rate < 1%, user can complete task in < 3 clicks

---

## Article III: Simplicity

Prefer the simplest solution that meets requirements.

**Acceptance:** No unnecessary abstractions, future-proofing, or over-engineering.

**Guidance:**

- Solve the current problem, not hypothetical future problems
- Avoid premature abstraction - three similar things can coexist
- Don't add configurability unless explicitly required
- If in doubt, choose the approach with fewer moving parts

---

## Article IV: Clarification Over Assumption

When requirements are unclear, mark with `[NEEDS CLARIFICATION]` and ask.

**Acceptance:** No implementation decisions made on uncertain requirements.

**Guidance:**

- If you're unsure what the user wants, ask
- Mark unclear sections explicitly in specs and plans
- Don't fill in gaps with assumptions
- It's better to ask a "dumb" question than build the wrong thing

---

## Article V: Interview-Driven Discovery

Research the codebase before interviewing. Interview deeply before specifying.

**Acceptance:** Specifications informed by both codebase research and user interviews.

**Guidance:**

- Explore existing patterns and architecture first
- Use research findings to ask informed questions
- Probe for edge cases, tradeoffs, and concerns
- Don't rush to solutions - understand the problem space

---

## Article VI: Security by Design

Security considerations SHOULD be addressed during design, not retrofitted.

**Acceptance:** Security implications documented; sensitive operations protected.

**Guidance:**

- Consider authorization and data access patterns early
- Never commit secrets or credentials
- Validate inputs at trust boundaries
- Think about data isolation in multi-tenant contexts
- Document security assumptions and requirements in specs
