local helpers = dofile(vim.fn.stdpath('config') .. '/tests/smoke/helpers.lua')

-- conform reads these keys as fallbacks, they aren't filetypes
local NON_FILETYPE_FORMATTER_KEYS = { '_', '*' }

-- list_formatters_to_run leaves out formatters that conform doesn't know, without an error
local function unknown_formatters(names, buf)
  local unknown = {}
  for _, name in ipairs(names) do
    if require('conform').get_formatter_info(name, buf).error then
      table.insert(unknown, name)
    end
  end
  return unknown
end

local function check_formatters()
  local errors = helpers.errors_from(function()
    helpers.load_plugins({ 'conform.nvim' })
  end)
  if errors then
    helpers.fail('loading conform.nvim', errors)
    return
  end

  local formatters_by_ft = require('plugins.format').opts.formatters_by_ft
  for _, filetype in ipairs(helpers.sorted_keys(formatters_by_ft)) do
    local buf = vim.api.nvim_get_current_buf()
    if not vim.list_contains(NON_FILETYPE_FORMATTER_KEYS, filetype) then
      errors = helpers.errors_from(function()
        buf = helpers.set_filetype_on_new_buffer(filetype)
        require('conform').list_formatters_to_run(buf)
      end)
      if errors then
        helpers.fail('formatters on filetype ' .. filetype, errors)
      end
    end

    for _, name in ipairs(unknown_formatters(formatters_by_ft[filetype], buf)) do
      helpers.fail(
        ('formatter %s on filetype %s'):format(name, filetype),
        'conform has no formatter by this name'
      )
    end
  end
end

helpers.run(check_formatters)
