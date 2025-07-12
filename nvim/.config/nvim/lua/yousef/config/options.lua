-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General options
local opt = vim.opt
opt.mouse = "a"               -- Enable mouse support
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.swapfile = false          -- Disable swap files
opt.backup = false            -- Disable backup files
opt.undofile = true           -- Enable persistent undo
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- UI options
opt.number = true         -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.cursorline = true     -- Highlight current line
opt.signcolumn = "yes"    -- Always show sign column
opt.wrap = false          -- Disable line wrapping
opt.scrolloff = 8         -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8     -- Keep 8 columns left/right of cursor
opt.colorcolumn = "120"   -- Show column at 120 characters
opt.list = true           -- Show whitespace characters
opt.listchars = { tab = "→ ", trail = "·", nbsp = "␣" }

-- Split options
opt.splitbelow = true -- Open horizontal splits below
opt.splitright = true -- Open vertical splits to the right

-- Search options
opt.ignorecase = true    -- Ignore case in search
opt.smartcase = true     -- Case sensitive if uppercase present
opt.hlsearch = true      -- Highlight search matches
opt.incsearch = true     -- Show matches while typing
opt.inccommand = "split" -- Live preview of search and replace

-- Indentation options
opt.expandtab = true   -- Use spaces instead of tabs
opt.shiftwidth = 2     -- Number of spaces for indentation
opt.tabstop = 2        -- Number of spaces for tab
opt.softtabstop = 2    -- Number of spaces for tab in insert mode
opt.autoindent = true  -- Auto indent new lines
opt.smartindent = true -- Smart indentation

-- Completion options
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10 -- Popup menu height

-- Performance options
opt.updatetime = 50  -- Faster completion
opt.timeoutlen = 300 -- Faster key sequence completion

-- Folding options
opt.foldmethod = "expr"     -- Use Treesitter for folding
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99          -- Start with all folds open
opt.foldlevelstart = 99
vim.o.foldenable = true     -- Enable folding by default
vim.o.foldmethod = "manual" -- Default fold method
vim.o.foldcolumn = "0"

-- Backspace options
opt.backspace = { "start", "eol", "indent" }

-- Separator styling
local separators = {
  thick = { vert = '█', horiz = '█' },
  double = { vert = '┃', horiz = '━' },
  bold = { vert = '║', horiz = '═' },
  blocks = { vert = '▌', horiz = '▄' },
}
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#808080", bg = "#808080", bold = true })
vim.api.nvim_set_hl(0, "VertSplit", { fg = "#808080", bg = "#808080", bold = true })
opt.fillchars:append(separators.blocks)

-- Clipboard options
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Miscellaneous options
opt.isfname:append("@-@")
vim.cmd [[highlight ColorColumn ctermbg=236 guibg=#808080]]
