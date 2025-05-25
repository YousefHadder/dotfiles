return {
	"github/copilot.vim",
	event = "InsertEnter",
	config = function()
		vim.g.copilot_no_tab_map = true
		vim.g.copilot_filetypes = {
			["*"] = false,
			["markdown"] = true,
			["text"] = true,
			["gitcommit"] = true,
			["gitrebase"] = true,
			["yaml"] = true,
			["json"] = true,
			["jsonc"] = true,
			["toml"] = true,
			["xml"] = true,
			["css"] = true,
			["html"] = true,
			["javascript"] = true,
			["typescript"] = true,
			["javascriptreact"] = true,
			["typescriptreact"] = true,
			["lua"] = true,
			["go"] = true,
			["java"] = true,
			["c"] = true,
			["cpp"] = true,
			["ruby"] = true,
		}
		vim.api.nvim_set_keymap("i", "<S-Tab>", 'copilot#Accept("<CR>")', { expr = true, silent = true })
	end,
}
