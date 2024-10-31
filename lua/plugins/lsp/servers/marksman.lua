local util = require 'lspconfig.util'
return function(on_attach)
	return {
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
		end,
		root_dir = util.root_pattern(".git", "README.md"),     -- Add your root directory patterns here
	}
end
