return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = { "OXY2DEV/markview.nvim" },
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			-- A list of parser names, or "all" (the listed parsers MUST always be installed)
			ensure_installed = {
				"c",
				"lua",
				"query",
				"markdown",
				"markdown_inline",
				"json",
				"go",
				"gomod",
				"gosum",
				"typescript",
				"tsx",
				"csv",
				"dockerfile",
				"svelte",
				"yaml",
				"html",
				"xml",
				"javascript",
				"scss",
				"css",
			},
			ignore_install = {},
			modules = {},

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,

			---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
			-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<cr>", -- set to `false` to disable one of the mappings
					node_incremental = "<cr>",
					scope_incremental = "s",
					node_decremental = "<s-cr>",
				},
			},

			highlight = {
				enable = true,

				disable = function(lang, buf)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
					-- Disable for markdown to avoid conflicts with markview
					if lang == "markdown" then
						return true
					end
				end,

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},
		})
	end,
}
