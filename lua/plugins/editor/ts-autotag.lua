return {
  'windwp/nvim-ts-autotag',
  desc = 'closes and renames HTML tags',
  event = {
    'InsertEnter *.tsx,*.jsx,*.html,*.vue,*.svelte,*.astro',
  },
  config = function()
    local autotag = require('nvim-ts-autotag')
    autotag.setup()
  end,
}
