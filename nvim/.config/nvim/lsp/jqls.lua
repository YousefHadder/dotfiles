-- Install with: brew install jq-lsp

---@type vim.lsp.Config
return {
	cmd = { "jq-lsp" },
	filetypes = { "jq" },
	root_markers = { ".git" },
}
