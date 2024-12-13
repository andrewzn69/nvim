return {
	"akinsho/toggleterm.nvim",
	opts = {
		size = 10,
		open_mapping = nil,
		direction = "horizontal",
		shade_terminals = false,
		float_opts = {
			border = "double",
			height = 15,
			width = 50,
			winblend = 3,
		},
		on_open = function(term)
			vim.cmd('wincmd p')
			vim.cmd('stopinsert')
		end
	},
	config = function(_, opts)
		require("toggleterm").setup(opts)
		vim.api.nvim_set_keymap(
			'n',
			'<leader>t',
			':ToggleTerm<CR>',
			{ noremap = true, silent = true }
		)
	end,
}
