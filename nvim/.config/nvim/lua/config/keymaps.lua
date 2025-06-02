local keymap = vim.keymap

-- Disable the spacebar key's default behavior in Normal and Visual modes
keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- REQUIRED
keymap.set("i", "jk", "<ESC>", { noremap = true, desc = "Exit insert mode with jk" })

-- Disable arrow keys in normal mode
keymap.set("n", "<Up>", "<nop>", { noremap = true, silent = true })
keymap.set("n", "<Down>", "<nop>", { noremap = true, silent = true })
keymap.set("n", "<Left>", "<nop>", { noremap = true, silent = true })
keymap.set("n", "<Right>", "<nop>", { noremap = true, silent = true })

-- CTRL + motion in insert mode
keymap.set("i", "<C-h>", "<Left>", { noremap = true, silent = true })
keymap.set("i", "<C-l>", "<Right>", { noremap = true, silent = true })
keymap.set("i", "<C-k>", "<Up>", { noremap = true, silent = true })
keymap.set("i", "<C-j>", "<Down>", { noremap = true, silent = true })

-- Clear search highlighting
keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

-- Select all
keymap.set("n", "vag", "ggVG")

-- -- move text up and down
keymap.set({ "n", "v" }, "<a-k>", "<esc>:m .-2<cr>==gv", { noremap = true, silent = true }) -- Alt-k
keymap.set({ "n", "v" }, "<a-j>", "<esc>:m .+1<cr>==gv", { noremap = true, silent = true }) -- Alt-j

-- better up and down
keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- source file
keymap.set("n", "<leader>so", "<cmd>so %<CR>", { noremap = true, silent = true, desc = "Source file" })

-- save file
keymap.set({ "i", "x", "n", "s" }, "<C-w>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- save file without auto-formatting
keymap.set("n", "<leader>sn", "<cmd>noautocmd w <CR>", { noremap = true, silent = true })

-- quit file
keymap.set("n", "<C-q>", "<cmd> q <CR>", { noremap = true, silent = true })

-- delete single character without copying into register
keymap.set("n", "x", '"_x', { noremap = true, silent = true })

-- Vertical scroll and center
keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

-- Navigate between splits
keymap.set({ "n", "v" }, "<C-k>", ":wincmd k<CR>", { noremap = true, silent = true })
keymap.set({ "n", "v" }, "<C-j>", ":wincmd j<CR>", { noremap = true, silent = true })
keymap.set({ "n", "v" }, "<C-h>", ":wincmd h<CR>", { noremap = true, silent = true })
keymap.set({ "n", "v" }, "<C-l>", ":wincmd l<CR>", { noremap = true, silent = true })

-- Find and center
keymap.set("n", "n", "nzzzv", { noremap = true, silent = true })
keymap.set("n", "N", "Nzzzv", { noremap = true, silent = true })

-- Resize with arrows (only when not disabled)
keymap.set("n", "<S-Up>", ":resize -2<CR>", { noremap = true, silent = true })
keymap.set("n", "<S-Down>", ":resize +2<CR>", { noremap = true, silent = true })
keymap.set("n", "<S-Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })
keymap.set("n", "<S-Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })

-- Better window management
keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>wh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close current split" })

-- Tab management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Buffers
keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true })
keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })
keymap.set("n", "<A-h>", "<Cmd>BufferLineMovePrev<CR>", { desc = "Move buffer left" })
keymap.set("n", "<A-l>", "<Cmd>BufferLineMoveNext<CR>", { desc = "Move buffer right" })

keymap.set("n", "<leader>bd", ":bdelete!<CR>", { noremap = true, silent = true }) -- close buffer
keymap.set("n", "<leader>bn", "<cmd> enew <CR>", { noremap = true, silent = true }) -- new buffer

-- Toggle line wrapping
keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", { noremap = true, silent = true })

-- Stay in indent mode
keymap.set("v", "<", "<gv", { noremap = true, silent = true })
keymap.set("v", ">", ">gv", { noremap = true, silent = true })

-- remember yanked
keymap.set("v", "p", '"_dp', { noremap = true, silent = true })
-- keymap.set("i", "<S-Tab>", [[copilot#Accept("\<Tab>")]], {
-- 	silent = true,
-- 	expr = true,
-- 	script = true,
-- 	replace_keycodes = false,
-- })

keymap.set(
  "n",
  "<leader>rw",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word cursor is on globally" }
)

keymap.set("n", "<leader>fp", function()
  local filePath = vim.fn.expand("%:~") -- Gets the file path relative to the home directory
  vim.fn.setreg("+", filePath) -- Copy the file path to the clipboard register
  print("File path copied to clipboard: " .. filePath) -- Optional: print message to confirm
end, { desc = "Copy file path to clipboard" })
