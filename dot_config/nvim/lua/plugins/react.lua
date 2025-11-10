return {
	-- Auto close and rename JSX tags
	{
		"windwp/nvim-ts-autotag",
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "html", "svelte" },
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					-- Defaults
					enable_close = true, -- Auto close tags
					enable_rename = true, -- Auto rename pairs of tags
					enable_close_on_slash = true, -- Auto close on trailing </
				},
			})
		end,
	},
	-- Better JSX/TSX comments
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = {
			enable_autocmd = false,
		},
	},
	-- React snippets are now in snippets/typescript.json and snippets/typescriptreact.json
	-- Use snippet shortcuts like 'rfc', 'rfcd', 'rhook', 'us', 'ue', etc.
}