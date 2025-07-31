return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	enabled = true,
	init = false,
	opts = function()
		local dashboard = require("alpha.themes.dashboard")
		local logo = [[

██████╗  █████╗ ██╗     ███████╗███████╗████████╗██╗███╗   ██╗███████╗
██╔══██╗██╔══██╗██║     ██╔════╝██╔════╝╚══██╔══╝██║████╗  ██║██╔════╝
██████╔╝███████║██║     █████╗  ███████╗   ██║   ██║██╔██╗ ██║█████╗
██╔═══╝ ██╔══██║██║     ██╔══╝  ╚════██║   ██║   ██║██║╚██╗██║██╔══╝
██║     ██║  ██║███████╗███████╗███████║   ██║   ██║██║ ╚████║███████╗
╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝   ╚═╝   ╚═╝╚═╝  ╚═══╝╚══════╝


							❤️🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤
							❤️❤️🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤
							❤️❤️❤️🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤
							❤️❤️❤️❤️🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍
							❤️❤️❤️❤️❤️🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍
							❤️❤️❤️❤️🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍🤍
							❤️❤️❤️💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚
							❤️❤️💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚
							❤️💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚
]]

		dashboard.section.header.val = vim.split(logo, "\n")
		-- stylua: ignore
		dashboard.section.buttons.val = {
			dashboard.button("f", " " .. " Find file", "<cmd> Telescope find_files <cr>"),
			dashboard.button("n", " " .. " New file", [[<cmd> ene <BAR> startinsert <cr>]]),
			dashboard.button("r", " " .. " Recent files", [[<cmd> Telescope oldfiles <cr>]]),
			dashboard.button("g", " " .. " Find text", [[<cmd> Telescope live_grep <cr>]]),
			dashboard.button("c", " " .. " Config", "<cmd> Telescope find_files cwd=~/.config/nvim <cr>"),
			dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
			dashboard.button("l", "󰒲 " .. " Lazy", "<cmd> Lazy <cr>"),
			dashboard.button("q", " " .. " Quit", "<cmd> qa <cr>"),
		}
		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.hl = "AlphaButtons"
			button.opts.hl_shortcut = "AlphaShortcut"
		end
		-- Set custom highlight groups for slate theme matching slate.vim
		vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#5f87d7", bold = true })    -- Statement color from slate.vim line 83
		vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#ffffff" })                -- Normal fg from slate.vim line 29
		vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#ffd700", bold = true })  -- Define color from slate.vim line 88
		vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#666666", italic = true })  -- Comment color from slate.vim line 78

		dashboard.section.header.opts.hl = "AlphaHeader"
		dashboard.section.buttons.opts.hl = "AlphaButtons"
		dashboard.section.footer.opts.hl = "AlphaFooter"
		dashboard.opts.layout[1].val = 8
		return dashboard
	end,
	config = function(_, dashboard)
		-- close Lazy and re-open when the dashboard is ready
		local lazy = require("lazy")
		if vim.o.filetype == "lazy" then
			vim.cmd.close()
			vim.api.nvim_create_autocmd("User", {
				once = true,
				pattern = "AlphaReady",
				callback = function()
					lazy.show()
				end,
			})
		end

		require("alpha").setup(dashboard.opts)

		vim.api.nvim_create_autocmd("User", {
			once = true,
			pattern = "LazyVimStarted",
			callback = function()
				local stats = lazy.stats()
				local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
				dashboard.section.footer.val = "⚡ Neovim loaded "
						.. stats.loaded
						.. "/"
						.. stats.count
						.. " plugins in "
						.. ms
						.. "ms"
				pcall(vim.cmd.AlphaRedraw)
			end,
		})
	end,
}
