return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "leoluz/nvim-dap-go",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        require("dap-go").setup()
        require("dapui").setup()

        -- Configure Ruby debugger
        dap.adapters.ruby = {
            type = 'executable',
            command = 'rdebug-ide', -- Ensure this is in your PATH or provide the full path
            args = {'--interpreter=debug'}
        }

        dap.configurations.ruby = {
            {
                type = 'ruby',
                request = 'launch',
                name = 'Debug Ruby',
                program = '${file}',
                useBundler = false -- Set to true if you are using bundler
            }
        }

        -- Set up DAP UI listeners
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

        -- Key mappings for debugging
        vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, {})
        vim.keymap.set("n", "<Leader>dc", dap.continue, {})

    end,
}
