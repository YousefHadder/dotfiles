-- Neovim configuration using only built-in features (0.11+)
-- Place this in ~/.config/nvim/init.lua

-- ============================================================================
-- BASIC SETTINGS
-- ============================================================================

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable unused providers (reduces checkhealth warnings)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

-- Basic options
local opt = vim.opt

-- General
opt.mouse = "a"               -- Enable mouse support
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.swapfile = false          -- Disable swap files
opt.backup = false            -- Disable backup files
opt.undofile = true           -- Enable persistent undo
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.whichwrap = "b,s,h,l,<,>,[,]" -- Allow cursor to wrap around lines

-- UI
opt.number = true         -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.cursorline = true     -- Highlight current line
opt.signcolumn = "yes"    -- Always show sign column
opt.wrap = false          -- Disable line wrapping
opt.scrolloff = 8         -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8     -- Keep 8 columns left/right of cursor
opt.colorcolumn = "100"   -- Show column at 80 characters
opt.list = true           -- Show whitespace characters
opt.listchars = { tab = "→ ", trail = "·", nbsp = "␣" }

-- Splits
opt.splitbelow = true -- Open horizontal splits below
opt.splitright = true -- Open vertical splits to the right

-- Search
opt.ignorecase = true -- Ignore case in search
opt.smartcase = true  -- Case sensitive if uppercase present
opt.hlsearch = true   -- Highlight search matches
opt.incsearch = true  -- Show matches while typing

-- Indentation
opt.expandtab = true   -- Use spaces instead of tabs
opt.shiftwidth = 2     -- Number of spaces for indentation
opt.tabstop = 2        -- Number of spaces for tab
opt.softtabstop = 2    -- Number of spaces for tab in insert mode
opt.autoindent = true  -- Auto indent new lines
opt.smartindent = true -- Smart indentation

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10 -- Popup menu height

-- Performance
opt.updatetime = 250  -- Faster completion
opt.timeoutlen = 500 -- Wait 1 second for key sequence completion (adjust as needed)
opt.timeout = true    -- Enable timeout for mappings
opt.ttimeout = true   -- Enable timeout for key codes
opt.ttimeoutlen = 10  -- Fast timeout for key codes (escape sequences)

-- Folding (using Treesitter)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99 -- Start with all folds open
opt.foldlevelstart = 99

-- Backspace options
opt.backspace = { "start", "eol", "indent" }


-- ============================================================================
-- COLORSCHEME
-- ============================================================================

-- Enable 24-bit RGB colors
opt.termguicolors = true
vim.cmd.colorscheme("slate")

-- Transparent background
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })

-- Make other UI elements transparent
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none" })

-- Ensure cursor line is visible but subtle
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2a2a2a" })

-- Status line appearance
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#303030", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#202020", fg = "#808080" })

-- Visual selection
vim.api.nvim_set_hl(0, "Visual", { bg = "#404040" })

