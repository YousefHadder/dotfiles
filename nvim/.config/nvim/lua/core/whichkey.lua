-- Which-Key like functionality for key hints
-- Author: YousefHadder
-- Date: 2025-07-26

local M = {}

-- Key descriptions
local key_descriptions = {
    -- Leader key mappings
    ["<leader>"] = {
        name = "Leader",
        w = "Save file",
        q = "Quit",
        Q = "Force quit all",
        h = "Clear search highlight",
        s = "Search and replace",
        y = "Yank to clipboard",
        Y = "Yank line to clipboard",
        d = "Delete without yank",

        -- Buffer operations
        b = {
            name = "Buffer",
            d = "Delete buffer",
            a = "Delete all other buffers",
        },

        -- Split operations
        s = {
            name = "Split",
            v = "Vertical split",
            h = "Horizontal split",
            e = "Equal splits",
            x = "Close split",
        },

        -- Tab operations
        t = {
            name = "Tab",
            o = "New tab",
            x = "Close tab",
            n = "Next tab",
            p = "Previous tab",
        },

        -- QuickFix
        c = {
            name = "QuickFix",
            o = "Open quickfix",
            c = "Close quickfix",
            n = "Next item",
            p = "Previous item",
        },

        -- Location list
        l = {
            name = "Location/LSP",
            o = "Open location list",
            c = "Close location list",
            n = "Next location",
            p = "Previous location",
            i = "LSP Info",
            r = "LSP Restart",
        },

        -- File explorer
        e = "File explorer",
        E = "File explorer (current dir)",
        v = {
            name = "Vertical",
            e = "Vertical file explorer",
        },

        -- Netrw
        n = {
            name = "Netrw",
            h = "Toggle hidden files",
            s = "Cycle list style",
        },

        -- Terminal
        t = {
            name = "Terminal/Tab",
            t = "Open terminal",
        },

        -- Workspace
        w = {
            name = "Workspace",
            a = "Add workspace folder",
            r = "Remove workspace folder",
            l = "List workspace folders",
        },

        -- Rename and code actions
        r = {
            name = "Rename/Replace",
            n = "Rename symbol",
        },

        -- Code actions
        c = {
            name = "Code",
            a = "Code actions",
            s = "Toggle colorscheme",
        },

        -- Formatting
        f = {
            name = "Format",
            m = "Format buffer",
            t = "Toggle format on save",
        },

        -- Diagnostics
        d = "Show diagnostics",

        -- Inlay hints
        i = {
            name = "Inlay",
            h = "Toggle inlay hints",
        },

        -- Misc
        ["?"] = "Show help",
        ["<leader>"] = "Source current file",
        rn = "Toggle relative numbers",
    },
}

