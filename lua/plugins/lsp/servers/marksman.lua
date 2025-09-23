return function(on_attach)
	return {
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
		end,
		root_dir = vim.fs.root(0, {".git", "README.md"}),
	}
end
