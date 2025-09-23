return function(on_attach)
	return {
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
			client.server_capabilities.document_formatting = false
		end,
		filetypes = { "vue" },
		init_options = {
			hostInfo = "neovim",
			vue = {
				hybridMode = false
			}
		},
		root_dir = vim.fs.root(0, {'.git'}),
		single_file_support = true,
	}
end
