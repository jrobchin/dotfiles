return {
	{
		"echasnovski/mini.nvim",
		version = false, -- always use latest
		config = function()
			require("mini.icons").setup()
			require("mini.cursorword").setup()
			require("mini.statusline").setup()

			require("mini.indentscope").setup({
				draw = {
					delay = 0,
					animation = require("mini.indentscope").gen_animation.none(),
				},
			})
		end,
	},
}
