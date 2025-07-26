-- Slate Colorscheme for Neovim
-- Author: YousefHadder
-- Date: 2025-07-26

local M = {}

-- Color palette
local colors = {
    -- Base colors
    bg = "#1e2329",
    bg_alt = "#252b35",
    bg_light = "#2d3441",
    bg_highlight = "#353e4c",
    bg_visual = "#3e4856",

    fg = "#c5cdd9",
    fg_alt = "#a8b2c1",
    fg_dark = "#7c8896",

    -- UI colors
    border = "#4a5568",
    cursor = "#528bff",
    selection = "#3e4856",
    search = "#4a90e2",

    -- Status colors
    error = "#e74c3c",
    warning = "#f39c12",
    info = "#3498db",
    hint = "#9b59b6",
    success = "#27ae60",

    -- Syntax colors
    red = "#e74c3c",
    orange = "#e67e22",
    yellow = "#f1c40f",
    green = "#27ae60",
    cyan = "#1abc9c",
    blue = "#3498db",
    purple = "#9b59b6",
    magenta = "#e91e63",

    -- Git colors
    git_add = "#27ae60",
    git_change = "#f39c12",
    git_delete = "#e74c3c",

    -- Additional colors
    comment = "#6c7b95",
    line_number = "#4a5568",
    cursorline = "#252b35",
    pmenu = "#2d3441",
    pmenu_sel = "#3e4856",

    -- Terminal colors
    terminal_black = "#1e2329",
    terminal_red = "#e74c3c",
    terminal_green = "#27ae60",
    terminal_yellow = "#f1c40f",
    terminal_blue = "#3498db",
    terminal_magenta = "#9b59b6",
    terminal_cyan = "#1abc9c",
    terminal_white = "#c5cdd9",
    terminal_bright_black = "#4a5568",
    terminal_bright_red = "#ec7063",
    terminal_bright_green = "#58d68d",
    terminal_bright_yellow = "#f4d03f",
    terminal_bright_blue = "#5dade2",
    terminal_bright_magenta = "#bb8fce",
    terminal_bright_cyan = "#76d7c4",
    terminal_bright_white = "#ecf0f1",
}

