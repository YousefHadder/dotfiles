return {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
        require("dressing").setup({
            input = {
                enabled = true,
                default_prompt = "Input: ",
                prompt_align = "left",
                insert_only = false,
                start_in_insert = true,
                persist_width = false,
                win_options = {
                    winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
                },
            },
            select = {
                enabled = true,
                backend = { "builtin", "telescope" },
                builtin = {
                    trim_prompt_chars = true,
                    win_options = {
                        winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
                    },
                },
            },
        })
    end,
}
