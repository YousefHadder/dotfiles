-- Install with: npm i -g stylelint-lsp

---@type vim.lsp.Config
return {
	cmd = { "stylelint-lsp", "--stdio" },
	filetypes = { "css", "less", "scss", "sugarss", "vue", "wxss" },
	root_markers = { ".stylelintrc", ".stylelintrc.json", ".stylelintrc.yml", "stylelint.config.js", "stylelint.config.mjs" },
}
