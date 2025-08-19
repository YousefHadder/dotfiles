return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    preset = "helix",
    defaults = {},
    spec = {
      {
        mode = { "n", "v" },
        { "<leader><tab>", group = "tabs", icon = { icon = "󰓩 ", color = "blue" } },
        { "<leader>.", group = "scratch", icon = { icon = "󱞁 ", color = "yellow" } },
        { "<leader>/", group = "search/grep", icon = { icon = "󰍉 ", color = "green" } },
        { "<leader>:", group = "command", icon = { icon = " ", color = "purple" } },
        { "<leader>a", group = "ai/copilot", icon = { icon = "󰚩 ", color = "orange" } },
        { "<leader>c", group = "code/format", icon = { icon = "󰘦 ", color = "blue" } },
        { "<leader>d", group = "debug", icon = { icon = " ", color = "red" } },
        { "<leader>e", group = "explorer", icon = { icon = "󰙅 ", color = "green" } },
        { "<leader>f", group = "find/files", icon = { icon = "󰍉 ", color = "blue" } },
        { "<leader>g", group = "git", icon = { icon = "󰊢 ", color = "orange" } },
        { "<leader>gh", group = "git hunks", icon = { icon = "󰊢 ", color = "orange" } },
        { "<leader>m", group = "move/split", icon = { icon = "󰩈 ", color = "cyan" } },
        { "<leader>M", group = "mcp hub", icon = { icon = "󰒋 ", color = "purple" } },
        { "<leader>n", group = "notifications", icon = { icon = "󰍡 ", color = "yellow" } },
        { "<leader>q", group = "quit/session", icon = { icon = "󰗼 ", color = "red" } },
        { "<leader>r", group = "replace/reload", icon = { icon = "󰛔 ", color = "yellow" } },
        { "<leader>s", group = "search/symbols", icon = { icon = "󰍉 ", color = "green" } },
        { "<leader>t", group = "test/terminal", icon = { icon = "󰙨 ", color = "green" } },
        { "<leader>u", group = "ui/toggle", icon = { icon = "󰙵 ", color = "cyan" } },
        { "<leader>w", group = "workspace/save", icon = { icon = "󰆓 ", color = "blue" } },
        { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
        { "<leader>z", group = "zen/zoom", icon = { icon = "󰊓 ", color = "purple" } },
        { "[", group = "prev", icon = { icon = "󰒮 ", color = "blue" } },
        { "]", group = "next", icon = { icon = "󰒭 ", color = "blue" } },
        { "g", group = "goto", icon = { icon = "󰉁 ", color = "blue" } },
        { "ys", group = "surround", icon = { icon = "󰅪 ", color = "yellow" } },
        { "z", group = "fold", icon = { icon = "󰘖 ", color = "cyan" } },
        {
          "<leader>b",
          group = "buffer",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        {
          "<leader>w",
          group = "windows",
          proxy = "<c-w>",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },
        -- better descriptions
        { "gx", desc = "Open with system app" },
      },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Keymaps (which-key)",
    },
  },
}
