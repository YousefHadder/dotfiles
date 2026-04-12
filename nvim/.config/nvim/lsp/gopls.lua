-- Install with: go install golang.org/x/tools/gopls@latest

---@type vim.lsp.Config
return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.mod", "go.work" },
	settings = {
		gopls = {
			gofumpt = true,
			staticcheck = true,
			usePlaceholders = true,
			analyses = {
				unusedparams = true,
				fieldalignment = true,
				shadow = true,
				useany = true,
			},
			codelenses = {
				test = true,
				tidy = true,
				upgrade_dependency = true,
				generate = true,
			},
			completeUnimported = true,
			directoryFilters = { "-vendor", "-node_modules" },
			buildFlags = { "-tags=integration" },
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
}
