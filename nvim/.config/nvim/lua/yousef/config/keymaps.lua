local keymap = vim.keymap

-- Disable the spacebar key's default behavior in Normal and Visual modes
keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- REQUIRED
keymap.set("i", "jk", "<ESC>", { noremap = true, desc = "Exit insert mode with jk" })

-- Clear search highlight
keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

-- Disable arrow keys in normal mode
keymap.set("n", "<Up>", "<nop>", { noremap = true, silent = true })
keymap.set("n", "<Down>", "<nop>", { noremap = true, silent = true })
keymap.set("n", "<Left>", "<nop>", { noremap = true, silent = true })
keymap.set("n", "<Right>", "<nop>", { noremap = true, silent = true })

-- Select all
keymap.set("n", "vag", "ggVG")

-- -- move text up and down
keymap.set({ "n", "v" }, "<a-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true }) -- Alt-k
keymap.set({ "n", "v" }, "<a-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true }) -- Alt-j

-- source file
keymap.set("n", "<leader>so", "<cmd> so % <CR>", { noremap = true, silent = true, desc = "Source file" })

-- save file
keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- save file without auto-formatting
keymap.set("n", "<leader>sn", "<cmd>noautocmd w <CR>", { noremap = true, silent = true })

-- quit file
keymap.set("n", "<C-q>", "<cmd> q <CR>", { noremap = true, silent = true })

-- delete single character without copying into register
keymap.set("n", "x", '"_x', { noremap = true, silent = true })

-- Vertical scroll and center
keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

-- split window commands
keymap.set("n", "<leader>|", "<cmd>vsplit<CR>", { noremap = true, silent = true }) -- vertical split
keymap.set("n", "<leader>-", "<cmd>split<CR>", { noremap = true, silent = true })  -- horizontal split

-- Move splits
keymap.set('n', '<leader>ml', '<C-w>H', { desc = 'Move split left' })
keymap.set('n', '<leader>md', '<C-w>J', { desc = 'Move split down' })
keymap.set('n', '<leader>mu', '<C-w>K', { desc = 'Move split up' })
keymap.set('n', '<leader>mr', '<C-w>L', { desc = 'Move split right' })

-- Navigate between splits
keymap.set("n", "<C-k>", ":wincmd k<CR>", { noremap = true, silent = true })
keymap.set("n", "<C-j>", ":wincmd j<CR>", { noremap = true, silent = true })
keymap.set("n", "<C-h>", ":wincmd h<CR>", { noremap = true, silent = true })
keymap.set("n", "<C-l>", ":wincmd l<CR>", { noremap = true, silent = true })

-- Find and center
keymap.set("n", "n", "nzzzv", { noremap = true, silent = true })
keymap.set("n", "N", "Nzzzv", { noremap = true, silent = true })

-- Resize with arrows
keymap.set("n", "<Up>", ":resize -2<CR>", { noremap = true, silent = true })
keymap.set("n", "<Down>", ":resize +2<CR>", { noremap = true, silent = true })
keymap.set("n", "<Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })
keymap.set("n", "<Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })

-- Navigate between buffers in order
keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true })
keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })

keymap.set("n", "<leader>bd", ":bdelete!<CR>", { noremap = true, silent = true })   -- close buffer
keymap.set("n", "<leader>bn", "<cmd> enew <CR>", { noremap = true, silent = true }) -- new buffer

-- Toggle line wrapping
keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", { noremap = true, silent = true })

-- Stay in indent mode
keymap.set("v", "<", "<gv", { noremap = true, silent = true })
keymap.set("v", ">", ">gv", { noremap = true, silent = true })

-- remember yanked
keymap.set("v", "p", '"_dp', { noremap = true, silent = true })

keymap.set('i', '<C-w>', '<Plug>(copilot-accept-word)')
keymap.set('i', '<C-l>', '<Plug>(copilot-accept-line)')
keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})

keymap.set(
  "n",
  "<leader>rw",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word cursor is on globally" }
)

keymap.set("n", "<leader>fp", function()
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
