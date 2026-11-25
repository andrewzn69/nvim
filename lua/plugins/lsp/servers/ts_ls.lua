local VUE_PACKAGE = '@vue/language-server'

-- covers packages that keep it inside a monorepo
local SEARCH_DEPTH = 4

local function read_package_name(dir)
  local file = io.open(vim.fs.joinpath(dir, 'package.json'))
  if not file then
    return nil
  end

  local ok, manifest = pcall(vim.json.decode, file:read('*a'))
  file:close()

  if not ok then
    return nil
  end

  return manifest.name
end

local function is_vue_package(dir)
  return read_package_name(dir) == VUE_PACKAGE
end

-- binary sits in bin dir of package it came with
local function find_install_dir()
  local binary = vim.fn.exepath('vue-language-server')
  if binary == '' then
    return nil
  end

  local bin_dir = vim.fs.dirname(vim.uv.fs_realpath(binary))

  return vim.fs.dirname(bin_dir)
end

-- npm installs have it at top, other installs nest it deeper
local function find_vue_package_dir(install_dir)
  if is_vue_package(install_dir) then
    return install_dir
  end

  for name, kind in vim.fs.dir(install_dir, { depth = SEARCH_DEPTH }) do
    local dir = vim.fs.joinpath(install_dir, name)

    if kind == 'directory' and is_vue_package(dir) then
      return dir
    end
  end

  return nil
end

local install_dir = find_install_dir()
local vue_package_dir = install_dir and find_vue_package_dir(install_dir)

-- without vue package ts_ls runs on lspconfig defaults
if not vue_package_dir then
  return {}
end

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_package_dir,
  languages = { 'vue' },
  configNamespace = 'typescript',
}

return {
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
  init_options = {
    plugins = { vue_plugin },
  },
}
