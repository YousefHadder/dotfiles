-- Keymaps Configuration
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Better escape
keymap("i", "jk", "<ESC>", opts)

-- Save and quit
keymap("n", "<leader>wa", ":w<CR>", opts)
keymap("n", "<leader>q", ":q<CR>", opts)
keymap("n", "<leader>Q", ":qa!<CR>", opts)

-- Better navigation
keymap("n", "<C-h>", "<C-w>h", opts) -- Navigate left
keymap("n", "<C-j>", "<C-w>j", opts) -- Navigate down
keymap("n", "<C-k>", "<C-w>k", opts) -- Navigate up
keymap("n", "<C-l>", "<C-w>l", opts) -- Navigate right

-- Resize windows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Buffer navigation
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<leader>bd", ":bdelete<CR>", opts)
keymap("n", "<leader>ba", ":%bdelete|edit#|bdelete#<CR>", opts) -- Close all but current

-- Move text up and down
keymap("n", "<A-j>", ":m .+1<CR>==", opts)
keymap("n", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Better indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Clear search highlighting
keymap("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Split windows
keymap("n", "<leader>sv", ":vsplit<CR>", opts)  -- Vertical split
keymap("n", "<leader>sh", ":split<CR>", opts)   -- Horizontal split
keymap("n", "<leader>se", "<C-w>=", opts)       -- Equal splits
keymap("n", "<leader>sx", ":close<CR>", opts)   -- Close split

-- Tab management
keymap("n", "<leader>to", ":tabnew<CR>", opts)   -- New tab
keymap("n", "<leader>tx", ":tabclose<CR>", opts) -- Close tab
keymap("n", "<leader>tn", ":tabn<CR>", opts)     -- Next tab
keymap("n", "<leader>tp", ":tabp<CR>", opts)     -- Previous tab

-- Quick fix list
keymap("n", "<leader>co", ":copen<CR>", opts)
keymap("n", "<leader>cc", ":cclose<CR>", opts)
keymap("n", "<leader>cn", ":cnext<CR>", opts)
keymap("n", "<leader>cp", ":cprev<CR>", opts)

-- Location list
keymap("n", "<leader>lo", ":lopen<CR>", opts)
keymap("n", "<leader>lc", ":lclose<CR>", opts)
keymap("n", "<leader>ln", ":lnext<CR>", opts)
keymap("n", "<leader>lp", ":lprev<CR>", opts)

-- Terminal
keymap("n", "<leader>tt", ":terminal<CR>", opts)
keymap("t", "<Esc>", "<C-\\><C-n>", opts) -- Exit terminal mode

-- File explorer (netrw)
keymap("n", "<leader>e", ":Explore<CR>", opts)
keymap("n", "<leader>ve", ":Vexplore<CR>", opts)
keymap("n", "<leader>se", ":Sexplore<CR>", opts)

-- Visual mode mappings
keymap("v", "p", '"_dP', opts) -- Paste without yanking

-- Search and replace
keymap("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", opts)
keymap("v", "<leader>s", ":s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", opts)

-- Yank to system clipboard
keymap("n", "<leader>y", '"+y', opts)
keymap("v", "<leader>y", '"+y', opts)
keymap("n", "<leader>Y", '"+Y', opts)

-- Delete without yanking
keymap("n", "<leader>d", '"_d', opts)
keymap("v", "<leader>d", '"_d', opts)

-- Center cursor when jumping
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

-- Keep cursor in place when joining lines
keymap("n", "J", "mzJ`z", opts)

-- Undo break points
keymap("i", ",", ",<C-g>u", opts)
keymap("i", ".", ".<C-g>u", opts)
keymap("i", "!", "!<C-g>u", opts)
keymap("i", "?", "?<C-g>u", opts)

-- Quick macro execution
keymap("n", "Q", "@q", opts)
keymap("v", "Q", ":norm @q<CR>", opts)

-- Toggle relative line numbers
keymap("n", "<leader>rn", ":set relativenumber!<CR>", opts)

-- Source current file
keymap("n", "<leader><leader>", ":so %<CR>", opts)

-- Folding keymaps
keymap("n", "zR", ":set foldlevel=99<CR>", opts) -- Open all folds
keymap("n", "zM", ":set foldlevel=0<CR>", opts)  -- Close all folds

-- Help keymap
keymap("n", "<leader>?", function()
    print("Key mappings help:")
    print("Leader key: <Space>")
    print("Basic: <leader>w (save), <leader>q (quit)")
    print("Navigation: <C-hjkl> (windows), <S-hl> (buffers)")
    print("LSP: gd (definition), K (hover), <leader>ca (code action)")
    print("Completion: <Tab>/<S-Tab> (navigate), <C-Space> (trigger)")
    print("Formatting: <leader>fm (format), <leader>ft (toggle format on save)")
end, opts)

-- Add these lines to the end of your existing keymaps.lua file:

-- Netrw keymaps
keymap("n", "<leader>nh", function()
    require('config.netrw').toggle_hidden()
end, { desc = "Toggle netrw hidden files" })

keymap("n", "<leader>ns", function()
    require('config.netrw').cycle_style()
end, { desc = "Cycle netrw list style" })

-- Enhanced file explorer keymaps
keymap("n", "<leader>E", ":Explore .<CR>", opts)     -- Open netrw in current directory
keymap("n", "<leader>Ve", ":Vexplore .<CR>", opts)   -- Open netrw in vertical split
keymap("n", "<leader>Se", ":Sexplore .<CR>", opts)   -- Open netrw in horizontal split
keymap("n", "<leader>Te", ":Texplore .<CR>", opts)   -- Open netrw in new tab


-- Which-key style help
keymap("n", "<leader>?", function()
    require('core.whichkey').show_leader_keys()
end, { desc = "Show all leader keymaps" })

