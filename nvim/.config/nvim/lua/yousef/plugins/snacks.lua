return {
	"folke/snacks.nvim",
	-- dir = "~/github/snacks.nvim/",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		explorer = {
			enabled = true,
			diagnostics = false,
		},
		indent = { enabled = true },
		input = { enabled = true },
		lazygit = {
			enabled = true,
			config = {
				gui = {
					theme = {
						lightTheme = false,
						activeBorderColor = { "#d7875f", "bold" },
						inactiveBorderColor = { "#666666" },
						selectedLineBgColor = { "#333333" },
						cherryPickedCommitBgColor = { "#87d7ff" },
						cherryPickedCommitFgColor = { "#5f87d7" },
						unstagedChangesColor = { "#ff8787" },
						defaultFgColor = { "#ffffff" },
						searchingActiveBorderColor = { "#d7875f", "bold" },
						optionsTextColor = { "#5f87d7" },
						selectedRangeBgColor = { "#333333" },
						inactiveViewSelectedLineBgColor = { "#262626" },
						markedBaseCommitFgColor = { "#5f87d7" },
						markedBaseCommitBgColor = { "#d7d787" },
					},
				},
			},
		},
		gh = {
			-- your gh configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		picker = {
			-- Use fzf-lua for vim.ui.select instead of Snacks
			ui_select = false,
			sources = {
				gh_issue = {
					-- your gh_issue picker configuration comes here
					-- or leave it empty to use the default settings
				},
				gh_pr = {
					-- your gh_pr picker configuration comes here
					-- or leave it empty to use the default settings
				},
			},
		},
		notifier = {
			enabled = true,
			timeout = 3000,
		},
		quickfile = { enabled = true },
		scope = { enabled = true },
		-- scroll = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		styles = {
			notification = {
				-- wo = { wrap = true } -- Wrap notifications
			},
		},
	},
	keys = {
		{
			"<leader>gi",
			function()
				Snacks.picker.gh_issue()
			end,
			desc = "GitHub Issues (open)",
		},
		{
			"<leader>gI",
			function()
				Snacks.picker.gh_issue({ state = "all" })
			end,
			desc = "GitHub Issues (all)",
		},
		{
			"<leader>gp",
			function()
				Snacks.picker.gh_pr()
			end,
			desc = "GitHub Pull Requests (open)",
		},
		{
			"<leader>gP",
			function()
				Snacks.picker.gh_pr({ state = "all" })
			end,
			desc = "GitHub Pull Requests (all)",
		},

		-- Explorer
		{
			"<leader>e",
			function()
				Snacks.explorer({ hidden = true })
			end,
			desc = "File Explorer",
		},
		-- Removed all picker keymaps - now using fzf-lua instead
		-- Other
		{
			"<leader>si",
			function()
				Snacks.picker.icons()
			end,
			desc = "Icon Picker",
		},
		{
			"<leader>z",
			function()
				Snacks.zen()
			end,
			desc = "Toggle Zen Mode",
		},
		{
			"<leader>Z",
			function()
				Snacks.zen.zoom()
			end,
			desc = "Toggle Zoom",
		},
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle Scratch Buffer",
		},
		{
			"<leader>S",
			function()
				Snacks.scratch.select()
			end,
			desc = "Select Scratch Buffer",
		},
		{
			"<leader>n",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History",
		},
		{
			"<leader>bd",
			function()
				Snacks.bufdelete()
			end,
			desc = "Delete Buffer",
		},
		{
			"<leader>cR",
			function()
				Snacks.rename.rename_file()
			end,
			desc = "Rename File",
		},
		{
			"<leader>gB",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Git Browse",
			mode = { "n", "v" },
		},
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>un",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss All Notifications",
		},
		{
			"<c-/>",
			function()
				Snacks.terminal()
			end,
			desc = "Toggle Terminal",
		},
		{
			"<c-_>",
			function()
				Snacks.terminal()
			end,
			desc = "which_key_ignore",
		},
		{
			"]]",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			desc = "Next Reference",
			mode = { "n", "t" },
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			desc = "Prev Reference",
			mode = { "n", "t" },
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Setup some globals for debugging (lazy-loaded)
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end
				vim.print = _G.dd -- Override print to use snacks for `:=` command

				-- Create some toggle mappings
				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
				Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.line_number():map("<leader>ul")
				Snacks.toggle
					.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
					:map("<leader>uc")
				Snacks.toggle.treesitter():map("<leader>uT")
				Snacks.toggle.inlay_hints():map("<leader>uh")
				Snacks.toggle.indent():map("<leader>ug")
				Snacks.toggle.dim():map("<leader>uD")
			end,
		})
	end,
}
