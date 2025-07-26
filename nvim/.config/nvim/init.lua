-- Neovim Configuration by YousefHadder
-- Date: 2025-07-26

-- Load colorscheme first
require('colors.slate').setup()

-- Load configuration modules
require('config.options')
require('config.keymaps')
require('config.autocmds')
require('config.netrw').setup()

-- Load core modules
require('core.completion').setup()
require('core.treesitter').setup()
require('core.statusline').setup()
require('core.lsp').setup()
require('core.formatting').setup()

