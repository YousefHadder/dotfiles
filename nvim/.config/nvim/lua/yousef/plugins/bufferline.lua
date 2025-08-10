return {
  -- scope buffers to tabs
  {
    "tiagovla/scope.nvim",
    event = "VeryLazy",
    config = true, -- `require("scope").setup({})`
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
        -- Setting the highlights similar to slate colorscheme
        highlights = {
          fill = { fg = "#666666", bg = "#262626" },
          background = { fg = "#666666", bg = "#333333" },
          tab = { fg = "#666666", bg = "#333333" },
          tab_selected = { fg = "#ffffff", bg = "#666666" },
          tab_separator = { fg = "#262626", bg = "#333333" },
          tab_separator_selected = { fg = "#262626", bg = "#666666", sp = "#666666", underline = false },
          tab_close = { fg = "#ff8787", bg = "#333333" },

          close_button = { fg = "#ff8787", bg = "#333333" },
          close_button_visible = { fg = "#ff8787", bg = "#333333" },
          close_button_selected = { fg = "#ff8787", bg = "#666666" },

          buffer_visible = { fg = "#ffffff", bg = "#333333" },
          buffer_selected = { fg = "#ffffff", bg = "#666666", bold = true, italic = false },

          numbers = { fg = "#666666", bg = "#333333" },
          numbers_visible = { fg = "#666666", bg = "#333333" },
          numbers_selected = { fg = "#ffffff", bg = "#666666", bold = true, italic = false },

          diagnostic = { fg = "#666666", bg = "#333333" },
          diagnostic_visible = { fg = "#666666", bg = "#333333" },
          diagnostic_selected = { fg = "#000000", bg = "#666666", bold = true, italic = false },

          hint = { fg = "#00cdcd", sp = "#00cdcd", bg = "#333333" },
          hint_visible = { fg = "#00cdcd", bg = "#333333" },
          hint_selected = { fg = "#00cdcd", bg = "#666666", sp = "#00cdcd", bold = true, italic = false },
          hint_diagnostic = { fg = "#00cdcd", sp = "#00cdcd", bg = "#333333" },
          hint_diagnostic_visible = { fg = "#00cdcd", bg = "#333333" },
          hint_diagnostic_selected = { fg = "#00cdcd", bg = "#666666", sp = "#00cdcd", bold = true, italic = false },

          info = { fg = "#5f87d7", sp = "#5f87d7", bg = "#333333" },
          info_visible = { fg = "#5f87d7", bg = "#333333" },
          info_selected = { fg = "#5f87d7", bg = "#666666", sp = "#5f87d7", bold = true, italic = false },
          info_diagnostic = { fg = "#5f87d7", sp = "#5f87d7", bg = "#333333" },
          info_diagnostic_visible = { fg = "#5f87d7", bg = "#333333" },
          info_diagnostic_selected = { fg = "#5f87d7", bg = "#666666", sp = "#5f87d7", bold = true, italic = false },

          warning = { fg = "#ff8787", sp = "#ff8787", bg = "#333333" },
          warning_visible = { fg = "#ff8787", bg = "#333333" },
          warning_selected = { fg = "#ff8787", bg = "#666666", sp = "#ff8787", bold = true, italic = false },
          warning_diagnostic = { fg = "#ff8787", sp = "#ff8787", bg = "#333333" },
          warning_diagnostic_visible = { fg = "#ff8787", bg = "#333333" },
          warning_diagnostic_selected = { fg = "#ff8787", bg = "#666666", sp = "#ff8787", bold = true, italic = false },

          error = { fg = "#ff0000", bg = "#333333", sp = "#ff0000" },
          error_visible = { fg = "#ff0000", bg = "#333333" },
          error_selected = { fg = "#ff0000", bg = "#666666", sp = "#ff0000", bold = true, italic = false },
          error_diagnostic = { fg = "#ff0000", bg = "#333333", sp = "#ff0000" },
          error_diagnostic_visible = { fg = "#ff0000", bg = "#333333" },
          error_diagnostic_selected = { fg = "#ff0000", bg = "#666666", sp = "#ff0000", bold = true, italic = false },

          modified = { fg = "#00ff00", bg = "#333333" },
          modified_visible = { fg = "#00ff00", bg = "#333333" },
          modified_selected = { fg = "#00ff00", bg = "#666666" },

          duplicate_selected = { fg = "#ffffff", bg = "#666666", italic = true },
          duplicate_visible = { fg = "#666666", bg = "#333333", italic = true },
          duplicate = { fg = "#666666", bg = "#333333", italic = true },

          separator_selected = { fg = "#262626", bg = "#666666" },
          separator_visible = { fg = "#262626", bg = "#333333" },
          separator = { fg = "#262626", bg = "#333333" },

          indicator_visible = { fg = "#666666", bg = "#333333" },
          indicator_selected = { fg = "#000000", bg = "#666666" },

          pick_selected = { fg = "#ffd700", bg = "#666666", bold = true, italic = false },
          pick_visible = { fg = "#ffd700", bg = "#333333", bold = true, italic = false },
          pick = { fg = "#ffd700", bg = "#333333", bold = true, italic = false },

          offset_separator = { fg = "#262626", bg = "#333333" },
          trunc_marker = { fg = "#666666", bg = "#333333" },
        },

        options = {
          -- mode = "tabs",
          numbers = "ordinal",
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count) return "(" .. count .. ")" end,

          indicator = { style = "icon" }, -- 'icon' is default style; keeping explicit is harmless
          buffer_close_icon = "󰅖",
          modified_icon = "● ",
          show_tab_indicators = true,
          offsets = {
            { filetype = "snacks-picker",    text = "Explorer", highlight = "Directory", text_align = "left" },
            { filetype = "snacks_layout_box" },
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
