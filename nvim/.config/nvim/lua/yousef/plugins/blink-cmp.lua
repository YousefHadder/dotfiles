return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets" },
	version = "*",
	event = { "InsertEnter", "CmdlineEnter" },
	build = "cargo build --release",
	opts = {
		keymap = { preset = "default", ["<CR>"] = { "accept", "fallback" } },

		appearance = {
			nerd_font_variant = "mono",
		},

		fuzzy = { implementation = "prefer_rust" },

		completion = {
			list = { selection = { preselect = false, auto_insert = false } },

			menu = {
				border = "rounded",
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
				window = { max_width = 60, border = "rounded" },
			},
		},

		signature = { enabled = true },

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
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