-- Search highlighting
vim.api.nvim_set_hl(0, "Search", { bg = "#4a4a4a", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "IncSearch", { bg = "#5a5a5a", fg = "#ffffff" })

-- Popup menu
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#303030", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#505050", fg = "#ffffff" })

-- Comments color (blue with italic)
vim.api.nvim_set_hl(0, "Comment", { fg = "#7aa2f7", italic = true })

-- Line numbers with different colors for above/below
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#5a8e7b", bg = "none" })     -- Green tint for lines above
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#8e5a7b", bg = "none" })     -- Purple tint for lines below
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ff9e64", bg = "none", bold = true })  -- Orange for current line

-- ============================================================================
-- KEYMAPS
-- ============================================================================

local keymap = vim.keymap.set

-- Required
keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Use jk instead of ESC
keymap("i", "jk", "<ESC>", { noremap = true, desc = "Exit insert mode with jk" })

-- Source file
keymap("n", "<leader>r", "<cmd> so % <CR>", { noremap = true, desc = "reload config" })

-- Better up/down movement
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Clear search highlighting
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Better indenting
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Move text up and down
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centered when scrolling
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- Keep cursor centered when searching
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- Better paste (doesn't replace clipboard)
keymap("x", "<leader>p", [["_dP]])

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Window resizing
keymap("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Buffer navigation
keymap("n", "[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Tab navigation
keymap("n", "[t", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
keymap("n", "]t", "<cmd>tabnext<CR>", { desc = "Next tab" })
keymap("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close tab" })

-- File explorer (netrw)
keymap("n", "<leader>e", "<cmd>Explore<CR>", { desc = "Open file explorer (tree nav: h/l/./q/?)" })
keymap("n", "<leader>E", "<cmd>Sexplore<CR>", { desc = "Open file explorer in split" })
keymap("n", "<leader>ee", "<cmd>Vexplore<CR>", { desc = "Open file explorer in vertical split" })

-- Terminal
keymap("n", "<leader>tt", "<cmd>terminal<CR>", { desc = "Open terminal" })
keymap("n", "<leader>ts", "<cmd>split | terminal<CR>", { desc = "Open terminal in split" })
keymap("n", "<leader>tv", "<cmd>vsplit | terminal<CR>", { desc = "Open terminal in vertical split" })
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Quick save and quit
keymap("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
keymap("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>qall<CR>", { desc = "Quit all" })

-- ============================================================================
-- TREESITTER CONFIGURATION
-- ============================================================================

-- Configure built-in Treesitter safely
pcall(function()
  vim.treesitter.language.register("bash", "sh")
end)

-- Treesitter folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- ============================================================================
-- LSP CONFIGURATION
-- ============================================================================

-- LSP attach function
local function on_attach(client, bufnr)
  local opts = { buffer = bufnr, silent = true }

  -- LSP keymaps
  keymap("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
  keymap("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
  keymap("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Go to references" }))
  keymap("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
  keymap("n", "gt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
  keymap("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
  keymap("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
  keymap("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
  keymap("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
  keymap("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end,
    vim.tbl_extend("force", opts, { desc = "Format buffer" }))

  -- Workspace
  keymap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder,
    vim.tbl_extend("force", opts, { desc = "Add workspace folder" }))
  keymap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder,
    vim.tbl_extend("force", opts, { desc = "Remove workspace folder" }))
  keymap("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    vim.tbl_extend("force", opts, { desc = "List workspace folders" }))
end

-- LSP servers configuration with filetypes
local servers = {
  -- Lua
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        workspace = {
          checkThirdParty = false,
          library = { vim.env.VIMRUNTIME }
        },
        completion = { callSnippet = "Replace" },
        diagnostics = { globals = { "vim" } },
        hint = { enable = true },
      },
    },
  },

  -- TypeScript/JavaScript
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },

  -- Python
  pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
          typeCheckingMode = "basic",
        },
      },
    },
  },

  -- Go
  gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
        gofumpt = true,
      },
    },
  },

  -- Ruby
  solargraph = {
    cmd = { "solargraph", "stdio" },
    filetypes = { "ruby" },
    settings = {
      solargraph = {
        diagnostics = true,
        completion = true,
        hover = true,
        formatting = true,
      },
    },
  },

  -- Rust
  rust_analyzer = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          runBuildScripts = true,
        },
        checkOnSave = {
          allFeatures = true,
          command = "clippy",
          extraArgs = { "--no-deps" },
        },
        procMacro = {
          enable = true,
          ignored = {
            ["async-trait"] = { "async_trait" },
            ["napi-derive"] = { "napi" },
            ["async-recursion"] = { "async_recursion" },
          },
        },
      },
    },
  },

  -- C/C++
  clangd = {
    cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  },

  -- JSON
  jsonls = {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    settings = {
      json = {
        schemas = {
          {
            fileMatch = { "package.json" },
            url = "https://json.schemastore.org/package.json",
          },
          {
            fileMatch = { "tsconfig*.json" },
            url = "https://json.schemastore.org/tsconfig.json",
          },
        },
      },
    },
  },

  -- YAML
  yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml", "yml" },
    settings = {
      yaml = {
        keyOrdering = false,
        format = {
          enable = true,
        },
        validate = true,
        schemaStore = {
          enable = false,
          url = "",
        },
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          ["https://json.schemastore.org/github-action.json"] = "/action.{yml,yaml}",
          ["https://json.schemastore.org/docker-compose.json"] = "docker-compose*.{yml,yaml}",
          ["https://json.schemastore.org/kustomization.json"] = "kustomization.{yml,yaml}",
        },
      },
    },
  },

  -- Markdown
  marksman = {
    cmd = { "marksman", "server" },
    filetypes = { "markdown", "markdown.mdx" },
  },

  -- Bash
  bashls = {
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh", "bash" },
    settings = {
      bashIde = {
        globPattern = "**/*@(.sh|.inc|.bash|.command)",
      },
    },
  },

  -- HTML
  html = {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html" },
    settings = {
      html = {
        format = {
          templating = true,
          wrapLineLength = 120,
          wrapAttributes = "auto",
        },
        hover = {
          documentation = true,
          references = true,
        },
      },
    },
  },

  -- CSS
  cssls = {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
    settings = {
      css = {
        validate = true,
        lint = {
          unknownAtRules = "ignore",
        },
      },
      scss = {
        validate = true,
        lint = {
          unknownAtRules = "ignore",
        },
      },
      less = {
        validate = true,
        lint = {
          unknownAtRules = "ignore",
        },
      },
    },
  },
}

-- Root directory patterns for different languages
local root_patterns = {
  lua_ls = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
  ts_ls = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  pyright = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
  gopls = { "go.mod", "go.work", ".git" },
  solargraph = { "Gemfile", ".git" },
  rust_analyzer = { "Cargo.toml", ".git" },
  clangd = { "compile_commands.json", "compile_flags.txt", ".clangd", ".git" },
  jsonls = { "package.json", ".git" },
  yamlls = { ".git" },
  marksman = { ".git" },
  bashls = { ".git" },
  html = { "package.json", ".git" },
  cssls = { "package.json", ".git" },
}

