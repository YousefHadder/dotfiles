return {
  "christoomey/vim-tmux-navigator",
  event = "VeryLazy",
  config = function()
    -- Set up keymaps for Tmux integration
    vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>", { silent = true })
    vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>", { silent = true })
    vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>", { silent = true })
    vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>", { silent = true })
  end,
}
