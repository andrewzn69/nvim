return {
  'kylechui/nvim-surround',
  desc = 'adds, changes and deletes surrounding pairs',
  version = '*',
  event = 'VeryLazy',
  config = function()
    require('nvim-surround').setup({})
  end,
}
