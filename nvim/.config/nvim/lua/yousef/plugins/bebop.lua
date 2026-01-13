return {
	"ATTron/bebop.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("bebop").setup({
			preset = "spike",
			transparent = true,
			terminal_colors = true,
		})
		vim.cmd([[colorscheme bebop]])
	end,
}
