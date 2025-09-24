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
			desc = "Code [A]ctions",
			mode = "n",
			buffer = bufnr,
			silent = true,
		},
		{
			"grR",
			function()
				vim.cmd.RustLsp("runnables")
			end,
			desc = "[R]unnables",
			mode = "n",
			buffer = bufnr,
			silent = true,
		},
		{
			"K",
			function()
				vim.cmd.RustLsp({ "hover", "actions" })
			end,
			desc = "Hover Actions",
			mode = "n",
			buffer = bufnr,
			silent = true,
		},
	},
})
