
return function(on_attach)
	return {
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
		end,
		cmd = { "texlab" },
		filetypes = { "tex", "bib" },
		root_dir = vim.fs.root(0, {".latexmkrc"}),
		settings = {
			texlab = {
				log_level = vim.lsp.protocol.MessageType.Log,
				auxDirectory = "build",
				bibtexFormatter = "texlab",
				build = {
					executable = "latexmk",
					args = {
						"-g",
						"-f",
					},
					onSave = true,
				},
				forwardSearch = {
					executable = "zathura",
					args = { "--synctex-forward", "%l:1:%f", "%p" },
				},
				chktex = {
					onEdit = false,
					onOpenAndSave = false,
				},
				diagnosticsDelay = 100,
				formatterLineLength = 120,
				latexFormatter = "latexindent",
				latexindent = { modifyLineBreaks = false },
				bibliography = { "chapters/appendix.bib" },
			},
		},
	}
end
