-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G", opts)

-- move text up and down
keymap.set("n", "<a-j>", "<esc>:m .+1<cr>==gi", opts) -- Alt-j
keymap.set("n", "<a-k>", "<esc>:m .-2<cr>==gi", opts) -- Alt-k

keymap.set("n", "<leader>r", ":luafile $MYVIMRC<CR>", { noremap = true, silent = true })
