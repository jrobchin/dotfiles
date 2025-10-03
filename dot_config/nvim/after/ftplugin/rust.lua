local wk = require("which-key")

local bufnr = vim.api.nvim_get_current_buf()
wk.add({
	{
		mode = { "n", "x" },

		{
			"gra",
			function()
				vim.cmd.RustLsp("codeAction")
			end,
			desc = "LSP: Code [A]ctions",
			mode = "n",
			buffer = bufnr,
			silent = true,
		},
		{
			"grR",
			function()
				vim.cmd.RustLsp("runnables")
			end,
			desc = "LSP: [R]unnables",
			mode = "n",
			buffer = bufnr,
			silent = true,
		},
		{
			"K",
			function()
				vim.cmd.RustLsp({ "hover", "actions" })
			end,
			desc = "LSP: Hover Actions",
			mode = "n",
			buffer = bufnr,
			silent = true,
		},
		{
			"gro",
			function()
				vim.cmd.RustLsp("openDocs")
			end,
			desc = "LSP: [O]pen Docs",
			mode = "n",
			buffer = bufnr,
			silent = true,
		},
	},
})