-- Setup LSP servers with proper filetype detection
local function setup_lsp_for_filetype(server_name, config, bufnr)
  -- Check if the LSP server executable exists
  local cmd = config.cmd
  if not cmd or not cmd[1] then
    return
  end

  -- Check if executable is available
  if vim.fn.executable(cmd[1]) == 0 then
    return
  end

  local server_config = vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
  }, config)

  -- Get root directory patterns for this server
  local patterns = root_patterns[server_name] or { ".git" }

  -- Safely start LSP server for this buffer
  local ok, _ = pcall(function()
    vim.lsp.start({
      name = server_name,
      cmd = server_config.cmd,
      root_dir = vim.fs.dirname(vim.fs.find(patterns, { upward = true })[1]),
      on_attach = server_config.on_attach,
      capabilities = server_config.capabilities,
      settings = server_config.settings,
    }, { bufnr = bufnr })
  end)
end

-- Create autocmd to start LSP servers based on filetype
local lsp_group = vim.api.nvim_create_augroup("LspAutostart", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = lsp_group,
  desc = "Start LSP servers for file types",
  callback = function(args)
    local filetype = args.match
    local bufnr = args.buf

    -- Find matching LSP servers for this filetype
    for server_name, config in pairs(servers) do
      if config.filetypes then
        for _, ft in ipairs(config.filetypes) do
          if ft == filetype then
            setup_lsp_for_filetype(server_name, config, bufnr)
            break
          end
        end
      end
    end
  end,
})

-- ============================================================================
-- DIAGNOSTICS CONFIGURATION
-- ============================================================================

vim.diagnostic.config({
  virtual_lines = { current_line = true },
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  } or {},
  virtual_text = {
    source = "if_many",
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
})

-- Diagnostic keymaps
keymap("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
keymap("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Add diagnostics to location list" })

-- ============================================================================
-- COMPLETION CONFIGURATION
-- ============================================================================

-- Built-in completion using omnifunc and completefunc
local function setup_completion()
  -- Use LspAttach event instead of FileType with wildcard
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("CompletionSetup", { clear = true }),
    desc = "Setup completion when LSP attaches",
    callback = function(args)
      local bufnr = args.buf
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end,
  })
end

setup_completion()

-- Completion keymaps
keymap("i", "<C-Space>", "<C-x><C-o>", { desc = "Trigger completion" })
keymap("i", "<C-n>", "<C-n>", { desc = "Next completion" })
keymap("i", "<C-p>", "<C-p>", { desc = "Previous completion" })

-- -- ============================================================================
-- -- FILE EXPLORER (NETRW) CONFIGURATION
-- -- ============================================================================
--
-- -- Netrw settings for tree-like behavior
-- vim.g.netrw_banner = 0                                 -- Hide banner
-- vim.g.netrw_liststyle = 3                              -- Tree view
-- vim.g.netrw_browse_split = 0                           -- Open in same window
-- vim.g.netrw_altv = 1                                   -- Open splits to the right
-- vim.g.netrw_winsize = 25                               -- Set width to 25%
-- vim.g.netrw_keepdir = 0                                -- Keep current directory synced with browsing
-- vim.g.netrw_localcopydircmd = 'cp -r'                  -- Copy directories recursively
-- vim.g.netrw_list_hide = [[.*\.pyc$,.*\.pyo$,.*\.git$]] -- Hide certain files
--
-- -- Netrw tree-like navigation keymaps
-- local function setup_netrw_maps()
--   local netrw_group = vim.api.nvim_create_augroup("NetrwMaps", { clear = true })
--
--   vim.api.nvim_create_autocmd("FileType", {
--     group = netrw_group,
--     pattern = "netrw",
--     callback = function()
--       local buf = vim.api.nvim_get_current_buf()
--       local opts = { buffer = buf, silent = true, nowait = true }
--
--       -- Tree navigation
--       vim.keymap.set("n", "h", function()
--         -- Go up one directory (parent)
--         vim.cmd("normal! -")
--       end, vim.tbl_extend("force", opts, { desc = "Go up directory" }))
--
--       vim.keymap.set("n", "l", function()
--         -- Enter directory or open file
--         vim.cmd("normal! \r")
--       end, vim.tbl_extend("force", opts, { desc = "Open directory/file" }))
--
--       vim.keymap.set("n", ".", function()
--         -- Set current directory as root
--         local line = vim.api.nvim_get_current_line()
--         if line:match("/$") then
--           -- If on a directory, change to it first
--           vim.cmd("normal! \r")
--         end
--         -- Set current directory as root
--         vim.cmd("Explore .")
--       end, vim.tbl_extend("force", opts, { desc = "Set as root directory" }))
--
--       -- Additional useful netrw mappings
--       vim.keymap.set("n", "H", function()
--         -- Toggle hidden files
--         vim.cmd("normal! a")
--       end, vim.tbl_extend("force", opts, { desc = "Toggle hidden files" }))
--
--       vim.keymap.set("n", "R", function()
--         -- Refresh directory
--         vim.cmd("edit .")
--       end, vim.tbl_extend("force", opts, { desc = "Refresh directory" }))
--
--       vim.keymap.set("n", "?", function()
--         -- Show netrw help
--         print("Netrw Tree Navigation:")
--         print("======================")
--         print("h - Go up directory")
--         print("l - Open directory/file")
--         print(". - Set current as root")
--         print("H - Toggle hidden files")
--         print("R - Refresh directory")
--         print("q - Close netrw")
--         print("")
--         print("Default netrw commands still work:")
--         print("d - Create directory")
--         print("% - Create file")
--         print("D - Delete file/directory")
--         print("r - Rename file/directory")
--         print("p - Preview file")
--         print("v - Open in vertical split")
--         print("o - Open in horizontal split")
--         print("t - Open in new tab")
--       end, vim.tbl_extend("force", opts, { desc = "Show netrw help" }))
--
--       vim.keymap.set("n", "q", function()
--         -- Close netrw
--         vim.cmd("close")
--       end, vim.tbl_extend("force", opts, { desc = "Close netrw" }))
--
--       -- File operations
--       vim.keymap.set("n", "n", function()
--         -- Create new file
--         vim.ui.input({ prompt = "New file name: " }, function(name)
--           if name and name ~= "" then
--             vim.cmd("edit " .. name)
--           end
--         end)
--       end, vim.tbl_extend("force", opts, { desc = "Create new file" }))
--
--       vim.keymap.set("n", "N", function()
--         -- Create new directory
--         vim.ui.input({ prompt = "New directory name: " }, function(name)
--           if name and name ~= "" then
--             vim.fn.mkdir(name)
--             vim.cmd("edit .")
--           end
--         end)
--       end, vim.tbl_extend("force", opts, { desc = "Create new directory" }))
--
--       -- Split operations
--       vim.keymap.set("n", "s", function()
--         -- Open in horizontal split
--         vim.cmd("normal! o")
--       end, vim.tbl_extend("force", opts, { desc = "Open in horizontal split" }))
--
--       vim.keymap.set("n", "v", function()
--         -- Open in vertical split
--         vim.cmd("normal! v")
--       end, vim.tbl_extend("force", opts, { desc = "Open in vertical split" }))
--
--       vim.keymap.set("n", "t", function()
--         -- Open in new tab
--         vim.cmd("normal! t")
--       end, vim.tbl_extend("force", opts, { desc = "Open in new tab" }))
--     end,
--   })
-- end
--
-- -- Initialize netrw keymaps
-- setup_netrw_maps()

