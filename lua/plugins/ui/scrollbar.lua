return {
  'petertriho/nvim-scrollbar',
  desc = 'floating scrollbar in each window',
  event = 'VeryLazy',
  config = function()
    local scrollbar = require('scrollbar')
    scrollbar.setup({
      marks = {
        Cursor = { text = ' ' },
      },
      scrollbar = {
        visibility = 'active',
        thumb = {
          blend = 0,
          text = ' ',
        },
      },
    })
  end,
}
