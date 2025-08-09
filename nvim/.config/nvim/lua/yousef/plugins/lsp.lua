return {
	-- Core LSP
	"neovim/nvim-lspconfig",
	event = "VeryLazy",

	dependencies = {
		-- Mason
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Status updates
		{ "j-hui/fidget.nvim", opts = {} },

		-- Completion (capabilities)
		"saghen/blink.cmp",
	},

	config = function()
		---------------------------------------------------------------------------
		-- On-attach: keymaps & buffer-scoped features
		---------------------------------------------------------------------------
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local function map(lhs, rhs, desc, mode)
					vim.keymap.set(mode or "n", lhs, rhs, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if not client then return end

				-- Document highlight (if supported)
				if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local hl_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						group = hl_group,
						buffer = event.buf,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						group = hl_group,
						buffer = event.buf,
						callback = vim.lsp.buf.clear_references,
					})
					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
						callback = function(detach_event)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = detach_event.buf })
						end,
					})
				end

				-- Toggle inlay hints (if supported)
				if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end

				-- Format on save (if supported)
				if client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = event.buf,
						callback = function() vim.lsp.buf.format({ bufnr = event.buf }) end,
					})
				end
			end,
		})

		---------------------------------------------------------------------------
		-- Diagnostics UI
		---------------------------------------------------------------------------
		vim.diagnostic.config({
			severity_sort = true,
			underline = { severity = { min = vim.diagnostic.severity.WARN } },
			virtual_lines = { current_line = true },
			virtual_text = {
				severity = { min = vim.diagnostic.severity.WARN },
				spacing = 2,
				prefix = function(d)
					local icons = {
						[vim.diagnostic.severity.ERROR] = "󰅚",
						[vim.diagnostic.severity.WARN]  = "󰀪",
						[vim.diagnostic.severity.INFO]  = "󰋽",
						[vim.diagnostic.severity.HINT]  = "󰌶",
					}
					return icons[d.severity] or "●"
				end,
			},
			float = {
				border = "rounded",
				header = "",
				prefix = "",
				format = function(diag)
					return string.format(
						"%s (%s): %s",
						diag.source or "LSP",
						diag.code or "no code",
						diag.message
					)
				end,
			},
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚",
					[vim.diagnostic.severity.WARN]  = "󰀪",
					[vim.diagnostic.severity.INFO]  = "󰋽",
					[vim.diagnostic.severity.HINT]  = "󰌶",
				},
			},
		})

		---------------------------------------------------------------------------
		-- Capabilities (blink.cmp)
		---------------------------------------------------------------------------
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		---------------------------------------------------------------------------
		-- Server-specific settings
		---------------------------------------------------------------------------
		local servers = {
			-- C/C++
			clangd = {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
				init_options = {
					usePlaceholders = true,
					completeUnimported = true,
					clangdFileStatus = true,
				},
			},

			-- Go
			gopls = {
				settings = {
					gopls = {
						gofumpt = true,
						staticcheck = true,
						usePlaceholders = true,
						analyses = {
							unusedparams = true,
							fieldalignment = true,
							shadow = true,
							useany = true,
						},
						codelenses = {
							test = true,
							tidy = true,
							upgrade_dependency = true,
							generate = true,
						},
						completeUnimported = true,
						directoryFilters = { "-vendor", "-node_modules" },
						buildFlags = { "-tags=integration" },
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
			},

			-- TypeScript/JavaScript
			ts_ls = {
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "json" },
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
						preferences = {
							disableSuggestions = false,
							quotePreference = "auto",
							includeCompletionsForModuleExports = true,
							includeCompletionsForImportStatements = true,
							includeCompletionsWithSnippetText = true,
							includeAutomaticOptionalChainCompletions = true,
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
						preferences = {
							disableSuggestions = false,
							quotePreference = "auto",
							includeCompletionsForModuleExports = true,
							includeCompletionsForImportStatements = true,
							includeCompletionsWithSnippetText = true,
							includeCompletionsWithInsertText = true,
						},
					},
				},
			},

			-- Lua
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = { "${3rd}/luv/library", unpack(vim.api.nvim_get_runtime_file("", true)) },
						},
						completion = { callSnippet = "Replace", postfix = ".", showWord = "Fallback", workspaceWord = true },
						diagnostics = { disable = { "missing-fields" }, globals = { "vim" } },
						hint = {
							enable = true,
							arrayIndex = "Disable",
							await = true,
							paramName = "Disable",
							paramType = true,
							semicolon = "Disable",
							setType = false,
						},
						format = { enable = false }, -- stylua instead
						telemetry = { enable = false },
					},
				},
			},

			-- Ruby
			ruby_lsp = { init_options = { formatter = "auto", linters = { "rubocop" } } },

			-- Bash
			bashls = { filetypes = { "sh", "bash", "zsh" } },

			-- Python
			pyright = {
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
						},
					},
				},
			},
		}

		---------------------------------------------------------------------------
		-- Mason: tools + servers
		---------------------------------------------------------------------------
		local ensure_installed = vim.tbl_keys(servers)
		vim.list_extend(ensure_installed, {
			-- Formatters
			"stylua", "prettier", "black", "gofumpt", "rubocop",
			-- Linters
			"eslint_d", "shellcheck", "golangci-lint",
		})

		require("mason-tool-installer").setup({
			ensure_installed = ensure_installed,
			auto_update = true,
			run_on_start = true,
		})

		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(servers),
			automatic_installation = true,
			handlers = {
				-- default handler
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
				-- prevent tsserver from being configured alongside ts_ls
				["tsserver"] = function() end,
			},
		})

		---------------------------------------------------------------------------
		-- Floating window defaults (rounded + bounds)
		---------------------------------------------------------------------------
		local orig_open = vim.lsp.util.open_floating_preview
		function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
			opts = opts or {}
			opts.border = opts.border or "rounded"
			opts.max_width = opts.max_width or 80
			opts.max_height = opts.max_height or 20
			return orig_open(contents, syntax, opts, ...)
		end
	end,
}
