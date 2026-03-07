# Testing Requirements

## Minimum Test Coverage: 80%

Test Types (ALL required):
1. **Unit Tests** - Individual functions, utilities, components
2. **Integration Tests** - API endpoints, database operations
3. **E2E Tests** - Critical user flows (framework chosen per language)

## Test-Driven Development

MANDATORY workflow:
1. Write test first (RED)
2. Run test - it should FAIL
3. Write minimal implementation (GREEN)
4. Run test - it should PASS
5. Refactor (IMPROVE)
6. Verify coverage (80%+)

## Troubleshooting Test Failures

1. Check test isolation
2. Verify mocks are correct
3. Fix implementation, not tests (unless tests are wrong)
4. Run tests individually to identify the failing case

## Testing Antipatterns (NEVER DO)

- Unconditional test skips without justification
- `assert True` / `assert.ok(true)` as placeholder assertions
- Tests that pass regardless of implementation correctness
- Modifying tests solely to make them pass (fix the code instead)
- Lowering coverage thresholds to satisfy CI

See `agents.md` for available testing agents.
