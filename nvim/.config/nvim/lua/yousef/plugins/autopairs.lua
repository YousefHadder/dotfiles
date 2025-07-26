return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  dependencies = {
    "hrsh7th/nvim-cmp",
  },

  config = function()
    require("nvim-autopairs").setup({
      check_ts = true,
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
        typescript = { "template_string" },
        javascriptreact = { "template_string" },
        typescriptreact = { "template_string" },
        python = { "string" },
        go = { "string", "raw_string" },
        c = { "string" },
        cpp = { "string" },
        java = { "string" },
        ruby = { "string" },
        html = { "attribute_value" },
        css = { "string_value" },
        json = { "string" },
        yaml = { "string" },
        toml = { "string" },
        markdown = { "code_fence_content" },
      },
    })

    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")

    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
