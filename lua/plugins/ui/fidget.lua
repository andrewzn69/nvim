return {
  'j-hui/fidget.nvim',
  desc = 'LSP progress messages',
  event = 'LspAttach',
  opts = {
    notification = {
      window = {
        border = 'none',
        winblend = 0,
      },
    },
  },
}
