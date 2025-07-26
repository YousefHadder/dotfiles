-- Completion Configuration
local M = {}

-- Completion sources
local sources = {
    buffer = true,
    path = true,
    lsp = true,
    snippet = true,
}

-- Setup completion keymaps
local function setup_keymaps()
    local keymap = vim.keymap.set
    local opts = { expr = true, silent = true }
    
    -- Tab completion
    keymap("i", "<Tab>", function()
        if vim.fn.pumvisible() == 1 then
            return "<C-n>"
        else
            local line = vim.fn.getline(".")
            local col = vim.fn.col(".") - 1
            if col == 0 or line:sub(col, col):match("%s") then
                return "<Tab>"
            else
                return "<C-x><C-o>"
            end
        end
    end, opts)
    
    -- Shift-Tab for previous item
    keymap("i", "<S-Tab>", function()
        if vim.fn.pumvisible() == 1 then
            return "<C-p>"
        else
            return "<S-Tab>"
        end
    end, opts)
    
    -- Enter to confirm completion
    keymap("i", "<CR>", function()
        if vim.fn.pumvisible() == 1 then
            return "<C-y>"
        else
            return "<CR>"
        end
    end, opts)
    
    -- Escape to cancel completion
    keymap("i", "<Esc>", function()
        if vim.fn.pumvisible() == 1 then
            return "<C-e><Esc>"
        else
            return "<Esc>"
        end
    end, opts)
    
    -- Manual trigger completion
    keymap("i", "<C-Space>", "<C-x><C-o>", { silent = true })
    
    -- Different completion modes
    keymap("i", "<C-x><C-f>", "<C-x><C-f>", { desc = "File completion" })
    keymap("i", "<C-x><C-l>", "<C-x><C-l>", { desc = "Line completion" })
    keymap("i", "<C-x><C-k>", "<C-x><C-k>", { desc = "Dictionary completion" })
    keymap("i", "<C-x><C-s>", "<C-x><C-s>", { desc = "Spelling completion" })
end

