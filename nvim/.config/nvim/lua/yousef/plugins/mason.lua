return {
	-- Mason core - must load first
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate", -- Move build command here
		config = function()
			require("mason").setup()
		end,
	},

	-- Mason tool installer
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
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
				-- Remove automatic_enable as it's deprecated
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
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
			"leoluz/nvim-dap-go",
			"suketa/nvim-dap-ruby",
			{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
		},
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = {
					"delve",
				},
			})
			require("dap-go").setup()
			require("dapui").setup()
			require("dap-ruby").setup()

			local dap, dapui = require("dap"), require("dapui")

			-- DAP UI auto-open/close
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			-- Function key bindings
			vim.keymap.set("n", "<F5>", function()
				require("dap").continue()
			end)
			vim.keymap.set("n", "<F10>", function()
				require("dap").step_over()
			end)
			vim.keymap.set("n", "<F11>", function()
				require("dap").step_into()
			end)
			vim.keymap.set("n", "<F12>", function()
				require("dap").step_out()
			end)

			-- Leader key bindings
			vim.keymap.set("n", "<leader><space>5", function()
				require("dap").continue()
			end, { desc = "Continue" })
			vim.keymap.set("n", "<leader><space>0", function()
				require("dap").step_over()
			end, { desc = "Step over" })
			vim.keymap.set("n", "<leader><space>1", function()
				require("dap").step_into()
			end, { desc = "Step into" })
			vim.keymap.set("n", "<leader><space>2", function()
				require("dap").step_out()
			end, { desc = "Step out" })
			vim.keymap.set("n", "<Leader><space>b", function()
				require("dap").toggle_breakpoint()
			end, { desc = "Toggle breakpoint" })
			vim.keymap.set("n", "<Leader><space>B", function()
				require("dap").set_breakpoint()
			end, { desc = "Breakpoint" })
			vim.keymap.set("n", "<Leader><space>pr", function()
				require("dap").repl.open()
			end, { desc = "Open REPL" })
			vim.keymap.set("n", "<Leader><space>pl", function()
				require("dap").run_last()
			end, { desc = "Run last" })
			vim.keymap.set({ "n", "v" }, "<Leader><space>ph", function()
				require("dap.ui.widgets").hover()
			end, { desc = "Hover widget" })
			vim.keymap.set({ "n", "v" }, "<Leader><space>pp", function()
				require("dap.ui.widgets").preview()
			end, { desc = "Preview widget" })
			vim.keymap.set("n", "<Leader><space>pf", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.frames)
			end, { desc = "Widget frames" })
			vim.keymap.set("n", "<Leader><space>ps", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.scopes)
			end, { desc = "Centre scopes" })
		end,
	},
}
