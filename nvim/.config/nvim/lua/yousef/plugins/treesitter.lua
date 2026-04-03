return {
	-- Parser & query manager (nvim-treesitter 1.0 / main branch)
	-- Highlighting, folding, and indent are now built into Neovim 0.12+.
	-- This plugin only manages parser installation and ships query files.
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup()
			require("nvim-treesitter").install({
				"bash",
				"c",
				"cpp",
				"css",
				"csv",
				"diff",
				"dockerfile",
				"gitignore",
				"go",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"regex",
				"ruby",
				"sql",
				"ssh_config",
				"tmux",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
				"hcl",
				"terraform",
			})

			-- Disable treesitter indent for python (known to cause issues)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "python",
				callback = function()
					vim.bo.indentexpr = ""
				end,
			})
		end,
	},

	-- Treesitter-based textobjects (standalone setup for main branch)
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
				},
			})

			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")

			-- Select textobjects
			local select_maps = {
				-- functions
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				-- classes
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				-- blocks/modules
				["am"] = "@block.outer",
				["im"] = "@block.inner",
				-- conditionals
				["ai"] = "@conditional.outer",
				["ii"] = "@conditional.inner",
				-- loops
				["al"] = "@loop.outer",
				["il"] = "@loop.inner",
				-- parameters
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				-- comments
				["aC"] = "@comment.outer",
				["iC"] = "@comment.inner",
			}

			for key, capture in pairs(select_maps) do
				vim.keymap.set({ "x", "o" }, key, function()
					select.select_textobject(capture, "textobjects")
				end, { desc = "TS: " .. capture })
			end

			-- Move to next/previous function/class
			vim.keymap.set({ "n", "x", "o" }, "]f", function()
				move.goto_next_start("@function.outer", "textobjects")
			end, { desc = "Next function start" })
			vim.keymap.set({ "n", "x", "o" }, "[f", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end, { desc = "Prev function start" })
			vim.keymap.set({ "n", "x", "o" }, "]F", function()
				move.goto_next_end("@function.outer", "textobjects")
			end, { desc = "Next function end" })
			vim.keymap.set({ "n", "x", "o" }, "[F", function()
				move.goto_previous_end("@function.outer", "textobjects")
			end, { desc = "Prev function end" })
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				max_lines = 3,
			})
		end,
	},

	-- highlights function arguments
	{
		"m-demare/hlargs.nvim",
		config = function()
			require("hlargs").setup()
		end,
	},
}
