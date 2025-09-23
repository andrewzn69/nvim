return function(on_attach)
return {
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
		end,
		cmd = { "intelephense", "--stdio" },
		filetypes =  { "php" },
		root_dir = vim.fs.root(0, {"composer.json", ".git"}),
		-- root_dir = util.find_git_ancestor,
		single_file_support = true,
	}
end
