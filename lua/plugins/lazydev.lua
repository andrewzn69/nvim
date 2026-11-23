return {
	"folke/lazydev.nvim",
	ft = "lua",
	opts = {
		library = {
			-- luvit types, loaded only in files that use them
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	},
}
