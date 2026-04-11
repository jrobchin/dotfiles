-- Parsers to auto-install on first launch (add/remove as needed)
local ensure_installed = {
	"c",
	"cpp",
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
	"bash",
	"jsdoc",
	"rust",
	"python",
	"toml",
}

-- Incremental selection state (treesitter node expansion/shrinking)
local ts_select = { node = nil }

local function select_node(node)
	if not node then
		return
	end
	ts_select.node = node
	local sr, sc, er, ec = node:range()
	vim.fn.setpos(".", { 0, sr + 1, sc + 1, 0 })
	vim.cmd("normal! v")
	vim.api.nvim_win_set_cursor(0, { er + 1, ec })
end

function ts_select.init_or_grow()
	if vim.fn.mode() ~= "v" then
		select_node(vim.treesitter.get_node())
	else
		local parent = ts_select.node and ts_select.node:parent()
		if parent then
			select_node(parent)
		end
	end
end

function ts_select.shrink()
	if not ts_select.node then
		return
	end
	local cursor = vim.api.nvim_win_get_cursor(0)
	local child = ts_select.node:named_child_for_range(cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2])
	if child and child:id() ~= ts_select.node:id() then
		select_node(child)
	end
end

return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = { "OXY2DEV/markview.nvim" },
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup()

		-- Auto-install missing parsers on startup
		local installed = require("nvim-treesitter.config").get_installed()
		local missing = vim.tbl_filter(function(p)
			return not vim.list_contains(installed, p)
		end, ensure_installed)
		if #missing > 0 then
			require("nvim-treesitter.install").install(missing, { summary = true })
		end

		-- Disable treesitter highlighting for markdown (markview compat)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function(args)
				vim.treesitter.stop(args.buf)
			end,
		})

		-- Disable highlighting for large files (>100KB)
		vim.api.nvim_create_autocmd("BufReadPost", {
			callback = function(args)
				local max_filesize = 100 * 1024
				local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
				if ok and stats and stats.size > max_filesize then
					vim.treesitter.stop(args.buf)
				end
			end,
		})

		-- Incremental selection keymaps (replaces old nvim-treesitter module)
		vim.keymap.set({ "n", "v" }, "<cr>", ts_select.init_or_grow, { desc = "Treesitter: expand selection" })
		vim.keymap.set("v", "<s-cr>", ts_select.shrink, { desc = "Treesitter: shrink selection" })
	end,
}