-- Helper function to set highlight groups
local function set_hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- Apply colorscheme
function M.setup()
    -- Clear existing highlights
    vim.cmd("highlight clear")
    if vim.fn.exists("syntax_on") then
        vim.cmd("syntax reset")
    end

    -- Set colorscheme name
    vim.g.colors_name = "slate"

    -- Set background
    vim.opt.background = "dark"

    -- Editor highlights
    set_hl("Normal", { fg = colors.fg, bg = colors.bg })
    set_hl("NormalFloat", { fg = colors.fg, bg = colors.bg_alt })
    set_hl("NormalNC", { fg = colors.fg_alt, bg = colors.bg })

    -- Cursor
    set_hl("Cursor", { fg = colors.bg, bg = colors.cursor })
    set_hl("CursorLine", { bg = colors.cursorline })
    set_hl("CursorColumn", { bg = colors.cursorline })
    set_hl("ColorColumn", { bg = colors.bg_alt })

    -- Line numbers
    set_hl("LineNr", { fg = colors.line_number })
    set_hl("CursorLineNr", { fg = colors.cursor, bold = true })
    set_hl("SignColumn", { fg = colors.line_number, bg = colors.bg })
    set_hl("FoldColumn", { fg = colors.comment, bg = colors.bg })

    -- Folding
    set_hl("Folded", { fg = colors.comment, bg = colors.bg_alt, italic = true })

    -- Statusline
    set_hl("StatusLine", { fg = colors.fg, bg = colors.bg_light })
    set_hl("StatusLineNC", { fg = colors.fg_dark, bg = colors.bg_alt })
    set_hl("WinSeparator", { fg = colors.border, bg = colors.bg })

    -- Tabline
    set_hl("TabLine", { fg = colors.fg_alt, bg = colors.bg_alt })
    set_hl("TabLineFill", { bg = colors.bg_alt })
    set_hl("TabLineSel", { fg = colors.fg, bg = colors.bg_light, bold = true })

    -- Popup menu
    set_hl("Pmenu", { fg = colors.fg, bg = colors.pmenu })
    set_hl("PmenuSel", { fg = colors.fg, bg = colors.pmenu_sel, bold = true })
    set_hl("PmenuSbar", { bg = colors.bg_light })
    set_hl("PmenuThumb", { bg = colors.border })
    set_hl("PmenuKind", { fg = colors.purple, bg = colors.pmenu })
    set_hl("PmenuKindSel", { fg = colors.purple, bg = colors.pmenu_sel })
    set_hl("PmenuExtra", { fg = colors.comment, bg = colors.pmenu })
    set_hl("PmenuExtraSel", { fg = colors.comment, bg = colors.pmenu_sel })

    -- Search
    set_hl("Search", { fg = colors.bg, bg = colors.search })
    set_hl("IncSearch", { fg = colors.bg, bg = colors.orange })
    set_hl("CurSearch", { fg = colors.bg, bg = colors.orange })

    -- Visual
    set_hl("Visual", { bg = colors.selection })
    set_hl("VisualNOS", { bg = colors.selection })

    -- Messages
    set_hl("ErrorMsg", { fg = colors.error, bold = true })
    set_hl("WarningMsg", { fg = colors.warning, bold = true })
    set_hl("ModeMsg", { fg = colors.green, bold = true })
    set_hl("MoreMsg", { fg = colors.blue, bold = true })
    set_hl("Question", { fg = colors.cyan, bold = true })

    -- Diff
    set_hl("DiffAdd", { fg = colors.git_add, bg = colors.bg_alt })
    set_hl("DiffChange", { fg = colors.git_change, bg = colors.bg_alt })
    set_hl("DiffDelete", { fg = colors.git_delete, bg = colors.bg_alt })
    set_hl("DiffText", { fg = colors.bg, bg = colors.git_change })

    -- Spell
    set_hl("SpellBad", { undercurl = true, sp = colors.error })
    set_hl("SpellCap", { undercurl = true, sp = colors.warning })
    set_hl("SpellLocal", { undercurl = true, sp = colors.cyan })
    set_hl("SpellRare", { undercurl = true, sp = colors.purple })

    -- Syntax highlighting
    set_hl("Comment", { fg = colors.comment, italic = true })
    set_hl("Constant", { fg = colors.orange })
    set_hl("String", { fg = colors.green })
    set_hl("Character", { fg = colors.green })
    set_hl("Number", { fg = colors.orange })
    set_hl("Boolean", { fg = colors.orange })
    set_hl("Float", { fg = colors.orange })

    set_hl("Identifier", { fg = colors.red })
    set_hl("Function", { fg = colors.blue })

    set_hl("Statement", { fg = colors.purple })
    set_hl("Conditional", { fg = colors.purple })
    set_hl("Repeat", { fg = colors.purple })
    set_hl("Label", { fg = colors.purple })
    set_hl("Operator", { fg = colors.cyan })
    set_hl("Keyword", { fg = colors.purple })
    set_hl("Exception", { fg = colors.purple })

    set_hl("PreProc", { fg = colors.yellow })
    set_hl("Include", { fg = colors.purple })
    set_hl("Define", { fg = colors.purple })
    set_hl("Macro", { fg = colors.purple })
    set_hl("PreCondit", { fg = colors.yellow })

    set_hl("Type", { fg = colors.yellow })
    set_hl("StorageClass", { fg = colors.yellow })
    set_hl("Structure", { fg = colors.yellow })
    set_hl("Typedef", { fg = colors.yellow })

    set_hl("Special", { fg = colors.cyan })
    set_hl("SpecialChar", { fg = colors.cyan })
    set_hl("Tag", { fg = colors.cyan })
    set_hl("Delimiter", { fg = colors.fg })
    set_hl("SpecialComment", { fg = colors.cyan })
    set_hl("Debug", { fg = colors.cyan })

    set_hl("Underlined", { underline = true })
    set_hl("Ignore", { fg = colors.comment })
    set_hl("Error", { fg = colors.error })
    set_hl("Todo", { fg = colors.bg, bg = colors.yellow, bold = true })

    -- Treesitter highlights
    set_hl("@variable", { fg = colors.fg })
    set_hl("@variable.builtin", { fg = colors.red })
    set_hl("@variable.parameter", { fg = colors.red })
    set_hl("@variable.member", { fg = colors.red })

    set_hl("@constant", { fg = colors.orange })
    set_hl("@constant.builtin", { fg = colors.orange })
    set_hl("@constant.macro", { fg = colors.orange })

    set_hl("@module", { fg = colors.yellow })
    set_hl("@label", { fg = colors.purple })

    set_hl("@string", { fg = colors.green })
    set_hl("@string.documentation", { fg = colors.comment })
    set_hl("@string.regexp", { fg = colors.cyan })
    set_hl("@string.escape", { fg = colors.cyan })
    set_hl("@string.special", { fg = colors.cyan })

    set_hl("@character", { fg = colors.green })
    set_hl("@character.special", { fg = colors.cyan })

    set_hl("@number", { fg = colors.orange })
    set_hl("@number.float", { fg = colors.orange })

    set_hl("@boolean", { fg = colors.orange })

    set_hl("@function", { fg = colors.blue })
    set_hl("@function.builtin", { fg = colors.blue })
    set_hl("@function.call", { fg = colors.blue })
    set_hl("@function.macro", { fg = colors.blue })

    set_hl("@function.method", { fg = colors.blue })
    set_hl("@function.method.call", { fg = colors.blue })

    set_hl("@constructor", { fg = colors.yellow })
    set_hl("@operator", { fg = colors.cyan })

    set_hl("@keyword", { fg = colors.purple })
    set_hl("@keyword.function", { fg = colors.purple })
    set_hl("@keyword.operator", { fg = colors.purple })
    set_hl("@keyword.import", { fg = colors.purple })
    set_hl("@keyword.storage", { fg = colors.purple })
    set_hl("@keyword.repeat", { fg = colors.purple })
    set_hl("@keyword.return", { fg = colors.purple })
    set_hl("@keyword.debug", { fg = colors.purple })
    set_hl("@keyword.exception", { fg = colors.purple })
    set_hl("@keyword.conditional", { fg = colors.purple })
    set_hl("@keyword.directive", { fg = colors.purple })
    set_hl("@keyword.directive.define", { fg = colors.purple })

    set_hl("@type", { fg = colors.yellow })
    set_hl("@type.builtin", { fg = colors.yellow })
    set_hl("@type.definition", { fg = colors.yellow })

    set_hl("@attribute", { fg = colors.cyan })
    set_hl("@property", { fg = colors.red })

    set_hl("@comment", { fg = colors.comment, italic = true })
    set_hl("@comment.documentation", { fg = colors.comment, italic = true })

    set_hl("@tag", { fg = colors.red })
    set_hl("@tag.attribute", { fg = colors.orange })
    set_hl("@tag.delimiter", { fg = colors.fg })

    -- LSP semantic tokens
    set_hl("@lsp.type.class", { fg = colors.yellow })
    set_hl("@lsp.type.decorator", { fg = colors.cyan })
    set_hl("@lsp.type.enum", { fg = colors.yellow })
    set_hl("@lsp.type.enumMember", { fg = colors.orange })
    set_hl("@lsp.type.function", { fg = colors.blue })
    set_hl("@lsp.type.interface", { fg = colors.yellow })
    set_hl("@lsp.type.macro", { fg = colors.cyan })
    set_hl("@lsp.type.method", { fg = colors.blue })
    set_hl("@lsp.type.namespace", { fg = colors.yellow })
    set_hl("@lsp.type.parameter", { fg = colors.red })
    set_hl("@lsp.type.property", { fg = colors.red })
    set_hl("@lsp.type.struct", { fg = colors.yellow })
    set_hl("@lsp.type.type", { fg = colors.yellow })
    set_hl("@lsp.type.typeParameter", { fg = colors.yellow })
    set_hl("@lsp.type.variable", { fg = colors.fg })

    -- Diagnostic highlights
    set_hl("DiagnosticError", { fg = colors.error })
    set_hl("DiagnosticWarn", { fg = colors.warning })
    set_hl("DiagnosticInfo", { fg = colors.info })
    set_hl("DiagnosticHint", { fg = colors.hint })
    set_hl("DiagnosticOk", { fg = colors.success })

    set_hl("DiagnosticVirtualTextError", { fg = colors.error, bg = colors.bg_alt })
    set_hl("DiagnosticVirtualTextWarn", { fg = colors.warning, bg = colors.bg_alt })
    set_hl("DiagnosticVirtualTextInfo", { fg = colors.info, bg = colors.bg_alt })
    set_hl("DiagnosticVirtualTextHint", { fg = colors.hint, bg = colors.bg_alt })

    set_hl("DiagnosticUnderlineError", { undercurl = true, sp = colors.error })
    set_hl("DiagnosticUnderlineWarn", { undercurl = true, sp = colors.warning })
    set_hl("DiagnosticUnderlineInfo", { undercurl = true, sp = colors.info })
    set_hl("DiagnosticUnderlineHint", { undercurl = true, sp = colors.hint })

    set_hl("DiagnosticSignError", { fg = colors.error, bg = colors.bg })
    set_hl("DiagnosticSignWarn", { fg = colors.warning, bg = colors.bg })
    set_hl("DiagnosticSignInfo", { fg = colors.info, bg = colors.bg })
    set_hl("DiagnosticSignHint", { fg = colors.hint, bg = colors.bg })

    -- LSP references
    set_hl("LspReferenceText", { bg = colors.bg_highlight })
    set_hl("LspReferenceRead", { bg = colors.bg_highlight })
    set_hl("LspReferenceWrite", { bg = colors.bg_highlight })

    -- LSP Inlay hints
    set_hl("LspInlayHint", { fg = colors.comment, bg = colors.bg_alt, italic = true })

    -- Git signs
    set_hl("GitSignsAdd", { fg = colors.git_add })
    set_hl("GitSignsChange", { fg = colors.git_change })
    set_hl("GitSignsDelete", { fg = colors.git_delete })

    -- Telescope (if used)
    set_hl("TelescopeNormal", { fg = colors.fg, bg = colors.bg_alt })
    set_hl("TelescopeBorder", { fg = colors.border, bg = colors.bg_alt })
    set_hl("TelescopePromptNormal", { fg = colors.fg, bg = colors.bg_light })
    set_hl("TelescopePromptBorder", { fg = colors.border, bg = colors.bg_light })
    set_hl("TelescopePromptTitle", { fg = colors.blue, bg = colors.bg_light })
    set_hl("TelescopePreviewTitle", { fg = colors.green, bg = colors.bg_alt })
    set_hl("TelescopeResultsTitle", { fg = colors.red, bg = colors.bg_alt })
    set_hl("TelescopeSelection", { fg = colors.fg, bg = colors.selection })
    set_hl("TelescopeSelectionCaret", { fg = colors.cursor, bg = colors.selection })

    -- WhichKey (if used)
    set_hl("WhichKey", { fg = colors.blue })
    set_hl("WhichKeyGroup", { fg = colors.purple })
    set_hl("WhichKeyDesc", { fg = colors.fg })
    set_hl("WhichKeySeperator", { fg = colors.comment })
    set_hl("WhichKeyFloat", { bg = colors.bg_alt })
    set_hl("WhichKeyBorder", { fg = colors.border })

    -- Netrw
    set_hl("netrwDir", { fg = colors.blue })
    set_hl("netrwClassify", { fg = colors.blue })
    set_hl("netrwLink", { fg = colors.cyan })
    set_hl("netrwSymLink", { fg = colors.cyan })
    set_hl("netrwExe", { fg = colors.green })
    set_hl("netrwComment", { fg = colors.comment })
    set_hl("netrwList", { fg = colors.yellow })
    set_hl("netrwHelpCmd", { fg = colors.cyan })
    set_hl("netrwCmdSep", { fg = colors.comment })
    set_hl("netrwVersion", { fg = colors.green })

    -- Terminal colors
    vim.g.terminal_color_0 = colors.terminal_black
    vim.g.terminal_color_1 = colors.terminal_red
    vim.g.terminal_color_2 = colors.terminal_green
    vim.g.terminal_color_3 = colors.terminal_yellow
    vim.g.terminal_color_4 = colors.terminal_blue
    vim.g.terminal_color_5 = colors.terminal_magenta
    vim.g.terminal_color_6 = colors.terminal_cyan
    vim.g.terminal_color_7 = colors.terminal_white
    vim.g.terminal_color_8 = colors.terminal_bright_black
    vim.g.terminal_color_9 = colors.terminal_bright_red
    vim.g.terminal_color_10 = colors.terminal_bright_green
    vim.g.terminal_color_11 = colors.terminal_bright_yellow
    vim.g.terminal_color_12 = colors.terminal_bright_blue
    vim.g.terminal_color_13 = colors.terminal_bright_magenta
    vim.g.terminal_color_14 = colors.terminal_bright_cyan
    vim.g.terminal_color_15 = colors.terminal_bright_white

    -- Float border
    set_hl("FloatBorder", { fg = colors.border, bg = colors.bg_alt })
    set_hl("FloatTitle", { fg = colors.blue, bg = colors.bg_alt })

    -- Health check
    set_hl("healthError", { fg = colors.error })
    set_hl("healthSuccess", { fg = colors.success })
    set_hl("healthWarning", { fg = colors.warning })

    -- Notify (if used)
    set_hl("NotifyERRORBorder", { fg = colors.error })
    set_hl("NotifyWARNBorder", { fg = colors.warning })
    set_hl("NotifyINFOBorder", { fg = colors.info })
    set_hl("NotifyDEBUGBorder", { fg = colors.comment })
    set_hl("NotifyTRACEBorder", { fg = colors.purple })
    set_hl("NotifyERRORIcon", { fg = colors.error })
    set_hl("NotifyWARNIcon", { fg = colors.warning })
    set_hl("NotifyINFOIcon", { fg = colors.info })
    set_hl("NotifyDEBUGIcon", { fg = colors.comment })
    set_hl("NotifyTRACEIcon", { fg = colors.purple })
    set_hl("NotifyERRORTitle", { fg = colors.error })
    set_hl("NotifyWARNTitle", { fg = colors.warning })
    set_hl("NotifyINFOTitle", { fg = colors.info })
    set_hl("NotifyDEBUGTitle", { fg = colors.comment })
    set_hl("NotifyTRACETitle", { fg = colors.purple })
end

-- Export colors for use in other parts of config
M.colors = colors

return M
