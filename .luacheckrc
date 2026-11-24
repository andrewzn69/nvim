std = 'lua51'
codes = true
-- stylua handles line length
max_line_length = false

read_globals = { 'jit', 'vim' }

globals = {
	'vim.g',
	'vim.b',
	'vim.w',
	'vim.t',
	'vim.o',
	'vim.go',
	'vim.bo',
	'vim.wo',
	'vim.opt',
	'vim.opt_local',
	'vim.opt_global',
	'vim.env',
}
