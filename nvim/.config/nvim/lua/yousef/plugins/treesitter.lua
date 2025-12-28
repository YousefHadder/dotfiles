return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				sync_install = false,
				ignore_install = {},
				modules = {},

				highlight = { enable = true },
				indent = { enable = true, disable = { "python" } },
				context_commentstring = { enable = true, enable_autocmd = false },

				ensure_installed = {
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
					"yaml",
					"hcl",
					"terraform",
				},

				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = "gnc",
						node_decremental = "gnd",
					},
				},

				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- you wanted this
						keymaps = {
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
						},
					},
				},
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				max_lines = 3, -- your choice (default is unlimited)
				patterns = {
					default = { "class", "function", "method", "for", "while", "if", "switch", "case" },
				},
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
