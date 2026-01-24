---
name: code-review
description: Review uncommitted/unstaged changes against main/master branch for correctness, security, and best practices. Analyzes logic gaps, integration issues, and verifies changes work with existing code. Use when user wants to review their local changes before committing.
---

# Code Review

Review local changes against the main branch, focusing on best practices and security.

## Workflow

1. **Detect base branch**: Check for `main` or `master`
2. **Get the diff**: Compare working tree against base branch
3. **Analyze changes**: Review for issues below
4. **Report findings**: Provide actionable feedback with severity levels

## Commands to Run

```bash
# Detect base branch
git rev-parse --verify main 2>/dev/null && echo "main" || echo "master"

# Get staged changes
git diff --cached

# Get unstaged changes
git diff

# Get all uncommitted changes against base branch
git diff main...HEAD
git diff  # working tree changes

# View full context of changed files (to understand existing logic)
git diff --name-only | xargs -I {} cat {}
```

## Analysis Approach

1. **Understand the change**: What is the intent? What problem does it solve?
2. **Read surrounding code**: Understand the existing logic and patterns
3. **Trace the flow**: Follow how data moves through changed code
4. **Verify completeness**: Are all cases handled? All paths covered?
5. **Check integration**: Do changes work with existing code?

## Review Checklist

### Logic & Correctness (Critical)
- Off-by-one errors, boundary conditions
- Incorrect boolean logic or operator precedence
- Missing edge case handling (empty arrays, null, zero, negative)
- Broken control flow (unreachable code after return, missing break)
- Type mismatches or implicit conversions that change behavior
- Incorrect function signatures or return values
- Changes that break existing functionality
- Missing or incorrect initialization
- Infinite loops or recursion without base case

### Integration with Existing Code (Critical)
- Changes that conflict with existing patterns/architecture
- Missing updates to related code (callers, tests, docs)
- Breaking API contracts (changed signatures, removed exports)
- State management inconsistencies
- Missing database migrations or schema updates
- Incompatible dependency changes

### Security (Critical)
- Hardcoded secrets, API keys, passwords, tokens
- SQL injection vulnerabilities
- Command injection (unsanitized shell commands)
- Path traversal vulnerabilities
- Insecure deserialization
- Missing input validation/sanitization
- Insecure cryptographic practices
- Exposed sensitive data in logs or errors
- SSRF, XSS, CSRF vulnerabilities
- Insecure file permissions

### Best Practices (Warning)
- Error handling: proper error propagation, no swallowed errors
- Resource management: closed files/connections, no leaks
- Null/nil safety: defensive checks where needed
- Race conditions in concurrent code
- Code duplication that should be refactored
- Dead code or unreachable branches
- Missing or inadequate logging
- Overly broad exception catching

### Code Quality (Info)
- Naming clarity and consistency
- Function/method length (should be focused)
- Cyclomatic complexity
- Missing type annotations where expected
- Inconsistent formatting (defer to linter)

## Output Format

```
## Code Review Summary

### 🔴 Critical (Security/Logic/Integration)
- **[file:line]** Issue description
  - Why it matters
  - Suggested fix

### 🟡 Warning (Best Practices)
- **[file:line]** Issue description
  - Recommendation

### 🔵 Info (Code Quality)
- **[file:line]** Minor suggestion

### ✅ What Looks Good
- Brief positive observations

### 🧪 Suggested Tests
- Edge cases or scenarios to verify manually or with tests
```

## Guidelines

- Only flag real issues - avoid nitpicking style preferences
- Provide concrete fix suggestions, not vague advice
- Prioritize security issues above all else
- Consider the project's existing patterns and conventions
- If no issues found, say so clearly
