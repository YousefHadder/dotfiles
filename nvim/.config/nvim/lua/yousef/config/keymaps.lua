local keymap = vim.keymap.set

-- ======================================================
-- Essential Mappings
-- ======================================================

-- Disable the spacebar key's default behavior in Normal and Visual modes
keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Use jk instead of Esc
keymap("i", "jk", "<ESC>")

-- Clear search highlighting
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- ======================================================
-- Movement and Navigation
-- ======================================================

-- Better up/down movement
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Keep cursor centered when scrolling
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- Keep cursor centered when searching
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- ======================================================
-- Text Manipulation
-- ======================================================

-- Better indenting
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Move text up and down
keymap({ "n", "v" }, "<a-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
keymap({ "n", "v" }, "<a-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Better paste (doesn't replace clipboard)
keymap("x", "<leader>p", [["_dP]])
keymap("v", "p", '"_dp', { noremap = true, silent = true })

-- Delete single character without copying into register
keymap("n", "x", '"_x', { noremap = true, silent = true })

-- Select All
keymap("n", "vag", "<cmd>keepjumps normal! ggVG<cr>")

-- ======================================================
-- File Operations
-- ======================================================

-- Reload configuration
keymap("n", "<leader>rf", "<cmd>so %<CR>", { silent = true })

-- Quick save and quit
keymap("n", "<leader>wa", "<cmd>write<CR>", { desc = "Save file" })
keymap("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>qall<CR>", { desc = "Quit all" })

-- ======================================================
-- Window Management
-- ======================================================

-- Window navigation
keymap({ "v", "n" }, "<C-h>", "<cmd>wincmd h<CR>", { desc = "Go to left window", silent = true })
keymap({ "v", "n" }, "<C-j>", "<cmd>wincmd j<CR>", { desc = "Go to lower window", silent = true })
keymap({ "v", "n" }, "<C-k>", "<cmd>wincmd k<CR>", { desc = "Go to upper window", silent = true })
keymap({ "v", "n" }, "<C-l>", "<cmd>wincmd l<CR>", { desc = "Go to right window", silent = true })

-- Window resizing
keymap("n", "<Up>", ":resize -2<CR>", { noremap = true, silent = true })
keymap("n", "<Down>", ":resize +2<CR>", { noremap = true, silent = true })
keymap("n", "<Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })
keymap("n", "<Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })

-- Split creation
keymap("n", "<leader>|", "<cmd>vsplit<CR>", { noremap = true, silent = true, desc = "Vertical split" })
keymap("n", "<leader>-", "<cmd>split<CR>", { noremap = true, silent = true, desc = "Horizontal split" })

-- Move splits
keymap('n', '<leader>ml', '<C-w>H', { desc = 'Move split left' })
keymap('n', '<leader>md', '<C-w>J', { desc = 'Move split down' })
keymap('n', '<leader>mu', '<C-w>K', { desc = 'Move split up' })
keymap('n', '<leader>mr', '<C-w>L', { desc = 'Move split right' })

keymap("n", "C-h", ":TmuxNavigateLeft<CR>")
keymap("n", "C-j", ":TmuxNavigateDown<CR>")
keymap("n", "C-k", ":TmuxNavigateUp<CR>")
keymap("n", "C-l", ":TmuxNavigateRight<CR>")


-- ======================================================
-- Buffer and Tab Management
-- ======================================================

-- Buffer navigation
keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true })
keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })
keymap("n", "<leader>bd", ":bdelete!<CR>", { noremap = true, silent = true, desc = "Close buffer" })
keymap("n", "<leader>bn", "<cmd>enew<CR>", { noremap = true, silent = true, desc = "New buffer" })

-- Tab navigation
keymap("n", "[t", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
keymap("n", "]t", "<cmd>tabnext<CR>", { desc = "Next tab" })
keymap("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close tab" })


-- ======================================================
-- Terminal
-- ======================================================

keymap("n", "<leader>tt", "<cmd>terminal<CR>", { desc = "Open terminal" })
keymap("n", "<leader>ts", "<cmd>split | terminal<CR>", { desc = "Open terminal in split" })
keymap("n", "<leader>tv", "<cmd>vsplit | terminal<CR>", { desc = "Open terminal in vertical split" })
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ======================================================
-- Copilot
-- ======================================================

keymap('i', '<C-w>', '<Plug>(copilot-accept-word)')
keymap('i', '<C-l>', '<Plug>(copilot-accept-line)')
keymap('i', '<S-Tab>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})

-- ======================================================
-- Utility Functions
-- ======================================================

-- Global find and replace
keymap(
  "n",
  "<leader>rw",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word cursor is on globally" }
)

-- Copy file path to clipboard
keymap("n", "<leader>cp", function()
  local filePath = vim.fn.expand("%:~")
  vim.fn.setreg("+", filePath)
  print("File path copied to clipboard: " .. filePath)
end, { desc = "Copy file path to clipboard" })

-- ======================================================
-- LSP Cleanup
-- ======================================================

local function clean_lsp_mappings()
  pcall(vim.keymap.del, 'n', 'gd')
  pcall(vim.keymap.del, 'n', 'gD')
  pcall(vim.keymap.del, 'n', 'gr')
  pcall(vim.keymap.del, 'n', 'gI')
  pcall(vim.keymap.del, 'n', 'gy')
end

clean_lsp_mappings()
