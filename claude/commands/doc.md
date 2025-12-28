Generate or improve documentation for the specified code.

## Documentation Types

Based on context, generate appropriate documentation:

### For Functions/Methods
```
Brief one-line description.

Longer description if behavior is complex.

Parameters:
  - param_name: Type - Description and constraints

Returns:
  - Type - Description of return value

Raises/Errors:
  - ErrorType - When this occurs

Example:
  (practical usage example)
```

### For Modules/Packages
- Purpose and responsibility
- Key exports and their roles
- Usage examples
- Dependencies and requirements

### For README/External Docs
- Project overview
- Installation instructions
- Quick start guide
- Configuration options
- API reference (if applicable)
- Contributing guidelines

## Format Guidelines
- Use the doc comment format idiomatic to the language:
  - Go: GoDoc comments above declarations
  - Ruby: YARD or RDoc format
  - JS/TS: JSDoc format
  - Lua: LDoc or EmmyLua annotations
  - Bash: Header comments with usage info

- Focus on the "why" and edge cases, not obvious "what"
- Include practical examples that demonstrate real usage
- Keep language clear and scannable
