return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	priority = 1000,
	keys = {
		-- Top level pickers
		{
			"<leader><space>",
			function()
				require("fzf-lua").files({ cwd = vim.fn.getcwd() })
			end,
			desc = "Smart Find Files",
		},
		{
			"<leader>:",
			function()
				require("fzf-lua").command_history()
			end,
			desc = "Command History",
		},

		-- Find operations (leader+f)
		{ "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
		{
			"<leader>fc",
			function()
				require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Find Config File",
		},
		{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files" },
		{ "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Grep" },
		{ "<leader>fo", "<cmd>FzfLua oldfiles<cr>", desc = "Recent Files" },
		{ "<leader>fr", "<cmd>FzfLua resume<cr>", desc = "Resume" },
		{ "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Help Tags" },
		{ "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },

		-- Git operations (leader+g)
		{ "<leader>gb", "<cmd>FzfLua git_branches<cr>", desc = "Git Branches" },
		{ "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Git Commits" },
		{ "<leader>gf", "<cmd>FzfLua git_files<cr>", desc = "Git Files" },
		{ "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Git Status" },
		{
			"<leader>gl",
			function()
				require("fzf-lua").git_commits()
			end,
			desc = "Git Log",
		},
		{
			"<leader>gL",
			function()
				require("fzf-lua").git_bcommits()
			end,
			desc = "Git Log (current file)",
		},
		{
			"<leader>gS",
			function()
				require("fzf-lua").git_stash()
			end,
			desc = "Git Stash",
		},

		-- Search operations (leader+s)
		{
			"<leader>sb",
			function()
				require("fzf-lua").blines()
			end,
			desc = "Buffer Lines",
		},
		{
			"<leader>sB",
			function()
				require("fzf-lua").lgrep_curbuf()
			end,
			desc = "Grep Current Buffer",
		},
		{
			"<leader>sg",
			function()
				require("fzf-lua").live_grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>sw",
			function()
				require("fzf-lua").grep_cword()
			end,
			desc = "Grep Word under Cursor",
			mode = "n",
		},
		{
			"<leader>sw",
			function()
				require("fzf-lua").grep_visual()
			end,
			desc = "Grep Visual Selection",
			mode = "x",
		},
		{
			'<leader>s"',
			function()
				require("fzf-lua").registers()
			end,
			desc = "Registers",
		},
		{
			"<leader>s/",
			function()
				require("fzf-lua").search_history()
			end,
			desc = "Search History",
		},
		{
			"<leader>sa",
			function()
				require("fzf-lua").autocmds()
			end,
			desc = "Autocmds",
		},
		{
			"<leader>sC",
			function()
				require("fzf-lua").commands()
			end,
			desc = "Commands",
		},
		{ "<leader>sd", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Diagnostics" },
		{ "<leader>sD", "<cmd>FzfLua diagnostics_document<cr>", desc = "Buffer Diagnostics" },
		{
			"<leader>sh",
			function()
				require("fzf-lua").help_tags()
			end,
			desc = "Help Pages",
		},
		{
			"<leader>sH",
			function()
				require("fzf-lua").highlights()
			end,
			desc = "Highlights",
		},
		{
			"<leader>sj",
			function()
				require("fzf-lua").jumps()
			end,
			desc = "Jumps",
		},
		{
			"<leader>sk",
			function()
				require("fzf-lua").keymaps()
			end,
			desc = "Keymaps",
		},
		{
			"<leader>sl",
			function()
				require("fzf-lua").loclist()
			end,
			desc = "Location List",
		},
		{
			"<leader>sm",
			function()
				require("fzf-lua").marks()
			end,
			desc = "Marks",
		},
		{
			"<leader>sM",
			function()
				require("fzf-lua").man_pages()
			end,
			desc = "Man Pages",
		},
		{
			"<leader>sp",
			function()
				require("fzf-lua").files({ cwd = vim.fn.stdpath("data") .. "/lazy" })
			end,
			desc = "Search for Plugin Spec",
		},
		{
			"<leader>sq",
			function()
				require("fzf-lua").quickfix()
			end,
			desc = "Quickfix List",
		},
		{
			"<leader>sR",
			function()
				require("fzf-lua").resume()
			end,
			desc = "Resume",
		},
		{
			"<leader>ss",
			function()
				require("fzf-lua").lsp_document_symbols()
			end,
			desc = "LSP Document Symbols",
		},
		{
			"<leader>sS",
			function()
				require("fzf-lua").lsp_live_workspace_symbols()
			end,
			desc = "LSP Workspace Symbols",
		},
		{
			"<leader>uC",
			function()
				require("fzf-lua").colorschemes()
			end,
			desc = "Colorschemes",
		},

		-- LSP operations
		{ "gd", "<cmd>FzfLua lsp_definitions<cr>", desc = "Goto Definition" },
		{ "gD", "<cmd>FzfLua lsp_declarations<cr>", desc = "Goto Declaration" },
		{ "gr", "<cmd>FzfLua lsp_references<cr>", desc = "References", nowait = true },
		{ "gi", "<cmd>FzfLua lsp_implementations<cr>", desc = "Goto Implementation" },
		{ "gy", "<cmd>FzfLua lsp_typedefs<cr>", desc = "Goto Type Definition" },
		{ "<leader>ca", "<cmd>FzfLua lsp_code_actions<cr>", desc = "Code Actions" },
		{ "<leader>ds", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Document Symbols" },
		{ "<leader>ws", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },

		-- Other operations
		{ "<leader>/", "<cmd>FzfLua grep_curbuf<cr>", desc = "Search in Current Buffer" },
	},
	config = function()
		local fzf = require("fzf-lua")

		fzf.setup({
			"default-title",
			-- Global settings
			winopts = {
				height = 0.85,
				width = 0.80,
				row = 0.35,
				col = 0.50,
				border = "rounded",
				fullscreen = false,
				preview = {
					default = "bat",
					border = "border",
					wrap = "nowrap",
					hidden = "nohidden",
					vertical = "down:45%",
					horizontal = "right:60%",
					layout = "flex",
					flip_columns = 120,
					title = true,
					title_pos = "center",
					scrollbar = "float",
					scrolloff = "-2",
					scrollchars = { "█", "" },
					delay = 100,
					winopts = {
						number = true,
						relativenumber = false,
						cursorline = true,
						cursorlineopt = "both",
						cursorcolumn = false,
						signcolumn = "no",
						list = false,
						foldenable = false,
						foldmethod = "manual",
					},
				},
			},
			fzf_opts = {
				["--no-scrollbar"] = true,
				["--no-separator"] = true,
				["--info=inline-right"] = true,
				["--layout=reverse"] = true,
				["--marker=+"] = true,
			},
			fzf_colors = {
				["fg"] = "#ffffff",
				["bg"] = "#262626",
				["hl"] = "#5f87d7",
				["fg+"] = "#ffffff",
				["bg+"] = "#333333",
				["hl+"] = "#87d7ff",
				["info"] = "#d7875f",
				["prompt"] = "#ff8787",
				["pointer"] = "#d7875f",
				["marker"] = "#d7d787",
				["spinner"] = "#5f87d7",
				["header"] = "#666666",
				["border"] = "#666666",
				["separator"] = "#666666",
				["label"] = "#ffffff",
				["query"] = "#ffffff",
				["gutter"] = "#262626",
			},
			keymap = {
				fzf = {
					["ctrl-z"] = "abort",
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
			-- File picker configuration - use fd by default
			files = {
				prompt = "Files❯ ",
				cmd = "fd --type f --hidden --follow --exclude .git",
				multiprocess = true,
				git_icons = true,
				file_icons = true,
				color_icons = true,
				-- Use fd as primary, with fallbacks
				fd_opts = "--color=never --type f --hidden --follow --exclude .git",
				rg_opts = "--color=never --files --hidden --follow -g '!.git'",
				find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
				actions = {
					["default"] = fzf.actions.file_edit_or_qf,
					["ctrl-s"] = fzf.actions.file_split,
					["ctrl-v"] = fzf.actions.file_vsplit,
					["ctrl-t"] = fzf.actions.file_tabedit,
					["alt-q"] = fzf.actions.file_sel_to_qf,
				},
			},
			-- Grep configuration - use rg by default
			grep = {
				prompt = "Rg❯ ",
				input_prompt = "Grep For❯ ",
				cmd = "rg --column --line-number --no-heading --color=always --smart-case --max-columns=4096",
				multiprocess = true,
				git_icons = true,
				file_icons = true,
				color_icons = true,
				rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden --follow -g '!.git' -e",
				rg_glob = true,
				glob_flag = "--iglob",
				glob_separator = "%s%-%-",
				actions = {
					["default"] = fzf.actions.file_edit_or_qf,
					["ctrl-s"] = fzf.actions.file_split,
					["ctrl-v"] = fzf.actions.file_vsplit,
					["ctrl-t"] = fzf.actions.file_tabedit,
					["alt-q"] = fzf.actions.file_sel_to_qf,
				},
			},
			buffers = {
				prompt = "Buffers❯ ",
				file_icons = true,
				color_icons = true,
				sort_lastused = true,
				ignore_current_buffer = false,
				cwd_only = false,
				actions = {
					["default"] = fzf.actions.buf_edit,
					["ctrl-s"] = fzf.actions.buf_split,
					["ctrl-v"] = fzf.actions.buf_vsplit,
					["ctrl-t"] = fzf.actions.buf_tabedit,
					["ctrl-x"] = fzf.actions.buf_del,
				},
			},
			oldfiles = {
				prompt = "History❯ ",
				cwd_only = false,
				stat_file = true,
				include_current_session = true,
			},
			commands = {
				prompt = "Commands❯ ",
				sort_lastused = true,
			},
			help_tags = {
				prompt = "Help❯ ",
			},
			git = {
				files = {
					prompt = "GitFiles❯ ",
					cmd = "git ls-files --exclude-standard",
					multiprocess = true,
					git_icons = true,
					file_icons = true,
					color_icons = true,
				},
				status = {
					prompt = "GitStatus❯ ",
					preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
					cmd = "git status --porcelain=v1",
					file_icons = true,
					git_icons = true,
					color_icons = true,
					actions = {
						["default"] = fzf.actions.file_edit_or_qf,
						["ctrl-s"] = fzf.actions.file_split,
						["ctrl-v"] = fzf.actions.file_vsplit,
						["ctrl-t"] = fzf.actions.file_tabedit,
						["right"] = { fn = fzf.actions.git_unstage, reload = true },
						["left"] = { fn = fzf.actions.git_stage, reload = true },
					},
				},
				commits = {
					prompt = "Commits❯ ",
					cmd = "git log --color=always --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset'",
					preview = "git show --color=always {1}",
					preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
					actions = {
						["default"] = fzf.actions.git_checkout,
						["ctrl-s"] = { fn = fzf.actions.git_switch, reload = true },
						["ctrl-y"] = { fn = fzf.actions.git_yank_commit, reload = true },
					},
				},
				branches = {
					prompt = "Branches❯ ",
					cmd = "git branch --all --color=always",
					preview = "git log --oneline --graph --date=short --color=always --pretty='format:%C(auto)%cd %h%d %s' {1}",
					actions = {
						["default"] = fzf.actions.git_switch,
						["ctrl-x"] = { fn = fzf.actions.git_branch_del, reload = true },
						["ctrl-a"] = { fn = fzf.actions.git_branch_add, field_index = "{q}", reload = true },
					},
				},
			},
			lsp = {
				prompt_postfix = "❯ ",
				cwd_only = false,
				async_or_timeout = 5000,
				file_icons = true,
				git_icons = false,
				color_icons = true,
				includeDeclaration = true,
				symbols = {
					symbol_style = 1,
					symbol_hl_prefix = "CmpItemKind",
					symbol_fmt = function(s)
						return "[" .. s .. "]"
					end,
					child_prefix = false,
				},
				code_actions = {
					prompt = "CodeActions❯ ",
					ui_select = true,
					async_or_timeout = 5000,
					winopts = {
						row = 0.40,
						height = 0.35,
						width = 0.60,
					},
				},
			},
			diagnostics = {
				prompt = "Diagnostics❯ ",
				cwd_only = false,
				file_icons = true,
				git_icons = false,
				color_icons = true,
				diag_icons = true,
				icon_padding = "",
				multiline = true,
				signs = {
					["Error"] = { text = "", texthl = "DiagnosticError" },
					["Warn"] = { text = "", texthl = "DiagnosticWarn" },
					["Info"] = { text = "", texthl = "DiagnosticInfo" },
					["Hint"] = { text = "󰌵", texthl = "DiagnosticHint" },
				},
			},
			complete_path = {
				cmd = nil,
				actions = { ["default"] = fzf.actions.complete_insert },
			},
			complete_file = {
				cmd = nil,
				file_icons = true,
				color_icons = true,
				git_icons = false,
				actions = { ["default"] = fzf.actions.complete_insert },
				winopts = { preview = { hidden = "nohidden" } },
			},
		})

		-- Register as vim.ui.select
		fzf.register_ui_select()
	end,
}
