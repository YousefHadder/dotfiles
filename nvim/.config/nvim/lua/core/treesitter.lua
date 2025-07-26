-- Treesitter Configuration
local M = {}

-- Languages to install
local languages = {
    "lua", "python", "javascript", "typescript", "rust", "go",
    "c", "cpp", "html", "css", "json", "yaml", "markdown", "netrw",
    "bash", "vim", "vimdoc", "query", "regex", "markdown_inline"
}

-- Install a parser
function M.install_parser(lang)
    local install_dir = vim.fn.stdpath("data") .. "/treesitter"
    vim.fn.mkdir(install_dir, "p")

    vim.notify("Installing " .. lang .. " parser...", vim.log.levels.INFO)

    -- Use vim.treesitter.language.add() for Neovim 0.11+
    local ok, err = pcall(function()
        vim.treesitter.language.add(lang)
    end)

    if not ok then
        vim.notify("Failed to install " .. lang .. " parser: " .. tostring(err), vim.log.levels.ERROR)
    else
        vim.notify(lang .. " parser installed successfully", vim.log.levels.INFO)
    end
end

-- Check if parser is installed
function M.is_parser_installed(lang)
    local ok = pcall(vim.treesitter.language.inspect, lang)
    return ok
end

-- Setup treesitter highlighting
local function setup_highlighting()
    -- Enable treesitter highlighting for all buffers
    vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
            local lang = vim.treesitter.language.get_lang(args.match)
            if lang and M.is_parser_installed(lang) then
                vim.treesitter.start(args.buf, lang)
            end
        end,
    })
end

-- Setup treesitter folding
local function setup_folding()
    -- Custom fold text function
    _G.treesitter_foldtext = function()
        local line = vim.fn.getline(vim.v.foldstart)
        local line_count = vim.v.foldend - vim.v.foldstart + 1
        return line .. " ... (" .. line_count .. " lines)"
    end

    vim.opt.foldtext = "v:lua.treesitter_foldtext()"
end

-- Setup treesitter text objects
local function setup_text_objects()
    -- Function text object
    vim.keymap.set({ "x", "o" }, "af", function()
        local node = vim.treesitter.get_node()
        while node do
            if node:type():match("function") then
                local start_row, start_col, end_row, end_col = node:range()
                vim.fn.setpos(".", { 0, start_row + 1, start_col + 1, 0 })
                vim.cmd("normal! v")
                vim.fn.setpos(".", { 0, end_row + 1, end_col, 0 })
                break
            end
            node = node:parent()
        end
    end, { desc = "Select around function" })

    -- Class text object
    vim.keymap.set({ "x", "o" }, "ac", function()
        local node = vim.treesitter.get_node()
        while node do
            if node:type():match("class") then
                local start_row, start_col, end_row, end_col = node:range()
                vim.fn.setpos(".", { 0, start_row + 1, start_col + 1, 0 })
                vim.cmd("normal! v")
                vim.fn.setpos(".", { 0, end_row + 1, end_col, 0 })
                break
            end
            node = node:parent()
        end
    end, { desc = "Select around class" })
end

-- Setup incremental selection
local function setup_incremental_selection()
    vim.keymap.set("n", "<C-space>", function()
        local node = vim.treesitter.get_node()
        if not node then return end

        local start_row, start_col, end_row, end_col = node:range()
        vim.fn.setpos(".", { 0, start_row + 1, start_col + 1, 0 })
        vim.cmd("normal! v")
        vim.fn.setpos(".", { 0, end_row + 1, end_col, 0 })
    end, { desc = "Init selection" })

    vim.keymap.set("x", "<C-space>", function()
        local node = vim.treesitter.get_node()
        if not node then return end

        node = node:parent()
        if not node then return end

        local start_row, start_col, end_row, end_col = node:range()
        vim.fn.setpos(".", { 0, start_row + 1, start_col + 1, 0 })
        vim.cmd("normal! o")
        vim.fn.setpos(".", { 0, end_row + 1, end_col, 0 })
    end, { desc = "Expand selection" })

    vim.keymap.set("x", "<BS>", function()
        local node = vim.treesitter.get_node()
        if not node then return end

        local child = node:child(0)
        if not child then return end

        local start_row, start_col, end_row, end_col = child:range()
        vim.fn.setpos(".", { 0, start_row + 1, start_col + 1, 0 })
        vim.cmd("normal! o")
        vim.fn.setpos(".", { 0, end_row + 1, end_col, 0 })
    end, { desc = "Shrink selection" })
end

-- Setup treesitter commands
local function setup_commands()
    vim.api.nvim_create_user_command("TSInstall", function(opts)
        local lang = opts.args
        if lang == "" then
            vim.notify("Usage: :TSInstall <language>", vim.log.levels.ERROR)
            return
        end
        M.install_parser(lang)
    end, { nargs = 1 })

    vim.api.nvim_create_user_command("TSInstallAll", function()
        for _, lang in ipairs(languages) do
            if not M.is_parser_installed(lang) then
                M.install_parser(lang)
            end
        end
    end, {})

    vim.api.nvim_create_user_command("TSInfo", function()
        local installed = {}
        local not_installed = {}

        for _, lang in ipairs(languages) do
            if M.is_parser_installed(lang) then
                table.insert(installed, lang)
            else
                table.insert(not_installed, lang)
            end
        end

        print("Installed parsers: " .. table.concat(installed, ", "))
        print("Not installed: " .. table.concat(not_installed, ", "))
    end, {})

    vim.api.nvim_create_user_command("TSHighlightInfo", function()
        vim.treesitter.inspect_tree()
    end, {})
end

-- Setup treesitter
function M.setup()
    -- Setup highlighting
    setup_highlighting()

    -- Setup folding
    setup_folding()

    -- Setup text objects
    setup_text_objects()

    -- Setup incremental selection
    setup_incremental_selection()

    -- Setup commands
    setup_commands()

    -- Auto-install parsers for opened files
    vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
            local lang = vim.treesitter.language.get_lang(args.match)
            if lang and not M.is_parser_installed(lang) then
                vim.defer_fn(function()
                    vim.notify("Parser for " .. lang .. " not installed. Run :TSInstall " .. lang, vim.log.levels.WARN)
                end, 100)
            end
        end,
    })
end

return M
