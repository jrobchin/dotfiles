return {
	"nvim-java/nvim-java",
	config = function()
		require("java").setup({
			-- Your custom jdtls settings goes here
		})

		require("lspconfig").jdtls.setup({
			-- Your custom nvim-java configuration goes here
		})
	end,
	-- TODO: Set keybinds for APIs mentioned here: https://github.com/nvim-java/nvim-java
	keys = {},
}
