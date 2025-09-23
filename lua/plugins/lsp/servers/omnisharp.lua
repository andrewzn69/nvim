return function(on_attach)
	return {
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
		end,
		filetypes = { "cs" },
		flags = {
			debounce_text_changes = 150,
		}
	}
end
