return {
  "akinsho/bufferline.nvim",
  config = function()
    require("bufferline").setup({
      highlights = require("catppuccin.groups.integrations.bufferline").get(),
      options = {
        numbers = "ordinal",
        close_command = "bp|sp|bn|bd! %d",
        right_mouse_command = "bp|sp|bn|bd! %d",
        left_mouse_command = "buffer %d",
        buffer_close_icon = "x",
        modified_icon = "",
        close_icon = "x",
        show_close_icon = false,
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 14,
        max_prefix_length = 13,
        tab_size = 10,
        show_tab_indicators = true,
        indicator = {
          style = "underline",
        },
        enforce_regular_tabs = false,
        view = "multiwindow",
        show_buffer_close_icons = true,
        -- separator_style = "thin",
        separator_style = "slant",
        always_show_bufferline = true,
        diagnostics = false,
        themable = true,
      },
    })
  end,
}
