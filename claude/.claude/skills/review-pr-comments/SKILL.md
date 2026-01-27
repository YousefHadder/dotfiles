---
name: review-pr-comments
description: Review PR comments, validate which are actionable and correct, and propose fixes for valid ones. Use when user wants to address feedback on a pull request.
---

# Review PR Comments

Analyze PR review comments, determine validity, and propose fixes for valid feedback.

## Trigger

- `/review-pr-comments` or `/review-pr-comments <PR-URL-or-number>`
- "review the comments on PR 123"
- "address the feedback on this PR"

## Workflow

### 1. Fetch PR Context

```bash
# Get PR details
gh pr view <number> --repo <owner/repo> --json title,body,files

# Get commits to understand timeline
gh api repos/<owner>/<repo>/pulls/<number>/commits \
  --jq '.[] | {sha: .sha[0:7], message: .commit.message, date: .commit.author.date}'

# Get line-level review comments (includes commit SHA for context)
gh api repos/<owner>/<repo>/pulls/<number>/comments \
  --jq '.[] | {id, path, line, body, user: .user.login, commit_id: .commit_id[0:7], in_reply_to_id, created_at}'

# Get the diff for context
gh api repos/<owner>/<repo>/pulls/<number>/files --jq '.[] | {filename, patch}'
```

**Important**: Comments are made against a specific commit. If the PR has multiple commits, check if a comment was already addressed by a later commit before marking it valid/invalid.

### 2. Filter Comments

**Ignore:**
- Resolved comment threads (check `in_reply_to_id` chains for resolution)
- Comments already addressed by subsequent commits
- Approval-only comments ("LGTM", "Looks good", "Approved")
- Bot acknowledgments without actionable content
- Comments that are replies to other comments (focus on top-level)

**Keep:**
- Comments with code suggestions
- Comments requesting changes
- Comments pointing out bugs or issues

### 3. Validate Each Comment

For each remaining comment, determine validity by checking:

1. **Actionable**: Does it request a specific change? (not a question or observation)
2. **Applies to current code**: Is the code it references still present?
3. **Correct**: Is the feedback technically accurate?

Read the actual source files to verify correctness—don't trust the comment blindly.

### 4. Output Format

```markdown
## PR Comment Review: <PR title>

### ✅ Valid Comments

#### Comment by @username on `path/to/file.lua`
> [quoted comment]

**Assessment**: Valid - [brief reason]

**Proposed Fix**:
```diff
- old code
+ new code
```

---

### ❌ Invalid Comments

#### Comment by @username on `path/to/file.lua`
> [quoted comment]

**Assessment**: Invalid - [specific reason why it's wrong or doesn't apply]

---

### Summary
- Valid: X comments requiring changes
- Invalid: Y comments (no action needed)

**Ready to implement the valid fixes?**
```

### 5. Implementation

After user confirms:
- Apply fixes one at a time
- Show diff for each change
- Run tests if available (`make check`, `npm test`, etc.)

## Validation Checklist

Before marking a comment as valid:
- [ ] Read the actual source code, not just the diff
- [ ] Understand the context (what does the surrounding code do?)
- [ ] Check if the suggestion introduces bugs
- [ ] Verify the comment isn't based on a misreading

## Common Invalid Comment Patterns

- Suggesting changes that are already implemented (misread the code)
- Requesting abstractions that add complexity without benefit
- Style preferences not matching project conventions
- Duplicating existing functionality
