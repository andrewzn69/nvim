return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"folke/neodev.nvim",
		"b0o/schemastore.nvim",
		"ravibrock/spellwarn.nvim",
		"williamboman/mason-lspconfig.nvim",
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	},
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("neodev").setup({})
		require("lsp_lines").setup()
		require("spellwarn").setup()
		local lspconfig = require("lspconfig")
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

		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
					[vim.diagnostic.severity.WARN] = icons.diagnostics.warning,
					[vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
					[vim.diagnostic.severity.INFO] = icons.diagnostics.information,
				},
				numhl = "",
				texthl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
					[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
					[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
					[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
				},
			},
		})

		local config = {
			virtual_text = false, -- appears after the line
			virtual_lines = false, -- appears under the line
			signs = {
				active = signs,
			},
			flags = {
				debounce_text_changes = 200,
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
		}
		lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, config)
		vim.diagnostic.config(config)

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
			bashls = require("plugins.lsp.servers.bashls")(on_attach), -- formatter
			biome = require("plugins.lsp.servers.biome")(on_attach), -- formatter
			cssls = require("plugins.lsp.servers.cssls")(on_attach),
			dockerls = {},
			elixirls = {},
			html = {},
			intelephense = require("plugins.lsp.servers.phpls")(on_attach), -- php
			jsonls = {},
			lua_ls = require("plugins.lsp.servers.lua_ls")(on_attach),
			marksman = {},                                                -- markdown
			pyright = require("plugins.lsp.servers.pyright")(on_attach),  -- python
			rust_analyzer = {},                                           -- rust
			tailwindcss = {},                                             -- css
			terraformls = {},                                             -- terraform
			texlab = require("plugins.lsp.servers.texlab")(on_attach),    -- latex
			tflint = {},                                                  -- terraform
			tinymist = require("plugins.lsp.servers.tinymist")(on_attach), -- typst
			ts_ls = require("plugins.lsp.servers.ts_ls")(on_attach),      -- typescript
			yamlls = {},                                                  -- yaml
			vue_ls = require("plugins.lsp.servers.vue_ls")(on_attach),    -- vue
			omnisharp = require("plugins.lsp.servers.omnisharp")(on_attach), -- csharp
		}

		local default_lsp_config = {
			on_attach = on_attach,
			capabilities = capabilities,
			flags = {
				debounce_text_changes = 200,
				allow_incremental_sync = true,
			},
		}

		local server_names = {}
		local server_configs = {}
		for server_name, server_config in pairs(servers) do
			table.insert(server_names, server_name)
			server_configs[server_name] = server_config
		end

		local present_mason, mason = pcall(require, "mason-lspconfig")
		if present_mason then
			mason.setup({
				ensure_installed = server_names,
				automatic_installation = true,
			})

			for server_name, server_config in pairs(server_configs) do
				local merged_config = vim.tbl_deep_extend("force", default_lsp_config, server_configs[server] or {})
				lspconfig[server_name].setup(merged_config)

				if server_name == "rust_analyzer" then
					local present_rust_tools, rust_tools = pcall(require, "rust-tools")
					if present_rust_tools then
						rust_tools.setup({ server = merged_config })
					end
				end
			end
		end
	end,
}
