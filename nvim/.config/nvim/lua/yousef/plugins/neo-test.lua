return {
  "nvim-neotest/neotest",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-jest"
  },
  config = function()
    require('neotest').setup({
      adapters = {
        require('neotest-jest')({
          jestCommand = "npm test --",
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
        }),
      }
    })

    vim.keymap.set("n", "<leader>tn", function() require("neotest").run.run() end, { desc = "Run nearest test" })
    vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,
      { desc = "Run file tests" })
    vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end,
      { desc = "Toggle test summary" })
    vim.keymap.set("n", "<leader>to", function() require("neotest").output.open({ enter = true }) end,
      { desc = "Open test output" })
    vim.keymap.set("n", "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end,
      { desc = "Debug nearest test" })
  end
}
