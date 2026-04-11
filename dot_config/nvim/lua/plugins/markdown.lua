return {
	{
		"HakonHarnes/img-clip.nvim",
		event = "VeryLazy",
		ft = { "markdown" },
		opts = {
			default = {
				dir_path = "assets",
				file_name = "%Y-%m-%d-%H-%M-%S",
				use_absolute_path = false,
				relative_to_current_file = true,
				prompt_for_file_name = false,
				embed_image_as_base64 = false,
				drag_and_drop = {
					enabled = true,
					insert_mode = true,
				},
			},
		},
		keys = {
			{ "<leader>pi", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
		},
	},
	{
		"iamcco/markdown-preview.nvim",
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
		"OXY2DEV/markview.nvim",
		event = "VeryLazy",
		lazy = false,
		ft = { "markdown" },
		opts = {
			preview = {
				enable = false,
				filetypes = { "md", "markdown", "svx" },
				ignore_buftypes = {},
				condition = function(buffer)
					local ft = vim.bo[buffer].filetype
					return vim.list_contains({ "markdown", "md", "svx" }, ft)
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
