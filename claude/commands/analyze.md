Perform a comprehensive analysis of the specified code or file:

## Analysis Areas

### 1. Code Quality
- Readability and clarity
- DRY violations and duplication
- Function/method complexity (cognitive load)
- Naming conventions and consistency

### 2. Security (HIGH PRIORITY)
- Input validation gaps
- Injection vulnerabilities (SQL, command, etc.)
- Authentication/authorization issues
- Sensitive data exposure
- Dependency vulnerabilities if apparent

### 3. Performance
- Obvious bottlenecks or inefficiencies
- N+1 query patterns
- Memory allocation concerns
- Unnecessary computations

### 4. Idioms & Best Practices
- Language-specific idiom violations
- Anti-patterns
- Modern alternatives to outdated patterns

### 5. Error Handling
- Unhandled error cases
- Poor error messages
- Missing edge case handling

## Output Format
Provide findings organized by severity:
- 🔴 **Critical** - Must fix (security, bugs)
- 🟠 **Warning** - Should fix (quality, performance)
- 🟡 **Suggestion** - Nice to have (style, minor improvements)

For each finding, explain WHY it's an issue and provide a concrete fix.
