return {
	"saghen/blink.cmp",
	dependencies = {
		-- Snippet engine
		"rafamadriz/friendly-snippets",
	},
	version = "*",
	event = { "InsertEnter", "CmdlineEnter" },

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' for mappings similar to built-in completion
		-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
		-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
		-- See the full "keymap" documentation for information on defining your own keymap.
		keymap = {
			preset = "default",
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
			["<CR>"] = { "accept", "fallback" },

			["<Tab>"] = {
				function(cmp)
					if cmp.snippet_active() then
						return cmp.snippet_forward()
					else
						return cmp.select_next()
					end
				end,
				"fallback"
			},
			["<S-Tab>"] = {
				function(cmp)
					if cmp.snippet_active() then
						return cmp.snippet_backward()
					else
						return cmp.select_prev()
					end
				end,
				"fallback"
			},

			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },

			["<C-u>"] = { "scroll_documentation_up", "fallback" },
			["<C-d>"] = { "scroll_documentation_down", "fallback" },
		},

		appearance = {
			-- Sets the fallback highlight groups to nvim-cmp's highlight groups
			-- Useful for when your theme doesn't support blink.cmp
			-- Will be removed in a future release
			use_nvim_cmp_as_default = false,
			-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing and ensures icons are aligned
			nerd_font_variant = "mono",

			-- Blink does not expose its default kind icons so you must copy them all (or set use_nvim_cmp_as_default)
			kind_icons = {
				Text = "󰉿",
				Method = "󰆧",
				Function = "󰊕",
				Constructor = "󰡱",
				Field = "󰜢",
				Variable = "󰀫",
				Class = "󰠱",
				Interface = "󰜰",
				Module = "󰏗",
				Property = "󰜢",
				Unit = "󰑭",
				Value = "󰎠",
				Enum = "󰕘",
				Keyword = "󰌋",
				Snippet = "󰆐",
				Color = "󰏘",
				File = "󰈙",
				Reference = "󰈇",
				Folder = "󰉋",
				EnumMember = "󰕘",
				Constant = "󰏿",
				Struct = "󰙅",
				Event = "󱐋",
				Operator = "󰆕",
				TypeParameter = "󰊄",
			}
		},

		completion = {
			-- 'prefix' will fuzzy match on the text before the cursor
			-- 'full' will fuzzy match on the text before and after the cursor
			-- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
			keyword = {
				range = "prefix",
			},

			-- Static list of triggers, or a function(ctx) -> character[]
			-- Set to false to disable
			trigger = {
				show_on_keyword = true,
				show_on_trigger_character = true,
				show_on_accept_on_trigger_character = true,
				show_on_insert_on_trigger_character = true,
				show_in_snippet = true,
			},

			-- Controls how the completion items are selected
			list = {
				-- Controls how the completion items are selected
				-- 'preselect' will automatically select the first item in the completion list
				-- 'manual' will not select any item by default
				-- 'auto_insert' will not select any item by default, and insert the completion items directly
				-- when navigating the completion list
				selection = {
					preselect = true,
					auto_insert = false,
				},
				-- Controls how the completion items are selected when cycling
				-- 'ignore' will not select any item when cycling and only change the displayed item
				-- 'select' will select the item when cycling
				cycle = {
					from_bottom = true,
					from_top = true,
				},
			},

			accept = {
				-- Experimental auto-brackets support
				auto_brackets = {
					enabled = true,
				},
			},
			menu = {
				enabled = true,
				min_width = 15,
				max_height = 10,
				border = "rounded",
				winblend = 0,
				winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
				scrolloff = 2,
				scrollbar = true,
				direction_priority = { "s", "n" },
				auto_show = true,

				draw = {
					columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
				},
			},

			-- Controls the documentation window
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
				update_delay_ms = 50,
				treesitter_highlighting = true,
				window = {
					min_width = 10,
					max_width = 60,
					max_height = 20,
					border = "rounded",
					winblend = 0,
					winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
					scrollbar = true,
				},
			},

			-- Controls the signature help window
			-- signature = {
			-- 	enabled = true,
			-- 	trigger = {
			-- 		blocked_trigger_characters = {},
			-- 		blocked_retrigger_characters = {},
			-- 		show_on_insert_on_trigger_character = true,
			-- 	},
			-- 	window = {
			-- 		min_width = 1,
			-- 		max_width = 100,
			-- 		max_height = 10,
			-- 		border = "rounded",
			-- 		winblend = 0,
			-- 		winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
			-- 		scrollbar = false,
			-- 		direction_priority = { "n", "s" },
			-- 		treesitter_highlighting = true,
			-- 	},
			-- },

			-- Controls the ghost text when selecting a completion item
			ghost_text = {
				enabled = true,
			},
		},
		-- Experimental signature help support
		signature = {
			enabled = true,
		},

		sources = {
			-- Static list of providers, or a function(ctx) -> providers[]
			-- Available providers: lsp, path, snippets, buffer, ripgrep, cmdline
			default = { "lsp", "path", "snippets", "buffer" },

			providers = {
				lsp = {
					name = "LSP",
					module = "blink.cmp.sources.lsp",
					enabled = true,
					min_keyword_length = 0,
					fallbacks = { "buffer" },
					score_offset = 0,
				},
				path = {
					name = "Path",
					module = "blink.cmp.sources.path",
					score_offset = 3,
					fallbacks = { "buffer" },
					opts = {
						trailing_slash = false,
						label_trailing_slash = true,
						show_hidden_files_by_default = false,
					}
				},
				snippets = {
					name = "Snippets",
					module = "blink.cmp.sources.snippets",
					score_offset = -3,
					fallbacks = { "buffer" },
					opts = {
						friendly_snippets = true,
						search_paths = { vim.fn.stdpath("config") .. "/snippets" },
						global_snippets = { "all" },
						extended_filetypes = {},
						ignored_filetypes = {},
					},
				},
				buffer = {
					name = "Buffer",
					module = "blink.cmp.sources.buffer",
					fallbacks = {},
					score_offset = -3,
					opts = {
						-- Show completions from all buffers used within the last x minutes
						get_bufnrs = function()
							return vim.api.nvim_list_bufs()
						end,
					}
				},
			},
		},

		-- Add cmdline configuration as a separate section
		snippets = {
			expand = function(snippet) vim.snippet.expand(snippet) end,
			active = function(filter)
				if filter and filter.direction then
					return vim.snippet.active({ direction = filter.direction })
				end
				return vim.snippet.active()
			end,
			jump = function(direction) vim.snippet.jump(direction) end,
		},
	},

	config = function(_, opts)
		-- Setup blink.cmp with opts
		require("blink.cmp").setup(opts)

		-- Set up slate-themed colors for blink-cmp matching slate.vim
		-- local slate_colors = {
		-- 	bg = "#262626",      -- Normal bg from slate.vim line 29
		-- 	fg = "#ffffff",      -- Normal fg from slate.vim line 29
		-- 	black = "#000000",   -- StatusLine fg from slate.vim line 31
		-- 	blue = "#5f87d7",    -- Statement color from slate.vim line 83
		-- 	border = "#666666",  -- Comment color from slate.vim line 78
		-- 	selection = "#d7d787", -- PmenuSel bg from slate.vim line 37
		-- 	pmenu_bg = "#4a4a4a", -- Pmenu bg from slate.vim line 36
		-- 	white = "#ffffff",
		-- }
		-- -- Blink-cmp highlight groups matching slate.vim exactly
		-- vim.api.nvim_set_hl(0, "BlinkCmpMenu", { fg = slate_colors.fg, bg = slate_colors.pmenu_bg })
		-- vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = slate_colors.border, bg = slate_colors.pmenu_bg })
		-- vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { fg = "#262626", bg = slate_colors.selection }) -- PmenuSel from slate.vim line 37
		-- vim.api.nvim_set_hl(0, "BlinkCmpDoc", { fg = slate_colors.fg, bg = slate_colors.pmenu_bg })
		-- vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = slate_colors.border, bg = slate_colors.pmenu_bg })
		-- vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelp", { fg = slate_colors.fg, bg = slate_colors.pmenu_bg })
		-- vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpBorder", { fg = slate_colors.border, bg = slate_colors.pmenu_bg })

		-- Optional: Set up additional keymaps for snippet navigation outside of completion
		vim.keymap.set({ "i", "s" }, "<C-j>", function()
			if vim.snippet.active({ direction = 1 }) then
				vim.snippet.jump(1)
			end
		end, { desc = "Jump to next snippet placeholder" })

		vim.keymap.set({ "i", "s" }, "<C-k>", function()
			if vim.snippet.active({ direction = -1 }) then
				vim.snippet.jump(-1)
			end
		end, { desc = "Jump to previous snippet placeholder" })
	end,
}
