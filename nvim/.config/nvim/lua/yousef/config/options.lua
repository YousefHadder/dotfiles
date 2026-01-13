local opt = vim.opt
local g = vim.g
local cmd = vim.cmd
local api = vim.api

-- Leader keys
g.mapleader = " "
g.maplocalleader = " "

-- General options
opt.mouse = "a" -- Enable mouse support
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.swapfile = false -- Disable swap files
opt.backup = false -- Disable backup files
opt.undofile = true -- Enable persistent undo
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- UI options
opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.cursorline = true -- Highlight current line
opt.signcolumn = "yes" -- Always show sign column
opt.wrap = true -- Disable line wrapping
opt.scrolloff = 8 -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
opt.colorcolumn = "120" -- Show column at 120 characters
opt.list = true -- Show whitespace characters
opt.listchars = { tab = "→ ", trail = "·", nbsp = "␣" }
opt.laststatus = 3 -- Global statusline
opt.whichwrap = "b,s,h,l,[,]" -- Allow movement across lines with wrap

-- Split options
opt.splitbelow = true -- Open horizontal splits below
opt.splitright = true -- Open vertical splits to the right

-- Tab options
opt.tabclose = "left" -- Focus left tab when closing a tab (0.11+)

-- Search options
opt.ignorecase = true -- Ignore case in search
opt.smartcase = true -- Case sensitive if uppercase present
opt.hlsearch = true -- Highlight search matches
opt.incsearch = true -- Show matches while typing
opt.inccommand = "split" -- Live preview of search and replace

-- Indentation options
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Number of spaces for indentation
opt.tabstop = 2 -- Number of spaces for tab
opt.softtabstop = 2 -- Number of spaces for tab in insert mode
opt.autoindent = true -- Auto indent new lines
opt.smartindent = true -- Smart indentation

-- Completion options
opt.completeopt = { "menu", "menuone", "noselect", "fuzzy" }
opt.pumheight = 10 -- Popup menu height

-- Performance options
opt.updatetime = 50 -- Faster completion
opt.timeoutlen = 300 -- Faster key sequence completion

-- Folding options (treesitter-based, async in 0.11+)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldcolumn = "0"

-- Backspace options
opt.backspace = { "start", "eol", "indent" }

-- Separator styling
local separators = {
	thick = { vert = "█", horiz = "█" },
	double = { vert = "┃", horiz = "━" },
	bold = { vert = "║", horiz = "═" },
	blocks = { vert = "▌", horiz = "▄" },
}

api.nvim_set_hl(0, "VertSplit", { fg = "#5a5a5a", bg = "#5a5a5a", bold = true })
api.nvim_set_hl(0, "WinSeparator", { fg = "#5a5a5a", bg = "#5a5a5a", bold = true })

-- Use vim.defer_fn to set fillchars after startup
vim.defer_fn(function()
	opt.fillchars:append(separators.blocks)
end, 100)

-- Miscellaneous options
opt.isfname:append("@-@")

-- Defer ColorColumn highlight to ensure it's set after colorscheme
vim.defer_fn(function()
	cmd([[highlight ColorColumn ctermbg=236 guibg=#3a3a3a]])
end, 100)

-- Enable true color support
opt.termguicolors = true

-- Set default border for all floating windows (Neovim 0.11+)
opt.winborder = "rounded"

-- Colorscheme is set in plugins/bebop.lua with priority 1000

-- Custom comment color - light gray/white for better visibility on dark background
cmd([[hi Comment guifg=#e0e0e0 gui=italic]])

-- Custom highlight for @param tags in comments
cmd([[hi CommentParam guifg=#00ff7f gui=bold]])

-- Only copy is supported, paste with Ctrl+shift+v
if vim.env.SSH_TTY then
	local osc52 = require("vim.ui.clipboard.osc52")

	local function copy_reg(reg)
		local orig = osc52.copy(reg)
		return function(lines, regtype)
			-- Write to Vim's internal register
			vim.fn.setreg(reg, table.concat(lines, "\n"), regtype)

			-- Send OSC52 to local clipboard
			orig(lines, regtype)
		end
	end

	vim.g.clipboard = {
		name = "OSC 52 with register sync",
		copy = {
			["+"] = copy_reg("+"),
			["*"] = copy_reg("*"),
		},
		-- Do NOT use OSC52 paste, just use internal registers
		paste = {
			["+"] = function()
				return vim.fn.getreg("+"), "v"
			end,
			["*"] = function()
				return vim.fn.getreg("*"), "v"
			end,
		},
	}

	vim.o.clipboard = "unnamedplus"
end
