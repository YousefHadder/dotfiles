return { -- Autocompletion
	"saghen/blink.cmp",
	event = "VimEnter",
	version = "1.*",
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			version = "2.*",
			build = (function()
				return "make install_jsregexp"
			end)(),
			opts = {},
			dependencies = {
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
						-- Load language-specific snippets
						require("luasnip.loaders.from_vscode").lazy_load({ paths = { "~/.config/nvim/snippets" } })
					end,
				},
				-- Add language-specific snippet collections
				"honza/vim-snippets", -- Additional snippet collection
			},
			config = function()
				local luasnip = require("luasnip")
				-- Enable autotrigger for snippets
				luasnip.config.set_config({
					enable_autosnippets = true,
					store_selection_keys = "<Tab>",
				})

				-- Language-specific configurations
				luasnip.filetype_extend("typescript", { "javascript" })
				luasnip.filetype_extend("typescriptreact", { "typescript", "javascript", "javascriptreact" })
				luasnip.filetype_extend("javascriptreact", { "javascript" })
			end,
		},
		"folke/lazydev.nvim",
	},
	opts = {
		keymap = {
			-- See :h blink-cmp-config-keymap for defining your own keymap
			preset = "default",
			['<S-Tab>'] = { 'accept', 'fallback' },
			-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
			--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			menu = {
				border = "rounded",
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 250,
				treesitter_highlighting = true,
				window = {
					border = "rounded",
				},
			},
		},

		sources = {
			default = { "lsp", "path", "snippets", "lazydev", "buffer" },
			providers = {
				lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				buffer = {
					-- Buffer completion for current and visible buffers
					opts = {
						get_bufnrs = function()
							local bufs = {}
							for _, win in ipairs(vim.api.nvim_list_wins()) do
								bufs[vim.api.nvim_win_get_buf(win)] = true
							end
							return vim.tbl_keys(bufs)
						end,
					},
				},
			},
			-- Language-specific source configuration
			per_filetype = {
				lua = { "lsp", "lazydev", "snippets", "path" },
				typescript = { "lsp", "snippets", "path", "buffer" },
				javascript = { "lsp", "snippets", "path", "buffer" },
				ruby = { "lsp", "snippets", "path", "buffer" },
				go = { "lsp", "snippets", "path", "buffer" },
			},
		},
		snippets = { preset = "luasnip" },

		-- See :h blink-cmp-config-fuzzy for more information
		fuzzy = { implementation = "lua" },

		-- Shows a signature help window while you type arguments for a function
		signature = { enabled = true },
	},
}
