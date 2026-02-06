---
name: onboard
description: Thoroughly analyze and understand the current codebase to enable effective work on any task. Use when starting work in an unfamiliar repo.
---

# Onboard

Deep-dive into the current working directory to fully understand the codebase architecture, patterns, and conventions.

## Execution Strategy

### Step 1: Check for Existing AGENTS.md

First, check if `AGENTS.md` exists in the project root.

**If AGENTS.md exists:**
1. Read the AGENTS.md file
2. Summarize key points for the user (stack, commands, conventions)
3. Confirm you're ready to work on the codebase
4. **Skip all remaining steps** - you're onboarded!

**If AGENTS.md does NOT exist:** Continue to Step 2.

### Step 2: Quick Initial Scan
Read these files if they exist to understand project basics:
- README.md, CONTRIBUTING.md
- package.json, go.mod, Gemfile, Cargo.toml, pyproject.toml, etc.
- Top-level directory listing

### Step 3: Run Parallel Discovery Passes

**Use parallel discovery passes** to analyze different aspects simultaneously. This cuts onboarding time from ~5 min to ~1-2 min.

Launch these 4 analysis passes in parallel when possible (otherwise run sequentially):

**Agent 1: Structure & Entry Points**
```
Prompt: "Map this codebase structure. Find:
1. All top-level directories and their purpose
2. Entry points (main.go, index.ts, app.rb, etc.)
3. Config files (tsconfig, webpack, vite, docker-compose)
4. Test directories and testing framework
Return a concise summary."
```

**Agent 2: Architecture & Dependencies**
```
Prompt: "Analyze this codebase architecture. Find:
1. Core modules/packages and their responsibilities
2. How modules depend on each other
3. Shared utilities, types, constants locations
4. Database/API patterns if present
Return a concise summary."
```

**Agent 3: Patterns & Conventions**
```
Prompt: "Identify coding patterns in this codebase:
1. Naming conventions (files, functions, variables)
2. Error handling approach
3. Import/export patterns
4. Logging and observability patterns
5. Any consistent architectural patterns
Return a concise summary."
```

**Agent 4: Dev Workflow**
```
Prompt: "Find the development workflow for this codebase:
1. Build commands (package.json scripts, Makefile, etc.)
2. Test commands and how to run specific tests
3. Linting and formatting setup
4. CI/CD pipeline (.github/workflows, etc.)
5. Environment setup (.env.example, docker-compose)
Return a concise summary."
```

### Step 4: Synthesize Results

Combine all subagent findings into a unified summary.

### Step 5: Generate AGENTS.md

After completing the analysis, **create an AGENTS.md file** in the project root with:
- Build/test/lint commands
- Key architectural decisions
- Coding conventions specific to this project
- Important gotchas or non-obvious patterns

Keep it under 100 lines. Only include what Claude needs to know that isn't obvious from the code itself.

## Output Format

```
## Project: {name}

**Stack**: {languages, frameworks, major deps}
**Architecture**: {monolith/microservices/monorepo, key patterns}
**Entry points**: {main files}
**Test command**: {how to run tests}
**Build command**: {how to build}

### Key directories
- src/: {purpose}
- lib/: {purpose}
...

### Conventions observed
- {pattern 1}
- {pattern 2}

### Ready to work on
- {what kinds of tasks I can now handle}
```
