---@diagnostic disable: undefined-global
return {
	"CopilotC-Nvim/CopilotChat.nvim",
	branch = "main",
	dependencies = {
		{ "zbirenbaum/copilot.lua" },
		{ "nvim-lua/plenary.nvim" },
	},
	build = "make tiktoken",
	event = "VeryLazy",
	config = function()
		require("CopilotChat").setup({
			auto_insert_mode = true,
			chat_autocomplete = true,
			show_help = false,
			show_folds = false,
			window = {
				layout = "vertical",
				width = 80,
				height = 20,
				border = "rounded",
				zindex = 100,
			},
			headers = {
				user = "  Yousef ",
				assistant = "  Copilot ",
			},
			model = "claude-sonnet-4.5",
		})
		require("fzf-lua").register_ui_select()
	end,
	keys = {
		{ "<leader>ax", "<cmd>CopilotChatStop<cr>", desc = "CopilotChat - Stop generating" },
		{ "<leader>aa", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle chat window" },
		{
			"<leader>ab",
			function()
				local ok, chat = pcall(require, "CopilotChat")
				if not ok then
					vim.notify("CopilotChat not loaded", vim.log.levels.ERROR)
					return
				end
				-- Custom selection: prefer visual selection, else whole buffer
				chat.toggle({
					selection = function(_)
						local mode = vim.fn.mode()
						if mode:match("[vV\22]") then
							local srow = vim.api.nvim_buf_get_mark(0, "<")[1]
							local erow = vim.api.nvim_buf_get_mark(0, ">")[1]
							local lines = vim.api.nvim_buf_get_lines(0, srow - 1, erow, false)
							return table.concat(lines, "\n")
						else
							return table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
						end
					end,
				})
			end,
			desc = "Toggle Copilot Chat with buffer/visual context",
		},
		{ "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
		{ "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
		{ "<leader>af", "<cmd>CopilotChatFix<cr>", desc = "CopilotChat - Fix" },
		{ "<leader>ao", "<cmd>CopilotChatOptimize<cr>", desc = "CopilotChat - Optimize" },
		{ "<leader>ad", "<cmd>CopilotChatDocs<cr>", desc = "CopilotChat - Add Documentation" },
		{ "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
		{ "<leader>ac", "<cmd>CopilotChatCommit<cr>", desc = "CopilotChat - Commit message" },
		{ "<leader>as", "<cmd>CopilotChatCommitStaged<cr>", desc = "CopilotChat - Commit message (staged)" },
		{ "<leader>am", "<cmd>CopilotChatModel<cr>", desc = "Copilot Chat Models" },
		{
			"<leader>ap",
			function()
				require("CopilotChat").select_prompt({ context = { "buffers" } })
			end,
			desc = "CopilotChat - Prompt actions",
		},
		{
			"<leader>ap",
			function()
				require("CopilotChat").select_prompt()
			end,
			mode = "x",
			desc = "CopilotChat - Prompt actions",
		},

		{
			"<leader>aD",
			function()
				local ok, chat = pcall(require, "CopilotChat")
				if not ok then
					vim.notify("CopilotChat not loaded", vim.log.levels.ERROR)
					return
				end

				local bufnr = vim.api.nvim_get_current_buf()
				local cursor = vim.api.nvim_win_get_cursor(0)
				local lnum0 = cursor[1] - 1
				local line_text = vim.api.nvim_buf_get_lines(bufnr, lnum0, lnum0 + 1, false)[1] or ""
				local diags = vim.diagnostic.get(bufnr, { lnum = lnum0 })

				table.sort(diags, function(a, b)
					return a.severity < b.severity
				end)

				local severity_names = {
					[vim.diagnostic.severity.ERROR] = "Error",
					[vim.diagnostic.severity.WARN] = "Warning",
					[vim.diagnostic.severity.INFO] = "Info",
					[vim.diagnostic.severity.HINT] = "Hint",
				}

				local prompt
				if #diags == 0 then
					prompt = table.concat({
						string.format("No diagnostics on line %d:", lnum0 + 1),
						line_text,
						"Please review this line for potential improvements (readability, correctness, robustness) and suggest a refined version if appropriate.",
					}, "\n")
				else
					local parts = {
						string.format("Analyze diagnostics for line %d:", lnum0 + 1),
						line_text,
						"",
					}
					for _, d in ipairs(diags) do
						table.insert(
							parts,
							string.format(
								"- [%s]%s%s",
								severity_names[d.severity] or ("Severity" .. d.severity),
								d.source and ("(" .. d.source .. ") ") or "",
								d.message:gsub("\n", " ")
							)
						)
					end
					table.insert(parts, "")
					table.insert(
						parts,
						"Explain each issue briefly, propose a fix, and output a corrected version of ONLY this line (and note if adjacent changes are required)."
					)
					prompt = table.concat(parts, "\n")
				end

				local ctx_before, ctx_after = 2, 2
				local start_ctx = math.max(0, lnum0 - ctx_before)
				local end_ctx = math.min(vim.api.nvim_buf_line_count(bufnr), lnum0 + ctx_after + 1)
				local context_lines = vim.api.nvim_buf_get_lines(bufnr, start_ctx, end_ctx, false)

				if chat.toggle then
					chat.toggle()
				end

				vim.schedule(function()
					if chat.ask then
						chat.ask(prompt, {
							context = {
								filename = vim.api.nvim_buf_get_name(bufnr),
								code = table.concat(context_lines, "\n"),
								range = {
									start = { line = start_ctx + 1, character = 0 },
									["end"] = { line = end_ctx, character = 0 },
								},
							},
						})
					else
						vim.notify("CopilotChat.ask not available in this version", vim.log.levels.WARN)
					end
				end)
			end,
			desc = "CopilotChat - Toggle & explain diagnostics for current line",
		},
	},
}
