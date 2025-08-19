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
keymap("n", "<Up>", ":resize +2<CR>", { noremap = true, silent = true })
keymap("n", "<Down>", ":resize -2<CR>", { noremap = true, silent = true })
keymap("n", "<Left>", ":vertical resize +2<CR>", { noremap = true, silent = true })
keymap("n", "<Right>", ":vertical resize -2<CR>", { noremap = true, silent = true })

-- Split creation
keymap("n", "<leader>|", "<cmd>vsplit <C-w>= <CR>", { noremap = true, silent = true, desc = "Vertical split" })
keymap("n", "<leader>-", "<cmd>split <C-w>=<CR>", { noremap = true, silent = true, desc = "Horizontal split" })

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
keymap("n", "<leader>ot", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap("n", "<leader>ct", "<cmd>tabclose<CR>", { desc = "Close tab" })


-- ======================================================
-- Terminal
-- ======================================================

keymap("n", "<leader>tt", "<cmd>terminal<CR>", { desc = "Open terminal" })
keymap("n", "<leader>tv", "<cmd>vsplit | terminal<CR>", { desc = "Open terminal in vertical split" })
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

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


-- Open all files that are changed (staged/unstaged) or untracked
-- Put this in your keymaps.lua (or wherever you configure mappings)
keymap("n", "<leader>go", function()
  -- Helper to run a shell command and get a list of lines
  local function systemlist(cmd)
    local ok, out = pcall(vim.fn.systemlist, cmd)
    if not ok then return {} end
    if vim.v.shell_error ~= 0 then return {} end
    return out
  end

  -- Quick check: are we inside a git repo?
  if vim.v.shell_error ~= 0 and #systemlist("git rev-parse --is-inside-work-tree 2>/dev/null") == 0 then
    vim.notify("Not a git repository", vim.log.levels.WARN)
    return
  end

  -- Collect paths from:
  -- 1) unstaged changes (worktree vs index)
  -- 2) staged changes (index vs HEAD)
  -- 3) untracked files (respects .gitignore)
  local changed_unstaged = systemlist("git diff --name-only")
  local changed_staged   = systemlist("git diff --name-only --cached")
  local untracked        = systemlist("git ls-files --others --exclude-standard")

  -- In rare cases `git status --porcelain` catches renames/deletes better.
  -- We use it only to filter out deleted paths robustly.
  local status_lines     = systemlist("git status --porcelain=v1 -unormal")

  -- Build a set of deleted (so we don't try to open them)
  local deleted          = {}
  for _, line in ipairs(status_lines) do
    -- Formats:
    --  " D file", "D  file" (deleted), "R  old -> new" (rename), etc.
    local x = line:sub(1, 1)
    local y = line:sub(2, 2)
    local payload = vim.trim(line:sub(4))

    if x == "D" or y == "D" then
      -- deleted tracked file
      if payload:find(" -> ") then
        -- For safety, add both old and new sides as deleted candidates
        local oldp, newp = payload:match("^(.-)%s+->%s+(.-)$")
        if oldp then deleted[oldp] = true end
        if newp then deleted[newp] = true end
      else
        deleted[payload] = true
      end
    end
  end

  -- Merge + dedupe
  local set = {}
  local function add_list(list)
    for _, p in ipairs(list) do
      p = vim.trim(p)
      if p ~= "" and not deleted[p] then
        set[p] = true
      end
    end
  end

  add_list(changed_unstaged)
  add_list(changed_staged)
  add_list(untracked)

  -- Convert to array
  local files = {}
  for p, _ in pairs(set) do
    table.insert(files, p)
  end
  table.sort(files)

  if #files == 0 then
    vim.notify("No changed or untracked files to open.", vim.log.levels.INFO)
    return
  end

  -- Option A: add buffers without jumping around (badd), then open the first
  for _, p in ipairs(files) do
    vim.cmd.badd(vim.fn.fnameescape(p))
  end
  -- Jump to the first file (optional)
  vim.cmd.edit(vim.fn.fnameescape(files[1]))

  -- If you prefer to open each file immediately in the current window instead,
  -- replace the badd/edit block with:
  -- for _, p in ipairs(files) do
  --   vim.cmd.edit(vim.fn.fnameescape(p))
  -- end

  vim.notify(("Opened %d file(s) into buffers."):format(#files), vim.log.levels.INFO)
end, { desc = "Open all changed/staged/untracked files" })

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
