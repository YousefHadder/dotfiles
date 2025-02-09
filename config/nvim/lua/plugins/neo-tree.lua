return {
	"nvim-neo-tree/neo-tree.nvim",
	opts = {
		filesystem = {
			filtered_items = {
				visible = true, -- Show filtered items by default
				hide_gitignored = true,
				hide_dotfiles = false,
				hide_hidden = false, -- Show hidden files
			},
		},
	},

	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
		vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
		vim.keymap.set("n", "<leader>th", function()
			require("neo-tree.sources.filesystem").toggle_filter()
		end, { desc = "Toggle hidden files in Neo-tree" })
	end,
}
