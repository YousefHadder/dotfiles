-- Statusline Configuration
local M = {}

-- Define mode names and colors
local modes = {
    ["n"] = { name = "NORMAL", hl = "StatusLineNormal" },
    ["no"] = { name = "NORMAL", hl = "StatusLineNormal" },
    ["v"] = { name = "VISUAL", hl = "StatusLineVisual" },
    ["V"] = { name = "V-LINE", hl = "StatusLineVisual" },
    [""] = { name = "V-BLOCK", hl = "StatusLineVisual" },
    ["s"] = { name = "SELECT", hl = "StatusLineSelect" },
    ["S"] = { name = "S-LINE", hl = "StatusLineSelect" },
    [""] = { name = "S-BLOCK", hl = "StatusLineSelect" },
    ["i"] = { name = "INSERT", hl = "StatusLineInsert" },
    ["ic"] = { name = "INSERT", hl = "StatusLineInsert" },
    ["R"] = { name = "REPLACE", hl = "StatusLineReplace" },
    ["Rv"] = { name = "V-REPLACE", hl = "StatusLineReplace" },
    ["c"] = { name = "COMMAND", hl = "StatusLineCommand" },
    ["cv"] = { name = "VIM-EX", hl = "StatusLineCommand" },
    ["ce"] = { name = "EX", hl = "StatusLineCommand" },
    ["r"] = { name = "PROMPT", hl = "StatusLinePrompt" },
    ["rm"] = { name = "MORE", hl = "StatusLinePrompt" },
    ["r?"] = { name = "CONFIRM", hl = "StatusLinePrompt" },
    ["!"] = { name = "SHELL", hl = "StatusLineShell" },
    ["t"] = { name = "TERMINAL", hl = "StatusLineTerminal" },
}

-- Define colors for different modes
local function setup_colors()
    local colors = {
        normal = { fg = "#282828", bg = "#83a598" },
        insert = { fg = "#282828", bg = "#b8bb26" },
        visual = { fg = "#282828", bg = "#fe8019" },
        replace = { fg = "#282828", bg = "#fb4934" },
        command = { fg = "#282828", bg = "#d3869b" },
        terminal = { fg = "#282828", bg = "#8ec07c" },
        inactive = { fg = "#a89984", bg = "#3c3836" },
        git = { fg = "#b8bb26", bg = "#504945" },
        diagnostics = { fg = "#ebdbb2", bg = "#504945" },
        filename = { fg = "#ebdbb2", bg = "#504945" },
        location = { fg = "#282828", bg = "#a89984" },
    }

    -- Set highlight groups
    vim.api.nvim_set_hl(0, "StatusLineNormal", colors.normal)
    vim.api.nvim_set_hl(0, "StatusLineInsert", colors.insert)
    vim.api.nvim_set_hl(0, "StatusLineVisual", colors.visual)
    vim.api.nvim_set_hl(0, "StatusLineReplace", colors.replace)
    vim.api.nvim_set_hl(0, "StatusLineCommand", colors.command)
    vim.api.nvim_set_hl(0, "StatusLineSelect", colors.visual)
    vim.api.nvim_set_hl(0, "StatusLinePrompt", colors.command)
    vim.api.nvim_set_hl(0, "StatusLineShell", colors.terminal)
    vim.api.nvim_set_hl(0, "StatusLineTerminal", colors.terminal)
    vim.api.nvim_set_hl(0, "StatusLineInactive", colors.inactive)
    vim.api.nvim_set_hl(0, "StatusLineGit", colors.git)
    vim.api.nvim_set_hl(0, "StatusLineDiagnostics", colors.diagnostics)
    vim.api.nvim_set_hl(0, "StatusLineFilename", colors.filename)
    vim.api.nvim_set_hl(0, "StatusLineLocation", colors.location)
end

-- Get current mode
local function get_mode()
    local mode = vim.api.nvim_get_mode().mode
    local mode_info = modes[mode] or { name = mode:upper(), hl = "StatusLineNormal" }
    return string.format("%%#%s# %s ", mode_info.hl, mode_info.name)
end

