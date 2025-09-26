# 🧠 Yousef’s Neovim

A fast, modern, and UI‑polished Neovim setup with great defaults, batteries‑included LSP/formatting/testing, Copilot + chat, and slick pickers/explorer — all powered by lazy.nvim.

• Works great for TypeScript/JavaScript, Go, Python, Lua, Bash/Zsh, Ruby, C/C++ and more.

## Table of content

- [🧠 Yousef’s Neovim](#yousefs-neovim)
  - [Table of content](#table-of-content)
  - [🚀 Highlights](#highlights)
  - [📁 Layout](#layout)
  - [⚡ Quick Start](#quick-start)
  - [🧾 Cheat Sheet](#cheat-sheet)
  - [🎮 Keys You’ll Use](#keys-youll-use)
  - [🔌 Plugins (by purpose)](#plugins-by-purpose)
  - [🧠 LSPs, Formatters, and Linters](#lsps-formatters-and-linters)
  - [🎨 UI Notes](#ui-notes)
  - [🔌 MCPHub Integration](#mcphub-integration)
  - [🧱 Treesitter Extras](#treesitter-extras)
  - [🛠️ Customize](#customize)
  - [🔍 Troubleshooting](#troubleshooting)
  - [💡 Tips](#tips)
  - [🤝 Contributing](#contributing)


## 🚀 Highlights

- 💡 Completion: `blink.cmp` with signature help and ghost text
- 🔍 Pickers/Explorer: `folke/snacks.nvim` (unified files, grep, buffers, git, symbols, projects, explorer, terminal)
- 🧰 LSP & Tools: `mason` + `nvim-lspconfig` with smart diagnostics and inlay hints
- 🎨 UI Polish: custom slate‑inspired statusline/tabline, Noice UI with rounded borders, Incline winbars, Alpha dashboard with Palestine flag theme
- 🧪 Testing: `neotest` (Jest, RSpec, Go) with handy keymaps
- 🤖 AI: GitHub Copilot + CopilotChat + MCPHub integration
- 🧭 Navigation: Flash jumps, Which‑Key guides, tmux navigation
- 💾 Sessions: automatic session restore with `persistence.nvim`
- 🛠️ Tools: Snacks provides zen mode, scratch buffers, notifications, and terminal management

## 📁 Layout

```
.config/nvim/
├── init.lua                 # Entrypoint (loads config + lazy)
├── lazy-lock.json          # Plugin lockfile
├── lua/yousef/
│   ├── config/
│   │   ├── init.lua        # Loads options/autocmds/keymaps
│   │   ├── options.lua     # Core options (UI, folds, search, etc.)
│   │   ├── keymaps.lua     # Keymaps (buffers, windows, terminal, Copilot, etc.)
│   │   └── autocmds.lua    # Your autocmds
│   ├── lazy.lua            # lazy.nvim bootstrap + setup
│   └── plugins/            # One file per plugin/spec
└── queries/                # Custom Treesitter queries (Ruby textobjects)
```


## ⚡ Quick Start

**1) Prereqs**
- Neovim 0.9+
- Git, curl
- A Nerd Font (for icons)
- ripgrep (`rg`) and fd (picker performance)
- Node.js, Go, Python (as needed for LSPs/formatters)

**2) Install**
```
git clone <this-repo> ~/.config/nvim
nvim
```

**3) First run**
- lazy.nvim bootstraps and installs everything automatically.

## 🧾 Cheat Sheet

**Navigation & Search**
- `<leader><space>`: smart find files • `<leader>ff`: find files • `<leader>fr`: recent files
- `<leader>sb`/`<leader>fg`: grep lines/files • `<leader>sw`: grep word • `<leader>sB`: grep buffers
- `<leader>fb`: buffers • `<leader>fp`: projects • `<leader>e`: explorer • `<leader>fc`: config files
- `<A-s>`/`<A-S>`: Flash jump/treesitter jump • `gd/gD/gr/gI/gy`: LSP def/decl/refs/impl/type

**Windows, Buffers, Tabs**
- Move focus: `<C-h/j/k/l>` • Split: `<leader>|` (vsplit), `<leader>-` (hsplit)
- Resize: arrow keys • Move split: `<leader>ml/md/mu/mr`
- Buffers: `<Tab>/<S-Tab>` cycle • `<leader>bd` close • `<leader>bn` new • `gb` pick • `<A-h/l>` move buffers
- Tabs: `[t` / `]t` prev/next • `<leader>ot` new • `<leader>ct` close

**LSP & Code**
- `<leader>ca`: code actions • `<leader>th`: toggle inlay hints
- `<leader>cf`: format buffer (Conform)

**Testing (neotest)**
- `<leader>tn`: nearest • `<leader>tf`: file • `<leader>ts`: summary • `<leader>to`: output • `<leader>td`: debug

**Code Execution**
- `<leader>rr`: run current file with code_runner

**Terminal**
- `<leader>tt`: terminal • `<leader>tv`: vsplit • `<C-/>`/`<C-_>`: toggle terminal • `<Esc><Esc>`: exit terminal mode

**Git**
- `<leader>gg`: LazyGit • `<leader>gs`: git status • `<leader>gl`: git log • `<leader>gL`: git log line
- `<leader>gb`: branches • `<leader>gS`: stash • `<leader>gd`: diff hunks • `<leader>gf`: log file
- `<leader>gB`: browse • `<leader>go`: open all changed/staged/untracked files in buffers

**AI**
- Copilot: `<S-Tab>` accept • `<C-w>` word • `<C-l>` line
- CopilotChat: `<leader>aa` toggle • `<leader>ae/ar/af/ao/ad/at` explain/review/fix/opt/docs/tests • `<leader>ac/as` commits
- MCPHub: `<leader>Mh` open interface • `<leader>aM` ask CopilotChat with MCP tools

**Misc**
- `<leader>rw`: replace word under cursor (global) • `<leader>cp`: copy current file path • `<leader>?`: Which‑Key
- `<leader>wa`: save file • `<leader>q`: quit • `<leader>Q`: quit all • `<leader>rf`: reload config
- `<leader>cR`: rename file • `vag`: select all • `]]`/`[[`: next/prev reference • `<leader>z`/`<leader>Z`: zen/zoom

## 🎮 Keys You’ll Use

- Leader: `<Space>` (also localleader)
- Which‑Key: `<leader>?` to discover context keys

**Editing & Movement**
- `jk`: leave insert • `<Esc>`: clear search • `<C-d>/<C-u>`: scroll centered
- `j/k`: move by display line • `<A-j>/<A-k>`: move lines up/down
- Better paste/replace, indentation tweaks, and "select all" via `vag`

**Windows, Buffers, Tabs**
- Navigate windows: `<C-h/j/k/l>` (tmux aware)
- Split: `<leader>|` (vertical), `<leader>-` (horizontal); resize with arrows
- Buffers: `<Tab>/<S-Tab>` cycle • `<leader>bd` close • `<leader>bn` new • `<A-h/l>` move buffers
- Tabs: `[t`/`]t` prev/next • `<leader>ot` new • `<leader>ct` close

**Terminal**
- `<leader>tt` open • `<leader>tv` vsplit • `<C-/>` toggle • `<Esc><Esc>` exit

**Copilot (Insert)**
- `<S-Tab>` accept • `<C-w>` accept word • `<C-l>` accept line

**Snacks Pickers & Explorer**
- Smart find: `<leader><space>` • Files: `<leader>ff` • Recent: `<leader>fr`
- Grep: `<leader>fg` • Lines: `<leader>sb` • Buffers: `<leader>fb` • Projects: `<leader>fp`
- Explorer: `<leader>e` (with hidden files enabled by default)
- LSP: `gd/gD/gr/gI/gy` via Snacks pickers for definitions, declarations, references, implementations, type definitions
- Git: `<leader>gs` status • `<leader>gl` log • `<leader>gb` branches • `<leader>gS` stash • `<leader>gd` diff hunks
- Terminal: `<C-/>` toggle • Notifications: `<leader>n` history • `<leader>un` dismiss all
- Other: `<leader>z` zen mode • `<leader>Z` zoom • `<leader>.` scratch buffer • `<leader>S` select scratch buffer

**LSP & Formatting**
- Code actions: `<leader>ca` • Toggle inlay hints: `<leader>th`
- Format buffer: `<leader>cf` (Conform)

**Testing (neotest)**
- Nearest: `<leader>tn` • File: `<leader>tf` • Summary: `<leader>ts` • Output: `<leader>to` • Debug: `<leader>td`

**Code Execution**
- Run code: `<leader>rr` (code_runner supports multiple languages)

**CopilotChat & MCP**
- Toggle chat: `<leader>aa` • Buffer context: `<leader>ab`
- Explain/Review/Fix/Optimize/Docs/Tests: `<leader>ae`/`ar`/`af`/`ao`/`ad`/`at`
- Commit msgs: `<leader>ac` (all) • `<leader>as` (staged)
- Model switcher: `<leader>am` • Prompt actions: `<leader>ap`
- MCPHub interface: `<leader>Mh` • Ask with MCP tools: `<leader>aM`

**UI Toggles**
- Spell check: `<leader>us` • Wrap: `<leader>uw` • Line numbers: `<leader>ul`
- Relative numbers: `<leader>uL` • Diagnostics: `<leader>ud` • Treesitter: `<leader>uT`
- Inlay hints: `<leader>uh` • Indent guides: `<leader>ug` • Dim: `<leader>uD`
- Notifications: `<leader>n` history • `<leader>un` dismiss all

**Misc**
- Replace word under cursor globally: `<leader>rw`
- Copy current file path: `<leader>cp`
- Save file: `<leader>wa` • Quit: `<leader>q` • Quit all: `<leader>Q`
- Reload config: `<leader>rf` • Rename file: `<leader>cR`

Tip: Which‑Key shows beautiful groups and icons for all `<leader>` menus.

## 🔌 Plugins (by purpose)

**Core & UX**
- 💤 `folke/lazy.nvim`: plugin manager
- 🧰 `nvim-lspconfig`, `mason.nvim`, `mason-lspconfig.nvim`, `mason-tool-installer.nvim`
- 🧩 `folke/which-key.nvim` • `folke/noice.nvim` • `goolord/alpha-nvim` • `b0o/incline.nvim`

**Completion & Editing**
- ✨ `saghen/blink.cmp` (+ `rafamadriz/friendly-snippets`)
- 🧲 `windwp/nvim-autopairs` • 🧱 `kylechui/nvim-surround` • 🧸 `echasnovski/mini.nvim`

**Pickers, Explorer, Git**
- 🔎 `folke/snacks.nvim` (unified pickers, explorer, lazygit integration, notifier, zen mode, terminal, scratch buffers)
- 🌿 `lewis6991/gitsigns.nvim`

**Treesitter & Syntax**
- 🌲 `nvim-treesitter` (+ textobjects/context) • `m-demare/hlargs.nvim`
- 🎨 `norcalli/nvim-colorizer.lua` • `MeanderingProgrammer/render-markdown.nvim`

**Statusline/Bufferline**
- 📊 `nvim-lualine/lualine.nvim` • 🗂️ `akinsho/bufferline.nvim`

**AI & Chat**
- 🤖 `zbirenbaum/copilot.lua` • 💬 `CopilotC-Nvim/CopilotChat.nvim` • 🔌 `ravitemer/mcphub.nvim`

**Testing**
- 🧪 `nvim-neotest/neotest` (+ jest/rspec/go adapters)

**Code Execution**
- 🏃 `CRAG666/code_runner.nvim` (run code directly from editor)

**Sessions & QoL**
- 💾 `folke/persistence.nvim` • 🧭 `christoomey/vim-tmux-navigator`
- 📐 `nmac427/guess-indent.nvim` • 🛍️ `alex-popov-tech/store.nvim`

## 🧠 LSPs, Formatters, and Linters

Installed/managed with Mason + configured via lspconfig/Conform.

**Servers (highlights)**
- TypeScript/JavaScript: `ts_ls` with rich inlay hints and preferences
- Lua: `lua_ls` (Neovim runtime + luv types via `lazydev`)
- Go: `gopls` (analyses, codelenses, hints)
- Python: `pyright`
- Ruby: `ruby_lsp`
- Bash/Zsh: `bashls`
- C/C++: `clangd`
- Markdown: `marksman`

**Formatting (Conform)**
- JS/TS/React: `prettier`/`prettierd` + `eslint_d`
- Python: `isort` + `black`
- Lua: `stylua`
- Go: `goimports` + `gofmt`
- Ruby: `rubocop`
- Shell: `shfmt`
- Others: `clang_format`, `prettier` for css/html/json/yaml/markdown/graphql
- Markdown: `markdownlint` for linting

**Diagnostics UI**
- Clean, sorted diagnostics with icons, rounded floats, and virtual lines
- Inlay hints toggle: `<leader>th`

## 🎨 UI Notes

- Slate‑inspired colors for `lualine` and `bufferline` for a cohesive dark theme
- `incline.nvim` adds a compact winbar with filename, LSP breadcrumbs, diagnostics, git diffs, and a clock
- `alpha.nvim` shows a custom dashboard on launch with Palestine flag ASCII art theme
- `noice.nvim` modernizes messages/cmdline with rounded borders and enhanced presets; notifications via Snacks
- `snacks.nvim` provides unified notifications, zen mode, and terminal management for a cohesive experience

## 🔌 MCPHub Integration

MCPHub provides Model Context Protocol (MCP) server integration for enhanced AI capabilities:

- **Native MCP servers**: Filesystem and Git operations with Lua handlers
- **CopilotChat integration**: MCP tools are automatically converted to CopilotChat functions
- **Tool execution**: Secure tool execution with auto-approval settings
- **Extensible**: Add custom MCP servers via configuration

## 🧱 Treesitter Extras

- Ruby textobjects (`queries/ruby/textobjects.scm`) for functions, classes, blocks, regex, comments, and parameters

## 🛠️ Customize

- Options: edit `lua/yousef/config/options.lua`
- Keymaps: edit `lua/yousef/config/keymaps.lua`
- Plugins: add a new file in `lua/yousef/plugins/` returning a lazy.nvim spec
- lazy.nvim auto‑detects new specs via `lua/yousef/lazy.lua` import

## 🔍 Troubleshooting

- LSP not working: open `:Mason`, ensure servers installed
- Icons missing: use a Nerd Font in your terminal
- Pickers slow/missing results: install `ripgrep` and `fd`
- CopilotChat: ensure `zbirenbaum/copilot.lua` is authenticated
- Health: run `:checkhealth` • Logs: `:Lazy log`

## 💡 Tips

- Press `<leader>` then pause: Which‑Key shows discoverable menus with icons
- Snacks Explorer (`<leader>e`) is minimal, fast, and shows hidden files by default
- Use `<leader><space>` for smart file finding and `<leader>fg` for text search
- Snacks provides unified experience for pickers, terminal (`<C-/>`), notifications, and zen mode
- Telescope is still configured and available for specialized use cases

## 🤝 Contributing

This is a personal configuration, but feel free to:
- Report issues or bugs
- Suggest improvements
- Fork and adapt for your needs
---

Made with ❤️ — happy hacking!