-- ============================================================================
-- LEADER KEY VISUAL FEEDBACK
-- ============================================================================

-- Simple visual feedback for pending leader operations
local function show_pending_keys()
  -- This will show the command line when leader is pressed
  vim.opt.showcmd = true
  vim.opt.showmode = true

  -- Optional: Show ruler for additional context
  vim.opt.ruler = true
end

show_pending_keys()

-- ============================================================================
-- SEARCH AND NAVIGATION
-- ============================================================================

-- Enhanced search functionality using built-in features
local function search_files()
  vim.ui.input({ prompt = "Search files: " }, function(input)
    if input then
      vim.cmd("find " .. input)
    end
  end)
end

local function search_buffers()
  local buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= "" then
      table.insert(buffers, vim.api.nvim_buf_get_name(buf))
    end
  end

  vim.ui.select(buffers, {
    prompt = "Select buffer:",
    format_item = function(item)
      return vim.fn.fnamemodify(item, ":t")
    end,
  }, function(choice)
    if choice then
      vim.cmd("buffer " .. vim.fn.bufnr(choice))
    end
  end)
end

keymap("n", "<leader>sf", search_files, { desc = "Search files" })
keymap("n", "<leader>sb", search_buffers, { desc = "Search buffers" })
keymap("n", "<leader>sg", "<cmd>vimgrep // **/*<Left><Left><Left><Left><Left><Left><CR>", { desc = "Search with grep" })

-- LSP shortcuts
keymap("n", "<leader>li", "<cmd>LspInfo<CR>", { desc = "LSP info" })
keymap("n", "<leader>la", "<cmd>LspAvailable<CR>", { desc = "Available LSP servers" })
keymap("n", "<leader>lc", "<cmd>LspCurrent<CR>", { desc = "LSP servers for current filetype" })
keymap("n", "<leader>lr", "<cmd>LspRestart<CR>", { desc = "Restart LSP" })

-- Utility shortcuts
keymap("n", "<leader>uc", "<cmd>checkhealth<CR>", { desc = "Check health" })
keymap("n", "<leader>up", "<cmd>ProvidersEnable<CR>", { desc = "Enable providers" })
keymap("n", "<leader>ud", "<cmd>DebugAutocmds<CR>", { desc = "Debug autocommands" })
keymap("n", "<leader>um", "<cmd>LeaderMaps<CR>", { desc = "Show leader keymaps" })
keymap("n", "<leader>ut", "<cmd>TimeoutSet<CR>", { desc = "Configure timeout" })
keymap("n", "<leader>uh", "<cmd>NetrwHelp<CR>", { desc = "Netrw help" })

-- Colorscheme shortcuts
keymap("n", "<leader>cr", "<cmd>RandomColor<CR>", { desc = "Random colorscheme" })
keymap("n", "<leader>cl", "<cmd>ColorList<CR>", { desc = "List colorschemes" })
keymap("n", "<leader>cs", "<cmd>ColorSet ", { desc = "Set colorscheme" })

-- Help keymap (shows available leader keys)
keymap("n", "<leader>?", "<cmd>LeaderMaps<CR>", { desc = "Show available leader keymaps" })

