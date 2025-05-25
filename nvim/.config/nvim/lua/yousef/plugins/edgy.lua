return {
	"folke/edgy.nvim",
	event = "VeryLazy",
	init = function()
		vim.opt.laststatus = 3
		vim.opt.splitkeep = "screen"
	end,
	keys = {
		{
			"<leader>et",
			function()
				require("edgy").toggle("left")
			end,
			desc = "Left Sidebar",
		},
	},
	opts = {
		exit_when_last = true,
		animate = {
			enabled = false,
		},
		options = {
			left = {
				size = 0.15,
			},
			right = {
				size = 0.15,
			},
		},
		bottom = {
			"Trouble",
			{
				ft = "qf",
				title = "QuickFix",
				size = { height = 30 },
			},
			{
				ft = "help",
				size = { height = 30 },
				-- only show help buffers
				filter = function(buf)
					return vim.bo[buf].buftype == "help"
				end,
			},
			{ ft = "spectre_panel", size = { height = 0.4 } },
		},
		left = {
			{
				title = "Files",
				ft = "neo-tree",
				filter = function(buf)
					return vim.b[buf].neo_tree_source == "filesystem"
				end,
				pinned = true,
				open = "Neotree position=top filesystem",
				size = { height = 0.5 },
			},
			{
				title = "Buffers",
				ft = "neo-tree",
				filter = function(buf)
					return vim.b[buf].neo_tree_source == "buffers"
				end,
				pinned = true,
				open = "Neotree position=bottom buffers",
				size = { height = 0.5 },
			},
		},
		right = {
			{
				ft = "Outline",
				pinned = true,
				open = "OutlineOpen",
				size = { height = 0.5 },
			},
			{
				ft = "neotest-summary",
				pinned = true,
				open = "Tests",
				size = { height = 0.5 },
			},
		},
	},
}
