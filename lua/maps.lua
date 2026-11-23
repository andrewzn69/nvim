local keymap = vim.keymap

-- space as leader key
vim.g.mapleader = " "

-- Window navigation using <Space> + w + h/j/k/l
vim.keymap.set('n', '<Leader>wh', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<Leader>wj', '<C-w>j', { desc = 'Move to window below' })
vim.keymap.set('n', '<Leader>wk', '<C-w>k', { desc = 'Move to window above' })
vim.keymap.set('n', '<Leader>wl', '<C-w>l', { desc = 'Move to right window' })

-- Resize window
keymap.set('n', '<A-h>', '<C-w>>')
keymap.set('n', '<A-j>', '<C-w>-')
keymap.set('n', '<A-k>', '<C-w>+')
keymap.set('n', '<A-l>', '<C-w><')

-- Grammar check
keymap.set('n', '<F6>', ':setlocal spell! spelllang=en_us<CR>')

-- Toggle Neo-tree
keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle Neo-tree' })

-- Exit terminal mode with <Esc>
keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
