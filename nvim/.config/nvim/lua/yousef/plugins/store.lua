return {
  "alex-popov-tech/store.nvim",
  dependencies = {
    "OXY2DEV/markview.nvim", -- optional, for pretty readme preview / help window
  },
  cmd = "Store",
  keys = {
    { "<leader>os", "<cmd>Store<cr>", desc = "Open Plugin Store" },
  },
  opts = {
    -- optional configuration here
  },
}
