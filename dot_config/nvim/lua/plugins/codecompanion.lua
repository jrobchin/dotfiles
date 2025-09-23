return {
	{
		"olimorris/codecompanion.nvim",
		tag = "v17.15.0",
		lazy = false,
		enabled = false,
		opts = {
			strategies = {
				chat = {
					adapter = "openrouter",
					keymaps = {
						completion = {
							modes = {
								i = "<C-Space>",
							},
							index = 1,
							callback = "keymaps.completion",
							description = "Completion Menu",
						},
					},
				},
				inline = {
					adapter = "openrouter",
				},
				cmd = {
					adapter = "openrouter",
				},
			},
			adapters = {
				openrouter = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = "https://openrouter.ai/api",
							api_key = "OPENROUTER_API_KEY",
							chat_url = "/v1/chat/completions",
						},
						schema = {
							model = {
								default = "anthropic/claude-sonnet-4",
							},
						},
					})
				end,
			},
			display = {
				action_palette = {
					provider = "fzf_lua",
				},
			},
			extensions = {
				-- mcphub = {
				-- 	callback = "mcphub.extensions.codecompanion",
				-- 	opts = {
				-- 		-- MCP Tools
				-- 		make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
				-- 		show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
				-- 		add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
				-- 		show_result_in_chat = true, -- Show tool results directly in chat buffer
				-- 		format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
				-- 		-- MCP Resources
				-- 		make_vars = true, -- Convert MCP resources to #variables for prompts
				-- 		-- MCP Prompts
				-- 		make_slash_commands = true, -- Add MCP prompts as /slash commands
				-- 	},
				-- },
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			{
				"echasnovski/mini.diff",
				config = function()
					local diff = require("mini.diff")
					diff.setup({
						-- Disabled by default
						source = diff.gen_source.none(),
					})
				end,
			},
			{
				"HakonHarnes/img-clip.nvim",
				opts = {
					filetypes = {
						codecompanion = {
							prompt_for_file_name = false,
							template = "[Image]($FILE_PATH)",
							use_absolute_path = true,
						},
					},
				},
			},
		},
		keys = {
			{ "<leader>ca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion actions" },
			{ "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "CodeCompanion toggle chat" },
			{ "<leader>ci", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "CodeCompanion inline" },
		},
	},
}
