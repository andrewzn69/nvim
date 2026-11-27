-- fails when lazy-lock.json and renovate's overridePackageName rules don't list same plugins
-- reads paths relative to working dir, so check runs from repo root

local LOCKFILE = 'lua/plugins/lazy-lock.json'
local RENOVATE_CONFIG = '.renovaterc.jsonc'

-- print leaves last line without newline when cquit exits nvim
local function write(text)
  io.stdout:write(text .. '\n')
  io.stdout:flush()
end

local function read_file(path)
  return table.concat(vim.fn.readfile(path), '\n')
end

local function locked_plugins()
  return vim.tbl_keys(vim.json.decode(read_file(LOCKFILE)))
end

-- other package rules also match deps by name, so only overrides count
local function overridden_plugins()
  local config = vim.json.decode(read_file(RENOVATE_CONFIG), { skip_comments = true })
  local plugins = {}
  for _, rule in ipairs(config.packageRules) do
    if rule.overridePackageName then
      vim.list_extend(plugins, rule.matchDepNames)
    end
  end
  return plugins
end

local function missing_from(plugins, listed)
  local missing = vim.tbl_filter(function(plugin)
    return not vim.list_contains(listed, plugin)
  end, plugins)
  table.sort(missing)
  return missing
end

local function print_missing(plugins, file)
  for _, plugin in ipairs(plugins) do
    write(('%s is missing from %s'):format(plugin, file))
  end
end

local locked = locked_plugins()
local overridden = overridden_plugins()
local without_override = missing_from(locked, overridden)
local without_plugin = missing_from(overridden, locked)

print_missing(without_override, RENOVATE_CONFIG)
print_missing(without_plugin, LOCKFILE)

if #without_override > 0 or #without_plugin > 0 then
  vim.cmd.cquit()
end
write(('%s and %s list same plugins'):format(LOCKFILE, RENOVATE_CONFIG))
