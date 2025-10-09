return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"folke/neodev.nvim",
		"b0o/schemastore.nvim",
		"ravibrock/spellwarn.nvim",
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("neodev").setup({})
		require("lsp_lines").setup()
		require("spellwarn").setup()

		local remaps = require("plugins.lsp.remaps")
		local icons = require("utils.icons")

		local presentCmpNvimLsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
		local presentLspSignature, lsp_signature = pcall(require, "lsp_signature")

		vim.lsp.set_log_level("error")

		local function on_attach(client, bufnr)
			remaps.set_default_on_buffer(client, bufnr)
			if presentLspSignature then
				lsp_signature.on_attach({ floating_window = false, timer_interval = 500 })
			end
		end

		-- Configure diagnostics
		vim.diagnostic.config({
			virtual_text = false,
			virtual_lines = false,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
					[vim.diagnostic.severity.WARN] = icons.diagnostics.warning,
					[vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
					[vim.diagnostic.severity.INFO] = icons.diagnostics.information,
				},
			},
			update_in_insert = true,
			underline = true,
			severity_sort = true,
			float = {
				focus = false,
				focusable = false,
				style = "minimal",
				border = "shadow",
				source = "always",
				header = "",
				prefix = "",
			},
		})

		local border = {
			border = "shadow",
		}
		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, border)
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border)

		local capabilities
		if presentCmpNvimLsp then
			capabilities = cmp_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
		else
			capabilities = vim.lsp.protocol.make_client_capabilities()
		end

		local servers = {
			astro = require("plugins.lsp.servers.astro")(on_attach),
			bashls = require("plugins.lsp.servers.bashls")(on_attach),
			biome = require("plugins.lsp.servers.biome")(on_attach),
			cssls = require("plugins.lsp.servers.cssls")(on_attach),
			dockerls = {},
			elixirls = {},
			html = {},
			hyprls = {},
			intelephense = require("plugins.lsp.servers.phpls")(on_attach),
			jinja_lsp = {},
			jsonls = {},
			lua_ls = require("plugins.lsp.servers.lua_ls")(on_attach),
			marksman = {},
			pyright = {}, -- require("plugins.lsp.servers.pyright")(on_attach),
			rust_analyzer = {},
			tailwindcss = {},
			terraformls = {},
			texlab = require("plugins.lsp.servers.texlab")(on_attach),
			tflint = {},
			tinymist = require("plugins.lsp.servers.tinymist")(on_attach),
			yamlls = {},
			omnisharp = require("plugins.lsp.servers.omnisharp")(on_attach),
			nil_ls = {},
			ts_ls = require("plugins.lsp.servers.ts_ls")(on_attach),
			helm_ls = {},
		}

		local default_lsp_config = {
			on_attach = on_attach,
			capabilities = capabilities,
			flags = {
				debounce_text_changes = 200,
				allow_incremental_sync = true,
			},
		}

		-- Configure LSP servers using new vim.lsp.config API
		for server, config in pairs(servers) do
			local merged_config = vim.tbl_deep_extend("force", default_lsp_config, config or {})

			if server == "rust_analyzer" then
				local present_rust_tools, rust_tools = pcall(require, "rust-tools")
				if present_rust_tools then
					rust_tools.setup({ server = merged_config })
				else
					vim.lsp.config[server] = merged_config
				end
			else
				vim.lsp.config[server] = merged_config
			end
		end

		-- Enable all configured LSP servers
		local server_names = vim.tbl_keys(servers)
		vim.lsp.enable(server_names)
	end,
}
