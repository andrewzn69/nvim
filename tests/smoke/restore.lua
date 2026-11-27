local helpers = dofile(vim.fn.stdpath('config') .. '/tests/smoke/helpers.lua')

local PARSER_BUILD_TIMEOUT_MS = 10 * 60 * 1000

local function restore()
  helpers.check_startup()

  local errors = helpers.errors_from(function()
    vim.cmd('Lazy! restore')
  end)
  if errors then
    helpers.fail('restoring plugins', errors)
  end

  -- config builds parsers in background, so restore waits for them before nvim quits
  errors = helpers.errors_from(function()
    local parsers = require('plugins.language.treeshitter').opts.parsers
    require('nvim-treesitter').install(parsers):wait(PARSER_BUILD_TIMEOUT_MS)
  end)
  if errors then
    helpers.fail('building parsers', errors)
  end
end

helpers.run(restore)
