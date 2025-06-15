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
			{ "<leader>aa", "<cmd>CopilotChatToggle<cr>",        desc = "Toggle Copilot Chat" },
			{ "<leader>ae", "<cmd>CopilotChatExplain<cr>",       desc = "CopilotChat - Explain code" },
			{ "<leader>ar", "<cmd>CopilotChatReview<cr>",        desc = "CopilotChat - Review code" },
			{ "<leader>af", "<cmd>CopilotChatFix<cr>",           desc = "CopilotChat - Fix" },
			{ "<leader>ao", "<cmd>CopilotChatOptimize<cr>",      desc = "CopilotChat - Optimize" },
			{ "<leader>ad", "<cmd>CopilotChatDocs<cr>",          desc = "CopilotChat - Add Documentation" },
			{ "<leader>at", "<cmd>CopilotChatTests<cr>",         desc = "CopilotChat - Generate tests" },
			{ "<leader>aD", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "CopilotChat - diagnostic issue in file" },
			{ "<leader>ac", "<cmd>CopilotChatCommit<cr>",        desc = "CopilotChat - Commit message" },
			{ "<leader>as", "<cmd>CopilotChatCommitStaged<cr>",  desc = "CopilotChat - Commit message" },
			{ "<leader>am", "<cmd>CopilotChatModel<cr>",         desc = "Copilot Chat Models" },
			{
				"<leader>ac",
				function()
					local actions = require("CopilotChat.actions")
					require("CopilotChat.integrations.telescope").pick(actions.help_actions())
				end,
				desc = "CopilotChat - Help actions",
			},
			-- Show prompts actions with telescope
			{
				"<leader>ap",
				function()
					local actions = require("CopilotChat.actions")
					require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
				end,
				desc = "CopilotChat - Prompt actions",
			},
		},
	},
}
