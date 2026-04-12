-- Install with: npm i -g typescript typescript-language-server

---@type vim.lsp.Config
return {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "json" },
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json" },
	settings = {
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
			},
		},
		javascript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
			},
		},
	},
}
