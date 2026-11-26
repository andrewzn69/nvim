-- shared by each smoke check, which runs with this repo as nvim's config dir

-- lets scheduled callbacks run before errors get read
-- HACK: a fixed guess since nvim has no api that waits until its event queue is empty
local SETTLE_MS = 200
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

-- startup and VimEnter errors are still in message history when checks run
local function check_startup()
  local errors = shown_errors()
  if errors then
    fail('startup', errors)
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

local function run_and_exit(check)
  local ok, err = xpcall(function()
    check()
    -- runs last, since it clears startup errors that check_startup reads
    check_error_detection()
  end, debug.traceback)
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
local function run(check)
  vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    nested = true,
    callback = function()
      run_and_exit(check)
    end,
  })
end

return {
  fail = fail,
  sorted_keys = sorted_keys,
  message_history = message_history,
  errors_from = errors_from,
  set_filetype_on_new_buffer = set_filetype_on_new_buffer,
  load_plugins = load_plugins,
  check_startup = check_startup,
  run = run,
}
