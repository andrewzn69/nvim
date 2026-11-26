return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'b0o/schemastore.nvim',
    'ravibrock/spellwarn.nvim',
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('lsp_lines').setup()
    require('spellwarn').setup({})

    local remaps = require('plugins.lsp.remaps')
    local icons = require('utils.icons')

    local presentCmpNvimLsp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')

    vim.lsp.log.set_level('error')

    local function on_attach(client, bufnr)
      remaps.set_default_on_buffer(client, bufnr)
    end

    -- Configure diagnostics
    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = false,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
          [vim.diagnostic.severity.WARN] = icons.diagnostics.warning,
          [vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
          [vim.diagnostic.severity.INFO] = icons.diagnostics.information,
        },
      },
      update_in_insert = true,
      underline = true,
      severity_sort = true,
      float = {
        focus = false,
        focusable = false,
        style = 'minimal',
        border = 'shadow',
        source = 'always',
        header = '',
        prefix = '',
      },
    })

    vim.lsp.config('*', {
      handlers = {
        ['textDocument/signatureHelp'] = function(err, result, ctx, config)
          return vim.lsp.handlers.hover(
            err,
            result,
            ctx,
            vim.tbl_extend('force', config or {}, { border = 'shadow' })
          )
        end,
        ['textDocument/hover'] = function(err, result, ctx, config)
          return vim.lsp.handlers.hover(
            err,
            result,
            ctx,
            vim.tbl_extend('force', config or {}, { border = 'shadow' })
          )
        end,
      },
    })

    local capabilities
    if presentCmpNvimLsp then
      capabilities = cmp_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
    else
      capabilities = vim.lsp.protocol.make_client_capabilities()
    end

    local servers = {
      astro = {},
      bashls = require('plugins.lsp.servers.bashls')(on_attach),
      biome = require('plugins.lsp.servers.biome')(on_attach),
      clangd = {},
      cssls = require('plugins.lsp.servers.cssls')(on_attach),
      dockerls = {},
      elixirls = {},
      gopls = {},
      html = {},
      hyprls = {},
      intelephense = require('plugins.lsp.servers.phpls')(on_attach),
      jinja_lsp = {},
      jsonls = require('plugins.lsp.servers.jsonls'),
      lua_ls = require('plugins.lsp.servers.lua_ls')(on_attach),
      marksman = {},
      prismals = {},
      pyright = {},
      rust_analyzer = {},
      stylua = {},
      tailwindcss = {},
      terraformls = require('plugins.lsp.servers.terraformls')(on_attach),
      texlab = require('plugins.lsp.servers.texlab')(on_attach),
      tflint = {},
      tinymist = require('plugins.lsp.servers.tinymist')(on_attach),
      vue_ls = {},
      yamlls = {},
      nixd = {},
      ts_ls = require('plugins.lsp.servers.ts_ls'),
      helm_ls = {},
    }

    local default_lsp_config = {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 200,
        allow_incremental_sync = true,
      },
    }

    for server, config in pairs(servers) do
      local merged_config = vim.tbl_deep_extend('force', default_lsp_config, config or {})

      vim.lsp.config(server, merged_config)
    end

    -- Enable all configured LSP servers
    local server_names = vim.tbl_keys(servers)
    vim.lsp.enable(server_names)
  end,
}
