return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local bufferline = require("bufferline")
    bufferline.setup({
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
        close_icon = " ",
        left_trunc_marker = " ",
        right_trunc_marker = " ",
        max_name_length = 18,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        truncate_names = true, -- whether or not tab names should be truncated
        tab_size = 18,
        diagnostics = "nvim_lspw",
        diagnostics_update_in_insert = false, -- only applies to coc
        diagnostics_update_on_event = true, -- use nvim's diagnostic handler
        -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
        diagnostics_indicator = function(count)
          return "(" .. count .. ")"
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "center",
          },
          {
            filetype = "snacks_layout_box",
          },
        },
        color_icons = true,
        get_element_icon = function(element)
          -- element consists of {filetype: string, path: string, extension: string, directory: string}
          -- This can be used to change how bufferline fetches the icon
          -- for an element e.g. a buffer or a tab.
          -- e.g.
          local icon, hl = require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = false })
          return icon, hl
        end,
        show_buffer_icons = true, -- disable filetype icons for buffers
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        show_duplicate_prefix = true, -- whether to show duplicate buffer prefix
        duplicates_across_groups = true, -- whether to consider duplicate paths in different groups as duplicates
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        move_wraps_at_ends = false, -- whether or not the move command "wraps" at the first or last position
        -- can also be a table containing 2 custom separators
        -- [focused and unfocused]. eg: { '|', '|' }
        separator_style = "slant",
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        auto_toggle_bufferline = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
        sort_by = "insert_after_current",
        pick = {
          alphabet = "abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ1234567890",
        },
      },
    })
  end,
}
