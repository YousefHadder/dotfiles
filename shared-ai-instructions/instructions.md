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

## Error Handling (Language-Specific)
- Go: Explicit error returns with proper wrapping
- Ruby: Exceptions where idiomatic, early returns otherwise
- JS/TS: Async/await with try-catch, or Result patterns when appropriate
- Lua: Return nil/error tuples, pcall for recoverable errors
- Bash: set -euo pipefail, explicit error checking
