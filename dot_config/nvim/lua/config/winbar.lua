-- This function gets the git diff information from the gitsigns plugin
-- Note: Requires Nerd Font for the icons.
function _G.get_git_info()
	-- gitsigns provides this dictionary with hunk information
	local dict = vim.b.gitsigns_status_dict
	if not dict or dict.head == "" then
		return ""
	end

	local added = dict.added and (" " .. dict.added) or ""
	local changed = dict.changed and (" " .. dict.changed) or ""
	local removed = dict.removed and (" " .. dict.removed) or ""

	-- Combine the parts, filtering out empty strings
	local parts = {}
	if added ~= "" then
		table.insert(parts, added)
	end
	if changed ~= "" then
		table.insert(parts, changed)
	end
	if removed ~= "" then
		table.insert(parts, removed)
	end

	local result = table.concat(parts, " ")
	return result ~= "" and (result .. " ") or ""
end

-- This is the main function for building the winbar string
function _G.get_custom_winbar()
	local file_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")

	if file_path == "" or vim.bo.buftype ~= "" then
		return ""
	end

	-- If the path is longer than 80 characters, shorten it from the left
	if #file_path > 80 then
		-- Takes the last 77 characters and prepends "..."
		file_path = "..." .. file_path:sub(-77)

		-- Alternatively, use path shortener
		-- file_path = vim.fn.pathshorten(file_path)
	end

	local modified_marker = vim.bo.modified and "● " or ""
	local git_info = _G.get_git_info()

	-- Add a space at the end for padding from the right edge
	return "  " .. modified_marker .. git_info .. file_path .. " "
end

-- Set the winbar to be right-aligned and use the custom function
vim.opt.winbar = "%{v:lua.get_custom_winbar()}"
