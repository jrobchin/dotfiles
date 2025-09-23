return {
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "md", "markdown" }
		end,
		ft = { "markdown" },
	},
	{
		"OXY2DEV/markview.nvim",
		event = "VeryLazy",
		priority = 49, -- load before nvim-treesitter
		lazy = false,
		opts = {
			preview = {
				enable = false,
				filetypes = { "md", "markdown", "codecompanion", "svx" },
				ignore_buftypes = {},
				condition = function(buffer)
					local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt

					if bt == "nofile" and ft == "codecompanion" then
						return true
					elseif bt == "nofile" then
						return false
					else
						return true
					end
				end,
			},
			markdown = {
				headings = { shift_width = 0 },
			},
		},
		keys = {
			{ "<leader>m", "<cmd>Markview<cr>", desc = "Toggle Markview" },
		},
	},
}
