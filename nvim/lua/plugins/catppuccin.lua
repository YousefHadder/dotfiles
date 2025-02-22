return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        custom_highlights = function(colors)
          return {
            Cursor = { bg = colors.peach }, -- Set cursor background color
            lCursor = { bg = colors.sky }, -- Set the color for the language cursor (optional)
          }
        end,
      })

      vim.cmd.colorscheme "catppuccin-mocha"
    end
  }
}
