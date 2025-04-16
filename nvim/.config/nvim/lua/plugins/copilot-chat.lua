return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "github/copilot.vim" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    build = "make tiktoken",
    event = "VeryLazy",
    config = function()
      require("CopilotChat").setup({
        auto_insert_mode = true,
        chat_autocomplete = true,
        show_help = false,
        show_folds = false,
        question_header = "  Yousef ",
        answer_header = "  Copilot ",
      })
    end,
    keys = {
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
      { "<leader>af", "<cmd>CopilotChatFix<cr>", desc = "CopilotChat - Fix" },
      { "<leader>ao", "<cmd>CopilotChatOptimize<cr>", desc = "CopilotChat - Optimize" },
      { "<leader>ad", "<cmd>CopilotChatDocs<cr>", desc = "CopilotChat - Add Documentation" },
      { "<leader>aT", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
      { "<leader>aD", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "CopilotChat - diagnostic issue in file" },
      { "<leader>ac", "<cmd>CopilotChatCommit<cr>", desc = "CopilotChat - Commit message" },
      { "<leader>as", "<cmd>CopilotChatCommitStaged<cr>", desc = "CopilotChat - Commit message" },
      { "<leader>at", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat" },
      { "<leader>am", "<cmd>CopilotChatModel<cr>", desc = "Copilot Chat Models" },
    },
  },
}
