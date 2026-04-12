-- Install with: brew install hashicorp/tap/terraform-ls

---@type vim.lsp.Config
return {
	cmd = { "terraform-ls", "serve" },
	filetypes = { "terraform", "terraform-vars", "hcl" },
	root_markers = { ".terraform", ".terraform.lock.hcl", "*.tf" },
}
