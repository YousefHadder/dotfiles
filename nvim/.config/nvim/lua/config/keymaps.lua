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
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

-- the how it be paste
keymap.set("x", "<leader>p", [["_dP]])

-- remember yanked
keymap.set("v", "p", '"_dp', opts)

-- Copies or Yank to system clipboard
keymap.set("n", "<leader>Y", [["+Y]], opts)

-- leader d delete wont remember as yanked/clipboard when delete pasting
keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- delete single character without copying into register
keymap.set("n", "x", '"_x', opts)

-- save file
keymap.set({ "i", "x", "n", "s" }, "<C-w>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- quit file
keymap.set("n", "<C-q>", "<cmd> q <CR>", opts)

-- Vertical scroll and center
keymap.set("n", "<C-d>", "<C-d>zz", opts)
keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Navigate between splits
keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

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

-- Move buffer to the left
keymap.set("n", "<A-h>", ":BufferLineMovePrev<CR>", { silent = true })
-- Move buffer to the right
keymap.set("n", "<A-l>", ":BufferLineMoveNext<CR>", { silent = true })

-- Replace the word cursor is on globally
keymap.set(
  "n",
  "<leader>rg",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word cursor is on globally" }
)

-- Use shit + tab to accept copilot compeletion suggestion.
vim.g.copilot_no_tab_map = true
keymap.set("i", "<S-Tab>", [[copilot#Accept("\<Tab>")]], {
  silent = true,
  expr = true,
  script = true,
  replace_keycodes = false,
})

-- Copy file path to clipboard
keymap.set("n", "<leader>fp", function()
  local filePath = vim.fn.expand("%:~") -- Gets the file path relative to the home directory
  vim.fn.setreg("+", filePath) -- Copy the file path to the clipboard register
  print("File path copied to clipboard: " .. filePath) -- Optional: print message to confirm
end, { desc = "Copy file path to clipboard" })
