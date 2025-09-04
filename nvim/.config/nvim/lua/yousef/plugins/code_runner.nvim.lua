return {
    "CRAG666/code_runner.nvim",
    config = true,
    vim.keymap.set('n', '<leader>rr', ':RunCode<CR>', { noremap = true, silent = false })
}
