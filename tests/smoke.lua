-- runs one check named by SMOKE_CHECK, with this repo as nvim's config dir

local PARSER_BUILD_TIMEOUT_MS = 10 * 60 * 1000
-- lets scheduled callbacks run before errors get read
-- HACK: a fixed guess since nvim has no api that waits until its event queue is empty
local SETTLE_MS = 200
-- conform reads these keys as fallbacks, they aren't filetypes
local NON_FILETYPE_FORMATTER_KEYS = { '_', '*' }
-- message kinds that nvim's ui-messages help lists as errors
local ERROR_KINDS = { 'emsg', 'echoerr', 'lua_error', 'rpc_error' }

local failures = 0

local function text_of(content)
  local chunks = {}
  for _, chunk in ipairs(content) do
    table.insert(chunks, chunk[2])
  end
  return table.concat(chunks)
end

local namespace = vim.api.nvim_create_namespace('smoke')

-- print would add these lines to message history
local function write(text)
  io.stdout:write(text .. '\n')
  io.stdout:flush()
end

local function fail(subject, details)
  failures = failures + 1
  write('FAIL ' .. subject)
  write(details)
end

local function sorted_keys(tbl)
  local keys = vim.tbl_keys(tbl)
  table.sort(keys)
  return keys
end

-- errors hidden by silent! never get into history
-- nvim treats an attached listener as a screen and stops at prompts, so it's attached only here
local function read_history()
  -- empty history sends no event
  local history = {}
  -- :messages sends history here with each entry's kind
  vim.ui_attach(namespace, { ext_messages = true }, function(event, entries)
    if event == 'msg_history_show' then
      history = vim.tbl_map(function(entry)
        return { kind = entry[1], text = text_of(entry[2]) }
      end, entries)
    end
  end)
  vim.cmd('messages')
  vim.ui_detach(namespace)
  return history
end

local function joined(entries)
  return table.concat(
    vim.tbl_map(function(entry)
      return entry.text
    end, entries),
    '\n'
  )
end

local function message_history()
  return joined(read_history())
end

local function shown_errors()
  local errors = vim.tbl_filter(function(entry)
    return vim.list_contains(ERROR_KINDS, entry.kind)
  end, read_history())
  if #errors > 0 then
    return joined(errors)
  end
  return nil
end

-- errors in plugin configs and autocmds don't reach pcall
-- nvim only shows them and adds them to message history
local function errors_from(action)
  vim.cmd('messages clear')

  local ok, err = pcall(action)
  vim.wait(SETTLE_MS)

  if not ok then
    return tostring(err)
  end
  return shown_errors()
end

local function set_filetype_on_new_buffer(filetype)
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_set_current_buf(buf)
  vim.bo[buf].filetype = filetype
  return buf
end

-- empty buffers never fire file events, so checks load plugins by name
local function load_plugins(names)
  require('lazy').load({ plugins = names })
end

-- lockfile lists every installed plugin by name, its path matches lua/plugins.lua
local function installed_plugin_names()
  local config_dir = vim.fn.stdpath('config')
  local lockfile = vim.env.LAZY_LOCKFILE or config_dir .. '/lua/plugins/lazy-lock.json'
  local lock = vim.json.decode(table.concat(vim.fn.readfile(lockfile), '\n'))
  return sorted_keys(lock)
end

-- startup and VimEnter errors are still in message history when checks run
local function check_startup()
  local errors = shown_errors()
  if errors then
    fail('startup', errors)
  end
end

local function restore()
  check_startup()

  local errors = errors_from(function()
    vim.cmd('Lazy! restore')
  end)
  if errors then
    fail('restoring plugins', errors)
  end

  -- config builds parsers in background, so restore waits for them before nvim quits
  errors = errors_from(function()
    local parsers = require('plugins.treeshitter').opts.parsers
    require('nvim-treesitter').install(parsers):wait(PARSER_BUILD_TIMEOUT_MS)
  end)
  if errors then
    fail('building parsers', errors)
  end
end

local function check_plugins()
  check_startup()

  local errors = errors_from(function()
    load_plugins(installed_plugin_names())
  end)
  if errors then
    fail('loading plugins', errors)
  end
end