-- -- ============================================================================
-- -- QUICKFIX AND LOCATION LIST
-- -- ============================================================================
--
-- keymap("n", "[q", "<cmd>cprevious<CR>", { desc = "Previous quickfix" })
-- keymap("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix" })
-- keymap("n", "<leader>qo", "<cmd>copen<CR>", { desc = "Open quickfix list" })
-- keymap("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Close quickfix list" })
--
-- keymap("n", "[l", "<cmd>lprevious<CR>", { desc = "Previous location" })
-- keymap("n", "]l", "<cmd>lnext<CR>", { desc = "Next location" })
-- keymap("n", "<leader>lo", "<cmd>lopen<CR>", { desc = "Open location list" })
-- keymap("n", "<leader>lc", "<cmd>lclose<CR>", { desc = "Close location list" })
--
-- -- ============================================================================
-- -- AUTOCMDS
-- -- ============================================================================
--
-- local augroup = vim.api.nvim_create_augroup
-- local autocmd = vim.api.nvim_create_autocmd
--
-- -- General settings
-- local general = augroup("General", { clear = true })
--
-- -- Highlight yanked text
-- autocmd("TextYankPost", {
--   group = general,
--   desc = "Highlight yanked text",
--   callback = function()
--     vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
--   end,
-- })
--
-- -- Remove trailing whitespace
-- autocmd("BufWritePre", {
--   group = general,
--   desc = "Remove trailing whitespace",
--   callback = function()
--     local save_cursor = vim.fn.getpos(".")
--     vim.cmd([[%s/\s\+$//e]])
--     vim.fn.setpos(".", save_cursor)
--   end,
-- })
--
-- -- Auto-resize splits when window is resized
-- autocmd("VimResized", {
--   group = general,
--   desc = "Auto-resize splits",
--   command = "wincmd =",
-- })
--
-- -- Close quickfix with q
-- autocmd("FileType", {
--   group = general,
--   pattern = { "qf", "help", "man", "lspinfo" },
--   callback = function()
--     vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
--   end,
-- })
--
-- -- Terminal settings
-- local terminal = augroup("Terminal", { clear = true })
--
-- autocmd("TermOpen", {
--   group = terminal,
--   desc = "Terminal settings",
--   callback = function()
--     vim.opt_local.number = false
--     vim.opt_local.relativenumber = false
--     vim.opt_local.signcolumn = "no"
--   end,
-- })
--
-- -- File type specific settings
-- local filetype = augroup("FileType", { clear = true })
--
-- -- Go
-- autocmd("FileType", {
--   group = filetype,
--   pattern = "go",
--   callback = function()
--     vim.bo.expandtab = false
--     vim.bo.tabstop = 4
--     vim.bo.shiftwidth = 4
--   end,
-- })
--
-- -- Python
-- autocmd("FileType", {
--   group = filetype,
--   pattern = "python",
--   callback = function()
--     vim.bo.expandtab = true
--     vim.bo.tabstop = 4
--     vim.bo.shiftwidth = 4
--     vim.bo.softtabstop = 4
--   end,
-- })
--
-- -- Markdown
-- autocmd("FileType", {
--   group = filetype,
--   pattern = "markdown",
--   callback = function()
--     vim.wo.wrap = true
--     vim.wo.linebreak = true
--     vim.bo.textwidth = 80
--   end,
-- })
--
-- -- YAML
-- autocmd("FileType", {
--   group = filetype,
--   pattern = { "yaml", "yml" },
--   callback = function()
--     vim.bo.expandtab = true
--     vim.bo.tabstop = 2
--     vim.bo.shiftwidth = 2
--     vim.bo.softtabstop = 2
--   end,
-- })
--
-- -- JSON
-- autocmd("FileType", {
--   group = filetype,
--   pattern = "json",
--   callback = function()
--     vim.bo.expandtab = true
--     vim.bo.tabstop = 2
--     vim.bo.shiftwidth = 2
--     vim.bo.softtabstop = 2
--   end,
-- })
--
-- -- Ruby
-- autocmd("FileType", {
--   group = filetype,
--   pattern = "ruby",
--   callback = function()
--     vim.bo.expandtab = true
--     vim.bo.tabstop = 2
--     vim.bo.shiftwidth = 2
--     vim.bo.softtabstop = 2
--   end,
-- })
--
-- -- JavaScript/TypeScript
-- autocmd("FileType", {
--   group = filetype,
--   pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
--   callback = function()
--     vim.bo.expandtab = true
--     vim.bo.tabstop = 2
--     vim.bo.shiftwidth = 2
--     vim.bo.softtabstop = 2
--   end,
-- })
--
-- -- HTML/CSS
-- autocmd("FileType", {
--   group = filetype,
--   pattern = { "html", "css", "scss", "less" },
--   callback = function()
--     vim.bo.expandtab = true
--     vim.bo.tabstop = 2
--     vim.bo.shiftwidth = 2
--     vim.bo.softtabstop = 2
--   end,
-- })
--
-- -- Shell scripts
-- autocmd("FileType", {
--   group = filetype,
--   pattern = { "sh", "bash", "zsh" },
--   callback = function()
--     vim.bo.expandtab = true
--     vim.bo.tabstop = 2
--     vim.bo.shiftwidth = 2
--     vim.bo.softtabstop = 2
--   end,
-- })
--
-- -- ============================================================================
-- -- STATUSLINE
-- -- ============================================================================
--
-- local function get_lsp_clients()
--   local clients = vim.lsp.get_clients({ bufnr = 0 })
--   if #clients == 0 then
--     return ""
--   end
--
--   local names = {}
--   for _, client in ipairs(clients) do
--     table.insert(names, client.name)
--   end
--
--   return " [" .. table.concat(names, ", ") .. "]"
-- end
--
-- local function get_diagnostics()
--   local diagnostics = vim.diagnostic.get(0)
--   local counts = { 0, 0, 0, 0 }
--
--   for _, diagnostic in ipairs(diagnostics) do
--     counts[diagnostic.severity] = counts[diagnostic.severity] + 1
--   end
--
--   local result = ""
--   if counts[1] > 0 then result = result .. " E:" .. counts[1] end
--   if counts[2] > 0 then result = result .. " W:" .. counts[2] end
--   if counts[3] > 0 then result = result .. " I:" .. counts[3] end
--   if counts[4] > 0 then result = result .. " H:" .. counts[4] end
--
--   return result
-- end
--
-- -- Simple statusline
-- vim.o.statusline = table.concat({
--   " %f",                        -- File path
--   " %m",                        -- Modified flag
--   " %r",                        -- Readonly flag
--   "%=",                         -- Right align
--   "%{v:lua.get_diagnostics()}", -- Diagnostics
--   "%{v:lua.get_lsp_clients()}", -- LSP clients
--   " %l:%c ",                    -- Line:column
--   " %p%% ",                     -- Percentage through file
-- })
--
-- -- Make functions global so statusline can access them
-- _G.get_diagnostics = get_diagnostics
-- _G.get_lsp_clients = get_lsp_clients
--
-- -- ============================================================================
-- -- COMMANDS
-- -- ============================================================================
--
-- -- Useful commands
-- vim.api.nvim_create_user_command("Config", "edit " .. vim.fn.stdpath("config") .. "/init.lua", { desc = "Edit config" })
-- vim.api.nvim_create_user_command("Reload", "source " .. vim.fn.stdpath("config") .. "/init.lua",
--   { desc = "Reload config" })
--
-- -- LSP commands
-- vim.api.nvim_create_user_command("LspRestart", function()
--   vim.lsp.stop_client(vim.lsp.get_clients())
--   vim.defer_fn(function()
--     vim.cmd("edit")
--   end, 500)
-- end, { desc = "Restart LSP" })
--
-- vim.api.nvim_create_user_command("LspInfo", function()
--   local clients = vim.lsp.get_clients({ bufnr = 0 })
--   if #clients == 0 then
--     print("No LSP clients attached to current buffer")
--     return
--   end
--
--   for _, client in ipairs(clients) do
--     print("Client: " .. client.name)
--     print("Root dir: " .. (client.config.root_dir or "unknown"))
--   end
-- end, { desc = "Show LSP info" })
--
-- vim.api.nvim_create_user_command("LspAvailable", function()
--   print("Checking available LSP servers...")
--   print("=====================================")
--
--   for server_name, config in pairs(servers) do
--     local cmd = config.cmd
--     if cmd and cmd[1] then
--       local available = vim.fn.executable(cmd[1]) == 1
--       local status = available and "✓ Available" or "✗ Not found"
--       local filetypes = config.filetypes and table.concat(config.filetypes, ", ") or "unknown"
--
--       print(string.format("%-15s: %s", server_name, status))
--       print(string.format("  Filetypes: %s", filetypes))
--       if not available then
--         print(string.format("  Command: %s", cmd[1]))
--       end
--       print("")
--     end
--   end
--
--   print("To install missing servers, see installation instructions.")
-- end, { desc = "Check available LSP servers" })
--
-- vim.api.nvim_create_user_command("LspCurrent", function()
--   local filetype = vim.bo.filetype
--   print("Current filetype: " .. filetype)
--   print("Available LSP servers for this filetype:")
--   print("=======================================")
--
--   local found = false
--   for server_name, config in pairs(servers) do
--     if config.filetypes then
--       for _, ft in ipairs(config.filetypes) do
--         if ft == filetype then
--           local cmd = config.cmd
--           if cmd and cmd[1] then
--             local available = vim.fn.executable(cmd[1]) == 1
--             local status = available and "✓ Available" or "✗ Not found"
--             print(string.format("  %-15s: %s", server_name, status))
--             found = true
--             break
--           end
--         end
--       end
--     end
--   end
--
--   if not found then
--     print("  No LSP servers configured for filetype: " .. filetype)
--   end
-- end, { desc = "Check LSP servers for current filetype" })
--
-- -- Utility command to check providers
-- vim.api.nvim_create_user_command("ProvidersEnable", function()
--   print("Re-enabling providers...")
--   vim.g.loaded_perl_provider = nil
--   vim.g.loaded_ruby_provider = nil
--   vim.g.loaded_python3_provider = nil
--   print("Providers enabled. Restart Neovim for changes to take effect.")
--   print("Make sure to install: pip install neovim, gem install neovim")
-- end, { desc = "Re-enable disabled providers" })
--
-- -- Debug command for autocommand issues
-- vim.api.nvim_create_user_command("DebugAutocmds", function()
--   print("Clearing all autocommands and reloading config...")
--   vim.cmd("autocmd!")
--   vim.cmd("source " .. vim.fn.stdpath("config") .. "/init.lua")
-- end, { desc = "Clear autocommands and reload config" })
--
-- -- Netrw help command
-- vim.api.nvim_create_user_command("NetrwHelp", function()
--   print("Netrw Tree Navigation Commands:")
--   print("===============================")
--   print("Basic Navigation:")
--   print("  h - Go up directory (parent)")
--   print("  l - Open directory or file")
--   print("  . - Set current directory as root")
--   print("  q - Close netrw window")
--   print("  ? - Show this help")
--   print("")
--   print("View Options:")
--   print("  H - Toggle hidden files")
--   print("  R - Refresh directory listing")
--   print("  i - Cycle through view types")
--   print("")
--   print("File Operations:")
--   print("  n - Create new file")
--   print("  N - Create new directory")
--   print("  % - Create new file (native)")
--   print("  d - Create directory (native)")
--   print("  D - Delete file/directory")
--   print("  r - Rename file/directory")
--   print("  p - Preview file")
--   print("")
--   print("Split Operations:")
--   print("  s - Open in horizontal split")
--   print("  v - Open in vertical split")
--   print("  t - Open in new tab")
--   print("  o - Open in horizontal split (native)")
--   print("")
--   print("Quick Access:")
--   print("  <leader>e  - Open netrw in current window")
--   print("  <leader>E  - Open netrw in horizontal split")
--   print("  <leader>ee - Open netrw in vertical split")
-- end, { desc = "Show netrw help and keybindings" })
--
-- -- Timeout configuration commands
-- vim.api.nvim_create_user_command("TimeoutSet", function(opts)
--   local timeout = tonumber(opts.args)
--   if timeout then
--     vim.opt.timeoutlen = timeout
--     print("Timeout set to " .. timeout .. "ms")
--     if timeout >= 3000 then
--       print("💡 Long timeout - great for learning keymaps!")
--     elseif timeout >= 1000 then
--       print("⚡ Balanced timeout - good for most users")
--     else
--       print("🚀 Fast timeout - for experienced users")
--     end
--   else
--     print("Current timeout: " .. vim.opt.timeoutlen:get() .. "ms")
--     print("Usage: :TimeoutSet <milliseconds>")
--     print("")
--     print("Presets:")
--     print("  :TimeoutSet 500   - Fast (experienced users)")
--     print("  :TimeoutSet 1000  - Balanced (recommended)")
--     print("  :TimeoutSet 2000  - Comfortable")
--     print("  :TimeoutSet 5000  - Learning mode")
--     print("  :TimeoutSet 0     - No timeout (wait forever)")
--   end
-- end, {
--   desc = "Set leader key timeout",
--   nargs = "?",
--   complete = function()
--     return { "0", "500", "1000", "2000", "3000", "5000" }
--   end
-- })
--
-- -- Show available leader keymaps
-- vim.api.nvim_create_user_command("LeaderMaps", function()
--   print("Available <leader> keymaps:")
--   print("==========================")
--   print("Files & Search:")
--   print("  <leader>e  - File explorer")
--   print("  <leader>E  - File explorer (split)")
--   print("  <leader>sf - Search files")
--   print("  <leader>sb - Search buffers")
--   print("  <leader>sg - Search with grep")
--   print("")
--   print("LSP:")
--   print("  <leader>rn - Rename symbol")
--   print("  <leader>ca - Code action")
--   print("  <leader>f  - Format buffer")
--   print("  <leader>li - LSP info")
--   print("  <leader>la - Available LSP servers")
--   print("  <leader>lc - LSP for current filetype")
--   print("  <leader>lr - Restart LSP")
--   print("")
--   print("Workspace:")
--   print("  <leader>wa - Add workspace folder")
--   print("  <leader>wr - Remove workspace folder")
--   print("  <leader>wl - List workspace folders")
--   print("")
--   print("Buffers & Tabs:")
--   print("  <leader>bd - Delete buffer")
--   print("  <leader>tn - New tab")
--   print("  <leader>tc - Close tab")
--   print("")
--   print("Terminal:")
--   print("  <leader>tt - Open terminal")
--   print("  <leader>ts - Terminal (split)")
--   print("  <leader>tv - Terminal (vertical)")
--   print("")
--   print("Quick Actions:")
--   print("  <leader>w  - Save file")
--   print("  <leader>q  - Quit")
--   print("  <leader>Q  - Quit all")
--   print("")
--   print("Diagnostics:")
--   print("  <leader>d  - Open diagnostic float")
--   print("  <leader>dl - Add diagnostics to location list")
--   print("")
--   print("Utilities:")
--   print("  <leader>uc - Check health")
--   print("  <leader>up - Enable providers")
--   print("  <leader>ud - Debug autocommands")
--   print("")
--   print("Language-specific (when available):")
--   print("  <leader>rt - Run tests")
--   print("  <leader>rr - Run program")
--   print("  <leader>rs - Run start (JS/TS)")
-- end, { desc = "Show available leader keymaps" })
--
-- -- Format command
-- vim.api.nvim_create_user_command("Format", function()
--   vim.lsp.buf.format({ async = true })
-- end, { desc = "Format buffer" })
--
-- -- Language-specific commands
-- vim.api.nvim_create_user_command("GoTest", function()
--   vim.cmd("terminal go test ./...")
-- end, { desc = "Run Go tests" })
--
-- vim.api.nvim_create_user_command("GoRun", function()
--   vim.cmd("terminal go run .")
-- end, { desc = "Run Go program" })
--
-- vim.api.nvim_create_user_command("CargoTest", function()
--   vim.cmd("terminal cargo test")
-- end, { desc = "Run Cargo tests" })
--
-- vim.api.nvim_create_user_command("CargoRun", function()
--   vim.cmd("terminal cargo run")
-- end, { desc = "Run Cargo program" })
--
-- vim.api.nvim_create_user_command("NpmTest", function()
--   vim.cmd("terminal npm test")
-- end, { desc = "Run npm tests" })
--
-- vim.api.nvim_create_user_command("NpmStart", function()
--   vim.cmd("terminal npm start")
-- end, { desc = "Run npm start" })
--
-- vim.api.nvim_create_user_command("PythonRun", function()
--   local file = vim.fn.expand("%")
--   vim.cmd("terminal python3 " .. file)
-- end, { desc = "Run Python file" })
--
-- vim.api.nvim_create_user_command("RubyRun", function()
--   local file = vim.fn.expand("%")
--   vim.cmd("terminal ruby " .. file)
-- end, { desc = "Run Ruby file" })
--
-- -- Language-specific keymaps (safe autocmd setup)
-- local lang_keymaps_group = vim.api.nvim_create_augroup("LangKeymaps", { clear = true })
--
-- autocmd("FileType", {
--   group = lang_keymaps_group,
--   pattern = "go",
--   callback = function()
--     keymap("n", "<leader>rt", "<cmd>GoTest<CR>", { buffer = true, desc = "Run Go tests" })
--     keymap("n", "<leader>rr", "<cmd>GoRun<CR>", { buffer = true, desc = "Run Go program" })
--   end,
-- })
--
-- autocmd("FileType", {
--   group = lang_keymaps_group,
--   pattern = "rust",
--   callback = function()
--     keymap("n", "<leader>rt", "<cmd>CargoTest<CR>", { buffer = true, desc = "Run Cargo tests" })
--     keymap("n", "<leader>rr", "<cmd>CargoRun<CR>", { buffer = true, desc = "Run Cargo program" })
--   end,
-- })
--
-- autocmd("FileType", {
--   group = lang_keymaps_group,
--   pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
--   callback = function()
--     keymap("n", "<leader>rt", "<cmd>NpmTest<CR>", { buffer = true, desc = "Run npm tests" })
--     keymap("n", "<leader>rs", "<cmd>NpmStart<CR>", { buffer = true, desc = "Run npm start" })
--   end,
-- })
--
-- autocmd("FileType", {
--   group = lang_keymaps_group,
--   pattern = "python",
--   callback = function()
--     keymap("n", "<leader>rr", "<cmd>PythonRun<CR>", { buffer = true, desc = "Run Python file" })
--   end,
-- })
--
-- autocmd("FileType", {
--   group = lang_keymaps_group,
--   pattern = "ruby",
--   callback = function()
--     keymap("n", "<leader>rr", "<cmd>RubyRun<CR>", { buffer = true, desc = "Run Ruby file" })
--   end,
-- })
--
-- print("Neovim configuration loaded successfully!")
--
-- -- ============================================================================
-- -- SAFE STARTUP
-- -- ============================================================================
--
-- -- Defer autocommand setup to prevent conflicts
-- vim.defer_fn(function()
--   setup_completion()
-- end, 10)
--
-- -- ============================================================================
-- -- ADDITIONAL NOTES
-- -- ============================================================================
--
-- -- LEADER KEY BEHAVIOR:
-- -- After pressing <Space> (leader), Neovim waits for the next key.
-- -- Current timeout: 1000ms (1 second) - adjust with :TimeoutSet
-- --
-- -- Quick reference: Press <leader>? to see all available keymaps
-- -- Configure timeout: Use :TimeoutSet <milliseconds>
-- --
-- -- COLORSCHEME:
-- -- Random colorscheme selected on startup from: default, desert, evening,
-- -- koehler, murphy, pablo, ron, slate
-- -- Use <leader>cr to randomize, <leader>cl to list, <leader>cs to set specific
-- --
-- -- If you see tmux warnings in :checkhealth, add this to your ~/.tmux.conf:
-- --   set-option -g focus-events on
-- --   set -g default-terminal "tmux-256color"
-- --
-- -- If you need Python/Ruby/Perl providers, install:
-- --   pip install neovim
-- --   gem install neovim
-- --   cpan Neovim::Ext
-- -- Then remove the corresponding vim.g.loaded_*_provider = 0 lines above
--
-- -- ============================================================================
-- -- TROUBLESHOOTING
-- -- ============================================================================
--
-- -- If you get "Cannot define autocommands for ALL events" error:
-- -- 1. Check for conflicting vimrc files: ~/.vimrc, ~/.vim/
-- -- 2. Try: :autocmd! to clear all autocommands
-- -- 3. Restart Neovim completely
