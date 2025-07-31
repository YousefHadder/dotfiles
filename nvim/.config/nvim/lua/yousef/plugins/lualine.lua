return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		vim.opt.laststatus = 2
		local function show_macro_recording()
			local recording_register = vim.fn.reg_recording()
			if recording_register == "" then
				return ""
			else
				return "Recording @" .. recording_register
			end
		end
		local colors = {
			blue   = '#5f87d7', -- Statement/Type color from slate.vim line 83/86
			cyan   = '#00cdcd', -- darkcyan from slate.vim line 19
			black  = '#000000', -- StatusLine fg from slate.vim line 31
			white  = '#ffffff', -- Normal fg from slate.vim line 29
			red    = '#ff0000', -- Error color from slate.vim line 19
			violet = '#cd00cd', -- darkmagenta from slate.vim line 19
			grey   = '#333333', -- CursorLine bg from slate.vim line 52
			green  = '#00ff00', -- Structure color from slate.vim line 89
			yellow = '#ffd700', -- Define color from slate.vim line 88
		}
		local slate_theme = {
			normal = {
				a = { fg = colors.black, bg = '#afaf87' }, -- StatusLine colors from slate.vim line 31
				b = { fg = colors.white, bg = colors.grey },
				c = { fg = colors.white, bg = '#262626' }, -- Normal bg from slate.vim line 29
			},

			insert = { a = { fg = colors.black, bg = colors.blue } },
			visual = { a = { fg = colors.black, bg = '#87d7ff' } }, -- String color from slate.vim line 79
			replace = { a = { fg = colors.black, bg = '#ff8787' } }, -- Identifier color from slate.vim line 80

			inactive = {
				a = { fg = '#666666', bg = '#262626' }, -- Comment fg, Normal bg from slate.vim
				b = { fg = '#666666', bg = '#262626' },
				c = { fg = '#666666', bg = '#262626' },
			},
		}
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = slate_theme,
				component_separators = '',
				section_separators = { left = '', right = '' },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				always_show_tabline = true,
				globalstatus = false,
				refresh = {
					statusline = 100,
					tabline = 100,
					winbar = 100,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = {
					{
						"filename",
						path = 3,
					}
				},
				lualine_x = {
					{
						show_macro_recording,
						color = { fg = "#ffd700" }, -- Define color from slate.vim line 88
					},
					"encoding",
					"fileformat",
					"filetype"
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = {
					{
						"filename",
						path = 1,
					}
				},
				lualine_x = { "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {},
		})
	end,
}
