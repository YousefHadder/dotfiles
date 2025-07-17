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
			"MasonLog"
		},
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
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
					"eslint-lsp",
					"eslint_d",
					"goimports",
					"golangci-lint",
					"gopls",
					"isort",
					"jq-lsp",
					"jsonlint",
					"json-lsp",
					"lua-language-server",
					"ts_ls",
					"prettierd",
					"prettier",
					"rubocop",
					"sorbet",
					"shellcheck",
					"stylelint-lsp",
					"stylua",
					"yaml-language-server",
				},
				debounce_hours = 96,
				auto_update = false, -- Disable auto-updates for faster startup
			})
		end,
	},

	-- Mason LSP Config - depends on mason.nvim
	{
		"williamboman/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig"
		},
		config = function()
			require("mason-lspconfig").setup({
				automatic_installation = true,
				automatic_enable = true, -- Fix diagnostic warning
				ensure_installed = {
					"bashls",
					"cssls",
					"dockerls",
					"eslint",
					"html",
					"jsonls",
					"ts_ls",
					"lua_ls",
					"gopls",
					"ruby_lsp",
				},
			})
		end,
	},

	-- LSP Config
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
	},
}
