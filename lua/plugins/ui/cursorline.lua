return {
  'yamatsum/nvim-cursorline',
  desc = 'underlines word under cursor',
  config = function()
    local nvim_cursorline = require('nvim-cursorline')
    nvim_cursorline.setup({
      cursorline = {
        enable = false,
      },
      cursorword = {
        enable = true,
        min_length = 3,
        hl = { underline = true },
      },
    })
  end,
}
