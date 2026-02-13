---
name: read-issue
description: Read a GitHub issue with all comments and linked content to add as working context. Use when the user provides a GitHub issue URL or reference.
---

# Read Issue

Fetch a GitHub issue and all related content to build full context for a task.

## Input

The user provides a GitHub issue reference in one of these forms:
- Full URL: `https://github.com/owner/repo/issues/123`
- Short ref with repo context: `owner/repo#123`
- Number only (requires repo context from cwd): `#123`

## Execution

### Step 1: Fetch the Issue

Extract owner, repo, and issue number from the input. Use `gh` to fetch the issue:

```bash
gh issue view <number> --repo <owner/repo> --json title,body,state,labels,assignees,milestone,createdAt,author,url
```

### Step 2: Fetch All Comments

```bash
gh api repos/<owner>/<repo>/issues/<number>/comments --paginate
```

Extract each comment's `user.login`, `created_at`, and `body`.

### Step 3: Collect All Links

Scan the issue body and all comment bodies for:

1. **GitHub issue/PR URLs**: `https://github.com/<owner>/<repo>/issues/<n>` or `/pull/<n>`
2. **GitHub short refs**: `#<n>` or `<owner>/<repo>#<n>`
3. **External URLs**: any other `https://` links (docs, wikis, designs, etc.)

Deduplicate the collected links.

### Step 4: Fetch Linked GitHub Issues/PRs

For each linked GitHub issue or PR, fetch a summary:

```bash
gh issue view <number> --repo <owner/repo> --json title,body,state,labels,url
gh pr view <number> --repo <owner/repo> --json title,body,state,url,files
```

Keep these summaries concise — title, state, and body are the priority.

### Step 5: Fetch External Links

Use `WebFetch` to retrieve content from non-GitHub URLs. Extract the key information relevant to the issue context. Skip URLs that are:
- Image/video links (`.png`, `.jpg`, `.gif`, `.mp4`, etc.)
- CI/CD build links (unless the issue is about a build failure)
- Bot-generated URLs that are unlikely to contain useful context

### Step 6: Present Context

Output everything as a structured context summary:

```
## Issue: <title> (<state>)
**URL**: <url>
**Author**: <author> | **Created**: <date>
**Labels**: <labels> | **Milestone**: <milestone>

### Description
<body>

### Comments (<count>)
**<user>** (<date>):
<comment body>

---

### Linked Issues/PRs
#### <title> (<state>) — <url>
<body summary>

---

### External References
#### <url>
<fetched content summary>
```

## Guidelines

- Always use `gh` CLI — never construct API URLs for raw `curl` calls
- Paginate comments with `--paginate` to ensure none are missed
- When following links, cap at **10 linked items** to avoid context explosion. If more exist, list the remaining URLs without fetching
- For linked issues/PRs, include the body but truncate if over ~200 lines
- For external links, summarize the relevant content rather than dumping the full page
- If `gh` auth fails or a repo is inaccessible, report it clearly and continue with what's available
- Do NOT attempt to follow links recursively (links within linked issues) — one level deep only
