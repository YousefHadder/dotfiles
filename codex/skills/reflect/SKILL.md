---
name: reflect
description: Synthesize diary entries from ~/.codex/memory/diary into ~/.codex/memory/REFLECTIONS.md. Use when the user asks to reflect on sessions, summarize learnings, or consolidate diary entries.
---

# Reflect

Synthesize diary entries into persistent learnings in `~/.codex/memory/REFLECTIONS.md`.

## Purpose

Periodically consolidate diary entries from `~/.codex/memory/diary/` into `~/.codex/memory/REFLECTIONS.md` - a living document of cross-session learnings that future Codex instances can reference.

## Process

### 1. Read Recent Diary Entries
- Scan `~/.codex/memory/diary/` for entries since last reflection
- Identify recurring patterns, decisions, and learnings

### 2. Synthesize Themes
Group findings into categories:
- **Project Patterns**: Per-project conventions and gotchas
- **User Preferences**: Communication style, tool preferences, workflow
- **Technical Learnings**: Effective approaches, common pitfalls
- **Process Improvements**: What works well in collaboration

### 3. Update REFLECTIONS.md
Add new insights while preserving existing content. Don't duplicate - merge similar learnings.

## REFLECTIONS.md Format

```markdown
# Codex Session Reflections
*Synthesized learnings from session diaries*

**Last Updated**: YYYY-MM-DD

## User Preferences
- [Preference]: [Context/example]

## Project-Specific Knowledge

### [Project Name]
- **Conventions**: [patterns to follow]
- **Gotchas**: [things to watch out for]
- **Preferences**: [project-specific user preferences]

## Technical Patterns

### [Language/Framework]
- [Effective pattern]: [when/why to use]

## Collaboration Insights
- [What works well in this working relationship]

## Common Pitfalls to Avoid
- [Mistake made]: [lesson learned]

---
*Entries synthesized from: [list of diary files processed]*
```

## When to Reflect

Run this skill when:
- Multiple diary entries have accumulated (5+)
- Starting a new major project (capture prior learnings)
- User requests synthesis
- Significant time has passed since last reflection

## Guidelines

- **Consolidate, don't duplicate** - Merge similar insights
- **Keep it scannable** - Future instances need quick context
- **Preserve specifics** - Project names, concrete examples
- **Date entries** - Know when learnings were captured
- **Archive processed diaries** - Move to `diary/archived/` after synthesis

## Setup Notes

- Create `~/.codex/memory/diary/` if it does not exist.
- Create `~/.codex/memory/REFLECTIONS.md` if it does not exist.
