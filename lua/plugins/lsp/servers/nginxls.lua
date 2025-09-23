return function(on_attach)
	return {
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
		end,
		cmd = { 'nginx-language-server' },
		cmd_env = {
			GLOB_PATTERN = "*@(nginx.conf)",
		},
		filetypes = { "nginx" },
		root_dir = vim.fs.root(0, {'.git'}),
		single_file_support = true,
	}
end
