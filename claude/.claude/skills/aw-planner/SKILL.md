---
name: aw-planner
description: Analyze the current repo deeply and suggest agentic workflows tailored to its architecture, patterns, and pain points. Use when user calls /aw-planner.
---

# Agentic Workflow Planner

Deep-analyze the current repository and recommend agentic workflows that would provide the most value — automating repetitive tasks, enforcing quality gates, and accelerating development.

## Execution Strategy

### Step 1: Deep Repo Analysis

Spawn 4 parallel subagents (`subagent_type: "Explore"`) to analyze the repo simultaneously:

**Agent 1: Stack & Architecture**
```
Prompt: "Analyze this codebase deeply. Find:
1. Languages, frameworks, and major dependencies
2. Architecture style (monolith, microservices, monorepo, library)
3. Module/package boundaries and how they interact
4. Entry points, API surfaces, and public interfaces
5. Database/storage layer and data access patterns
6. Configuration management approach
Return a detailed summary with file paths as evidence."
```

**Agent 2: Development Workflow & Tooling**
```
Prompt: "Map the full development workflow:
1. Build system and commands (Makefile, package.json scripts, etc.)
2. Test framework, test structure, and how tests are run
3. CI/CD pipeline (.github/workflows, Jenkinsfile, etc.)
4. Linting, formatting, and static analysis tools
5. Deployment process (Docker, k8s, serverless, etc.)
6. Environment management (.env, docker-compose, etc.)
7. Git workflow (branching strategy, PR templates, commit conventions)
Return a detailed summary with file paths as evidence."
```

**Agent 3: Code Quality & Pain Points**
```
Prompt: "Identify code quality signals and pain points:
1. Test coverage gaps — modules with no tests or minimal coverage
2. Error handling patterns — consistent or inconsistent?
3. Code duplication — repeated patterns across files
4. Large files (>500 lines) or complex functions (>50 lines)
5. Missing or outdated documentation
6. Security patterns — auth, input validation, secret management
7. TODOs, FIXMEs, and HACKs in the codebase
8. Dependency health — outdated, deprecated, or vulnerable packages
Return findings with specific file paths and line numbers."
```

**Agent 4: Patterns & Conventions**
```
Prompt: "Identify established patterns and conventions:
1. Naming conventions (files, functions, variables, classes)
2. Import/export organization
3. State management approach (if applicable)
4. Logging and observability patterns
5. API design patterns (REST, GraphQL, RPC conventions)
6. Existing automation — scripts, hooks, generators
7. Any CLAUDE.md, CONTRIBUTING.md, or codestyle docs
Return a summary with examples from the code."
```

### Step 2: Synthesize Findings

Combine all subagent results into a unified understanding:

1. **Stack profile** — languages, frameworks, architecture style
2. **Workflow maturity** — what's automated vs. manual today
3. **Quality gaps** — where quality enforcement is weak or missing
4. **Pain points** — repetitive tasks, friction areas, risky manual processes
5. **Existing automation** — what's already in place (don't duplicate)

### Step 3: Generate Workflow Recommendations

For each recommended workflow, evaluate fit against this criteria:

| Criteria | Weight |
|----------|--------|
| Pain point severity (how much time/risk it eliminates) | High |
| Implementation effort (quick win vs. major investment) | High |
| Stack compatibility (works with existing tools) | Medium |
| Existing coverage (not duplicating what's already automated) | Medium |

#### Workflow Categories to Evaluate

Assess each category and only recommend workflows where there's a genuine gap:

**Build & Deploy**
- CI/CD pipeline automation or improvements
- Build validation and artifact management
- Deployment safety (canary, blue-green, rollback)
- Environment provisioning and configuration
- Infrastructure as code workflows

**Code Quality**
- Automated code review (style, patterns, anti-patterns)
- PR workflow automation (labeling, assignment, checks)
- Security scanning (SAST, dependency audit, secret detection)
- Documentation generation and staleness detection
- Refactoring assistance (dead code, complexity reduction)

**Testing**
- Test generation for uncovered code paths
- TDD enforcement workflows
- E2E test automation for critical user flows
- Test data management and fixtures
- Flaky test detection and quarantine

**Development Velocity**
- Onboarding automation for new contributors
- Feature scaffolding and boilerplate generation
- Database migration workflows
- API contract testing and documentation
- Local development environment setup

**Observability & Operations**
- Log analysis and alerting workflows
- Performance profiling automation
- Incident response runbooks
- Health check and monitoring setup
- Cost optimization analysis

**Custom / Project-Specific**
- Any workflow unique to the project's domain or architecture
- Workflows that address specific pain points found in the analysis

### Step 4: Prioritize and Present

Rank recommendations by impact and feasibility:

- **Quick Wins** — high impact, low effort (implement first)
- **Strategic** — high impact, higher effort (plan and schedule)
- **Nice to Have** — moderate impact (backlog)

### Step 5: Save to File

Write the recommendations to `AGENTIC_WORKFLOWS.md` in the repo root.

## Output Format

Present recommendations both in conversation and in the file:

```markdown
# Agentic Workflow Recommendations

**Repository**: {name}
**Stack**: {languages, frameworks}
**Analysis Date**: {YYYY-MM-DD}

---

## Current State

### What's Already Automated
- {existing automation 1}
- {existing automation 2}

### Key Pain Points Identified
- {pain point 1 — with evidence}
- {pain point 2 — with evidence}

---

## Recommended Workflows

### Quick Wins

#### 1. {Workflow Name}

**Category**: {Build & Deploy | Code Quality | Testing | Dev Velocity | Ops | Custom}
**Pain Point**: {what problem this solves}
**Impact**: {High | Medium | Low}
**Effort**: {Hours | Days | Weeks}

**What it does**:
{2-3 sentence description of the workflow}

**Implementation sketch**:
{Concrete steps, tools, or agent configurations to implement this}

**Example trigger**:
> "{What a user would say to invoke this workflow}"

---

(repeat for each recommendation, grouped by priority tier)

---

### Strategic

#### N. {Workflow Name}
(same format)

---

### Nice to Have

#### N. {Workflow Name}
(same format)

---

## Implementation Roadmap

| Priority | Workflow | Effort | Dependencies |
|----------|----------|--------|--------------|
| 1 | {name} | {effort} | {any prereqs} |
| 2 | {name} | {effort} | {any prereqs} |
| ... | ... | ... | ... |
```

## Guidelines

- **Evidence-based** — every recommendation must cite specific findings from the analysis (file paths, patterns, gaps). No generic suggestions.
- **No duplication** — if a workflow already exists (CI pipeline, linting, etc.), acknowledge it and suggest improvements only if there are clear gaps.
- **Concrete sketches** — include enough implementation detail that each workflow could be turned into a skill or script. Don't be vague.
- **Respect the stack** — recommend tools and approaches compatible with the project's existing toolchain. Don't suggest Jest for a Go project.
- **Prioritize ruthlessly** — 5-8 high-quality recommendations beat 20 generic ones. Only recommend workflows with clear ROI.
- **Consider the team** — if CONTRIBUTING.md or team patterns suggest certain workflows, factor that in.
- **Actionable output** — the saved file should serve as a backlog the user can work through, not just a report.
