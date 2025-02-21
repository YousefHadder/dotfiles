return {

	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "ts_ls", "gopls", "ruby_lsp" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")

			lspconfig.zls.setup({
				capabilities = capabilities,
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.gopls.setup({
				capabilities = capabilities,
			})
			lspconfig.ruby_lsp.setup({
				capabilities = capabilities,
				init_options = {
					formatter = "rubocop",
					linters = { "rubocop" },
					enabledFeatures = {
						codeActions = true,
						codeLens = true,
						completion = true,
						definition = true,
						diagnostics = true,
						documentHighlights = true,
						documentLink = true,
						documentSymbols = true,
						foldingRanges = true,
						formatting = true,
						hover = true,
						inlayHint = true,
						onTypeFormatting = true,
						selectionRanges = true,
						semanticHighlighting = true,
						signatureHelp = true,
						typeHierarchy = true,
						workspaceSymbol = true,
					},
					featuresConfiguration = {
						inlayHint = {
							implicitHashValue = true,
							implicitRescue = true,
						},
					},
				},
			})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
		end,
	},
}
