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
		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { timeout_ms = 1000 }
		end,
	},
	init = function()
		vim.api.nvim_create_user_command("Format", function(args)
			local range = nil
			if args.count ~= -1 then
				local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
				range = {
					start = { args.line1, 0 },
					["end"] = { args.line2, end_line:len() },
				}
			end
			require("conform").format({ async = true, range = range })
		end, { range = true, desc = "format buffer or range" })

		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, { bang = true, desc = "turn off format on save" })

		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, { desc = "turn on format on save" })
	end,
}
