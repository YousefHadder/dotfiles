return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      lsp = {
        -- Removed deprecated overrides: stylize_markdown and convert_input_to_markdown_lines
        -- are deprecated in 0.11+ and removed in 0.12. Native LSP UI + winborder handles this.
        override = {},
      },
      views = {
        cmdline_popup = { border = { style = "rounded", padding = { 0, 1 } } },
        popupmenu = { border = { style = "rounded", padding = { 0, 1 } } },
        hover = { border = { style = "rounded" } },
        signature = { border = { style = "rounded" } },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = false,        -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
      },
    })
  end,
}
