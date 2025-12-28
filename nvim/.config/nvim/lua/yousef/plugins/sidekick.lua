return {
	"folke/sidekick.nvim",
	opts = {
		-- add any options here
		cli = {
			tools = {
				-- Claude variants
				claude = { cmd = { "claude" } },
				claude_yolo = { cmd = { "claude", "--dangerously-skip-permissions" } },
				claude_resume = { cmd = { "claude", "--resume" } },
				claude_yolo_resume = { cmd = { "claude", "--dangerously-skip-permissions", "--resume" } },
				-- Copilot variants
				copilot = { cmd = { "copilot" } },
				copilot_auto = { cmd = { "copilot", "--allow-all-tools" } },
				copilot_resume = { cmd = { "copilot", "--resume" } },
				copilot_auto_resume = { cmd = { "copilot", "--allow-all-tools", "--resume" } },
				-- Codex
				codex = { cmd = { "codex", "--full-auto" } },
			},

			mux = {
				backend = "tmux",
				enabled = true,
			},
		},
	},
	keys = {
		-- {
		-- 	"<tab>",
		-- 	function()
		-- 		-- if there is a next edit, jump to it, otherwise apply it if any
		-- 		if not require("sidekick").nes_jump_or_apply() then
		-- 			return "<Tab>" -- fallback to normal tab
		-- 		end
		-- 	end,
		-- 	expr = true,
		-- 	desc = "Goto/Apply Next Edit Suggestion",
		-- },
		{
			"<c-.>",
			function()
				require("sidekick.cli").toggle()
			end,
			desc = "Sidekick Toggle",
			mode = { "n", "t", "i", "x" },
		},
		{
			"<leader>ak",
			function()
				require("sidekick.cli").toggle()
			end,
			desc = "Sidekick Toggle CLI",
		},
		{
			"<leader>aS",
			function()
				require("sidekick.cli").select()
			end,
			-- Or to select only installed tools:
			-- require("sidekick.cli").select({ filter = { installed = true } })
			desc = "Select CLI",
		},
		{
			"<leader>aq",
			function()
				require("sidekick.cli").close()
			end,
			desc = "Detach a CLI Session",
		},
		{
			"<leader>ah",
			function()
				require("sidekick.cli").send({ msg = "{this}" })
			end,
			mode = { "x", "n" },
			desc = "Send This",
		},
		{
			"<leader>aF",
			function()
				require("sidekick.cli").send({ msg = "{file}" })
			end,
			desc = "Send File",
		},
		{
			"<leader>av",
			function()
				require("sidekick.cli").send({ msg = "{selection}" })
			end,
			mode = { "x" },
			desc = "Send Visual Selection",
		},
		{
			"<leader>aP",
			function()
				require("sidekick.cli").prompt()
			end,
			mode = { "n", "x" },
			desc = "Sidekick Select Prompt",
		},
		-- Example of a keybinding to open Claude directly
		{
			"<leader>aC",
			function()
				require("sidekick.cli").toggle({ name = "claude", focus = true })
			end,
			desc = "Sidekick Toggle Claude",
		},
	},
}
