-- Basic Options Configuration
local opt = vim.opt

-- Line numbers
opt.number = true              -- Show line numbers
opt.relativenumber = true      -- Show relative line numbers
opt.cursorline = true          -- Highlight current line

-- Indentation
opt.tabstop = 4               -- Number of spaces tabs count for
opt.shiftwidth = 4            -- Size of an indent
opt.expandtab = true          -- Use spaces instead of tabs
opt.smartindent = true        -- Insert indents automatically
opt.autoindent = true         -- Copy indent from current line

-- Search
opt.ignorecase = true         -- Ignore case in search
opt.smartcase = true          -- Override ignorecase if search contains capitals
opt.hlsearch = true           -- Highlight search results
opt.incsearch = true          -- Show search results while typing

-- Appearance
opt.termguicolors = true      -- True color support
opt.signcolumn = "yes"        -- Always show sign column
opt.wrap = false              -- Disable line wrap
opt.scrolloff = 8             -- Lines of context
opt.sidescrolloff = 8         -- Columns of context
opt.colorcolumn = "80"        -- Show column at 80 characters

-- Split behavior
opt.splitbelow = true         -- Put new windows below current
opt.splitright = true         -- Put new windows right of current

-- File handling
opt.backup = false            -- Don't create backup files
opt.writebackup = false       -- Don't create backup before overwriting
opt.swapfile = false          -- Don't create swap files
opt.undofile = true           -- Enable persistent undo
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Performance
opt.updatetime = 250          -- Faster completion
opt.timeoutlen = 1000         -- Time to wait for mapped sequence (increased from 300 to 1000ms)
opt.ttimeoutlen = 10          -- Time to wait for key code sequence

-- Completion
opt.completeopt = "menuone,noselect,noinsert"  -- Better completion experience
opt.pumheight = 10            -- Maximum items in popup menu

-- Misc
opt.mouse = "a"               -- Enable mouse support
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.hidden = true             -- Enable background buffers
opt.showmode = false          -- Don't show mode (we'll use statusline)
opt.laststatus = 3            -- Global statusline

-- Fold settings
opt.foldmethod = "expr"       -- Use expression for folding
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99            -- Start with all folds open
opt.foldenable = true         -- Enable folding
opt.foldtext = ""             -- Use treesitter for fold text

-- Better display for whitespace characters
opt.list = true
opt.listchars = {
    tab = "→ ",
    trail = "·",
    extends = "→",
    precedes = "←",
    nbsp = "␣"
}

-- Create undo directory if it doesn't exist
local undo_dir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undo_dir) == 0 then
    vim.fn.mkdir(undo_dir, "p")
end
