return {
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup(
        { "*" }, -- highlight all files, or adjust filetypes as needed
        {
          RGB = true, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          names = true, -- "Name" colors like Blue or red
          RRGGBBAA = false, -- disable alpha channel for now
          rgb_fn = true, -- CSS rgb() and rgba() functions
          hsl_fn = false, -- disable hsl() functions if you don't need them
          css = true, -- enable all CSS features: rgb_fn, hsl_fn, names, RGB, etc.
          css_fn = true, -- enable CSS functions (e.g. color: rgb(255,0,0))
        }
      )
    end,
  },
}
