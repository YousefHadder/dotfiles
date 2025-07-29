return {
	{
		"folke/tokyonight.nvim",
		enabled = false,
	},
	{
		name = "slate-colorscheme",
		dir = vim.fn.stdpath("config"),
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme slate]])

			-- Slate colorscheme enhancements - matching slate.vim
			local slate_colors = {
				bg = "#19191f",
				fg = "#ebebf4",
				black = "#2e2e2e",
				red = "#cc4455",
				green = "#87af87",
				yellow = "#ffcc99",
				blue = "#566981",
				magenta = "#ffccff",
				cyan = "#89A7B1",
				white = "#ffffff",
				bright_black = "#515166",
				bright_red = "#cc4455",
				bright_green = "#337700",
				bright_yellow = "#ffeecc",
				bright_blue = "#9eb2d9",
				bright_magenta = "#ffccff",
				bright_cyan = "#bbddff",
				comment = "#515166",
				selection = "#557799",
				border = "#89A7B1",
			}

			-- Custom highlight overrides for slate theme
			local highlights = {
				Normal = { fg = slate_colors.fg, bg = "NONE" },
				Comment = { fg = slate_colors.comment, italic = true },
				LineNr = { fg = slate_colors.bright_black },
				CursorLineNr = { fg = slate_colors.yellow, bold = true },
				Visual = { bg = slate_colors.selection },
				Search = { fg = slate_colors.black, bg = slate_colors.yellow },
				IncSearch = { fg = slate_colors.black, bg = slate_colors.bright_yellow },

				-- Diagnostic colors
				DiagnosticError = { fg = slate_colors.red },
				DiagnosticWarn = { fg = slate_colors.yellow },
				DiagnosticInfo = { fg = slate_colors.blue },
				DiagnosticHint = { fg = slate_colors.cyan },

				-- LSP highlights
				LspInlayHint = { fg = slate_colors.comment, italic = true },
				InlayHint = { fg = slate_colors.comment, italic = true },

				-- Floating windows
				NormalFloat = { fg = slate_colors.fg, bg = "NONE" },
				FloatBorder = { fg = slate_colors.border, bg = "NONE" },

				-- Popup menu
				Pmenu = { fg = slate_colors.fg, bg = "NONE" },
				PmenuSel = { fg = slate_colors.black, bg = slate_colors.blue },
				PmenuSbar = { bg = slate_colors.bright_black },
				PmenuThumb = { bg = slate_colors.white },

				-- Neo-tree highlights
				NeoTreeNormal = { fg = slate_colors.fg, bg = "NONE" },
				NeoTreeNormalNC = { fg = slate_colors.fg, bg = "NONE" },
				NeoTreeDirectoryIcon = { fg = slate_colors.blue },
				NeoTreeDirectoryName = { fg = slate_colors.fg },
				NeoTreeFileName = { fg = slate_colors.fg },
				NeoTreeFileIcon = { fg = slate_colors.cyan },
				NeoTreeRootName = { fg = slate_colors.yellow, bold = true },
				NeoTreeGitAdded = { fg = slate_colors.green },
				NeoTreeGitModified = { fg = slate_colors.yellow },
				NeoTreeGitDeleted = { fg = slate_colors.red },
				NeoTreeGitIgnored = { fg = slate_colors.comment },

				-- Bufferline highlights (transparent)
				BufferLineFill = { bg = "NONE" },
				BufferLineBackground = { fg = slate_colors.comment, bg = "NONE" },
				BufferLineBuffer = { fg = slate_colors.fg, bg = "NONE" },
				-- BufferLineBufferSelected = { fg = slate_colors.white, bg = slate_colors.selection, bold = true },
				BufferLineBufferVisible = { fg = slate_colors.fg, bg = "NONE" },
				BufferLineCloseButton = { fg = slate_colors.comment, bg = "NONE" },
				-- BufferLineCloseButtonSelected = { fg = slate_colors.red, bg = slate_colors.selection },
				BufferLineCloseButtonVisible = { fg = slate_colors.comment, bg = "NONE" },
				BufferLineSeparator = { fg = slate_colors.border, bg = "NONE" },
				-- BufferLineSeparatorSelected = { fg = slate_colors.blue, bg = slate_colors.selection },
				BufferLineSeparatorVisible = { fg = slate_colors.border, bg = "NONE" },
				-- BufferLineIndicatorSelected = { fg = slate_colors.blue, bg = slate_colors.selection },
				BufferLineModified = { fg = slate_colors.yellow, bg = "NONE" },
				-- BufferLineModifiedSelected = { fg = slate_colors.yellow, bg = slate_colors.selection },

				-- Telescope highlights
				TelescopeNormal = { fg = slate_colors.fg, bg = "NONE" },
				TelescopeBorder = { fg = slate_colors.border, bg = "NONE" },
				TelescopePromptNormal = { fg = slate_colors.fg, bg = "NONE" },
				TelescopePromptBorder = { fg = slate_colors.border, bg = "NONE" },
				TelescopePromptTitle = { fg = slate_colors.yellow, bold = true },
				TelescopePreviewTitle = { fg = slate_colors.green, bold = true },
				TelescopeResultsTitle = { fg = slate_colors.blue, bold = true },
				TelescopeSelection = { fg = slate_colors.white, bg = slate_colors.selection },
				TelescopeSelectionCaret = { fg = slate_colors.blue },
				TelescopeMatching = { fg = slate_colors.yellow, bold = true },

				ErrorMsg = { fg = slate_colors.red },

				-- Matching parentheses/brackets - subtle background to keep cursor visible
				MatchParen = { bg = slate_colors.bright_black, fg = slate_colors.white },

			}

			for group, opts in pairs(highlights) do
				vim.api.nvim_set_hl(0, group, opts)
			end
		end,
	},
}
