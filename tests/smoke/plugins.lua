local helpers = dofile(vim.fn.stdpath('config') .. '/tests/smoke/helpers.lua')

-- lockfile lists every installed plugin by name, its path matches lua/plugins.lua
local function installed_plugin_names()
  local config_dir = vim.fn.stdpath('config')
  local lockfile = vim.env.LAZY_LOCKFILE or config_dir .. '/lua/plugins/lazy-lock.json'
  local lock = vim.json.decode(table.concat(vim.fn.readfile(lockfile), '\n'))
  return helpers.sorted_keys(lock)
end

local function check_plugins()
  helpers.check_startup()

  local errors = helpers.errors_from(function()
    helpers.load_plugins(installed_plugin_names())
  end)
  if errors then
    helpers.fail('loading plugins', errors)
  end
end

helpers.run(check_plugins)
