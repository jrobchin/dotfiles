-- JavaScript React (JSX) specific settings
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.expandtab = true
vim.bo.softtabstop = 2

-- Set comment string for JSX
vim.bo.commentstring = "{/* %s */}"

-- Enable Emmet abbreviations with Tab
vim.keymap.set("i", "<Tab>", function()
	if vim.fn["emmet#isExpandable"]() == 1 then
		return "<Plug>(emmet-expand-abbr)"
	else
		return "<Tab>"
	end
end, { buffer = true, expr = true, desc = "Expand Emmet abbreviation" })