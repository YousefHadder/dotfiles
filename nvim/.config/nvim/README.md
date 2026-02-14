# Yousef's Neovim

A fast, modern, and UI-polished Neovim setup with great defaults, batteries-included LSP/formatting/testing, AI integrations (Copilot, CopilotChat, Sidekick), and powerful pickers/explorer — all powered by lazy.nvim.

Works great for **TypeScript/JavaScript**, **Go**, **Python**, **Lua**, **Ruby**, **Bash/Zsh**, **C/C++**, **Terraform**, and more.

**Requires Neovim 0.11+** for full feature support (treesitter folding, `vim.lsp.config`, rounded borders, etc.)

---

## Table of Contents

- [Highlights](#highlights)
- [Directory Layout](#directory-layout)
- [Quick Start](#quick-start)
- [Core Options](#core-options)
- [Keybindings](#keybindings)
  - [Essential](#essential)
  - [Navigation & Search](#navigation--search)
  - [LSP & Code Actions](#lsp--code-actions)
  - [Git](#git)
  - [Testing](#testing)
  - [AI & Copilot](#ai--copilot)
  - [Sidekick CLI](#sidekick-cli)
  - [Windows, Buffers, Tabs](#windows-buffers-tabs)
  - [Terminal](#terminal)
  - [UI Toggles](#ui-toggles)
  - [Misc Utilities](#misc-utilities)
- [Plugins](#plugins)
- [LSP Configuration](#lsp-configuration)
- [Formatting & Linting](#formatting--linting)
- [Treesitter](#treesitter)
- [Autocommands](#autocommands)
- [Custom Filetype Detection](#custom-filetype-detection)
- [UI & Theme](#ui--theme)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)

---

## Highlights

| Category | Tools |
|----------|-------|
| **Plugin Manager** | `folke/lazy.nvim` with auto-install, update checker, rounded UI |
| **Completion** | `saghen/blink.cmp` with signature help, ghost text, auto-brackets |
| **Pickers** | `ibhagwan/fzf-lua` for files, grep, buffers, git, LSP, diagnostics |
| **File Explorer** | `folke/snacks.nvim` explorer + `mikavilpas/yazi.nvim` integration |
| **LSP** | `nvim-lspconfig` + `mason.nvim` with auto-install and rich diagnostics |
| **Formatting** | `stevearc/conform.nvim` with format-on-save |
| **Linting** | `mfussenegger/nvim-lint` with per-filetype linters |
| **AI** | GitHub Copilot + CopilotChat (Claude Sonnet 4.5 default) |
| **CLI Agents** | `folke/sidekick.nvim` for Claude, Copilot CLI, Codex integration |
| **Testing** | `nvim-neotest/neotest` with Jest, RSpec, Minitest, Go, Plenary adapters |
| **Git** | `lewis6991/gitsigns.nvim` + Snacks LazyGit integration |
| **UI** | Bebop colorscheme, Noice cmdline, Incline winbar, Alpha dashboard |
| **Navigation** | Flash.nvim jumps, Which-Key guides, tmux-navigator |
| **Sessions** | `folke/persistence.nvim` with auto-restore |

---

## Directory Layout

```
.config/nvim/
├── init.lua                      # Entrypoint - loads config + lazy.nvim
├── lazy-lock.json                # Plugin lockfile
├── lua/yousef/
│   ├── config/
│   │   ├── init.lua              # Loads options → autocmds → keymaps
│   │   ├── options.lua           # Core vim options (UI, folds, search, etc.)
│   │   ├── keymaps.lua           # Global keymaps
│   │   └── autocmds.lua          # Autocommands
│   ├── lazy.lua                  # lazy.nvim bootstrap + setup
│   └── plugins/                  # One file per plugin spec
│       ├── alpha.lua             # Dashboard
│       ├── autopairs.lua         # Auto-close brackets
│       ├── bebop.lua             # Colorscheme
│       ├── blink-cmp.lua         # Completion
│       ├── bufferline.lua        # Buffer tabs
│       ├── code_runner.nvim.lua  # Code execution
│       ├── conform.lua           # Formatting
│       ├── copilot.lua           # GitHub Copilot
│       ├── copilotchat.lua       # CopilotChat
│       ├── flash.lua             # Jump navigation
│       ├── fzf-lua.lua           # Fuzzy finder
│       ├── gitsigns.lua          # Git signs
│       ├── guess-indent.lua      # Auto-detect indent
│       ├── incline.lua           # Winbar
│       ├── lazydev.lua           # Lua LSP for Neovim
│       ├── lsp.lua               # LSP configuration
│       ├── lualine.lua           # Statusline
│       ├── markdown.lua          # Markdown rendering/preview
│       ├── mason.lua             # LSP/tool installer
│       ├── mini.lua              # Mini.nvim modules
│       ├── neo-test.lua          # Testing framework
│       ├── noice.lua             # UI enhancements
│       ├── nvim-colorize.lua     # Color highlighting
│       ├── nvim-lint.lua         # Linting
│       ├── persistence.lua       # Session management
│       ├── praise.lua            # Git praise
│       ├── screenkey.lua         # Show keypresses
│       ├── sidekick.lua          # CLI agent integration
│       ├── snacks.lua            # Utilities (explorer, lazygit, etc.)
│       ├── surround.lua          # Surround operations
│       ├── treesitter.lua        # Syntax highlighting
│       ├── vim-tmux-navigator.lua # Tmux integration
│       ├── which-key.lua         # Keymap hints
│       └── yazi.lua              # Yazi file manager
└── queries/
    └── ruby/
        └── textobjects.scm       # Custom Ruby textobjects
```

---

## Quick Start

### Prerequisites

- **Neovim 0.11+** (required)
- Git, curl
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- `ripgrep` (`rg`) and `fd` for fast searching
- Node.js (for JS/TS LSP and formatters)
- Go, Python, Ruby (as needed for respective LSPs)
- Optional: `yazi`, `lazygit`, `delta` (for enhanced git diffs)

### Install

```bash
# Backup existing config if any
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this config
git clone <this-repo> ~/.config/nvim

# Launch Neovim - lazy.nvim will auto-install everything
nvim
```

---

## Core Options

Configured in `lua/yousef/config/options.lua`:

| Option | Value | Description |
|--------|-------|-------------|
| Leader | `<Space>` | Both leader and localleader |
| Line numbers | Relative | `number` + `relativenumber` |
| Indentation | 2 spaces | `expandtab`, `shiftwidth=2` |
| Search | Smart case | Case-insensitive unless uppercase |
| Clipboard | System | Uses `unnamedplus` |
| Folding | Treesitter | Expression-based, starts unfolded |
| Scrolloff | 8 lines | Keeps context above/below cursor |
| Color column | 120 | Visual line length guide |
| Borders | Rounded | Global `winborder` for all floats |
| Statusline | Global | `laststatus=3` |
| SSH | OSC 52 | Clipboard works over SSH |

---

## Keybindings

Leader key is `<Space>`. Use `<leader>?` to open Which-Key for discoverable menus.

### Essential

| Key | Action |
|-----|--------|
| `jk` | Exit insert mode |
| `<Esc>` | Clear search highlighting |
| `<C-d>` / `<C-u>` | Scroll half-page (centered) |
| `n` / `N` | Search next/prev (centered) |
| `j` / `k` | Move by display line (respects wrap) |
| `<` / `>` (visual) | Indent and reselect |
| `<A-j>` / `<A-k>` | Move lines up/down |
| `vag` | Select entire buffer |
| `x` | Delete char without yanking |
| `p` (visual) | Paste without replacing register |

### Navigation & Search

| Key | Action |
|-----|--------|
| `<leader><space>` | Smart find files (fzf-lua) |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fo` | Recent files |
| `<leader>fb` | Buffers |
| `<leader>fc` | Config files |
| `<leader>fr` | Resume last picker |
| `<leader>fh` | Help tags |
| `<leader>fk` | Keymaps |
| `<leader>/` | Search in current buffer |
| `<leader>:` | Command history |
| `<leader>sb` | Buffer lines |
| `<leader>sB` | Grep current buffer |
| `<leader>sg` | Live grep |
| `<leader>sw` | Grep word under cursor |
| `<leader>ss` | LSP document symbols |
| `<leader>sS` | LSP workspace symbols |
| `<leader>sd` | Workspace diagnostics |
| `<leader>sD` | Buffer diagnostics |
| `<leader>sm` | Marks |
| `<leader>sj` | Jumps |
| `<leader>sq` | Quickfix list |
| `<leader>sl` | Location list |
| `<leader>e` | File explorer (Snacks) |
| `<leader>y` | Open Yazi at current file |
| `<leader>cw` | Open Yazi at cwd |
| `<A-s>` | Flash jump |
| `<A-S>` | Flash treesitter jump |
| `]]` / `[[` | Next/prev reference (LSP) |

### LSP & Code Actions

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Find references |
| `gi` | Go to implementation |
| `gy` | Go to type definition |
| `<leader>ca` | Code actions |
| `<leader>ds` | Document symbols |
| `<leader>ws` | Workspace symbols |
| `<leader>th` | Toggle inlay hints |
| `<leader>cf` | Format buffer |
| `<leader>cl` | Lint current file |
| `<leader>cR` | Rename file |

### Git

| Key | Action |
|-----|--------|
| `<leader>gg` | LazyGit |
| `<leader>gs` | Git status |
| `<leader>gc` | Git commits |
| `<leader>gl` | Git log |
| `<leader>gL` | Git log (current file) |
| `<leader>gb` | Git branches |
| `<leader>gf` | Git files |
| `<leader>gS` | Git stash |
| `<leader>gB` | Git browse (open in browser) |
| `<leader>go` | Open all changed/untracked files |
| `<leader>gi` | GitHub issues (open) |
| `<leader>gI` | GitHub issues (all) |
| `<leader>gp` | GitHub PRs (open) |
| `<leader>gP` | GitHub PRs (all) |
| `<leader>gP` | Git praise (who wrote this) |
| `]c` / `[c` | Next/prev git hunk |

### Testing

| Key | Action |
|-----|--------|
| `<leader>tn` | Test nearest |
| `<leader>tf` | Test file |
| `<leader>tl` | Rerun last test |
| `<leader>ts` | Toggle test summary |
| `<leader>to` | Open test output |
| `<leader>tp` | Toggle output panel |
| `<leader>tw` | Watch file tests |
| `<leader>td` | Debug nearest test |
| `]t` / `[t` | Next/prev failed test |

### AI & Copilot

| Key | Action |
|-----|--------|
| `<S-Tab>` | Accept Copilot suggestion |
| `<C-w>` | Accept word |
| `<C-l>` | Accept line |
| `<leader>aa` | Toggle CopilotChat |
| `<leader>ab` | Chat with buffer context |
| `<leader>ae` | Explain code |
| `<leader>ar` | Review code |
| `<leader>af` | Fix code |
| `<leader>ao` | Optimize code |
| `<leader>ad` | Add documentation |
| `<leader>at` | Generate tests |
| `<leader>ac` | Generate commit message |
| `<leader>am` | Select AI model |
| `<leader>ap` | Prompt actions |
| `<leader>aD` | Explain diagnostics on current line |
| `<leader>ax` | Stop generating |

### Sidekick CLI

Integrates with Claude, Copilot CLI, and Codex agents via tmux:

| Key | Action |
|-----|--------|
| `<C-.>` | Toggle Sidekick CLI |
| `<leader>ak` | Toggle Sidekick CLI |
| `<leader>aS` | Select CLI tool |
| `<leader>aq` | Detach CLI session |
| `<leader>ah` | Send current context |
| `<leader>aF` | Send current file |
| `<leader>av` | Send visual selection |
| `<leader>aP` | Select prompt |
| `<leader>aC` | Toggle Claude directly |

### Windows, Buffers, Tabs

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate windows (tmux-aware) |
| `<leader>\|` | Vertical split |
| `<leader>-` | Horizontal split |
| `<Up/Down/Left/Right>` | Resize windows |
| `<Tab>` / `<S-Tab>` | Cycle buffers |
| `<leader>bd` | Delete buffer |
| `<leader>bn` | New buffer |
| `<A-h>` / `<A-l>` | Move buffer left/right |
| `gb` | Pick buffer |
| `[t` / `]t` | Prev/next tab |
| `<leader>ot` | New tab |
| `<leader>ct` | Close tab |

### Terminal

| Key | Action |
|-----|--------|
| `<C-/>` | Toggle Snacks terminal |
| `<leader>tt` | Open terminal |
| `<leader>tv` | Terminal in vsplit |
| `<Esc><Esc>` | Exit terminal mode |

### UI Toggles

| Key | Action |
|-----|--------|
| `<leader>us` | Toggle spelling |
| `<leader>uw` | Toggle word wrap |
| `<leader>ul` | Toggle line numbers |
| `<leader>uL` | Toggle relative numbers |
| `<leader>ud` | Toggle diagnostics |
| `<leader>uc` | Toggle conceal |
| `<leader>uT` | Toggle treesitter |
| `<leader>uh` | Toggle inlay hints |
| `<leader>ug` | Toggle indent guides |
| `<leader>uD` | Toggle dim |
| `<leader>uC` | Colorscheme picker |
| `<leader>z` | Zen mode |
| `<leader>Z` | Zoom |

### Misc Utilities

| Key | Action |
|-----|--------|
| `<leader>rw` | Replace word under cursor globally |
| `<leader>cp` | Copy file path to clipboard |
| `<leader>cd` | Copy diagnostics to clipboard |
| `<leader>wa` | Save all files |
| `<leader>q` | Quit |
| `<leader>Q` | Quit all |
| `<leader>rf` | Reload config |
| `<leader>lm` | Open Lazy |
| `<leader>mm` | Open Mason |
| `<leader>n` | Notification history |
| `<leader>un` | Dismiss notifications |
| `<leader>.` | Scratch buffer |
| `<leader>S` | Select scratch buffer |
| `<leader>si` | Icon picker |
| `<leader>rr` | Run current file (code_runner) |
| `<A-t>` | Toggle boolean (true/false, yes/no, etc.) |
| `<leader>?` | Which-Key buffer keymaps |

---

## Plugins

### Core & UX

| Plugin | Purpose |
|--------|---------|
| `folke/lazy.nvim` | Plugin manager with lazy-loading |
| `folke/which-key.nvim` | Keymap hints with helix preset |
| `folke/noice.nvim` | Enhanced cmdline, messages, notifications |
| `folke/snacks.nvim` | Explorer, lazygit, notifier, zen, scratch |
| `goolord/alpha-nvim` | Dashboard with Palestine flag theme |

### Completion & Editing

| Plugin | Purpose |
|--------|---------|
| `saghen/blink.cmp` | Fast completion with signature help |
| `rafamadriz/friendly-snippets` | Snippet collection |
| `windwp/nvim-autopairs` | Auto-close brackets (treesitter-aware) |
| `kylechui/nvim-surround` | Surround operations |
| `echasnovski/mini.nvim` | ai textobjects + icons |

### Pickers & Navigation

| Plugin | Purpose |
|--------|---------|
| `ibhagwan/fzf-lua` | Fuzzy finder for everything |
| `folke/flash.nvim` | Jump to any location |
| `mikavilpas/yazi.nvim` | Yazi file manager integration |

### Git

| Plugin | Purpose |
|--------|---------|
| `lewis6991/gitsigns.nvim` | Git signs in sign column |
| `lseppala/praise.nvim` | Git blame/praise |
| Snacks lazygit | LazyGit integration |

### LSP & Development

| Plugin | Purpose |
|--------|---------|
| `neovim/nvim-lspconfig` | LSP configuration |
| `williamboman/mason.nvim` | LSP/tool installer |
| `williamboman/mason-lspconfig.nvim` | Mason + lspconfig bridge |
| `WhoIsSethDaniel/mason-tool-installer.nvim` | Auto-install tools |
| `j-hui/fidget.nvim` | LSP progress indicator |
| `folke/lazydev.nvim` | Lua LSP for Neovim APIs |

### Formatting & Linting

| Plugin | Purpose |
|--------|---------|
| `stevearc/conform.nvim` | Format on save |
| `mfussenegger/nvim-lint` | Async linting |

### Testing

| Plugin | Purpose |
|--------|---------|
| `nvim-neotest/neotest` | Testing framework |
| `nvim-neotest/neotest-jest` | Jest adapter |
| `olimorris/neotest-rspec` | RSpec adapter |
| `zidhuss/neotest-minitest` | Minitest adapter |
| `nvim-neotest/neotest-go` | Go adapter |
| `nvim-neotest/neotest-plenary` | Plenary adapter |

### AI & Assistants

| Plugin | Purpose |
|--------|---------|
| `zbirenbaum/copilot.lua` | GitHub Copilot |
| `CopilotC-Nvim/CopilotChat.nvim` | Copilot Chat (Claude Sonnet 4.5) |
| `folke/sidekick.nvim` | CLI agent integration (Claude, Copilot, Codex) |

### UI & Appearance

| Plugin | Purpose |
|--------|---------|
| `ATTron/bebop.nvim` | Colorscheme (spike preset, transparent) |
| `nvim-lualine/lualine.nvim` | Statusline with slate theme |
| `akinsho/bufferline.nvim` | Buffer tabs with slant style |
| `tiagovla/scope.nvim` | Scope buffers to tabs |
| `b0o/incline.nvim` | Floating winbar with navic + diagnostics |
| `SmiteshP/nvim-navic` | LSP breadcrumbs |
| `norcalli/nvim-colorizer.lua` | Color highlighting |
| `NStefan002/screenkey.nvim` | Display keypresses |

### Treesitter

| Plugin | Purpose |
|--------|---------|
| `nvim-treesitter/nvim-treesitter` | Syntax highlighting + more |
| `nvim-treesitter/nvim-treesitter-textobjects` | Textobjects for code |
| `nvim-treesitter/nvim-treesitter-context` | Sticky context |
| `m-demare/hlargs.nvim` | Highlight function arguments |

### Markdown

| Plugin | Purpose |
|--------|---------|
| `MeanderingProgrammer/render-markdown.nvim` | Markdown rendering |
| `iamcco/markdown-preview.nvim` | Browser preview |
| `yousefhadder/markdown-plus.nvim` | Additional markdown features |

### Misc

| Plugin | Purpose |
|--------|---------|
| `folke/persistence.nvim` | Session management |
| `christoomey/vim-tmux-navigator` | Seamless tmux/vim navigation |
| `nmac427/guess-indent.nvim` | Auto-detect indentation |
| `CRAG666/code_runner.nvim` | Run code from editor |

---

## LSP Configuration

Configured in `lua/yousef/plugins/lsp.lua`. Uses the new Neovim 0.11+ `vim.lsp.config()` API.

### Servers

| Language | Server | Notes |
|----------|--------|-------|
| TypeScript/JavaScript | `ts_ls` | Inlay hints, handles JSX/TSX |
| ESLint | `eslint` | Vue support |
| Lua | `lua_ls` | Neovim runtime types via lazydev |
| Go | `gopls` | Full analysis, codelenses, hints |
| Python | `pyright` | Type checking |
| Ruby | `ruby_lsp` | With rubocop linting |
| Bash/Zsh | `bashls` | Handles zsh files too |
| C/C++ | `clangd` | clang-tidy, completion |
| Markdown | `marksman` | Wiki links, references |
| Terraform | `terraformls` | HCL support |

### Diagnostics

- Virtual lines on current line (Neovim 0.11+)
- Virtual text for warnings+ only
- Rounded float borders
- Severity icons: `󰅚` Error, `󰀪` Warn, `󰋽` Info, `󰌶` Hint
- Underline for warnings and above

---

## Formatting & Linting

### Formatters (conform.nvim)

| Filetype | Formatters |
|----------|-----------|
| Lua | `stylua` |
| JavaScript/TypeScript/React | `eslint_d`, `prettierd`/`prettier` |
| Python | `isort`, `black` |
| Go | `goimports`, `gofmt` |
| Ruby | `rubocop` |
| Shell | `shfmt` |
| JSON | `jq` |
| CSS/HTML/YAML/Markdown | `prettier` |
| Terraform | `terraform_fmt` |
| C/C++ | `clang_format` |

Format on save is enabled (500ms timeout) except for C/C++.

### Linters (nvim-lint)

| Filetype | Linters |
|----------|---------|
| Lua | `luacheck` |
| Ruby | `rubocop` |
| Go | `revive` |
| Python | `pylint` |
| Shell | `shellcheck` |
| Terraform | `tflint` |

Linting runs on `BufEnter`, `BufWritePost`, `InsertLeave`.

---

## Treesitter

### Installed Parsers

bash, c, cpp, css, csv, diff, dockerfile, gitignore, go, html, javascript, json, lua, markdown, python, regex, ruby, sql, ssh_config, tmux, toml, tsx, typescript, vim, yaml, hcl, terraform

### Textobjects

| Keymap | Object |
|--------|--------|
| `af` / `if` | Function outer/inner |
| `ac` / `ic` | Class outer/inner |
| `am` / `im` | Block/module outer/inner |
| `ai` / `ii` | Conditional outer/inner |
| `al` / `il` | Loop outer/inner |
| `aa` / `ia` | Parameter outer/inner |
| `aC` / `iC` | Comment outer/inner |

### Incremental Selection

| Key | Action |
|-----|--------|
| `<C-Space>` | Init/increment selection |
| `gnc` | Scope increment |
| `gnd` | Decrement |

---

## Autocommands

Configured in `lua/yousef/config/autocmds.lua`:

| Event | Behavior |
|-------|----------|
| Save | Strip trailing whitespace |
| Focus | Auto-reload changed files |
| Save | Auto-create parent directories |
| Yank | Highlight yanked text |
| FileType | Spellcheck for markdown, text, gitcommit |
| Terminal | No line numbers, auto insert mode |
| Resize | Auto-equalize splits |
| BufRead | Restore cursor position |
| Window | Cursorline only in active window |
| Large files | Disable syntax/undo for files > 10MB |
| Insert mode | Disable MatchParen highlighting |
| Diagnostics | Hide virtual text when virtual lines active |
| Session | Unload non-file buffers before save |
| Help | Open help in vertical split |
| Comment | Highlight @param tags in comments |

---

## Custom Filetype Detection

Configured in `init.lua` and `autocmds.lua`:

| Pattern | Filetype |
|---------|----------|
| `*.gs` | JavaScript (Google Apps Script) |
| `*.tf`, `*.tfvars` | Terraform |
| `*.hcl` | HCL |
| `*.jsx` | javascriptreact |
| `*.tsx` | typescriptreact |
| `.env*`, `*.env` | sh |
| Rails shebang scripts | Ruby |

---

## UI & Theme

### Colorscheme

**Bebop** with `spike` preset and transparent background.

### Statusline (lualine)

Custom slate-inspired theme with:
- Mode indicator with distinct colors
- Branch, diff, diagnostics
- Full file path
- Macro recording indicator
- Encoding, format, filetype
- Progress and location

### Bufferline

- Slant separators
- Ordinal numbers
- LSP diagnostics
- Hover effects
- Pick mode with `gb`

### Incline Winbar

Floating winbar showing:
- File icon + name
- LSP breadcrumbs (navic)
- Diagnostics counts
- Git diff stats
- Clock (in focused window)

### Alpha Dashboard

Palestine flag theme with quick actions:
- Find file, New file, Recent files
- Find text, Config, Restore session
- Lazy, Quit

### Noice

- Rounded borders everywhere
- Command palette preset
- Long messages to split

---

## Customization

### Add a Plugin

Create a new file in `lua/yousef/plugins/`:

```lua
-- lua/yousef/plugins/my-plugin.lua
return {
  "author/my-plugin.nvim",
  event = "VeryLazy",
  opts = {
    -- plugin options
  },
}
```

### Modify Options

Edit `lua/yousef/config/options.lua`

### Add Keymaps

Edit `lua/yousef/config/keymaps.lua` or add to plugin specs

### Project-Local Config

Create `.nvim.lua` in project root - it's auto-sourced on `VimEnter`

---

## Troubleshooting

### LSP Not Working

1. Open `:Mason` and ensure servers are installed
2. Check `:LspInfo` for active clients
3. Run `:checkhealth lsp`

### Pickers Slow

Install `ripgrep` and `fd`:
```bash
# macOS
brew install ripgrep fd

# Ubuntu
apt install ripgrep fd-find
```

### Icons Missing

Install a [Nerd Font](https://www.nerdfonts.com/) and configure your terminal

### Copilot Not Working

1. Run `:Copilot auth` to authenticate
2. Check `:Copilot status`

### Format on Save Not Working

1. Check `:ConformInfo` for configured formatters
2. Ensure formatters are installed via Mason

### Large Files Slow

Files > 10MB automatically disable syntax, undo, and folding

### Health Check

Run `:checkhealth` for comprehensive diagnostics

### Logs

- `:Lazy log` - Plugin manager logs
- `:LspLog` - LSP logs
- `~/.local/state/nvim/` - Neovim state directory

---

Made with love — happy hacking!
