vim.cmd("autocmd!")

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.title = true

vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.scrolloff = 10

-- cursorline
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.colorcolumn = "81"

-- modelines (bad for security)
vim.opt.modelines = 1

-- hide buffers, not close them
vim.opt.hidden = true

-- maintain undo history between sessions
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- scroll bounds
vim.o.scrolloff = 13


-- use markdown syntax highlighting for mdx
-- no mdx treeshitter support yet?
vim.cmd([[au BufRead,BufNewFile *.mdx set filetype=markdown]])

-- case insensitive search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true

-- make backspaces behave in a sane manner
vim.opt.backspace = "indent,eol,start"

-- searching
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"

-- use indents of 2
vim.opt.shiftwidth = 2

-- tabs
vim.opt.expandtab = false

-- an indentation every 2 columns
vim.opt.tabstop = 2

-- let backspace delete indent
vim.opt.softtabstop = 2

-- indentation
vim.opt.autoindent = true
vim.opt.smartindent = true

-- turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = '*',
	command = "set nopaste"
})

-- add asterisks in block comments
vim.opt.formatoptions:append { 'r' }

-- undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- automatically change working directory to the project root
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		local cwd = vim.fn.getcwd()
		local git_root = vim.fn.finddir(".git", cwd .. ";")
		if git_root ~= "" then
			vim.cmd("cd " .. vim.fn.fnamemodify(git_root, ":h"))
		end
	end,
})

-- On VimEnter, enables recursive path search and ignores irrelevant files.
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.opt.path:append("**")
		vim.opt.wildignore:append(
			".git,.hg,.svn" ..
			".aux,*.out,*.toc" ..
			".o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class" ..
			".ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp" ..
			".avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg" ..
			".mp3,*.oga,*.ogg,*.wav,*.flac" ..
			".eot,*.otf,*.ttf,*.woff" ..
			".doc,*.pdf,*.cbr,*.cbz" ..
			".zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb" ..
			".swp,.lock,.DS_Store,._*" ..
			".,.." ..
			" */node_modules/* "
		)
	end
})

-- disable cursorcolumn for neo-tree and terminal
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	callback = function()
		if vim.bo.filetype == "neo-tree" or vim.bo.filetype == "toggleterm" then
			vim.opt_local.cursorcolumn = false
		end
	end,
})

-- disable cursorline for terminal
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		if vim.bo.filetype == "toggleterm" then
			vim.opt_local.cursorline = false
		end
	end,
})

-- osc 52 clipboard for ssh (works with kitty terminal)
vim.g.clipboard = {
	name = 'OSC 52',
	copy = {
		['+'] = require('vim.ui.clipboard.osc52').copy('+'),
		['*'] = require('vim.ui.clipboard.osc52').copy('*'),
	},
	paste = {
		['+'] = require('vim.ui.clipboard.osc52').paste('+'),
		['*'] = require('vim.ui.clipboard.osc52').paste('*'),
	},
}

-- reset cursor to terminal default when leaving nvim
vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		vim.cmd([[set guicursor=a:hor20]])
	end,
})
