return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
		config = function()
			require("render-markdown").setup({
				completion = {
					blink = {
						enabled = true,
					},
				},
			})

			-- Customize colors for code blocks and inline code
			local function set_render_markdown_hl()
				local ns = 0
				-- Fenced code blocks
				vim.api.nvim_set_hl(ns, "RenderMarkdownCode", { fg = "#c0caf5", bg = "#1f2335" })
				-- Inline `code`
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
	-- 	vim.opt.runtimepath:prepend("~/github/markdown-plus.nvim"),
	-- 	require("markdown-plus").setup(),
	-- },
	{
		"yousefhadder/markdown-plus.nvim",
		config = function()
			require("markdown-plus").setup({})
		end,
	},
}
