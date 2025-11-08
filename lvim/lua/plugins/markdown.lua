return {
  {
    "yousefhadder/markdown-plus.nvim",
    ft = { "markdown" },
    config = function()
      require("markdown-plus").setup({
        keymaps = {
          enabled = true,
        },
      })
    end,
  },
  -- {
  --   vim.opt.runtimepath:prepend("~/github/markdown-plus.nvim"),
  --   require("markdown-plus").setup(),
  -- },
}
