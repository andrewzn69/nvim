return {
  'brenoprata10/nvim-highlight-colors',
  desc = 'shows color codes in their color',
  event = 'VeryLazy',
  config = function()
    local r = require('utils.remaps')
    local c = require('nvim-highlight-colors')
    c.setup({})
    r.noremap('n', '<leader>c', function()
      c.toggle()
    end, 'toggle colorizer')
    r.map_virtual({ '<leader>c', group = 'colorizer', icon = { icon = '󰌁', hl = 'Constant' } })
  end,
}
