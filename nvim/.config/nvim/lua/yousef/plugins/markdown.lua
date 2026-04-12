local use_local_markdown_plus = true

local markdown_plus_spec = {
	ft = { "markdown", "csv" },
	opts = {
		enabled = true,

		-- Toggle individual feature modules
		features = {
			list_management = true,
			text_formatting = true,
			thematic_break = true,
			links = true,
			images = true,
			headers_toc = true,
			quotes = true,
			callouts = true,
			code_block = true,
			html_block_awareness = true,
			table = true,
			footnotes = true,
		},

		-- Global keymap toggle (all <Plug> defaults)
		keymaps = {
			enabled = true,
		},

		-- Filetypes that trigger the plugin
		filetypes = { "markdown" },

		-- Table of Contents
		toc = {
			initial_depth = 4, -- Minimum heading depth to include (2 = skip H1)
		},

		-- Table editing
		table = {
			enabled = true,
			auto_format = true, -- Re-align on <Tab>/<CR>
			default_alignment = "left", -- "left" | "center" | "right"
			confirm_destructive = true, -- Prompt before deleting rows/cols
			keymaps = {
				enabled = true,
				prefix = "<localleader>t", -- All table maps start with this
				insert_mode_navigation = true, -- Tab/S-Tab navigate cells
			},
		},

		-- Callout blocks (> [!NOTE], etc.)
		callouts = {
			default_type = "NOTE", -- Default callout when inserting
			custom_types = {}, -- Add custom callout types here
		},

		-- Thematic breaks (horizontal rules)
		thematic_break = {
			style = "---", -- "---" | "***" | "___"
		},

		-- Fenced code blocks
		code_block = {
			enabled = true,
			fence_style = "backtick", -- "backtick" | "tilde"
			languages = { "lua", "python", "javascript", "typescript", "bash", "json", "yaml", "markdown" },
		},

		-- Footnotes
		footnotes = {
			section_header = "Footnotes", -- Header text for footnotes section
			confirm_delete = true, -- Prompt before deleting footnotes
		},

		-- List management
		list = {
			smart_outdent = true, -- Outdent empty list items instead of removing
			checkbox_completion = {
				enabled = false, -- Add completion metadata to checked items
				format = "emoji", -- "emoji" | "text"
				date_format = "%Y-%m-%d",
				remove_on_uncheck = true,
				update_existing = true,
			},
		},

		-- Link management
		links = {
			smart_paste = {
				enabled = true, -- Auto-fetch URL titles on paste
				timeout = 5, -- Fetch timeout in seconds
			},
		},
	},
}

if use_local_markdown_plus then
	markdown_plus_spec.dir = "~/github/markdown-plus.nvim"
else
	markdown_plus_spec[1] = "yousefhadder/markdown-plus.nvim"
end

return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
		config = function()
			require("render-markdown").setup({
				latex = { enabled = false },
			})

			local function set_render_markdown_hl()
				local ns = 0
				vim.api.nvim_set_hl(ns, "RenderMarkdownCode", { fg = "#c0caf5", bg = "#1f2335" })
				vim.api.nvim_set_hl(ns, "RenderMarkdownCodeInline", { fg = "#c0caf5", bg = "#1f2335" })
			end

			set_render_markdown_hl()
			vim.api.nvim_create_autocmd("ColorScheme", {
				group = vim.api.nvim_create_augroup("RenderMarkdownHL", { clear = true }),
				callback = set_render_markdown_hl,
			})
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
	markdown_plus_spec,
}
