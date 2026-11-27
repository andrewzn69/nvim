-- rewrites renovate's package name overrides in .renovaterc.jsonc from lazy-lock.json
-- reads paths relative to working dir, so script runs from repo root

local LOCKFILE = 'lua/plugins/lazy-lock.json'
local RENOVATE_CONFIG = '.renovaterc.jsonc'
local OVERRIDE_KEY = '"overridePackageName"'
-- location where lazy clones
local PLUGIN_DIR = vim.fn.stdpath('data') .. '/lazy'

local function plugin_names()
  local lock = vim.json.decode(table.concat(vim.fn.readfile(LOCKFILE), '\n'))
  local names = vim.tbl_keys(lock)
  table.sort(names)
  return names
end

local function clone_url(name)
  local git = { 'git', '-C', PLUGIN_DIR .. '/' .. name, 'remote', 'get-url', 'origin' }
  local result = vim.system(git, { text = true }):wait()
  if result.code ~= 0 then
    error(('%s has no clone: %s'):format(name, result.stderr))
  end
  return vim.trim(result.stdout)
end

local function github_repository(url)
  local without_suffix = url:gsub('%.git$', '')
  return without_suffix:match('^https://github%.com/(.+)$')
end

local function override(name)
  local url = clone_url(name)
  local repository = github_repository(url)
  local fields = { ('"matchDepNames": ["%s"]'):format(name) }
  if repository then
    table.insert(fields, ('"overridePackageName": "%s"'):format(repository))
  else
    -- plugins outside github get their commits from git-refs
    table.insert(fields, '"overrideDatasource": "git-refs"')
    table.insert(fields, ('"overridePackageName": "%s"'):format(url))
  end
  return '{ ' .. table.concat(fields, ', ') .. ' }'
end

-- overrides sit one per line in a single run, so nothing else gets replaced
local function overrides_block(lines)
  local first, last
  for i, line in ipairs(lines) do
    if line:find(OVERRIDE_KEY, 1, true) then
      first = first or i
      last = i
    end
  end
  assert(first, ('%s has no package name overrides'):format(RENOVATE_CONFIG))
  for i = first, last do
    if not lines[i]:find(OVERRIDE_KEY, 1, true) then
      error(('%s:%d sits between package name overrides'):format(RENOVATE_CONFIG, i))
    end
  end
  return first, last
end

local lines = vim.fn.readfile(RENOVATE_CONFIG)
local first, last = overrides_block(lines)
local indent = lines[first]:match('^%s*')
-- last override keeps its comma when another rule follows it
local last_comma = lines[last]:match(',%s*$') and ',' or ''

local names = plugin_names()
local overrides = {}
for i, name in ipairs(names) do
  local comma = i < #names and ',' or last_comma
  table.insert(overrides, indent .. override(name) .. comma)
end

local updated = vim.list_slice(lines, 1, first - 1)
vim.list_extend(updated, overrides)
vim.list_extend(updated, lines, last + 1)
vim.fn.writefile(updated, RENOVATE_CONFIG)
