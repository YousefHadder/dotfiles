Help craft a good commit message for the staged changes.

## Process

1. **Analyze the changes**
   - Review git diff of staged files
   - Understand what was modified and why

2. **Determine the type**
   - `feat`: New feature
   - `fix`: Bug fix
   - `docs`: Documentation only
   - `style`: Formatting, no code change
   - `refactor`: Code change that neither fixes nor adds
   - `test`: Adding/updating tests
   - `chore`: Maintenance, deps, build
   - `perf`: Performance improvement

3. **Identify the scope** (optional)
   - Component, module, or area affected
   - e.g., `auth`, `api`, `cli`, `parser`

4. **Write the message**

## Conventional Commit Format

```
type(scope): short description (imperative mood, <50 chars)

Longer explanation if needed. Wrap at 72 characters.
Explain WHAT changed and WHY, not HOW (the code shows how).

- Bullet points for multiple changes
- Keep it scannable

Refs: #123 (if applicable)
```

## Examples

```
feat(auth): add OAuth2 login support

Implement Google and GitHub OAuth providers for user authentication.
This replaces the previous email-only login flow.

- Add OAuth callback handlers
- Store provider tokens securely
- Update user model with provider field

Refs: #456
```

```
fix(parser): handle empty input without panic

The parser was dereferencing nil when given empty input.
Now returns an empty result instead.
```

## Guidelines
- Use imperative mood: "add" not "added" or "adds"
- First line should complete: "This commit will..."
- Don't end the subject line with a period
- Focus on WHY the change was made
