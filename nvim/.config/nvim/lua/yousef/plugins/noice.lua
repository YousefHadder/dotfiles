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
        -- override markdown rendering so that LSP and plugins use Treesitter
        -- Note: Verified compatible with Neovim 0.11 LSP changes
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
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
