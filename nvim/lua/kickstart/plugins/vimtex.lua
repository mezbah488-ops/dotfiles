return {
  'lervag/vimtex',
  ft = 'tex',
  lazy = false,
  init = function()
    vim.g.vimtex_mappings_enabled = 1
    vim.g.vimtex_view_method = 'zathura'
    vim.g.vimtex_fold_enabled = 1
    vim.g.vimtex_compiler_enabled = 0 -- disable vimtex's own latexmk process; compile manually instead
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'tex',
      callback = function()
        vim.keymap.set({ 'n', 'x' }, '<leader>ce', '<plug>(vimtex-env-change)', { buffer = true })
        vim.keymap.set({ 'n', 'x' }, '<leader>cn', '<plug>(vimtex-cmd-create)', { buffer = true })
        vim.keymap.set('n', '<leader>cd', '<plug>(vimtex-env-delete)', { buffer = true }) -- delete surrounding environment
      end,
    })
  end,
}
