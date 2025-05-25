return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,

  config = function()
    require("tokyonight").setup({
      transparent = true,
      terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
      day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
      lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
      style = "moon",
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "transparent", -- style for sidebars, see below
        floats = "transparent", -- style for floating windows
      },
      on_highlights = function(hl)
        hl.LineNrAbove = {
          fg = "#6ab8ff",
        }
        hl.LineNrBelow = {
          fg = "#ff6188",
        }
        hl.Comment = { fg = "#7fbbb3", bg = "none", italic = true }
        -- If you use Treesitter and want to catch @comment as well:
        hl["@comment"] = { fg = "#7fbbb3", bg = "none", italic = true }
      end,
    })
    vim.cmd([[colorscheme tokyonight]])
  end,
}
