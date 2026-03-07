# Coding Style

## Immutability (CRITICAL)

ALWAYS create new objects, NEVER mutate existing ones:

```
// Pseudocode
WRONG:  modify(original, field, value) -> changes original in-place
CORRECT: update(original, field, value) -> returns new copy with change
```

Rationale: Immutable data prevents hidden side effects, makes debugging easier, and enables safe concurrency.

## KISS Principle

- Avoid over-engineering - simplest solution that works
- Use idiomatic patterns for each language (Go error handling, Ruby blocks, etc.)
- Prefer pragmatic solutions over theoretical purity
- Write clean, readable code with clear intent

## File Organization

MANY SMALL FILES > FEW LARGE FILES:
- High cohesion, low coupling
- 200-400 lines typical, 800 max
- Extract utilities from large modules
- Organize by feature/domain, not by type

## Error Handling

ALWAYS handle errors comprehensively:
- Handle errors explicitly at every level
- Provide user-friendly error messages in UI-facing code
- Log detailed error context on the server side
- Never silently swallow errors

## Input Validation

ALWAYS validate at system boundaries:
- Validate all user input before processing
- Use schema-based validation where available
- Fail fast with clear error messages
- Never trust external data (API responses, user input, file content)

## Code Quality Checklist

Before marking work complete:
- [ ] Code is readable and well-named
- [ ] Functions are small (<50 lines)
- [ ] Files are focused (<800 lines)
- [ ] No deep nesting (>4 levels)
- [ ] Proper error handling
- [ ] No mutation (immutable patterns used)

## Antipatterns (NEVER DO)

- Stub implementations without raising NotImplementedError or equivalent
- Unconditional test skips or `assert True` / `assert.ok(true)`
- Mass lint suppressions (noqa, eslint-disable, luacheck: ignore) to hide issues
- Lowering coverage/quality thresholds to make CI pass
- Adding to safe-lists or whitelists just to bypass checks
- Claiming "it works" without running the actual tests
