-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.copilot_no_tab_map = true

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

-- Folding options (defer to ensure Treesitter is available)
vim.defer_fn(function()
  if vim.treesitter.foldexpr then
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  else
    vim.opt.foldmethod = "indent"
  end
  vim.opt.foldlevel = 99
  vim.opt.foldlevelstart = 99
  vim.opt.foldenable = true
  vim.opt.foldcolumn = "0"
end, 100)

-- Backspace options
opt.backspace = { "start", "eol", "indent" }

-- Separator styling
local separators = {
  thick = { vert = '█', horiz = '█' },
  double = { vert = '┃', horiz = '━' },
  bold = { vert = '║', horiz = '═' },
  blocks = { vert = '▌', horiz = '▄' },
}
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#5a5a5a", bg = "#5a5a5a", bold = true })
vim.api.nvim_set_hl(0, "VertSplit", { fg = "#5a5a5a", bg = "#5a5a5a", bold = true })

-- Use vim.defer_fn to set fillchars after startup
vim.defer_fn(function()
  vim.opt.fillchars:append(separators.blocks)
end, 100)

-- Miscellaneous options
opt.isfname:append("@-@")

-- Defer ColorColumn highlight to ensure it's set after colorscheme
vim.defer_fn(function()
  vim.cmd([[highlight ColorColumn ctermbg=236 guibg=#3a3a3a]])
end, 100)
