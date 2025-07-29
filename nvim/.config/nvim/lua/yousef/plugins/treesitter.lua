return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = { enable = true },
				indent = { enable = true, disable = { "python" } },
				context_commentstring = { enable = true, enable_autocmd = false },
				move = { enable = true },
				select = { enable = true },
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
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj
						keymaps = {
							-- Functions
							["af"] = "@function.outer",
							["if"] = "@function.inner",

							-- Classes
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",

							-- Modules/Blocks
							["am"] = "@block.outer",
							["im"] = "@block.inner",

							-- Conditionals (if/else)
							["ai"] = "@conditional.outer",
							["ii"] = "@conditional.inner",

							-- Loops
							["al"] = "@loop.outer",
							["il"] = "@loop.inner",

							-- Parameters/Arguments
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",

							-- Comments
							["aC"] = "@comment.outer",
							["iC"] = "@comment.inner",
						},
					},
				},
				auto_install = true,
				sync_install = false,
				ignore_install = {},
				modules = {},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = "gnc",
						node_decremental = "gnd",
					},
				},
			})
		end,
	},

	{
		'nvim-treesitter/nvim-treesitter-context',
		config = function()
			require('treesitter-context').setup({
				max_lines = 3,
				patterns = {
					default = {
						'class', 'function', 'method', 'for', 'while', 'if', 'switch', 'case',
					},
				},
			})
		end
	},

	-- Highlights function arguments
	{
		'm-demare/hlargs.nvim',
		config = function()
			require('hlargs').setup()
		end
	}
}
