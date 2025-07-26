-- Formatting Configuration
local M = {}

-- Formatters configuration
local formatters = {
    -- Lua
    lua = {
        command = "stylua",
        args = {
            "--search-parent-directories",
            "--stdin-filepath",
            "%",
            "-",
        },
    },
    -- Python
    python = {
        command = "black",
        args = { "-", "--quiet", "--stdin-filename", "%" },
    },
    -- JavaScript/TypeScript
    javascript = {
        command = "prettier",
        args = { "--stdin-filepath", "%" },
    },
    typescript = {
        command = "prettier",
        args = { "--stdin-filepath", "%" },
    },
    javascriptreact = {
        command = "prettier",
        args = { "--stdin-filepath", "%" },
    },
    typescriptreact = {
        command = "prettier",
        args = { "--stdin-filepath", "%" },
    },
    -- JSON
    json = {
        command = "jq",
        args = { "." },
    },
    -- Go
    go = {
        command = "gofmt",
        args = {},
    },
    -- Rust
    rust = {
        command = "rustfmt",
        args = { "--edition", "2021" },
    },
    -- C/C++
    c = {
        command = "clang-format",
        args = { "--assume-filename=%", "-style=file" },
    },
    cpp = {
        command = "clang-format",
        args = { "--assume-filename=%", "-style=file" },
    },
    -- Markdown
    markdown = {
        command = "prettier",
        args = { "--stdin-filepath", "%", "--prose-wrap", "always" },
    },
    -- YAML
    yaml = {
        command = "prettier",
        args = { "--stdin-filepath", "%" },
    },
    -- HTML/CSS
    html = {
        command = "prettier",
        args = { "--stdin-filepath", "%" },
    },
    css = {
        command = "prettier",
        args = { "--stdin-filepath", "%" },
    },
    -- Shell
    sh = {
        command = "shfmt",
        args = { "-i", "2", "-bn", "-ci", "-sr" },
    },
    bash = {
        command = "shfmt",
        args = { "-i", "2", "-bn", "-ci", "-sr" },
    },
}

-- Format buffer using external formatter
function M.format_buffer()
    local filetype = vim.bo.filetype
    local formatter = formatters[filetype]
    
    if not formatter then
        -- Fall back to LSP formatting if available
        vim.lsp.buf.format({ async = true })
        return
    end
    
    -- Check if formatter command exists
    if vim.fn.executable(formatter.command) == 0 then
        vim.notify(string.format("Formatter '%s' not found for %s", formatter.command, filetype), vim.log.levels.WARN)
        -- Fall back to LSP formatting
        vim.lsp.buf.format({ async = true })
        return
    end
    
    -- Get current buffer content
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local content = table.concat(lines, "\n")
    
    -- Prepare command
    local cmd = { formatter.command }
    for _, arg in ipairs(formatter.args) do
        -- Replace % with actual filename
        local processed_arg = arg:gsub("%%", vim.fn.expand("%:p"))
        table.insert(cmd, processed_arg)
    end
    
    -- Run formatter
    vim.system(cmd, {
        stdin = content,
        text = true,
    }, function(obj)
        if obj.code ~= 0 then
            vim.schedule(function()
                vim.notify(string.format("Formatting failed: %s", obj.stderr or "Unknown error"), vim.log.levels.ERROR)
            end)
            return
        end
        
        -- Apply formatted content
        vim.schedule(function()
            local formatted_lines = vim.split(obj.stdout, "\n")
            -- Remove last empty line if present
            if formatted_lines[#formatted_lines] == "" then
                table.remove(formatted_lines)
            end
            
            -- Only update if content changed
            local current_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            local changed = false
            
            if #current_lines ~= #formatted_lines then
                changed = true
            else
                for i, line in ipairs(current_lines) do
                    if line ~= formatted_lines[i] then
                        changed = true
                        break
                    end
                end
            end
            
            if changed then
                -- Save cursor position
                local cursor = vim.api.nvim_win_get_cursor(0)
                
                -- Update buffer
                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted_lines)
                
                -- Restore cursor position
                pcall(vim.api.nvim_win_set_cursor, 0, cursor)
                
                vim.notify("Formatted with " .. formatter.command, vim.log.levels.INFO)
            end
        end)
    end)
end

-- Setup format on save
local function setup_format_on_save()
    local format_on_save_filetypes = {
        "lua", "python", "javascript", "typescript", "javascriptreact", "typescriptreact",
        "json", "go", "rust", "c", "cpp", "html", "css", "yaml", "markdown"
    }
    
    vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = "FormatOnSave",
        pattern = "*",
        callback = function()
            if vim.g.format_on_save ~= false and vim.tbl_contains(format_on_save_filetypes, vim.bo.filetype) then
                -- Try formatter first, then fall back to LSP
                if formatters[vim.bo.filetype] and vim.fn.executable(formatters[vim.bo.filetype].command) == 1 then
                    M.format_buffer()
                else
                    -- Use LSP formatting if available
                    local clients = vim.lsp.get_clients({ bufnr = 0 })
                    for _, client in ipairs(clients) do
                        if client.server_capabilities.documentFormattingProvider then
                            vim.lsp.buf.format({ timeout_ms = 2000 })
                            break
                        end
                    end
                end
            end
        end,
    })
end

-- Setup formatting commands
local function setup_commands()
    vim.api.nvim_create_user_command("Format", function()
        M.format_buffer()
    end, {})
    
    vim.api.nvim_create_user_command("FormatToggle", function()
        if vim.g.format_on_save == false then
            vim.g.format_on_save = true
            vim.notify("Format on save enabled", vim.log.levels.INFO)
        else
            vim.g.format_on_save = false
            vim.notify("Format on save disabled", vim.log.levels.INFO)
        end
    end, {})
end

-- Setup formatting
function M.setup()
    setup_format_on_save()
    setup_commands()
    
    -- Keymaps for formatting
    vim.keymap.set("n", "<leader>fm", M.format_buffer, { desc = "Format buffer" })
    vim.keymap.set("n", "<leader>ft", vim.cmd.FormatToggle, { desc = "Toggle format on save" })
end

return M
