return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			close_if_last_window = false,
			popup_border_style = "rounded",
			enable_git_status = true,
			window = {
				position = "left",
				width = 30,
				mappings = {
					["j"] = "next_sibling",
					["k"] = "prev_sibling",
					["h"] = "close_node",
					["l"] = "open",
					["<C-v>"] = "open_vsplit",
					["<C-x>"] = "open_split",
					["<C-t>"] = "open_tabnew",
				},
			},
			vim.keymap.set("n", "-", function()
				local reveal_file = vim.fn.expand("%:p")
				if reveal_file == "" then
					reveal_file = vim.fn.getcwd()
				else
					local f = io.open(reveal_file, "r")
					if f then
						f.close(f)
					else
						reveal_file = vim.fn.getcwd()
					end
				end
				require("neo-tree.command").execute({
					action = "focus", -- OPTIONAL, this is the default value
					source = "filesystem", -- OPTIONAL, this is the default value
					position = "left", -- OPTIONAL, this is the default value
					reveal_file = reveal_file, -- path to file or folder to reveal
					reveal_force_cwd = true, -- change cwd without asking if needed
				})
			end, { desc = "Open neo-tree at current file or working directory" }),

			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
				},
			},
		})
	end,
}
