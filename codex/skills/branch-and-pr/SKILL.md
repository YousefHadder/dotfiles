---
name: branch-and-pr
description: Create a branch from unstaged changes, commit with conventional message, and open a PR. Use when user wants to quickly ship current work.
---

# Branch and PR

Create a new branch, commit current changes, and open a pull request in one workflow.

## Workflow

1. **Analyze changes**: Run `git status` and `git diff` to understand what changed
2. **Generate branch name**: Format `{username}/{type}-{short-description}`
   - Get username from `git config user.name` (lowercase, no spaces)
   - Type: feat, fix, refactor, docs, test, chore, perf, style
   - Description: 2-4 words, kebab-case, derived from changes
3. **Create branch**: `git checkout -b {branch-name}`
4. **Stage and commit**:
   - Stage all changes: `git add -A`
   - Commit with conventional message: `{type}: {description}` (max 72 chars)
5. **Pause for confirmation**: Show the user what will be pushed
6. **On confirmation**: Push and create PR via `gh pr create`

## Commit Message Style

- Conventional format: `type: lowercase description`
- No period at end
- Imperative mood ("add" not "adds" or "added")
- Max 72 characters
- Examples:
  - `fix: handle null user in auth middleware`
  - `feat: add dark mode toggle to settings`
  - `refactor: extract validation logic to helper`

## PR Description Style

Write like a human developer, not an AI:

- **Title**: Same as commit message or slightly expanded
- **Body structure**:
  ```
  Brief 1-2 sentence summary of what this does.

  - Bullet points for specific changes if needed
  - Keep it scannable

  Tested by [how you verified it works]
  ```

Avoid:
- "This PR introduces..." / "This commit adds..."
- Overly formal language
- Excessive bullet points
- Explaining obvious things
- Words like "comprehensive", "robust", "enhance"

Good examples:
- "Fixes the crash when user logs out during sync"
- "Adds retry logic for flaky API calls - was causing random failures in prod"
- "Cleans up the auth module, no behavior changes"

## Confirmation Prompt

Before pushing, show:
```
Branch: {branch-name}
Commit: {commit-message}

Changes to be pushed:
{file list}

Ready to push and create PR? (y/n)
```

Wait for explicit user confirmation before proceeding.
