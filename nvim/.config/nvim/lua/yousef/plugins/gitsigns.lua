return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		})
		vim.keymap.set("n", "]c", ":Gitsigns next_hunk<CR>", { desc = "Next hunk" })
		vim.keymap.set("n", "[c", ":Gitsigns prev_hunk<CR>", { desc = "Previous hunk" })
	end,
}
