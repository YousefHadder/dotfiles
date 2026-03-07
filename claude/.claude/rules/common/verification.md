# Verification Protocol

## Evidence-Based Completion

- NEVER claim "done" without showing actual command output as proof
- Claims require evidence - paste the validation/test output
- If tests were modified, explicitly state WHY
- One in-progress task at a time - complete current before starting next
- Run validation after EVERY code change before claiming success

## Validation Steps

After every change:
1. Run the relevant test suite
2. Verify the build passes
3. Check for regressions in related functionality
4. Paste output as proof of success

## What Counts as Evidence

- Test runner output (pass/fail with counts)
- Build output (success/failure)
- Linter output (clean or with explanations)
- Command output showing expected behavior
- Screenshot or terminal output for UI changes
