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
	{
		vim.opt.runtimepath:prepend("~/github/markdown-plus.nvim"),
		require("markdown-plus").setup({}),
	},
	-- {
	-- 	"yousefhadder/markdown-plus.nvim",
	-- 	ft = "markdown", -- Load on markdown files by default
	-- 	config = function()
	-- 		require("markdown-plus").setup({
	-- 			-- Configuration options (all optional)
	-- 			enabled = true,
	-- 			features = {
	-- 				list_management = true, -- List management features
	-- 				text_formatting = true, -- Text formatting features
	-- 				headers_toc = true, -- Headers + TOC features
	-- 				links = true, -- Link management features
	-- 				quotes = true, -- Blockquote toggling feature
	-- 				code_block = true, -- Code block conversion feature
	-- 				table = true, -- Table support features
	-- 			},
	-- 			keymaps = {
	-- 				enabled = true, -- Enable default keymaps (<Plug> available for custom)
	-- 			},
	-- 			toc = { -- TOC window configuration
	-- 				initial_depth = 2,
	-- 			},
	-- 			table = { -- Table sub-configuration
	-- 				auto_format = true,
	-- 				default_alignment = "left",
	-- 				keymaps = { enabled = true, prefix = "<leader>t" },
	-- 			},
	-- 			filetypes = { "markdown" }, -- Filetypes to enable the plugin for
	-- 		})
	-- 	end,
	-- },
}
