local util = require 'lspconfig.util'
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
		root_dir = util.find_git_ancestor,
		single_file_support = true,
	}
end
