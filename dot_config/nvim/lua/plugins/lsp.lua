return {
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			-- Mason must be loaded before its dependents so we need to set it up here.
			-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },

			{ "folke/which-key.nvim" },
		},
		config = function()
			--  This function gets run when an LSP attaches to a particular buffer.
			--    That is to say, every time a new file is opened that is associated with
			--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
			--    function will be executed to configure the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- fzf-lua overrides for built-in LSP navigation (intentionally replacing defaults)
					map("grr", require("fzf-lua").lsp_references, "Goto references")
					map("gri", require("fzf-lua").lsp_implementations, "Goto implementation")
					map("grd", require("fzf-lua").lsp_definitions, "Goto definition")
					map("gO", require("fzf-lua").lsp_document_symbols, "Open document symbols")
					map("gW", require("fzf-lua").lsp_live_workspace_symbols, "Open workspace symbols")
					map("grt", require("fzf-lua").lsp_typedefs, "Type definition")

					-- Diagnostics via fzf-lua
					map("gsd", require("fzf-lua").diagnostics_document, "Search document diagnostics")
					map("gsD", require("fzf-lua").diagnostics_workspace, "Search workspace diagnostics")

					-- Register CTRL-S for which-key discoverability (already a 0.12 default)
					map("<C-s>", vim.lsp.buf.signature_help, "Signature help", "i")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if not client then
						return
					end

					-- Highlight references of the word under cursor
					if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
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
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if client.name == "vtsls" then
						vim.lsp.inlay_hint.enable(false, { bufnr = event.buf })
					end

					-- Toggle inlay hints
					if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				},
				virtual_text = {
					source = "if_many",
					spacing = 2,
				},
			})

			-- Broadcast blink.cmp capabilities to LSP servers
			local original_capabilities = vim.lsp.protocol.make_client_capabilities()
			local capabilities = require("blink.cmp").get_lsp_capabilities(original_capabilities)

			local servers = {
				clangd = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				marksman = {},
				eslint = {
					settings = {
						workingDirectory = { mode = "auto" },
					},
				},
				pyright = {},
				emmet_ls = {
					filetypes = {
						"html",
						"typescriptreact",
						"javascriptreact",
						"css",
						"sass",
						"scss",
						"less",
						"svelte",
					},
				},
				vtsls = {
					settings = {
						typescript = {
							preferences = {
								importModuleSpecifier = "relative",
								includePackageJsonAutoImports = "on",
							},
							suggest = {
								completeFunctionCalls = true,
							},
						},
						javascript = {
							preferences = {
								importModuleSpecifier = "relative",
								includePackageJsonAutoImports = "on",
							},
							suggest = {
								completeFunctionCalls = true,
							},
						},
					},
				},
				svelte = {},
				somesass_ls = {},
				tailwindcss = {
					filetypes = {
						"html",
						"typescriptreact",
						"javascriptreact",
						"css",
						"sass",
						"scss",
						"svelte",
					},
					settings = {
						tailwindCSS = {
							experimental = {
								classRegex = {
									{ "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
									{ "cn\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
									{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
								},
							},
						},
					},
				},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
				"eslint_d",
				"prettierd",
				"isort",
				"black",
				"gopls",
				"tailwindcss-language-server",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})

			-- GDScript LSP (Godot), not managed by Mason
			vim.lsp.enable("gdscript")
		end,
	},
}
