return {
	'wakatime/vim-wakatime',
	event = "VeryLazy",
	cond = function()
		return vim.fn.executable('wakatime') == 1
	end
}
