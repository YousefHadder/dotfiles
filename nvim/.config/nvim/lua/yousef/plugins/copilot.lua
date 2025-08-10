return {
  "github/copilot.vim",
  event = "InsertEnter",
  init = function()
    -- Stop TAB fights with completion
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true

    -- Also hide during built-in completion (belt & suspenders)
    vim.g.copilot_hide_during_completion = 1

    -- Optional: tiny delay reduces flicker of ghost text
    vim.g.copilot_idle_delay = 150
  end,
  config = function()
    -- Hide Copilot ghost text while Blink’s menu is visible
    local grp = vim.api.nvim_create_augroup("CopilotBlinkHarmony", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      pattern = "BlinkCmpMenuOpen",
      group = grp,
      callback = function() vim.b.copilot_suggestion_hidden = true end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "BlinkCmpMenuClose",
      group = grp,
      callback = function() vim.b.copilot_suggestion_hidden = false end,
    })
  end,

}
