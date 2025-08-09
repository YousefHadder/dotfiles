# 🧠 Yousef’s Neovim

A fast, modern, and UI‑polished Neovim setup with great defaults, batteries‑included LSP/formatting/testing, Copilot + chat, and slick pickers/explorer — all powered by lazy.nvim.

• Works great for TypeScript/JavaScript, Go, Python, Lua, Bash/Zsh, Ruby, C/C++ and more.

## 🚀 Highlights

- 💡 Completion: `blink.cmp` with signature help and ghost text
- 🔍 Pickers/Explorer: `folke/snacks.nvim` (files, grep, buffers, git, symbols, projects) + built‑in explorer
- 🧰 LSP & Tools: `mason` + `nvim-lspconfig` with smart diagnostics and inlay hints
- 🎨 UI Polish: custom slate‑inspired statusline/tabline, Noice UI, Incline winbars, Alpha dashboard
- 🧪 Testing: `neotest` (Jest, RSpec, Go) with handy keymaps
- 🤖 AI: GitHub Copilot + CopilotChat
- 🧭 Navigation: Flash jumps, Which‑Key guides, tmux navigation
- 💾 Sessions: automatic session restore with `persistence.nvim`

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

1) Prereqs
- Neovim 0.9+
- Git, curl
- A Nerd Font (for icons)
- ripgrep (`rg`) and fd (picker performance)
- Node.js, Go, Python (as needed for LSPs/formatters)

2) Install
```
git clone <this-repo> ~/.config/nvim
nvim
```

3) First run
- lazy.nvim bootstraps and installs everything automatically.

## 🧾 Cheat Sheet

Navigation & Search
- `<leader>ff`: files • `<leader>fr`: recent • `<leader>fg`: git files
- `<leader>/`: grep • `<leader>fb`: buffers • `<leader>fp`: projects • `<leader>e`: explorer
- `s`/`S`: Flash jump/treesitter jump • `gd/gD/gr/gI/gy`: LSP def/decl/refs/impl/type

Windows, Buffers, Tabs
- Move focus: `<C-h/j/k/l>` • Split: `<leader>|` (vsplit), `<leader>-` (hsplit)
- Resize: arrow keys • Move split: `<leader>ml/md/mu/mr`
- Buffers: `<Tab>/<S-Tab>` cycle • `<leader>bd` close • `<leader>bn` new • `gb` pick
- Tabs: `[t` / `]t` prev/next • `<leader>tn` new • `<leader>tc` close

LSP & Code
- `<leader>ca`: code actions • `<leader>th`: toggle inlay hints
- `<leader>cf`: format buffer (Conform)

Testing (neotest)
- `<leader>tn`: nearest • `<leader>tf`: file • `<leader>ts`: summary • `<leader>to`: output • `<leader>td`: debug

Terminal
- `<leader>tt`: terminal • `<leader>ts`: split • `<leader>tv`: vsplit • `<Esc><Esc>`: exit terminal mode

Git
- `<leader>gg`: LazyGit • `<leader>gs`: git status • `<leader>gl`: git log • `<leader>gP`: praise

AI
- Copilot: `<S-Tab>` accept • `<C-w>` word • `<C-l>` line
- CopilotChat: `<leader>aa` toggle • `<leader>ae/ar/af/ao/ad/at` explain/review/fix/opt/docs/tests • `<leader>ac/as` commits

Misc
- `<leader>rw`: replace word under cursor (global) • `<leader>cp`: copy current file path • `<leader>?`: Which‑Key

## 🎮 Keys You’ll Use

- Leader: `<Space>` (also localleader)
- Which‑Key: `<leader>?` to discover context keys

Editing & Movement
- `jk`: leave insert • `<Esc>`: clear search • `<C-d>/<C-u>`: scroll centered
- `j/k`: move by display line • `<A-j>/<A-k>`: move selection
- Better paste/replace, indentation tweaks, and “select all” via `vag`

Windows, Buffers, Tabs
- Navigate windows: `<C-h/j/k/l>` (tmux aware)
- Split: `<leader>|` (vertical), `<leader>-` (horizontal); resize with arrows
- Buffers: `<Tab>/<S-Tab>` cycle • `<leader>bd` close • `<leader>bn` new
- Tabs: `[t`/`]t` prev/next • `<leader>tn` new • `<leader>tc` close

Terminal
- `<leader>tt` open • `<leader>ts` split • `<leader>tv` vsplit • `<Esc><Esc>` exit

Copilot (Insert)
- `<S-Tab>` accept • `<C-w>` accept word • `<C-l>` accept line

Snacks Pickers & Explorer
- Files: `<leader>ff` • Recent: `<leader>fr` • Git files: `<leader>fg`
- Grep: `<leader>/` • Buffers: `<leader>fb` • Projects: `<leader>fp`
- Explorer: `<leader>e` (hidden files enabled)
- LSP: `gd/gD/gr/gI/gy` via Snacks pickers

