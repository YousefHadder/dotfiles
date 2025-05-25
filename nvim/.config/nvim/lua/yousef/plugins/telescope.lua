return {
  "nvim-telescope/telescope.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",
    "stevearc/aerial.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
  },
  config = function()
    require("telescope").setup({
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    })
    -- Define all fuzzy finding keymaps here
    local builtin = require("telescope.builtin")

    -- Main keymaps for files and searching
    vim.keymap.set("n", "<c-P>", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<c-G>", builtin.live_grep, { desc = "Live grep" })

    -- File navigation
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
    vim.keymap.set("n", "<leader>fc", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "Find config files" })

    -- Help and documentation
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })

    -- Git integration
    vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git status" })
    vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })
    vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })

    -- LSP integration
    vim.keymap.set("n", "gd", function()
      builtin.lsp_definitions({ jump_type = "never" })
    end, { desc = "Go to definition" })

    vim.keymap.set("n", "gr", function()
      builtin.lsp_references()
    end, { desc = "Find references" })

    vim.keymap.set("n", "gi", builtin.lsp_implementations, { desc = "Go to implementation" })
    vim.keymap.set("n", "gt", builtin.lsp_type_definitions, { desc = "Go to type definition" })

    vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })
    vim.keymap.set("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })

    -- Diagnostics
    vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })

    -- Load extensions
    require("telescope").load_extension("aerial")
    require("telescope").load_extension("ui-select")
  end,
}
