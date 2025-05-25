return {
	"kylechui/nvim-surround",
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	event = "VeryLazy",
	config = function()
		require("nvim-surround").setup({
			keymaps = {
				insert = "<C-g>s",
				insert_line = "<C-g>S",
				normal = "ys",
				normal_cur = "yss",
				normal_line = "yS",
				normal_cur_line = "ySS",
				visual = "S",
				visual_line = "gS",
				delete = "ds",
				change = "cs",
				change_line = "cS",
			},
			surrounds = {
				-- Custom surrounds can be added here
				["("] = {
					add = { "(", ")" },
					find = function()
						return require("nvim-surround.config").get_selection({ motion = "a(" })
					end,
					delete = "^(.).*(.)\r?$",
				},
				[")"] = {
					add = { "( ", " )" },
					find = function()
						return require("nvim-surround.config").get_selection({ motion = "a)" })
					end,
					delete = "^(. ?).*(.? )\r?$",
				},
				["{"] = {
					add = { "{", "}" },
					find = function()
						return require("nvim-surround.config").get_selection({ motion = "a{" })
					end,
					delete = "^(.).*(.)\r?$",
				},
				["}"] = {
					add = { "{ ", " }" },
					find = function()
						return require("nvim-surround.config").get_selection({ motion = "a}" })
					end,
					delete = "^(. ?).*(.? )\r?$",
				},
				["<"] = {
					add = { "<", ">" },
					find = function()
						return require("nvim-surround.config").get_selection({ motion = "a<" })
					end,
					delete = "^(.).*(.)\r?$",
				},
				[">"] = {
					add = { "< ", " >" },
					find = function()
						return require("nvim-surround.config").get_selection({ motion = "a>" })
					end,
					delete = "^(. ?).*(.? )\r?$",
				},
				-- Function call surround
				["f"] = {
					add = function()
						local result = require("nvim-surround.config").get_input("Enter the function name: ")
						if result then
							return { { result .. "(" }, { ")" } }
						end
					end,
					find = function()
						return require("nvim-surround.config").get_selection({ motion = "a(" })
					end,
					delete = "^(.-%()().-(%))()$",
					change = {
						target = "^(.-%()().-(%))()$",
						replacement = function()
							local result = require("nvim-surround.config").get_input("Enter the function name: ")
							if result then
								return { { result .. "(" }, { ")" } }
							end
						end,
					},
				},
			},
		})
	end,
}
