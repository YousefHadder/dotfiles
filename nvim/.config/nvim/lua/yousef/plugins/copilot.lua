return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	dependencies = {
		"zbirenbaum/copilot-cmp",
	},
	config = function()
		require("copilot").setup({
			suggestion = {
				auto_trigger = true,
				keymap = {
					accept = "<S-Tab>",
					accept_word = "<C-w>",
					accept_line = "<C-l>",
				},
			},
		})

		-- Hide Copilot ghost text while Blink's menu is visible
		local grp = vim.api.nvim_create_augroup("CopilotBlinkHarmony", { clear = true })
		vim.api.nvim_create_autocmd("User", {
			pattern = "BlinkCmpMenuOpen",
			group = grp,
			callback = function()
				require("copilot.suggestion").dismiss()
			end,
		})
		vim.api.nvim_create_autocmd("User", {
			pattern = "BlinkCmpMenuClose",
			group = grp,
			callback = function()
				-- Re-enable copilot suggestions after blink menu closes
				vim.defer_fn(function()
					require("copilot.suggestion").next()
				end, 100)
			end,
		})
	end,
}
