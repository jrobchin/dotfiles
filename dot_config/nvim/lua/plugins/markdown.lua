return {
	{
		"iamcco/markdown-preview.nvim",
		enabled = false,
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "md", "markdown" }
		end,
		ft = { "markdown" },
		keys = {
			{ "<leader>mp", "<cmd>MarkdownPreview<cr>", desc = "Markdown Preview" },
		},
	},
	{
		"brianhuster/live-preview.nvim",
		cmd = { "LivePreview", "LivePreviewStop", "LivePreviewPick" },
		dependencies = {
			"ibhagwan/fzf-lua",
		},
		opts = {
			dynamic_root = true,
		},
		keys = {
			{ "<leader>mp", "<cmd>LivePreview start<cr>", desc = "Live Preview" },
			{ "<leader>mP", "<cmd>LivePreview pick<cr>", desc = "Live Preview (Picker)" },
		},
	},
	{
		"OXY2DEV/markview.nvim",
		event = "VeryLazy",
		priority = 49, -- load before nvim-treesitter
		lazy = false,
		ft = { "markdown" },
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
			{ "<leader>mv", "<cmd>Markview<cr>", desc = "Toggle Markview" },
		},
	},
}
