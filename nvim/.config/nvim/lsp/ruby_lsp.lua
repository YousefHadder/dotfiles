-- Install with: gem install ruby-lsp

---@type vim.lsp.Config
return {
	cmd = { "ruby-lsp" },
	filetypes = { "ruby", "eruby" },
	root_markers = { "Gemfile", ".ruby-version", ".ruby-gemset" },
	init_options = { formatter = "auto", linters = { "rubocop" } },
}
