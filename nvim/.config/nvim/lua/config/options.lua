-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = false

vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

vim.opt.wrap = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "Yellow" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#33ff36" })
