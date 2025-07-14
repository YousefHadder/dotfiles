local keymap = vim.keymap.set

-- Disable the spacebar key's default behavior in Normal and Visual modes
keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Use jk instead of Esc
keymap("i", "jk", "<ESC>")

-- Reload
keymap("n", "<leader>rf", "<cmd> so % <CR>", { silent = true })

-- Select All
keymap("n", "vag", "<cmd>keepjumps normal! ggVG<cr>")

-- Better up/down movement
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Clear search highlighting
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Better indenting
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Move text up and down
keymap({ "n", "v" }, "<a-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true }) -- Alt-k
keymap({ "n", "v" }, "<a-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true }) -- Alt-j

-- Keep cursor centered when scrolling
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- Keep cursor centered when searching
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- Better paste (doesn't replace clipboard)
keymap("x", "<leader>p", [["_dP]])

-- remember yanked
keymap("v", "p", '"_dp', { noremap = true, silent = true })

-- delete single character without copying into register
keymap("n", "x", '"_x', { noremap = true, silent = true })

-- Window navigation
keymap({ "v", "n" }, "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap({ "v", "n" }, "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap({ "v", "n" }, "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap({ "v", "n" }, "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize with arrows
keymap("n", "<Up>", ":resize -2<CR>", { noremap = true, silent = true })
keymap("n", "<Down>", ":resize +2<CR>", { noremap = true, silent = true })
keymap("n", "<Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })
keymap("n", "<Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })

-- Buffer navigation
keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true })
keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })
keymap("n", "<leader>bd", ":bdelete!<CR>", { noremap = true, silent = true })   -- close buffer
keymap("n", "<leader>bn", "<cmd> enew <CR>", { noremap = true, silent = true }) -- new buffer

-- Tab navigation
keymap("n", "[t", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
keymap("n", "]t", "<cmd>tabnext<CR>", { desc = "Next tab" })
keymap("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close tab" })

-- split window commands
keymap("n", "<leader>|", "<cmd>vsplit<CR>", { noremap = true, silent = true }) -- vertical split
keymap("n", "<leader>-", "<cmd>split<CR>", { noremap = true, silent = true })  -- horizontal split

-- Move splits
keymap('n', '<leader>ml', '<C-w>H', { desc = 'Move split left' })
keymap('n', '<leader>md', '<C-w>J', { desc = 'Move split down' })
keymap('n', '<leader>mu', '<C-w>K', { desc = 'Move split up' })
keymap('n', '<leader>mr', '<C-w>L', { desc = 'Move split right' })

-- Navigate between splits
keymap("n", "<C-k>", ":wincmd k<CR>", { noremap = true, silent = true })
keymap("n", "<C-j>", ":wincmd j<CR>", { noremap = true, silent = true })
keymap("n", "<C-h>", ":wincmd h<CR>", { noremap = true, silent = true })
keymap("n", "<C-l>", ":wincmd l<CR>", { noremap = true, silent = true })

-- Terminal
keymap("n", "<leader>tt", "<cmd>terminal<CR>", { desc = "Open terminal" })
keymap("n", "<leader>ts", "<cmd>split | terminal<CR>", { desc = "Open terminal in split" })
keymap("n", "<leader>tv", "<cmd>vsplit | terminal<CR>", { desc = "Open terminal in vertical split" })
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Quick save and quit
keymap("n", "<leader>wa", "<cmd>write<CR>", { desc = "Save file" })
keymap("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>qall<CR>", { desc = "Quit all" })

keymap(
  "n",
  "<leader>rw",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word cursor is on globally" }
)

keymap("n", "<leader>cp", function()
  local filePath = vim.fn.expand("%:~")                -- Gets the file path relative to the home directory
  vim.fn.setreg("+", filePath)                         -- Copy the file path to the clipboard register
  print("File path copied to clipboard: " .. filePath) -- Optional: print message to confirm
end, { desc = "Copy file path to clipboard" })


local function clean_lsp_mappings()
  -- Remove custom LSP mappings that conflict with defaults
  pcall(vim.keymap.del, 'n', 'gd')
  pcall(vim.keymap.del, 'n', 'gD')
  pcall(vim.keymap.del, 'n', 'gr')
  pcall(vim.keymap.del, 'n', 'gI')
  pcall(vim.keymap.del, 'n', 'gy')
end

-- Call this after your LSP setup
clean_lsp_mappings()
