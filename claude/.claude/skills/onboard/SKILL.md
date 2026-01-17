---
name: onboard
description: Thoroughly analyze and understand the current codebase to enable effective work on any task. Use when starting work in an unfamiliar repo.
---

# Onboard

Deep-dive into the current working directory to fully understand the codebase architecture, patterns, and conventions.

## Execution Strategy

**Use parallel subagents** to analyze different aspects simultaneously. This cuts onboarding time from ~5 min to ~1-2 min.

### Step 1: Quick Initial Scan (do this first, sequentially)
Read these files if they exist to understand project basics:
- README.md, CLAUDE.md, CONTRIBUTING.md
- package.json, go.mod, Gemfile, Cargo.toml, pyproject.toml, etc.
- Top-level directory listing

### Step 2: Spawn Parallel Subagents

Launch these 4 subagents simultaneously using the Task tool with `subagent_type: "Explore"`:

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

### Step 3: Synthesize Results

Combine all subagent findings into a unified summary.

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

## CLAUDE.md Generation

If no CLAUDE.md exists in the project root, offer to create one with:
- Build/test/lint commands
- Key architectural decisions
- Coding conventions specific to this project
- Important gotchas or non-obvious patterns

Keep it under 100 lines. Only include what Claude needs to know that isn't obvious from the code itself.
