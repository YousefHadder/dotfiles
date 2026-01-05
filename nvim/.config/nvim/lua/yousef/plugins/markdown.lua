local use_local_markdown_plus = true

local markdown_plus_spec = {
	ft = { "markdown", "csv" },
	opts = {},
}

if use_local_markdown_plus then
	markdown_plus_spec.dir = "~/github/markdown-plus.nvim"
else
	markdown_plus_spec[1] = "yousefhadder/markdown-plus.nvim"
end

return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
		config = function()
			require("render-markdown").setup({
				latex = { enabled = false },
			})

			local function set_render_markdown_hl()
				local ns = 0
				vim.api.nvim_set_hl(ns, "RenderMarkdownCode", { fg = "#c0caf5", bg = "#1f2335" })
				vim.api.nvim_set_hl(ns, "RenderMarkdownCodeInline", { fg = "#c0caf5", bg = "#1f2335" })
			end

			set_render_markdown_hl()
			vim.api.nvim_create_autocmd("ColorScheme", {
				group = vim.api.nvim_create_augroup("RenderMarkdownHL", { clear = true }),
				callback = set_render_markdown_hl,
			})
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
	markdown_plus_spec,
}
