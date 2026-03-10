# CLAUDE.md - Dotfiles Repository

## MANDATORY: Use td for Task Management

Run td usage --new-session at conversation start (or after /clear). This tells you what to work on next.

Sessions are automatic (based on terminal/agent context). Optional:
- td session "name" to label the current session
- td session --new to force a new session in the same context

Use td usage -q after first read.

## Quick Reference

- **Install**: `./install.sh` (full setup) or `stow <package>` (individual)
- **Test**: `./claude-copilot-proxy/.claude-copilot-proxy/test/run-tests.sh [--quick] [--verbose]`
- **Lint**: No repo-wide linter; Neovim uses conform (formatting) + nvim-lint (async linting)
- **Stow a package**: `stow <dir>` (e.g., `stow nvim`, `stow zsh`)
- **Re-stow**: `stow -R <dir>` after config changes

## Architecture

**Dotfiles manager using GNU Stow.** Each top-level directory is a stow package whose contents mirror `$HOME`. Running `stow nvim` symlinks `nvim/.config/nvim/` → `~/.config/nvim/`.

### Installation Pipeline (install.sh)
Sequential phases, each a separate script sourcing `install/utils.sh`:
1. `bootstrap.sh` → Zsh + Oh My Zsh
2. `homebrew.sh` → Homebrew package manager
3. `packages.sh` → Brewfile.essential (blocking), Brewfile.optional (async)
4. `languages.sh` → Rust, Copilot CLI (async background jobs)
5. `scripts.sh` → Copy utility scripts to ~/scripts
6. `symlinks.sh` → GNU Stow symlinks (respects `.stowrc` ignores)

### Key Stow Packages
| Package | Target | Entry Point |
|---------|--------|-------------|
| `nvim` | `~/.config/nvim/` | `init.lua` → `lua/yousef/{config,plugins,lazy}.lua` |
| `zsh` | `~/` | `.zshrc` → sources `conf.d/00-08*.zsh` in order |
| `tmux` | `~/` | `.tmux.conf` (TPM + 14 plugins) |
| `git` | `~/` | `.gitconfig` (Delta pager) |
| `claude` | `~/.claude/` | `CLAUDE.md` + `settings.json` + skills/ |
| `copilot-cli` | `~/.copilot/` | `config.json` + skills/ |
| `claude-copilot-proxy` | `~/.claude-copilot-proxy/` | LiteLLM proxy routing |
| `shared-ai-instructions` | `~/.claude/` (via CLAUDE.md `@` import) | Global AI instructions shared across Claude + Copilot |

## Conventions

### Bash Scripts
- Prefer `set -euo pipefail` for executable scripts; `test/run-tests.sh` intentionally uses `set -uo pipefail` so all checks run
- Functions: `snake_case` — Variables: `UPPER_CASE` constants, `lower_case` locals
- Use `command_exists()` check before relying on tools
- Logging via `log()`, `log_success()`, `log_error()`, `log_warning()`, `log_info()`
- Script self-location: `SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"`

### Zsh Configuration
- Modular `conf.d/` with numeric prefixes (00-08) controlling load order
- Adding a new config: create `zsh/conf.d/NN-name.zsh` with appropriate number
- Secrets loaded from `~/.secret-env-vars` (never committed)

### Neovim (Lua)
- All config under `nvim/.config/nvim/lua/yousef/`
- Plugins: one file per plugin in `plugins/` dir, returning a lazy.nvim spec table
- Config split: `config/options.lua`, `config/keymaps.lua`, `config/autocmds.lua`

### Adding a New Tool
1. Create `<tool>/` directory mirroring `$HOME` structure
2. Add package to `Brewfile.essential` or `Brewfile.optional`
3. Run `stow <tool>` to symlink
4. Update `install/symlinks.sh` exclusion list if needed

## Gotchas
- `.stowrc` currently ignores `.stowrc`, `DS_Store`, `Brewfile`, and `install.sh`; package skip logic is in `install/symlinks.sh`
- Full auto-stow currently skips `git`, `ghostty`, and `install` packages in `install/symlinks.sh`
- Codespaces changes `DOTFILES_DIR` to `/workspaces/.codespaces/.persistedshare/dotfiles`
- `claude/.claude/CLAUDE.md` is the Claude Code global instructions (stowed to `~/.claude/`) — different from this file
- Brewfile.essential is blocking; Brewfile.optional runs async — don't put critical deps in optional
- No CI/CD pipeline — testing is manual via proxy test suite and editor validation
- `logs/` is gitignored (only `.gitkeep` committed) — install logs written to `~/dotfiles_install.log`
- `shared-ai-instructions/instructions.md` is the single source of truth for AI behavior; both `claude/.claude/CLAUDE.md` (`@` import) and `copilot-cli/.copilot/copilot-instructions.md` (symlink) reference it
