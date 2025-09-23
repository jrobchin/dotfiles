return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		view_options = {
			show_hidden = true,
		},
		win_options = {
			signcolumn = "yes:2",
		},
		keymaps = {
			["gd"] = {
				desc = "Toggle file detail view",
				callback = function()
					detail = not detail
					if detail then
						require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
					else
						require("oil").set_columns({ "icon" })
					end
				end,
			},
		},
		skip_confirm_for_simple_edits = true,
	},
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons" } },
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	keys = {
		{ "<leader>e", "<cmd>Oil<cr>", desc = "Open Oil" },
	},
}
