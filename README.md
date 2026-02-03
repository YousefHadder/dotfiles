# My Dotfiles

A carefully curated collection of configuration files and scripts for a streamlined development environment across macOS and Linux systems.

# Table of Contents

- [My Dotfiles](#my-dotfiles)
- [Table of Contents](#table-of-contents)
  - [Overview](#overview)
    - [Key Features](#key-features)
  - [What's Included](#whats-included)
    - [Shell \& Terminal](#shell--terminal)
    - [Development Tools](#development-tools)
    - [AI Integrations](#ai-integrations)
    - [Utilities \& Enhancements](#utilities--enhancements)
    - [Package Management](#package-management)
  - [Quick Start](#quick-start)
    - [GitHub Codespaces Support](#github-codespaces-support)
  - [Repository Structure](#repository-structure)
  - [Installation Guide](#installation-guide)
    - [Prerequisites](#prerequisites)
    - [Detailed Installation Steps](#detailed-installation-steps)
    - [What Gets Installed](#what-gets-installed)
    - [Manual Installation (Alternative)](#manual-installation-alternative)
  - [Configuration Details](#configuration-details)
    - [Zsh Configuration](#zsh-configuration)
    - [Neovim Setup (Comprehensive Development Environment)](#neovim-setup-comprehensive-development-environment)
    - [Tmux Setup](#tmux-setup)
    - [Git Configuration](#git-configuration)
    - [Starship Prompt](#starship-prompt)
    - [Ghostty Terminal](#ghostty-terminal)
    - [Claude AI Configuration](#claude-ai-configuration)
    - [Yazi File Manager](#yazi-file-manager)
    - [Lazygit Configuration](#lazygit-configuration)
    - [LunarVim Configuration (lvim)](#lunarvim-configuration-lvim)
    - [Claude-Copilot Proxy](#claude-copilot-proxy)
    - [Copilot CLI Configuration](#copilot-cli-configuration)
    - [Eza Theme](#eza-theme)
  - [Customization](#customization)
    - [Adding New Packages](#adding-new-packages)
    - [Modifying Existing Configurations](#modifying-existing-configurations)
    - [Neovim Plugin Management](#neovim-plugin-management)
    - [Environment-Specific Settings](#environment-specific-settings)
    - [Stow Package Management](#stow-package-management)
  - [Troubleshooting](#troubleshooting)
    - [Common Issues](#common-issues)
    - [Getting Help](#getting-help)
  - [Key Features \& Shortcuts](#key-features--shortcuts)
    - [Neovim Shortcuts (Highlights)](#neovim-shortcuts-highlights)
    - [Tmux Shortcuts](#tmux-shortcuts)
    - [Zsh Aliases](#zsh-aliases)
  - [Contributing](#contributing)
    - [How to Contribute](#how-to-contribute)
    - [Guidelines](#guidelines)
    - [Areas for Contribution](#areas-for-contribution)
    - [Reporting Issues](#reporting-issues)
  - [License](#license)
  - [Acknowledgments](#acknowledgments)
  - [Related Projects](#related-projects)

## Overview

This dotfiles repository contains my personal development environment configuration, optimized for productivity and efficiency. It includes configurations for modern terminal tools, editors, version control, and development utilities with full **GitHub Codespaces** support.

### Key Features
- **Modular Architecture**: Organized installation scripts and Zsh configuration for maintainability
- **Automated Installation**: One-command setup with comprehensive `install.sh` using parallel background jobs
- **Cross-Platform**: Works on macOS, Linux, and GitHub Codespaces
- **Modern Tools**: Curated selection of powerful CLI utilities
- **Organized Structure**: Clean organization using GNU Stow
- **Developer-Focused**: Optimized for coding with LSP, AI assistants, and modern workflows
- **Extensive Neovim Setup**: Complete Lua-based configuration with 38+ plugins
- **AI-First Development**: Deep integration with Copilot, Claude, and MCP servers

## What's Included

### Shell & Terminal
- **Zsh**: Enhanced shell with Oh My Zsh framework and modern plugins
- **Starship**: Fast, customizable prompt with Dracula theme
- **Tmux**: Terminal multiplexer with Catppuccin theme and 14 productivity plugins
- **Ghostty**: High-performance terminal emulator with custom Slate colorscheme

### Development Tools
- **Neovim**: Comprehensive Lua configuration with:
  - LSP integration (Mason, nvim-lspconfig) for 10+ languages
  - 38+ lazy-loaded plugins via lazy.nvim
  - Treesitter for syntax highlighting
  - blink.cmp for fast completion
  - Neotest for testing frameworks
  - Conform for code formatting
  - nvim-lint for async linting
- **LunarVim (lvim)**: Alternative Neovim configuration based on LazyVim
- **Git**: Optimized configuration with Delta pager for diffs
- **Lazygit**: Beautiful terminal Git UI with vim-style keybindings
- **FZF**: Fuzzy finder with custom previews using bat and eza

### AI Integrations
- **GitHub Copilot**: Code suggestions with CopilotChat using claude-sonnet-4.5
- **Claude Code**: AI assistant with custom skills and powerline status
- **Claude-Copilot Proxy**: Route Claude Code through GitHub Copilot API
- **Copilot CLI**: Terminal-based Copilot with custom skills
- **MCPHub**: Model Context Protocol server integration
- **Sidekick.nvim**: Claude/Copilot/Codex CLI wrapper in Neovim

### Utilities & Enhancements
- **Yazi**: Modern file manager with MIME-based coloring and previews
- **Eza**: Modern `ls` replacement with custom 256-color theme
- **Bat**: Syntax-highlighted `cat` replacement
- **Ripgrep**: Ultra-fast text search
- **Zoxide**: Smart directory jumping (`cd` replacement)
- **Tree-sitter**: Advanced syntax highlighting
- **fd**: Fast alternative to `find`
- **pay-respects**: Command correction tool

### Package Management
- **Homebrew**: Package manager with split Brewfiles (essential/optional)
- **NVM**: Node.js version management (lazy-loaded)
- **rbenv**: Ruby version management
- **Lua/LuaJIT**: For Neovim configuration and tools

## Quick Start

```bash
# Clone the repository
git clone https://github.com/YousefHadder/dotfiles.git ~/dotfiles

# Navigate to the directory
cd ~/dotfiles

# Run the installation script
./install.sh
```

The installation script will:
1. **Bootstrap Phase**: Install Zsh and Oh My Zsh
2. **Homebrew Phase**: Install Homebrew package manager
3. **Package Phase**: Install essential packages (blocking) and optional packages (background)
4. **Languages Phase**: Install Rust and Copilot CLI (background)
5. **Scripts Phase**: Copy utility scripts to ~/scripts
6. **Symlinks Phase**: Create symlinks using GNU Stow
7. **Finalization**: Wait for background jobs, generate timing summary, reload shell

### GitHub Codespaces Support
This repository is fully configured for GitHub Codespaces with automatic environment detection and non-interactive installation.

## Repository Structure

<details>
<summary><strong>Click to expand full directory tree</strong></summary>

```
dotfiles/
├── Brewfile                 # Complete package definitions (fallback)
├── Brewfile.essential       # Core packages (blocking install)
├── Brewfile.optional        # Extended tools (background install)
├── install.sh               # Main installation script
├── README.md                # This comprehensive guide
├── .stowrc                  # GNU Stow configuration
│
├── install/                 # Modular installation scripts
│   ├── bootstrap.sh         # System bootstrap and Zsh setup
│   ├── homebrew.sh          # Homebrew installation
│   ├── languages.sh         # Rust, Copilot CLI (async)
│   ├── packages.sh          # Package installation via Homebrew
│   ├── scripts.sh           # Script copying and permissions
│   ├── symlinks.sh          # GNU Stow symlink creation
│   └── utils.sh             # Utility functions, logging, job tracking
│
├── assests/                 # Assets (background images, etc.)
│
├── claude/                  # Claude AI configuration
│   └── .claude/
│       ├── CLAUDE.md        # Global Claude code instructions
│       ├── settings.json    # Claude settings (model, permissions)
│       ├── claude-powerline.json  # Powerline theme & budget config
│       └── skills/          # Custom skills (branch-and-pr, review-pr, etc.)
│
├── claude-copilot-proxy/    # Claude Code → GitHub Copilot router
│   └── .claude-copilot-proxy/
│       ├── config.yaml      # LiteLLM routing configuration
│       ├── bin/             # Setup, start, update scripts
│       ├── lib/             # Token management, service handlers
│       └── test/            # Health checks, API tests
│
├── copilot-cli/             # GitHub Copilot CLI configuration
│   └── .config/.copilot/
│       ├── config.json      # CLI settings (model, logging)
│       ├── copilot-instructions.md  # Global instructions
│       └── skills/          # Custom skills (code-review, etc.)
│
├── eza/                     # Eza (ls replacement) configuration
│   └── .config/eza/
│       └── theme.yml        # 256-color theme definition
│
├── git/
│   └── .gitconfig           # Git config with Delta pager
│
├── ghostty/                 # Ghostty terminal configuration
│   └── .config/ghostty/
│       └── config           # Terminal settings, Slate theme
│
├── lazygit/                 # Lazygit UI configuration
│   └── .config/lazygit/
│       └── config.yml       # Lazygit settings, keybindings
│
├── lvim/                    # LunarVim/Neovim alt config
│   └── .config/lvim/
│       ├── init.lua         # Entry point
│       └── lua/config/      # Options, keymaps, autocmds
│
├── nvim/                    # Primary Neovim configuration (38+ plugins)
│   └── .config/nvim/
│       ├── init.lua         # Main entry point
│       └── lua/yousef/      # Personal configuration modules
│           ├── config/      # Core settings (options, keymaps, autocmds)
│           ├── plugins/     # Plugin configurations
│           └── lazy.lua     # Lazy.nvim plugin manager setup
│
├── scripts/                 # Utility scripts
│   ├── custom_modules/      # Custom tmux status modules
│   │   ├── ctp_battery.conf
│   │   ├── ctp_cpu.conf
│   │   ├── ctp_memory.conf
│   │   ├── pane_size.conf
│   │   ├── primary_ip.conf
│   │   └── ...
│   └── fzf-git.sh           # Enhanced git operations with fzf
│
├── starship/                # Starship prompt configuration
│   └── .config/
│       └── starship.toml    # Dracula theme, multi-line format
│
├── tmux/
│   └── .tmux.conf           # Tmux with Catppuccin, 14 plugins
│
├── vim/
│   └── .vimrc               # Vim configuration (fallback)
│
├── yazi/                    # Yazi file manager configuration
│   └── .config/yazi/
│       ├── yazi.toml        # Main configuration
│       ├── theme.toml       # Visual theme
│       └── keymap.toml      # Custom keybindings
│
└── zsh/
    ├── .zshrc               # Main Zsh configuration
    └── conf.d/              # Modular Zsh configuration files
        ├── 00-paths.zsh     # PATH and environment paths
        ├── 01-environment.zsh   # Environment variables
        ├── 02-homebrew.zsh      # Homebrew configuration
        ├── 03-oh-my-zsh.zsh     # Oh My Zsh setup and plugins
        ├── 04-editor.zsh        # Editor preferences, aliases
        ├── 05-tools.zsh         # Tool initializations
        ├── 06-fzf.zsh           # FZF fuzzy finder setup
        ├── 07-plugins.zsh       # Zsh plugins
        └── 08-functions.zsh     # Custom shell functions
```

</details>

## Installation Guide

### Prerequisites

- **macOS**: Xcode Command Line Tools (automatically installed by script)
- **Linux**: `curl`, `git`, and system package manager (apt, yum, dnf, pacman)
- **GitHub Codespaces**: Ready to use (no additional setup required)
- **Both**: Internet connection for downloading packages

### Detailed Installation Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/YousefHadder/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

1. **Review the Brewfile** (optional):
   ```bash
   cat Brewfile.essential  # Core packages
   cat Brewfile.optional   # Extended tools
   ```

1. **Run Installation**:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

1. **Automatic Shell Switch**: The script automatically reloads Zsh with all configurations

### What Gets Installed

**Essential Packages** (blocking, must complete):
- `stow`, `fzf`, `neovim`, `tmux`, `starship`, `ripgrep`
- `zsh-autosuggestions`, `zsh-syntax-highlighting`

**Optional Packages** (background, non-blocking):
- `node`, `nvm`, `bat`, `eza`, `fd`, `zoxide`, `tree`, `yazi`, `yq`
- `lua`, `luajit`, `luarocks`, `prettier`, `make`, `lazygit`, `tree-sitter`

**Language Tools** (background):
- Rust & Cargo
- GitHub Copilot CLI

### Manual Installation (Alternative)

If you prefer manual control:

1. Install Homebrew:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

1. Install packages:
   ```bash
   brew bundle --file=Brewfile.essential
   brew bundle --file=Brewfile.optional
   ```

1. Stow individual packages:
   ```bash
   stow zsh tmux nvim git starship lazygit yazi eza claude copilot-cli
   ```

## Configuration Details

<details>
<summary><strong>Zsh Configuration</strong></summary>

The Zsh configuration is **modular and organized** into separate files in `zsh/conf.d/`:

**Files loaded in order:**
| File | Purpose |
|------|---------|
| `00-paths.zsh` | PATH configuration (Go, Ruby, Homebrew) |
| `01-environment.zsh` | Environment variables (XDG, NVM, etc.) |
| `02-homebrew.zsh` | Homebrew initialization (cross-platform) |
| `03-oh-my-zsh.zsh` | Oh My Zsh with git and rbenv plugins |
| `04-editor.zsh` | Editor preferences and core aliases |
| `05-tools.zsh` | Tool initializations (starship, zoxide, rbenv) |
| `06-fzf.zsh` | FZF configuration with custom previews |
| `07-plugins.zsh` | Zsh autosuggestions and syntax highlighting |
| `08-functions.zsh` | Custom functions (y, gpp, grun) |

**Key Aliases:**
| Alias | Command | Description |
|-------|---------|-------------|
| `l`, `ls` | `eza --icons=always` | Modern file listing |
| `ll`, `la` | `eza -lg`, `eza -lag` | Long format with icons |
| `lt`, `lt2-4` | `eza -lTg` | Tree view with depth limits |
| `cd` | `z` | Zoxide smart jumping |
| `n`, `vim` | `nvim` | Neovim aliases |
| `lg` | `lazygit` | Git TUI |
| `ccd` | `claude --dangerously-skip-permissions` | Claude Code shortcut |
| `cpa` | `copilot --yolo` | Copilot CLI shortcut |

**Custom Functions:**
- `y()`: Yazi file manager with directory change support
- `gpp <file.cpp>`: Compile C++ with g++17 and auto-detect g++ version
- `grun <file.cpp>`: Compile and run C++ in one command

</details>

<details>
<summary><strong>Neovim Setup (38+ plugins)</strong></summary>

**Plugin Manager**: Lazy.nvim with 38+ lazy-loaded plugins

**LSP & Language Support:**
| Language | Server | Formatter | Linter |
|----------|--------|-----------|--------|
| Go | gopls | goimports, gofmt | golangci-lint, revive |
| TypeScript/JS | ts_ls, eslint | prettier, eslint_d | eslint |
| Ruby | ruby_lsp | rubocop | rubocop |
| Python | pyright | isort, black | pylint |
| Lua | lua_ls | stylua | luacheck |
| Bash/Zsh | bashls | shfmt | shellcheck |
| Terraform | terraformls | terraform_fmt | tflint |
| Markdown | marksman | prettier | - |

**AI Integration:**
| Plugin | Purpose | Key |
|--------|---------|-----|
| copilot.lua | Code suggestions | `<S-Tab>` accept |
| CopilotChat.nvim | AI chat (claude-sonnet-4.5) | `<leader>aa` |
| mcphub.nvim | MCP server integration | `<leader>Mh` |
| sidekick.nvim | Claude/Copilot/Codex CLI | `<C-.>` toggle |

**File Navigation:**
| Plugin | Purpose | Key |
|--------|---------|-----|
| fzf-lua | Fuzzy finder | `<leader><space>`, `<leader>ff/fg` |
| snacks.nvim | Explorer, terminal, zen | `<leader>e`, `<C-/>`, `<leader>z` |
| yazi.nvim | File manager | `<leader>y` |

**Testing (neotest):**
- Adapters: rspec, minitest, jest, go, plenary
- Keys: `<leader>tn` nearest, `<leader>tf` file, `<leader>ts` summary

**UI/Theme:**
- Colorscheme: bebop.nvim (spike preset, transparent)
- Statusline: lualine with custom slate theme
- Bufferline: Ordinal numbering with LSP diagnostics
- Header: incline.nvim with navic breadcrumbs
- Dashboard: alpha-nvim with custom ASCII art

</details>

<details>
<summary><strong>Tmux Setup (14 plugins)</strong></summary>

**Theme**: Catppuccin Mocha with custom styling
**Plugin Manager**: TPM with 14 plugins

**Key Plugins:**
| Plugin | Purpose |
|--------|---------|
| vim-tmux-navigator | Seamless `<C-h/j/k/l>` navigation |
| tmux-sessionx | Session management (`Prefix + o`) |
| tmux-yank | Enhanced copy/paste |
| extrakto | Text extraction |
| catppuccin/tmux | Theme with custom modules |

**Status Bar Modules:**
- CPU, battery, memory monitoring
- Primary IP address display
- Pane size indicator
- Git integration

**Key Bindings:**
| Key | Action |
|-----|--------|
| `Prefix` | `Ctrl+b` |
| `Prefix + \|` | Vertical split |
| `Prefix + -` | Horizontal split |
| `<C-h/j/k/l>` | Vim-style navigation |
| `Prefix + o` | Session manager |

</details>

<details>
<summary><strong>Git Configuration</strong></summary>

**Core Settings:**
- Editor: Neovim
- Pager: Delta with side-by-side diff
- LFS: Enabled
- Push strategy: Simple

**Delta Pager:**
- Side-by-side view with line numbers
- Color-coded: Deletions (dark red), Additions (dark green)
- File headers: Bold yellow with underline

**Aliases:**
| Alias | Command |
|-------|---------|
| `co` | checkout |
| `cf` | Clone fork |
| `push-empty` | Create empty commit for CI triggers |

</details>

<details>
<summary><strong>Starship Prompt</strong></summary>

**Theme**: Custom Dracula palette

**Modules (left to right):**
1. OS symbol
2. Directory (4 levels max)
3. Git branch and status
4. Fill spacer
5. Runtime versions (Node, Bun, Deno)
6. AWS profile
7. Command duration (>500ms)
8. Time (HH:MM)
9. Character (success/error indicator)

**Layout**: Two-line format with box-drawing decorations

</details>

<details>
<summary><strong>Ghostty Terminal</strong></summary>

**Theme**: Custom Slate colorscheme
**Font**: Hack Nerd Font Mono, 15px
**Cursor**: Underline (non-blinking)
**Background**: Custom image at 15% opacity
**Window**: Frameless with macOS tabs

</details>

<details>
<summary><strong>Claude AI Configuration</strong></summary>

**Global Instructions (CLAUDE.md):**
- TDD-first workflow with verification protocol
- Language-specific idioms (Go, Ruby, JS, Lua, Bash)
- Conventional commits, no AI attribution
- Security-focused with explicit permission model

**Settings:**
- Model: Opus with Extended Thinking
- Permissions: Allow/ask/deny lists
- Plugins: lua-lsp, clangd-lsp

**Powerline:**
- 2-line status with 10-color palette
- Budget tracking: $5/day, 20M tokens/block
- 80% usage warnings

**Skills:**
| Skill | Purpose |
|-------|---------|
| `branch-and-pr` | Feature workflow automation |
| `review-pr-comments` | PR feedback analysis |
| `onboard` | Auto-generate project CLAUDE.md |
| `skill-creator` | Build new skills |
| `zendesk-markdown` | Markdown → HTML converter |

**Commands:**
- `/diary`: Capture session context
- `/reflect`: Synthesize patterns to REFLECTIONS.md

</details>

<details>
<summary><strong>Yazi File Manager</strong></summary>

**Layout**: 1:4:3 pane ratio
**Sorting**: Alphabetical, directories first
**Theme**: Dark with custom color scheme
- Directories: Light blue
- Executables: Green
- Archives: Red
- Media: Yellow/gold

**Features:**
- MIME-based file coloring
- Git status highlighting
- Permission color-coding

</details>

<details>
<summary><strong>Lazygit Configuration</strong></summary>

**Theme**: Custom dark with orange/blue accents
**Layout**: 33% side panel, Nerd Fonts v3
**Navigation**: Full vim-style keybindings

**Key Bindings:**
| Key | Action |
|-----|--------|
| `j/k` | Navigate up/down |
| `h/l` | Navigate panels |
| `Space` | Stage/unstage |
| `c` | Commit |
| `P/p` | Push/Pull |
| `z` | Undo |

</details>

<details>
<summary><strong>LunarVim Configuration (lvim)</strong></summary>

**Base**: LazyVim starter template
**Colorscheme**: Slate (dark, transparent)

**Features:**
- Relative + absolute line numbers
- 2-space indentation
- Smart case search
- Treesitter folding
- Persistent undo
- Transparent background

**Key Bindings:**
| Key | Action |
|-----|--------|
| `<leader>go` | Open all git changed files |
| `<leader>rw` | Global find/replace word |
| `<leader>tt/tv` | Terminal (window/split) |
| `<A-j/k>` | Move line up/down |

</details>

<details>
<summary><strong>Claude-Copilot Proxy</strong></summary>

Routes Claude Code API requests through GitHub Copilot API.

**Architecture:**
- Proxy: LiteLLM on `localhost:4000`
- Authentication: GitHub PAT with copilot scope
- Token storage: macOS Keychain / Linux Secret Service
- Auto-start: launchd (macOS) / systemd (Linux)

**Supported Models:**
- Claude: haiku-4.5, sonnet-4/4.5, opus-4.5
- Google: gemini-2.5-pro, gemini-3-pro/flash
- OpenAI: gpt-4.1, gpt-4o, gpt-5
- xAI: grok-code-fast-1

</details>

<details>
<summary><strong>Copilot CLI Configuration</strong></summary>

**Default Model**: claude-opus-4.5
**Features**: Markdown rendering, full logging

**Skills:**
| Skill | Purpose |
|-------|---------|
| `code-review` | Review local changes against main |
| `skill-creator` | Template for new skills |

</details>

<details>
<summary><strong>Eza Theme</strong></summary>

Custom 256-color theme for file listing with:
- **File kinds**: 15 color categories (directories, executables, symlinks, etc.)
- **Permissions**: Read (white), Write (gold), Execute (green)
- **Sizes**: Color intensity by size (bytes to giga)
- **Git status**: New (green), Modified (gold), Deleted (red)
- **File types**: Image, video, music, document categories

</details>

## Customization

<details>
<summary><strong>Adding New Packages</strong></summary>

1. **Add to Brewfile**:
   ```ruby
   # Essential (blocking)
   # Add to Brewfile.essential
   brew "package-name"

   # Optional (background)
   # Add to Brewfile.optional
   brew "optional-package"
   ```

1. **Install the package**:
   ```bash
   brew bundle --file=Brewfile.essential
   ```

1. **Create configuration directory** (if needed):
   ```bash
   mkdir package-name
   # Add your config files
   ```

1. **Stow the configuration**:
   ```bash
   stow package-name
   ```

</details>

<details>
<summary><strong>Modifying Existing Configurations</strong></summary>

1. **Edit files directly** in their respective directories:
   ```bash
   # Neovim config
   nvim nvim/.config/nvim/lua/yousef/config/options.lua

   # Zsh environment
   nvim zsh/conf.d/01-environment.zsh

   # Installation module
   nvim install/packages.sh
   ```

1. **Re-stow if needed**:
   ```bash
   stow -R package-name
   ```

</details>

<details>
<summary><strong>Neovim Plugin Management</strong></summary>

Add new plugins to the appropriate file in `nvim/.config/nvim/lua/yousef/plugins/`:
```lua
return {
  "author/plugin-name",
  config = function()
    -- Plugin configuration
  end,
}
```

</details>

<details>
<summary><strong>Environment-Specific Settings</strong></summary>

Cross-platform compatibility is built-in:
```bash
# In conf.d/02-homebrew.zsh
if [ "$(uname)" = "Darwin" ]; then
  BREW_HOME="/opt/homebrew"
elif [ "$(uname)" = "Linux" ]; then
  BREW_HOME="/home/linuxbrew/.linuxbrew"
fi
```

</details>

<details>
<summary><strong>Stow Package Management</strong></summary>

The `.stowrc` file automatically ignores:
- `.stowrc`, `DS_Store`, `Brewfile*`, `install.sh`, `scripts/`, `install/`

**Excluded packages** during automated stowing (Codespaces):
- `git`, `ghostty`, `claude`

</details>

## Troubleshooting

<details>
<summary><strong>Common Issues & Solutions</strong></summary>

**Stow conflicts**:
```bash
stow -D package-name  # Remove existing links
stow package-name     # Re-create links
```

**Permission errors**:
```bash
sudo chown -R $(whoami) ~/.config
```

**Homebrew path issues** (macOS):
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
```

**Homebrew path issues** (Linux):
```bash
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
```

**Oh My Zsh installation fails**:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```

**Neovim plugins not loading**:
```bash
rm -rf ~/.local/share/nvim
nvim --headless "+Lazy! sync" +qa
```

**Tmux plugins not working**:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins
```

**View installation log**:
```bash
cat ~/dotfiles_install.log
tail -f ~/dotfiles_install.log  # Watch in real-time
```

</details>

<details>
<summary><strong>Getting Help</strong></summary>

1. Check the [Issues](https://github.com/YousefHadder/dotfiles/issues) page
2. Review individual tool documentation:
   - [Neovim](https://neovim.io/doc/)
   - [Tmux](https://github.com/tmux/tmux/wiki)
   - [Oh My Zsh](https://ohmyz.sh/)
   - [Starship](https://starship.rs/)
3. Test configurations in isolation

</details>

## Key Features & Shortcuts

### Neovim Shortcuts (Highlights)

| Category | Key | Action |
|----------|-----|--------|
| **Navigation** | `<C-h/j/k/l>` | Window navigation (tmux-aware) |
| | `<C-d/u>` | Scroll (centered) |
| **Files** | `<leader>e` | File explorer |
| | `<leader><space>` | Smart find files |
| | `<leader>ff/fg` | Find files / Live grep |
| | `<leader>y` | Open Yazi |
| **Git** | `<leader>gs` | Git status |
| | `<leader>gg` | Lazygit |
| | `<leader>gb/gc` | Git branches / commits |
| **LSP** | `<leader>ca` | Code actions |
| | `<leader>cf` | Format buffer |
| | `gd/gr` | Go to definition / references |
| **AI** | `<leader>aa` | Toggle CopilotChat |
| | `<leader>ae/r/f` | Explain / Review / Fix |
| | `<C-.>` | Toggle Sidekick |
| | `<leader>Mh` | MCP Hub |
| **Testing** | `<leader>tn/tf` | Test nearest / file |
| | `<leader>ts` | Test summary |
| **UI** | `<leader>z` | Zen mode |
| | `<C-/>` | Toggle terminal |
| | `<leader>n` | Notification history |

### Tmux Shortcuts

| Key | Action |
|-----|--------|
| `Prefix` | `Ctrl+b` |
| `Prefix + \|` | Split horizontal |
| `Prefix + -` | Split vertical |
| `<C-h/j/k/l>` | Vim navigation |
| `Prefix + o` | Session manager (sessionx) |
| `Prefix + R` | Reload config |

### Zsh Aliases

| Category | Alias | Command |
|----------|-------|---------|
| **Listing** | `l`, `ls` | `eza --icons=always` |
| | `ll`, `la` | Long format / All files |
| | `lt`, `lt2-4` | Tree view with depth |
| **Navigation** | `z <dir>` | Smart directory jump |
| **Editor** | `n`, `vim` | Neovim |
| | `lvim` | LunarVim config |
| **Git** | `lg` | Lazygit |
| **AI** | `ccd` | Claude Code (skip perms) |
| | `cpa` | Copilot CLI (yolo) |
| **C++** | `gpp <file>` | Compile with g++17 |
| | `grun <file>` | Compile and run |

## Contributing

<details>
<summary><strong>How to Contribute</strong></summary>

This repository is in active development and contributions are welcome!

1. **Fork the repository**
2. **Create a feature branch**:
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes** following the existing structure
4. **Test thoroughly** on both macOS and Linux if possible
5. **Update documentation** if adding new features
6. **Submit a pull request**

**Guidelines:**
- Maintain cross-platform compatibility (macOS, Linux, Codespaces)
- Document new features in the README
- Test installation script changes thoroughly
- Follow existing code style and organization
- Use proper Stow structure for new configurations
- Add to appropriate Brewfile (essential vs optional)

**Areas for Contribution:**
- New tool configurations (following existing patterns)
- Neovim plugin additions with proper configuration
- Tmux enhancements
- Shell improvements (new aliases or functions)
- Cross-platform compatibility fixes
- Documentation improvements
- Installation script enhancements

**Reporting Issues:**
When reporting issues, please include:
- Operating system and version
- Terminal emulator being used
- Complete error messages
- Steps to reproduce
- Relevant configuration files

</details>

## License

This project is open source and available under the [MIT License](LICENSE).

## Acknowledgments

Special thanks to:

- **Framework Creators**: Oh My Zsh, Lazy.nvim, Starship
- **Package Managers**: Homebrew, GNU Stow
- **Theme Authors**: Catppuccin, Dracula, Bebop
- **Tool Creators**: eza, bat, ripgrep, fd, yazi, fzf, delta
- **AI Tools**: GitHub Copilot, Anthropic Claude

## Related Projects

- [LazyVim](https://github.com/LazyVim/LazyVim) - Neovim configuration
- [GitHub does dotfiles](https://dotfiles.github.io/) - Dotfiles inspiration
- [Catppuccin](https://github.com/catppuccin/catppuccin) - Terminal themes

---

**Happy coding!**

If you find these dotfiles helpful, please consider:
- Starring the repository
- Forking for your own use
- Reporting issues you encounter
- Contributing improvements

*Built with care for developers who value productivity and beautiful terminals.*
