return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"giuxtaposition/blink-cmp-copilot",
	},
	version = "*",
	event = { "InsertEnter", "CmdlineEnter" },
	build = "cargo build --release",
	opts = {
		keymap = {
			preset = "default",
			["<CR>"] = { "accept", "fallback" },
			["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		fuzzy = { implementation = "prefer_rust" },

		completion = {
			trigger = {
				signature = {
					enabled = false,
				},
				show_on_insert_on_trigger_character = false,
				show_on_keyword = false,
			},

			list = { selection = { preselect = false, auto_insert = false } },

			menu = {
				border = "rounded",
				auto_show = false,
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
				window = { max_width = 60, border = "rounded" },
			},
		},

		signature = { enabled = true },

		sources = {
			default = { "lsp", "path", "snippets", "buffer", "copilot" },
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-cmp-copilot",
					score_offset = 100,
					async = true,
				},
			},
		},

		cmdline = {
			enabled = true,
			keymap = { preset = "default" },
		},

	},

	config = function(_, opts)
		require("blink.cmp").setup(opts)

		-- keep if you like these snippet jumps
		vim.keymap.set({ "i", "s" }, "<C-j>", function()
			if vim.snippet.active({ direction = 1 }) then vim.snippet.jump(1) end
		end, { desc = "Jump to next snippet placeholder" })

		vim.keymap.set({ "i", "s" }, "<C-k>", function()
			if vim.snippet.active({ direction = -1 }) then vim.snippet.jump(-1) end
		end, { desc = "Jump to previous snippet placeholder" })
	end,
}
