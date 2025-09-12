return {
  "nvim-neotest/neotest",
  commit = "52fca6717ef972113ddd6ca223e30ad0abb2800c",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- Keep only the adapters you actually need
    "olimorris/neotest-rspec",
    "nvim-neotest/neotest-jest",
    "nvim-neotest/neotest-go",
  },
  config = function()
    local neotest = require("neotest")

    neotest.setup({
      discovery = { enabled = true },
      running = { concurrent = true },
      summary = { follow = true, expand_errors = true },
      output = { open_on_run = false },
      quickfix = { enabled = false },
      adapters = {
        require("neotest-rspec"),
        require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function() return vim.fn.getcwd() end,
        }),
        require("neotest-go"),
      },
    })

    -- Keymaps
    local map = vim.keymap.set
    map("n", "<leader>tn", function() neotest.run.run() end, { desc = "Test nearest" })
    map("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Test file" })
    map("n", "<leader>tl", function() neotest.run.run_last() end, { desc = "Rerun last test" })
    map("n", "<leader>ts", function() neotest.summary.toggle() end, { desc = "Toggle test summary" })
    map("n", "<leader>to", function() neotest.output.open({ enter = true }) end, { desc = "Open test output" })
    map("n", "<leader>tp", function() neotest.output_panel.toggle() end, { desc = "Toggle output panel" })
    map("n", "<leader>tw", function() neotest.watch.toggle(vim.fn.expand("%")) end, { desc = "Watch file tests" })
    map("n", "<leader>td", function() neotest.run.run({ strategy = "dap" }) end, { desc = "Debug nearest test" })
    map("n", "]t", function() neotest.jump.next({ status = "failed" }) end, { desc = "Next failed test" })
    map("n", "[t", function() neotest.jump.prev({ status = "failed" }) end, { desc = "Prev failed test" })
  end,
}
