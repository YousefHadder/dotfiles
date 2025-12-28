Help systematically debug the issue at hand.

## Debugging Process

### 1. Understand the Problem
- What is the expected behavior?
- What is the actual behavior?
- When did it start happening?
- What changed recently?

### 2. Gather Information
- Analyze error messages and stack traces in detail
- Identify the code path involved
- Check for relevant logs or output

### 3. Form Hypotheses
List the most likely causes ranked by probability:
1. Most likely cause and why
2. Second most likely...
3. etc.

### 4. Investigation Steps
Provide specific debugging steps:
- Strategic print/log statement locations
- Breakpoint suggestions for the debugger
- Commands to run for more information
- State to inspect

### 5. Common Gotchas
Check for language/framework-specific issues:
- Go: nil pointer, goroutine races, defer gotchas
- Ruby: nil vs false, symbol/string confusion
- JS/TS: async/await issues, this binding, type coercion
- Lua: 1-indexed arrays, nil in tables, global leaks
- Bash: word splitting, glob expansion, exit codes

### 6. Proposed Fixes
Once root cause is identified, provide a fix with explanation of why it works.

Be thorough and methodical. Don't jump to conclusions.
