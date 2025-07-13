return {
	-- Mason core - must load first
	{
		"williamboman/mason.nvim",
		lazy = true,
		cmd = {
			"Mason",
			"MasonInstall",
			"MasonUninstall",
			"MasonUninstallAll",
			"MasonLog"
		},
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},

	-- Mason tool installer
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		event = "VeryLazy", -- Defer tool installation
		config = function()
			local mason_tool_installer = require("mason-tool-installer")
			mason_tool_installer.setup({
				ensure_installed = {
					"eslint-lsp",
					"eslint_d",
					"goimports",
					"golangci-lint",
					"gopls",
					"isort",
					"jq-lsp",
					"jsonlint",
					"json-lsp",
					"lua-language-server",
					"ts_ls",
					"prettierd",
					"prettier",
					"rubocop",
					"sorbet",
					"shellcheck",
					"stylelint-lsp",
					"stylua",
					"yaml-language-server",
				},
				debounce_hours = 96,
				auto_update = false, -- Disable auto-updates for faster startup
			})
		end,
	},

	-- Mason LSP Config - depends on mason.nvim
	{
		"williamboman/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig"
		},
		config = function()
			require("mason-lspconfig").setup({
				automatic_installation = true,
				automatic_enable = true, -- Fix diagnostic warning
				ensure_installed = {
					"bashls",
					"cssls",
					"dockerls",
					"eslint",
					"html",
					"jsonls",
					"ts_ls",
					"lua_ls",
					"gopls",
					"ruby_lsp",
				},
			})
		end,
	},

	-- LSP Config
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
	},

	-- Mason DAP
	-- {
	-- 	"jay-babu/mason-nvim-dap.nvim",
	-- 	lazy = true,
	-- 	cmd = { "DapContinue", "DapToggleBreakpoint" },
	-- 	keys = {
	-- 		{ "<F5>",              function() require("dap").continue() end,           desc = "Continue" },
	-- 		{ "<F10>",             function() require("dap").step_over() end,          desc = "Step over" },
	-- 		{ "<F11>",             function() require("dap").step_into() end,          desc = "Step into" },
	-- 		{ "<F12>",             function() require("dap").step_out() end,           desc = "Step out" },
	-- 		{ "<leader><space>5",  function() require("dap").continue() end,           desc = "Continue" },
	-- 		{ "<leader><space>0",  function() require("dap").step_over() end,          desc = "Step over" },
	-- 		{ "<leader><space>1",  function() require("dap").step_into() end,          desc = "Step into" },
	-- 		{ "<leader><space>2",  function() require("dap").step_out() end,           desc = "Step out" },
	-- 		{ "<leader><space>b",  function() require("dap").toggle_breakpoint() end,  desc = "Toggle breakpoint" },
	-- 		{ "<leader><space>B",  function() require("dap").set_breakpoint() end,     desc = "Breakpoint" },
	-- 		{ "<leader><space>pr", function() require("dap").repl.open() end,          desc = "Open REPL" },
	-- 		{ "<leader><space>pl", function() require("dap").run_last() end,           desc = "Run last" },
	-- 		{ "<leader><space>ph", function() require("dap.ui.widgets").hover() end,   mode = { "n", "v" },       desc = "Hover widget" },
	-- 		{ "<leader><space>pp", function() require("dap.ui.widgets").preview() end, mode = { "n", "v" },       desc = "Preview widget" },
	-- 		{
	-- 			"<leader><space>pf",
	-- 			function()
	-- 				local widgets = require("dap.ui.widgets")
	-- 				widgets.centered_float(widgets.frames)
	-- 			end,
	-- 			desc = "Widget frames"
	-- 		},
	-- 		{
	-- 			"<leader><space>ps",
	-- 			function()
	-- 				local widgets = require("dap.ui.widgets")
	-- 				widgets.centered_float(widgets.scopes)
	-- 			end,
	-- 			desc = "Centre scopes"
	-- 		},
	-- 	},
	-- 	dependencies = {
	-- 		"williamboman/mason.nvim",
	-- 		"mfussenegger/nvim-dap",
	-- 		"leoluz/nvim-dap-go",
	-- 		"suketa/nvim-dap-ruby",
	-- 		{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
	-- 	},
	-- 	config = function()
	-- 		require("mason-nvim-dap").setup({
	-- 			ensure_installed = {
	-- 				"delve",
	-- 			},
	-- 			automatic_installation = true, -- Fix diagnostic warning
	-- 		})
	-- 		require("dap-go").setup()
	-- 		require("dapui").setup()
	-- 		require("dap-ruby").setup()
	--
	-- 		local dap, dapui = require("dap"), require("dapui")
	--
	-- 		-- DAP UI auto-open/close
	-- 		dap.listeners.before.attach.dapui_config = function()
	-- 			dapui.open()
	-- 		end
	-- 		dap.listeners.before.launch.dapui_config = function()
	-- 			dapui.open()
	-- 		end
	-- 		dap.listeners.before.event_terminated.dapui_config = function()
	-- 			dapui.close()
	-- 		end
	-- 		dap.listeners.before.event_exited.dapui_config = function()
	-- 			dapui.close()
	-- 		end
	-- 	end,
	-- },
}
