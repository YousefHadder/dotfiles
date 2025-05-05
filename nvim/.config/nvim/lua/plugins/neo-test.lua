return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      -- Language adapters
      "nvim-neotest/neotest-go", -- Go adapter
      "nvim-neotest/neotest-jest", -- Jest for JS/TS
      "olimorris/neotest-rspec", -- RSpec for Ruby
    },
    config = function()
      local neotest = require("neotest")

      neotest.setup({
        adapters = {
          require("neotest-go")({
            -- Go adapter options
            experimental = {
              test_table = true,
            },
            args = { "-count=1", "-timeout=60s" },
          }),
          require("neotest-jest")({
            -- Jest adapter options
            jestCommand = "npm test --",
            jestConfigFile = "jest.config.js",
            env = { CI = true },
            cwd = function()
              return vim.fn.getcwd()
            end,
          }),
          require("neotest-rspec")({
            -- RSpec adapter options
            rspec_cmd = function()
              return "bundle exec rspec"
            end,
          }),
        },
        -- General settings
        discovery = {
          enabled = true,
        },
        diagnostic = {
          enabled = true,
        },
        status = {
          enabled = true,
          signs = true,
          virtual_text = true,
        },
        summary = {
          open = "botright vsplit | vertical resize 50",
        },
        output = {
          enabled = true,
          open_on_run = true,
        },
        -- Icons for the UI
        icons = {
          running = "⟳",
          passed = "✓",
          failed = "✗",
          skipped = "◌",
          unknown = "?",
        },
      })

      -- Keymappings
      vim.keymap.set("n", "<leader>tt", function()
        neotest.run.run()
      end, { desc = "Run nearest test" })
      vim.keymap.set("n", "<leader>tf", function()
        neotest.run.run(vim.fn.expand("%"))
      end, { desc = "Run current file" })
      vim.keymap.set("n", "<leader>ts", function()
        neotest.summary.toggle()
      end, { desc = "Toggle test summary" })
      vim.keymap.set("n", "<leader>to", function()
        neotest.output.open({ enter = true })
      end, { desc = "Open test output" })
      vim.keymap.set("n", "<leader>tp", function()
        neotest.output_panel.toggle()
      end, { desc = "Toggle output panel" })
      vim.keymap.set("n", "[t", function()
        neotest.jump.prev({ status = "failed" })
      end, { desc = "Jump to previous failed test" })
      vim.keymap.set("n", "]t", function()
        neotest.jump.next({ status = "failed" })
      end, { desc = "Jump to next failed test" })
    end,
  },
}
