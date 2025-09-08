# Global Claude Code Instructions

## Preferred Tools

Always use these modern alternatives instead of traditional Unix tools:

- Use `fd` instead of `find` for file searching
- Use `ripgrep` (rg) instead of `grep` for text searching
- Use `zoxide` instead of `cd` for directory navigation
- Use `bat` instead of `cat` for file viewing when syntax highlighting is beneficial

## Tool Usage Guidelines

### File Search
```bash
# Use fd for finding files by name/pattern
fd "pattern" /path/to/search

# Use ripgrep for searching file contents
rg "search_term" /path/to/search
```

### Directory Navigation
```bash
# Use zoxide for smart directory jumping
z directory_name

# Add directories to zoxide database
z /full/path/to/directory
```

### File Operations
- Prefer modern tools that provide better output formatting and performance
- Always check if these tools are available before falling back to traditional alternatives
- When tools aren't available, use traditional alternatives but mention the preferred tool

## Additional Instructions

Add any other global preferences or coding standards here as needed.
