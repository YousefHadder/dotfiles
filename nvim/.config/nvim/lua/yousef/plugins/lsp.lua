return {
	-- Mason for automatic LSP/tool installation
	"williamboman/mason.nvim",
	event = "VeryLazy",

	dependencies = {
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

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if not client then
					return
				end

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

				-- Document color support (0.12+)
				if client:supports_method("textDocument/documentColor") then
					map("grc", function()
						vim.lsp.document_color.color_presentation()
					end, "Color presentation", { "n", "x" })
				end

				-- Attach nvim-navic for breadcrumb navigation (used by incline.nvim)
				if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentSymbol) then
					local ok, navic = pcall(require, "nvim-navic")
					if ok then
						navic.attach(client, event.buf)
					end
				end

				-- Formatting is handled by conform.nvim's format_on_save
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
						[vim.diagnostic.severity.WARN] = "󰀪",
						[vim.diagnostic.severity.INFO] = "󰋽",
						[vim.diagnostic.severity.HINT] = "󰌶",
					}
					return icons[d.severity] or "●"
				end,
			},
			float = {
				border = "rounded",
				header = "",
				prefix = "",
				format = function(diag)
					return string.format("%s (%s): %s", diag.source or "LSP", diag.code or "no code", diag.message)
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
			-- Enable vim.diagnostic.status() for statusline integration (0.12+)
			status = {
				format = {
					[vim.diagnostic.severity.ERROR] = "󰅚",
					[vim.diagnostic.severity.WARN] = "󰀪",
					[vim.diagnostic.severity.INFO] = "󰋽",
					[vim.diagnostic.severity.HINT] = "󰌶",
				},
			},
		})

		---------------------------------------------------------------------------
		-- Native LSP setup (0.12 pattern)
		-- Server configs live in top-level lsp/*.lua files (vim.lsp.Config tables).
		-- Shared capabilities are set via vim.lsp.config('*').
		-- Servers are discovered from lsp/ and enabled in a single call.
		---------------------------------------------------------------------------
		vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
			once = true,
			callback = function()
				-- Shared capabilities for all servers
				vim.lsp.config("*", {
					capabilities = require("blink.cmp").get_lsp_capabilities(nil, true),
				})

				-- Discover and enable servers from our lsp/ directory
				local config_dir = vim.fn.stdpath("config")
				local servers = vim.iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
					:filter(function(file)
						-- Only include files from our config directory
						return vim.startswith(file, config_dir)
					end)
					:map(function(file)
						return vim.fn.fnamemodify(file, ":t:r")
					end)
					:totable()
				vim.lsp.enable(servers)
			end,
		})

		---------------------------------------------------------------------------
		-- Mason: tool installation (servers + formatters + linters)
		---------------------------------------------------------------------------
		require("mason-tool-installer").setup({
			ensure_installed = {
				-- LSP servers
				"clangd",
				"gopls",
				"eslint-lsp",
				"typescript-language-server",
				"lua-language-server",
				"ruby-lsp",
				"bash-language-server",
				"pyright",
				"marksman",
				"terraform-ls",
				"json-lsp",
				"yaml-language-server",
				"jq-lsp",
				"stylelint-lsp",
				-- Formatters
				"stylua",
				"prettier",
				"prettierd",
				"black",
				"isort",
				"goimports",
				"shfmt",
				-- Linters
				"eslint_d",
				"shellcheck",
				"golangci-lint",
				"tflint",
				"pylint",
				"revive",
				"luacheck",
				"jsonlint",
				"markdownlint",
			},
			auto_update = false,
			run_on_start = true,
			debounce_hours = 96,
		})

		-- Mason-lspconfig: ensure servers are installed (no handler loop needed)
		require("mason-lspconfig").setup({
			automatic_installation = true,
		})

		---------------------------------------------------------------------------
		-- Note: Floating window borders are handled globally via
		-- vim.o.winborder in options.lua (no monkey-patching needed)
		---------------------------------------------------------------------------
	end,
}
