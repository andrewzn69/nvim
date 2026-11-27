return {
  'f-person/git-blame.nvim',
  desc = 'Git blame as virtual text',
  config = function()
    local git_blame = require('gitblame')
    git_blame.setup({
      enable = true,
    })
  end,
}
