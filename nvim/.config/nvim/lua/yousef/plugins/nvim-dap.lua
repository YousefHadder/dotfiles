return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
		"leoluz/nvim-dap-go", -- Go debugging
		"mxsdev/nvim-dap-vscode-js", -- JavaScript/TypeScript debugging
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Setup DAP UI
		dapui.setup()

		-- Setup virtual text
		require("nvim-dap-virtual-text").setup()

		-- Setup Go debugging
		require("dap-go").setup()

		-- Setup JS/TS debugging
		require("dap-vscode-js").setup({
			debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
			debugger_cmd = { "js-debug-adapter" },
			adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
		})

		-- JavaScript/TypeScript configurations
		for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
			dap.configurations[language] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
			}
		end

		-- Keymaps
		local keymap = vim.keymap.set
		keymap("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
		keymap("n", "<leader>dc", dap.continue, { desc = "Continue" })
		keymap("n", "<leader>da", dap.continue, { desc = "Start/Continue" })
		keymap("n", "<leader>dx", dap.terminate, { desc = "Terminate" })
		keymap("n", "<leader>do", dap.step_over, { desc = "Step Over" })
		keymap("n", "<leader>di", dap.step_into, { desc = "Step Into" })
		keymap("n", "<leader>dw", dap.step_out, { desc = "Step Out" })
		keymap("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
		keymap("n", "<leader>ds", dap.session, { desc = "Session" })
		keymap("n", "<leader>dt", dapui.toggle, { desc = "Toggle Debug UI" })

		-- Auto open/close DAP UI
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end
	end,
}
