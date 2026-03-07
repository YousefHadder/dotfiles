# Global AI Assistant Instructions

## About Me
- Primary languages: Lua, Ruby, Go, JavaScript/TypeScript, Bash
- Environment: Neovim + terminal-focused workflow
- Approach: Pragmatic - use whatever fits the problem best

## Response Style
- Be detailed and thorough in explanations
- Always explain the "why" behind changes and decisions
- Share tips and better approaches when relevant (but don't overdo it)
- Never be vague - provide concrete, actionable information

## Code Changes
- Make changes directly, then explain what was done and why
- Follow existing conventions and patterns in the codebase - never ignore them
- If you notice unrelated issues, suggest them but don't apply without asking
- Always flag security concerns prominently - this is high priority

## Coding Standards
- Use idiomatic patterns for each language (Go error handling, Ruby blocks, etc.)
- Prefer pragmatic solutions over theoretical purity
- Avoid over-engineering - KISS principle when reasonable
- Write clean, readable code with clear intent

### Immutability (CRITICAL)

ALWAYS create new objects, NEVER mutate existing ones:

```
// Pseudocode
WRONG:  modify(original, field, value) -> changes original in-place
CORRECT: update(original, field, value) -> returns new copy with change
```

Rationale: Immutable data prevents hidden side effects, makes debugging easier, and enables safe concurrency.

### File Organization

MANY SMALL FILES > FEW LARGE FILES:
- High cohesion, low coupling
- 200-400 lines typical, 800 max
- Functions should be small (<50 lines)
- No deep nesting (>4 levels)
- Extract utilities from large modules
- Organize by feature/domain, not by type

### Input Validation

ALWAYS validate at system boundaries:
- Validate all user input before processing
- Use schema-based validation where available
- Fail fast with clear error messages
- Never trust external data (API responses, user input, file content)

## Error Handling
- Go: Explicit error returns with proper wrapping
- Ruby: Exceptions where idiomatic, early returns otherwise
- JS/TS: Async/await with try-catch, or Result patterns when appropriate
- Lua: Return nil/error tuples, pcall for recoverable errors
- Bash: set -euo pipefail, explicit error checking
- ALWAYS handle errors comprehensively - never silently swallow them
- Provide user-friendly error messages in UI-facing code
- Log detailed error context on the server side

## Testing
- I follow TDD - write tests first when possible
- Generate comprehensive test cases covering edge cases
- Use the testing framework idiomatic to the language/project
- Minimum test coverage: 80%
- Test types (ALL required): Unit tests, Integration tests, E2E tests

### TDD Workflow (MANDATORY)
1. Write test first (RED)
2. Run test - it should FAIL
3. Write minimal implementation (GREEN)
4. Run test - it should PASS
5. Refactor (IMPROVE)
6. Verify coverage (80%+)

## Security
- No hardcoded secrets (API keys, passwords, tokens) - use environment variables or a secret manager
- All user inputs validated
- SQL injection prevention (parameterized queries)
- XSS prevention (sanitized HTML)
- CSRF protection enabled
- Authentication/authorization verified
- Rate limiting on all endpoints
- Error messages don't leak sensitive data
- Rotate any secrets that may have been exposed

## Design Patterns

### Repository Pattern
Encapsulate data access behind a consistent interface:
- Define standard operations: findAll, findById, create, update, delete
- Concrete implementations handle storage details (database, API, file, etc.)
- Business logic depends on the abstract interface, not the storage mechanism
- Enables easy swapping of data sources and simplifies testing with mocks

### API Response Format
Use a consistent envelope for all API responses:
- Include a success/status indicator
- Include the data payload (nullable on error)
- Include an error message field (nullable on success)
- Include metadata for paginated responses (total, page, limit)

## Verification Protocol
- NEVER claim "done" without showing actual command output as proof
- Claims require evidence - paste the validation/test output
- If tests were modified, explicitly state WHY
- One in-progress task at a time - complete current before starting next
- Run validation after EVERY code change before claiming success

## Antipatterns (NEVER DO)
- Stub implementations without raising NotImplementedError or equivalent
- Unconditional test skips or `assert True` / `assert.ok(true)`
- Mass lint suppressions (noqa, eslint-disable, luacheck: ignore) to hide issues
- Lowering coverage/quality thresholds to make CI pass
- Adding to safe-lists or whitelists just to bypass checks
- Claiming "it works" without running the actual tests

## Documentation
- Provide doc comments for public APIs and exported functions
- Prefer external documentation (README, docs/) for concepts
- Comments should explain "why", not "what"

## Git & Commits
- Use Conventional Commits format: type(scope): description
- Types: feat, fix, docs, style, refactor, test, chore, perf, ci
- Keep commits atomic and focused
- NEVER add "Co-Authored-By", "Generated by AI", or any AI attribution to commits, PRs, or issues

## Preferred CLI Tools
- Use `fd` instead of `find` for file searching
- Use `ripgrep` (rg) instead of `grep` for text searching
- Use `bat` instead of `cat` when syntax highlighting helps
- Use `zoxide` for smart directory navigation

## Things to Avoid
- Vague or hand-wavy responses
- Making changes without explaining the impact
- Ignoring existing code conventions in the project
- Over-engineering simple problems
- Skipping security considerations

## Agent Model Selection
When spawning subagents:
- **Haiku** for: file discovery, pattern matching, keyword searching, structure mapping, code smell detection
- **Sonnet** for: most implementation tasks, bug fixing, code generation
- **Opus** for: security audits, architectural decisions, complex debugging, safety-critical code
- Auto-escalate if a lighter model returns uncertainty or insufficient results
