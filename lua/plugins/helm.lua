return {
	"towolf/vim-helm",
	lazy = false,
	priority = 1000,
	config = function()
		-- disable and clear diagnostics for helm filetype
		vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			callback = function(args)
				local bufnr = args.buf
				if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
					vim.diagnostic.enable(false, { buffer = bufnr })
					vim.defer_fn(function()
						vim.diagnostic.reset(nil, bufnr)
					end, 1000)
				end
			end,
		})
	end,
}
