return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets" },

	event = { "InsertEnter", "CmdlineEnter" },

	opts = {
		keymap = { preset = "default", ["<CR>"] = { "accept", "fallback" } },

		appearance = {
			nerd_font_variant = "mono",
		},

		fuzzy = { implementation = "lua" },

		completion = {
			list = { selection = { preselect = true, auto_insert = false } },
			menu = {
				border = "rounded",
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
				window = { max_width = 60, border = "rounded" },
			},
			ghost_text = { enabled = true },
		},

		signature = { enabled = true },

		sources = {
			providers = {
				path = {
					module = "blink.cmp.sources.path",
					opts = { trailing_slash = false, label_trailing_slash = true, show_hidden_files_by_default = false },
				},
			},
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
