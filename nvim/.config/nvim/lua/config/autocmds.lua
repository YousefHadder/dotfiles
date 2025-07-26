-- Autocmds Configuration

-- Create autocommand groups
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
local highlight_group = augroup('YankHighlight', {})
autocmd('TextYankPost', {
    group = highlight_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

-- Remove whitespace on save
local whitespace_group = augroup('RemoveWhitespace', {})
autocmd('BufWritePre', {
    group = whitespace_group,
    pattern = '*',
    command = [[%s/\s\+$//e]],
})

-- Restore cursor position
local cursor_group = augroup('RestoreCursor', {})
autocmd('BufReadPost', {
    group = cursor_group,
    pattern = '*',
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Auto create directories
local mkdir_group = augroup('MkdirOnSave', {})
autocmd('BufWritePre', {
    group = mkdir_group,
    pattern = '*',
    callback = function()
        local dir = vim.fn.fnamemodify(vim.fn.expand('<afile>'), ':h')
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, 'p')
        end
    end,
})

-- Terminal settings
local terminal_group = augroup('TerminalSettings', {})
autocmd('TermOpen', {
    group = terminal_group,
    pattern = '*',
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = 'no'
    end,
})

-- File type specific settings
local filetype_group = augroup('FileTypeSettings', {})

-- Set indentation for specific file types
autocmd('FileType', {
    group = filetype_group,
    pattern = { 'javascript', 'typescript', 'html', 'css', 'json', 'yaml' },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
})

-- Disable auto comment on new line
autocmd('FileType', {
    group = filetype_group,
    pattern = '*',
    callback = function()
        vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
    end,
})
