-- Set leader key
vim.g.mapleader = " "

-- For conciseness
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Disable the spacebar key's default behavior in Normal and Visual modes
keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- REQUIRED
keymap.set("i", "jk", "<ESC>", { noremap = true, desc = "Exit insert mode with jk" })

-- Disable arrow keys in normal mode
keymap.set("n", "<Up>", "<nop>", { noremap = true, silent = true })
keymap.set("n", "<Down>", "<nop>", { noremap = true, silent = true })
keymap.set("n", "<Left>", "<nop>", { noremap = true, silent = true })
keymap.set("n", "<Right>", "<nop>", { noremap = true, silent = true })

-- Select all
keymap.set("n", "<C-a>", "ggVG")

-- -- move text up and down
-- keymap.set("n", "<a-k>", "<esc>:m .-2<cr>==gi", opts) -- Alt-k
-- keymap.set("n", "<a-j>", "<esc>:m .+1<cr>==gi", opts) -- Alt-j

keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

-- gitsigns keymaps
keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", opts)
keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", opts)

-- save file
keymap.set({ "i", "x", "n", "s" }, "<C-w>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- save file without auto-formatting
keymap.set("n", "<leader>sn", "<cmd>noautocmd w <CR>", opts)

-- quit file
keymap.set("n", "<C-q>", "<cmd> q <CR>", opts)

-- delete single character without copying into register
keymap.set("n", "x", '"_x', opts)

-- Vertical scroll and center
keymap.set("n", "<C-d>", "<C-d>zz", opts)
keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Find and center
keymap.set("n", "n", "nzzzv", opts)
keymap.set("n", "N", "Nzzzv", opts)

-- Resize with arrows
keymap.set("n", "<Up>", ":resize -2<CR>", opts)
keymap.set("n", "<Down>", ":resize +2<CR>", opts)
keymap.set("n", "<Left>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<Right>", ":vertical resize +2<CR>", opts)

-- Buffers
keymap.set("n", "<Tab>", ":bnext<CR>", opts)
keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
keymap.set("n", "<leader>x", ":bdelete!<CR>", opts) -- close buffer
keymap.set("n", "<leader>b", "<cmd> enew <CR>", opts) -- new buffer

-- Toggle line wrapping
keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- Stay in indent mode
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

-- Keep last yanked when pasting
keymap.set("v", "p", '"_dP', opts)
