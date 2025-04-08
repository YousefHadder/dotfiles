return {
  {
    "zbirenbaum/copilot.lua",
    opts = function()
      require("copilot.api").status = require("copilot.status")
    end,
  },
}
