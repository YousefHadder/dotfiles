-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.wrap = true
vim.opt.smartcase = true
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "Yellow" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#33ff36" })
