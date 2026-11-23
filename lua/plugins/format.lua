local lsp = { lsp_format = "prefer" }

return {
	"stevearc/conform.nvim",
	event = { "BufRead", "BufNewFile" },
	opts = {
		formatters_by_ft = {
			-- astro = lsp,
			biome = lsp,
			c = lsp,
			cmake = { "cmake_format" },
			cpp = { "clang-format" },
			css = lsp,
			cs = lsp,
			elixir = lsp,
			go = lsp,
			helm = lsp,
			html = lsp,
			java = { "astyle" },
			javascript = lsp,
			json = lsp,
			lua = lsp,
			nix = lsp,
			php = { "php_cs_fixer" },
			prisma = lsp,
			python = { "isort", "black" },
			rust = lsp,
			sh = { "shfmt" },
			terraform = lsp,
			typescript = lsp,
			typescriptreact = lsp,
			vue = lsp,
			yaml = lsp,
			markdown = { "markdownlint" },
			bib = lsp,
			tex = lsp,
			plaintex = lsp,
			-- filetypes without their own entry
			["_"] = { "trim_whitespace", "trim_newlines" },
		},
		formatters = {
			astyle = {
				append_args = { "-A2", "-s2", "-c", "-J", "-n", "-q", "-z2", "-xC80" },
			},
			php_cs_fixer = {
				append_args = { "--rules=@PSR12" },
			},
		},
		format_on_save = { timeout_ms = 500 },
	},
}
