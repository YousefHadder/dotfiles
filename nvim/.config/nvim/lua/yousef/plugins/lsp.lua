return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	dependencies = {
		-- Mason dependencies
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP
		{ "j-hui/fidget.nvim", opts = {} },

		-- Completion engine
		"saghen/blink.cmp",
	},
	config = function()
		-- LSP Attach autocmd for buffer-local keymaps and features
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end


				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if not client then return end

				-- Document highlighting
				if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
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

				-- Inlay hints toggle
				if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end

				-- Format on save (optional)
				if client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = event.buf,
						callback = function()
							vim.lsp.buf.format({ bufnr = event.buf })
						end,
					})
				end
			end,
		})

		-- Enhanced diagnostic configuration
		vim.diagnostic.config({
			severity_sort = true,
			update_in_insert = false,
			underline = {
				severity = { min = vim.diagnostic.severity.WARN }
			},
			virtual_text = {
				severity = { min = vim.diagnostic.severity.WARN },
				source = "if_many",
				spacing = 2,
				prefix = function(diagnostic)
					local icons = {
						[vim.diagnostic.severity.ERROR] = "󰅚",
						[vim.diagnostic.severity.WARN] = "󰀪",
						[vim.diagnostic.severity.INFO] = "󰋽",
						[vim.diagnostic.severity.HINT] = "󰌶",
					}
					return icons[diagnostic.severity] or "●"
				end,
			},
			float = {
				border = "rounded",
				source = "if_many",
				header = "",
				prefix = "",
				format = function(diagnostic)
					return string.format("%s (%s): %s",
						diagnostic.source or "LSP",
						diagnostic.code or "no code",
						diagnostic.message
					)
				end,
			},
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚",
					[vim.diagnostic.severity.WARN] = "󰀪",
					[vim.diagnostic.severity.INFO] = "󰋽",
					[vim.diagnostic.severity.HINT] = "󰌶",
				},
			},
		})

		-- Get blink.cmp capabilities
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- Enhanced server configurations
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
				filetypes = {
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"vue",
					"json",
				},
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
							library = {
								"${3rd}/luv/library",
								unpack(vim.api.nvim_get_runtime_file("", true)),
							},
						},
						completion = {
							callSnippet = "Replace",
							postfix = ".",
							showWord = "Fallback",
							workspaceWord = true,
						},
						diagnostics = {
							disable = { "missing-fields" },
							globals = { "vim" },
						},
						hint = {
							enable = true,
							arrayIndex = "Disable",
							await = true,
							paramName = "Disable",
							paramType = true,
							semicolon = "Disable",
							setType = false,
						},
						format = {
							enable = false, -- Use stylua instead
						},
						telemetry = { enable = false },
					},
				},
			},

			-- Ruby
			ruby_lsp = {
				init_options = {
					formatter = "auto",
					linters = { "rubocop" },
				},
			},

			-- Bash
			bashls = {
				filetypes = { "sh", "bash", "zsh" },
			},

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

		-- Mason tool installer setup
		local ensure_installed = vim.tbl_keys(servers)
		vim.list_extend(ensure_installed, {
			-- Formatters
			"stylua",
			"prettier",
			"black",
			"gofumpt",
			"rubocop",

			-- Linters
			"eslint_d",
			"shellcheck",
			"golangci-lint",
		})

		require("mason-tool-installer").setup({
			ensure_installed = ensure_installed,
			auto_update = true,
			run_on_start = true,
		})

		-- Mason LSP setup with enhanced handlers
		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(servers),
			automatic_installation = true,
			handlers = {
				-- Default handler
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,

				-- Disable tsserver if using ts_ls
				["tsserver"] = function() end,
			},
		})

		-- Global LSP settings
		vim.lsp.set_log_level("WARN")

		-- Improve LSP performance
		local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
		function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
			opts = opts or {}
			opts.border = opts.border or "rounded"
			opts.max_width = opts.max_width or 80
			opts.max_height = opts.max_height or 20
			return orig_util_open_floating_preview(contents, syntax, opts, ...)
		end
	end,
}
