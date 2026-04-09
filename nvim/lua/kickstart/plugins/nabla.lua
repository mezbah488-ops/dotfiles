return {
  'jbyuki/nabla.nvim',
  ft = { 'tex', 'latex', 'markdown' },
  keys = {
    {
      '<leader>p',
      function()
        require('nabla').toggle_virt()
      end,
      desc = 'Toggle math preview',
    },
    {
      '<leader>p',
      function()
        require('nabla').popup()
      end,
      desc = 'Math popup preview',
    },
  },
}
