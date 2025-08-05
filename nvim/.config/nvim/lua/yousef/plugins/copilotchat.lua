return {

	"CopilotC-Nvim/CopilotChat.nvim",
	branch = "main",
	dependencies = {
		{ "github/copilot.vim" },  -- or github/copilot.vim
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
			window = {
				layout = 'vertical',
				width = 80,     -- Fixed width in columns
				height = 20,    -- Fixed height in rows
				border = 'rounded', -- 'single', 'double', 'rounded', 'solid'
				title = '🤖 AI Assistant',
				zindex = 100,   -- Ensure window stays on top
			},
			headers = {
				user = "  Yousef ",
				assistant = "  Copilot ",
			},
			model = "claude-sonnet-4",
		})
	end,
	keys = {
		{
			"<leader>aa",
			function()
				require("CopilotChat").toggle({
					selection = function(source)
						return require("CopilotChat.select").visual(source) or
								require("CopilotChat.select").buffer(source)
					end,
				})
			end,
			desc = "Toggle Copilot Chat with buffer context"
		},
		{ "<leader>ae", "<cmd>CopilotChatExplain<cr>",      desc = "CopilotChat - Explain code" },
		{ "<leader>ar", "<cmd>CopilotChatReview<cr>",       desc = "CopilotChat - Review code" },
		{ "<leader>af", "<cmd>CopilotChatFix<cr>",          desc = "CopilotChat - Fix" },
		{ "<leader>ao", "<cmd>CopilotChatOptimize<cr>",     desc = "CopilotChat - Optimize" },
		{ "<leader>ad", "<cmd>CopilotChatDocs<cr>",         desc = "CopilotChat - Add Documentation" },
		{ "<leader>at", "<cmd>CopilotChatTests<cr>",        desc = "CopilotChat - Generate tests" },
		{ "<leader>ac", "<cmd>CopilotChatCommit<cr>",       desc = "CopilotChat - Commit message" },
		{ "<leader>as", "<cmd>CopilotChatCommitStaged<cr>", desc = "CopilotChat - Commit message" },
		{ "<leader>am", "<cmd>CopilotChatModel<cr>",        desc = "Copilot Chat Models" },
		-- Show prompts actions with telescope
		{
			"<leader>ap",
			function()
				require("CopilotChat").select_prompt({
					context = {
						"buffers",
					},
				})
			end,
			desc = "CopilotChat - Prompt actions",
		},
		{
			"<leader>ap",
			function()
				require("CopilotChat").select_prompt()
			end,
			mode = "x",
			desc = "CopilotChat - Prompt actions",
		},
	},
}
