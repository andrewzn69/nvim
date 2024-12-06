return function(on_attach)
	return {
		on_attach = on_attach,
		single_file_support = true,
		root_dir = function()
			return vim.fn.getcwd()
		end,
		settings = {
			exportPdf = "onType" },
	}
end
