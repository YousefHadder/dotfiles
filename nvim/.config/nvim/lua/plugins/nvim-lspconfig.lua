return {
  {
    "nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_lines = { current_line = true },
        underline = { severity = vim.diagnostic.severity.WARN }, -- underlines for warnings and errors only
        virtual_text = {
          prefix = function(diagnostic)
            if diagnostic.severity == vim.diagnostic.severity.ERROR then
              return ""
            elseif diagnostic.severity == vim.diagnostic.severity.WARN then
              return ""
            elseif diagnostic.severity == vim.diagnostic.severity.INFO then
              return ""
            else
              return ""
            end
          end,
          source = "if_many",
          spacing = 4,
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
        },
      },
    },
  },
}
