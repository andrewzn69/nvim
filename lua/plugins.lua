-- lazy

local pluginspath = vim.fn.stdpath('data') .. '/lazy'
local lazypath = pluginspath .. '/lazy.nvim'

-- install lazy
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end

vim.opt.runtimepath:prepend(lazypath)

-- use protected call so we don't error out on firt use
local status_ok, lazy = pcall(require, 'lazy')
if not status_ok then
  print('lazy has been installed, restart nvim')
  return
end

-- install plugins
lazy.setup({
  spec = {
    { import = 'plugins.editor' },
    { import = 'plugins.git' },
    { import = 'plugins.language' },
    { import = 'plugins.navigation' },
    { import = 'plugins.tools' },
    { import = 'plugins.ui' },
  },
  dev = {
    path = '~/.local/src',
  },
  -- restore hook in hm-module.nix passes a writable copy, store copy is read only
  lockfile = vim.env.LAZY_LOCKFILE or vim.fn.stdpath('config') .. '/lua/plugins/lazy-lock.json',
  ui = {},
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