LSP & Formatting
- Code actions: `<leader>ca` • Toggle inlay hints: `<leader>th`
- Format buffer: `<leader>cf` (Conform)

Testing (neotest)
- Nearest: `<leader>tn` • File: `<leader>tf` • Summary: `<leader>ts` • Output: `<leader>to` • Debug: `<leader>td`

CopilotChat
- Toggle chat: `<leader>aa`
- Explain/Review/Fix/Optimize/Docs/Tests: `<leader>ae`/`ar`/`af`/`ao`/`ad`/`at`
- Commit msgs: `<leader>ac` (all) • `<leader>as` (staged)
- Model switcher: `<leader>am` • Prompt actions: `<leader>ap`

Misc
- Replace word under cursor globally: `<leader>rw`
- Copy current file path: `<leader>cp`

Tip: Which‑Key shows beautiful groups and icons for all `<leader>` menus.

## 🔌 Plugins (by purpose)

Core & UX
- 💤 `folke/lazy.nvim`: plugin manager
- 🧰 `nvim-lspconfig`, `mason.nvim`, `mason-lspconfig.nvim`, `mason-tool-installer.nvim`
- 🧩 `folke/which-key.nvim` • `folke/noice.nvim` • `goolord/alpha-nvim` • `b0o/incline.nvim`

Completion & Editing
- ✨ `saghen/blink.cmp` (+ `rafamadriz/friendly-snippets`)
- 🧲 `windwp/nvim-autopairs` • 🧱 `kylechui/nvim-surround` • 🧸 `echasnovski/mini.nvim`

Pickers, Explorer, Git
- 🔎 `folke/snacks.nvim` (pickers/explorer/lazygit/notifier/zen/scratch)
- 🌿 `lewis6991/gitsigns.nvim`

Treesitter & Syntax
- 🌲 `nvim-treesitter` (+ textobjects/context) • `m-demare/hlargs.nvim`
- 🎨 `norcalli/nvim-colorizer.lua` • `MeanderingProgrammer/render-markdown.nvim`

Statusline/Bufferline
- 📊 `nvim-lualine/lualine.nvim` • 🗂️ `akinsho/bufferline.nvim`

AI & Chat
- 🤖 `github/copilot.vim` • 💬 `CopilotC-Nvim/CopilotChat.nvim`

Testing
- 🧪 `nvim-neotest/neotest` (+ jest/rspec/go adapters)

Sessions & QoL
- 💾 `folke/persistence.nvim` • 🧭 `christoomey/vim-tmux-navigator`
- 📐 `nmac427/guess-indent.nvim` • 🛍️ `alex-popov-tech/store.nvim`

## 🧠 LSPs, Formatters, and Linters

Installed/managed with Mason + configured via lspconfig/Conform.

Servers (highlights)
- TypeScript/JavaScript: `ts_ls` with rich inlay hints and preferences
- Lua: `lua_ls` (Neovim runtime + luv types via `lazydev`)
- Go: `gopls` (analyses, codelenses, hints)
- Python: `pyright`
- Ruby: `ruby_lsp`
- Bash/Zsh: `bashls`
- C/C++: `clangd`

Formatting (Conform)
- JS/TS/React: `prettier`/`prettierd` + `eslint_d`
- Python: `isort` + `black`
- Lua: `stylua`
- Go: `goimports` + `gofmt`
- Ruby: `rubocop`
- Shell: `shfmt`
- Others: `clang_format`, `prettier` for css/html/json/yaml/markdown/graphql

Diagnostics UI
- Clean, sorted diagnostics with icons, rounded floats, and virtual lines
- Inlay hints toggle: `<leader>th`

## 🎨 UI Notes

- Slate‑inspired colors for `lualine` and `bufferline` for a cohesive dark theme
- `incline.nvim` adds a compact winbar with filename, LSP breadcrumbs, diagnostics, git diffs, and a clock
- `alpha.nvim` shows a custom dashboard on launch (with themed ASCII header)
- `noice.nvim` modernizes messages/cmdline; notifications via Snacks

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
- CopilotChat: ensure `github/copilot.vim` is authenticated
- Health: run `:checkhealth` • Logs: `:Lazy log`

## 💡 Tips

- Press `<leader>` then pause: Which‑Key shows discoverable menus with icons
- Snacks Explorer is minimal and fast; use `<leader>e` and `<leader>gg` for LazyGit
- Telescope is configured and available when you need it; Snacks is the default day‑to‑day picker

## 🤝 Contributing

This is a personal configuration, but feel free to:
- Report issues or bugs
- Suggest improvements
- Fork and adapt for your needs
---

Made with ❤️ — happy hacking!
