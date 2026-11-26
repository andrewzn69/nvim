local helpers = dofile(vim.fn.stdpath('config') .. '/tests/smoke/helpers.lua')

local function check_lsp()
  local errors = helpers.errors_from(function()
    helpers.load_plugins({ 'nvim-lspconfig' })
  end)
  if errors then
    helpers.fail('loading nvim-lspconfig', errors)
    return
  end

  local configs = vim.lsp.get_configs({ enabled = true })
  if #configs == 0 then
    helpers.fail('lsp servers', 'none enabled')
    return
  end

  for _, config in ipairs(configs) do
    if not config.cmd then
      helpers.fail('lsp server ' .. config.name, 'no cmd, nvim-lspconfig may not know this name')
    end

    -- a server without filetypes has no filetype of its own to set
    for _, filetype in ipairs(config.filetypes or {}) do
      errors = helpers.errors_from(function()
        helpers.set_filetype_on_new_buffer(filetype)
      end)
      if errors then
        helpers.fail(('lsp server %s on filetype %s'):format(config.name, filetype), errors)
      end
    end
  end
end

helpers.run(check_lsp)
