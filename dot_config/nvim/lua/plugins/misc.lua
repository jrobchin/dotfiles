return {
	{
		"vague2k/vague.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("vague").setup({})
			vim.cmd("colorscheme vague")
		end,
	},
	{ "folke/todo-comments.nvim", opts = {} },
	{
		"hedyhli/outline.nvim",
		keys = {
			{ "<leader>o", "<cmd>Outline<cr>", desc = "Toggle outline" },
		},
		config = function()
			require("outline").setup({
				providers = {
					priority = { "lsp", "coc", "markdown", "norg", "treesitter" },
				},
			})
		end,
		event = "VeryLazy",
		dependencies = {
			"epheien/outline-treesitter-provider.nvim",
		},
	},
	{
		"NMAC427/guess-indent.nvim",
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		"tronikelis/ts-autotag.nvim",
		opts = {},
		-- ft = {}, optionally you can load it only in jsx/html
		event = "VeryLazy",
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = { enable = true },
	},
	{
		"dimtion/guttermarks.nvim",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	},
}
