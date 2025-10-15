return {
	"stevearc/conform.nvim",
	lazy = false,
	config = function()
		require("conform").setup({
			async = true,
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				svelte = { "prettierd", "prettier", stop_after_first = true },
				markdown = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettierd", "prettier", stop_after_first = true },
				scss = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				kotlin = { "ktlint" },
				-- Scala formatting is handled by Metals LSP
			},
			format_after_save = function(bufnr)
				local filename = vim.api.nvim_buf_get_name(bufnr)
				if string.match(filename, "%.svx$") then
					return nil
				end
				-- For Scala files, always use LSP formatting (Metals)
				if vim.bo[bufnr].filetype == "scala" or vim.bo[bufnr].filetype == "sbt" then
					return {
						lsp_format = "prefer",
					}
				end
				return {
					lsp_format = "fallback",
				}
			end,
		})
	end,
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "Code format",
		},
	},
}