-- Floating window for key hints
local function show_key_hints(keys, timeout)
    timeout = timeout or 1000

    local function get_hints(key_table, prefix)
        local hints = {}
        prefix = prefix or ""

        for key, desc in pairs(key_table) do
            if key ~= "name" then
                if type(desc) == "table" then
                    table.insert(hints, {
                        key = prefix .. key,
                        desc = desc.name or "group",
                        is_group = true
                    })
                else
                    table.insert(hints, {
                        key = prefix .. key,
                        desc = desc,
                        is_group = false
                    })
                end
            end
        end

        -- Sort hints
        table.sort(hints, function(a, b)
            return a.key < b.key
        end)

        return hints
    end

    local hints = get_hints(keys)
    if #hints == 0 then
        return
    end

    -- Calculate window size
    local max_key_len = 0
    local max_desc_len = 0

    for _, hint in ipairs(hints) do
        max_key_len = math.max(max_key_len, #hint.key)
        max_desc_len = math.max(max_desc_len, #hint.desc)
    end

    local width = math.max(40, max_key_len + max_desc_len + 8)
    local height = math.min(15, #hints + 2)

    -- Create buffer
    local buf = vim.api.nvim_create_buf(false, true)

    -- Create content
    local lines = {}
    local title = keys.name or "Key Bindings"
    table.insert(lines, " " .. title .. " ")
    table.insert(lines, string.rep("─", #title + 2))

    for _, hint in ipairs(hints) do
        local key_part = hint.key
        local desc_part = hint.desc
        local separator = hint.is_group and " ➤ " or " → "
        local line = string.format(" %-" .. max_key_len .. "s%s%s", key_part, separator, desc_part)
        table.insert(lines, line)
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Calculate position
    local win_height = vim.o.lines
    local win_width = vim.o.columns
    local row = math.floor((win_height - height) / 2)
    local col = math.floor((win_width - width) / 2)

    -- Create window
    local win_opts = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = " " .. title .. " ",
        title_pos = "center",
    }

    local win = vim.api.nvim_open_win(buf, false, win_opts)

    -- Set buffer options
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "readonly", true)

    -- Set highlighting
    vim.api.nvim_buf_add_highlight(buf, -1, "Title", 0, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, -1, "Comment", 1, 0, -1)

    for i, hint in ipairs(hints) do
        local line_idx = i + 1
        local key_end = #hint.key + 1
        local sep_start = key_end + 1
        local sep_end = sep_start + (hint.is_group and 3 or 3)

        -- Highlight key
        vim.api.nvim_buf_add_highlight(buf, -1, "Keyword", line_idx, 1, key_end)
        -- Highlight separator
        vim.api.nvim_buf_add_highlight(buf, -1, "Comment", line_idx, sep_start, sep_end)
        -- Highlight description
        local desc_hl = hint.is_group and "Directory" or "String"
        vim.api.nvim_buf_add_highlight(buf, -1, desc_hl, line_idx, sep_end, -1)
    end

    -- Auto-close after timeout
    local timer = vim.loop.new_timer()
    timer:start(timeout, 0, vim.schedule_wrap(function()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
        timer:close()
    end))

    -- Close on any key press
    local close_autocmd
    close_autocmd = vim.api.nvim_create_autocmd("CursorMoved", {
        callback = function()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
            vim.api.nvim_del_autocmd(close_autocmd)
            timer:close()
        end,
    })

    return win, buf
end

-- Track partial key sequences
local partial_keys = ""
local hint_timer = nil

-- Function to handle key sequence tracking
function M.handle_key(key)
    partial_keys = partial_keys .. key

    -- Clear existing timer
    if hint_timer then
        hint_timer:close()
        hint_timer = nil
    end

    -- Check if we have hints for this sequence
    local current_hints = key_descriptions
    local keys = vim.split(partial_keys, "", { plain = true })

    for _, k in ipairs(keys) do
        if current_hints[k] and type(current_hints[k]) == "table" then
            current_hints = current_hints[k]
        else
            current_hints = nil
            break
        end
    end

    if current_hints then
        -- Show hints after a short delay
        hint_timer = vim.loop.new_timer()
        hint_timer:start(500, 0, vim.schedule_wrap(function()
            show_key_hints(current_hints, 2000)
            hint_timer:close()
            hint_timer = nil
        end))
    end
end

-- Reset partial keys
function M.reset_keys()
    partial_keys = ""
    if hint_timer then
        hint_timer:close()
        hint_timer = nil
    end
end

-- Setup function
function M.setup()
    -- Create autocommand to track leader key
    local group = vim.api.nvim_create_augroup("WhichKey", { clear = true })

    -- Reset on mode change
    vim.api.nvim_create_autocmd("ModeChanged", {
        group = group,
        callback = function()
            M.reset_keys()
        end,
    })

    -- Show leader key hints immediately when leader is pressed
    vim.keymap.set("n", "<leader>", function()
        show_key_hints(key_descriptions["<leader>"], 2000)
        return "<leader>"
    end, { expr = true, desc = "Show leader key hints" })
end

-- Manual trigger for showing all leader keymaps
function M.show_leader_keys()
    show_key_hints(key_descriptions["<leader>"], 5000)
end

return M
