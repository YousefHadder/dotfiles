return {
  {
    "tiagovla/scope.nvim",
    event = "VeryLazy",
    config = true,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    config = function()
      local bufferline = require("bufferline")

      -- Keymaps
      vim.keymap.set("n", "<A-h>", ":BufferLineMovePrev<CR>", { silent = true })
      vim.keymap.set("n", "<A-l>", ":BufferLineMoveNext<CR>", { silent = true })
      vim.keymap.set("n", "gb", ":BufferLinePick<CR>", { silent = true })

      bufferline.setup({
        options = {
          themable = true, -- Let bufferline derive colors from the colorscheme
          -- mode = "tabs",
          numbers = "ordinal",
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count) return "(" .. count .. ")" end,

          indicator = { style = "icon" }, -- 'icon' is default style; keeping explicit is harmless
          buffer_close_icon = "󰅖",
          modified_icon = "● ",
          show_tab_indicators = true,
          offsets = {
            { filetype = "snacks_layout_box", text = "Explorer",     highlight = "Directory", text_align = "center" },
            { filetype = "copilot-chat",      text = "Copilot Chat", highlight = "Directory", text_align = "center" },
          },
          get_element_icon = function(element)
            local icon, hl = require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = false })
            return icon, hl
          end,
          separator_style = "slant",
          auto_toggle_bufferline = true,
          hover = { enabled = true, delay = 200, reveal = { "close" } },

          pick = {
            alphabet = "abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ1234567890",
          },
        },
      })
    end,
  }
}
