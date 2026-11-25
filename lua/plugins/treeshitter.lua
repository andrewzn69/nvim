return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  build = ':TSUpdate',
  config = function()
    local treesitter = require('nvim-treesitter')

    treesitter.install({
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
    })

    vim.treesitter.language.register('gotmpl', { 'gohtmltmpl', 'gotexttmpl' })

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
