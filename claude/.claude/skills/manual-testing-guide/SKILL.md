---
name: manual-testing-guide
description: Generate a comprehensive manual testing guide for completed work, with note sections for user feedback that the agent reviews afterward. Use when the user wants to manually test changes before shipping.
---

# Manual Testing Guide

Generate a thorough manual testing guide for the work just completed. The guide is a markdown file the user fills out during testing, then hands back for review.

## Workflow

### Phase 1: Generate the Guide

1. **Analyze the changes** — run `git diff` (staged + unstaged) and review all modified/added files to understand exactly what changed.
2. **Identify test surfaces** — map changes to user-facing behavior, API endpoints, CLI commands, UI interactions, config changes, and side effects.
3. **Write the guide** — create `TESTING.md` in the repo root using the format below.

### Phase 2: Review the Notes

When the user says testing is done (or asks you to review), read `TESTING.md` and:

- Flag any test case marked `[x] FAIL` or with concerning notes.
- Suggest fixes or next steps for failures.
- Identify any gaps — test cases the user skipped or scenarios the notes reveal were missed.
- Summarize overall readiness: ship, fix-then-ship, or needs-more-work.

## Guide Format

```markdown
# Manual Testing Guide

**Changes**: (one-line summary of what was changed)
**Date**: YYYY-MM-DD
**Branch**: (branch name)

---

## Prerequisites

- (environment setup, seed data, config needed before testing)

---

## Test Cases

### 1. (Test case title)

**Category**: (Happy Path | Edge Case | Error Handling | Regression | Security | Performance)
**Priority**: (P0 — must pass | P1 — should pass | P2 — nice to verify)

**Steps**:
1. Step one
2. Step two
3. Step three

**Expected Result**: (what should happen)

**Result**: [ ] PASS  [ ] FAIL

**Notes**:
> (tester writes observations, screenshots, unexpected behavior here)

---

(repeat for each test case)

---

## Summary

**Overall Result**: [ ] PASS  [ ] FAIL
**Tested By**:
**General Notes**:
> (overall observations, concerns, or follow-ups)
```

## Test Case Coverage Rules

Generate test cases for **every** category that applies:

- **Happy Path** — the primary intended flow works correctly
- **Edge Cases** — boundary values, empty inputs, max lengths, special characters, concurrent usage
- **Error Handling** — invalid inputs, missing data, network failures, permission errors
- **Regression** — existing functionality that touches the same code still works
- **Security** — auth checks, input sanitization, privilege escalation (if applicable)
- **Performance** — large datasets, rapid repeated actions (if applicable)

Order test cases by priority (P0 first), then by category.

## Guidelines

- Be specific in steps — include exact inputs, URLs, commands, or clicks. Never say "test the feature."
- Expected results must be observable and verifiable, not vague ("it works").
- Keep the guide practical — 10-25 test cases is typical. Don't pad with trivial cases.
- If changes span multiple features, group test cases under feature subheadings.
- Include a Prerequisites section only if setup is actually needed.
- Write for someone who didn't make the changes — enough context to test without reading the code.
