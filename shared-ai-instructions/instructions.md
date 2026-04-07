# Global AI Assistant Instructions

> Coding standards, testing, security, git workflow, patterns, verification,
> documentation, and agent orchestration are defined in `~/.claude/rules/`.
> This file covers only interaction preferences and behavioral guidance
> that are not covered by those rule files.

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

## Write Operations — Approval Required

- **Never** post PR reviews, edit issues, create issues, update comments, or make any GitHub write operation without explicit user approval
- When asked to review a PR: present the review content in the conversation and wait for the user to say "post it" before submitting
- When asked to write/update an issue: draft it in the conversation first and wait for approval
- If the user says "write", "update", "create", or "post", always confirm the target and content before executing
- Read operations (fetching PRs, issues, code) do not require approval

## Shell Commands

- Never use nested command substitution in bash — `$(...)` inside quoted arguments gets blocked by the shell security guard
- Instead of: `curl -H "Authorization: Bearer $(printenv TOKEN)" url`
- Use: `TOKEN=$(printenv TOKEN) && curl -H "Authorization: Bearer $TOKEN" url`
- Instead of: `echo "result: $([ -n "$VAR" ] && echo yes || echo no)"`
- Use: `if [ -n "$VAR" ]; then echo "result: yes"; else echo "result: no"; fi`
- General rule: capture command output into a variable first, then reference it with `$VAR`

## Error Handling (Language-Specific)

- Go: Explicit error returns with proper wrapping
- Ruby: Exceptions where idiomatic, early returns otherwise
- JS/TS: Async/await with try-catch, or Result patterns when appropriate
- Lua: Return nil/error tuples, pcall for recoverable errors
- Bash: set -euo pipefail, explicit error checking

## Git

- Do not include a Co-authored-by trailer for Copilot or Claude code in git commits
