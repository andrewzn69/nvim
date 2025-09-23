local function get_typescript_server_path(root_dir)
	local project_root = vim.fs.find('node_modules', { path = root_dir, upward = true })[1]
  return project_root and vim.fs.joinpath(project_root, 'typescript', 'lib') or ''
end

return function(on_attach)
	return {
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
			client.server_capabilities.document_formatting = false
			client.server_capabilities.documentFormattingProvider = false
		end,
		cmd = { 'astro-ls', '--stdio' },
		filetypes = { 'astro' },
		root_dir = vim.fs.root(0, {'package.json', 'tsconfig.json', 'jsconfig.json', '.git'}),
		init_options = {
			typescript = {},
		},
		on_new_config = function(new_config, new_root_dir)
			if vim.tbl_get(new_config.init_options, 'typescript') and not new_config.init_options.typescript.tsdk then
				new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
			end
		end,
		docs = {
			description = [[
https://github.com/withastro/language-tools/tree/main/packages/language-server

`astro-ls` can be installed via `npm`:
```sh
npm install -g @astrojs/language-server
```
]],
		},
	}
end
