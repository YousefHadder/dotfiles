---
name: onboard-repo
description: >
  This skill should be used when the user asks to "onboard", "analyze this repo",
  "understand this codebase", "familiarize yourself", "what is this project",
  or needs to deeply understand a codebase's architecture, patterns, and conventions
  before starting work.
---

# Onboard

Deep-dive into the current working directory to fully understand the codebase architecture, patterns, and conventions.

## Execution Strategy

### Step 0: Ensure Default Branch

Onboarding must always run against the repository's default branch so the analysis reflects the canonical codebase.

1. **Detect the default branch** — run `git remote show origin | grep 'HEAD branch' | awk '{print $NF}'` (fall back to `main` if the remote query fails).
2. **Check the current branch** — run `git branch --show-current`.
3. **If already on the default branch**, skip ahead to Step 1.
4. **If on a different branch**:
   a. Save the current branch name for later.
   b. If there are uncommitted changes (`git status --porcelain` is non-empty), create a temporary commit:
      ```
      git add -A && git commit -m "ONBOARD_TEMP_COMMIT" --no-verify
      ```
   c. Switch to the default branch: `git checkout <default-branch>`.
   d. Continue with Step 1 through Step 6.
   e. **After Step 6 completes**, switch back to the saved branch:
      ```
      git checkout <saved-branch>
      ```
   f. If a temporary commit was created in (b), undo it while keeping the working-tree changes:
      ```
      git reset --soft HEAD~1 && git restore --staged .
      ```

> **Important**: Steps 1–6 below always execute on the default branch. The switch-back and reset happen only after all analysis and instruction file updates are complete.

### Step 1: Check for Existing Instruction Files

Check if either or both of these files exist in the project:
- `CLAUDE.md` (project root) — used by **Claude Code**
- `.github/copilot-instructions.md` — used by **GitHub Copilot**

**If a file exists:** Read it and note the contents. It will be validated and updated if needed after the analysis.

**If a file does NOT exist:** It will be generated in Step 5.

### Step 2: Quick Initial Scan

Note the current working directory (`pwd`). Read these files if they exist:
- README.md, CONTRIBUTING.md
- package.json, go.mod, Gemfile, Cargo.toml, pyproject.toml, etc.
- Top-level directory listing

### Step 3: Spawn Parallel Subagents

**Use parallel subagents** to analyze different aspects simultaneously. This cuts onboarding time from ~5 min to ~1-2 min.

Launch these 4 subagents simultaneously using the Agent tool with `subagent_type: "Explore"` and `model: "haiku"`. Inject the working directory (from Step 2) into each prompt.

**Agent 1: Structure & Entry Points**
```
Prompt: "Working directory: {cwd}. Map this codebase structure. Find:
1. All top-level directories and their purpose
2. Entry points (main.go, index.ts, app.rb, etc.)
3. Config files (tsconfig, webpack, vite, docker-compose)
4. Test directories and testing framework
Return a concise summary."
```

**Agent 2: Architecture & Dependencies**
```
Prompt: "Working directory: {cwd}. Analyze this codebase architecture. Find:
1. Core modules/packages and their responsibilities
2. How modules depend on each other
3. Shared utilities, types, constants locations
4. Database/API patterns if present
Return a concise summary."
```

**Agent 3: Patterns & Conventions**
```
Prompt: "Working directory: {cwd}. Identify coding patterns in this codebase:
1. Naming conventions (files, functions, variables)
2. Error handling approach
3. Import/export patterns
4. Logging and observability patterns
5. Any consistent architectural patterns
Return a concise summary."
```

**Agent 4: Dev Workflow**
```
Prompt: "Working directory: {cwd}. Find the development workflow for this codebase:
1. Build commands (package.json scripts, Makefile, etc.)
2. Test commands and how to run specific tests
3. Linting and formatting setup
4. CI/CD pipeline (.github/workflows, etc.)
5. Environment setup (.env.example, docker-compose)
Return a concise summary."
```

### Step 4: Synthesize Results

Combine all subagent findings into a unified summary using the **Output Format** template below.

### Step 5: Generate or Update Instruction Files

Apply this step to **both** `CLAUDE.md` and `.github/copilot-instructions.md`. The analysis content is the same — tailor the format and framing to each tool.

#### 5a: `CLAUDE.md` (Claude Code)

Place at the project root. Use a `# CLAUDE.md` heading. Content priorities:
1. Build/test/lint commands (most critical)
2. Non-obvious conventions specific to this project
3. Gotchas and known footguns
4. Key architectural decisions

Omit anything that is self-evident from reading the code.

**If the file already exists:** Do a section-by-section comparison. Only edit sections where a finding directly contradicts or is missing from the current content:
- Commands changed (build, test, lint scripts differ from what's documented)
- New conventions adopted that aren't documented
- Key directories or entry points changed
- Tooling shifted (e.g., migrated from Jest to Vitest)
- A section is entirely missing that would meaningfully help

Make **targeted edits only** — use the Edit tool, not a full rewrite. If the existing file is complete and accurate, leave it untouched.

#### 5b: `.github/copilot-instructions.md` (GitHub Copilot)

Place inside the `.github/` directory (create it if it doesn't exist). Content priorities are the same as 5a, but:
- Omit the `# CLAUDE.md` heading — use a project-appropriate heading instead (e.g., `# Copilot Instructions` or `# Project: {name}`)
- Keep the same sections: build/test/lint commands, conventions, gotchas, architecture
- Apply the same targeted-edit rules if the file already exists

Prioritize build/test/lint commands first, then non-obvious conventions, then gotchas. Omit anything derivable from reading the code. Keep it focused — quality over quantity.

### Step 6: Report Changes

Always end with a brief summary covering **both files**:

| File | Status |
|------|--------|
| `CLAUDE.md` | Created / Updated (list changes) / No changes needed |
| `.github/copilot-instructions.md` | Created / Updated (list changes) / No changes needed |

For each file that was modified, note what was added, updated, or left unchanged.

## Output Format

Use this exact structure when presenting the synthesis in Step 4:

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
