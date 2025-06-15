vim.g.maplocalleader = " "
vim.g.mapleader = " "

vim.g.editorconfig = true
vim.g.copilot_no_tab_map = true

vim.opt.nu = true
vim.opt.rnu = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.incsearch = true
vim.opt.inccommand = "split"

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.background = "dark"

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- Enable folding ( setup in nvim-ufo )
vim.o.foldenable = true     -- Enable folding by default
vim.o.foldmethod = "manual" -- Default fold method (change as needed)
vim.o.foldlevel = 99        -- Open most folds by default
vim.o.foldcolumn = "0"

-- backspace
vim.opt.backspace = { "start", "eol", "indent" }

--split windows
vim.opt.splitright = true --split vertical window to the right
vim.opt.splitbelow = true --split horizontal window to the bottom

local separators = {
  thick = { vert = '█', horiz = '█' },
  double = { vert = '┃', horiz = '━' },
  bold = { vert = '║', horiz = '═' },
  blocks = { vert = '▌', horiz = '▄' },
}

-- Apply the style
vim.opt.fillchars:append(separators.thick)

-- make it more visible
vim.api.nvim_set_hl(0, 'winseparator', {
  fg = 'gray', -- adjust color to your theme
  bold = true
})

vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "120"

-- clipboard
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
vim.opt.hlsearch = true

-- for easy mouse resizing, just incase
vim.opt.mouse = "a"

-- gets rid of line with white spaces
-- vim.opt.list = true
-- vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
