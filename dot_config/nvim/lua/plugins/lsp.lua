return {
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Mason must be loaded before its dependents
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP
			{ "j-hui/fidget.nvim", opts = {} },

			{ "folke/which-key.nvim" },
		},
		config = function()
			-- This runs when an LSP attaches to a particular buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- fzf-lua overrides for built-in LSP navigation
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

			-----------------------------------------------------------------
			-- Server configurations (Neovim 0.12 native API)
			--
			-- vim.lsp.config() deep-merges with defaults from nvim-lspconfig's
			-- lsp/*.lua files. mason-lspconfig's automatic_enable calls
			-- vim.lsp.enable() for all Mason-installed servers.
			--
			-- This means:
			--   - Servers with no custom config just work (defaults are fine)
			--   - Only customize servers that need non-default settings
			--   - No handlers, no timing issues, no indirection
			-----------------------------------------------------------------

			-- Broadcast blink.cmp capabilities to ALL LSP servers
			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						completion = { callSnippet = "Replace" },
					},
				},
			})

			vim.lsp.config("eslint", {
				settings = {
					workingDirectory = { mode = "auto" },
				},
			})

			vim.lsp.config("emmet_ls", {
				filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
			})

			-- typescript-svelte-plugin is bundled with svelte-language-server (installed via Mason).
			-- Adding it as a vtsls global plugin gives TypeScript awareness of .svelte imports
			-- in .ts/.js files (e.g. +page.ts, +layout.ts in SvelteKit projects).
			local svelte_plugin_path = vim.fn.stdpath("data")
				.. "/mason/packages/svelte-language-server/node_modules/typescript-svelte-plugin"

			vim.lsp.config("vtsls", {
				settings = {
					vtsls = {
						tsserver = {
							globalPlugins = {
								{
									name = "typescript-svelte-plugin",
									location = svelte_plugin_path,
									enableForWorkspaceTypeScriptVersions = true,
								},
							},
						},
					},
					typescript = {
						preferences = {
							importModuleSpecifier = "relative",
							includePackageJsonAutoImports = "on",
						},
						suggest = { completeFunctionCalls = true },
					},
					javascript = {
						preferences = {
							importModuleSpecifier = "relative",
							includePackageJsonAutoImports = "on",
						},
						suggest = { completeFunctionCalls = true },
					},
				},
			})

			-- The default lsp/svelte.lua already provides on_attach with
			-- TS/JS file change notification and :LspMigrateToSvelte5 command.
			-- We only need to add defaultScriptLanguage.
			vim.lsp.config("svelte", {
				settings = {
					svelte = {
						plugin = {
							svelte = { defaultScriptLanguage = "ts" },
						},
					},
				},
			})

			-- Disable cssls validation — Tailwind LSP handles CSS validation in
			-- Tailwind projects and understands @plugin, @theme, etc. natively.
			-- cssls still provides CSS property completions and hover docs.
			vim.lsp.config("cssls", {
				settings = {
					css = { validate = false },
					less = { validate = false },
					scss = { validate = false },
				},
			})

			vim.lsp.config("somesass_ls", {
				settings = {
					css = { lint = { unknownAtRules = "ignore" } },
					scss = { lint = { unknownAtRules = "ignore" } },
				},
			})

			-- The default lsp/tailwindcss.lua already includes svelte in filetypes
			-- and sets editor.tabSize in before_init. We replace before_init to
			-- add Tailwind v4 auto-detection while preserving the tabSize logic.
			vim.lsp.config("tailwindcss", {
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
				before_init = function(_, config)
					-- Preserve default: set editor.tabSize
					config.settings = vim.tbl_deep_extend("keep", config.settings, {
						editor = { tabSize = vim.lsp.util.get_effective_tabstop() },
					})

					-- Auto-detect Tailwind v4 CSS entry point (@import 'tailwindcss')
					-- Tailwind v4 has no tailwind.config.js; the LSP needs experimental.configFile
					-- pointing to the CSS file that imports tailwindcss.
					local root_dir = config.root_dir
					if not root_dir then
						return
					end
					-- Don't override if explicitly set (e.g. via project-local .nvim.lua)
					local tw = config.settings and config.settings.tailwindCSS
					if tw and tw.experimental and tw.experimental.configFile then
						return
					end
					local css_files = vim.fs.find(function(name, path)
						return name:match("%.css$") and not path:find("node_modules", 1, true)
					end, { path = root_dir, type = "file", limit = 20 })
					for _, file_path in ipairs(css_files) do
						local ok, lines = pcall(vim.fn.readfile, file_path, "", 10)
						if ok then
							for _, line in ipairs(lines) do
								if line:find("@import%s+['\"]tailwindcss['\"]") then
									config.settings = config.settings or {}
									config.settings.tailwindCSS = config.settings.tailwindCSS or {}
									config.settings.tailwindCSS.experimental = config.settings.tailwindCSS.experimental
										or {}
									config.settings.tailwindCSS.experimental.configFile = file_path
									return
								end
							end
						end
					end
				end,
			})

			-----------------------------------------------------------------
			-- Mason: install servers and tools
			-----------------------------------------------------------------
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- LSP servers
					"clangd",
					"lua_ls",
					"marksman",
					"eslint",
					"pyright",
					"emmet_ls",
					"vtsls",
					"svelte",
					"cssls",
					"somesass_ls",
					"tailwindcss",
					-- Formatters & tools
					"stylua",
					"prettierd",
					"isort",
					"black",
					"gopls",
				},
			})

			-- mason-lspconfig: automatic_enable (default) calls vim.lsp.enable()
			-- for all Mason-installed servers, using the configs from
			-- vim.lsp.config() above merged with nvim-lspconfig's lsp/*.lua defaults.
			require("mason-lspconfig").setup()

			-- GDScript LSP (Godot), not managed by Mason
			vim.lsp.enable("gdscript")
		end,
	},
}
