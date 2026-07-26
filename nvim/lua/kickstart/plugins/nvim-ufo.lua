return {
  'kevinhwang91/nvim-ufo',
  dependencies = { 'kevinhwang91/promise-async' },
  event = 'BufReadPost', -- lazy-load when a buffer is actually opened
  opts = {
    provider_selector = function(bufnr, filetype, buftype)
      return { 'treesitter', 'indent' }
    end,
  },
  init = function()
    vim.opt.foldcolumn = '1' -- '0' to disable, '1' to show fold column
    vim.opt.foldlevel = 99 -- ufo needs a high foldlevel
    vim.opt.foldlevelstart = 99
    vim.opt.foldenable = true

    -- Keymaps for opening/closing folds with peek preview
    vim.keymap.set('n', 'zR', function()
      require('ufo').openAllFolds()
    end, { desc = 'Open all folds' })

    vim.keymap.set('n', 'zM', function()
      require('ufo').closeAllFolds()
    end, { desc = 'Close all folds' })

    vim.keymap.set('n', 'zK', function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, { desc = 'Peek fold or hover' })
  end,
}
