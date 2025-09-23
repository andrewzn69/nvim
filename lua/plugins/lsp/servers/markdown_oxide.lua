return function(on_attach)
	return {
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
		end,
		cmd = { "markdown_oxide" },
		filetypes = { "markdown", "mdx" },
		root_dir = vim.fs.root(0, {".git"}) or vim.fn.getcwd(),
	}
end
