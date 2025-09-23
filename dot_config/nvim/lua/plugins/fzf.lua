return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		keys = {
			{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
			{ "<leader>fF", "<cmd>FzfLua files resume=true<cr>", desc = "Resume finding files" },
			{ "<leader>fg", "<cmd>FzfLua grep_project<cr>", desc = "Fuzzy search project" },
			{ "<leader>fG", "<cmd>FzfLua grep_project resume=true<cr>", desc = "Fuzzy search project (resume)" },
			{ "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Find help tags" },
			{ "<leader>fi", "<cmd>FzfLua builtin<cr>", desc = "Find fzf buildins" },
			{ "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Find keymaps" },
			{ "<leader>fo", "<cmd>FzfLua oldfiles<cr>", desc = "Find oldfiles" },
			{ "<leader>fd", "<cmd>FzfLua lsp_document_diagnostics<cr>", desc = "Find document diagnostics" },
			{ "<leader>fD", "<cmd>FzfLua lsp_workspace_diagnostics<cr>", desc = "Find workspace diagnostics" },
			{ "<leader>fm", "<cmd>FzfLua marks<cr>", desc = "Find workspace diagnostics" },
			{ "<leader><leader>", "<cmd>FzfLua buffers<cr>", desc = "List buffers" },
			{ "<leader>/", "<cmd>FzfLua grep_curbuf<cr>", desc = "Fuzzy search buffer" },
			{ "<leader>'", "<cmd>FzfLua grep_curbuf resume=true<cr>", desc = "Fuzzy search buffer" },
		},
		config = function()
			require("fzf-lua").setup({
				"hide",
			})
		end,
	},
}
