Capture the current session to a diary entry for cross-session continuity.

## Purpose

Claude doesn't persist between sessions. This skill creates diary entries that future Claude instances can reference to understand context, decisions, and learnings.

## What to Capture

Create a diary entry in `~/.claude/memory/diary/` with filename `YYYY-MM-DD-HH-MM-topic.md`:

### 1. Session Context
- What project/task was being worked on
- Starting state and goals

### 2. Decisions Made
- Key choices and their rationale
- Trade-offs considered
- Why alternatives were rejected

### 3. Patterns Learned
- Project-specific conventions discovered
- User preferences observed
- Effective approaches that worked

### 4. Problems Solved
- Issues encountered and how they were resolved
- Gotchas to remember
- Workarounds applied

### 5. Unfinished Business
- What's left to do
- Blockers or open questions
- Recommended next steps

### 6. User Preferences Observed
- Communication style preferences
- Tool preferences
- Workflow patterns

## Diary Entry Format

```markdown
# Session Diary: [Brief Topic]
**Date**: YYYY-MM-DD HH:MM
**Project**: [project name or path]

## Context
[What we were working on and why]

## Key Decisions
- [Decision]: [Rationale]

## Learnings
- [Pattern or insight discovered]

## Problems & Solutions
- **Problem**: [description]
  **Solution**: [what worked]

## Unfinished
- [ ] [Remaining task]

## User Preferences
- [Observed preference]
```

## When to Offer Diary Capture

Proactively suggest capturing when:
- Task completion (natural stopping point)
- Substantive multi-step work completed
- User expresses gratitude ("Thanks!", "Perfect!")
- Important architecture decisions made
- Problem solved after significant effort
- Before context gets too long (preserve before compaction)
