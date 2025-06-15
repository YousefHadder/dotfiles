return {
	"rcarriga/nvim-notify",
	config = function()
		vim.notify = require("notify")
	end,
	vim.keymap.set("n", "<leader>n", function()
		vim.notify("Enhanced notification!", "info", { title = "Neovim" })
	end, { desc = "Show fancy notification" }),
}

-- Then use the same keymap as above
