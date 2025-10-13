-- options
--------------------------------------------------------------------------------
local opt = vim.opt

-- Disable mouse support
opt.mouse = ""

-- Confirm before exiting a modified buffer
opt.confirm = true

-- Relative and absolute line numbers combined
opt.number = true
opt.relativenumber = true

-- Keep signcolumn on by default
opt.signcolumn = "yes"

-- Cursorline
opt.cursorline = true

-- Spelling
opt.spelllang = "en_us"
opt.spell = true
opt.spelloptions = "camel"

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Preview substitutions
opt.inccommand = "split"

-- Text wrapping
opt.wrap = true
opt.breakindent = true
opt.linebreak = true

-- Tab stops
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

-- Window splitting
opt.splitright = true
opt.splitbelow = true

-- Save undo history
opt.undofile = true

-- Set the default border for all floating windows
opt.winborder = "rounded"

-- Allow scrolling past the end of the file
opt.scrolloff = 8 -- This keeps cursor centered when possible
opt.sidescrolloff = 8 -- Horizontal scrolling offset

-- Global statusline
opt.laststatus = 3
opt.showmode = false

-- Scrolling
opt.smoothscroll = true

-- Fill chars
opt.fillchars = {
	foldopen = "",
	foldclose = "",
}

-- Folding
opt.foldlevel = 99
opt.foldtext = ""
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Colors
opt.termguicolors = true

-- File types
vim.filetype.add({
	extension = {
		svx = "markdown",
	},
})

-- cfilter
vim.cmd.packadd("cfilter")
