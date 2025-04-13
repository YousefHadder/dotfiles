return {
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      lspconfig.lua_ls.setup({})
      lspconfig.ts_ls.setup({})
      lspconfig.sorbet.setup({})
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = true,
    cmd = { "Mason", "MasonUpdate" },
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    dependencies = { "mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "cmake",
          "ts_ls",
          "html",
          "cssls",
          "jsonls",
          "bashls",
          "dockerls",
          "gopls",
          "marksman",
        },
      })
    end,
  },
}
