require("yousef.config")
require("yousef.lazy")
vim.api.nvim_create_autocmd("VimEnter", { callback = function() require "lazy".update({ show = true }) end })
