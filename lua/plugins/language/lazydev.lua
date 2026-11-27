return {
  'folke/lazydev.nvim',
  desc = 'configures LuaLS for Neovim config',
  ft = 'lua',
  opts = {
    library = {
      -- luvit types, loaded only in files that use them
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  },
}
