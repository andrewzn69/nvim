return {
  'nvim-treesitter/nvim-treesitter',
  desc = 'Tree-sitter parsers and queries',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  build = ':TSUpdate',
  opts = {
    parsers = {
      'astro',
      'bash',
      'css',
      'c_sharp',
      'dockerfile',
      'elixir',
      'go',
      'gotmpl',
      'graphql',
      'gitcommit',
      'gitignore',
      'git_config',
      'git_rebase',
      'hcl',
      'helm',
      'html',
      'javascript',
      'json',
      'lua',
      'markdown',
      'markdown_inline',
      'nix',
      'php',
      'prisma',
      'python',
      'rasi',
      'regex',
      'ruby',
      'rust',
      'scss',
      'sql',
      'terraform',
      'tsx',
      'typescript',
      'vim',
      'vue',
      'yaml',
      'yuck',
    },
  },
  config = function(_, opts)
    local treesitter = require('nvim-treesitter')

    treesitter.install(opts.parsers)

    local parser_by_filetype = {}
    for _, parser in ipairs(opts.parsers) do
      for _, filetype in ipairs(vim.treesitter.language.get_filetypes(parser)) do
        parser_by_filetype[filetype] = parser
      end
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter_highlight', { clear = true }),
      pattern = vim.tbl_keys(parser_by_filetype),
      callback = function(ev)
        local parser = parser_by_filetype[vim.bo[ev.buf].filetype]

        if vim.treesitter.language.add(parser) then
          vim.treesitter.start(ev.buf, parser)
        end
      end,
    })

    local r = require('utils.remaps')
    r.noremap('n', '<leader>dp', function()
      vim.treesitter.inspect_tree({ command = 'botright 60vnew' })
    end, 'treesitter playground')

    r.noremap('n', '<C-e>', function()
      local result = vim.treesitter.get_captures_at_cursor(0)
      print(vim.inspect(result))
    end, 'show treesitter capture group')

    r.noremap('n', '<leader>rp', function()
      require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
    end, 'swap parameter to next')

    r.noremap('n', '<leader>rP', function()
      require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.inner')
    end, 'swap parameter to previous')
  end,
}
