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
	-- React snippets are included in friendly-snippets (already installed in cmp.lua)
	-- Additional React-specific keymaps and commands
	{
		"folke/which-key.nvim",
		opts = function(_, opts)
			local wk = require("which-key")
			wk.add({
				{ "<leader>r", group = "React", icon = "⚛" },
				{
					"<leader>rc",
					function()
						-- Create a new React component in the current file
						local component_name = vim.fn.input("Component name: ")
						if component_name == "" then
							return
						end
						local lines = {
							"import React from 'react';",
							"",
							"interface " .. component_name .. "Props {",
							"  // Add props here",
							"}",
							"",
							"export const " .. component_name .. ": React.FC<" .. component_name .. "Props> = ({}) => {",
							"  return (",
							"    <div>",
							"      " .. component_name,
							"    </div>",
							"  );",
							"};",
						}
						vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
					end,
					desc = "Create React component",
				},
				{
					"<leader>rh",
					function()
						-- Create a new React hook in the current file
						local hook_name = vim.fn.input("Hook name (without 'use' prefix): ")
						if hook_name == "" then
							return
						end
						local lines = {
							"import { useState, useEffect } from 'react';",
							"",
							"export const use" .. hook_name .. " = () => {",
							"  const [state, setState] = useState();",
							"",
							"  useEffect(() => {",
							"    // Effect logic here",
							"  }, []);",
							"",
							"  return { state };",
							"};",
						}
						vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
					end,
					desc = "Create React hook",
				},
			})
			return opts
		end,
	},
}