return {

  name = "slate-colorscheme",
  dir = vim.fn.stdpath("config"),
  lazy = false,
  priority = 1000,
  enabled = true,
  config = function()
    -- Slate colorscheme colors - matching slate.vim exactly
    local slate_colors = {
      -- Core colors from slate.vim
      bg = "#262626",      -- Background from line 29
      fg = "#ffffff",      -- Foreground from line 29
      black = "#000000",   -- From line 19
      red = "#ff0000",     -- From line 19
      green = "#00ff00",   -- From line 19
      yellow = "#ffff00",  -- From line 19
      blue = "#5c5cff",    -- From line 19
      magenta = "#ff00ff", -- From line 19
      cyan = "#00ffff",    -- From line 19
      white = "#ffffff",   -- From line 19

      -- Additional colors from slate.vim
      gray = "#e5e5e5",        -- From line 19
      darkgray = "#7f7f7f",    -- From line 19
      darkred = "#cd0000",     -- From line 19
      darkgreen = "#00cd00",   -- From line 19
      darkyellow = "#cdcd00",  -- From line 19
      darkblue = "#0000ee",    -- From line 19
      darkmagenta = "#cd00cd", -- From line 19
      darkcyan = "#00cdcd",    -- From line 19

      -- Specific syntax colors from slate.vim
      comment = "#666666",        -- From line 78
      string = "#87d7ff",         -- From line 79
      identifier = "#ff8787",     -- From line 80
      function_color = "#ffd7af", -- From line 81
      special = "#d7d787",        -- From line 82
      statement = "#5f87d7",      -- From line 83
      constant = "#ffafaf",       -- From line 84
      preproc = "#d7875f",        -- From line 85
      type = "#5f87d7",           -- From line 86
      operator = "#d7875f",       -- From line 87
      define = "#ffd700",         -- From line 88
      structure = "#00ff00",      -- From line 89

      -- UI colors from slate.vim
      cursor_line = "#333333",    -- From line 52
      visual = "#d7d787",         -- From line 56
      visual_bg = "#5f8700",      -- From line 56
      search = "#000000",         -- From line 67
      search_bg = "#d7875f",      -- From line 67
      inc_search = "#000000",     -- From line 68
      inc_search_bg = "#00ff00",  -- From line 68
      line_nr = "#666666",        -- From line 59
      pmenu = "NONE",             -- From line 36
      pmenu_sel = "#262626",      -- From line 37
      pmenu_sel_bg = "#d7d787",   -- From line 37
      status_line = "#000000",    -- From line 31
      status_line_bg = "#afaf87", -- From line 31
    }

    -- Custom highlight overrides matching slate.vim exactly
    local highlights = {
      -- Core UI from slate.vim - transparent background
      Normal = { fg = slate_colors.fg, bg = "NONE" },
      NormalNC = { fg = slate_colors.fg, bg = "NONE" },
      SignColumn = { fg = "NONE", bg = "NONE" },
      LineNr = { fg = slate_colors.line_nr },
      CursorLine = { bg = slate_colors.cursor_line },
      CursorLineNr = { bg = slate_colors.cursor_line },
      Visual = { fg = slate_colors.visual, bg = slate_colors.visual_bg },
      Search = { fg = slate_colors.search, bg = slate_colors.search_bg },
      IncSearch = { fg = slate_colors.inc_search, bg = slate_colors.inc_search_bg },
      StatusLine = { fg = slate_colors.status_line, bg = slate_colors.status_line_bg },
      StatusLineNC = { fg = slate_colors.comment, bg = slate_colors.status_line_bg },
      VertSplit = { fg = slate_colors.comment, bg = slate_colors.status_line_bg },

      -- Popup menu from slate.vim
      Pmenu = { bg = slate_colors.pmenu },
      PmenuSel = { fg = slate_colors.pmenu_sel, bg = "NONE" }, -- Slate.vim line 37
      PmenuSbar = { bg = slate_colors.bg },
      PmenuThumb = { bg = "#ffd700" },                         -- From line 39 in slate.vim

      -- Syntax highlighting from slate.vim
      Comment = { fg = slate_colors.comment },
      String = { fg = slate_colors.string },
      Identifier = { fg = slate_colors.identifier },
      Function = { fg = slate_colors.function_color },
      Special = { fg = slate_colors.special },
      Statement = { fg = slate_colors.statement, bold = true },
      Constant = { fg = slate_colors.constant },
      PreProc = { fg = slate_colors.preproc },
      Type = { fg = slate_colors.type, bold = true },
      Operator = { fg = slate_colors.operator },
      Define = { fg = slate_colors.define, bold = true },
      Structure = { fg = slate_colors.structure },

      -- Additional UI elements
      MatchParen = { fg = slate_colors.black, bg = "#ffd700" },                      -- From line 66
      Todo = { fg = slate_colors.red, bg = slate_colors.yellow },                    -- From line 69
      Error = { fg = slate_colors.red, bg = slate_colors.white, reverse = true },    -- From line 60
      ErrorMsg = { fg = slate_colors.red, bg = slate_colors.black, reverse = true }, -- From line 61
      WarningMsg = { fg = "#ff8787" },                                               -- From line 63
      MoreMsg = { fg = "#00875f" },                                                  -- From line 64
      Question = { fg = "#ffd700" },                                                 -- From line 65
      Directory = { fg = "#00875f", bold = true },                                   -- From line 90
      Title = { fg = "#ffd700", bold = true },                                       -- From line 93

      -- Diff colors from slate.vim
      DiffAdd = { fg = slate_colors.white, bg = "#5f875f" },    -- From line 94
      DiffChange = { fg = slate_colors.white, bg = "#5f87af" }, -- From line 95
      DiffText = { fg = slate_colors.black, bg = "#c6c6c6" },   -- From line 96
      DiffDelete = { fg = slate_colors.white, bg = "#af5faf" }, -- From line 97

      -- LSP and diagnostic colors
      DiagnosticError = { fg = slate_colors.red },
      DiagnosticWarn = { fg = "#ff8787" },
      DiagnosticInfo = { fg = slate_colors.darkyellow },
      DiagnosticHint = { fg = slate_colors.darkcyan },

      -- Modern features
      LspInlayHint = { fg = slate_colors.comment, italic = true },
      InlayHint = { fg = slate_colors.comment, italic = true },
      NormalFloat = { fg = slate_colors.fg, bg = slate_colors.pmenu },
      FloatBorder = { fg = slate_colors.comment, bg = slate_colors.pmenu },

      -- Telescope to match theme
      TelescopeNormal = { fg = slate_colors.fg, bg = "NONE" },
      TelescopeBorder = { fg = slate_colors.comment, bg = "NONE" },
      TelescopePromptNormal = { fg = slate_colors.fg, bg = "NONE" },
      TelescopePromptBorder = { fg = slate_colors.comment, bg = "NONE" },
      TelescopePromptTitle = { fg = slate_colors.define, bold = true },
      TelescopePreviewTitle = { fg = slate_colors.structure, bold = true },
      TelescopeResultsTitle = { fg = slate_colors.statement, bold = true },
      TelescopeSelection = { fg = slate_colors.white, bg = slate_colors.visual_bg },
      TelescopeSelectionCaret = { fg = slate_colors.statement },
      TelescopeMatching = { fg = slate_colors.define, bold = true },
    }

    for group, opts in pairs(highlights) do
      vim.api.nvim_set_hl(0, group, opts)
    end
  end,
}