local function missing_parsers(parsers)
  local built = require('nvim-treesitter').get_installed('parsers')
  return vim.tbl_filter(function(parser)
    return not vim.list_contains(built, parser)
  end, parsers)
end

local function check_parser(parser)
  local loaded, load_error = vim.treesitter.language.add(parser)
  if not loaded then
    fail('parser ' .. parser, load_error or 'parser not found')
    return
  end

  -- lua/plugins/treeshitter.lua starts highlighting on each of these filetypes
  for _, filetype in ipairs(vim.treesitter.language.get_filetypes(parser)) do
    local errors = errors_from(function()
      set_filetype_on_new_buffer(filetype)
    end)
    if errors then
      fail(('parser %s on filetype %s'):format(parser, filetype), errors)
    end
  end
end

local function check_parsers()
  local parsers = require('plugins.treeshitter').opts.parsers

  local missing = missing_parsers(parsers)
  if #missing > 0 then
    fail('parsers ' .. table.concat(missing, ', '), 'not built\n' .. message_history())
  end

  for _, parser in ipairs(parsers) do
    if not vim.list_contains(missing, parser) then
      check_parser(parser)
    end
  end
end

local function check_lsp()
  local errors = errors_from(function()
    load_plugins({ 'nvim-lspconfig' })
  end)
  if errors then
    fail('loading nvim-lspconfig', errors)
    return
  end

  local configs = vim.lsp.get_configs({ enabled = true })
  if #configs == 0 then
    fail('lsp servers', 'none enabled')
    return
  end

  for _, config in ipairs(configs) do
    if not config.cmd then
      fail('lsp server ' .. config.name, 'no cmd, nvim-lspconfig may not know this name')
    end

    -- a server without filetypes has no filetype of its own to set
    for _, filetype in ipairs(config.filetypes or {}) do
      errors = errors_from(function()
        set_filetype_on_new_buffer(filetype)
      end)
      if errors then
        fail(('lsp server %s on filetype %s'):format(config.name, filetype), errors)
      end
    end
  end
end

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
  local errors = errors_from(function()
    load_plugins({ 'conform.nvim' })
  end)
  if errors then
    fail('loading conform.nvim', errors)
    return
  end

  local formatters_by_ft = require('plugins.format').opts.formatters_by_ft
  for _, filetype in ipairs(sorted_keys(formatters_by_ft)) do
    local buf = vim.api.nvim_get_current_buf()
    if not vim.list_contains(NON_FILETYPE_FORMATTER_KEYS, filetype) then
      errors = errors_from(function()
        buf = set_filetype_on_new_buffer(filetype)
        require('conform').list_formatters_to_run(buf)
      end)
      if errors then
        fail('formatters on filetype ' .. filetype, errors)
      end
    end

    for _, name in ipairs(unknown_formatters(formatters_by_ft[filetype], buf)) do
      fail(
        ('formatter %s on filetype %s'):format(name, filetype),
        'conform has no formatter by this name'
      )
    end
  end
end

-- history with kinds comes from an api that nvim's help marks experimental
-- an error raised on purpose shows that errors still get reported
local function check_error_detection()
  local errors = errors_from(function()
    vim.schedule(function()
      error('raised on purpose to check error detection')
    end)
  end)
  if not errors then
    fail('error detection', 'an error raised on purpose never showed up as an error in history')
  end
end

local checks = {
  restore = restore,
  plugins = check_plugins,
  parsers = check_parsers,
  lsp = check_lsp,
  formatters = check_formatters,
}

local function run()
  local check = checks[vim.env.SMOKE_CHECK]
  if not check then
    fail('SMOKE_CHECK', 'must be one of ' .. table.concat(sorted_keys(checks), ', '))
    return
  end
  check()
  -- runs last, since it clears startup errors that check_startup reads
  check_error_detection()
end

local function run_and_exit()
  local ok, err = xpcall(run, debug.traceback)
  if not ok then
    fail('smoke test script', err)
  end

  if failures == 0 then
    write('smoke test passed')
    vim.cmd('qall!')
  else
    write('smoke test failed')
    -- cquit exits nvim with an error status
    vim.cmd('cquit')
  end
end

-- luafile runs before VimEnter, so checks wait for it to see errors from VimEnter handlers as well
-- nested lets FileType autocmds fire inside this callback
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  nested = true,
  callback = run_and_exit,
})
