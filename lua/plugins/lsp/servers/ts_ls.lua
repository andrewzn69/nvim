return function(on_attach)
	return {
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
			client.server_capabilities.document_formatting = false
		end,
		cmd = { "typescript-language-server", "--stdio" },
		filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},
		init_options = {
			hostInfo = "neovim",
		},
		-- root_dir = vim.fs.root(0, {"package.json", "package-lock.json", "tsconfig.json", "jsconfig.json", ".git"}),
		root_dir = vim.fs.root(0, {'node_modules'}) or vim.fs.root(0, {'package.json', 'tsconfig.json', 'jsconfig.json', '.git'}),
		single_file_support = true,
	}
end
