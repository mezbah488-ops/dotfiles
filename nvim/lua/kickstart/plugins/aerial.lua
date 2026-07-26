return {
  {
    'stevearc/aerial.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    opts = {
      backends = { 'lsp', 'treesitter', 'markdown' },
      filter_kind = {
        'Module',
        'Namespace',
        'Package',
        'Class',
        'Method',
        'Function',
      },
    },
    keys = {
      {
        '<leader>a',
        function()
          require('aerial').toggle()
          if require('aerial').is_open() then
            require('aerial').focus()
          end
        end,
        desc = 'Aerial Outline Toggle & Focus',
      },
    },
  },
}
