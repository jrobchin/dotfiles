local wk = require("which-key")

-- Quickfix toggle
local function toggle_quickfix()
	local is_open = false
	for _, win in ipairs(vim.fn.getwininfo()) do
		if win.quickfix == 1 then
			is_open = true
			break
		end
	end
	if is_open then
		vim.cmd("cclose")
	else
		vim.cmd("copen")
	end
end

-- Location list toggle (for current window)
local function toggle_loclist()
	local ll = vim.fn.getloclist(0, { winid = 0 })
	if ll.winid ~= 0 then
		vim.cmd("lclose")
	else
		vim.cmd("lopen")
	end
end

local function copy_register(text)
	vim.fn.setreg("+", text)
	vim.notify("Copied: " .. text)
end

local function copy_line_or_range(path_fn)
	local file = path_fn()
	local mode = vim.api.nvim_get_mode().mode

	if mode:sub(1, 1) == "n" then
		copy_register(string.format("%s:%d", file, vim.fn.line(".")))
		return
	end

	local fallback_start = vim.fn.line("v")
	local fallback_end = vim.fn.line(".")

	vim.schedule(function()
		local start_pos = vim.fn.getpos("'<")
		local end_pos = vim.fn.getpos("'>")
		local start_line = start_pos[2]
		local end_line = end_pos[2]

		if start_line == 0 or end_line == 0 then
			if fallback_start ~= 0 and fallback_end ~= 0 then
				start_line = fallback_start
				end_line = fallback_end
			else
				copy_register(string.format("%s:%d", file, vim.fn.line(".")))
				return
			end
		end

		if start_line == end_line and fallback_start ~= 0 and fallback_end ~= 0 and fallback_start ~= fallback_end then
			start_line = fallback_start
			end_line = fallback_end
		end

		if start_line == 0 or end_line == 0 then
			copy_register(string.format("%s:%d", file, vim.fn.line(".")))
			return
		end

		if start_line > end_line then
			start_line, end_line = end_line, start_line
		end

		if start_line == end_line then
			copy_register(string.format("%s:%d", file, start_line))
			return
		end

		copy_register(string.format("%s:%d-%d", file, start_line, end_line))
	end)
end

wk.add({
	{
		mode = { "n", "x" },

		-- Navigation
		{ "j", "gj", desc = "Navigate down (visual line)" },
		{ "k", "gk", desc = "Navigate up (visual line)" },
		{ "<Down>", "gj", desc = "Navigate down (visual line)" },
		{ "<Up>", "gk", desc = "Navigate up (visual line)" },
		{ "<C-l>", "<cmd>set hlsearch!<cr><C-l>", desc = "Toggle search highlighting" },
		{ "<C-k>", "5<C-y>", desc = "Scroll up" },
		{ "<C-j>", "5<C-e>", desc = "Scroll down" },
		{ "<C-u>", "10<C-y>", desc = "Scroll up" },
		{ "<C-d>", "10<C-e>", desc = "Scroll down" },

		-- Files
		{ "<leader>ww", "<cmd>write<cr>", desc = "Write file" },
		{ "<leader>wW", "<cmd>noautocmd write<cr>", desc = "No auto command write file" },
		{ "<leader>wa", "<cmd>wall<cr>", desc = "Write all files" },

		-- Buffers
		{
			"<leader>b",
			group = "Buffers",
		},
		{ "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete buffer" },
		{ "<leader>bD", "<cmd>bdelete!<cr>", desc = "Force delete buffer" },
		{ "<leader>bo", "<cmd>%bd|e#<cr>", desc = "Delete all buffers except current" },
		{ "<leader>ba", "<cmd>bufdo bd<cr>", desc = "Delete all buffers" },
		{
			"<leader>bp",
			function()
				local path = vim.fn.expand("%:.")
				vim.fn.setreg("+", path)
				vim.notify("Copied relative path: " .. path)
			end,
			desc = "Copy Relative Path",
		},
		{
			"<leader>bP",
			function()
				local path = vim.fn.expand("%:p")
				vim.fn.setreg("+", path)
				vim.notify("Copied absolute path: " .. path)
			end,
			desc = "Copy Absolute Path",
		},
		{
			"<leader>bl",
			function()
				copy_line_or_range(function()
					return vim.fn.expand("%:.")
				end)
			end,
			desc = "Copy Relative Path",
		},
		{
			"<leader>bL",
			function()
				copy_line_or_range(function()
					return vim.fn.expand("%:p")
				end)
			end,
			desc = "Copy file path and line number or selection range",
			mode = { "n", "x" },
		},
		{
			"<leader>bn",
			function()
				vim.fn.setreg("+", vim.fn.expand("%:t"))
			end,
			desc = "Copy file name",
		},
		{
			"<leader>bN",
			function()
				vim.fn.setreg("+", vim.fn.expand("%:t:r"))
			end,
			desc = "Copy file name (no ext)",
		},
		{
			"<leader>br",
			"<cmd>:e<cr>",
			desc = "Reload buffer",
		},
		{
			"<leader>bO",
			function()
				local path = vim.fn.expand("%:p:h")
				vim.fn.system("open " .. vim.fn.shellescape(path))
			end,
			desc = "Open in Finder",
		},

		-- System clipboard
		{ "<leader>y", "\"+y", desc = "Copy to system clipboard" },
		{ "<leader>p", "\"+p", desc = "Paste from system clipboard after cursor" },
		{ "<leader>P", "\"+P", desc = "Paste from system clipboard before cursor" },

		-- LSP
		{
			"gl",
			function()
				vim.diagnostic.open_float()
			end,
			desc = "Open floating diagnostics",
		},

		-- Lists
		{
			"<leader>q",
			group = " Quickfix",
		},
		{ "<leader>qp", vim.diagnostic.setqflist, desc = "Populate quickfix list with diagnostics" },
		{ "<leader>qq", toggle_quickfix, desc = "Toggle quickfix list" },
		{
			"<leader>l",
			group = " Loclist",
		},
		{ "<leader>lp", vim.diagnostic.setloclist, desc = "Populate location list with diagnostics" },
		{ "<leader>ll", toggle_loclist, desc = "Toggle location list" },

		-- Links
		{ "gx", "<esc>:URLOpenUnderCursor<cr>", desc = "Open URL under cursor" },
		{
			"<Leader>k",
			function()
				require("lsp_signature").toggle_float_win()
			end,
			desc = "Show/hide signature help",
		},

		-- Spelling
		{ "<leader>sf", "1z=", desc = "Fix spelling with the first option" },

		-- Formatting
		{ "<leader>wp", "m`vapgq``", desc = "Wrap paragraph" },

		-- Line numbers
		{ "<leader>rn", "<cmd>set relativenumber!<cr>", desc = "Toggle relative line numbers" },
	},
	{
		mode = { "i" },
		{ "jk", "<esc>", desc = "Exit insert mode" },
	},
})
