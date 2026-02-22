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

	-- mason-tool-installer and mason-lspconfig are configured in lsp.lua
	-- (single source of truth for all ensure_installed lists)
}
