return {
  'wakatime/vim-wakatime',
  desc = 'coding time tracking with WakaTime',
  event = 'VeryLazy',
  cond = function()
    return vim.fn.executable('wakatime') == 1
  end,
}
