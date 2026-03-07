# Documentation Standards

## Doc Comments

- Provide doc comments for public APIs and exported functions
- Include parameter descriptions, return types, and error conditions
- Use language-idiomatic doc format (GoDoc, JSDoc, YARD, LuaDoc)

## External Documentation

- Prefer external documentation (README, docs/) for concepts and architecture
- Keep inline comments focused on "why", not "what"
- Document non-obvious design decisions inline

## When to Document

- Public APIs and exported interfaces (ALWAYS)
- Complex algorithms or business logic (ALWAYS)
- Workarounds and known limitations (ALWAYS)
- Simple, self-explanatory code (SKIP - let the code speak)
