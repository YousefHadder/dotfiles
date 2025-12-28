Generate comprehensive tests for the specified code.

## Testing Approach (TDD-friendly)

### Test Categories

1. **Happy Path**
   - Standard expected usage
   - Common input scenarios

2. **Edge Cases**
   - Empty inputs (nil, null, "", [], {})
   - Boundary values (0, 1, -1, max, min)
   - Single element collections
   - Unicode and special characters

3. **Error Cases**
   - Invalid inputs
   - Missing required data
   - Type mismatches
   - Resource failures (network, file, etc.)

4. **Integration Points** (if applicable)
   - Mock external dependencies
   - Test interface boundaries

### Framework Selection
Use the idiomatic testing framework:
- Go: testing package + testify if available
- Ruby: RSpec or Minitest (match project)
- JS/TS: Jest, Vitest, or Mocha (match project)
- Lua: busted or luaunit
- Bash: bats or simple test scripts

### Test Structure
Follow AAA pattern:
- **Arrange**: Set up test data and mocks
- **Act**: Execute the code under test
- **Assert**: Verify the results

### Output
- Provide complete, runnable test files
- Include descriptive test names that document behavior
- Add comments explaining non-obvious test cases
- Group related tests logically

### Guidelines
- Tests should be independent and isolated
- Use descriptive names: `test_returns_empty_list_when_no_items_match`
- Mock external dependencies appropriately
- Aim for high coverage on critical paths
