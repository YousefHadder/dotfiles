return {
	-- Mason core - must load first
	{
		"williamboman/mason.nvim",
		lazy = true,
		cmd = {
			"Mason",
			"MasonInstall",
			"MasonUninstall",
			"MasonUninstallAll",
			"MasonLog",
		},
		build = ":MasonUpdate",
		config = function()
			require("mason").setup({
				ui = {
					border = "rounded", -- Use rounded borders for Mason UI
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},

	-- Mason tool installer
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		event = "VeryLazy", -- Defer tool installation
		config = function()
			local mason_tool_installer = require("mason-tool-installer")
			mason_tool_installer.setup({
				ensure_installed = {
					-- LSPs
					"eslint-lsp",
					"gopls",
					"jq-lsp",
					"json-lsp",
					"marksman",
					"lua-language-server",
					"ts_ls",
					"sorbet",
					"stylelint-lsp",
					"yaml-language-server",
					"terraform-ls",
					-- Linters
					"eslint_d",
					"golangci-lint",
					"jsonlint",
					"markdownlint",
					"rubocop",
					"shellcheck",
					"pylint",
					"revive",
					"luacheck",
					-- Formatters
					"goimports",
					"isort",
					"prettierd",
					"prettier",
					"stylua",
				},
				debounce_hours = 96,
				auto_update = false, -- Disable auto-updates for faster startup
			})
		end,
	},

	-- Note: mason-lspconfig and nvim-lspconfig are configured in lsp.lua
}
