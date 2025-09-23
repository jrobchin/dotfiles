return {
	"folke/trouble.nvim",
	enabled = false,
	opts = {
		modes = {
			my_diagnostics = {
				mode = "diagnostics",
				preview = {
					type = "float",
					relative = "editor",
					border = "rounded",
					title = "Preview",
					position = { 0, 0 },
					size = { width = 0.6, height = 0.6 },
					zindex = 10,
				},
			},
		},
	},
	cmd = "Trouble",
	keys = {
		{
			"<leader>xx",
			"<cmd>Trouble my_diagnostics toggle<cr>",
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>xX",
			"<cmd>Trouble my_diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>cs",
			"<cmd>Trouble symbols toggle focus=false<cr>",
			desc = "Symbols (Trouble)",
		},
		{
			"<leader>cl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
		{
			"<leader>xL",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "Location List (Trouble)",
		},
		{
			"<leader>xQ",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Quickfix List (Trouble)",
		},
	},
}
