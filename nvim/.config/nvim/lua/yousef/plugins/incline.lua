return {
	"b0o/incline.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- For file icons
		"SmiteshP/nvim-navic", -- For LSP navigation context
	},
	config = function()
		local helpers = require("incline.helpers")
		local devicons = require("nvim-web-devicons")
		local navic = require("nvim-navic")

		require("incline").setup({
			window = {
				placement = { horizontal = "right", vertical = "top" },
				padding_char = " ",
				width = "fit",
				winhighlight = {
					active = {
						Normal = "InclineNormal",
						EndOfBuffer = "None",
						Search = "None",
					},
					inactive = {
						Normal = "InclineNormalNC",
						EndOfBuffer = "None",
						Search = "None",
					},
				},
				zindex = 50,
			},

			-- highlight = {
			--   groups = {
			--     InclineNormal   = { default = true, group = "StatusLine" },
			--     InclineNormalNC = { default = true, group = "StatusLineNC" },
			--   },
			-- },

			render = function(props)
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
				if filename == "" then
					filename = "[No Name]"
				end
				local modified = vim.bo[props.buf].modified
				local ft_icon, ft_color = devicons.get_icon_color(filename)
				local result = {}

				-- ICON box + extra space
				if ft_icon then
					table.insert(result, {
						" " .. ft_icon .. " ",
						guibg = ft_color,
						guifg = helpers.contrast_color(ft_color),
					})
					table.insert(result, " ") -- spacing between icon and filename
				end

				-- FILENAME
				table.insert(result, {
					filename,
					gui = modified and "bold,italic" or "bold",
				})

				local function sep()
					return { " | ", guifg = "#666666" }
				end

				if props.focused then
					-- NAVIC
					local navic_data = navic.get_data(props.buf) or {}
					if #navic_data > 0 then
						table.insert(result, sep())
						for _, item in ipairs(navic_data) do
							table.insert(result, {
								{ " > ", group = "NavicSeparator" },
								{ item.icon, group = "NavicIcons" .. item.type },
								{ item.name, group = "NavicText" },
							})
						end
					end

					-- DIAGNOSTICS
					local diag_icons = { error = "", warn = "", info = "", hint = "" }
					local entries = {}

					for severity, icon in pairs(diag_icons) do
						local count = #vim.diagnostic.get(props.buf, {
							severity = vim.diagnostic.severity[string.upper(severity)],
						})
						if count > 0 then
							table.insert(entries, {
								icon .. " " .. count,
								group = "DiagnosticSign" .. severity,
							})
						end
					end

					if #entries > 0 then
						table.insert(result, sep())
						for i, item in ipairs(entries) do
							table.insert(result, item)
							if i < #entries then
								table.insert(result, " ") -- space after all but last
							end
						end
					end

					-- GIT DIFF
					local git_icons = { added = "", changed = "", removed = "" }
					local git_palette = {
						added = "#00875f", -- slate green
						changed = "#d7d787", -- slate yellow
						removed = "#ff8787", -- slate red
					}

					local signs = vim.b[props.buf].gitsigns_status_dict
					local has_git_change = signs
						and ((signs.added or 0) > 0 or (signs.changed or 0) > 0 or (signs.removed or 0) > 0)

					if has_git_change then
						table.insert(result, sep())
						local entries = {}

						for name, icon in pairs(git_icons) do
							local count = tonumber(signs[name])
							if count and count > 0 then
								table.insert(entries, {
									icon .. " " .. count,
									guifg = git_palette[name],
									guibg = "none",
								})
							end
						end

						for i, item in ipairs(entries) do
							table.insert(result, item)
							if i < #entries then
								table.insert(result, " ") -- trailing space for all but the last
							end
						end
					end

					-- CLOCK
					table.insert(result, sep())
					table.insert(result, { os.date("%H:%M") })
				end

				table.insert(result, " ")
				return result
			end,
		})
	end,
	-- Optional: Lazy load Incline
}
