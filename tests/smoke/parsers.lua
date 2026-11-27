local helpers = dofile(vim.fn.stdpath('config') .. '/tests/smoke/helpers.lua')

local function missing_parsers(parsers)
  local built = require('nvim-treesitter').get_installed('parsers')
  return vim.tbl_filter(function(parser)
    return not vim.list_contains(built, parser)
  end, parsers)
end

local function check_parser(parser)
  local loaded, load_error = vim.treesitter.language.add(parser)
  if not loaded then
    helpers.fail('parser ' .. parser, load_error or 'parser not found')
    return
  end

  -- lua/plugins/language/treeshitter.lua starts highlighting on each of these filetypes
  for _, filetype in ipairs(vim.treesitter.language.get_filetypes(parser)) do
    local errors = helpers.errors_from(function()
      helpers.set_filetype_on_new_buffer(filetype)
    end)
    if errors then
      helpers.fail(('parser %s on filetype %s'):format(parser, filetype), errors)
    end
  end
end

local function check_parsers()
  local parsers = require('plugins.language.treeshitter').opts.parsers

  local missing = missing_parsers(parsers)
  if #missing > 0 then
    helpers.fail(
      'parsers ' .. table.concat(missing, ', '),
      'not built\n' .. helpers.message_history()
    )
  end

  for _, parser in ipairs(parsers) do
    if not vim.list_contains(missing, parser) then
      check_parser(parser)
    end
  end
end

helpers.run(check_parsers)