-- Custom omnifunc that combines multiple sources
function M.omnifunc(findstart, base)
    if findstart == 1 then
        -- Find the start of the word
        local line = vim.fn.getline(".")
        local col = vim.fn.col(".") - 1
        
        while col > 0 and line:sub(col, col):match("[%w_.-]") do
            col = col - 1
        end
        
        return col
    else
        local results = {}
        
        -- Buffer completion
        if sources.buffer then
            local buffer_words = M.get_buffer_words(base)
            for _, word in ipairs(buffer_words) do
                table.insert(results, {
                    word = word,
                    menu = "[Buffer]",
                    kind = "Text",
                })
            end
        end
        
        -- Path completion
        if sources.path and base:match("[./~]") then
            local paths = M.get_path_completions(base)
            for _, path in ipairs(paths) do
                table.insert(results, {
                    word = path,
                    menu = "[Path]",
                    kind = vim.fn.isdirectory(path) == 1 and "Folder" or "File",
                })
            end
        end
        
        -- LSP completion (if available)
        if sources.lsp then
            local lsp_results = M.get_lsp_completions(base)
            for _, item in ipairs(lsp_results) do
                table.insert(results, item)
            end
        end
        
        -- Snippet completions
        if sources.snippet then
            local snippet_results = M.get_snippet_completions(base)
            for _, item in ipairs(snippet_results) do
                table.insert(results, item)
            end
        end
        
        -- Sort results by relevance
        table.sort(results, function(a, b)
            -- Prioritize exact matches
            local a_exact = a.word:lower():sub(1, #base) == base:lower()
            local b_exact = b.word:lower():sub(1, #base) == base:lower()
            if a_exact ~= b_exact then
                return a_exact
            end
            
            -- Then by length (shorter first)
            if #a.word ~= #b.word then
                return #a.word < #b.word
            end
            
            -- Finally alphabetically
            return a.word < b.word
        end)
        
        return results
    end
end

-- Get words from current buffer
function M.get_buffer_words(base)
    local words = {}
    local seen = {}
    
    -- Get all lines in buffer
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    
    for _, line in ipairs(lines) do
        -- Extract words from line
        for word in line:gmatch("[%w_]+") do
            if word:len() >= 3 and word:lower():find("^" .. vim.pesc(base:lower())) then
                if not seen[word] then
                    seen[word] = true
                    table.insert(words, word)
                end
            end
        end
    end
    
    return words
end

-- Get path completions
function M.get_path_completions(base)
    local paths = {}
    local dir, prefix
    
    if base:match("/") then
        dir = vim.fn.fnamemodify(base, ":h")
        prefix = vim.fn.fnamemodify(base, ":t")
    else
        dir = "."
        prefix = base
    end
    
    -- Expand ~ to home directory
    dir = vim.fn.expand(dir)
    
    -- Get files in directory
    local files = vim.fn.readdir(dir, function(name)
        return name:sub(1, 1) ~= "." or prefix:sub(1, 1) == "."
    end)
    
    for _, file in ipairs(files) do
        if file:lower():find("^" .. vim.pesc(prefix:lower())) then
            local full_path = dir .. "/" .. file
            if vim.fn.isdirectory(full_path) == 1 then
                table.insert(paths, file .. "/")
            else
                table.insert(paths, file)
            end
        end
    end
    
    return paths
end

-- Get LSP completions
function M.get_lsp_completions(base)
    local results = {}
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    
    if #clients == 0 then
        return results
    end
    
    -- Use the built-in LSP omnifunc if available
    local lsp_results = vim.lsp.omnifunc(0, base)
    
    if type(lsp_results) == "table" then
        for _, item in ipairs(lsp_results) do
            local completion_item = {
                word = item.word or item.label,
                menu = "[LSP]",
                kind = vim.lsp.protocol.CompletionItemKind[item.kind] or "Text",
                info = item.detail or "",
            }
            table.insert(results, completion_item)
        end
    end
    
    return results
end

-- Snippets
local snippets = {
    lua = {
        ["func"] = "function ${1:name}(${2:args})\n    ${0}\nend",
        ["local"] = "local ${1:name} = ${0:value}",
        ["if"] = "if ${1:condition} then\n    ${0}\nend",
        ["for"] = "for ${1:i} = ${2:1}, ${3:10} do\n    ${0}\nend",
        ["fori"] = "for ${1:i}, ${2:v} in ipairs(${3:table}) do\n    ${0}\nend",
        ["forp"] = "for ${1:k}, ${2:v} in pairs(${3:table}) do\n    ${0}\nend",
    },
    python = {
        ["def"] = "def ${1:name}(${2:args}):\n    ${0:pass}",
        ["class"] = "class ${1:Name}:\n    def __init__(self${2:, args}):\n        ${0:pass}",
        ["if"] = "if ${1:condition}:\n    ${0:pass}",
        ["for"] = "for ${1:item} in ${2:iterable}:\n    ${0:pass}",
        ["try"] = "try:\n    ${1:pass}\nexcept ${2:Exception} as ${3:e}:\n    ${0:pass}",
    },
    javascript = {
        ["func"] = "function ${1:name}(${2:args}) {\n    ${0}\n}",
        ["arrow"] = "const ${1:name} = (${2:args}) => {\n    ${0}\n}",
        ["if"] = "if (${1:condition}) {\n    ${0}\n}",
        ["for"] = "for (let ${1:i} = 0; ${1} < ${2:length}; ${1}++) {\n    ${0}\n}",
        ["class"] = "class ${1:Name} {\n    constructor(${2:args}) {\n        ${0}\n    }\n}",
    },
}

-- Get snippet completions
function M.get_snippet_completions(base)
    local results = {}
    local ft = vim.bo.filetype
    local ft_snippets = snippets[ft]
    
    if ft_snippets then
        for trigger, _ in pairs(ft_snippets) do
            if trigger:lower():find("^" .. vim.pesc(base:lower())) then
                table.insert(results, {
                    word = trigger,
                    menu = "[Snippet]",
                    kind = "Snippet",
                })
            end
        end
    end
    
    return results
end

-- Expand snippet
function M.expand_snippet(trigger)
    local ft = vim.bo.filetype
    local snippet = snippets[ft] and snippets[ft][trigger]
    
    if not snippet then
        return false
    end
    
    -- Simple snippet expansion (without placeholders for now)
    local lines = vim.split(snippet:gsub("${%d+:?([^}]*)}", "%1"):gsub("${%d+}", ""), "\n")
    
    -- Get current position
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    
    -- Find trigger start
    local trigger_start = col - #trigger
    
    -- Replace trigger with snippet
    local before = line:sub(1, trigger_start)
    local after = line:sub(col + 1)
    
    -- Insert snippet
    local new_lines = {}
    for i, snippet_line in ipairs(lines) do
        if i == 1 then
            table.insert(new_lines, before .. snippet_line)
        else
            table.insert(new_lines, snippet_line)
        end
    end
    new_lines[#new_lines] = new_lines[#new_lines] .. after
    
    -- Replace lines
    vim.api.nvim_buf_set_lines(0, row - 1, row, false, new_lines)
    
    -- Move cursor to first placeholder or end
    local placeholder_pos = snippet:find("${0")
    if placeholder_pos then
        -- Simple cursor positioning
        vim.api.nvim_win_set_cursor(0, { row + #lines - 1, #new_lines[#new_lines] - #after })
    end
    
    return true
end

-- Setup completion autocmds
local function setup_autocmds()
    local group = vim.api.nvim_create_augroup("Completion", { clear = true })
    
    -- Set omnifunc for all buffers
    vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
        callback = function()
            if vim.bo.omnifunc == "" then
                vim.bo.omnifunc = "v:lua.require('core.completion').omnifunc"
            end
        end,
    })
    
    -- Auto-trigger completion after typing 3 characters
    vim.api.nvim_create_autocmd("TextChangedI", {
        group = group,
        callback = function()
            local col = vim.fn.col(".") - 1
            local line = vim.fn.getline(".")
            local char = line:sub(col, col)
            
            -- Check if we should trigger completion
            if char:match("[%w_]") then
                local word_start = col
                while word_start > 0 and line:sub(word_start, word_start):match("[%w_]") do
                    word_start = word_start - 1
                end
                
                local word_len = col - word_start
                if word_len >= 3 and vim.fn.pumvisible() == 0 then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, true, true), "n")
                end
            end
        end,
    })
    
    -- Snippet expansion
    vim.api.nvim_create_autocmd("CompleteDone", {
        group = group,
        callback = function()
            local completed_item = vim.v.completed_item
            if completed_item.word and completed_item.menu == "[Snippet]" then
                M.expand_snippet(completed_item.word)
            end
        end,
    })
end

-- Setup function
function M.setup()
    setup_keymaps()
    setup_autocmds()
end

return M
