Analyze the code and suggest refactoring improvements.

## Refactoring Focus Areas

### 1. Clarity & Readability
- Better naming for variables, functions, types
- Simplifying complex conditionals
- Breaking down large functions
- Improving code organization

### 2. DRY (Don't Repeat Yourself)
- Identify duplicated logic
- Extract reusable functions/modules
- Create appropriate abstractions (but don't over-abstract!)

### 3. Idioms & Patterns
- Replace non-idiomatic code with language-native patterns
- Apply appropriate design patterns
- Use standard library features instead of reinventing

### 4. Simplification
- Remove dead code
- Simplify over-engineered solutions
- Reduce cognitive complexity

### 5. Performance (if applicable)
- Obvious inefficiencies
- Better data structures
- Caching opportunities

## Output Format

For each suggestion:

**Issue**: What's the problem
**Location**: Where in the code
**Why**: Why this matters
**Before**: Current code snippet
**After**: Refactored code snippet
**Impact**: What improves (readability, performance, maintainability)

## Guidelines
- Follow existing code conventions in the project
- Suggest improvements but don't apply without asking
- Prioritize by impact - most valuable changes first
- Be pragmatic - don't refactor for refactoring's sake
