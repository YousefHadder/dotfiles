return {
  "akinsho/bufferline.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local bufferline = require("bufferline")

    -- Move buffer to the left
    vim.keymap.set("n", "<A-h>", ":BufferLineMovePrev<CR>", { silent = true })
    -- Move buffer to the right
    vim.keymap.set("n", "<A-l>", ":BufferLineMoveNext<CR>", { silent = true })
    vim.keymap.set("n", "gb", ":BufferLinePick<CR>", { silent = true })
    bufferline.setup({
      highlights = {
        -- Base colors from slate.vim
        fill = {
          fg = '#666666', -- Line numbers color from slate.vim
          bg = '#262626', -- Background from slate.vim
        },
        background = {
          fg = '#666666', -- Comment color from slate.vim
          bg = '#333333', -- TabLine bg from slate.vim line 43
        },
        tab = {
          fg = '#666666', -- Comment color from slate.vim
          bg = '#333333', -- TabLine bg from slate.vim
        },
        tab_selected = {
          fg = '#ffffff', -- Normal fg from slate.vim
          bg = '#666666', -- StatusLine bg from slate.vim
        },
        tab_separator = {
          fg = '#262626', -- Background from slate.vim
          bg = '#333333', -- TabLine bg from slate.vim
        },
        tab_separator_selected = {
          fg = '#262626', -- Background from slate.vim
          bg = '#666666', -- StatusLine bg from slate.vim
          sp = '#666666',
          underline = false,
        },
        tab_close = {
          fg = '#ff8787', -- TabLineFill from slate.vim line 44
          bg = '#333333',
        },
        close_button = {
          fg = '#ff8787', -- Identifier color from slate.vim
          bg = '#333333',
        },
        close_button_visible = {
          fg = '#ff8787',
          bg = '#333333',
        },
        close_button_selected = {
          fg = '#ff8787', -- StatusLine fg from slate.vim
          bg = '#666666',
        },
        buffer_visible = {
          fg = '#ffffff', -- Comment color from slate.vim
          bg = '#333333',
        },
        buffer_selected = {
          fg = '#ffffff', -- Normal fg from slate.vim
          bg = '#666666', -- StatusLine bg from slate.vim
          bold = true,
          italic = false,
        },
        numbers = {
          fg = '#666666',
          bg = '#333333',
        },
        numbers_visible = {
          fg = '#666666',
          bg = '#333333',
        },
        numbers_selected = {
          fg = '#ffffff', -- StatusLine fg from slate.vim
          bg = '#666666',
          bold = true,
          italic = false,
        },
        diagnostic = {
          fg = '#666666',
          bg = '#333333',
        },
        diagnostic_visible = {
          fg = '#666666',
          bg = '#333333',
        },
        diagnostic_selected = {
          fg = '#000000',
          bg = '#666666',
          bold = true,
          italic = false,
        },
        hint = {
          fg = '#00cdcd', -- darkcyan from slate.vim
          sp = '#00cdcd',
          bg = '#333333',
        },
        hint_visible = {
          fg = '#00cdcd',
          bg = '#333333',
        },
        hint_selected = {
          fg = '#00cdcd',
          bg = '#666666',
          sp = '#00cdcd',
          bold = true,
          italic = false,
        },
        hint_diagnostic = {
          fg = '#00cdcd',
          sp = '#00cdcd',
          bg = '#333333',
        },
        hint_diagnostic_visible = {
          fg = '#00cdcd',
          bg = '#333333',
        },
        hint_diagnostic_selected = {
          fg = '#00cdcd',
          bg = '#666666',
          sp = '#00cdcd',
          bold = true,
          italic = false,
        },
        info = {
          fg = '#5f87d7', -- Statement/Type color from slate.vim
          sp = '#5f87d7',
          bg = '#333333',
        },
        info_visible = {
          fg = '#5f87d7',
          bg = '#333333',
        },
        info_selected = {
          fg = '#5f87d7',
          bg = '#666666',
          sp = '#5f87d7',
          bold = true,
          italic = false,
        },
        info_diagnostic = {
          fg = '#5f87d7',
          sp = '#5f87d7',
          bg = '#333333',
        },
        info_diagnostic_visible = {
          fg = '#5f87d7',
          bg = '#333333',
        },
        info_diagnostic_selected = {
          fg = '#5f87d7',
          bg = '#666666',
          sp = '#5f87d7',
          bold = true,
          italic = false,
        },
        warning = {
          fg = '#ff8787', -- WarningMsg from slate.vim line 63
          sp = '#ff8787',
          bg = '#333333',
        },
        warning_visible = {
          fg = '#ff8787',
          bg = '#333333',
        },
        warning_selected = {
          fg = '#ff8787',
          bg = '#666666',
          sp = '#ff8787',
          bold = true,
          italic = false,
        },
        warning_diagnostic = {
          fg = '#ff8787',
          sp = '#ff8787',
          bg = '#333333',
        },
        warning_diagnostic_visible = {
          fg = '#ff8787',
          bg = '#333333',
        },
        warning_diagnostic_selected = {
          fg = '#ff8787',
          bg = '#666666',
          sp = '#ff8787',
          bold = true,
          italic = false,
        },
        error = {
          fg = '#ff0000', -- Error color from slate.vim
          bg = '#333333',
          sp = '#ff0000',
        },
        error_visible = {
          fg = '#ff0000',
          bg = '#333333',
        },
        error_selected = {
          fg = '#ff0000',
          bg = '#666666',
          sp = '#ff0000',
          bold = true,
          italic = false,
        },
        error_diagnostic = {
          fg = '#ff0000',
          bg = '#333333',
          sp = '#ff0000',
        },
        error_diagnostic_visible = {
          fg = '#ff0000',
          bg = '#333333',
        },
        error_diagnostic_selected = {
          fg = '#ff0000',
          bg = '#666666',
          sp = '#ff0000',
          bold = true,
          italic = false,
        },
        modified = {
          fg = '#00ff00', -- Structure color from slate.vim
          bg = '#333333',
        },
        modified_visible = {
          fg = '#00ff00',
          bg = '#333333',
        },
        modified_selected = {
          fg = '#00ff00',
          bg = '#666666',
        },
        duplicate_selected = {
          fg = '#ffffff',
          bg = '#666666',
          italic = true,
        },
        duplicate_visible = {
          fg = '#666666',
          bg = '#333333',
          italic = true,
        },
        duplicate = {
          fg = '#666666',
          bg = '#333333',
          italic = true,
        },
        separator_selected = {
          fg = '#262626',
          bg = '#666666',
        },
        separator_visible = {
          fg = '#262626',
          bg = '#333333',
        },
        separator = {
          fg = '#262626',
          bg = '#333333',
        },
        indicator_visible = {
          fg = '#666666',
          bg = '#333333',
        },
        indicator_selected = {
          fg = '#000000',
          bg = '#666666',
        },
        pick_selected = {
          fg = '#ffd700', -- Define color from slate.vim
          bg = '#666666',
          bold = true,
          italic = false,
        },
        pick_visible = {
          fg = '#ffd700',
          bg = '#333333',
          bold = true,
          italic = false,
        },
        pick = {
          fg = '#ffd700',
          bg = '#333333',
          bold = true,
          italic = false,
        },
        offset_separator = {
          fg = '#262626',
          bg = '#333333',
        },
        trunc_marker = {
          fg = '#666666',
          bg = '#333333',
        }
      },
      options = {
        mode = "buffers", -- set to "tabs" to only show tabpages instead
        style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
        themable = true, -- allows highlight groups to be overriden i.e. sets highlights as default
        numbers = "ordinal",
        close_command = "bdelete! %d", -- can be a string | function, | false see "Mouse actions"
        right_mouse_command = "bdelete! %d", -- can be a string | function | false, see "Mouse actions"
        left_mouse_command = "buffer %d", -- can be a string | function, | false see "Mouse actions"
        middle_mouse_command = nil, -- can be a string | function, | false see "Mouse actions"
        indicator = {
          icon = "▎", -- this should be omitted if indicator style is not 'icon'
          style = "icon",
        },
        buffer_close_icon = "󰅖",
        modified_icon = "● ",
        close_icon = " ",
        left_trunc_marker = " ",
        right_trunc_marker = " ",
        max_name_length = 18,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        truncate_names = true,  -- whether or not tab names should be truncated
        tab_size = 18,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false, -- only applies to coc
        diagnostics_update_on_event = true,   -- use nvim's diagnostic handler
        -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
        diagnostics_indicator = function(count)
          return "(" .. count .. ")"
        end,
        offsets = {
          {
            filetype = "snacks-picker",
            text = "Explorer",
            highlight = "Directory",
            text_align = "left",
          },
          {
            filetype = "snacks_layout_box",
          },
        },
        color_icons = true, -- whether or not to add the filetype icon highlights
        get_element_icon = function(element)
          local icon, hl =
              require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = false })
          return icon, hl
        end,
        show_buffer_icons = true, -- disable filetype icons for buffers
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        show_duplicate_prefix = true,    -- whether to show duplicate buffer prefix
        duplicates_across_groups = true, -- whether to consider duplicate paths in different groups as duplicates
        persist_buffer_sort = true,      -- whether or not custom sorted buffers should persist
        move_wraps_at_ends = false,      -- whether or not the move command "wraps" at the first or last position
        separator_style = "slant",
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        auto_toggle_bufferline = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
        sort_by = function(buffer_a, buffer_b)
          return buffer_a.id < buffer_b.id
        end,
        pick = {
          alphabet = "abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ1234567890",
        },
      },

    })
  end,
}
