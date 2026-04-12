-- Install with: brew install lua-language-server

---@type vim.lsp.Config
return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					"${3rd}/luv/library",
				},
			},
			completion = {
				callSnippet = "Replace",
				postfix = ".",
				showWord = "Fallback",
				workspaceWord = true,
			},
			diagnostics = { disable = { "missing-fields" }, globals = { "vim" } },
			hint = {
				enable = true,
				arrayIndex = "Disable",
				await = true,
				paramName = "Disable",
				paramType = true,
				semicolon = "Disable",
				setType = false,
			},
			format = { enable = false }, -- stylua instead
			telemetry = { enable = false },
		},
	},
}
