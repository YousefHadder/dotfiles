-- Utility functions for Neovim configuration
local M = {}

-- Check if a command exists
function M.executable(cmd)
    return vim.fn.executable(cmd) == 1
end

-- Get the visual selection
function M.get_visual_selection()
    local _, ls, cs = unpack(vim.fn.getpos("'<"))
    local _, le, ce = unpack(vim.fn.getpos("'>"))
    
    local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
    
    if #lines == 0 then
        return ""
    end
    
    -- Handle single line selection
    if #lines == 1 then
        lines[1] = string.sub(lines[1], cs, ce)
    else
        -- Handle multi-line selection
        lines[1] = string.sub(lines[1], cs)
        lines[#lines] = string.sub(lines[#lines], 1, ce)
    end
    
    return table.concat(lines, "\n")
end

-- Create a floating window
function M.create_float(opts)
    opts = opts or {}
    
    -- Calculate dimensions
    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)
    
    -- Calculate position to center the window
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)
    
    -- Create buffer
    local buf = vim.api.nvim_create_buf(false, true)
    
    -- Window options
    local win_opts = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = opts.border or "rounded",
        title = opts.title,
        title_pos = opts.title_pos or "center",
    }
    
    -- Create window
    local win = vim.api.nvim_open_win(buf, true, win_opts)
    
    -- Set buffer options
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "filetype", opts.filetype or "")
    
    -- Set window options
    vim.api.nvim_win_set_option(win, "winblend", opts.winblend or 0)
    
    -- Close with q or Escape
    vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<CR>", { noremap = true, silent = true })
    
    return buf, win
end

-- Check if we're in a git repository
function M.is_git_repo()
    local git_dir = vim.fn.finddir(".git", ".;")
    return git_dir ~= ""
end

-- Get git root directory
function M.get_git_root()
    if not M.is_git_repo() then
        return nil
    end
    
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    return git_root
end

-- Debounce function
function M.debounce(func, timeout)
    local timer_id
    return function(...)
        local args = {...}
        if timer_id then
            vim.fn.timer_stop(timer_id)
        end
        timer_id = vim.fn.timer_start(timeout, function()
            func(unpack(args))
        end)
    end
end

-- Throttle function
function M.throttle(func, timeout)
    local last_call = 0
    return function(...)
        local now = vim.fn.reltime()
        local elapsed = vim.fn.reltimefloat(vim.fn.reltime(last_call, now)) * 1000
        
        if elapsed >= timeout then
            last_call = now
            func(...)
        end
    end
end

-- Safe require function
function M.safe_require(module)
    local ok, result = pcall(require, module)
    if not ok then
        vim.notify("Error loading module: " .. module .. "\n" .. result, vim.log.levels.ERROR)
        return nil
    end
    return result
end

-- Get project root based on markers
function M.get_project_root(markers)
    markers = markers or { ".git", "package.json", "Cargo.toml", "go.mod", "pyproject.toml", "Makefile" }
    
    local current_dir = vim.fn.expand("%:p:h")
    
    while current_dir ~= "/" do
        for _, marker in ipairs(markers) do
            if vim.fn.filereadable(current_dir .. "/" .. marker) == 1 or 
               vim.fn.isdirectory(current_dir .. "/" .. marker) == 1 then
                return current_dir
            end
        end
        current_dir = vim.fn.fnamemodify(current_dir, ":h")
    end
    
    return vim.fn.getcwd()
end

-- Toggle boolean option
function M.toggle_option(option)
    vim.opt[option] = not vim.opt[option]:get()
    vim.notify(option .. ": " .. tostring(vim.opt[option]:get()))
end

-- Load configuration from a table
function M.load_config(config)
    for key, value in pairs(config) do
        if type(value) == "table" and vim.tbl_islist(value) then
            vim.opt[key] = value
        else
            vim.opt[key] = value
        end
    end
end

-- Get highlight group under cursor
function M.get_highlight_under_cursor()
    local line = vim.fn.line(".")
    local col = vim.fn.col(".")
    local hi_name = vim.fn.synIDattr(vim.fn.synID(line, col, 1), "name")
    local trans_hi_name = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.synID(line, col, 1)), "name")
    
    print("Highlight: " .. hi_name .. " -> " .. trans_hi_name)
end

-- Center text in a given width
function M.center_text(text, width)
    local padding = math.floor((width - #text) / 2)
    return string.rep(" ", padding) .. text
end

-- Wrap text to specified width
function M.wrap_text(text, width)
    local lines = {}
    local current_line = ""
    
    for word in text:gmatch("%S+") do
        if #current_line + #word + 1 <= width then
            current_line = current_line == "" and word or current_line .. " " .. word
        else
            if current_line ~= "" then
                table.insert(lines, current_line)
            end
            current_line = word
        end
    end
    
    if current_line ~= "" then
        table.insert(lines, current_line)
    end
    
    return lines
end

-- Check if buffer is empty
function M.is_buffer_empty(bufnr)
    bufnr = bufnr or 0
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    return #lines == 1 and lines[1] == ""
end

-- Get buffer size in bytes
function M.get_buffer_size(bufnr)
    bufnr = bufnr or 0
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local size = 0
    for _, line in ipairs(lines) do
        size = size + #line + 1 -- +1 for newline
    end
    return size
end

-- Format bytes to human readable
function M.format_bytes(bytes)
    local units = { "B", "KB", "MB", "GB" }
    local unit_index = 1
    local size = bytes
    
    while size >= 1024 and unit_index < #units do
        size = size / 1024
        unit_index = unit_index + 1
    end
    
    return string.format("%.1f %s", size, units[unit_index])
end

-- Get current time formatted
function M.get_time(format)
    format = format or "%H:%M:%S"
    return os.date(format)
end

-- Get current date formatted
function M.get_date(format)
    format = format or "%Y-%m-%d"
    return os.date(format)
end

-- Create directory if it doesn't exist
function M.ensure_dir(path)
    if vim.fn.isdirectory(path) == 0 then
        vim.fn.mkdir(path, "p")
    end
end

-- Read file contents
function M.read_file(path)
    local file = io.open(path, "r")
    if not file then
        return nil
    end
    
    local content = file:read("*all")
    file:close()
    return content
end

-- Write content to file
function M.write_file(path, content)
    local file = io.open(path, "w")
    if not file then
        return false
    end
    
    file:write(content)
    file:close()
    return true
end

-- Get OS information
function M.get_os()
    local os_name = vim.loop.os_uname().sysname
    if os_name == "Linux" then
        return "linux"
    elseif os_name == "Darwin" then
        return "macos"
    elseif os_name:match("Windows") then
        return "windows"
    else
        return "unknown"
    end
end

-- Reload a Lua module
function M.reload_module(module_name)
    package.loaded[module_name] = nil
    return require(module_name)
end

-- Get all buffers with a specific filetype
function M.get_buffers_by_filetype(filetype)
    local buffers = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
            local buf_ft = vim.api.nvim_buf_get_option(buf, "filetype")
            if buf_ft == filetype then
                table.insert(buffers, buf)
            end
        end
    end
    return buffers
end

return M
