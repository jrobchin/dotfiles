return {
	"scalameta/nvim-metals",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"mfussenegger/nvim-dap",
	},
	ft = { "scala", "sbt", "java" },
	opts = function()
		local metals_config = require("metals").bare_config()

		-- Example of settings
		metals_config.settings = {
			showImplicitArguments = true,
			excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
			scalafmtConfigPath = ".scalafmt.conf", -- Use project's scalafmt config
			scalafixConfigPath = ".scalafix.conf", -- Use project's scalafix config
			-- metals = {},
		}

		-- *READ THIS*
		-- I *highly* recommend setting statusBarProvider to either "off" or "on"
		--
		-- "off" will enable LSP progress notifications by Metals and you'll need
		-- to ensure you have a plugin like fidget.nvim installed to handle them.
		--
		-- "on" will enable the custom Metals status extension and you *have* to have
		-- a have settings to capture this in your statusline or else you'll not see
		-- any messages from metals. There is more info in the help docs about this
		metals_config.init_options.statusBarProvider = "off"

		-- Example if you are using cmp how to make sure the correct capabilities for snippets are set
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		metals_config.capabilities = capabilities

		-- Debug settings if you're using nvim-dap
		local dap = require("dap")

		dap.configurations.scala = {
			{
				type = "scala",
				request = "launch",
				name = "RunOrTest",
				metals = {
					runType = "runOrTestFile",
					--args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
				},
			},
			{
				type = "scala",
				request = "launch",
				name = "Test Target",
				metals = {
					runType = "testTarget",
				},
			},
		}

		metals_config.on_attach = function(client, bufnr)
			require("metals").setup_dap()

			-- Enable formatting through Metals LSP
			-- This will use scalafmt if a .scalafmt.conf is present in your project
			vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")

			-- Optional: Add keymapping for Metals-specific commands
			-- local map = function(keys, func, desc)
			-- 	vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
			-- end

			-- map("<leader>mc", require("metals").compile_cascade, "Metals: Compile cascade")
			-- map("<leader>mi", require("metals").toggle_setting_bool("showImplicitArguments"), "Metals: Toggle implicit args")
			-- map("<leader>md", require("metals").doctor_run, "Metals: Run doctor")
		end

		return metals_config
	end,
	config = function(self, metals_config)
		local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			pattern = self.ft,
			callback = function()
				require("metals").initialize_or_attach(metals_config)
			end,
			group = nvim_metals_group,
		})
	end,
}

