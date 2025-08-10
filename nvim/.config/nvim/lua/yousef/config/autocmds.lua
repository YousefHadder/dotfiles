-- lua/yousef/config/autocmds.lua

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Create autocommand groups
local general_group = augroup("GeneralSettings", { clear = true })
local highlight_group = augroup("HighlightYank", { clear = true })
local terminal_group = augroup("TerminalSettings", { clear = true })
local git_group = augroup("GitSettings", { clear = true })
local cursor_group = augroup("CursorSettings", { clear = true })
local ft_detect_group = augroup("FiletypeDetection", { clear = true })
local matchparen_group = augroup("MatchParenSettings", { clear = true })
local persistence_group = augroup("PersistenceSettings", { clear = true })

-- ======================================================
-- General Quality of Life
-- ======================================================

-- Remember last editing position
autocmd("BufReadPost", {
	group = general_group,
	pattern = "*",
	callback = function()
		if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
			vim.cmd('normal! g`"')
		end
	end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
	group = general_group,
	pattern = "*",
	callback = function()
		local save_cursor = vim.fn.getpos(".")
		vim.cmd([[%s/\s\+$//e]])
		vim.fn.setpos(".", save_cursor)
	end,
})

-- Auto-reload files when changed externally
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	group = general_group,
	pattern = "*",
	command = "if mode() != 'c' | checktime | endif",
})

-- Auto create directories before save
autocmd("BufWritePre", {
	group = general_group,
	callback = function(event)
		local file = vim.fn.fnamemodify(event.match, ':p')
		local dir = vim.fn.fnamemodify(file, ":p:h")
		local success, _ = vim.fn.isdirectory(dir)
		if not success then
			vim.fn.system({ "mkdir", "-p", dir })
		end
	end,
})

-- ======================================================
-- Highlighting and Visual Enhancements
-- ======================================================

-- Highlight yanked text
autocmd("TextYankPost", {
	group = highlight_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
	end,
})

-- Automatically enable spellchecking in specific file types
autocmd("FileType", {
	group = general_group,
	pattern = { "markdown", "text", "gitcommit", "tex" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_us"
	end,
})

-- Disable line numbers in terminal
autocmd("TermOpen", {
	group = terminal_group,
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.cmd("startinsert")
	end,
})

-- Auto-resize splits on window resize
autocmd("VimResized", {
	group = general_group,
	callback = function()
		vim.cmd("wincmd =")
	end,
})

-- ======================================================
-- Cursor Position and Movement
-- ======================================================

-- Restore cursor position
autocmd("BufReadPost", {
	group = cursor_group,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Return to last edit position when opening files
autocmd("BufRead", {
	group = cursor_group,
	callback = function()
		local last_pos = vim.fn.line("'\"")
		if last_pos > 0 and last_pos <= vim.fn.line("$") and vim.bo.filetype ~= "commit" then
			vim.cmd("normal! g'\"")
		end
	end,
})

-- Highlight current line only in active window
autocmd({ "BufEnter", "WinEnter" }, {
	group = cursor_group,
	callback = function()
		vim.opt_local.cursorline = true
	end,
})
autocmd("WinLeave", {
	group = cursor_group,
	callback = function()
		vim.opt_local.cursorline = false
	end,
})

-- ======================================================
-- Language-Specific Settings
-- ======================================================

-- Fix jsx file type detection
autocmd({ "BufNewFile", "BufRead" }, {
	group = ft_detect_group,
	pattern = "*.jsx",
	command = "set filetype=javascriptreact",
})

-- Fix tsx file type detection
autocmd({ "BufNewFile", "BufRead" }, {
	group = ft_detect_group,
	pattern = "*.tsx",
	command = "set filetype=typescriptreact",
})

-- Add .env file detection
autocmd({ "BufNewFile", "BufRead" }, {
	group = ft_detect_group,
	pattern = { ".env*", "*.env" },
	command = "set filetype=sh",
})

-- ======================================================
-- Git Integration
-- ======================================================

-- outomatically open quickfix window when running git grep
autocmd("QuickFixCmdPost", {
	group = git_group,
	pattern = "*grep*",
	command = "cwindow",
})

-- Set 72 character line limit in git commit messages
autocmd("FileType", {
	group = git_group,
	pattern = "gitcommit",
	callback = function()
		vim.opt_local.textwidth = 72
		vim.opt_local.colorcolumn = "72"
	end,
})

-- ======================================================
-- Terminal Improvements
-- ======================================================

-- Auto-enter insert mode when switching to a terminal
autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, {
	group = terminal_group,
	pattern = "term://*",
	callback = function()
		vim.cmd("startinsert")
	end,
})

-- Close terminal buffer on process exit
autocmd("TermClose", {
	group = terminal_group,
	callback = function()
		vim.cmd("bdelete!")
	end,
})

-- ======================================================
-- Project Specific
-- ======================================================

-- Load project-specific settings from .nvim.lua if present
autocmd("VimEnter", {
	group = general_group,
	callback = function()
		local project_config = vim.fn.getcwd() .. "/.nvim.lua"
		if vim.fn.filereadable(project_config) == 1 then
			vim.cmd("source " .. project_config)
		end
	end,
})

-- Large file handling
autocmd("BufReadPre", {
	group = general_group,
	callback = function(ev)
		-- Disable certain features for files larger than 10MB
		local max_size = 10 * 1024 * 1024 -- 10MB
		local file_size = vim.fn.getfsize(ev.match)
		if file_size > max_size or file_size == -2 then
			-- Disable features that might slow down Vim
			vim.opt_local.spell = false
			vim.opt_local.undofile = false
			vim.opt_local.swapfile = false
			vim.opt_local.backup = false
			vim.opt_local.writebackup = false
			vim.opt_local.foldenable = false
			vim.g.did_install_syntax_menu = 1
			vim.cmd("syntax clear")
			vim.cmd("syntax off")
			vim.notify("Large file detected. Some features disabled.", vim.log.levels.WARN)
		end
	end,
})

-- ======================================================
-- MatchParen Settings
-- ======================================================

-- Disable MatchParen highlighting in insert mode
autocmd("InsertEnter", {
	group = matchparen_group,
	callback = function()
		vim.api.nvim_set_hl(0, "MatchParen", {})
	end,
})

autocmd("InsertLeave", {
	group = matchparen_group,
	callback = function()
		vim.api.nvim_set_hl(0, "MatchParen", { fg = "#000000", bg = "#ffd700" })
	end,
})

-- Hide diagnostic virtual text when virtual lines are enabled
local og_virt_text
local og_virt_line
autocmd({ "CursorMoved", "DiagnosticChanged" }, {
	group = augroup("DiagnosticVirtualLines", { clear = true }),
	callback = function()
		if og_virt_line == nil then
			og_virt_line = vim.diagnostic.config().virtual_lines
		end

		-- ignore if virtual_lines.current_line is disabled
		if not (og_virt_line and og_virt_line.current_line) then
			if og_virt_text then
				vim.diagnostic.config({ virtual_text = og_virt_text })
				og_virt_text = nil
			end
			return
		end

		if og_virt_text == nil then
			og_virt_text = vim.diagnostic.config().virtual_text
		end

		local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1

		if vim.tbl_isempty(vim.diagnostic.get(0, { lnum = lnum })) then
			vim.diagnostic.config({ virtual_text = og_virt_text })
		else
			vim.diagnostic.config({ virtual_text = false })
		end
	end,
})

autocmd("User", {
	group = persistence_group,
	pattern = "PersistenceSavePre",
	callback = function()
		for _, b in ipairs(vim.api.nvim_list_bufs()) do
			if vim.bo[b].filetype == "copilot-chat"
					or vim.bo[b].filetype == "snacks_picker_list" then
				vim.cmd.bunload(b)
			end
		end
	end,
})

-- Return the module
return {}
