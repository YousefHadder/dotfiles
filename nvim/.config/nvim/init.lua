-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
local cmp = require("cmp")

cmp.setup({
  mapping = {
    -- Map <S-Tab> to confirm the currently selected completion item.
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
      else
        fallback()
      end
    end, { "i", "s" }),

    -- Optionally, disable <Enter> from confirming completions.
    ["<CR>"] = cmp.mapping(function(fallback)
      fallback()
    end, { "i", "s" }),

    -- You can add other mappings here (e.g., for navigating suggestions).
  },
  -- Other cmp configurations...
})
