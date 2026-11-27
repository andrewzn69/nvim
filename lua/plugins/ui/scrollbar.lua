return {
  'petertriho/nvim-scrollbar',
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
