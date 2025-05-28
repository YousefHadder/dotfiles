return {
  {
    "nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
        virtual_lines = {
          current_line = true,
        },
        signs = true,
      },
    },
  },
}
