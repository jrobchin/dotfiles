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
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
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
	-- lazy.nvim
	{
		"sontungexpt/url-open",
		event = "VeryLazy",
		cmd = "URLOpenUnderCursor",
		config = function()
			local status_ok, url_open = pcall(require, "url-open")
			if not status_ok then
				return
			end
			url_open.setup({})
		end,
	},
	{
		"tronikelis/ts-autotag.nvim",
		opts = {},
		-- ft = {}, optionally you can load it only in jsx/html
		event = "VeryLazy",
	},
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {},
	},
}
