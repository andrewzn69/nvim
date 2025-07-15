return {
	"williamboman/mason.nvim",
	event = "VeryLazy",
	build = ":MasonInstallAll",
	config = function()
		local f = require("utils.functions")
		require("mason").setup({
			ui = {
				border = "shadow",
				icons = require("utils.icons").mason,
				zindex = 99,
			},
			registries = {
				'github:mason-org/mason-registry',
				'github:crashdummyy/mason-registry',
			},
		})
		f.cmd("MasonInstallAll", function()
			vim.cmd('MasonUpdate')
			local ensure_installed = {
				"bash-language-server",
				"black",
				"biome",
				"clang-format",
				"clangd",
				"css-lsp",
				"dockerfile-language-server",
				"eslint-lsp",
				"gopls",
				"helm-ls",
				"html-lsp",
				"intelephense",
				"isort",
				"jq",
				"json-lsp",
				"jsonlint",
				"lua-language-server",
				"markdownlint",
				"php-cs-fixer",
				"prettier",
				"prettierd",
				"prisma-language-server",
				"python-lsp-server",
				"rust-analyzer",
				"shellcheck",
				"shellharden",
				"shfmt",
				"standardjs",
				"stylelint",
				"stylelint-lsp",
				"stylua",
				"tailwindcss-language-server",
				"terraform-ls",
				"texlab",
				"tflint",
				"tinymist",
				"typescript-language-server",
				"vue-language-server",
				"yaml-language-server",
				"yamlfmt",
				"yamllint",
				"bibtex-tidy",
				"latexindent",
			}
			vim.cmd('MasonInstall ' .. table.concat(ensure_installed, ' '))
		end, { desc = "install all lsp tools" })
	end,
}
