return {
	"ibhagwan/fzf-lua",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local fzf = require("fzf-lua")

		fzf.setup({
			"telescope",
			winopts = {
				height = 0.85,
				width = 0.80,
				row = 0.35,
				col = 0.50,
				border = "rounded",
				preview = {
					border = "border",
					wrap = "nowrap",
					hidden = "nohidden",
					vertical = "down:45%",
					horizontal = "right:60%",
					layout = "flex",
					flip_columns = 120,
				},
			},
			keymap = {
				builtin = {
					["<F1>"] = "toggle-help",
					["<F2>"] = "toggle-fullscreen",
					["<F3>"] = "toggle-preview-wrap",
					["<F4>"] = "toggle-preview",
					["<F5>"] = "toggle-preview-ccw",
					["<F6>"] = "toggle-preview-cw",
					["<S-down>"] = "preview-page-down",
					["<S-up>"] = "preview-page-up",
					["<S-left>"] = "preview-page-reset",
				},
				fzf = {
					["ctrl-z"] = "abort",
					["ctrl-u"] = "unix-line-discard",
					["ctrl-f"] = "half-page-down",
					["ctrl-b"] = "half-page-up",
					["ctrl-a"] = "beginning-of-line",
					["ctrl-e"] = "end-of-line",
					["alt-a"] = "toggle-all",
					["f3"] = "toggle-preview-wrap",
					["f4"] = "toggle-preview",
					["shift-down"] = "preview-page-down",
					["shift-up"] = "preview-page-up",
				},
			},
			previewers = {
				cat = {
					cmd = "cat",
					args = "--number",
				},
				bat = {
					cmd = "bat",
					args = "--style=numbers,changes --color always",
					theme = "Coldark-Dark",
				},
				head = {
					cmd = "head",
					args = nil,
				},
				git_diff = {
					cmd_deleted = "git show HEAD:./{file}",
					cmd_modified = "git diff HEAD {file}",
					cmd_untracked = "git diff --no-index /dev/null {file}",
				},
			},
			files = {
				prompt = "Files❯ ",
				multiprocess = true,
				git_icons = true,
				file_icons = true,
				color_icons = true,
				find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
				rg_opts = "--color=never --files --hidden --follow -g '!.git'",
				fd_opts = "--color=never --type f --hidden --follow --exclude .git",
			},
			grep = {
				prompt = "Rg❯ ",
				input_prompt = "Grep For❯ ",
				multiprocess = true,
				git_icons = true,
				file_icons = true,
				color_icons = true,
				grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e",
				rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
				rg_glob = true,
				glob_flag = "--iglob",
				glob_separator = "%s%-%-",
			},
			args = {
				prompt = "Args❯ ",
				files_only = true,
			},
			oldfiles = {
				prompt = "History❯ ",
				cwd_only = false,
				stat_file = true,
				include_current_session = false,
			},
			buffers = {
				prompt = "Buffers❯ ",
				file_icons = true,
				color_icons = true,
				sort_lastused = true,
				show_unloaded = true,
			},
			tabs = {
				prompt = "Tabs❯ ",
				tab_title = "Tab",
				tab_marker = "<<",
				file_icons = true,
				color_icons = true,
			},
			lines = {
				previewer = "builtin",
				prompt = "Lines❯ ",
				show_preview = true,
				show_unloaded = true,
				no_term_buffers = true,
				fzf_opts = {
					["--delimiter"] = ":",
					["--nth"] = "2..",
					["--tiebreak"] = "index",
				},
			},
			blines = {
				previewer = "builtin",
				prompt = "BLines❯ ",
				show_preview = true,
				no_term_buffers = true,
				fzf_opts = {
					["--delimiter"] = ":",
					["--with-nth"] = "2..",
					["--tiebreak"] = "index",
				},
			},
		})

		-- Register fzf-lua as the ui-select provider
		fzf.register_ui_select()

		-- Set up keymaps that match your telescope configuration
		local function set_keymap(key, cmd, desc)
			vim.keymap.set("n", key, cmd, { desc = desc })
		end

		set_keymap("<leader>fzh", fzf.help_tags, "[S]earch [H]elp")
		set_keymap("<leader>fzk", fzf.keymaps, "[S]earch [K]eymaps")
		set_keymap("<leader>fzf", fzf.files, "[S]earch [F]iles")
		set_keymap("<leader>fzs", fzf.builtin, "[S]earch [S]elect fzf-lua")
		set_keymap("<leader>fzw", fzf.grep_cword, "[S]earch current [W]ord")
		set_keymap("<leader>fzg", fzf.live_grep, "[S]earch by [G]rep")
		set_keymap("<leader>fzd", fzf.diagnostics_document, "[S]earch [D]iagnostics")
		set_keymap("<leader>fzr", fzf.resume, "[S]earch [R]esume")
		set_keymap("<leader>fz.", fzf.oldfiles, '[S]earch Recent Files ("." for repeat)')
		set_keymap("<leader>fzb", fzf.buffers, "[ ] Find existing buffers")


		-- Shortcut for searching Neovim configuration files
		set_keymap("<leader>fn", function()
			fzf.files({ cwd = vim.fn.stdpath("config") })
		end, "[S]earch [N]eovim files")

		-- Additional useful fzf-lua specific commands
		set_keymap("<leader>fzc", fzf.commands, "[S]earch [C]ommands")
		set_keymap("<leader>fzq", fzf.quickfix, "[S]earch [Q]uickfix")
		set_keymap("<leader>fzl", fzf.loclist, "[S]earch [L]oclist")
		set_keymap("<leader>fzj", fzf.jumps, "[S]earch [J]umps")
		set_keymap("<leader>fzm", fzf.marks, "[S]earch [M]arks")
		set_keymap("<leader>fzt", fzf.tabs, "[S]earch [T]abs")

		-- Git integration
		set_keymap("<leader>gzf", fzf.git_files, "[G]it [F]iles")
		set_keymap("<leader>gzc", fzf.git_commits, "[G]it [C]ommits")
		set_keymap("<leader>gzb", fzf.git_bcommits, "[G]it [B]uffer commits")
		set_keymap("<leader>gzs", fzf.git_status, "[G]it [S]tatus")
		set_keymap("<leader>gzt", fzf.git_stash, "[G]it s[T]ash")

		-- LSP integration
		set_keymap("<leader>lr", fzf.lsp_references, "[L]SP [R]eferences")
		set_keymap("<leader>ld", fzf.lsp_definitions, "[L]SP [D]efinitions")
		set_keymap("<leader>li", fzf.lsp_implementations, "[L]SP [I]mplementations")
		set_keymap("<leader>lt", fzf.lsp_typedefs, "[L]SP [T]ype definitions")
		set_keymap("<leader>ls", fzf.lsp_document_symbols, "[L]SP document [S]ymbols")
		set_keymap("<leader>lw", fzf.lsp_workspace_symbols, "[L]SP [W]orkspace symbols")
		set_keymap("<leader>la", fzf.lsp_code_actions, "[L]SP code [A]ctions")
	end,
}

