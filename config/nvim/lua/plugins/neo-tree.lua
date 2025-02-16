return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- Show filtered items by default
        hide_gitignored = true,
        hide_dotfiles = false,
        hide_hidden = false, -- Show hidden files
      },
    },
    window = {
      mappings = {
        ["<BS>"] = "close_node",  -- Backspace to close the current node/go back
        ["h"] = "close_node",       -- h also closes the current node/go back
        ["l"] = "open",             -- l to open a node or file (optional)
      },
    },
  },
  config = function()
    vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
    vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
  end,
}

