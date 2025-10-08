local keymap = vim.keymap

-- space as leader key
vim.g.mapleader = " "

keymap.set('n', 'x', '"_x', { desc = 'Delete character without yanking' })
keymap.set('x', 'p', 'P', { noremap = true, silent = true, desc = 'Disable clipboard overwrite on paste' })

-- Increment/decrement
keymap.set('n', '+', '<C-a>', { desc = 'Increment number' })
keymap.set('n', '-', '<C-x>', { desc = 'Decrement number' })

-- Delete a word backwards
keymap.set('n', 'dw', 'vb"_d', { desc = 'Delete word backwards without yanking' })
-- Delete a word backwards in insert mode
vim.keymap.set('i', '<C-H>', '<C-W>', { noremap = true, silent = true })

-- Select all
keymap.set('n', '<C-a>', 'gg<S-v>G', { desc = 'Select all content' })

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- New tab
keymap.set('n', 'te', ':tabedit', { desc = 'Open a new tab' })

-- Window navigation using <Space> + w + h/j/k/l
vim.keymap.set('n', '<Leader>wh', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<Leader>wj', '<C-w>j', { desc = 'Move to window below' })
vim.keymap.set('n', '<Leader>wk', '<C-w>k', { desc = 'Move to window above' })
vim.keymap.set('n', '<Leader>wl', '<C-w>l', { desc = 'Move to right window' })

-- Split window
keymap.set('n', 'ss', ':split<Return><C-w>w', { desc = 'Split window horizontally' })
keymap.set('n', 'sv', ':vsplit<Return><C-w>w', { desc = 'Split window vertically' })

-- Move window
keymap.set('n', '<Space>', '<C-w>w', { desc = 'Cycle through windows' })
keymap.set('', 'sh', '<C-w>h', { desc = 'Move to left window' })
keymap.set('', 'sk', '<C-w>k', { desc = 'Move to window above' })
keymap.set('', 'sj', '<C-w>j', { desc = 'Move to window below' })
keymap.set('', 'sl', '<C-w>l', { desc = 'Move to right window' })

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

-- keymap.set('i', '<C-Backspace>', '<C-w>', { desc = 'Delete previous word' })

-- if vim.env.term == "xterm-kitty" then then then then
-- 	keymap.set("i", "<C-BS>", "<C-W>")
--
--
--
-- fklsdjf lksdjlkf jlksdjflksdjlk
-- end
