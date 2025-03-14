-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local api = vim.api
local opts = { noremap = true, silent = true }
local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

-- Disable arrow keys in normal mode
keymap.set("n", "<Up>", "<nop>", { noremap = true, silent = true })
keymap.set("n", "<Down>", "<nop>", { noremap = true, silent = true })
keymap.set("n", "<Left>", "<nop>", { noremap = true, silent = true })
keymap.set("n", "<Right>", "<nop>", { noremap = true, silent = true })

-- Select all
keymap.set("n", "<C-a>", "ggVG")

-- move text up and down
keymap.set("n", "<a-j>", "<esc>:m .+1<cr>==gi", opts) -- Alt-j
keymap.set("n", "<a-k>", "<esc>:m .-2<cr>==gi", opts) -- Alt-k

keymap.set("n", "<leader>r", ":luafile $MYVIMRC<CR>", { noremap = true, silent = true })

api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

keymap.set("n", "<leader>ha", function()
  harpoon:list():add()
end)
keymap.set("n", "<C-e>", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)

keymap.set("n", "<C-1>", function()
  harpoon:list():select(1)
end)
keymap.set("n", "<C-2>", function()
  harpoon:list():select(2)
end)
keymap.set("n", "<C-3>", function()
  harpoon:list():select(3)
end)
keymap.set("n", "<C-4>", function()
  harpoon:list():select(4)
end)

-- Toggle previous & next buffers stored within Harpoon list
keymap.set("n", "<C-S-P>", function()
  harpoon:list():prev()
end)
keymap.set("n", "<C-S-N>", function()
  harpoon:list():next()
end)
