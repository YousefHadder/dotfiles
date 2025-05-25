return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"folke/trouble.nvim",
		"saghen/blink.cmp",
		"b0o/schemastore.nvim", -- JSON schemas
	},
	event = "VeryLazy",

	config = function()
		local lspconfig = require("lspconfig")
		local util = require("lspconfig/util")
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		local yaml_capabilities = vim.lsp.protocol.make_client_capabilities()

		-- Extend YAML capabilities
		yaml_capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		-- Common on_attach function
		local on_attach = function(client)
			local keymap = vim.keymap.set
			keymap("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
			keymap("n", "gd", function()
				require("telescope.builtin").lsp_definitions({ jump_type = "never" })
			end, { desc = "Go to definition" })
			keymap("n", "K", vim.lsp.buf.hover, { desc = "Show hover" })
			keymap("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
			keymap("n", "gs", vim.lsp.buf.signature_help, { desc = "Show signature help" })
			keymap("n", "gR", vim.lsp.buf.rename, { desc = "Rename" })
			keymap("n", "gr", function()
				require("telescope.builtin").lsp_references()
			end, { desc = "Show references" })
			keymap("n", "gx", vim.diagnostic.open_float, { desc = "Show diagnostics" })
			keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Show code actions" })

			if client.server_capabilities.document_formatting then
				keymap("n", "<leader>cf", vim.lsp.buf.formatting, { desc = "Format" })
			elseif client.server_capabilities.document_range_formatting then
				keymap("n", "<leader>cf", vim.lsp.buf.formatting, { desc = "Format" })
			end

			vim.diagnostic.config({
				virtual_lines = { current_line = true },
				underline = { severity = vim.diagnostic.severity.WARN },
				virtual_text = {
					prefix = function(diagnostic)
						local icons = {
							[vim.diagnostic.severity.ERROR] = "",
							[vim.diagnostic.severity.WARN] = "",
							[vim.diagnostic.severity.INFO] = "",
							[vim.diagnostic.severity.HINT] = "",
						}
						return icons[diagnostic.severity] or ""
					end,
					source = "if_many",
					spacing = 4,
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.INFO] = "",
						[vim.diagnostic.severity.HINT] = "",
					},
				},
			})
		end

		-- Server configurations
		local servers = {
			ts_ls = { root_dir = util.root_pattern("tsconfig.json") },
			gopls = {
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
			sorbet = { env = { SRB_SKIP_GEM_RBIS = 1 } },
			vale_ls = {},
			eslint = { root_dir = util.root_pattern("package.json") },
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								"${3rd}/luv/library",
							},
						},
						telemetry = { enable = false },
					},
				},
			},
			yamlls = { 
				capabilities = yaml_capabilities,
				settings = {
					yaml = {
						schemas = {
							["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
						},
					},
				},
			},
			jqls = {},
			jsonls = {
				settings = {
					json = {
						schemas = require('schemastore').json.schemas(),
						validate = { enable = true },
					},
				},
			},
			-- Add more language servers
			bashls = {},
			dockerls = {},
			marksman = {}, -- Markdown
			taplo = {}, -- TOML
		}

		-- Setup servers
		for server, config in pairs(servers) do
			local opts = vim.tbl_deep_extend("force", {
				on_attach = on_attach,
				capabilities = capabilities,
			}, config)
			if config.env then
				for k, v in pairs(config.env) do
					vim.env[k] = v
				end
			end
			lspconfig[server].setup(opts)
		end
	end,
}
