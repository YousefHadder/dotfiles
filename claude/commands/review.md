Perform a thorough code review like a senior engineer.

## Review Checklist

### 🔴 Critical (Blockers)
- [ ] **Security vulnerabilities** - injection, auth bypass, data exposure
- [ ] **Bugs** - logic errors, race conditions, null derefs
- [ ] **Data loss risks** - destructive operations, missing validation

### 🟠 Important
- [ ] **Error handling** - are errors caught and handled appropriately?
- [ ] **Edge cases** - what happens with empty/null/invalid input?
- [ ] **Performance** - N+1 queries, unnecessary allocations, blocking calls
- [ ] **Testing** - are there tests? Do they cover the changes?

### 🟡 Suggestions
- [ ] **Code clarity** - is it easy to understand?
- [ ] **Naming** - do names convey intent?
- [ ] **DRY** - is there duplication that should be extracted?
- [ ] **Idioms** - does it follow language conventions?
- [ ] **Documentation** - are complex parts explained?

### 🔵 Nits (Optional)
- [ ] Style consistency
- [ ] Minor optimizations
- [ ] Formatting

## Review Output

For each item:
```
[🔴/🟠/🟡/🔵] **Category**: Brief title
📍 Location: file:line (or code snippet)
💬 Comment: Explanation of the issue
✅ Suggestion: How to fix it (with code if helpful)
```

## Tone
- Be constructive and specific
- Explain the "why" behind feedback
- Acknowledge good patterns when you see them
- Prioritize - focus on what matters most