-- Get git branch
local git_branch_cache = ""
local function get_git_branch()
    vim.system(
        { "git", "rev-parse", "--abbrev-ref", "HEAD" },
        { text = true },
        function(obj)
            if obj.code == 0 then
                git_branch_cache = obj.stdout:gsub("\n", "")
            else
                git_branch_cache = ""
            end
        end
    )
    
    if git_branch_cache ~= "" then
        return string.format("%%#StatusLineGit#  %s ", git_branch_cache)
    end
    return ""
end

-- Get diagnostics
local function get_diagnostics()
    local diagnostics = vim.diagnostic.count(0)
    local parts = {}
    
    if diagnostics[vim.diagnostic.severity.ERROR] and diagnostics[vim.diagnostic.severity.ERROR] > 0 then
        table.insert(parts, string.format("%%#DiagnosticError# %d", diagnostics[vim.diagnostic.severity.ERROR]))
    end
    if diagnostics[vim.diagnostic.severity.WARN] and diagnostics[vim.diagnostic.severity.WARN] > 0 then
        table.insert(parts, string.format("%%#DiagnosticWarn# %d", diagnostics[vim.diagnostic.severity.WARN]))
    end
    if diagnostics[vim.diagnostic.severity.INFO] and diagnostics[vim.diagnostic.severity.INFO] > 0 then
        table.insert(parts, string.format("%%#DiagnosticInfo# %d", diagnostics[vim.diagnostic.severity.INFO]))
    end
    if diagnostics[vim.diagnostic.severity.HINT] and diagnostics[vim.diagnostic.severity.HINT] > 0 then
        table.insert(parts, string.format("%%#DiagnosticHint# %d", diagnostics[vim.diagnostic.severity.HINT]))
    end
    
    if #parts > 0 then
        return string.format("%%#StatusLineDiagnostics# %s ", table.concat(parts, " "))
    end
    return ""
end

-- Get file info
local function get_file_info()
    local filename = vim.fn.expand("%:t")
    if filename == "" then
        filename = "[No Name]"
    end
    
    local modified = vim.bo.modified and " [+]" or ""
    local readonly = vim.bo.readonly and " [RO]" or ""
    local filetype = vim.bo.filetype ~= "" and string.format(" [%s]", vim.bo.filetype) or ""
    
    return string.format("%%#StatusLineFilename# %s%s%s%s ", filename, modified, readonly, filetype)
end

-- Get file encoding and format
local function get_file_format()
    local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
    local format = vim.bo.fileformat
    return string.format("%%#StatusLineDiagnostics# %s[%s] ", encoding, format)
end

-- Get cursor position
local function get_location()
    local line = vim.fn.line(".")
    local col = vim.fn.virtcol(".")
    local total_lines = vim.fn.line("$")
    local percent = math.floor(line * 100 / total_lines)
    
    return string.format("%%#StatusLineLocation# %d:%d [%d%%%%] ", line, col, percent)
end

-- Get LSP status
local function get_lsp_status()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients > 0 then
        local names = {}
        for _, client in ipairs(clients) do
            table.insert(names, client.name)
        end
        return string.format("%%#StatusLineDiagnostics# LSP:%s ", table.concat(names, ","))
    end
    return ""
end

-- Get Treesitter status
local function get_treesitter_status()
    local buf = vim.api.nvim_get_current_buf()
    if vim.treesitter.highlighter.active[buf] then
        return "%#StatusLineDiagnostics# TS "
    end
    return ""
end

-- Build statusline
function M.build()
    local parts = {
        get_mode(),
        get_git_branch(),
        get_file_info(),
        get_diagnostics(),
        "%=", -- Right align
        get_treesitter_status(),
        get_lsp_status(),
        get_file_format(),
        get_location(),
    }
    
    return table.concat(parts)
end

-- Setup statusline
function M.setup()
    setup_colors()
    
    -- Set statusline
    vim.o.statusline = "%!v:lua.require('core.statusline').build()"
    
    -- Initialize git branch
    get_git_branch()
    
    -- Refresh statusline on certain events
    vim.api.nvim_create_autocmd(
        { "ModeChanged", "BufEnter", "BufWritePost", "DiagnosticChanged", "LspAttach", "LspDetach" },
        {
            callback = function()
                vim.cmd("redrawstatus")
            end,
        }
    )
    
    -- Update git branch on buffer enter and write
    vim.api.nvim_create_autocmd(
        { "BufEnter", "BufWritePost", "FocusGained" },
        {
            callback = function()
                get_git_branch()
            end,
        }
    )
end

return M
