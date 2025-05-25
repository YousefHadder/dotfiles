-- Leader keys
vim.g.maplocalleader = " "
vim.g.mapleader = " "

-- General settings
vim.g.editorconfig = true
vim.g.copilot_no_tab_map = true

-- UI
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "120"
vim.opt.hlsearch = true
vim.opt.mouse = "a"

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = false

-- Files, backups, undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Search
vim.opt.incsearch = true
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Folding
-- Enable folding (setup in nvim-ufo)
vim.o.foldenable = true -- Enable folding by default
vim.o.foldmethod = "manual" -- Default fold method (change as needed)
vim.o.foldlevel = 99 -- Open most folds by default
vim.o.foldcolumn = "0"

-- Backspace
vim.opt.backspace = { "start", "eol", "indent" }

-- Split windows
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom

-- Filename characters
vim.opt.isfname:append("@-@")

-- Performance
vim.opt.updatetime = 50

-- Clipboard
vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default

-- Whitespace and listchars
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
