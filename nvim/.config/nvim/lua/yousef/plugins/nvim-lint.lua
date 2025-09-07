return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- Configure linters by filetype
		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			ruby = { "rubocop" },
			go = { "revive" }, -- Use revive instead of golangci-lint for nvim-lint
			python = { "pylint" },
			bash = { "shellcheck" },
			sh = { "shellcheck" },
			zsh = { "shellcheck" },
		}

		-- Create autocmd group for inting
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		-- Lint on specific events
		vim.api.nvim_create_autocmd({
			"BufEnter",
			"BufWritePost",
			"InsertLeave",
		}, {
			group = lint_augroup,
			callback = function()
				-- Only lint if the buffer has a valid filetype and file exists
				local filetype = vim.bo.filetype
				if filetype and filetype ~= "" and vim.fn.filereadable(vim.fn.expand("%")) == 1 then
					lint.try_lint()
				end
			end,
		})

		-- Manual lint keymap
		vim.keymap.set("n", "<leader>cl", function()
			lint.try_lint()
		end, { desc = "[L]int current file" })
	end,
}

