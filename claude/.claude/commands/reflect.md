Synthesize diary entries into persistent learnings in REFLECTIONS.md.

## Purpose

Periodically consolidate diary entries from `~/.claude/memory/diary/` into `~/.claude/memory/REFLECTIONS.md` - a living document of cross-session learnings that future Claude instances can reference.

## Process

### 1. Read Recent Diary Entries
- Scan `~/.claude/memory/diary/` for entries since last reflection
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
# Claude Session Reflections
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

Run `/user:reflect` when:
- Multiple diary entries have accumulated (5+)
- Starting a new major project (capture prior learnings)
- User requests synthesis
- Significant time has passed since last reflection

## Guidelines

- **Consolidate, don't duplicate** - Merge similar insights
- **Keep it scannable** - Future Claudes need quick context
- **Preserve specifics** - Project names, concrete examples
- **Date entries** - Know when learnings were captured
- **Archive processed diaries** - Move to `diary/archived/` after synthesis
