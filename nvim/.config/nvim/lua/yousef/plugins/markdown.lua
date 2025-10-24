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
		build = "cd app && npm install",
		ft = "markdown",
		config = function()
			vim.g.mkdp_auto_start = 0
			vim.g.mkdp_auto_close = 1
			vim.g.mkdp_refresh_slow = 0
			vim.g.mkdp_command_for_global = 0
			vim.g.mkdp_open_to_the_world = 0
			vim.g.mkdp_browser = ""
			vim.g.mkdp_echo_preview_url = 0
			vim.g.mkdp_page_title = "Preview - %s"
		end,
	},
	{
		vim.opt.runtimepath:prepend("~/github/markdown-plus.nvim"),
		require("markdown-plus").setup(),
	},
	-- {
	-- 	"yousefhadder/markdown-plus.nvim",
	-- 	config = function()
	-- 		require("markdown-plus").setup({})
	-- 	end,
	-- },
}
