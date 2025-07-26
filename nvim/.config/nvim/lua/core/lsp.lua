-- LSP Configuration
local M = {}

-- LSP servers configuration
local servers = {
    -- Lua
    lua_ls = {
        cmd = { "lua-language-server" },
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                },
                diagnostics = {
                    globals = { 'vim' },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },
    -- Python
    pyright = {
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    useLibraryCodeForTypes = true,
                },
            },
        },
    },
    -- TypeScript/JavaScript
    tsserver = {},
    -- Rust
    rust_analyzer = {
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy",
                },
            },
        },
    },
    -- Go
    gopls = {},
    -- C/C++
    clangd = {
        cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
        },
    },
    -- JSON
    jsonls = {},
    -- HTML/CSS
    html = {},
    cssls = {},
}

-- Diagnostic configuration
local function setup_diagnostics()
    vim.diagnostic.config({
        virtual_text = {
            prefix = '●',
            source = "always",
        },
        float = {
            source = "always",
            border = "rounded",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
    })

    -- Define diagnostic signs
    local signs = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " "
    }

    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
end

-- Border configuration for floating windows
local border = {
    {"╭", "FloatBorder"},
    {"─", "FloatBorder"},
    {"╮", "FloatBorder"},
    {"│", "FloatBorder"},
    {"╯", "FloatBorder"},
    {"─", "FloatBorder"},
    {"╰", "FloatBorder"},
    {"│", "FloatBorder"},
}

-- LSP handlers
local function setup_handlers()
    -- Hover handler with border
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
            border = border,
        }
    )

    -- Signature help handler with border
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
            border = border,
        }
    )
end

-- LSP keymaps
local function setup_lsp_keymaps(bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    local keymap = vim.keymap.set

    -- Navigation
    keymap("n", "gD", vim.lsp.buf.declaration, opts)
    keymap("n", "gd", vim.lsp.buf.definition, opts)
    keymap("n", "K", vim.lsp.buf.hover, opts)
    keymap("n", "gi", vim.lsp.buf.implementation, opts)
    keymap("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    keymap("n", "gr", vim.lsp.buf.references, opts)
    keymap("n", "gt", vim.lsp.buf.type_definition, opts)

    -- Workspaces
    keymap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    keymap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    keymap("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)

    -- Actions
    keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
    keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
    keymap("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
    end, opts)

    -- Diagnostics
    keymap("n", "[d", vim.diagnostic.goto_prev, opts)
    keymap("n", "]d", vim.diagnostic.goto_next, opts)
    keymap("n", "<leader>d", vim.diagnostic.open_float, opts)
    keymap("n", "<leader>q", vim.diagnostic.setloclist, opts)

    -- Toggle inlay hints (Neovim 0.10+)
    if vim.lsp.inlay_hint then
        keymap("n", "<leader>ih", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, opts)
    end
end

-- On attach function
local function on_attach(client, bufnr)
    -- Setup keymaps
    setup_lsp_keymaps(bufnr)

    -- Enable completion
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Highlight symbol under cursor
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
        vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = vim.lsp.buf.document_highlight,
            buffer = bufnr,
            group = "lsp_document_highlight",
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            callback = vim.lsp.buf.clear_references,
            buffer = bufnr,
            group = "lsp_document_highlight",
        })
    end

    -- Enable inlay hints if supported
    if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
end

-- Capabilities
local function get_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Enable snippet support
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    }

    -- Enable folding
    capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }

    return capabilities
end

-- Setup function for a single server
local function setup_server(server_name, config)
    local server_config = config or {}

    -- Merge with default config
    server_config.on_attach = on_attach
    server_config.capabilities = get_capabilities()

    -- Try to setup the server
    local ok, err = pcall(vim.lsp.start, {
        name = server_name,
        cmd = server_config.cmd or { server_name },
        root_dir = vim.fs.root(0, { ".git", "package.json", "Cargo.toml", "go.mod", "pyproject.toml" }),
        settings = server_config.settings,
        on_attach = server_config.on_attach,
        capabilities = server_config.capabilities,
    })

    if not ok then
        vim.notify("Failed to start " .. server_name .. ": " .. err, vim.log.levels.WARN)
    end
end

-- Auto-start LSP servers based on filetype
local function setup_autostart()
    local filetype_to_servers = {
        lua = { "lua_ls" },
        python = { "pyright" },
        javascript = { "tsserver" },
        typescript = { "tsserver" },
        javascriptreact = { "tsserver" },
        typescriptreact = { "tsserver" },
        rust = { "rust_analyzer" },
        go = { "gopls" },
        c = { "clangd" },
        cpp = { "clangd" },
        json = { "jsonls" },
        html = { "html" },
        css = { "cssls" },
    }

    vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
            local ft = args.match
            local server_names = filetype_to_servers[ft]

            if server_names then
                for _, server_name in ipairs(server_names) do
                    local config = servers[server_name]
                    if config then
                        setup_server(server_name, config)
                    end
                end
            end
        end,
    })
end

-- Manual server start command
local function create_commands()
    vim.api.nvim_create_user_command("LspStart", function(opts)
        local server_name = opts.args
        local config = servers[server_name]

        if config then
            setup_server(server_name, config)
            vim.notify("Started " .. server_name, vim.log.levels.INFO)
        else
            vim.notify("Unknown server: " .. server_name, vim.log.levels.ERROR)
        end
    end, {
        nargs = 1,
        complete = function()
            local server_list = {}
            for name, _ in pairs(servers) do
                table.insert(server_list, name)
            end
            return server_list
        end,
    })

    vim.api.nvim_create_user_command("LspRestart", function()
        vim.lsp.stop_client(vim.lsp.get_clients())
        vim.cmd("edit")
    end, {})

    vim.api.nvim_create_user_command("LspInfo", function()
        local clients = vim.lsp.get_clients()
        if #clients == 0 then
            vim.notify("No active LSP clients", vim.log.levels.INFO)
            return
        end

        for _, client in ipairs(clients) do
            print(string.format("Client: %s (id: %d)", client.name, client.id))
        end
    end, {})
end

-- Setup LSP
function M.setup()
    setup_diagnostics()
    setup_handlers()
    setup_autostart()
    create_commands()

    -- Global LSP keymaps
    vim.keymap.set("n", "<leader>li", vim.cmd.LspInfo, { desc = "LSP Info" })
    vim.keymap.set("n", "<leader>lr", vim.cmd.LspRestart, { desc = "LSP Restart" })
end

return M
