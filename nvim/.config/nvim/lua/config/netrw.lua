-- Netrw Configuration
-- Author: YousefHadder
-- Date: 2025-07-26

local M = {}

-- Netrw settings
function M.setup()
    -- Set list style (detailed list view)
    vim.g.netrw_liststyle = 3  -- 0: thin, 1: long, 2: wide, 3: tree

    -- Basic settings
    vim.g.netrw_banner = 0           -- Disable banner
    vim.g.netrw_browse_split = 0     -- Open files in same window
    vim.g.netrw_altv = 1            -- Open splits to the right
    vim.g.netrw_alto = 0            -- Open splits below
    vim.g.netrw_winsize = 25        -- Window size percentage
    vim.g.netrw_preview = 1         -- Vertical preview window
    vim.g.netrw_keepdir = 0         -- Keep current directory and browsing directory synced
    vim.g.netrw_localcopydircmd = 'cp -r'  -- Copy command for directories

    -- File sorting
    vim.g.netrw_sort_by = "name"    -- Sort by name (name, time, size, exten)
    vim.g.netrw_sort_direction = "normal"  -- normal or reverse

    -- Special file handling
    vim.g.netrw_special_syntax = 1  -- Special syntax highlighting
    vim.g.netrw_hide = 1            -- Enable hiding
    vim.g.netrw_list_hide = '\\(^\\|\\s\\s\\)\\zs\\.\\S\\+'  -- Hide dotfiles by default

    -- Cursor settings
    vim.g.netrw_cursor = 2          -- Cursor behavior (2 = cursor follows selection)
    vim.g.netrw_fastbrowse = 2      -- Fast browsing

    -- Mouse support
    vim.g.netrw_mousemaps = 1       -- Enable mouse maps

    -- Display settings
    vim.g.netrw_dirhistmax = 100    -- Directory history size
    vim.g.netrw_maxfilenamelen = 50 -- Max filename length to display

    -- Setup autocommands for netrw buffers
    local group = vim.api.nvim_create_augroup("NetrwConfig", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "netrw",
        callback = function()
            -- Custom keymaps for netrw
            local opts = { buffer = true, silent = true, noremap = true }

            -- Navigation keymaps (history navigation only, h/l will be set below)
            vim.keymap.set("n", "<C-h>", "u", opts)       -- Go back in history
            vim.keymap.set("n", "<C-l>", "U", opts)       -- Go forward in history

            -- File operations
            vim.keymap.set("n", "a", "%", opts)           -- Create new file
            vim.keymap.set("n", "r", "R", opts)           -- Rename file

            -- Help and quit
            vim.keymap.set("n", "?", "<F1>", opts)        -- Help
            vim.keymap.set("n", "q", ":q<CR>", opts)      -- Quit netrw
            vim.keymap.set("n", "<Esc>", ":q<CR>", opts)  -- Alternative quit

            -- Custom functions
            vim.keymap.set("n", "<leader>cd", function()
                -- Change working directory to current netrw directory
                local dir = vim.fn.expand("%")
                if vim.fn.isdirectory(dir) == 1 then
                    vim.cmd("cd " .. dir)
                    print("Changed directory to: " .. dir)
                end
            end, opts)

            vim.keymap.set("n", "<leader>.", function()
                -- Toggle hidden files
                if vim.g.netrw_hide == 1 then
                    vim.g.netrw_hide = 0
                    print("Showing all files")
                else
                    vim.g.netrw_hide = 1
                    print("Hiding dotfiles")
                end
                vim.cmd("edit")  -- Refresh view
            end, opts)

            vim.keymap.set("n", "<leader>st", function()
                -- Cycle through list styles
                local styles = { 0, 1, 2, 3 }
                local style_names = { "thin", "long", "wide", "tree" }
                local current = vim.g.netrw_liststyle
                local next_index = 1

                for i, style in ipairs(styles) do
                    if style == current then
                        next_index = (i % #styles) + 1
                        break
                    end
                end

                vim.g.netrw_liststyle = styles[next_index]
                print("List style: " .. style_names[next_index])
                vim.cmd("edit")  -- Refresh view
            end, opts)

            -- Disable conflicting window navigation mappings in netrw buffers
            pcall(vim.keymap.del, "n", "h", { buffer = true })
            pcall(vim.keymap.del, "n", "l", { buffer = true })
            
            -- Then set our custom netrw mappings
            vim.keymap.set("n", "h", "-", opts)           -- Go up directory (like -)
            vim.keymap.set("n", "l", "<CR>", opts)        -- Enter directory/file (like Enter)
        end,
    })

    -- Custom netrw colors (using slate colorscheme colors)
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "netrw",
        callback = function()
            -- Apply custom highlighting if slate colorscheme is loaded
            if vim.g.colors_name == "slate" then
                local colors = require('colors.slate').colors

                vim.api.nvim_set_hl(0, "netrwDir", { fg = colors.blue, bold = true })
                vim.api.nvim_set_hl(0, "netrwPlain", { fg = colors.fg })
                vim.api.nvim_set_hl(0, "netrwHelpCmd", { fg = colors.cyan })
                vim.api.nvim_set_hl(0, "netrwCmdSep", { fg = colors.comment })
                vim.api.nvim_set_hl(0, "netrwComment", { fg = colors.comment, italic = true })
                vim.api.nvim_set_hl(0, "netrwList", { fg = colors.yellow })
                vim.api.nvim_set_hl(0, "netrwHidePat", { fg = colors.comment })
                vim.api.nvim_set_hl(0, "netrwQuickHelp", { fg = colors.cyan })
                vim.api.nvim_set_hl(0, "netrwVersion", { fg = colors.green })
                vim.api.nvim_set_hl(0, "netrwTimeSep", { fg = colors.comment })
                vim.api.nvim_set_hl(0, "netrwDateSep", { fg = colors.comment })
                vim.api.nvim_set_hl(0, "netrwTreeBar", { fg = colors.comment })
                vim.api.nvim_set_hl(0, "netrwExe", { fg = colors.green, bold = true })
                vim.api.nvim_set_hl(0, "netrwLink", { fg = colors.cyan })
                vim.api.nvim_set_hl(0, "netrwSymLink", { fg = colors.magenta })
                vim.api.nvim_set_hl(0, "netrwClassify", { fg = colors.blue })
                vim.api.nvim_set_hl(0, "netrwCoreDump", { fg = colors.red })
                vim.api.nvim_set_hl(0, "netrwData", { fg = colors.orange })
                vim.api.nvim_set_hl(0, "netrwHdr", { fg = colors.yellow, bold = true })
                vim.api.nvim_set_hl(0, "netrwLex", { fg = colors.purple })
                vim.api.nvim_set_hl(0, "netrwLib", { fg = colors.yellow })
                vim.api.nvim_set_hl(0, "netrwMakefile", { fg = colors.orange, bold = true })
                vim.api.nvim_set_hl(0, "netrwObj", { fg = colors.red })
                vim.api.nvim_set_hl(0, "netrwTags", { fg = colors.cyan })
                vim.api.nvim_set_hl(0, "netrwTilde", { fg = colors.comment })
                vim.api.nvim_set_hl(0, "netrwTmp", { fg = colors.comment })
            end
        end,
    })

    -- Set netrw to open in current window by default
    vim.api.nvim_create_autocmd("VimEnter", {
        group = group,
        callback = function()
            -- Only if no file was specified
            if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 then
                vim.cmd("edit .")
            end
        end,
    })
end

-- Quick access functions
function M.toggle_hidden()
    if vim.g.netrw_hide == 1 then
        vim.g.netrw_hide = 0
        print("Showing all files")
    else
        vim.g.netrw_hide = 1
        print("Hiding dotfiles")
    end
    if vim.bo.filetype == "netrw" then
        vim.cmd("edit")
    end
end

function M.cycle_style()
    local styles = { 0, 1, 2, 3 }
    local style_names = { "thin", "long", "wide", "tree" }
    local current = vim.g.netrw_liststyle
    local next_index = 1

    for i, style in ipairs(styles) do
        if style == current then
            next_index = (i % #styles) + 1
            break
        end
    end

    vim.g.netrw_liststyle = styles[next_index]
    print("List style: " .. style_names[next_index])
    if vim.bo.filetype == "netrw" then
        vim.cmd("edit")
    end
end


return M
